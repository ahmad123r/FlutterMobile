import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<double> monthsExp = List.generate(12, (index) => 0.0);
  final List<String> monthsString = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.brown,
    Colors.deepOrange,
  ];
  double totalExpense = 0.0;
  double averageExpense = 0.0;
  double minExpense = double.infinity;
  double maxExpense = 0.0;

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
  }

  Future<void> fetchExpenseData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

    List<double> fetchedMonthsExp = List.generate(12, (index) => 0.0);

    double total = 0.0;

    querySnapshot.docs.forEach((doc) {
      DateTime expenseDate = doc['date'].toDate();
      double expenseAmount = doc['amount'];

      int monthIndex = expenseDate.month - 1;

      fetchedMonthsExp[monthIndex] += expenseAmount;

      total += expenseAmount;

      if (expenseAmount < minExpense) {
        minExpense = expenseAmount;
      }

      if (expenseAmount > maxExpense) {
        maxExpense = expenseAmount;
      }
    });

    totalExpense = total;
    averageExpense = total / querySnapshot.docs.length;

    setState(() {
      monthsExp = fetchedMonthsExp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Analysis"),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Text("Manage"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chart()));
              },
              child: Text("Analysis"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Chart
            Text(
              'Monthly Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: monthsExp.asMap().entries.map((entry) {
                final index = entry.key;
                final element = entry.value * 0.01;

                return Column(
                  children: [
                    Container(
                      width: 30,
                      height: element * 20,
                      color: colors[index],
                    ),
                    SizedBox(height: 5),
                    Text(
                      monthsString[index],
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                );
              }).toList(),
            ),

            // Line separator
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 2,
              color: Colors.grey.withOpacity(0.5),
            ),

            // Summary Statistics
            Text(
              'Summary Statistics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatSquare("Total", totalExpense),
                _buildStatSquare("Average", averageExpense),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatSquare("Min", minExpense),
                _buildStatSquare("Max", maxExpense),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSquare(String label, double value) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            '\$$value',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
