import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appThemeStateNotifier = ChangeNotifierProvider((ref) {
  return AppThemeState();
});


class AppThemeState extends ChangeNotifier {
  bool isDarkMode = false;

  void setLightTheme (){
    isDarkMode = false;
    notifyListeners();
  }
  void setDarkTheme (){
    isDarkMode = true;
    notifyListeners();
  }
}