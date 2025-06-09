import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/diary/diary_bloc.dart';
import '../../blocs/diary/diary_event.dart';
import '../../blocs/diary/diary_state.dart';
import '../../models/diary.dart';
import '../../utils/color.dart';
import '../../widget/custom_button.dart';

class EditDiaryScreen extends StatefulWidget {
  final DiaryEntry entry;

  const EditDiaryScreen({super.key, required this.entry});

  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late String selectedEmoji;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _contentController = TextEditingController(text: widget.entry.content);
    selectedEmoji = widget.entry.selectedEmoji;
  }

  void _updateDiary() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUpdating = true;
      });

      final updatedEntry = widget.entry.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        selectedEmoji: selectedEmoji,
        timestamp: DateTime.now(),
      );

      context.read<VirtualDiaryBloc>().add(UpdateDiaryEntry(updatedEntry));

      // Tidak perlu pop di sini, biarkan BlocListener yang menangani navigasi
    }
  }

  String get _currentDate {
    return DateFormat('d MMMM y', 'id_ID').format(DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _emojiOverlayEntry?.remove();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<VirtualDiaryBloc, VirtualDiaryState>(
      listener: (context, state) {
        if (state is VirtualDiaryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          setState(() {
            _isUpdating = false;
          });
        }
        // Ketika update berhasil dan state sudah diupdate
        else if (state is VirtualDiaryLoaded && _isUpdating) {
          GoRouter.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: color3,
        appBar: AppBar(
          title: const Text(
            'Buat Diary Baru',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            _isUpdating
                ? const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: CircularProgressIndicator(),
                  )
                : CustomButton(
                    text: 'UPDATE',
                    onPressed: _updateDiary,
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white,
                    borderRadius: 10,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    fontWeight: FontWeight.w700,
                  ),
          ],
          // ... (bagian body yang sama)
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
      ),
    );
  }
}
