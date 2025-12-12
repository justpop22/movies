import 'package:flutter/widgets.dart';

class AppProvider extends ChangeNotifier{
  String local = "en";

  void changeLanguage(String lang){
    local = lang;
    notifyListeners();
  }
}