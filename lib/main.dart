// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wkshp_app/card_page.dart';

// the main function, called when the app is run.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  const MyApp({super.key}); // A constructor, we can ignore this for now.

  @override
  Widget build(BuildContext context) {
    // the build function returns what is shown on screen.

    return const MaterialApp(
      // An app with the "Material" UI design scheme.
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Stateful widgets are widgets that can change over time.

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // A simple app with a purple app bar and a centered text.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text("Birthday Card Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                    labelText: 'Name',
                  ),
                )),
            Text("${selectedDate.toLocal()}".split(' ')[0]), // '2021-06-23'
            ElevatedButton(
                onPressed: () async {
                  await _selectDate(context);
                },
                child: Text("Choose date")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CardPage(
                              name: nameController.text,
                              birthDay: selectedDate)));
                },
                child: Text("Generate card")),
          ],
        ),
      ), // The comma at the end makes everything look nicer.
    );
  }
}
