// TODO: Save the newExpense using an appropriate method
// For example, you could have a list of expenses in your main_bloc.dart or a separate ExpensesProvider
// You can add the newExpense to the list and then notify listeners to update the UI
// Or you could use a service class to handle data management (e.g., FirebaseService)
// For now, let's assume you have a list of expenses in your main_bloc.dart:

import 'package:flutter/material.dart';
import 'expense.dart';
import 'main_bloc.dart'; // Import your main bloc or provider

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late DateTime _selectedDate = DateTime.now();
  final Expense? editedExpense;

  _AddExpensePageState({this.editedExpense});

  @override
  void initState() {
    super.initState();
    _title = editedExpense?.title ??
        ''; // Initialize to the provided value or an empty string
    _amount =
        editedExpense?.amount ?? 0.0; // Initialize to the provided value or 0.0
    _selectedDate = editedExpense?.date ??
        DateTime.now(); // Initialize to the provided value or current date
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newExpense = Expense(
        title: _title,
        amount: _amount,
        date: _selectedDate,
      );

      mainBloc.addExpense(newExpense);

      Navigator.pop(context); // Return to the Expenses List page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  });
                },
                child: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate.toString()}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
