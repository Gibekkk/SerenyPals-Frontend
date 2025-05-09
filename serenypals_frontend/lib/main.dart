import 'package:flutter/material.dart';

void main() => runApp(const ChatBotApp());

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Overlock',
      ),
      home: const ChatHomePage(),
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> chatList = [];
  final List<Map<String, List<Map<String, String>>>> allMessages = [];
  final Map<int, bool> showGreeting = {};
  int selectedIndex = -1;

  final Color highlightColor = const Color(0xFF9EC6F3);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, String>> get _messages {
    if (selectedIndex == -1) return [];
    return allMessages[selectedIndex][chatList[selectedIndex]] ?? [];
  }

  void _showChatOptions(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Opsi Chat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Rename"),
              onTap: () {
                Navigator.pop(context);
                _renameChat(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: () {
                Navigator.pop(context);
                _deleteChat(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _renameChat(int index) async {
    final TextEditingController _renameController = 
      TextEditingController(text: chatList[index]);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context, _renameController.text),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      setState(() {
        final oldName = chatList[index];
        chatList[index] = newName;
        final existingMessages = allMessages[index][oldName] ?? [];
        allMessages[index] = {newName: existingMessages};
        if (selectedIndex == index) {
          _scaffoldKey.currentState?.closeDrawer();
        }
      });
    }
  }

  void _deleteChat(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                if (selectedIndex == index) {
                  selectedIndex = -1;
                } else if (selectedIndex > index) {
                  selectedIndex--;
                }
              });
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
  if (text.trim().isEmpty || selectedIndex == -1) return; // Tambahkan validasi selectedIndex

  setState(() {
    String oldName = chatList[selectedIndex];
    _messages.add({'role': 'user', 'text': text});
    showGreeting[selectedIndex] = false;

    if (oldName.startsWith("New Chat")) {
      String newName = 'Chat ${oldName.split(' ').last}';
      chatList[selectedIndex] = newName;
      List<Map<String, String>> existingMessages = 
        allMessages[selectedIndex][oldName] ?? [];
      allMessages[selectedIndex] = {newName: existingMessages};
    }
  });

  _controller.clear();

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
}

  void _createNewChat() {
  // Cek apakah sudah ada New Chat yang belum digunakan
  if (chatList.isNotEmpty && 
      chatList.last.startsWith("New Chat") && 
      allMessages.last[chatList.last]!.isEmpty) {
    // Focus ke chat yang sudah ada
    setState(() {
      selectedIndex = chatList.length - 1;
    });
    return;
  }

  setState(() {
    int nextNumber = chatList.length + 1;
    String newChat = 'New Chat $nextNumber';
    chatList.add(newChat);
    allMessages.add({newChat: []});
    showGreeting[chatList.length - 1] = true;
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              "Keluarkan keluh kesahmu dengan bercerita",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35, 
              fontWeight: FontWeight.w600, 
              color: Color.fromARGB(255, 0, 0, 0), 
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pembicaraan kamu private kok!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17, 
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }


    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: _messages.map((msg) {
            final isUser = msg['role'] == 'user';
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blue[100] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(msg['text'] ?? ''),
              ),
            );
          }).toList(),
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
          color: Colors.lightBlue[100],
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: DrawerHeader(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  decoration: BoxDecoration(color: Colors.blue[300]),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'SerenyPals',
                      style: TextStyle(
                        fontFamily: 'Overlock',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                        horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: index == selectedIndex 
                          ? highlightColor 
                          : Colors.transparent,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                        title: Text(
                          chatList[index],
                          style: TextStyle(
                            color: index == selectedIndex 
                              ? Colors.white 
                              : Colors.black,
                            fontWeight: index == selectedIndex 
                              ? FontWeight.w500 
                              : FontWeight.normal,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: index == selectedIndex 
                              ? Colors.white 
                              : Colors.grey[600],
                          ),
                          onPressed: () => _showChatOptions(index),
                        ),
                        onTap: () => _selectChat(index),
                        onLongPress: () => _showChatOptions(index),
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
        backgroundColor: Colors.blue[200],
        title: Center(
          child: Text(
            selectedIndex == -1 ? 'SerenyPals' : chatList[selectedIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(Icons.chat_bubble_outline, size: 30, color: Colors.white),
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
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            _scaffoldKey.currentState?.closeDrawer();
          }
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
              color: Colors.blue[100],
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ceritalah',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        if (selectedIndex == -1) {
                          _createNewChat();
                        }
                        _sendMessage(_controller.text);
                      }
                    },
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
          const SizedBox(height: 16), // Tetap pertahankan spacing
          const Text(
            "Keluarkan keluh kesahmu dengan bercerita",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20, // Diperbesar dari 16 ke 20
              fontWeight: FontWeight.w600, // Lebih tebal
              color: Colors.blueGrey, // Warna lebih gelap
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pembicaraan kamu private kok!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, // Diperbesar dari 12 ke 14
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}