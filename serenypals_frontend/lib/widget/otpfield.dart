import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <--- Tambahkan ini
import 'package:google_fonts/google_fonts.dart';

class OtpField extends StatefulWidget {
  final int index;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;

  const OtpField({
    required this.index,
    required this.focusNodes,
    required this.controllers,
    super.key,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: widget.controllers[widget.index],
        focusNode: widget.focusNodes[widget.index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ], // ✅ Batasi input hanya angka
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
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (widget.index < widget.focusNodes.length - 1) {
              FocusScope.of(
                context,
              ).requestFocus(widget.focusNodes[widget.index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (widget.index > 0) {
              FocusScope.of(
                context,
              ).requestFocus(widget.focusNodes[widget.index - 1]);
            }
          }
        },
      ),
    );
  }
}
