import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/load_config.dart';
import 'home/box_view.dart';
import 'home/number_view.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    //if (widget.config.defaults) {
    //  Future.delayed(Duration.zero, () => _firstOpenDialog(context, l10n));
    //}

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: _appBarActions(context, l10n),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article)),
              Tab(icon: Icon(Icons.apps)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: LoadConfig(
                    loaded: (config) => NumberView(
                        birthday: config.birthdate, age: config.age)),
              ),
            ),
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 20),
              child: LoadConfig(
                  loaded: (config) =>
                      BoxView(birthday: config.birthdate, age: config.age)),
            )),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions(BuildContext context, AppLocalizations l10n) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: IconButton(
          icon: const Icon(
            Icons.settings,
          ),
          tooltip: l10n.settingsPage,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
        ),
      )
    ];
    /*
    const keySettings = 'settings';
    return [
      PopupMenuButton<String>(
        onSelected: (String selected) {
          if (selected == keySettings) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfigPage(widget.config)));
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: keySettings,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: Text(l10n.settingsPage),
              ),
            )
          ];
        },
      ),
    ];
    */
  }

  /*
  void _firstOpenDialog(BuildContext context, AppLocalizations l10n) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.firstOpenDialogTitle),
              content: Text(l10n.firstOpenDialogContent),
              actions: [
                TextButton(
                  child: Text(l10n.firstOpenDialogOpenSettings.toUpperCase()),
                  onPressed: () {
                    widget.config.defaults = false;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                )
              ],
            ));
  }
  */
}
