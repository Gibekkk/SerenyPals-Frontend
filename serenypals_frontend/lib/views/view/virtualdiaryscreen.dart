import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:serenypals_frontend/utils/color.dart';

import '../widget/custom_button.dart';

// Model sederhana untuk diary entry
class DiaryEntry {
  final String title;
  final String content;
  final String date;

  DiaryEntry({required this.title, required this.content, required this.date});
}

class MyDiaryPage extends StatefulWidget {
  const MyDiaryPage({super.key});

  @override
  State<MyDiaryPage> createState() => _MyDiaryPageState();
}

class _MyDiaryPageState extends State<MyDiaryPage> {
  final List<DiaryEntry> _entries = [
    DiaryEntry(
      title: 'Hari yang Melelahkan',
      content:
          'Hari ini sangat melelahkan dengan banyak deadline yang harus diselesaikan...',
      date: '31 Mei 2025',
    ),
    DiaryEntry(
      title: 'Pencapaian Kecil',
      content:
          'Akhirnya berhasil menyelesaikan proyek kecil setelah bekerja keras...',
      date: '29 Mei 2025',
    ),
  ];

  void _navigateToCreateDiary() async {
    final result = await context.push<DiaryEntry>('/create-diary');

    if (result != null) {
      setState(() {
        _entries.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        title: Text(
          'My Virtual Diary',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: color3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Header
            Text(
              'Keluh Kesahku',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color5,
              ),
            ),
            Divider(thickness: 1, height: 20),
            SizedBox(height: 10),
            // Diary list
            ..._entries.map((entry) => _buildDiaryCard(entry)),

            // Sharing Section
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: _navigateToCreateDiary,
          backgroundColor: color7,
          elevation: 5,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  Widget _buildDiaryCard(DiaryEntry entry) {
    return Card(
      color: color8,
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  entry.date,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(entry.content),
          ],
        ),
      ),
    );
  }
}

class CreateDiaryScreen extends StatefulWidget {
  const CreateDiaryScreen({super.key});

  @override
  State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String get _currentDate {
    return DateFormat('d MMMM y', 'id_ID').format(DateTime.now());
  }

  String selectedEmoji = '😊';

  OverlayEntry? _emojiOverlayEntry;

  void showEmojiOverlay(BuildContext context, Offset position) {
    // Remove overlay lama dulu kalau ada
    _emojiOverlayEntry?.remove();
    _emojiOverlayEntry = null;

    final overlay = Overlay.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = 220;
    final calculatedLeft = position.dx - (popupWidth / 2);

    final double safeLeft =
        calculatedLeft < 10
            ? 10
            : (calculatedLeft + popupWidth > screenWidth - 10
                ? screenWidth - popupWidth - 10
                : calculatedLeft);

    _emojiOverlayEntry = OverlayEntry(
      builder:
          (_) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Tutup overlay kalau tap di luar popup
              _emojiOverlayEntry?.remove();
              _emojiOverlayEntry = null;
            },
            child: Stack(
              children: [
                Positioned(
                  left: safeLeft,
                  top: position.dy + 10,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: popupWidth.toDouble(),
                      height: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              [
                                '😊',
                                '😢',
                                '😡',
                                '🥰',
                                '😎',
                                '😴',
                                '😭',
                                '😃',
                                '🤔',
                                '😁',
                                '😅',
                                '🤯',
                                '🤗',
                                '🫠',
                                '😇',
                                '🥲',
                              ].map((emoji) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedEmoji = emoji;
                                    });
                                    _emojiOverlayEntry?.remove();
                                    _emojiOverlayEntry = null;
                                  },
                                  child: Text(
                                    emoji,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    overlay.insert(_emojiOverlayEntry!);
  }

  void _saveDiary() {
    if (_formKey.currentState!.validate()) {
      final newEntry = DiaryEntry(
        title: _titleController.text,
        content: _contentController.text,
        date: _currentDate,
      );

      GoRouter.of(context).pop(newEntry); // Kembalikan data
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        title: Text(
          'Buat Diary Baru',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CustomButton(
              text: 'SIMPAN',
              onPressed: _saveDiary,
              backgroundColor: Colors.lightBlueAccent,
              textColor: Colors.white,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (details) {
                      if (_emojiOverlayEntry != null) {
                        // Kalau overlay sudah ada, tutup dulu
                        _emojiOverlayEntry?.remove();
                        _emojiOverlayEntry = null;
                      } else {
                        // Kalau belum ada, buka overlay baru
                        final position = details.globalPosition;
                        showEmojiOverlay(context, position);
                      }
                    },
                    child: Text(
                      selectedEmoji,
                      style: TextStyle(fontSize: 28, color: Colors.orange),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Judul',
                  border: InputBorder.none,
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Harap isi judul'
                            : null,
              ),
              SizedBox(height: 10),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Tulis lebih banyak di sini...',
                    alignLabelWithHint: false,
                    border: InputBorder.none, // Hilangkan border
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Harap isi konten diary'
                              : null,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
