import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact/pages/home/home_page.dart';
import 'package:contact/pages/auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash duration

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/contacts.png'),

          radius: 40,
        )
      ),
    );
  }
}
