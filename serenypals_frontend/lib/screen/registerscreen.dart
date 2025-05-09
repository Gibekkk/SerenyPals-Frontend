import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:serenypals_frontend/screen/loginscreen.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';
import '../utils/color.dart';
import 'package:serenypals_frontend/widget/customtextfield.dart';
import 'package:serenypals_frontend/widget/newsletter_checkbox.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _newsletterValue = false;
  bool _obscurePassword = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: color4),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SerenyPals',
                    style: GoogleFonts.overlock(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Daftarkan Akun',
                    style: GoogleFonts.overlock(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),

                  // Nama
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama',
                        style: GoogleFonts.overlock(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomInputField(
                        hint: 'Masukkan nama',
                        controller: _nameController,
                        icon: Icons.person,
                        obscureText: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Lahir
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Lahir',
                        style: GoogleFonts.overlock(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomInputField(
                            hint: 'Pilih tanggal lahir',
                            controller: _birthDateController,
                            icon: Icons.calendar_today,
                            obscureText: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // No. Telepon
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Telepon',
                        style: GoogleFonts.overlock(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomInputField(
                        hint: 'Masukkan nomor telepon',
                        controller: _phoneController,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.overlock(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomInputField(
                        hint: 'Masukkan email',
                        controller: _emailController,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.overlock(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    ],
                  ),

                  const SizedBox(height: 24),
                  NewsletterCheckbox(
                    value: _newsletterValue,
                    onChanged: (val) => setState(() => _newsletterValue = val),
                  ),
                  SizedBox(height: 25),
                  CustomButton(
                    text: 'Daftar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    backgroundColor: color1,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(height: 16),
                  _buildLoginNavigation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginNavigation() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.overlock(color: Colors.black),
        children: [
          const TextSpan(text: 'Sudah punya akun? '),
          TextSpan(
            text: 'Masuk',
            style: GoogleFonts.overlock(
              color: color1,
              fontWeight: FontWeight.bold,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () => Navigator.pushNamed(context, '/login'),
          ),
          const TextSpan(text: ' di sini'),
        ],
      ),
    );
  }
}
