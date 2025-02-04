import 'package:event_manager/ui/theme.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final String label;
  final Function()? onTap;  // sdk

  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,   // sdk
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
        color: primaryClr
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
