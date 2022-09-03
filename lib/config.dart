String androidAppID = 'org.xennis.apps.lifetime_clock';
String appVersion = '1.2.0';
String appAuthor = 'Xennis';

class LifetimeConfig {
  LifetimeConfig(this.birthdate, this.age, {required this.numberViewMode});

  DateTime birthdate;
  int age;
  NumberViewMode numberViewMode;
}

enum NumberViewMode {
  birthToNow,
  nowToDeath,
}
