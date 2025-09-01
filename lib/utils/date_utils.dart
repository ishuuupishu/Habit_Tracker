class DateUtilsHelper {
  /// Check if two DateTime objects represent the same day
  static bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  /// Calculate current streak from a list of completed dates
  static int calculateStreak(List<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;

    List<DateTime> sortedDates = List.from(completedDates)
      ..sort((a, b) => b.compareTo(a)); // descending

    int streak = 0;
    DateTime currentDay = DateTime.now();

    for (DateTime date in sortedDates) {
      if (isSameDay(date, currentDay)) {
        streak++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else if (date.isBefore(currentDay)) {
        break;
      }
    }
    return streak;
  }

  /// Format a date as "dd MMM yyyy"
  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} "
        "${_monthName(date.month)} ${date.year}";
  }

  static String _monthName(int month) {
    const names = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[month - 1];
  }
}