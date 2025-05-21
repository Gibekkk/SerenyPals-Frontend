import 'dart:async';

import 'package:flutter/material.dart';

class LoadingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration typingDuration;
  final Duration pauseDuration;

  const LoadingText({
    Key? key,
    required this.text,
    this.style,
    this.typingDuration = const Duration(milliseconds: 200),
    this.pauseDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<LoadingText> createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingLoop();
  }

  void _startTypingLoop() {
    _timer?.cancel(); // Jaga-jaga
    _timer = Timer.periodic(widget.typingDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
        _restartAfterPause();
      }
    });
  }

  void _restartAfterPause() async {
    await Future.delayed(widget.pauseDuration);
    if (!mounted) return;
    setState(() {
      _displayedText = '';
      _currentIndex = 0;
    });
    _startTypingLoop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayedText, style: widget.style);
  }
}
