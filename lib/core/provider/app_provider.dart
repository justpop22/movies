import 'package:flutter/cupertino.dart';

import '../../config/shared_pref/cache_manager.dart';

class AppProvider extends ChangeNotifier {
  String _local = CacheManager.getLanguage();
  String get local => _local;
  void changeLanguage(String value) {
    if (_local == value) return;
    _local = value;
    CacheManager.setLanguage(value);
    notifyListeners();
  }
}
