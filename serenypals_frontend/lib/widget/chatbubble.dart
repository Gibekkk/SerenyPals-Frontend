import 'package:flutter/material.dart';
import 'package:serenypals_frontend/utils/color.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({Key? key, required this.text, required this.isSender})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.7, // max 70% screen width
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSender ? color6 : color2,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
