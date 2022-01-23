import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'config.dart';
import 'pages/home.dart';

void main() {
  runApp(const LifetimeApp());
}

class LifetimeApp extends StatelessWidget {
  const LifetimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ThemeMode defaultThemeMode = ThemeMode.light;
    final ValueNotifier<ThemeMode> themeModeNotifier =
        ValueNotifier(defaultThemeMode);

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (_, themeMode, _child) {
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
            themeMode: themeMode,
            home: FutureBuilder<LifetimeConfig?>(
                future: LifetimePreferences.get(),
                builder: (context, snapshot) {
                  final LifetimeConfig? config = snapshot.data;
                  if (config != null) {
                    return HomePage(config, themeModeNotifier);
                  }
                  if (config == null || snapshot.hasError) {
                    return HomePage(
                        LifetimeConfig(DateTime.now(), 100, defaultThemeMode),
                        themeModeNotifier);
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        });
  }
}
