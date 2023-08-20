import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../util.dart';

class BoxView extends StatefulWidget {
  const BoxView({required this.birthday, required this.age, Key? key})
      : super(key: key);

  final DateTime birthday;
  final int age;

  @override
  State<BoxView> createState() => _BoxViewState();
}

class _BoxViewState extends State<BoxView> {
  late final Timer _timer;
  late DateTime _now;

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
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (result) {
      final DateTime now = DateTime.now();
      // Only if the year changes a reload is required.
      if (now.year != _now.year) {
        setState(() {
          _now = now;
        });
      }
    });
    _now = DateTime.now();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int current = yearsBetween(widget.birthday, _now);
    final List<Widget> boxes = [];
    for (var i = 0; i < widget.age; i++) {
      boxes.add(_box(i, current: current));
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
              const Column(
                children: [
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

  static CustomPaint _box(int i, {required int current}) {
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
