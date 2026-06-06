import 'package:hive/hive.dart';

import '../data/models/expense_hive_model.dart';
import '../domain/entities/expense.dart';

class ExpenseHiveModelAdapter extends TypeAdapter<ExpenseHiveModel> {
  @override
  final int typeId = 1;

  @override
  ExpenseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: (fields[2] as num).toDouble(),
      date: fields[3] as DateTime,
      category: fields[4] as ExpenseCategory,
      note: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.note);
  }
}
