import 'package:flutter/material.dart';
import 'routes.dart'; // import router yang sudah dibuat

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SerenyPals',
      routerConfig: router, // pakai router yang diimport
    );
  }
}
