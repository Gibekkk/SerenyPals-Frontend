import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/blocs/auth/auth_bloc.dart';
import 'package:serenypals_frontend/blocs/auth/auth_event.dart';
import 'package:serenypals_frontend/blocs/auth/auth_state.dart';
import 'package:serenypals_frontend/utils/color.dart';
import '../../widget/customloading.dart';
import '../../widget/customtextfield.dart';
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
  String? _fcmtoken;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _isDialogShowing = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _getFcmToken(); // Ensure FCM token is fetched before disposing
    _fcmtoken = null; // Clear the token to avoid memory leaks
    super.dispose();
  }

  Future<void> _getFcmToken() async {
    try {
      _fcmtoken = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $_fcmtoken");
    } catch (e) {
      print("Failed to get FCM token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          if (!_isDialogShowing) {
            _isDialogShowing = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const LoadingDialog(),
            );
          }
        } else {
          if (_isDialogShowing &&
              Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
            _isDialogShowing = false;
          }

          if (state is LoginSuccess) {
            context.go('/dashboard');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      child: Scaffold(
        backgroundColor: color4,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
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
                  CustomButton(
                    key: const Key('login_button'),
                    text: 'Masuk',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              LoginUser(
                                email: _emailController.text,
                                password: _passwordController.text,
                                fcmToken: _fcmtoken,
                              ),
                            );
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: color1,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    key: const Key('register_navigation'),
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Belum punya akun? '),
                        TextSpan(
                          text: 'Daftar',
                          style: TextStyle(
                            color: color1,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go('/register'),
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
