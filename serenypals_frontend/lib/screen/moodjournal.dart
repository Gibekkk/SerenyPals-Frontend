import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';

import '../widget/custom_button.dart';

class MoodJournaling extends StatefulWidget {
  const MoodJournaling({super.key});

  @override
  State<MoodJournaling> createState() => _MoodJournalingState();
}

class _MoodJournalingState extends State<MoodJournaling> {
  double moodLevel = 3;
  final TextEditingController issueController = TextEditingController();
  final TextEditingController storyController = TextEditingController();

  final String dynamicQuestion = "Apakah kamu ingin bercerita tentang harimu?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        title: const Text('Mood Journaling'),
        backgroundColor: color2,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MoodQuestionBox(
                            question: 'Bagaimana perasaanmu hari ini?',
                            moodLevel: moodLevel,
                            onChanged: (val) {
                              setState(() {
                                moodLevel = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: QuestionBox(
                            question: dynamicQuestion,
                            hintText: 'Contoh: Teman, pekerjaan, dll.',
                            controller: issueController,
                            isMultiline: false,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: QuestionBox(
                            question: dynamicQuestion,
                            hintText: 'Tuliskan ceritamu di sini...',
                            controller: storyController,
                            isMultiline: true,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: CustomButton(
                            text: 'Simpan',
                            onPressed: () {
                              print('Mood: $moodLevel');
                              print('Masalah: ${issueController.text}');
                              print('Cerita: ${storyController.text}');
                            },
                            backgroundColor: Colors.purple[300]!,
                            textColor: Colors.white,
                            borderRadius: 20,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===========================
// Mood Question Box
// ===========================
class MoodQuestionBox extends StatelessWidget {
  final double moodLevel;
  final ValueChanged<double> onChanged;
  final String question;

  const MoodQuestionBox({
    super.key,
    required this.moodLevel,
    required this.onChanged,
    this.question = 'Bagaimana perasaanmu hari ini?',
  });

  static const List<String> labels = [
    "Sangat Buruk",
    "Buruk",
    "Biasa",
    "Baik",
    "Sangat Baik",
  ];

  static const List<IconData> icons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  @override
  Widget build(BuildContext context) {
    int moodIndex = moodLevel.round() - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.overlock(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icons[0], color: Colors.red),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12.0,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 24.0,
                  ),
                  trackHeight: 4.0,
                ),
                child: Slider(
                  value: moodLevel,
                  onChanged: onChanged,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: labels[moodIndex],
                  activeColor: color5,
                  inactiveColor: color7,
                ),
              ),
            ),
            Icon(icons[4], color: Colors.green),
          ],
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            labels[moodIndex],
            style: GoogleFonts.overlock(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}

// ========================
// Question Box
// ========================
class QuestionBox extends StatelessWidget {
  final String question;
  final String hintText;
  final TextEditingController controller;
  final bool isMultiline;

  const QuestionBox({
    super.key,
    required this.question,
    required this.hintText,
    required this.controller,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.overlock(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints:
              isMultiline ? const BoxConstraints(minHeight: 100) : null,
          child: TextField(
            controller: controller,
            maxLines: isMultiline ? null : 1,
            keyboardType:
                isMultiline ? TextInputType.multiline : TextInputType.text,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: color3,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
