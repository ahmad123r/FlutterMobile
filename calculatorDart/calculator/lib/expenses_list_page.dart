import 'package:calculator/edit_expense_page.dart';
import 'package:flutter/material.dart';
import 'expense.dart';
import 'expense_item.dart';
import 'add_expense_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import Firestore

class ExpensesListPage extends StatefulWidget {
  final List<Expense> expenses;

  ExpensesListPage({required this.expenses});

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  List<Expense> _filteredExpenses = [];
  late List<Expense> _expenses = [];

  void _deleteExpense(int index) async {
    // Get the expense that needs to be deleted

    Expense expenseToDelete = _filteredExpenses[index];

    // Get a reference to the Firestore collection
    CollectionReference expensesCollection =
        FirebaseFirestore.instance.collection('expenses');

    // Query for the expense document to be deleted
    QuerySnapshot snapshot = await expensesCollection
        .where('title', isEqualTo: expenseToDelete.title)
        .get();

    // Delete the document
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }

  void _filterExpenses(String query) {
    setState(() {
      _filteredExpenses = widget.expenses
          .where((expense) =>
              expense.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _editExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpensePage(editedExpense: expense),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchExpenses(); // Fetch expenses when the widget initializes
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
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return ExpenseItem(
                  expense: _expenses[index],
                  onDelete: () => _deleteExpense(index),
                  onEdit: () => _editExpense(_expenses[index]),
                );
              },
            ),
          ),
        ],
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
