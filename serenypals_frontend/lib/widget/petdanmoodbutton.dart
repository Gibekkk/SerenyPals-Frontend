import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/color.dart';

class PetAndMoodSection extends StatelessWidget {
  const PetAndMoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _InfoCard(
            icon: Icons.pets,
            label: 'Anabul',
            bgColor: color8,
            onTap: () => context.go('/anabul'), // Ganti rute sesuai nama kamu
          ),
          _InfoCard(
            icon: Icons.mood,
            label: 'Mood Journaling',
            bgColor: color7,
            onTap:
                () => context.go('/mood-journaling'), // Ganti juga kalau perlu
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final VoidCallback? onTap; // Tambah ini

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Overlock',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCardSection extends StatefulWidget {
  const InfoCardSection({super.key});

  @override
  State<InfoCardSection> createState() => _InfoCardSectionState();
}

class _InfoCardSectionState extends State<InfoCardSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[200]?.withOpacity(0.4),
      child: ExpansionTile(
        title: Text(
          'Selesai Klaim',
          style: TextStyle(fontFamily: 'Overlock', fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _InfoCard(
                  icon: Icons.check_circle,
                  label: 'Klaim A',
                  bgColor: Colors.greenAccent,
                ),
                _InfoCard(
                  icon: Icons.check_circle_outline,
                  label: 'Klaim B',
                  bgColor: Colors.orangeAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
