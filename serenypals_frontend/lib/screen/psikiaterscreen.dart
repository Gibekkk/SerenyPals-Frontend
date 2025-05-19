import 'package:flutter/material.dart';
import 'package:serenypals_frontend/screen/customloading.dart';
import 'package:serenypals_frontend/screen/profile_page.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Page")),
      body: Center(child: Text("AI Assistant")),
    );
  }
}

class PsikiaterPage extends StatelessWidget {
  const PsikiaterPage({super.key});

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
