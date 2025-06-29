import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
          key: const Key('newsletter_checkbox_input'), // beda key
          value: value,
          onChanged: (val) => onChanged(val!),
          activeColor: color1,
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Overlock',
                fontSize: 14,
              ),
              children: [
                const TextSpan(
                  text:
                      'Dengan mendaftar, Anda setuju bergabung dengan SerenyPals sesuai  ',
                ),
                TextSpan(
                  text: 'Syarat & Ketentuan ',
                  style: TextStyle(
                    color: color1,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Overlock',
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () => showDialog(
                              context: context,
                              builder: (context) => const TermsPopup(),
                            ),
                ),
                const TextSpan(
                  text: 'yang telah kami ajukan',
                  style: TextStyle(fontFamily: 'Overlock', fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
