import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/prefs_provider.dart';
import '../../config.dart';
import '../../util.dart';

class NumberView extends StatefulWidget {
  const NumberView({required this.birthday, required this.age, required this.mode, Key? key}) : super(key: key);

  final DateTime birthday;
  final int age;
  final NumberViewMode mode;

  @override
  State<NumberView> createState() => _NumberViewState();
}

class _NumberViewState extends State<NumberView> {
  late final Timer _timer;
  late DateTime _now;
  late NumberViewMode _mode;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (result) {
      setState(() {
        _now = DateTime.now();
      });
    });
    _now = DateTime.now();
    _mode = widget.mode;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);
    final DateTime deathDay = DateTime(widget.birthday.year + widget.age, widget.birthday.month, widget.birthday.day);

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
      text = l10n.numberViewBirthToNow(widget.birthday);
    } else {
      text = l10n.numberViewNowToDeath(widget.age, deathDay);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _NumberDefaultView(years, duration),
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
            Flexible(child: Text(text)),
          ],
        ),
        Row(
          children: [
            Switch(
                value: _mode == NumberViewMode.birthToNow,
                onChanged: (value) {
                  final NumberViewMode mode = value ? NumberViewMode.birthToNow : NumberViewMode.nowToDeath;
                  if (mode != _mode) {
                    prefsProvider.setNumberViewMode(mode);
                    setState(() {
                      _mode = mode;
                    });
                  }
                }),
            Text(l10n.numberViewModeSwitch),
          ],
        )
      ],
    );
  }
}

class _NumberDefaultView extends StatelessWidget {
  const _NumberDefaultView(this.years, this.duration, {Key? key}) : super(key: key);

  final int years;
  final Duration duration;

  final TextStyle _pairStyle = const TextStyle(fontSize: 27.0);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final NumberFormat numberFmt = NumberFormat.decimalPattern(l10n.localeName);
    final Map<String, String> pairs = {
      l10n.olympics: numberFmt.format((years / 4).floor()),
      l10n.years: numberFmt.format(years),
      l10n.days: numberFmt.format(duration.inDays),
      l10n.hours: numberFmt.format(duration.inHours),
      l10n.minutes: numberFmt.format(duration.inMinutes),
      l10n.seconds: numberFmt.format(duration.inSeconds)
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
