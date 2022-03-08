import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../provider/prefs_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider =
        Provider.of<AppPrefsProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.settingsPage),
        ),
        body: _LoadConfig(
          prefsProvider,
          loaded: (config) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: [
                    _BirthdayListTile(config.birthdate),
                    _AgeListTile(config.age),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: Text(l10n.optionDarkTheme),
                      subtitle: Text(l10n.optionDarkThemeDesc),
                      trailing: Switch(
                          value: prefsProvider.getThemeMode == ThemeMode.dark,
                          onChanged: (value) {
                            final ThemeMode themeMode =
                                value ? ThemeMode.dark : ThemeMode.light;
                            prefsProvider.setThemeMode(themeMode);
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
                      applicationVersion: l10n.aboutVersion('1.1.0'),
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
            );
          },
        ));
  }

  void _showImprint(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.imprint),
              scrollable: true,
              content: Column(
                // otherwise the dialog fills the whole hight
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${l10n.imprintTmgText(5)}:\n\n',
                        ),
                        const TextSpan(
                            text:
                                'Fabian Rosenthal\nSchäferkampsallee 61\n20357\nHamburg\nGermany\ncode [at] xennis.org\n\n'),
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

class _BirthdayListTile extends StatefulWidget {
  const _BirthdayListTile(this.birthday, {Key? key}) : super(key: key);

  final DateTime birthday;

  @override
  State<_BirthdayListTile> createState() => _BirthdayListTileState();
}

class _BirthdayListTileState extends State<_BirthdayListTile> {
  late DateTime _birthday;

  @override
  void initState() {
    super.initState();
    _birthday = widget.birthday;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider =
        Provider.of<AppPrefsProvider>(context);
    return ListTile(
      leading: const Icon(Icons.date_range),
      title: Text(l10n.birthday),
      subtitle: Text(DateFormat.yMd(l10n.localeName).format(_birthday)),
      onTap: () => _selectBirthday(context, prefsProvider),
    );
  }

  Future<void> _selectBirthday(
      BuildContext context, AppPrefsProvider prefsProvider) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _birthday,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _birthday) {
      prefsProvider.setBirthday(picked);
      setState(() {
        _birthday = picked;
      });
    }
  }
}

class _AgeListTile extends StatefulWidget {
  const _AgeListTile(this.age, {Key? key}) : super(key: key);

  final int age;

  @override
  State<_AgeListTile> createState() => _AgeListTileState();
}

class _AgeListTileState extends State<_AgeListTile> {
  late int _age;

  @override
  void initState() {
    super.initState();
    _age = widget.age;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider =
        Provider.of<AppPrefsProvider>(context);
    return ListTile(
      leading: const Icon(Icons.person_add_alt_1_sharp),
      title: Text(l10n.optionPlannedAge),
      subtitle: Text("$_age"),
      onTap: () => _selectAge(context, l10n, prefsProvider),
    );
  }

  void _selectAge(BuildContext context, AppLocalizations l10n,
      AppPrefsProvider prefsProvider) async {
    final int? picked = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.optionPlannedAge),
              content: StatefulBuilder(
                builder: (context, dialogState) {
                  return NumberPicker(
                    value: _age,
                    minValue: 1,
                    maxValue: 150,
                    onChanged: (int value) {
                      dialogState(() => _age = value);
                    },
                  );
                },
              ),
              actions: [
                TextButton(
                  child: Text(l10n.cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                TextButton(
                  child: Text(l10n.ok.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pop(_age);
                  },
                )
              ],
            ));

    if (picked != null) {
      prefsProvider.setAge(picked);
      setState(() {
        _age = picked;
      });
    } else {
      setState(() {
        _age = widget.age;
      });
    }
  }
}

class _LoadConfig extends StatelessWidget {
  const _LoadConfig(this.prefsProvider, {required this.loaded, Key? key})
      : super(key: key);

  final AppPrefsProvider prefsProvider;

  final Function(LifetimeConfig config) loaded;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LifetimeConfig?>(
      future: Provider.of<AppPrefsProvider>(context).get,
      builder: (context, snapshot) {
        final LifetimeConfig? config = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        }
        if (config != null) {
          return loaded(config);
        }

        // Set defaults
        final DateTime birthday = DateTime(2000, 1, 1);
        prefsProvider.setBirthday(birthday);
        const int age = 100;
        prefsProvider.setAge(age);
        return loaded(LifetimeConfig(birthday, age,
            numberViewMode: NumberViewMode.birthToNow));
      },
    );
  }
}
