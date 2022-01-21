import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  DateTime selectedDate = DateTime.now();
  int selectedAge = 100;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text("Birthday"),
                subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
                onTap: () => _selectBirthday(context),
              ),
              ListTile(
                leading: const Icon(Icons.health_and_safety),
                title: const Text("Age"),
                subtitle: Text("$selectedAge"),
                onTap: () => _selectAge(context),
              ),
            ],
          ),
        ));
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectAge(BuildContext context) async {
    /*
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "Enter your number",
                            //errorStyle: TextStyle(),
                            // errorText: 'Please enter something'
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            //FilteringTextInputFormatter.allow(
                            //    RegExp(r'[1-9][0-9]?$|^200$'))
                          ],
                        )
                        */

    final int? picked = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Age"),
              content: TextField(
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Enter your age",
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    int? age = int.tryParse(_controller.text);
                    if (age != null && age > 150) {
                      age = null;
                    }
                    Navigator.of(context).pop(age);
                  },
                )
              ],
            ));
    if (picked != null && picked != selectedAge) {
      setState(() {
        selectedAge = picked;
      });
    }
  }
}
