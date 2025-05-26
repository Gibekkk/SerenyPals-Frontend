import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/konselormodel.dart';
import '../utils/color.dart';
import 'custom_button.dart';

class KonselorCard extends StatelessWidget {
  final Konselor konselor;

  const KonselorCard({super.key, required this.konselor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(
          '/psikiater/chat/${Uri.encodeComponent((konselor.name ?? '').isNotEmpty ? konselor.name! : 'Nama Konselor')}',
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD8F6F0),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueGrey,
              backgroundImage:
                  (konselor.avatarUrl.isNotEmpty)
                      ? NetworkImage(konselor.avatarUrl)
                      : null,
              child:
                  konselor.avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (konselor.name ?? '').isNotEmpty
                        ? konselor.name!
                        : 'Nama Konselor',
                    style: GoogleFonts.overlock(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    konselor.title.isNotEmpty
                        ? konselor.title
                        : 'Psikolog/Konselor',
                    style: GoogleFonts.overlock(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CustomButton(
              text: 'Jadwal',
              onPressed: () => showJadwalPopup(context, konselor),
              backgroundColor: color2,
              textColor: Colors.black,
              fontSize: 16,
              borderRadius: 10,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
          ],
        ),
      ),
    );
  }
}

void showJadwalPopup(BuildContext context, Konselor konselor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFDEACA),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Jadwal ${konselor.name}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ...[
                "Senin – 08:00 – 20:00",
                "Selasa – 08:00 – 20:00",
                "Rabu – 08:00 – 20:00",
                "Kamis – 08:00 – 20:00",
                "Jumat – 08:00 – 20:00",
                "Sabtu – 08:00 – 20:00",
                "Minggu – 08:00 – 20:00",
              ].map(
                (text) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
