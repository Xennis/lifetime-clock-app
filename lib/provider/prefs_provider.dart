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

  Future<LifetimeConfig> get get {
    return _AppPrefs.get();
  }

  void setBirthday(DateTime birthday) {
    _AppPrefs.setBirthdate(birthday);
    notifyListeners();
  }

  void setAge(int age) {
    _AppPrefs.setAge(age);
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

  static Future<LifetimeConfig> get() async {
    final DateTime? birthdate = await _getBirthdate();
    final int? age = await _getAge();
    // Use defaults if none are stored.
    final defaults = birthdate == null || age == null;
    return LifetimeConfig(birthdate ?? DateTime(2000, 1, 1), age ?? 100,
        defaults: defaults);
  }

  static Future<DateTime?> _getBirthdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_keyBirthdate);
    if (raw == null) {
      return Future.value(null);
    }
    return DateTime.tryParse(raw);
  }

  static Future<bool> setBirthdate(DateTime birthdate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBirthdate, birthdate.toIso8601String());
  }

  static Future<int?> _getAge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAge);
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
