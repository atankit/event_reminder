import 'package:flutter/material.dart';
import 'package:event_manager/pin/app_lock_service.dart';

class ResetPinScreen extends StatefulWidget {
  @override
  _ResetPinScreenState createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  TextEditingController oldPinController = TextEditingController();
  TextEditingController newPinController = TextEditingController();

  void _updatePin() async {
    String? savedPin = await AppLockService.getPin(); // Get current PIN

    if (oldPinController.text != savedPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect Old PIN!')),
      );
      return;
    }

    if (newPinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New PIN cannot be empty!')),
      );
      return;
    }

    await AppLockService.setPin(newPinController.text); // Save new PIN
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PIN Updated Successfully!')),
    );
  }

  void _removePin() async {
    String? savedPin = await AppLockService.getPin();
    if (oldPinController.text != savedPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter currect PIN first!')),
      );
      return;
    }

    bool success = await AppLockService.removePin(oldPinController.text);
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('App Lock Removed Successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove PIN! Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset or Remove App Lock PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Current PIN"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter New PIN"),
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
                  onPressed: _updatePin,
                  child: Text("Update PIN"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _removePin,
                  child: Text("Remove PIN"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
