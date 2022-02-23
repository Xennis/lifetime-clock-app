import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.config, {Key? key}) : super(key: key);

  final LifetimeConfig config;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Timer _timer;

  late DateTime _now;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (result) {
      setState(() {
        _now = DateTime.now();
      });
    });
    _now = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int current = yearsBetween(widget.config.birthdate, _now);

    if (widget.config.defaults) {
      Future.delayed(Duration.zero, () => _firstOpenDialog(context, l10n));
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: _appBarActions(l10n),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article)),
              Tab(icon: Icon(Icons.apps)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: _NumberView(
                  now: _now,
                  birthday: widget.config.birthdate,
                  deathDay: widget.config.getDeathDay(),
                ),
              ),
            ),
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 20),
              child: _BoxView(widget.config.age, current),
            )),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions(AppLocalizations l10n) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: IconButton(
          icon: const Icon(
            Icons.settings,
          ),
          tooltip: l10n.settingsPage,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(widget.config)));
          },
        ),
      )
    ];
    /*
    const keySettings = 'settings';
    return [
      PopupMenuButton<String>(
        onSelected: (String selected) {
          if (selected == keySettings) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfigPage(widget.config)));
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: keySettings,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: Text(l10n.settingsPage),
              ),
            )
          ];
        },
      ),
    ];
    */
  }

  void _firstOpenDialog(BuildContext context, AppLocalizations l10n) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.firstOpenDialogTitle),
              content: Text(l10n.firstOpenDialogContent),
              actions: [
                TextButton(
                  child: Text(l10n.firstOpenDialogOpenSettings.toUpperCase()),
                  onPressed: () {
                    widget.config.defaults = false;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage(widget.config)));
                  },
                )
              ],
            ));
  }
}

class _NumberView extends StatefulWidget {
  const _NumberView(
      {required this.now,
      required this.birthday,
      required this.deathDay,
      Key? key})
      : super(key: key);

  final DateTime now;
  final DateTime birthday;
  final DateTime deathDay;

  @override
  State<_NumberView> createState() => _NumberViewState();
}

class _NumberViewState extends State<_NumberView> {
  NumberViewMode _mode = NumberViewMode.birthToNow;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    int years;
    Duration duration;
    if (_mode == NumberViewMode.nowToDeath) {
      years = yearsBetween(widget.now, widget.deathDay);
      duration = widget.deathDay.difference(widget.now);
    } else {
      years = yearsBetween(widget.birthday, widget.now);
      duration = widget.now.difference(widget.birthday);
    }
    if (years < 0) {
      years = 0;
    }
    if (duration.isNegative) {
      duration = Duration.zero;
    }

    final Map<NumberViewMode, String> modes = {
      NumberViewMode.birthToNow:
          l10n.numberViewBirthToNow(widget.birthday.toString().split(' ')[0]),
      NumberViewMode.nowToDeath:
          l10n.numberViewNowToDeath(widget.deathDay.toString().split(' ')[0])
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<NumberViewMode>(
            value: _mode,
            onChanged: (NumberViewMode? newMode) {
              if (newMode != null) {
                AppPrefs.setNumberViewMode(newMode);
                setState(() {
                  _mode = newMode;
                });
              }
            },
            items: modes.entries
                .map((e) => DropdownMenuItem<NumberViewMode>(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList()),
        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
        _NumberDefaultView(years, duration),
      ],
    );
  }
}

class _NumberDefaultView extends StatelessWidget {
  const _NumberDefaultView(this.years, this.duration, {Key? key})
      : super(key: key);

  final int years;
  final Duration duration;

  final TextStyle _pairStyle = const TextStyle(fontSize: 28.0);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Map<String, String> pairs = {
      l10n.olympics: "${(years / 4).floor()}",
      l10n.years: "$years",
      l10n.days: "${duration.inDays}",
      l10n.hours: "${duration.inHours}",
      l10n.minutes: "${duration.inMinutes}",
      l10n.seconds: "${duration.inSeconds}"
    };

    final List<TableRow> rows = [];
    pairs.forEach((label, value) {
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            label,
            style: _pairStyle,
            textAlign: TextAlign.end,
          ),
        ),
        Text(value, style: _pairStyle),
      ]));
    });

    return Table(children: rows);
  }
}

class _BoxView extends StatelessWidget {
  const _BoxView(this.max, this.current, {Key? key}) : super(key: key);

  final int max;
  final int current;

  static const CustomPaint _past = CustomPaint(
    size: Size(25, 25),
    painter: _ColoredRect(Colors.blueAccent),
  );
  static const CustomPaint _active = CustomPaint(
    size: Size(25, 25),
    painter: _ColoredRect(Colors.pinkAccent),
  );
  static const CustomPaint _future = CustomPaint(
    size: Size(25, 25),
    painter: _ColoredRect(Colors.greenAccent),
  );

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<Widget> boxes = [];
    for (var i = 0; i < max; i++) {
      boxes.add(_box(i));
    }

    return Center(
      child: Column(
        children: [
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: boxes,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20.0)),
          const Divider(),
          Row(
            children: [
              Column(
                children: const [
                  Icon(
                    Icons.info_outline,
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(right: 10.0)),
              Flexible(child: Text(l10n.boxViewInfoText))
            ],
          ),
        ],
      ),
    );
  }

  CustomPaint _box(int i) {
    if (i < current) {
      return _past;
    }
    if (i == current) {
      return _active;
    }
    return _future;
  }
}

class _ColoredRect extends CustomPainter {
  const _ColoredRect(this.color, {Listenable? repaint})
      : super(repaint: repaint);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawRect(const Offset(0, 0) & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

int yearsBetween(DateTime from, DateTime to) {
  int years = to.year - from.year;
  final int months = to.month - from.month;
  final int days = to.day - from.day;
  if (months < 0 || (months == 0 && days < 0)) {
    years--;
  }
  return years;
}
