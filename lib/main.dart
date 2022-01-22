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
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<LifetimeConfig?>(
          future: LifetimePreferences.get(),
          builder: (context, snapshot) {
            final LifetimeConfig? config = snapshot.data;
            if (config != null) {
              return HomePage(config);
            }
            if (config == null || snapshot.hasError) {
              return HomePage(LifetimeConfig(DateTime.now(), 100));
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
  }
}
