import 'package:flutter/material.dart';
import 'package:lifetime/config.dart';
import 'package:numberpicker/numberpicker.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage(this.config, {Key? key}) : super(key: key);

  final LifetimeConfig config;

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late int _selectedAge;

  @override
  void initState() {
    _selectedAge = widget.config.age;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text("Birthday"),
                subtitle: Text("${widget.config.birthdate}".split(' ')[0]),
                onTap: () => _selectBirthday(context),
              ),
              ListTile(
                leading: const Icon(Icons.health_and_safety_outlined),
                title: const Text("Age"),
                subtitle: Text("${widget.config.age}"),
                onTap: () => _selectAge(context),
              ),
            ],
          ),
          ),
        ));
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.config.birthdate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != widget.config.birthdate) {
      setState(() {
        LifetimePreferences.setBirthdate(picked);
        widget.config.birthdate = picked;
      });
    }
  }

  void _selectAge(BuildContext context) async {
    final int? picked = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Age"),
              content: StatefulBuilder(
                builder: (context, dialogState) {
                  return NumberPicker(
                    value: _selectedAge,
                    minValue: 1,
                    maxValue: 150,
                    onChanged: (int value) {
                      //setState(() => _selectedAge = value);
                      dialogState(() => _selectedAge = value);
                    },
                  );
                },
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(_selectedAge);
                  },
                )
              ],
            ));

    if (picked != null) {
      LifetimePreferences.setAge(picked);
      setState(() {
        widget.config.age = picked;
      });
    }
  }
}
