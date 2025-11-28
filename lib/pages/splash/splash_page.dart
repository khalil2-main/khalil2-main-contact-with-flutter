import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact/pages/home/home_page.dart';
import 'package:contact/pages/auth/login_page.dart';
import 'package:contact/theme/app_colors.dart';

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
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    /// get user fro to device storage
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final isLoggedIn = email != null;

    // Navigate based on login state
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomePage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:AppColors.primary ,
      body: Center(
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/contacts.png'),
        ),
      ),
    );
  }
}
