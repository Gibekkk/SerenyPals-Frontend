import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/color.dart';
import '../widget/loading_text.dart';

class LoadingScreen extends StatefulWidget {
  final String loadingText;
  final TextStyle? loadingTextStyle;
  final Color backgroundColor;
  final String gifAssetPath;

  const LoadingScreen({
    Key? key,
    this.loadingText = 'Loading...',
    this.loadingTextStyle,
    this.backgroundColor = color4, // default background
    this.gifAssetPath = 'assets/loading/loading.gif',
  }) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Color _currentBackgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Delay sedikit supaya animasi terlihat
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _currentBackgroundColor = widget.backgroundColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        color: _currentBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(widget.gifAssetPath, width: 300, height: 300),
              const SizedBox(height: 20),
              LoadingText(
                text: widget.loadingText,
                style:
                    widget.loadingTextStyle ??
                    GoogleFonts.overlock(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
