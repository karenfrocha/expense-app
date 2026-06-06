import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../domain/entities/expense.dart';
import '../theme/app_colors.dart';
import '../utils/category_utils.dart';
import '../utils/formatters.dart';
import 'glass_card.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;
  final int index;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onDelete,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = CategoryUtils.color(expense.category);
    final icon = CategoryUtils.icon(expense.category);

    return GlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              // Title & meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            CategoryUtils.label(expense.category),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Formatters.timeAgo(expense.date),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.currency(expense.amount),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (expense.note != null && expense.note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.notes_rounded,
                      color: AppColors.textMuted,
                      size: 14,
                    ),
                  ],
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.15, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
