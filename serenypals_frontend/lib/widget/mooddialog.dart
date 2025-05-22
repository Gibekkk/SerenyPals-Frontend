import 'package:flutter/material.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';

import '../utils/color.dart';

class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Terima kasih sudah mengisi survei mood! ^^',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/img/moodjournaling.png', // ganti dengan path gambar kamu
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Data kamu sangat membantu kami.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        Center(
          child: CustomButton(
            text: 'Simpan',
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            backgroundColor: color6,
            textColor: Colors.black,
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
