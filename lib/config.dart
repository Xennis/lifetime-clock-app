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
