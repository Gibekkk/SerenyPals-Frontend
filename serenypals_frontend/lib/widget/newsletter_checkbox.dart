import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/widget/termsandconditionsdialog.dart';
import '../utils/color.dart';

class NewsletterCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const NewsletterCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(val!),
          activeColor: color1,
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.overlock(color: Colors.black),
              children: [
                const TextSpan(
                  text:
                      'Dengan mendaftar, Anda setuju bergabung dengan SerenyPals sesuai  ',
                ),
                TextSpan(
                  text: 'Syarat & Ketentuan ',
                  style: GoogleFonts.overlock(
                    color: color1,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () => showDialog(
                              context: context,
                              builder: (context) => const TermsPopup(),
                            ),
                ),
                const TextSpan(text: 'yang telah kami ajukan'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
