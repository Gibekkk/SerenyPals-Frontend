import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:serenypals_frontend/widget/otpfield.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = "user@example.com"; // Ganti dengan email yang sesuai

    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: color4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Tombol kembali
        ),
        title: Text(
          'Verifikasi OTP',
          style: GoogleFonts.overlock(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: 'Masukkan kode OTP yang dikirim ke email ',
                style: GoogleFonts.overlock(fontSize: 20),
                children: [
                  TextSpan(
                    text: email,
                    style: GoogleFonts.overlock(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Masukkan Kode',
              style: GoogleFonts.overlock(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Menggunakan Wrap untuk OTP fields agar lebih responsif
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8, // Jarak antar OTP fields
              runSpacing: 8, // Jarak antar baris
              children: List.generate(6, (index) => OtpField(index: index)),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol "Batal" dengan ukuran yang fleksibel
                Expanded(
                  child: SizedBox(
                    width: double.infinity, // Tombol mengikuti lebar layar
                    child: CustomButton(
                      text: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.grey.shade400,
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Jarak antar tombol
                // Tombol "Verifikasi" dengan ukuran yang fleksibel
                Expanded(
                  child: SizedBox(
                    width: double.infinity, // Tombol mengikuti lebar layar
                    child: CustomButton(
                      text: 'Verifikasi',
                      onPressed: () {
                        // Call the BLoC's submit OTP event
                        // context.read<OtpFormBloc>().add(OtpFormSubmitEvent());
                      },
                      backgroundColor: color1,
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
