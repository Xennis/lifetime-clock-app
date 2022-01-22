import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifetime/config.dart';
import 'package:lifetime/pages/config.dart';

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
    final DateTime deathDay = widget.config.getDeathDay();
    Duration durationLeft = deathDay.difference(_now);
    if (durationLeft.isNegative) {
      durationLeft = Duration.zero;
    }
    int yearsLeft = deathDay.year - _now.year;
    if (yearsLeft < 0) {
      yearsLeft = 0;
    }
    int current = widget.config.age - yearsLeft;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lifetime"),
          actions: _appBarActions(),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.article)),
              Tab(icon: Icon(Icons.apps)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: _NumberView(yearsLeft, durationLeft),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: _BoxView(widget.config.age, current),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return <Widget>[
      PopupMenuButton<String>(
        onSelected: (String selected) {
          if (selected == "settings") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfigPage(widget.config)));
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: "settings",
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              ),
            )
          ];
        },
      ),
    ];
  }
}

class _NumberView extends StatelessWidget {
  const _NumberView(this.years, this.duration, {Key? key}) : super(key: key);

  final int years;
  final Duration duration;

  final TextStyle _pairStyle = const TextStyle(fontSize: 28.0);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> pairs = {
      "Olympia": "${(years / 4).floor()}",
      "Years": "$years",
      "Days": "${duration.inDays}",
      "Hours": "${duration.inHours}",
      "Minutes": "${duration.inMinutes}",
      "Seconds": "${duration.inSeconds}"
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Table(
          children: rows,
        )
      ],
    );
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
          )
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
