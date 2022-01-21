import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  int selectedAge = 100;
  DateTime now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (result) {
      setState(() {
        now = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Duration fuu() {
    DateTime deathDay = DateTime(
        selectedDate.year + selectedAge, selectedDate.month, selectedDate.day);
    return deathDay.difference(now);
  }

  int years() {
    DateTime deathDay = DateTime(
        selectedDate.year + selectedAge, selectedDate.month, selectedDate.day);
    return deathDay.year - now.year;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Lifetime'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.article),
              ),
              Tab(icon: Icon(Icons.apps)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: _NumberView(years(), fuu()),
            ),
            Center(
              child: _BoxView(selectedAge, 31),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select date'),
                  ),
                  Text("$selectedAge"),
                  TextField(
                    //controller: TextEditingController()
                    //  ..text = selectedAge.toString(),
                    onChanged: (inputValue) {
                      int? age = int.tryParse(inputValue);
                      // Avoid having to render too many boxes.
                      if (age != null && age <= 150) {
                        setState(() {
                          selectedAge = age;
                        });
                      }
                    },
                    maxLength: 3,
                    decoration: const InputDecoration(
                      labelText: "Enter your number",
                      //errorStyle: TextStyle(),
                      // errorText: 'Please enter something'
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      //FilteringTextInputFormatter.allow(
                      //    RegExp(r'[1-9][0-9]?$|^200$'))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberView extends StatelessWidget {
  const _NumberView(this.years, this.duration, {Key? key}) : super(key: key);

  final int years;
  final Duration duration;

  final TextStyle _pairStyle = const TextStyle(fontSize: 30.0);

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
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
            label,
            style: _pairStyle,
            textAlign: TextAlign.end,
          ),
        ),
        Text(value, style: _pairStyle),
      ]));
    });

    return Table(
      children: rows,
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
    for (var i = 0; i <= max; i++) {
      boxes.add(_box(i));
    }

    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: boxes,
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
