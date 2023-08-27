import 'package:flutter/material.dart';
import 'expenses_list_page.dart';
import 'expense.dart'; // Import your Expense model
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyCREtpR7qF5l43IZQ8iB4O-mM47AU3tCx4",
    projectId: "taksquiz",
    messagingSenderId: "1086277915400",
    appId: "1:1086277915400:web:6f2919bda39331dc1412bd",
  )); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Create a list of expenses

    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpensesListPage(expenses: expenses), // Pass the list of expenses
    );
  }
}
