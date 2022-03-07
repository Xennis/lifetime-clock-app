import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class AppPrefsProvider extends ChangeNotifier {
  AppPrefsProvider() {
    _loadFromPrefs();
  }

  ThemeMode? _themeMode;

  ThemeMode? get getThemeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _AppPrefs.setThemeMode(mode);
    notifyListeners();
  }

  _loadFromPrefs() async {
    _themeMode = await _AppPrefs.getThemeMode() ?? ThemeMode.system;
    notifyListeners();
  }

  Future<LifetimeConfig?> get get {
    return _AppPrefs.get();
  }

  void setBirthday(DateTime birthday) async {
    await _AppPrefs.setBirthdate(birthday);
    notifyListeners();
  }

  void setAge(int age) async {
    await _AppPrefs.setAge(age);
    notifyListeners();
  }

  void setNumberViewMode(NumberViewMode mode) {
    _AppPrefs.setNumberViewMode(mode);
    // No notify
  }
}

class _AppPrefs {
  static const String _keyBirthdate = 'birthdate';
  static const String _keyAge = 'age';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyNumberViewMode = 'numberViewMode';

  static Future<LifetimeConfig?> get() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Birthday
    DateTime? birthday;
    final String? rawBirthday = prefs.getString(_keyBirthdate);
    if (rawBirthday != null) {
      birthday = DateTime.tryParse(rawBirthday);
    }

    // Age
    final int? age = prefs.getInt(_keyAge);

    if (birthday == null || age == null) {
      return Future.value(null);
    }
    return LifetimeConfig(birthday, age);
  }

  static Future<bool> setBirthdate(DateTime birthdate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBirthdate, birthdate.toIso8601String());
  }

  static Future<bool> setAge(int age) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_keyAge, age);
  }

  static Future<ThemeMode?> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? raw = prefs.getInt(_keyThemeMode);
    if (raw == null) {
      return Future.value(null);
    }
    return ThemeMode.values[raw];
  }

  static Future<bool> setThemeMode(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_keyThemeMode, mode.index);
  }

  /*
  static Future<NumberViewMode?> getNumberViewMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? raw = prefs.getInt(_keyNumberViewMode);
    if (raw == null) {
      return Future.value(null);
    }
    return NumberViewMode.values[raw];
  }
  */

  static Future<bool> setNumberViewMode(NumberViewMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_keyNumberViewMode, mode.index);
  }
}
