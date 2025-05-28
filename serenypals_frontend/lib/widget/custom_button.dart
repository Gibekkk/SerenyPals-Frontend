import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? fontSize; // ✅ opsional
  final FontWeight? fontWeight; // ✅ Tambahkan ini

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(12.0),
    this.fontSize, // ✅ tidak wajib diisi
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        minimumSize: const Size(0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: GoogleFonts.overlock(
          color: textColor,
          fontSize: fontSize ?? 18.0, // ✅ pakai default kalau null
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
    );
  }
}
