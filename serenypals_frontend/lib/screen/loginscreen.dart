import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';
import '../widget/customtextfield.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';
import 'package:serenypals_frontend/widget/carousel_image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const ImageCarousel(),
                const SizedBox(height: 10),

                const SizedBox(height: 20),
                Text(
                  'SerenyPals',
                  style: GoogleFonts.overlock(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Masuk',
                    style: GoogleFonts.overlock(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Email Field
                const SizedBox(height: 8),
                CustomInputField(
                  hint: 'Masukkan email',
                  controller: _emailController,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                const SizedBox(height: 16),

                // Password Field
                const SizedBox(height: 8),
                CustomInputField(
                  hint: 'Masukkan password',
                  controller: _passwordController,
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 25),

                // Custom Button
                CustomButton(
                  text: 'Masuk',
                  onPressed: () {
                    context.go(
                      '/Home',
                    ); // pastikan ini sama dengan yang di router
                  },
                  backgroundColor: color1,
                  textColor: Colors.black,
                ),

                const SizedBox(height: 24),

                // Register Navigation
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.overlock(color: Colors.black),
                    children: [
                      const TextSpan(text: 'Belum punya akun? '),
                      TextSpan(
                        text: 'Daftar',
                        style: GoogleFonts.overlock(
                          color: color1,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () =>
                                      Navigator.pushNamed(context, '/register'),
                      ),
                      const TextSpan(text: ' di sini'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
