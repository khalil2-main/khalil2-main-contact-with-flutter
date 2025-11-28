import 'package:contact/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact/services/auth_service.dart';
import 'package:contact/pages/auth/login_page.dart';
import 'package:contact/pages/auth/signup_page.dart';
import 'package:contact/pages/splash/splash_page.dart';
import 'package:contact/pages/home/home_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      theme: ThemeData(primarySwatch: AppColors.primary),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SignupPage.routeName: (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
