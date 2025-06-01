import 'package:flutter/material.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';

class TermsPopup extends StatelessWidget {
  const TermsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: color8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Syarat & Ketentuan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              'Ini adalah syarat dan ketentuan aplikasi kami. '
              'Silakan baca dengan seksama sebelum melanjutkan.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Tutup',
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: color7,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
