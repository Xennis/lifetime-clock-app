class LifetimeConfig {
  LifetimeConfig(this.birthdate, this.age, {this.defaults = false});

  DateTime birthdate;
  int age;

  bool defaults;
}

enum NumberViewMode {
  birthToNow,
  nowToDeath,
}
