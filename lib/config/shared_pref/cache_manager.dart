import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static late SharedPreferences _prefs;
  static const String _keyIsFirstTime = 'isFirstTime';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isFirstTime {
    return _prefs.getBool(_keyIsFirstTime) ?? true;
  }

  static Future<void> markFirstTimeComplete() async {
    await _prefs.setBool(_keyIsFirstTime, false);
  }

  static Future<void> set({required String key, required dynamic value}) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  static String? getString(String key) => _prefs.getString(key);

  static int? getInt(String key) => _prefs.getInt(key);

  static bool? getBool(String key) => _prefs.getBool(key);

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  static Future<bool> remove({required String key}) async {
    return await _prefs.remove(key);
  }
  static Future<void> setLanguage(String lang) async {
    await _prefs.setString('language', lang);
  }

  static String getLanguage() {
    return _prefs.getString('language') ?? 'en';
  }
}
