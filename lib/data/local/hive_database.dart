import 'package:hive_flutter/hive_flutter.dart';

import '../../adapters/expense_category_adapter.dart';
import '../../adapters/expense_hive_adapter.dart';
import '../../data/models/expense_hive_model.dart';

class HiveDatabase {
  static const String _expenseBoxName = 'expenses';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseCategoryAdapter());
    Hive.registerAdapter(ExpenseHiveModelAdapter());
    await Hive.openBox<ExpenseHiveModel>(_expenseBoxName);
  }

  static Box<ExpenseHiveModel> get expenseBox =>
      Hive.box<ExpenseHiveModel>(_expenseBoxName);
}
