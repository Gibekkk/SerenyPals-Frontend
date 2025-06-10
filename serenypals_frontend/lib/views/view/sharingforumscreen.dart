import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/forum/forum_bloc.dart';
import '../../blocs/forum/forum_event.dart'; // Diperlukan untuk RefreshForumData
import '../../blocs/forum/forum_state.dart';
import '../../utils/color.dart'; // Pastikan path ini benar
import '../../widget/forum_content.dart'; // Pastikan path ini benar
import '../../widget/my_forum.dart'; // Pastikan path ini benar
import '../../widget/notification.dart'; // Pastikan path ini benar

class SharingForumScreen extends StatefulWidget {
  const SharingForumScreen({super.key});

  @override
  State<SharingForumScreen> createState() => _SharingForumScreenState();
}

class _SharingForumScreenState extends State<SharingForumScreen> {
  String _currentPage =
      'Sharing Forum'; // State untuk mengelola tampilan saat ini

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForumBloc, ForumState>(
      listenWhen: (previous, current) => current is AddPostSuccess,
      listener: (context, state) {
        if (state is AddPostSuccess) {
          context.read<ForumBloc>().add(LoadForumData());
        }
      },
      child: Scaffold(
        backgroundColor: color4,
        appBar: AppBar(
          title: Text(_currentPage),
          backgroundColor: color3,
        ),
        drawer: Drawer(
          backgroundColor: color4,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: color7),
                child: const Text(
                  'Sharing Forum',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.forum),
                title: const Text('Forum Sharing'),
                onTap: () {
                  setState(() => _currentPage = 'Sharing Forum');
                  Navigator.pop(context); // Tutup drawer
                  // Panggil event untuk menyegarkan data semua postingan jika dibutuhkan saat pindah tab
                  context.read<ForumBloc>().add(RefreshForumData());
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Postingan Saya'),
                onTap: () {
                  setState(() => _currentPage = 'Postingan Saya');
                  Navigator.pop(context); // Tutup drawer
                  // Panggil event untuk menyegarkan data postingan saya jika dibutuhkan saat pindah tab
                  context.read<ForumBloc>().add(
                      RefreshForumData()); // Atau event spesifik seperti LoadMyPostsData()
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifikasi'),
                onTap: () {
                  setState(() => _currentPage = 'Notifikasi');
                  Navigator.pop(context); // Tutup drawer
                  // Panggil event untuk memuat notifikasi jika ada
                },
              ),
            ],
          ),
        ),
        body: _buildBodyContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigasi ke halaman tambah forum
            context.go('/forum/add'); // Pastikan rute ini benar di GoRouter
          },
          backgroundColor: Colors.blue.shade200,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return BlocBuilder<ForumBloc, ForumState>(
      builder: (context, state) {
        // Tangani state loading secara lebih umum
        if (state is ForumLoading &&
            (state.allPosts.isEmpty && state.myPosts.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }
        // Tangani state error
        if (state is ForumError) {
          return Center(
            child: Text(
              'Error: ${state.message}\nKetuk untuk mencoba lagi.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        // Tampilkan konten berdasarkan _currentPage dan state
        switch (_currentPage) {
          case 'Sharing Forum':
            // Jika data belum dimuat atau kosong
            if (state.allPosts.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada postingan di forum ini.\nAyo buat postingan pertamamu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return SharingForumContent(posts: state.allPosts);

          case 'Postingan Saya':
            if (state.myPosts.isEmpty) {
              return const Center(
                child: Text(
                  'Kamu belum membuat postingan apa pun.\nAyo buat postingan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return MyPostsContent(posts: state.myPosts);

          case 'Notifikasi':
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada notifikasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return NotificationsContent(notifications: state.notifications);

          default:
            return const Center(child: Text('Halaman tidak ditemukan'));
        }
      },
    );
  }
}
