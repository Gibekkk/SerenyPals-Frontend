import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Out'),
      ),
      body: const Center(
        child: Text(
          'Halaman Log Out (Dummy)',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}