import 'dart:async';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/firestore_service.dart';

class HabitProvider extends ChangeNotifier {
  final String userId;
  final FirestoreService _firestoreService = FirestoreService();

  HabitProvider({required this.userId}) {
    fetchHabits();
  }

  List<HabitModel> _habits = [];
  List<HabitModel> get habits => _habits;

  late final StreamSubscription<List<HabitModel>> _subscription;

  
  void fetchHabits() {
    _subscription = _firestoreService.getHabits(userId).listen((habitList) {
      _habits = habitList;
      notifyListeners();
    });
  }

  Future<void> addOrUpdateHabit(HabitModel habit) async {
    await _firestoreService.saveHabit(userId, habit);
    // Firestore listener will auto-update _habits
  }
  Future<void> deleteHabit(String habitId) async {
    await _firestoreService.deleteHabit(userId, habitId);
  }

  Future<void> toggleHabitDate(HabitModel habit, DateTime date) async {
    if (habit.completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day)) {
      habit.completedDates.removeWhere((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);
    } else {
      habit.completedDates.add(date);
    }
    await _firestoreService.saveHabit(userId, habit);
  }

  
  Future<void> toggleHabitCompletion(HabitModel habit) async {
    await toggleHabitDate(habit, DateTime.now());
  }

 
  List<HabitModel> getHabitsForWeek(DateTime weekStart) {
    return _habits.where((habit) {
      return habit.completedDates.any((date) =>
          date.isAfter(weekStart) &&
          date.isBefore(weekStart.add(const Duration(days: 7))));
    }).toList();
  }

 
  double get overallCompletionRate {
    if (_habits.isEmpty) return 0.0;

    double total = 0.0;
    for (var habit in _habits) {
      total += habit.completionPercentage;
    }
    return total / _habits.length;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
