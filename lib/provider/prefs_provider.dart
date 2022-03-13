import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class AppPrefsProvider extends ChangeNotifier {
  AppPrefsProvider() {
    _loadFromPrefs();
  }

  ThemeMode? themeMode;
  Locale? locale;

  void setThemeMode(ThemeMode? value) async {
    themeMode = value;
    await _AppPrefs.setThemeMode(value);
    notifyListeners();
  }

  void setLanguage(Locale? value) async {
    locale = value;
    await _AppPrefs.setLocale(value);
    notifyListeners();
  }

  _loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    themeMode = _AppPrefs.getThemeMode(prefs);
    locale = _AppPrefs.getLocale(prefs);
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

  void setNumberViewMode(NumberViewMode mode) async {
    await _AppPrefs.setNumberViewMode(mode);
    // No notify
  }
}

class _AppPrefs {
  static const String _keyBirthdate = 'birthdate';
  static const String _keyAge = 'age';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyLanguage = 'language';
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

    // Mode (with default)
    NumberViewMode numberViewMode = NumberViewMode.birthToNow;
    final int? rawNumberViewMode = prefs.getInt(_keyNumberViewMode);
    if (rawNumberViewMode != null) {
      numberViewMode = NumberViewMode.values[rawNumberViewMode];
    }

    return LifetimeConfig(birthday, age, numberViewMode: numberViewMode);
  }

  static Future<bool> setBirthdate(DateTime birthdate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBirthdate, birthdate.toIso8601String());
  }

  static Future<bool> setAge(int age) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_keyAge, age);
  }

  static ThemeMode? getThemeMode(SharedPreferences prefs) {
    final int? raw = prefs.getInt(_keyThemeMode);
    if (raw == null) {
      return null;
    }
    return ThemeMode.values[raw];
  }

  static Future<bool> setThemeMode(ThemeMode? mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mode == null) {
      return prefs.remove(_keyThemeMode);
    }
    return prefs.setInt(_keyThemeMode, mode.index);
  }

  static Locale? getLocale(SharedPreferences prefs) {
    final String? raw = prefs.getString(_keyLanguage);
    if (raw == null) {
      return null;
    }
    return Locale(raw);
  }

  static Future<bool> setLocale(Locale? locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      return prefs.remove(_keyLanguage);
    }
    return prefs.setString(_keyLanguage, locale.languageCode);
  }

  static Future<bool> setNumberViewMode(NumberViewMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_keyNumberViewMode, mode.index);
  }
}
