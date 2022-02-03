import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'pages/home_page.dart';
import 'provider/theme_provider.dart';

void main() {
  runApp(const LifetimeApp());
}

class LifetimeApp extends StatelessWidget {
  const LifetimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModeProvider>(
        create: (_) => ThemeModeProvider(),
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
            themeMode: Provider.of<ThemeModeProvider>(context).getMode,
            home: FutureBuilder<LifetimeConfig?>(
                future: AppPrefs.get(),
                builder: (context, snapshot) {
                  final LifetimeConfig? config = snapshot.data;
                  if (config != null) {
                    return HomePage(config);
                  }
                  if (config == null || snapshot.hasError) {
                    final DateTime now = DateTime.now();
                    // Use current date (and not current date time)
                    return HomePage(LifetimeConfig(
                        DateTime(now.year, now.month, now.day), 100));
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
        }));
  }
}
