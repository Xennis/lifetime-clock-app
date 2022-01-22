import 'package:flutter/material.dart';
import 'package:lifetime/config.dart';
import 'package:lifetime/pages/home.dart';

void main() {
  runApp(const LifetimeApp());
}

class LifetimeApp extends StatelessWidget {
  const LifetimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifetime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<LifetimeConfig?>(
        future: LifetimePreferences.get(),
        builder: (BuildContext context, AsyncSnapshot<LifetimeConfig?> snapshot) {
          final LifetimeConfig? config = snapshot.data;
          if (config != null) {
            return HomePage(config);
          }
          if (config == null || snapshot.hasError) {
            return HomePage(LifetimeConfig(DateTime.now(), 100));
          }
          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}

