import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddForumVerificationScreen extends StatelessWidget {
  // final String postId; // postId tidak lagi diperlukan jika ini halaman generik
  // const AddForumVerificationScreen({super.key, required this.postId}); // Hapus parameter postId

  const AddForumVerificationScreen({super.key}); // Buat constructor generik

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Post'), // Judul lebih generik
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/forum'); // Kembali ke halaman forum utama
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Terima kasih atas sharing\nyang kamu lakukan ^_^',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                // Pastikan 'assets/img/capybara.png' ada di pubspec.yaml
                Image.asset(
                  'assets/img/capybara.png', // Pastikan path asset ini benar
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/forum'); // Kembali ke halaman forum utama
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('OK', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
