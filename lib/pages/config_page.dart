import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeModeProvider themeModeProvider =
        Provider.of<ThemeModeProvider>(context);

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
                  leading: const Icon(Icons.health_and_safety),
                  title: Text(l10n.age),
                  subtitle: Text("${widget.config.age}"),
                  onTap: () => _selectAge(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(l10n.optionDarkTheme),
                  subtitle: Text(l10n.optionDarkThemeDesc),
                  trailing: Switch(
                      value: themeModeProvider.getMode == ThemeMode.dark,
                      onChanged: (value) {
                        final ThemeMode themeMode =
                            value ? ThemeMode.dark : ThemeMode.light;
                        themeModeProvider.setMode(themeMode);
                      }),
                  onTap: () => {},
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
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(l10n.imprint),
                  onTap: () => _showImprint(context),
                ),
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
      LifetimePreferences.setBirthdate(picked);
      setState(() {
        widget.config.birthdate = picked;
      });
    }
  }

  void _selectAge(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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

  void _showImprint(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.imprint),
              content: Column(
                // otherwise the dialog fills the whole hight
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${l10n.imprintTmgText('5')}:\n\n',
                        ),
                        const TextSpan(
                            text:
                                'Fabian Rosenthal\nc/o skriptspektor e. U.\nRobert-Preußler-Straße 13 / TOP 1\n5020 Salzburg\nAT – Österreich\ncode [at] xennis.org\n\n'),
                        TextSpan(
                          text: '${l10n.imprintDisclaimerLabel}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${l10n.imprintDisclaimerText}',
                        ),
                        //TextSpan(text: '${l10n.imprintGdprApplyText} '),
                        //TextSpan(
                        //  text: l10n.gdprPrivacyPolicy,
                        //  style: const TextStyle(color: Colors.blue),
                        //  recognizer: TapGestureRecognizer()
                        //    ..onTap = () => launch(privacyPolicyUrl),
                        //),
                        //const TextSpan(text: '.')
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(l10n.ok.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
