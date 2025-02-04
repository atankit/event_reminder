import 'package:flutter/material.dart';
import 'package:event_manager/pin/app_lock_service.dart';

class SetPinScreen extends StatefulWidget {
  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  TextEditingController pinController = TextEditingController();
  TextEditingController hintAnswerController = TextEditingController();
  String selectedQuestion = "Favourite Place";

  final List<String> hintQuestions = [
    "Favourite Place",
    "Favourite Food",
    "Favourite Movie",
    "Pet Name",
  ];

  void _savePin() async {
    if (pinController.text.isEmpty || hintAnswerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    // Save PIN & Hint Answer
    await AppLockService.setPin(pinController.text);
    await AppLockService.setHintQuestion(selectedQuestion);
    await AppLockService.setHintAnswer(hintAnswerController.text);

    Navigator.pop(context); // Close screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('App Lock PIN Set Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set App Lock PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter PIN"),
            ),
            SizedBox(height: 20),
            Text("Select Hint Question", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedQuestion,
              onChanged: (value) {
                setState(() {
                  selectedQuestion = value!;
                });
              },
              items: hintQuestions.map((question) {
                return DropdownMenuItem(
                  value: question,
                  child: Text(question),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: hintAnswerController,
              decoration: InputDecoration(labelText: "Enter Answer"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _savePin,
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
