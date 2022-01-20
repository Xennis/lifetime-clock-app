import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const LifetimeApp());
}

class LifetimeApp extends StatelessWidget {
  const LifetimeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifetime',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    TextStyle numbers = const TextStyle(fontSize: 30.0);

    return DefaultTabController(
      initialIndex: 1,
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
              child: Column(
                children: [
                  Text("Olympia: ${(years() / 4).floor()}", style: numbers),
                  Text("Years: ${years()}", style: numbers),
                  Text("Days: ${fuu().inDays}", style: numbers),
                  Text("Hours: ${fuu().inHours}", style: numbers),
                  Text("Minutes: ${fuu().inMinutes}", style: numbers),
                  Text("Seconds: ${fuu().inSeconds}", style: numbers),
                ],
              ),
            ),
            Center(
              child: BoxView(selectedAge, 31),
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

class BoxView extends StatelessWidget {
  const BoxView(this.max, this.current, {Key? key}) : super(key: key);

  final int max;
  final int current;

  static const Color past = Colors.blueAccent;
  static const Color active = Colors.pinkAccent;
  static const Color future = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    List<Widget> years = [];
    for (var i = 0; i <= max; i++) {
      years.add(CustomPaint(
        size: const Size(25, 25),
        painter: MyPainter(color(i)),
      ));
    }

    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: years,
    );
  }

  Color color(int i) {
    if (i < current) {
      return past;
    }
    if (i == current) {
      return active;
    }
    return future;
  }
}

class MyPainter extends CustomPainter {
  const MyPainter(this.color, {Listenable? repaint}) : super(repaint: repaint);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawRect(const Offset(0, 0) & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
