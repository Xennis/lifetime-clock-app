import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'provider/prefs_provider.dart';

void main() {
  runApp(const LifetimeApp());
}

class LifetimeApp extends StatelessWidget {
  const LifetimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppPrefsProvider>(
        create: (_) => AppPrefsProvider(),
        child: Builder(builder: (context) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.orange,
            ),
            themeMode: Provider.of<AppPrefsProvider>(context).getThemeMode,
            home: const HomePage(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        }));
  }
}
