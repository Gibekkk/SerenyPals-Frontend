import 'package:flutter/material.dart';

import '../../models/meditation.dart';

class MeditationTipCard extends StatelessWidget {
  final int index;
  final MeditationTip tip;

  const MeditationTipCard({
    Key? key,
    required this.index,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${tip.title}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1E263D), // Dark blue from the image
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tip.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF4C5D72), // Slightly lighter dark blue
            ),
          ),
        ],
      ),
    );
  }
}
