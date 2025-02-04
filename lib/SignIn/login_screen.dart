import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:event_manager/SignIn/auth_service.dart';
import 'package:event_manager/ui/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<String> texts = ["Event Management", "Event Reminder"];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTextAnimation();
  }

  void _startTextAnimation() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % texts.length;
        });
      }
    });
  }

  void _signInWithEmail() async {
    final user = await AuthService.signInWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      Get.off(() => HomePage());
    } else {
      _showErrorDialog('Login Failed. Please check your credentials.');
    }
  }

  void _signInWithGoogle() async {
    final user = await AuthService.signInWithGoogle();
    if (user != null) {
      Get.off(() => HomePage());
    } else {
      _showErrorDialog("Google Sign-In failed.");
    }
  }

  void _offlineLogin() {
    Get.off(() => HomePage());
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/bg.jpg',  // Replace with your actual image path
                height: 240, // Adjust height as needed
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 800),
                transitionBuilder: (widget, animation) {
                  return FadeTransition(opacity: animation, child: widget);
                },
                child: Text(
                  texts[currentIndex],
                  key: ValueKey<String>(texts[currentIndex]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(height: 30),
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
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _signInWithEmail,
                child: Text('Login with Email',style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: Icon(Icons.g_mobiledata, color: Colors.white),
                label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _offlineLogin,
                child: Text(
                  'Continue Offline',
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
    super.dispose();
  }
}
