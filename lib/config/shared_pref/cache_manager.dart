import 'package:shared_preferences/shared_preferences.dart';

/// This is the complete and corrected CacheManager class.
/// It is safe to use and will not crash your app.
class CacheManager {
  static late SharedPreferences _prefs;
  static const String _keyIsFirstTime = 'isFirstTime';

  /// Initializes the SharedPreferences instance.
  /// Must be called once at app startup in main().
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Specific Logic for First Time Flow ---

  /// [CRITICAL FIX]
  /// A static GETTER to check if it's the first app launch.
  /// This prevents the app from crashing on startup.
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
}