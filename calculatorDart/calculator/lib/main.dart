import 'package:flutter/material.dart';
import 'expenses_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpensesListPage(expenses: []), // Pass your list of expenses here
    );
  }
}
