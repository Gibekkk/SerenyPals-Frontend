import 'package:flutter/material.dart';
import 'package:serenypals_frontend/utils/color.dart';

import '../../widget/chatbubble.dart';
import '../../widget/chatinputtext.dart';

class ChatPsikolog extends StatefulWidget {
  final String? name;

  /// [name] adalah nama konselor yang akan muncul di title. Opsional.
  const ChatPsikolog({super.key, this.name});

  @override
  State<ChatPsikolog> createState() => _ChatPsikologState();
}

class _ChatPsikologState extends State<ChatPsikolog> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _insertMessage(String text, bool isSender) {
    final newMessage = {'text': text, 'isSender': isSender};
    _messages.add(newMessage);
    _listKey.currentState?.insertItem(_messages.length - 1);
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    _insertMessage(text, true);

    // Simulasi balasan otomatis
    Future.delayed(const Duration(milliseconds: 500), () {
      _insertMessage('Terima kasih sudah berbagi.', false);
    });
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final message = _messages[index];
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: FadeTransition(
        opacity: animation,
        child: ChatBubble(text: message['text'], isSender: message['isSender']),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Pesan awal
    Future.delayed(Duration.zero, () {
      _insertMessage('Ceritakanlah', false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        backgroundColor: color2,
        leading: const BackButton(color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: 18,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
              // Jika nanti kamu punya avatar URL, bisa ganti ke:
              // backgroundImage: NetworkImage(widget.avatarUrl ?? ""),
            ),
            const SizedBox(width: 12),
            Text(
              widget.name ?? 'Konselor',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.call, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _messages.length,
              itemBuilder: _buildItem,
            ),
          ),
          ChatInputField(controller: _controller, onSend: _handleSend),
        ],
      ),
    );
  }
}
