class Expense {
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
  });
}

List<Expense> expenses = [
  Expense(title: 'Expense 1', amount: 100.0, date: DateTime.now()),
  Expense(title: 'Expense 2', amount: 200.0, date: DateTime.now()),
  // Add more expenses as needed
];
