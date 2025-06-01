import 'package:flutter/material.dart';
import 'package:serenypals_frontend/utils/color.dart';
import '../widget/chatbubble.dart';

typedef ChatMessage =
    Map<String, String>; // {'role': 'user'/'bot', 'text': '...'}

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final TextEditingController _controller = TextEditingController();

  // List of chat session titles
  final List<String> chatList = [];

  // List of chat messages per session: each item is List<ChatMessage>
  final List<List<ChatMessage>> allMessages = [];

  // List of unique GlobalKeys for menu buttons
  final List<GlobalKey> menuKeys = [];

  final Map<int, bool> showGreeting = {};
  int selectedIndex = -1;

  final Color highlightColor = color2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Getter untuk pesan chat yang sedang dipilih
  List<ChatMessage> get _messages {
    if (selectedIndex == -1) return [];
    return allMessages[selectedIndex];
  }

  Future<void> _showChatOptions(
    BuildContext context,
    int index,
    GlobalKey key,
  ) async {
    final RenderBox button =
        key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(
        buttonPosition.dx,
        buttonPosition.dy,
        button.size.width,
        button.size.height,
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'rename',
          child: ListTile(leading: Icon(Icons.edit), title: Text('Rename')),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(leading: Icon(Icons.delete), title: Text('Delete')),
        ),
      ],
      elevation: 8,
      color: color1,
    );

    if (selected == 'rename') {
      _renameChat(index);
    } else if (selected == 'delete') {
      _deleteChat(index);
    }
  }

  void _renameChat(int index) async {
    final TextEditingController _renameController = TextEditingController(
      text: chatList[index],
    );

    final newName = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Rename Chat"),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: "Masukkan nama baru"),
              controller: _renameController,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pop(context, _renameController.text.trim()),
                child: const Text("Simpan"),
              ),
            ],
          ),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        chatList[index] = newName;
      });
    }
  }

  void _deleteChat(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Chat"),
            content: const Text("Yakin ingin menghapus chat ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    chatList.removeAt(index);
                    allMessages.removeAt(index);
                    menuKeys.removeAt(index); // juga hapus key menu-nya
                    if (selectedIndex == index) {
                      selectedIndex = -1;
                    } else if (selectedIndex > index) {
                      selectedIndex--;
                    }
                  });
                },
                child: Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Jika belum ada chat yang dipilih, buat chat baru dulu
    if (selectedIndex == -1) {
      _createNewChat();
    }

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      showGreeting[selectedIndex] = false;

      // Simulasikan balasan bot dengan delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && selectedIndex != -1) {
          setState(() {
            _messages.add({
              'role': 'bot',
              'text': 'Terima kasih sudah bercerita.',
            });
          });
        }
      });
    });

    _controller.clear();
  }

  void _createNewChat() {
    int count = 1;
    String newChat;
    do {
      newChat = 'New Chat $count';
      count++;
    } while (chatList.contains(newChat));

    setState(() {
      chatList.add(newChat);
      allMessages.add([]);
      showGreeting[chatList.length - 1] = true;
      menuKeys.add(GlobalKey()); // tambah key menu baru
      selectedIndex = chatList.length - 1;
    });
  }

  void _selectChat(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _buildChatContent() {
    if (selectedIndex == -1) {
      return const _AnimatedGreeting();
    }
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 80),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final msg = _messages[index];
            final isUser = msg['role'] == 'user';
            return ChatBubble(text: msg['text'] ?? '', isSender: isUser);
          },
        ),
        if (showGreeting[selectedIndex] == true && _messages.isEmpty)
          const _AnimatedGreeting(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: color3,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: DrawerHeader(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'SerenyPals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            index == selectedIndex
                                ? highlightColor
                                : Colors.transparent,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          chatList[index],
                          style: TextStyle(
                            color:
                                index == selectedIndex
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight:
                                index == selectedIndex
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                          ),
                        ),
                        trailing: IconButton(
                          key: menuKeys[index], // gunakan key unik
                          icon: Icon(
                            Icons.more_vert,
                            color:
                                index == selectedIndex
                                    ? Colors.white
                                    : Colors.grey[600],
                          ),
                          onPressed:
                              () => _showChatOptions(
                                context,
                                index,
                                menuKeys[index],
                              ),
                        ),
                        onTap: () => _selectChat(index),
                        onLongPress:
                            () => _showChatOptions(
                              context,
                              index,
                              menuKeys[index],
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: color2,
        title: Center(
          child: Text(
            selectedIndex == -1 ? 'SerenyPals' : chatList[selectedIndex],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(
                    Icons.chat_bubble_outline_outlined,
                    size: 28,
                    color: Colors.black87,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.add, size: 18, color: Colors.blue),
                  ),
                ],
              ),
              tooltip: 'New Chat',
              onPressed: _createNewChat,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            _scaffoldKey.currentState?.closeDrawer();
          }
          FocusScope.of(context).unfocus(); // Hide keyboard on tap outside
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.yellow[50],
                child: _buildChatContent(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ceritalah',
                        fillColor: color8,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) _sendMessage(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: color6,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          _sendMessage(_controller.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedGreeting extends StatelessWidget {
  const _AnimatedGreeting();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            "Keluarkan keluh kesahmu dengan bercerita",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pembicaraan kamu private kok!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
