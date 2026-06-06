import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../domain/entities/expense.dart';
import '../theme/app_colors.dart';
import '../utils/category_utils.dart';
import '../utils/formatters.dart';

class SpendingDonutChart extends StatefulWidget {
  final Map<ExpenseCategory, double> data;
  final double total;

  const SpendingDonutChart({
    super.key,
    required this.data,
    required this.total,
  });

  @override
  State<SpendingDonutChart> createState() => _SpendingDonutChartState();
}

class _SpendingDonutChartState extends State<SpendingDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              color: AppColors.textMuted,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              'Sem despesas este mês',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final entries = widget.data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 44,
              sections: List.generate(entries.length, (i) {
                final isTouched = i == _touchedIndex;
                final entry = entries[i];
                final pct = widget.total > 0
                    ? (entry.value / widget.total * 100)
                    : 0.0;
                return PieChartSectionData(
                  color: CategoryUtils.color(entry.key),
                  value: entry.value,
                  title: isTouched ? '${pct.toStringAsFixed(0)}%' : '',
                  radius: isTouched ? 60 : 52,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.take(5).map((entry) {
              return _LegendItem(
                color: CategoryUtils.color(entry.key),
                label: CategoryUtils.label(entry.key),
                amount: Formatters.currency(entry.value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
