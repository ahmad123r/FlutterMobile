import 'package:flutter/material.dart';
import 'expense.dart';
import 'expense_item.dart';
import 'add_expense.dart';

class ExpensesListPage extends StatefulWidget {
  final List<Expense> expenses;

  ExpensesListPage(this.expenses);

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  List<Expense> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _filteredExpenses = widget.expenses;
  }

  void _deleteExpense(int index) {
    setState(() {
      widget.expenses.removeAt(index);
      _filteredExpenses = widget.expenses; // Update filtered list
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
        builder: (context) => AddExpensePage(editedExpense: expense),
      ),
    );
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
              itemCount: _filteredExpenses.length,
              itemBuilder: (context, index) {
                return ExpenseItem(
                  expense: _filteredExpenses[index],
                  onDelete: () => _deleteExpense(index),
                  onEdit: () => _editExpense(_filteredExpenses[index]),
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

class AddExpensePage extends StatefulWidget {
  final Expense? editedExpense;

  AddExpensePage({this.editedExpense});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _title = widget.editedExpense?.title ?? '';
    _amount = widget.editedExpense?.amount ?? 0.0;
    _selectedDate = widget.editedExpense?.date ?? DateTime.now();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newExpense = Expense(
        title: _title,
        amount: _amount,
        date: _selectedDate,
      );

      if (widget.editedExpense != null) {
        // Handle editing of expense (if provided)
        // You might want to update the existing expense in the list or database
        // This could involve replacing the old expense with the new values
      } else {
        // Handle adding a new expense
        // Add the newExpense to your list or database
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.editedExpense != null ? 'Edit Expense' : 'Add Expense'),
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
