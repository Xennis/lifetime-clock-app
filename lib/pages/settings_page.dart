import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../provider/prefs_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);

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
                    const Divider(),
                    _ThemeListTile(prefsProvider.themeMode),
                    _LanguageListTile(prefsProvider.locale),
                    const Divider(),
                    _RateAppListTile(),
                    AboutListTile(
                      icon: const Icon(Icons.explore),
                      //applicationIcon: Image.asset(
                      //  'assets/app-icon.png',
                      //  width: 65,
                      //  height: 65,
                      //),
                      applicationName: l10n.appTitle,
                      applicationVersion: l10n.aboutVersion(appVersion),
                      applicationLegalese: l10n.aboutLegalese(appAuthor),
                      child: Text(l10n.aboutPage),
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);
    return ListTile(
      leading: const Icon(Icons.date_range),
      title: Text(l10n.birthday),
      subtitle: Text(DateFormat.yMd(l10n.localeName).format(_birthday)),
      onTap: () => _selectBirthday(context, prefsProvider),
    );
  }

  Future<void> _selectBirthday(BuildContext context, AppPrefsProvider prefsProvider) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: _birthday, firstDate: DateTime(1900), lastDate: DateTime.now());
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
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);
    return ListTile(
      leading: const Icon(Icons.person_add_alt_1_sharp),
      title: Text(l10n.optionPlannedAge),
      subtitle: Text("$_age"),
      onTap: () => _selectAge(context, l10n, prefsProvider),
    );
  }

  void _selectAge(BuildContext context, AppLocalizations l10n, AppPrefsProvider prefsProvider) async {
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

class _LanguageListTile extends StatefulWidget {
  const _LanguageListTile(this.locale, {Key? key}) : super(key: key);

  final Locale? locale;

  @override
  State<_LanguageListTile> createState() => _LanguageListTileState();
}

class _LanguageListTileState extends State<_LanguageListTile> {
  late Locale? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.locale;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);

    final Map<Locale?, String> languages = {
      null: "(${l10n.optionSystem})",
      // No l10n here. Always show the native language names.
      const Locale("de"): "Deutsch",
      const Locale("fr"): "Français",
      const Locale("en"): "English"
    };

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      trailing: DropdownButton<Locale?>(
          value: _selectedLanguage,
          onChanged: (Locale? newValue) {
            prefsProvider.setLanguage(newValue);
            setState(() {
              _selectedLanguage = newValue;
            });
          },
          items: languages.entries
              .map((e) => DropdownMenuItem<Locale?>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList()),
      onTap: () => {},
    );
  }
}

class _ThemeListTile extends StatefulWidget {
  const _ThemeListTile(this.mode, {Key? key}) : super(key: key);

  final ThemeMode? mode;

  @override
  State<_ThemeListTile> createState() => _ThemeListTileState();
}

class _ThemeListTileState extends State<_ThemeListTile> {
  late ThemeMode? _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);

    final Map<ThemeMode?, String> languages = {
      null: "(${l10n.optionSystem})",
      ThemeMode.dark: l10n.optionDarkTheme,
      ThemeMode.light: l10n.optionLightTheme,
    };

    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: Text(l10n.optionTheme),
      trailing: DropdownButton<ThemeMode?>(
          value: _mode,
          onChanged: (ThemeMode? newValue) {
            prefsProvider.setThemeMode(newValue);
            setState(() {
              _mode = newValue;
            });
          },
          items: languages.entries
              .map((e) => DropdownMenuItem<ThemeMode?>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList()),
      onTap: () => {},
    );
  }
}

class _RateAppListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      return ListTile(
          leading: const Icon(Icons.star),
          title: Text(l10n.rateApp),
          onTap: () => launchUrl(Uri.https('play.google.com', '/store/apps/details', {'id': androidAppID}),
              mode: LaunchMode.externalApplication));
    }
    return Container();
  }
}

class _LoadConfig extends StatelessWidget {
  const _LoadConfig(this.prefsProvider, {required this.loaded, Key? key}) : super(key: key);

  final AppPrefsProvider prefsProvider;

  final Function(LifetimeConfig config) loaded;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LifetimeConfig?>(
      future: Provider.of<AppPrefsProvider>(context).get,
      builder: (context, snapshot) {
        final LifetimeConfig? config = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) {
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
        return loaded(LifetimeConfig(birthday, age, numberViewMode: NumberViewMode.birthToNow));
      },
    );
  }
}
