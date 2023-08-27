import 'package:flutter/material.dart';
import 'expenses_list.dart'; // Import your ExpensesListPage
import 'expense.dart'; // Import your Expense model

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a list of expenses
    List<Expense> expenses = [
      Expense(title: 'Groceries', amount: 50.0, date: DateTime(2023, 8, 15)),
      Expense(title: 'Rent', amount: 1000.0, date: DateTime(2023, 8, 1)),
      // Add more expenses here
    ];

    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpensesListPage(expenses), // Pass the list of expenses
    );
  }
}
