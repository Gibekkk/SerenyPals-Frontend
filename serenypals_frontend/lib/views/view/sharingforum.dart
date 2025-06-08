// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Import Provider

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ForumProvider(), // Inisialisasi ForumProvider
//       child: MyApp(),
//     ),
//   );
// }

// // --- Model Data Postingan ---
// class Post {
//   String title; // Tambahkan judul
//   String content; // Konten sharing
//   int likes;
//   int comments;
//   bool isLiked;

//   Post({
//     required this.title,
//     required this.content,
//     this.likes = 0,
//     this.comments = 0,
//     this.isLiked = false,
//   });
// }

// // --- Model Notifikasi ---
// class NotificationItem {
//   String message;
//   DateTime timestamp;

//   NotificationItem({required this.message, required this.timestamp});
// }

// // --- ForumProvider (Manajemen State Global) ---
// class ForumProvider extends ChangeNotifier {
//   // Inisialisasi daftar postingan sebagai daftar kosong
//   final List<Post> _allPosts = [];
//   final List<Post> _myPosts = [];

//   // Daftar notifikasi
//   final List<NotificationItem> _notifications = [];

//   List<Post> get allPosts => _allPosts;
//   List<Post> get myPosts => _myPosts;
//   List<NotificationItem> get notifications => _notifications;

//   // Menambah postingan baru
//   void addPost(Post newPost) {
//     _allPosts.insert(0, newPost); // Tambahkan di paling atas
//     _myPosts.insert(
//       0,
//       newPost,
//     ); // Asumsikan postingan baru masuk ke "Postingan Saya"
//     notifyListeners(); // Beri tahu widget yang mendengarkan untuk di-rebuild
//   }

//   // Menambah notifikasi
//   void addNotification(String message) {
//     _notifications.insert(
//       0,
//       NotificationItem(message: message, timestamp: DateTime.now()),
//     );
//     notifyListeners(); // Beri tahu widget yang mendengarkan untuk di-rebuild
//   }

//   // Mengupdate postingan (misal: saat like/komentar)
//   void updatePost(Post updatedPost) {
//     notifyListeners(); // Perlu ini agar ListView di SharingForumContent/MyPostsContent di-rebuild
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sharing Forum',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         scaffoldBackgroundColor:
//             Colors.orange.shade50, // Warna latar belakang global (sesuai Figma)
//         // >>> PERUBAHAN DI SINI: AppBarTheme diperbarui <<<
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.blue.shade100, // Warna biru muda untuk AppBar
//           foregroundColor:
//               Colors.black87, // Warna teks di AppBar (hampir hitam)
//           elevation: 0, // Menghilangkan shadow di AppBar
//           iconTheme: IconThemeData(
//             color: Colors.black87,
//           ), // Warna ikon di AppBar (misal: hamburger menu, back button)
//         ),
//         // >>> AKHIR PERUBAHAN <<<
//       ),
//       home: SharingForumScreen(),
//     );
//   }
// }

// class SharingForumScreen extends StatefulWidget {
//   @override
//   _SharingForumScreenState createState() => _SharingForumScreenState();
// }

// class _SharingForumScreenState extends State<SharingForumScreen> {
//   String _currentPage = 'Sharing Forum'; // To manage the main content area

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_currentPage),
//         // Tidak perlu lagi backgroundColor dan elevation di sini, sudah diatur di Theme
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue, // Warna biru untuk header drawer
//               ),
//               child: Text(
//                 'Forums',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.article), // Icon for 'Postingan Saya'
//               title: Text('Postingan Saya'),
//               onTap: () {
//                 setState(() {
//                   _currentPage = 'Postingan Saya';
//                 });
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.notifications), // Icon for 'Notifikasi'
//               title: Text('Notifikasi'),
//               onTap: () {
//                 setState(() {
//                   _currentPage = 'Notifikasi';
//                 });
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             // You can add more list tiles for other menu items here
//           ],
//         ),
//       ),
//       body: _buildBodyContent(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddForumScreen()),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue.shade200, // Warna tombol plus
//       ),
//     );
//   }

//   Widget _buildBodyContent() {
//     // Gunakan Consumer untuk mendapatkan data dari ForumProvider
//     return Consumer<ForumProvider>(
//       builder: (context, forumProvider, child) {
//         switch (_currentPage) {
//           case 'Sharing Forum':
//             // Tampilkan pesan jika tidak ada postingan
//             if (forumProvider.allPosts.isEmpty) {
//               return Center(
//                 child: Text(
//                   'Belum ada postingan di forum ini.\nAyo buat postingan pertamamu!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               );
//             }
//             return SharingForumContent(posts: forumProvider.allPosts);
//           case 'Postingan Saya':
//             // Tampilkan pesan jika tidak ada postingan saya
//             if (forumProvider.myPosts.isEmpty) {
//               return Center(
//                 child: Text(
//                   'Kamu belum membuat postingan apa pun.\nAyo buat postingan!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               );
//             }
//             return MyPostsContent(posts: forumProvider.myPosts);
//           case 'Notifikasi':
//             return NotificationsContent(
//               notifications: forumProvider.notifications,
//             );
//           default:
//             return Center(child: Text('Halaman tidak ditemukan'));
//         }
//       },
//     );
//   }
// }

// // --- Content Widgets for each section ---
// class SharingForumContent extends StatelessWidget {
//   final List<Post> posts;

//   const SharingForumContent({Key? key, required this.posts}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: PostCard(post: posts[index]), // Meneruskan objek Post
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MyPostsContent extends StatelessWidget {
//   final List<Post> posts;

//   const MyPostsContent({Key? key, required this.posts}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: PostCard(post: posts[index]), // Meneruskan objek Post
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class NotificationsContent extends StatelessWidget {
//   final List<NotificationItem> notifications;

//   const NotificationsContent({Key? key, required this.notifications})
//     : super(key: key);

//   // Helper untuk format waktu
//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inSeconds < 60) {
//       return '${difference.inSeconds} detik lalu';
//     } else if (difference.inMinutes < 60) {
//       return '${difference.inMinutes} menit lalu';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours} jam lalu';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays} hari lalu';
//     } else {
//       return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (notifications.isEmpty) {
//       return Center(
//         child: Text(
//           'Belum ada notifikasi.',
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       );
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: notifications.length,
//       itemBuilder: (context, index) {
//         final notification = notifications[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 10.0),
//           color: Colors.blue.shade50,
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   notification.message,
//                   style: TextStyle(fontSize: 16, color: Colors.black87),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   _formatTimestamp(notification.timestamp),
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // --- Reusable PostCard Widget (STATEFUL + Menggunakan Consumer) ---
// class PostCard extends StatefulWidget {
//   final Post post;

//   const PostCard({Key? key, required this.post}) : super(key: key);

//   @override
//   _PostCardState createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   bool _showCommentInput = false;
//   final TextEditingController _commentController = TextEditingController();

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ForumProvider>(
//       builder: (context, forumProvider, child) {
//         return Card(
//           elevation: 2.0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           color: Colors.blue.shade50, // Light blue background for the card
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.post.title, // Tampilkan judul postingan
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 5.0),
//                 Text(
//                   widget.post.content, // Tampilkan konten postingan
//                   style: TextStyle(fontSize: 16.0, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10.0),
//                 Row(
//                   children: [
//                     // Icon Hati (Like)
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           widget.post.isLiked =
//                               !widget.post.isLiked; // Toggle like status
//                           if (widget.post.isLiked) {
//                             widget.post.likes++;
//                             forumProvider.addNotification(
//                               'Postinganmu "${widget.post.title}" disukai.',
//                             );
//                           } else {
//                             widget.post.likes--;
//                           }
//                           forumProvider.updatePost(
//                             widget.post,
//                           ); // Beri tahu provider ada update
//                         });
//                       },
//                       child: Icon(
//                         widget.post.isLiked
//                             ? Icons.favorite
//                             : Icons.favorite_border,
//                         size: 20,
//                         color:
//                             widget.post.isLiked
//                                 ? Colors.red
//                                 : Colors.grey, // Warna hati
//                       ),
//                     ),
//                     SizedBox(width: 4.0),
//                     Text(
//                       '${widget.post.likes >= 1000 ? (widget.post.likes / 1000).toStringAsFixed(0) + 'k' : widget.post.likes}',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     SizedBox(width: 16.0),
//                     // Icon Komentar
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _showCommentInput =
//                               !_showCommentInput; // Tampilkan/sembunyikan input komentar
//                         });
//                       },
//                       child: Icon(
//                         Icons.comment_outlined,
//                         size: 20,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(width: 4.0),
//                     Text(
//                       '${widget.post.comments >= 1000 ? (widget.post.comments / 1000).toStringAsFixed(0) + 'k' : widget.post.comments}',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 if (_showCommentInput) // Tampilkan input komentar jika _showCommentInput true
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _commentController,
//                             decoration: InputDecoration(
//                               hintText: 'Tulis komentar...',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               fillColor:
//                                   Colors
//                                       .white, // Background putih untuk input komentar
//                               filled: true,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_commentController.text.isNotEmpty) {
//                               String commentText =
//                                   _commentController
//                                       .text; // Ambil teks komentar
//                               setState(() {
//                                 widget
//                                     .post
//                                     .comments++; // Tambah jumlah komentar
//                                 _commentController.clear(); // Bersihkan input
//                                 _showCommentInput = false; // Sembunyikan input
//                                 forumProvider.updatePost(
//                                   widget.post,
//                                 ); // Beri tahu provider ada update
//                               });

//                               // Notifikasi SnackBar (opsional, karena juga masuk ke page notifikasi)
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     'Komentar berhasil ditambahkan!',
//                                   ),
//                                   duration: Duration(seconds: 1),
//                                 ),
//                               );

//                               // Tambahkan notifikasi ke ForumProvider
//                               String notificationMessage;
//                               if (widget.post.comments == 1) {
//                                 notificationMessage =
//                                     'Postinganmu "${widget.post.title}" mendapatkan 1 komentar: "$commentText"';
//                               } else {
//                                 notificationMessage =
//                                     'Postinganmu "${widget.post.title}" mendapatkan ${widget.post.comments} komentar. Komentar terbaru: "$commentText"';
//                               }
//                               forumProvider.addNotification(
//                                 notificationMessage,
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade100,
//                             foregroundColor: Colors.black87,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               vertical: 10,
//                               horizontal: 15,
//                             ),
//                           ),
//                           child: Text('Kirim'),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // --- AddForumScreen ---
// class AddForumScreen extends StatefulWidget {
//   @override
//   _AddForumScreenState createState() => _AddForumScreenState();
// }

// class _AddForumScreenState extends State<AddForumScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Forum'),
//         // Tidak perlu lagi backgroundColor dan elevation di sini, sudah diatur di Theme
//       ),
//       body: Container(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Apa yang mau kamu bagikan hari ini?',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 32),
//               Text('Judul'),
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   hintText: 'Tulis judul...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide(color: Colors.grey.shade400),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide(color: Colors.grey.shade400),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 8.0,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//               Text('Konten Sharing'),
//               Expanded(
//                 child: TextField(
//                   controller: _contentController,
//                   maxLines: null,
//                   expands: true,
//                   textAlignVertical: TextAlignVertical.top,
//                   decoration: InputDecoration(
//                     hintText: 'Tulis konten sharing...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide(color: Colors.grey.shade400),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     filled: true,
//                     fillColor: Colors.blue.shade50,
//                     contentPadding: EdgeInsets.all(12.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_titleController.text.isEmpty ||
//                           _contentController.text.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               'Judul dan konten tidak boleh kosong!',
//                             ),
//                           ),
//                         );
//                         return;
//                       }

//                       // Dapatkan instance ForumProvider
//                       final forumProvider = Provider.of<ForumProvider>(
//                         context,
//                         listen: false,
//                       );

//                       // Buat postingan baru dengan 0 like dan 0 komentar
//                       final newPost = Post(
//                         title: _titleController.text,
//                         content: _contentController.text,
//                         likes: 0,
//                         comments: 0,
//                         isLiked: false,
//                       );

//                       forumProvider.addPost(
//                         newPost,
//                       ); // Tambahkan postingan melalui provider

//                       Navigator.pop(context); // Tutup AddForumScreen
//                       Navigator.push(
//                         // Navigasi ke Verifikasi
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddForumVerificationScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade100,
//                       foregroundColor: Colors.black87,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text('Post', style: TextStyle(fontSize: 18)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- AddForumVerificationScreen ---
// class AddForumVerificationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Forum - Verifikasi'),
//         // Tidak perlu lagi backgroundColor dan elevation di sini, sudah diatur di Theme
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.popUntil(context, (route) => route.isFirst);
//           },
//         ),
//       ),
//       body: Container(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Terima kasih atas sharing\nyang kamu lakukan ^_^',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 40),
//                 Image.asset(
//                   'assets/capybara.png', // Pastikan path ini benar!
//                   width: 200,
//                   height: 200,
//                 ),
//                 SizedBox(height: 40),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.popUntil(context, (route) => route.isFirst);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade100,
//                       foregroundColor: Colors.black87,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text('OK', style: TextStyle(fontSize: 18)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
