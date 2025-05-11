import 'package:flutter/material.dart';
import 'package:serenypals_frontend/screen/loginscreen.dart';
import 'package:serenypals_frontend/screen/registerscreen.dart';
import 'package:serenypals_frontend/screen/profile_page.dart';

void main() {
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      

      home: const ProfilePage(),
    );
  }
}