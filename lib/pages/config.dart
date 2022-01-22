import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';

import '../config.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage(this.config, {Key? key}) : super(key: key);

  final LifetimeConfig config;

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late int _selectedAge;

  @override
  void initState() {
    _selectedAge = widget.config.age;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.settingsPage),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: Text(l10n.birthday),
                  subtitle: Text("${widget.config.birthdate}".split(' ')[0]),
                  onTap: () => _selectBirthday(context),
                ),
                ListTile(
                  leading: const Icon(Icons.health_and_safety_outlined),
                  title: Text(l10n.age),
                  subtitle: Text("${widget.config.age}"),
                  onTap: () => _selectAge(context),
                ),
                const Divider(),
                AboutListTile(
                  child: Text(l10n.aboutPage),
                  icon: const Icon(Icons.explore),
                  //applicationIcon: Image.asset(
                  //  'assets/app-icon.png',
                  //  width: 65,
                  //  height: 65,
                  //),
                  applicationName: l10n.appTitle,
                  applicationVersion: l10n.aboutVersion('0.1.0'),
                  applicationLegalese: l10n.aboutLegalese('Xennis'),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.config.birthdate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != widget.config.birthdate) {
      setState(() {
        LifetimePreferences.setBirthdate(picked);
        widget.config.birthdate = picked;
      });
    }
  }

  void _selectAge(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final int? picked = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.age),
              content: StatefulBuilder(
                builder: (context, dialogState) {
                  return NumberPicker(
                    value: _selectedAge,
                    minValue: 1,
                    maxValue: 150,
                    onChanged: (int value) {
                      //setState(() => _selectedAge = value);
                      dialogState(() => _selectedAge = value);
                    },
                  );
                },
              ),
              actions: [
                TextButton(
                  child: Text(l10n.ok.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pop(_selectedAge);
                  },
                )
              ],
            ));

    if (picked != null) {
      LifetimePreferences.setAge(picked);
      setState(() {
        widget.config.age = picked;
      });
    }
  }
}
