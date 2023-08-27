import 'package:flutter/material.dart';
import 'expenses_list_page.dart';

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpensesListPage(
        expenses: [], // Initialize with your list of expenses
      ),
    );
  }
}
