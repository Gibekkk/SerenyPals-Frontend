import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/widget/meditasiwidget.dart';
import '../../utils/color.dart';
import '../../widget/petdanmoodbutton.dart';
import '../../widget/task.dart';
import 'package:serenypals_frontend/widget/fastsupport.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderSection(),
              const _WeeklyCheckIn(),
              const PetAndMoodSection(),
              const TaskSection(),
              FastSupportSection(enableAnimation: false), // Nonaktifkan animasi
              const MeditationTipsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      color: color1, // warna background utama
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SerenyPals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/premium'); // Navigasi ke halaman premium
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // transparan
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/img/premium.png',
                        width: 30,
                        height: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SerenyPremium',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyCheckIn extends StatefulWidget {
  const _WeeklyCheckIn();

  @override
  State<_WeeklyCheckIn> createState() => _WeeklyCheckInState();
}

class _WeeklyCheckInState extends State<_WeeklyCheckIn> {
  List<bool> isCheckedList = [true, true, false, false, false, false, false];
  Timer? _checkInTimer;

  @override
  void initState() {
    super.initState();

    // Mulai timer untuk animasi check-in
    _checkInTimer = Timer(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        isCheckedList = [true, true, true, false, false, false, false];
      });
    });
  }

  @override
  void dispose() {
    _checkInTimer?.cancel(); // pastikan timer dibatalkan saat widget dibuang
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Check-in Selama Seminggu Untuk +100',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Stack(
            children: [
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Container(height: 2, color: Colors.grey[400]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  const dayLabels = [
                    'Senin',
                    'Selasa',
                    'Rabu',
                    'Kamis',
                    'Jumat',
                    'Sabtu',
                    'Minggu',
                  ];
                  return _DayCheckCircle(
                    label: dayLabels[index],
                    isChecked: isCheckedList[index],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCheckCircle extends StatelessWidget {
  final String label;
  final bool isChecked;

  const _DayCheckCircle({required this.label, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isChecked ? color5 : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Psikiater")),
      body: Center(child: Text("Hubungi Psikiater")),
    );
  }
}
