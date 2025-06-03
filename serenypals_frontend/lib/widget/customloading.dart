import 'package:flutter/material.dart';
import 'loading_text.dart';

class LoadingDialog extends StatefulWidget {
  final String loadingText;
  final TextStyle? loadingTextStyle;
  final Color backgroundColor;
  final String gifAssetPath;

  const LoadingDialog({
    Key? key,
    this.loadingText = 'Loading...',
    this.loadingTextStyle,
    this.backgroundColor =
        Colors.transparent, // default background semi-transparent bisa diatur
    this.gifAssetPath = 'assets/loading/Capybaratea.gif',
  }) : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  Color _currentBackgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _currentBackgroundColor = widget.backgroundColor.withOpacity(0.8);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          Colors.transparent, // Supaya background bisa animasi sendiri
      elevation: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _currentBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(widget.gifAssetPath, width: 300, height: 300),
            const SizedBox(height: 16),
            LoadingText(
              text: widget.loadingText,
              style:
                  widget.loadingTextStyle ??
                  const TextStyle(
                    fontFamily: 'Overlock',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
