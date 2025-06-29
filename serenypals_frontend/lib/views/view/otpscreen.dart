import 'package:flutter/material.dart';
import 'package:serenypals_frontend/widget/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:serenypals_frontend/widget/otpfield.dart';

class OtpForm extends StatefulWidget {
  final String email;
  const OtpForm({super.key, required this.email});
  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('otp_screen'), // Use the key passed from widget
      backgroundColor: color4,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: color4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verifikasi OTP',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
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
                style: const TextStyle(fontSize: 20),
                children: [
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Masukkan Kode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                6,
                (index) => OtpField(
                  index: index,
                  focusNodes: _focusNodes,
                  controllers: _controllers,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Batal',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.grey.shade400,
                    textColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    text: 'Verifikasi',
                    onPressed: () {
                      final otp = _controllers.map((c) => c.text).join();
                      if (otp.length == 6) {
                        context.go('/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lengkapi semua digit OTP'),
                          ),
                        );
                      }
                    },
                    backgroundColor: color1,
                    textColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // TODO: Tambahkan logika kirim ulang OTP
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kode OTP telah dikirim ulang')),
                );
              },
              child: const Text(
                'Belum menerima kode? Kirim ulang',
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
