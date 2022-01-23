import 'package:flutter/material.dart';

import '../../config.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeModeProvider() {
    _loadFromPrefs();
  }

  ThemeMode? _mode;

  ThemeMode? get getMode => _mode;

  void setMode(ThemeMode mode) async {
    _mode = mode;
    await LifetimePreferences.setThemeMode(mode);
    notifyListeners();
  }

  _loadFromPrefs() async {
    _mode = await LifetimePreferences.getThemeMode() ?? ThemeMode.system;
    notifyListeners();
  }
}
