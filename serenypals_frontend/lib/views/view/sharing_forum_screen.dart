import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/views/view/sharingforum.dart' as post_card;
import '../../blocs/forum/forum_state.dart';
import '../../blocs/forum/forum_bloc.dart';
import 'sharingforum.dart';

class SharingForumScreen extends StatefulWidget {
  const SharingForumScreen({super.key});

  @override
  State<SharingForumScreen> createState() => _SharingForumScreenState();
}

class _SharingForumScreenState extends State<SharingForumScreen> {
  String _currentPage = 'Sharing Forum';

  @override
  void initState() {
    super.initState();
    context.read<ForumCubit>().loadForumData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentPage)),
      drawer: _buildDrawer(),
      body: _buildBodyContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddForumScreen()),
          );
        },
        backgroundColor: Colors.blue.shade200,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Forums',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Postingan Saya'),
            onTap: () {
              setState(() {
                _currentPage = 'Postingan Saya';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            onTap: () {
              setState(() {
                _currentPage = 'Notifikasi';
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    return BlocBuilder<ForumCubit, ForumState>(
      builder: (context, state) {
        if (state is ForumLoaded) {
          final posts = state.allPosts;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return post_card.PostCard(post: posts[index]);
            },
          );
        } else if (state is ForumLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ForumError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox(); // atau bisa juga Center(child: Text("No data yet"))
        }
      },
    );
  }

  Widget _buildForumContent(List<Post> posts) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          _currentPage == 'Sharing Forum'
              ? 'Belum ada postingan di forum ini.\nAyo buat postingan pertamamu!'
              : 'Kamu belum membuat postingan apa pun.\nAyo buat postingan!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: post_card.PostCard(post: posts[index]),
        );
      },
    );
  }

  Widget _buildNotificationsContent(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada notifikasi.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10.0),
          color: Colors.blue.shade50,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} detik lalu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
