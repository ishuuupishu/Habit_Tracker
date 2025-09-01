import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/habit_model.dart';
import '../../providers/habit_provider.dart';
import '../../providers/theme_provider.dart';

class HabitCalendarTab extends StatefulWidget {
  final HabitModel habit;

  const HabitCalendarTab({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitCalendarTab> createState() => _HabitCalendarTabState();
}

class _HabitCalendarTabState extends State<HabitCalendarTab> {
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    displayedMonth = DateTime(now.year, now.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    });
  }

  bool _isInStreak(DateTime date) {
    if (widget.habit.completedDates.isEmpty) return false;

    final sortedDates = List<DateTime>.from(widget.habit.completedDates)
      ..sort((a, b) => b.compareTo(a));

    DateTime current = DateTime.now();
    int streakCount = 0;

    for (var completedDate in sortedDates) {
      if (current.isAtSameMomentAs(completedDate) ||
          current.subtract(const Duration(days: 1)).isAtSameMomentAs(completedDate)) {
        streakCount++;
        current = completedDate;
      } else {
        break;
      }
    }

    return widget.habit.completedDates.any((d) =>
            d.year == date.year &&
            d.month == date.month &&
            d.day == date.day) &&
        date.isAfter(current.subtract(Duration(days: streakCount)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final now = DateTime.now();
    final daysInMonth =
        DateUtils.getDaysInMonth(displayedMonth.year, displayedMonth.month);
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final startingWeekday = firstDay.weekday;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Month & navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _goToPreviousMonth,
              ),
              Text(
                DateFormat.yMMMM().format(displayedMonth),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Weekdays
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _WeekdayLabel("Mon"),
              _WeekdayLabel("Tue"),
              _WeekdayLabel("Wed"),
              _WeekdayLabel("Thu"),
              _WeekdayLabel("Fri"),
              _WeekdayLabel("Sat"),
              _WeekdayLabel("Sun"),
            ],
          ),
          const SizedBox(height: 12),

          // Calendar grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: daysInMonth + startingWeekday - 1,
              itemBuilder: (context, index) {
                if (index < startingWeekday - 1) {
                  return const SizedBox.shrink();
                }

                final day = index - startingWeekday + 2;
                final date =
                    DateTime(displayedMonth.year, displayedMonth.month, day);
                final isCompleted = widget.habit.completedDates.any((d) =>
                    d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day);
                final isInStreak = _isInStreak(date);
                final isToday = date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;

                return GestureDetector(
                  onTap: () {
                    Provider.of<HabitProvider>(context, listen: false)
                        .toggleHabitDate(widget.habit, date);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: isInStreak
                          ? LinearGradient(
                              colors: [
                                Colors.green.shade600,
                                Colors.green.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: !isInStreak && isCompleted
                          ? Colors.green.shade200
                          : null,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isToday
                            ? Theme.of(context).colorScheme.primary
                            : (isCompleted || isInStreak)
                                ? Colors.green
                                : themeProvider.isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                        width: isToday ? 2 : 1,
                      ),
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: (isCompleted || isInStreak)
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Streak info card
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.habit.currentStreak} day streak',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Longest streak: ${_calculateLongestStreak()} days',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateLongestStreak() {
    if (widget.habit.completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(widget.habit.completedDates)
      ..sort((a, b) => b.compareTo(a));

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      if (sortedDates[i - 1].difference(sortedDates[i]).inDays == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else if (sortedDates[i - 1].difference(sortedDates[i]).inDays > 1) {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
    );
  }
}
