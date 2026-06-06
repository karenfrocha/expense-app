import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../local/hive_database.dart';
import '../models/expense_hive_model.dart';

class HiveExpenseRepository implements ExpenseRepository {
  @override
  Future<List<Expense>> getAll() async {
    final box = HiveDatabase.expenseBox;
    final list = box.values.map((m) => m.toEntity()).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> add(Expense expense) async {
    final box = HiveDatabase.expenseBox;
    await box.put(expense.id, ExpenseHiveModel.fromEntity(expense));
  }

  @override
  Future<void> update(Expense expense) async {
    final box = HiveDatabase.expenseBox;
    await box.put(expense.id, ExpenseHiveModel.fromEntity(expense));
  }

  @override
  Future<void> delete(String id) async {
    final box = HiveDatabase.expenseBox;
    await box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    final box = HiveDatabase.expenseBox;
    await box.clear();
  }
}
