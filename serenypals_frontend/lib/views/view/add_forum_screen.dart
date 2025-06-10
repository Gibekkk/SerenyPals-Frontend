import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/forum/forum_bloc.dart';
import '../../blocs/forum/forum_event.dart';
import '../../blocs/forum/forum_state.dart'; // Diperlukan untuk mendengarkan state
import '../../models/post.dart';
import '../../utils/color.dart'; // Pastikan path ini benar

class AddForumScreen extends StatefulWidget {
  const AddForumScreen({super.key});

  @override
  State<AddForumScreen> createState() => _AddForumScreenState();
}

class _AddForumScreenState extends State<AddForumScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isSubmitting = false; // State untuk mengelola status loading tombol

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost(BuildContext context) {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan konten tidak boleh kosong!'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Set loading saat mulai submit
    });

    final newPost = Post(
      id: '', // ID akan di-generate oleh ForumApiService
      title: _titleController.text,
      content: _contentController.text,
      likes: 0,
      comments: const [],
      isLiked: false,
    );

    // Kirim event AddPostEvent ke ForumBloc
    context.read<ForumBloc>().add(AddPostEvent(newPost));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForumBloc, ForumState>(
      listener: (context, state) async {
        if (state is AddPostSuccess) {
          setState(() {
            _isSubmitting = false;
          });

          // Tunggu sebentar agar UI sempat memperbarui state
          await Future.delayed(const Duration(milliseconds: 300));

          context.go('/forum/verify');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Postingan berhasil ditambahkan!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is ForumError) {
          setState(() {
            _isSubmitting = false; // Hentikan loading
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan postingan: ${state.message}'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: color4, // Menggunakan warna dari utils/color.dart
        appBar: AppBar(
          title: const Text('Add Forum'),
          centerTitle: true,
          backgroundColor: color3, // Menggunakan warna dari utils/color.dart
        ),
        body: Container(
          color:
              color4, // Sesuaikan dengan warna latar belakang yang diinginkan
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Apa yang mau kamu bagikan hari ini?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    hintText: 'Mis: Resensi Buku, Curhat Singkat, dll.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(12.0),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null, // Memungkinkan banyak baris
                    expands: true, // Akan memenuhi ruang yang tersedia
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      labelText: 'Konten',
                      hintText: 'Tuliskan isi postinganmu di sini...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isSubmitting ? null : () => _submitPost(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black87,
                              ),
                            )
                          : const Text('Post', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
