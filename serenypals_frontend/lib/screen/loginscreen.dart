import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const ImageCarousel(),
                  const SizedBox(height: 10),

                  const SizedBox(height: 20),
                  Text(
                    'SerenyPals',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masuk',
                      key: const Key('masuk_text'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Email Field
                  const SizedBox(height: 8),
                  CustomInputField(
                    key: const Key('email_field'),
                    hint: 'Masukkan email',
                    controller: _emailController,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (value) {
                      final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$");
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      } else if (!regex.hasMatch(value)) {
                        return 'Gunakan format email yang valid dan domain @gmail.com';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  const SizedBox(height: 8),
                  CustomInputField(
                    key: const Key('password_field'),
                    hint: 'Masukkan password',
                    controller: _passwordController,
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      return null;
                    },
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
                    key: const Key('login_button'),
                    text: 'Masuk',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Semua field valid
                        context.go('/splashscreen');
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: color1,
                    textColor: Colors.black,
                  ),

                  const SizedBox(height: 24),

                  // Register Navigation
                  RichText(
                    key: const Key('register_navigation'), // <---- add this key
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Belum punya akun? '),
                        TextSpan(
                          text: 'Daftar',
                          style: TextStyle(
                            color: color1,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () => context.go('/Register'),
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
      ),
    );
  }
}
