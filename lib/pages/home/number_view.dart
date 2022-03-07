import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../provider/prefs_provider.dart';
import '../../config.dart';
import '../../util.dart';

class NumberView extends StatefulWidget {
  const NumberView({required this.birthday, required this.age, Key? key})
      : super(key: key);

  final DateTime birthday;
  final int age;

  @override
  State<NumberView> createState() => _NumberViewState();
}

class _NumberViewState extends State<NumberView> {
  late final Timer _timer;
  late DateTime _now;

  NumberViewMode _mode = NumberViewMode.birthToNow;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (result) {
      setState(() {
        _now = DateTime.now();
      });
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
    final AppPrefsProvider prefsProvider =
        Provider.of<AppPrefsProvider>(context);
    final DateTime deathDay = DateTime(widget.birthday.year + widget.age,
        widget.birthday.month, widget.birthday.day);

    int years;
    Duration duration;
    if (_mode == NumberViewMode.nowToDeath) {
      years = yearsBetween(_now, deathDay);
      duration = deathDay.difference(_now);
    } else {
      years = yearsBetween(widget.birthday, _now);
      duration = _now.difference(widget.birthday);
    }
    if (years < 0) {
      years = 0;
    }
    if (duration.isNegative) {
      duration = Duration.zero;
    }

    String text = "";
    if (_mode == NumberViewMode.birthToNow) {
      text =
          l10n.numberViewBirthToNow(widget.birthday.toString().split(' ')[0]);
    } else {
      text = l10n.numberViewNowToDeath(deathDay.toString().split(' ')[0]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _NumberDefaultView(years, duration),
        const Padding(padding: EdgeInsets.only(bottom: 20.0)),
        const Divider(),
        Row(
          children: [
            Switch(
                value: _mode == NumberViewMode.birthToNow,
                onChanged: (value) {
                  final NumberViewMode mode = value
                      ? NumberViewMode.birthToNow
                      : NumberViewMode.nowToDeath;
                  if (mode != _mode) {
                    setState(() {
                      _mode = mode;
                    });
                  }
                }),
            Flexible(child: Text(text)),
          ],
        ),
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
