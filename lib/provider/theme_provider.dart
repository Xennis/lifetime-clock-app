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
    await AppPrefs.setThemeMode(mode);
    notifyListeners();
  }

  _loadFromPrefs() async {
    _mode = await AppPrefs.getThemeMode() ?? ThemeMode.system;
    notifyListeners();
  }
}
