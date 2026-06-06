import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WeeklyBarChart extends StatelessWidget {
  /// weekday (1=Mon … 7=Sun) → total amount
  final Map<int, double> weeklyData;

  const WeeklyBarChart({super.key, required this.weeklyData});

  static const _labels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final values = weeklyData.values.where((v) => v > 0);
    final maxY = values.isEmpty
        ? 100.0
        : (values.reduce((a, b) => a > b ? a : b) * 1.35).clamp(
            10.0,
            double.infinity,
          );

    final today = DateTime.now().weekday;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.card,
            tooltipBorder: const BorderSide(color: AppColors.cardBorder),
            getTooltipItem: (group, _, rod, _) {
              return BarTooltipItem(
                'R\$ ${rod.toY.toStringAsFixed(0)}',
                const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= 7) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _labels[idx],
                    style: TextStyle(
                      color: (idx + 1) == today
                          ? AppColors.primary
                          : AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: (idx + 1) == today
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppColors.cardBorder.withValues(alpha: 0.4),
            strokeWidth: 1,
          ),
        ),
        barGroups: List.generate(7, (i) {
          final weekday = i + 1;
          final amount = weeklyData[weekday] ?? 0.0;
          final isToday = weekday == today;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: amount,
                gradient: isToday
                    ? AppColors.primaryGradient
                    : LinearGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.4),
                          AppColors.primary.withValues(alpha: 0.25),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                width: 22,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
