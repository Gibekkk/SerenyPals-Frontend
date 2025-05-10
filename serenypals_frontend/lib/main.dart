import 'package:flutter/material.dart';
import 'package:serenypals_frontend/screen/loginscreen.dart';
import 'package:serenypals_frontend/screen/registerscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SerenyPals',
      initialRoute: '/login', // Rute awal
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
