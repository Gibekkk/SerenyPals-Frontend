import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/konselormodel.dart';
import '../utils/color.dart';
import '../widget/konselingcard.dart';

class KonselingOnlinePage extends StatelessWidget {
  const KonselingOnlinePage({super.key});

  final List<Konselor> konselorList = const [
    Konselor(
      id: '1',
      name: 'Dr. Andini R.',
      title: 'Psikolog Klinis',
      avatarUrl: '', // Bisa pakai URL atau biarkan kosong
    ),
    Konselor(
      id: '2',
      name: 'Bapak Arief T.',
      title: 'Psikolog Pendidikan',
      avatarUrl: '',
    ),
    Konselor(
      id: '3',
      name: 'Ibu Sinta M.',
      title: 'Konselor Remaja',
      avatarUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color1,
        title: Text(
          'Konseling Online',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: konselorList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: KonselorCard(konselor: konselorList[index]),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 10),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () {
              print("FAB ditekan");
            },
            backgroundColor: color1,
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
