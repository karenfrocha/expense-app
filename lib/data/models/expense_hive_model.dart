import '../../domain/entities/expense.dart';

class ExpenseHiveModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final String? note;

  const ExpenseHiveModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  factory ExpenseHiveModel.fromEntity(Expense expense) {
    return ExpenseHiveModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      date: expense.date,
      category: expense.category,
      note: expense.note,
    );
  }

  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: category,
      note: note,
    );
  }
}
