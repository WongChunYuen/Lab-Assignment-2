import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import '../../models/user.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Auto Login after when the splash screen is running
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Image.asset('assets/images/homestay.jpg', scale: 0.9),
          const Text("HOMESTAY RAYA",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 25,
            width: 100,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 120,
          ),
          const Text("Version BETA"),
          const SizedBox(
            height: 100,
          ),
        ]),
      ),
    );
  }

  // A method to auto login and navigate to the Main screen
  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _pass = (prefs.getString('pass')) ?? '';
    // If the shared_preferences is not empty then login
    if (_email.isNotEmpty) {
      http.post(Uri.parse("${Config.server}/php/login_user.php"),
          body: {"email": _email, "password": _pass,"login": "login"}).then((response) {
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        } else {
          User user = User(
              id: "0",
              email: "unregistered",
              name: "unregistered",
              address: "na",
              phone: "0123456789",
              regdate: "0");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        }
      });
    } else {
      User user = User(
          id: "0",
          email: "unregistered",
          name: "unregistered",
          address: "na",
          phone: "0123456789",
          regdate: "0");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
