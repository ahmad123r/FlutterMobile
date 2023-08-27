import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'expense.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditExpensePage extends StatefulWidget {
  final Expense? editedExpense;

  EditExpensePage({this.editedExpense});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<EditExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title = widget.editedExpense!.title.toString();
  late double _amount = widget.editedExpense!.amount;
  late DateTime _selectedDate = widget.editedExpense!.date;

  @override
  void initState() {
    super.initState();
    _title = widget.editedExpense?.title ?? '';
    _amount = widget.editedExpense?.amount ?? 0.0;
    _selectedDate = widget.editedExpense?.date ?? DateTime.now();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      expenses.remove(widget.editedExpense);
      final newExpense = Expense(
        title: _title,
        amount: _amount,
        date: _selectedDate,
      );
      // Get a reference to the Firestore collection
      CollectionReference expensesCollection =
          FirebaseFirestore.instance.collection('expenses');

      // Add the newExpense to the Firestore collection
      await expensesCollection.add({
        'title': newExpense.title,
        'amount': newExpense.amount,
        'date': newExpense.date,
      });

      Navigator.pop(context, newExpense);
      // Pass the newExpense back to the previous screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      expenses.add(newExpense);

      print(newExpense.amount);
      print(newExpense.date);
      print(newExpense.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editedExpense != null ? 'Edit Expense' : 'Add Expense>>'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _title,
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
                initialValue: _amount.toString(),
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
                    initialDate: _selectedDate,
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
                child: Text('Date: ${_selectedDate.toString()}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.editedExpense != null
                    ? 'Save Changes'
                    : 'Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
