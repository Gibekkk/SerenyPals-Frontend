import 'package:flutter/material.dart';
import '../widget/loading_text.dart'; // pastikan ini file yang berisi animasi teks kamu

class LoadingScreen extends StatelessWidget {
  final String loadingText;
  final TextStyle? loadingTextStyle;
  final Color backgroundColor;
  final String gifAssetPath;

  const LoadingScreen({
    Key? key,
    this.loadingText = 'Loading...',
    this.loadingTextStyle,
    this.backgroundColor = Colors.white,
    this.gifAssetPath = 'assets/loading/loading.gif', // default gif
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(gifAssetPath, width: 300, height: 300),
            const SizedBox(height: 20),
            LoadingText(
              text: loadingText,
              style:
                  loadingTextStyle ??
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
