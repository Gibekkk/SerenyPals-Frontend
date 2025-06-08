import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/forum/forum_bloc.dart';
import '../../blocs/forum/forum_state.dart';
import 'add_forum_screen.dart';
import '../../widget/my_forum.dart';
import '../../widget/notification.dart';
import '../../widget/forum_content.dart';

class SharingForumScreen extends StatefulWidget {
  const SharingForumScreen({super.key});

  @override
  _SharingForumScreenState createState() => _SharingForumScreenState();
}

class _SharingForumScreenState extends State<SharingForumScreen> {
  String _currentPage = 'Sharing Forum';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPage),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Forums',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Postingan Saya'),
              onTap: () {
                setState(() {
                  _currentPage = 'Postingan Saya';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifikasi'),
              onTap: () {
                setState(() {
                  _currentPage = 'Notifikasi';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildBodyContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddForumScreen()),
          );
        },
        backgroundColor: Colors.blue.shade200,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBodyContent() {
    return BlocBuilder<ForumBloc, ForumState>(
      builder: (context, state) {
        switch (_currentPage) {
          case 'Sharing Forum':
            if (state.allPosts.isEmpty) {
              return Center(
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
              return Center(
                child: Text(
                  'Kamu belum membuat postingan apa pun.\nAyo buat postingan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return MyPostsContent(posts: state.myPosts);
          case 'Notifikasi':
            return NotificationsContent(
              notifications: state.notifications,
            );
          default:
            return Center(child: Text('Halaman tidak ditemukan'));
        }
      },
    );
  }
}
