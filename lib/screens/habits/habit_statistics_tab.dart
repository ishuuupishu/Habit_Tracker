import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/habit_model.dart';

class HabitStatisticsTab extends StatelessWidget {
  final HabitModel habit;

  const HabitStatisticsTab({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weeklyData = _generateWeeklyData();
    final monthlyData = _generateMonthlyData();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section: Weekly Progress
          _buildSectionTitle('Weekly Progress', theme),
          _buildBarChart(weeklyData, theme),
          const SizedBox(height: 24),

          // Section: Monthly Progress
          _buildSectionTitle('Monthly Progress', theme),
          _buildLineChart(monthlyData, theme),
          const SizedBox(height: 24),

          // Stats Cards Grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            children: [
              _buildStatCard(
                'Current Streak',
                '${habit.currentStreak} days',
                Icons.local_fire_department,
                Colors.orange,
                theme,
              ),
              _buildStatCard(
                'Longest Streak',
                '${habit.longestStreak} days',
                Icons.timeline,
                Colors.green,
                theme,
              ),
              _buildStatCard(
                'Weekly Completion',
                '${habit.completionPercentage.toStringAsFixed(0)}%',
                Icons.check_circle,
                Colors.blue,
                theme,
                fullWidth: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    ThemeData theme, {
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<double> data, ThemeData theme) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.2,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final isToday = index == DateTime.now().weekday % 7;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: value > 0 ? theme.colorScheme.primary : Colors.grey[300],
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                  borderSide: isToday
                      ? BorderSide(color: theme.colorScheme.secondary, width: 2)
                      : BorderSide.none,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final dayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      dayNames[value.toInt()],
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildLineChart(List<double> data, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: (data.reduce((a, b) => a > b ? a : b) + 1),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('Week ${value.toInt() + 1}', style: theme.textTheme.bodySmall);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: theme.textTheme.bodySmall),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<double> _generateWeeklyData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      return habit.completedDates.any((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day)
          ? 1.0
          : 0.0;
    });
  }

  List<double> _generateMonthlyData() {
    final now = DateTime.now();
    return List.generate(4, (index) {
      final weekStart = now.subtract(Duration(days: (3 - index) * 7));
      int streak = 0;
      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        if (habit.completedDates.any((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day)) {
          streak++;
        } else {
          break;
        }
      }
      return streak.toDouble();
    });
  }
}
