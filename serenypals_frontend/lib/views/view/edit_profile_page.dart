import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serenypals_frontend/models/user.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../utils/color.dart';
import '../../widget/customtextfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();

  String? _authToken;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchProfile();
  }

  Future<void> _loadTokenAndFetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      setState(() {
        _authToken = token;
      });
      context.read<ProfileBloc>().add(FetchProfile(token));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found')),
      );
    }
  }

  void _populateControllers(User profile) {
    nameController.text = profile.name;
    emailController.text = profile.email;
    phoneController.text = profile.phone;
    birthDateController.text = profile.birthDate;
  }

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
        birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      if (_authToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auth token is missing')),
        );
        return;
      }

      final updatedData = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'birthDate': birthDateController.text,
      };
      context.read<ProfileBloc>().add(UpdateProfile(
            updatedData: updatedData,
            token: _authToken!,
          ));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          TextButton(
            onPressed: _onSavePressed,
            child: const Text("Save", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            _populateControllers(state.profile);

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/avatar.png'),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement Upload Photo
                          },
                          child: const Text("Upload Photo",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: "Name",
                    hint: "Enter your name",
                    controller: nameController,
                    icon: Icons.person,
                    obscureText: false,
                    validator: (val) =>
                        val == null || val.isEmpty ? "Name is required" : null,
                  ),
                  CustomInputField(
                    label: "Email",
                    hint: "Enter your email",
                    controller: emailController,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (val) => val == null || !val.contains('@')
                        ? "Enter valid email"
                        : null,
                  ),
                  CustomInputField(
                    label: "Phone",
                    hint: "Enter phone number",
                    controller: phoneController,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    obscureText: false,
                    validator: (val) => val == null || val.length < 10
                        ? "Enter valid phone"
                        : null,
                  ),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomInputField(
                        label: "Birth Date",
                        hint: "dd-mm-yyyy",
                        controller: birthDateController,
                        icon: Icons.cake,
                        obscureText: false,
                        validator: (val) => val == null || val.isEmpty
                            ? "Birthdate required"
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}
