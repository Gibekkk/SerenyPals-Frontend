import 'package:flutter/material.dart';
import 'package:serenypals_frontend/screen/topup.dart';

void main() => runApp(const Mytino());

class Mytino extends StatelessWidget {
  const Mytino({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const DiamondTopUpPage(),
    );
  }
}

