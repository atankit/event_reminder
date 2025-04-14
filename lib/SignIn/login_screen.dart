import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../SignIn/auth_service.dart';
import 'package:event_manager/ui/home_page.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  List<String> texts = ["Event Management", "Event Reminder"];
  int currentIndex = 0;
  bool _isObscure = true;
  bool _isOffline = false; // Track offline mode

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _startTextAnimation();
  }

  // Check if device is offline
  void _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isOffline = true;
      });
    }
  }

  void _startTextAnimation() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % texts.length;
        });
        _startTextAnimation();
      }
    });
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar('Please enter a valid email!');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      _showSnackBar('Password must be at least 6 characters long!');
      return;
    }

    var user = await _authService.loginWithEmail(email, password);
    if (user != null) {
      _showSnackBar('Login successful!');
      Get.off(() => HomePage());
    } else {
      _showSnackBar('Login failed! Please check your credentials.');
    }
  }

  void loginWithGoogle() async {
    var user = await _authService.signInWithGoogle();
    if (user != null) {
      _showSnackBar('Google Login successful!');
      Get.off(() => HomePage());
    } else {
      _showSnackBar('Google Login failed!');
    }
  }

  // Local Login for offline use
  void loginOffline() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (await _authService.loginLocally(email, password)) {
      _showSnackBar('Offline Login successful!');
      Get.off(() => HomePage());
    } else {
      _showSnackBar('Offline Login failed! Check credentials.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isOffline)
                  Column(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.red, size: 50),
                      SizedBox(height: 10),
                      Text(
                        "You're offline!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Image.asset('images/bg.jpg', height: 200),
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: login,
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text('Login', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: loginWithGoogle,
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
                if (_isOffline) ...[
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: loginOffline,
                    icon: Icon(Icons.lock, color: Colors.blue),
                    label: Text('Login Offline', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.to(() => RegisterScreen()),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
