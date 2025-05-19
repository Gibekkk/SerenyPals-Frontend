import 'package:flutter/material.dart';
import 'package:serenypals_frontend/screen/loginscreen.dart';
import 'package:serenypals_frontend/screen/registerscreen.dart';
import 'package:serenypals_frontend/screen/topup.dart';

void main() {
  runApp(const Mytino());
}

class Mytino extends StatelessWidget {
  const Mytino({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SerenyPals',
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/topup': (context) => const DiamondTopUpPage(),
      },
    );
  }
}
