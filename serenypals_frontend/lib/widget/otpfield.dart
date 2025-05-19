import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpField extends StatelessWidget {
  final int index;
  const OtpField({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.overlock(fontSize: 20),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}
