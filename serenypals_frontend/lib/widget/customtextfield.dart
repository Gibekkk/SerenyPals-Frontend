import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';

class CustomInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator; // tambahkan ini

  const CustomInputField({
    super.key,
    this.label,
    this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.suffixIcon,
    required this.obscureText,
    this.validator,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.label!,
                  style: GoogleFonts.overlock(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              validator: widget.validator,
              decoration: InputDecoration(
                prefixIcon: Icon(widget.icon, color: Colors.black54),
                hintText: widget.hint,
                hintStyle: GoogleFonts.overlock(),
                labelText:
                    widget
                        .label, // Optional: bisa pakai labelText untuk float label
                labelStyle: GoogleFonts.overlock(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: color1, width: 2),
                ),
                suffixIcon: widget.suffixIcon,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
