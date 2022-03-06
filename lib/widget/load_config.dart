import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/prefs_provider.dart';
import '../config.dart';

class LoadConfig extends StatelessWidget {
  const LoadConfig({required this.loaded, Key? key}) : super(key: key);

  final Function(LifetimeConfig config) loaded;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LifetimeConfig>(
      future: Provider.of<AppPrefsProvider>(context).get,
      builder: (context, snapshot) {
        final LifetimeConfig? config = snapshot.data;
        if (config == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return loaded(config);
      },
    );
  }
}
