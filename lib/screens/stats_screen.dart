import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../domain/entities/expense.dart';
import '../services/expense_service.dart';
import '../theme/app_colors.dart';
import '../utils/category_utils.dart';
import '../utils/formatters.dart';
import '../widgets/glass_card.dart';
import '../widgets/spending_chart.dart';
import '../widgets/weekly_bar_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseService>(
      builder: (context, service, _) {
        final sortedCategories = service.categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Weekly spending chart
                  GlassCard(
                        padding: const EdgeInsets.all(20),
                        borderColor: AppColors.secondary.withValues(alpha: 0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.bar_chart_rounded,
                                  color: AppColors.secondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Gastos da Semana',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  Formatters.currency(service.totalThisWeek),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 160,
                              child: WeeklyBarChart(
                                weeklyData: service.weeklySpending,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 14),

                  // Category donut chart
                  GlassCard(
                        padding: const EdgeInsets.all(20),
                        borderColor: AppColors.primary.withValues(alpha: 0.15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.donut_large_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Categorias (Mês)',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 190,
                              child: SpendingDonutChart(
                                data: service.categoryTotals,
                                total: service.totalThisMonth,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate(delay: 80.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 14),

                  // Category breakdown list
                  if (sortedCategories.isNotEmpty)
                    GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.list_alt_rounded,
                                    color: AppColors.accent,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Detalhamento',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...sortedCategories.map(
                                (entry) => _CategoryRow(
                                  category: entry.key,
                                  amount: entry.value,
                                  total: service.totalThisMonth,
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate(delay: 160.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Category Row ─────────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final ExpenseCategory category;
  final double amount;
  final double total;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final color = CategoryUtils.color(category);
    final pct = total > 0 ? (amount / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  CategoryUtils.icon(category),
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CategoryUtils.label(category),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(pct * 100).toStringAsFixed(0)}% do total',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                Formatters.currency(amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (_, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
