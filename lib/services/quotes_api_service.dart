import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String themeKey = 'isDarkMode';
  static const String lastUserKey = 'lastUserEmail';

  // Save theme preference
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  // Load theme preference
  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }

  // Save last logged-in email
  Future<void> saveLastUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastUserKey, email);
  }

  // Load last logged-in email
  Future<String?> loadLastUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastUserKey);
  }
}