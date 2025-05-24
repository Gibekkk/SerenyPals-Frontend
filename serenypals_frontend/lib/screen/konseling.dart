import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:flutter_svg/svg.dart';

import '../widget/konselingcard.dart';

class KonselingOnlinePage extends StatelessWidget {
  const KonselingOnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color1,
        title: Text(
          'Konseling Online',
          style: GoogleFonts.overlock(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: KonselorCard(),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 10),
        child: SizedBox(
          width: 60, // ukuran lebar yang lebih besar
          height: 60, // ukuran tinggi yang lebih besar
          child: FloatingActionButton(
            onPressed: () {
              print("FAB ditekan");
            },
            backgroundColor: color1, // sesuaikan icon juga
            shape: const CircleBorder(),
            child: SvgPicture.asset(
              'assets/img/chatadd.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
    );
  }
}
