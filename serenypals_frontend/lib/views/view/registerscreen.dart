import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/color.dart';
import 'package:serenypals_frontend/widget/customtextfield.dart';
import 'package:serenypals_frontend/widget/newsletter_checkbox.dart';
import '../../widget/customloading.dart';

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
  bool _isDialogShowing = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color2,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: color1),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: color4,
              headerBackgroundColor: color1,
              headerForegroundColor: Colors.black,
              dayForegroundColor: WidgetStateColor.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? color2
                    : Colors.black,
              ),
              dayBackgroundColor: WidgetStateColor.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? color2
                    : Colors.transparent,
              ),
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
              bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading && !_isDialogShowing) {
          _isDialogShowing = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingDialog(),
          ).then((_) => _isDialogShowing = false);
        }

        if ((state is AuthRegisterSuccess || state is AuthFailure) &&
            _isDialogShowing &&
            Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (state is AuthRegisterSuccess) {
          // Kirim email sebagai extra ke halaman OTP
          context.go('/otp', extra: _emailController.text);
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: color4),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'SerenyPals',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Daftarkan Akun',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // === Nama ===
                    _buildFormFieldTitle('Nama'),
                    CustomInputField(
                      key: const Key('name_field'),
                      hint: 'Masukkan nama',
                      controller: _nameController,
                      icon: Icons.person,
                      obscureText: false,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // === Tanggal Lahir ===
                    _buildFormFieldTitle('Tanggal Lahir'),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomInputField(
                          key: const Key('birthdate_field'),
                          hint: 'Pilih tanggal lahir',
                          controller: _birthDateController,
                          icon: Icons.calendar_today,
                          obscureText: false,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Tanggal Lahir wajib diisi'
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // === No. Telepon ===
                    _buildFormFieldTitle('No. Telepon'),
                    CustomInputField(
                      key: const Key('phone_field'),
                      hint: 'Masukkan nomor telepon',
                      controller: _phoneController,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                      validator: (value) {
                        final phoneRegex = RegExp(r'^[0-9]+$');
                        if (value == null || value.isEmpty) {
                          return 'No. Telepon wajib diisi';
                        } else if (!phoneRegex.hasMatch(value)) {
                          return 'No. Telepon hanya boleh angka';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // === Email ===
                    _buildFormFieldTitle('Email'),
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

                    // === Password ===
                    _buildFormFieldTitle('Password'),
                    CustomInputField(
                      key: const Key('password_field'),
                      hint: 'Masukkan password',
                      controller: _passwordController,
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password wajib diisi'
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // === Newsletter Checkbox ===
                    NewsletterCheckbox(
                      key: const Key('newsletter_checkbox'),
                      value: _newsletterValue,
                      onChanged: (val) =>
                          setState(() => _newsletterValue = val),
                    ),

                    const SizedBox(height: 25),

                    // === Button Daftar ===
                    Center(
                      child: CustomButton(
                        key: const Key('register_button'),
                        text: 'Daftar',
                        fontSize: 20,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  RegisterUser(
                                    name: _nameController.text,
                                    birthDate: _birthDateController.text,
                                    phone: _phoneController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    subscribeNewsletter: _newsletterValue,
                                  ),
                                );
                          }
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        backgroundColor: color1,
                        textColor: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // === Navigasi ke Login ===
                    _buildLoginNavigation(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFieldTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLoginNavigation() {
    return Center(
      child: RichText(
        key: const Key('login_navigation'),
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Overlock',
          ),
          children: [
            const TextSpan(text: 'Sudah punya akun? '),
            TextSpan(
              text: 'Masuk',
              style: TextStyle(
                fontFamily: 'Overlock',
                color: color1,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.go('/login'),
            ),
            const TextSpan(
              text: ' di sini',
              style: TextStyle(fontSize: 16, fontFamily: 'Overlock'),
            ),
          ],
        ),
      ),
    );
  }
}
