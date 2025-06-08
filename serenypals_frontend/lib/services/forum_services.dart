// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:serenypals_frontend/models/post.dart';
import 'package:serenypals_frontend/repositories/forum_repository.dart'; // Import interface ForumRepository

class ForumApiService implements ForumRepository {
  // Ganti ini dengan URL API Anda yang sebenarnya
  // final String _baseUrl = 'https://your-api-domain.com/api/v1/forum';

  // Simulasi data in-memory karena belum ada API backend
  // Dalam aplikasi nyata, ini akan diambil dari server
  final List<Post> _mockPosts = [
    Post(
      id: '1',
      title: 'Selamat datang di Forum!',
      content: 'Mari bagikan pengalaman dan pikiranmu di sini.',
      likes: 10,
      comments: 2,
      isLiked: false,
    ),
    Post(
      id: '2',
      title: 'Tips Produktivitas',
      content: 'Bagaimana cara kamu tetap produktif di tengah kesibukan?',
      likes: 5,
      comments: 1,
      isLiked: true,
    ),
  ];

  // Method untuk mengambil semua postingan
  @override
  Future<List<Post>> fetchAllPosts() async {
    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Dalam aplikasi nyata, Anda akan melakukan panggilan HTTP
    /*
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
    */
    return _mockPosts; // Mengembalikan data simulasi
  }

  // Method untuk menambahkan postingan baru
  @override
  Future<Post> addPost(Post newPost) async {
    // Simulasi penundaan jaringan
    await Future.delayed(
        const Duration(seconds: 5)); // Menunda 5 detik untuk simulasi

    // Dalam aplikasi nyata, Anda akan melakukan panggilan HTTP POST
    /*
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newPost.toJson()),
    );

    if (response.statusCode == 201) { // 201 Created
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add post');
    }
    */

    // Tambahkan ID unik untuk simulasi
    final addedPost = newPost.copyWith(
        id: (DateTime.now().millisecondsSinceEpoch).toString());
    _mockPosts.insert(0, addedPost); // Tambahkan ke daftar simulasi
    return addedPost;
  }

  // Method untuk memperbarui postingan (misalnya, toggle like, tambah komentar)
  @override
  Future<Post> updatePost(Post updatedPost) async {
    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Dalam aplikasi nyata, Anda akan melakukan panggilan HTTP PUT atau PATCH
    /*
    final response = await http.put(
      Uri.parse('$_baseUrl/${updatedPost.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedPost.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update post');
    }
    */

    final index = _mockPosts.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      _mockPosts[index] = updatedPost; // Perbarui di daftar simulasi
    }
    return updatedPost;
  }
}
