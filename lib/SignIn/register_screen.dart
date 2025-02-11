import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_manager/SignIn/auth_service.dart';
import 'package:event_manager/ui/home_page.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match!");
      return;
    }

    final user = await AuthService.registerWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      Get.off(() => HomePage());
    } else {
      _showErrorDialog("Registration Failed. Try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Register")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
