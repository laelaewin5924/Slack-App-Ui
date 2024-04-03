import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static saveStr(String key, String message) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, message);
  }
  static saveInt(String key, int message) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, message);
  }
  static Future<String?> getStr(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> remove(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
  }
}
