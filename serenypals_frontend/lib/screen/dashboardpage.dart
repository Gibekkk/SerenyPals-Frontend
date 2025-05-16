import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/widget/meditasiwidget.dart';
import '../utils/color.dart';
import '../widget/petdanmoodbutton.dart';
import '../widget/task.dart';
import 'package:serenypals_frontend/widget/fastsupport.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderSection(),
              _WeeklyCheckIn(), // ← pindahkan ke sini
              PetAndMoodSection(),
              TaskSection(),
              FastSupportSection(),
              MeditationTipsSection(),
              SizedBox(height: 24),
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
                style: GoogleFonts.overlock(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PremiumPage()),
                  );
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
                        style: GoogleFonts.overlock(
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
  // Untuk tracking status check-in hari
  List<bool> isCheckedList = [true, true, false, false, false, false, false];

  // Trigger animasi setelah masuk
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        // Ubah hari yang belum check-in agar bisa dianimasi ke kuning (simulasi)
        isCheckedList = [true, true, true, false, false, false, false];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
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
          Text(
            'Check-in Selama Seminggu Untuk +100',
            style: GoogleFonts.overlock(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
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
                children: [
                  _DayCheckCircle(label: 'Senin', isChecked: isCheckedList[0]),
                  _DayCheckCircle(label: 'Selasa', isChecked: isCheckedList[1]),
                  _DayCheckCircle(label: 'Rabu', isChecked: isCheckedList[2]),
                  _DayCheckCircle(label: 'Kamis', isChecked: isCheckedList[3]),
                  _DayCheckCircle(label: 'Jumat', isChecked: isCheckedList[4]),
                  _DayCheckCircle(label: 'Sabtu', isChecked: isCheckedList[5]),
                  _DayCheckCircle(label: 'Minggu', isChecked: isCheckedList[6]),
                ],
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
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isChecked ? color5 : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.overlock(fontSize: 10)),
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

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Forum"));
  }
}

class MyDiaryPage extends StatelessWidget {
  const MyDiaryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("My Diary"));
  }
}
