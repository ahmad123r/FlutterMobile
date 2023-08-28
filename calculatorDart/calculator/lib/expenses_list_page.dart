import 'dart:html';

import 'package:calculator/edit_expense_page.dart';
import 'package:flutter/material.dart';
import 'expense.dart';
import 'expense_item.dart';
import 'add_expense_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chartwid.dart';
// Import Firestore

class ExpensesListPage extends StatefulWidget {
  final List<Expense> expenses;

  ExpensesListPage({required this.expenses});

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>> _expensesStream =
      FirebaseFirestore.instance.collection('expenses').snapshots();

  @override
  void initState() {
    super.initState();
    _expensesStream =
        FirebaseFirestore.instance.collection('expenses').snapshots();
  }

  Widget _buildExpensesList(QuerySnapshot snapshot) {
    List<Expense> fetchedExpenses = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Expense(
        title: data['title'],
        amount: data['amount'],
        date: data['date'].toDate(),
      );
    }).toList();

    return ListView.builder(
      itemCount: fetchedExpenses.length,
      itemBuilder: (context, index) {
        return ExpenseItem(
          expense: fetchedExpenses[index],
          onDelete: () => _deleteExpense(fetchedExpenses[index].title),
          onEdit: () => (),
        );
      },
    );
  }

  void _filterExpenses(String query) {
    setState(() {
      if (query.isEmpty) {
        _expensesStream =
            FirebaseFirestore.instance.collection('expenses').snapshots();
      } else {
        _expensesStream = FirebaseFirestore.instance
            .collection('expenses')
            .where('title', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('title', isLessThan: query.toLowerCase() + 'z')
            .snapshots();
      }
    });
  }

  List<Expense> _filteredExpenses = [];
  late List<Expense> _expenses = [];
  void _deleteExpense(String documentTitle) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('title', isEqualTo: documentTitle)
          .get();

      if (querySnapshot.size > 0) {
        final documentId = querySnapshot.docs[0].id;

        await Future.microtask(() {
          setState(() {
            FirebaseFirestore.instance
                .collection('expenses')
                .doc(documentId)
                .delete();
          });
        });
        _fetchExpenses();
        print('Document deleted successfully');
      } else {
        print('Document not found');
      }
    } catch (error) {
      print('Error deleting document: $error');
    }
  }

  Future<void> _fetchExpenses() async {
    // Fetch expenses from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('expenses').get();

    // Convert fetched data to Expense objects
    List<Expense> fetchedExpenses = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Expense(
        title: data['title'],
        amount: data['amount'],
        date: data['date'].toDate(),
      );
    }).toList();

    setState(() {
      _expenses = fetchedExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterExpenses,
              decoration: InputDecoration(
                labelText: 'Search expenses by title',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _expensesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildExpensesList(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('Error loading expenses');
                } else {
                  return CircularProgressIndicator(); // Show a loading indicator
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Text("Mange"),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chart()));
              },
              child: Text("Analysis"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpensePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
