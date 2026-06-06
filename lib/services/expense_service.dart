import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';

class ExpenseService extends ChangeNotifier {
  final ExpenseRepository _repository;

  List<Expense> _expenses = [];
  bool _isLoading = false;

  ExpenseService(this._repository);

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;

  double get totalThisMonth {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    return _expenses
        .where((e) => !e.date.isBefore(weekStartDate))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<Expense> get recentExpenses => _expenses.take(10).toList();

  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    final now = DateTime.now();
    final monthExpenses = _expenses.where(
      (e) => e.date.year == now.year && e.date.month == now.month,
    );
    for (final expense in monthExpenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  /// Returns spending per weekday for the last 7 days (1=Mon … 7=Sun).
  Map<int, double> get weeklySpending {
    final now = DateTime.now();
    final Map<int, double> weekly = {for (int i = 1; i <= 7; i++) i: 0.0};
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayTotal = _expenses
          .where(
            (e) =>
                e.date.year == day.year &&
                e.date.month == day.month &&
                e.date.day == day.day,
          )
          .fold(0.0, (sum, e) => sum + e.amount);
      weekly[day.weekday] = (weekly[day.weekday] ?? 0) + dayTotal;
    }
    return weekly;
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    _expenses = await _repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    required ExpenseCategory category,
    String? note,
  }) async {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
      note: note,
    );
    await _repository.add(expense);
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await _repository.update(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _repository.delete(id);
    await loadExpenses();
  }

  List<Expense> filterByCategory(ExpenseCategory category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<Expense> searchExpenses(String query) {
    final q = query.toLowerCase();
    return _expenses
        .where(
          (e) =>
              e.title.toLowerCase().contains(q) ||
              (e.note?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }
}
