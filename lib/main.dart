import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'home_widget.dart';
import 'pages/home_page.dart';
import 'provider/prefs_provider.dart';

void main() {
  // The home widget is only implemented for Android.
  //
  // kIsWeb check required because Platform.isX is not implemented
  // for web (so it would raise an not implemented error).
  if (!kIsWeb && Platform.isAndroid) {
    // Not needed. Instead https://github.com/brucejcooper/Android-Examples/blob/master/WidgetExample/src/com/eightbitcloud/example/widget/ExampleAppWidgetProvider.java
    // The link above better. But maybe https://stackoverflow.com/questions/30288791/using-timertask-and-timer-with-widget-appwidgetprovider also heps
    WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: const Duration(seconds: 15));
  }

  runApp(const LifetimeApp());
}

class LifetimeApp extends StatelessWidget {
  const LifetimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppPrefsProvider>(
        create: (_) => AppPrefsProvider(),
        child: Builder(builder: (context) {
          final AppPrefsProvider prefsProvider =
              Provider.of<AppPrefsProvider>(context);
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
            themeMode: prefsProvider.themeMode,
            locale: prefsProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomePage(),
          );
        }));
  }
}
