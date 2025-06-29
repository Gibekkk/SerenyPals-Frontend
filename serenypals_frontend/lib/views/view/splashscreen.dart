import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/color.dart';

class SplashScreen extends StatefulWidget {
  final Duration delay;

  const SplashScreen({
    Key? key,
    this.delay = const Duration(
        milliseconds: 2000), // Ubah menjadi 1 detik (atau 1500 ms)
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _navigateTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // Durasi animasi fade juga bisa dipersingkat, misal 1.5 detik
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // Navigasi dengan Timer yang bisa dibatalkan
    _navigateTimer = Timer(widget.delay, () {
      if (mounted) {
        context.go('/Onboarding');
      }
    });
  }

  @override
  void dispose() {
    _navigateTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('splashscreen'),
      backgroundColor: color4,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/logo.png', width: 250, height: 250),
              const SizedBox(height: 20),
              const Text(
                'Serenypals',
                key: Key('splash_text'),
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
