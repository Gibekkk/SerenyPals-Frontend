import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/utils/color.dart';

import '../../blocs/diary/diary_bloc.dart';
import '../../blocs/diary/diary_event.dart';
import '../../blocs/diary/diary_state.dart';
import '../../models/diary.dart';
import '../../widget/custom_button.dart';

class MyDiaryPage extends StatefulWidget {
  const MyDiaryPage({super.key});

  @override
  State<MyDiaryPage> createState() => _MyDiaryPageState();
}

class _MyDiaryPageState extends State<MyDiaryPage> {
  @override
  void initState() {
    super.initState();
    context.read<VirtualDiaryBloc>().add(const LoadDiaryEntries());
  }

  void _navigateToCreateDiary() {
    context.push('/create-diary');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        title: const Text(
          'My Virtual Diary',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: color3,
        elevation: 0,
      ),
      body: BlocConsumer<VirtualDiaryBloc, VirtualDiaryState>(
        listener: (context, state) {
          if (state is VirtualDiaryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is VirtualDiaryLoading || state is VirtualDiaryInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VirtualDiaryError) {
            return Center(child: Text('Gagal memuat diary: ${state.message}'));
          } else if (state is VirtualDiaryLoaded) {
            if (state.entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum ada entri diary.\nAyo buat yang pertama!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Buat Diary Baru',
                      onPressed: _navigateToCreateDiary,
                      backgroundColor: color7,
                      textColor: Colors.white,
                      borderRadius: 10,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    'Keluh Kesahku',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color5,
                    ),
                  ),
                  const Divider(thickness: 1, height: 20),
                  const SizedBox(height: 10),
                  ...state.entries
                      .map((entry) => _buildDiaryCard(context, entry))
                      .toList(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return const Center(child: Text('State Tidak Dikenal'));
        },
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

  Widget _buildDiaryCard(BuildContext context, DiaryEntry entry) {
    return Card(
      color: color8,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'editDiary',
            pathParameters: {'id': entry.id},
            extra: entry, // ✅ HARUS ADA!
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${entry.selectedEmoji} ${entry.title}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    entry.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context
                          .read<VirtualDiaryBloc>()
                          .add(DeleteDiaryEntry(entry.id));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entry.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
    _emojiOverlayEntry?.remove();
    _emojiOverlayEntry = null;

    final overlay = Overlay.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const popupWidth = 220;
    final calculatedLeft = position.dx - (popupWidth / 2);

    final double safeLeft = calculatedLeft < 10
        ? 10
        : (calculatedLeft + popupWidth > screenWidth - 10
            ? screenWidth - popupWidth - 10
            : calculatedLeft);

    _emojiOverlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
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
                      children: const [
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
                            style: const TextStyle(fontSize: 30),
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
        id: '',
        title: _titleController.text,
        content: _contentController.text,
        date: _currentDate,
        selectedEmoji: selectedEmoji,
        timestamp: DateTime.now(),
      );

      context.read<VirtualDiaryBloc>().add(AddDiaryEntry(newEntry));
      context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _emojiOverlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        title: const Text(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (details) {
                      if (_emojiOverlayEntry != null) {
                        _emojiOverlayEntry?.remove();
                        _emojiOverlayEntry = null;
                      } else {
                        final position = details.globalPosition;
                        showEmojiOverlay(context, position);
                      }
                    },
                    child: Text(
                      selectedEmoji,
                      style:
                          const TextStyle(fontSize: 28, color: Colors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Judul',
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Harap isi judul' : null,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Tulis lebih banyak di sini...',
                    alignLabelWithHint: false,
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Harap isi konten diary'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
