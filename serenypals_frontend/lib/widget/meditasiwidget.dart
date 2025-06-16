import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

import '../utils/color.dart';

class MeditationTipsSection extends StatelessWidget {
  const MeditationTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips Meditasi',
            style: TextStyle(
              fontFamily: 'Overlock',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Menggunakan _TipCard dengan kemampuan navigasi
          _TipCard(
            title: 'Fokus pada Napas',
            imageAsset: 'assets/img/gambarlogin1.png',
            onTap: () {
              context.push('/meditation-tips'); // Menambahkan navigasi di sini
            },
          ),
          // Anda bisa menambahkan _TipCard lainnya di sini jika ada
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final VoidCallback? onTap; // Menambahkan callback onTap

  const _TipCard({
    required this.title,
    required this.imageAsset,
    this.onTap, // onTap sekarang opsional
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Menggunakan onTap yang disediakan
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color8,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageAsset,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Overlock',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
