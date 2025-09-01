import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String title;
  final String description;
  final String frequency;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.createdAt,
    required this.completedDates,
  });

  factory HabitModel.fromMap(Map<String, dynamic> data, String documentId) {
    return HabitModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      frequency: data['frequency'] ?? 'day',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      completedDates: (data['completedDates'] as List<dynamic>?)
          ?.map((e) => e is Timestamp ? e.toDate() : DateTime.tryParse(e.toString())!)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'frequency': frequency,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedDates': completedDates.map((e) => Timestamp.fromDate(e)).toList(),
    };
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime current = DateTime.now();

    for (final date in sortedDates) {
      if (current.difference(date).inDays == 0) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else if (current.isAfter(date)) {
        break;
      }
    }

    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort();

    int longest = 1;
    int current = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i-1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (diff > 1) {
        current = 1;
      }
    }

    return longest;
  }

  List<DateTime> get streakDates {
    if (completedDates.isEmpty) return [];

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));

    final streak = <DateTime>[];
    DateTime current = DateTime.now();

    for (final date in sortedDates) {
      if (current.difference(date).inDays == 0) {
        streak.add(date);
        current = current.subtract(const Duration(days: 1));
      } else if (current.isAfter(date)) {
        break;
      }
    }

    return streak;
  }

  double get completionPercentage {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday));
    final completedDays = completedDates.where((date) =>
    date.isAfter(weekStart) && date.isBefore(now.add(const Duration(days: 1)))
    ).length;

    return (completedDays / 7) * 100;
  }

  bool isDateCompleted(DateTime date) {
    return completedDates.any((d) =>
    d.year == date.year &&
        d.month == date.month &&
        d.day == date.day);
  }
}