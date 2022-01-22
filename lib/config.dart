

import 'package:shared_preferences/shared_preferences.dart';

class LifetimeConfig {
  LifetimeConfig(this.birthdate, this.age);

  DateTime birthdate;
  int age;

  DateTime getDeathDay() {
    return DateTime(birthdate.year + age, birthdate.month, birthdate.day);
  }
}


class LifetimePreferences {

  static const String _keyBirthdate = 'birthdate';
  static const String _keyAge = 'age';

  static Future<LifetimeConfig?> get() async {
    final DateTime? birthdate = await _getBirthdate();
    final int? age = await _getAge();
    if (birthdate != null && age != null) {
      return LifetimeConfig(birthdate, age);
    }
    return Future.value(null);
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
}