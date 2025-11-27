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
        // add other providers later here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // attempt to load saved user session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      auth.loadFromPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // show splash
      routes: {
        '/': (context) => const SplashPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SignupPage.routeName: (context) => const SignupPage(),
        '/home': (context) => const HomePage(), // implement later
      },
    );
  }
}
