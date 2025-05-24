import 'package:flutter/material.dart';

import 'routes.dart'; // import router yang sudah dibuat

void main() {
  runApp(const Mytino());
}

class Mytino extends StatelessWidget {
  const Mytino({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SerenyPals',
      routerConfig: router, // pakai router yang diimport
    );
  }
}
