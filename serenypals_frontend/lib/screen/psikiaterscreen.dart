import 'package:flutter/material.dart';
import 'package:serenypals_frontend/widget/customloading.dart';
import 'package:serenypals_frontend/screen/profile_page.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingScreen(
        loadingText: 'Memuat...',
        gifAssetPath: 'assets/loading/Capybaratea.gif',
        backgroundColor: color4,
      ),
    );
  }
}
