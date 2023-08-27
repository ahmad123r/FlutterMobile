import 'dart:async';
import 'expense.dart';

class MainBloc {
  List<Expense> _expenses = []; // List to store expenses
  static final List<Expense> exp = [];
  // Stream controller to manage the list of expenses
  final _expensesStreamController = StreamController<List<Expense>>.broadcast();

  // Stream to expose the list of expenses
  Stream<List<Expense>> get expensesStream => _expensesStreamController.stream;

  // Function to add an expense to the list and update the stream
  void addExpense(Expense expense) {
    _expenses.add(expense);
    exp.add(expense);
    print(_expenses);
    _expensesStreamController.sink.add(_expenses);
  }

  // Close the stream controller when no longer needed
  void dispose() {
    _expensesStreamController.close();
  }

  List<Expense> getexpenses() {
    return _expenses;
  }
}

// Create an instance of MainBloc to use throughout the app
final mainBloc = MainBloc();
