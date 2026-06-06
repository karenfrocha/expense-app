import 'package:flutter/material.dart';

import '../domain/entities/expense.dart';

class CategoryUtils {
  static String label(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'Alimentação';
      case ExpenseCategory.transport:
        return 'Transporte';
      case ExpenseCategory.shopping:
        return 'Compras';
      case ExpenseCategory.health:
        return 'Saúde';
      case ExpenseCategory.entertainment:
        return 'Lazer';
      case ExpenseCategory.bills:
        return 'Contas';
      case ExpenseCategory.education:
        return 'Educação';
      case ExpenseCategory.other:
        return 'Outros';
    }
  }

  static IconData icon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.health:
        return Icons.favorite_rounded;
      case ExpenseCategory.entertainment:
        return Icons.movie_rounded;
      case ExpenseCategory.bills:
        return Icons.receipt_long_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.other:
        return Icons.category_rounded;
    }
  }

  static Color color(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return const Color(0xFFFF6B6B);
      case ExpenseCategory.transport:
        return const Color(0xFF4ECDC4);
      case ExpenseCategory.shopping:
        return const Color(0xFFFFE66D);
      case ExpenseCategory.health:
        return const Color(0xFF00FF8C);
      case ExpenseCategory.entertainment:
        return const Color(0xFFFF79C6);
      case ExpenseCategory.bills:
        return const Color(0xFF6272A4);
      case ExpenseCategory.education:
        return const Color(0xFF8BE9FD);
      case ExpenseCategory.other:
        return const Color(0xFF8892B0);
    }
  }
}
