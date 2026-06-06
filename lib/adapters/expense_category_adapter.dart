import 'package:hive/hive.dart';

import '../domain/entities/expense.dart';

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 0;

  @override
  ExpenseCategory read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= ExpenseCategory.values.length) {
      return ExpenseCategory.other;
    }
    return ExpenseCategory.values[index];
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    writer.writeByte(obj.index);
  }
}
