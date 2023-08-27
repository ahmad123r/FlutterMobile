import 'package:flutter/material.dart';
import 'expense.dart';
import 'expense_item.dart';
import 'add_expense_page.dart';

class ExpensesListPage extends StatefulWidget {
  final List<Expense> expenses;

  ExpensesListPage({required this.expenses});

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
      _filteredExpenses = widget.expenses;
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
