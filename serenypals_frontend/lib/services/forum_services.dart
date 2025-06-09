import 'dart:async';
import 'package:serenypals_frontend/models/post.dart';
import 'package:serenypals_frontend/repositories/forum_repository.dart';

class ForumApiService implements ForumRepository {
  // Gunakan List<Post> non-final agar bisa diubah
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

  @override
  Future<List<Post>> fetchAllPosts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasikan delay API
    return List<Post>.from(_mockPosts); // return salinan
  }

  @override
  Future<Post> addPost(Post newPost) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasikan delay API
    final postWithId = newPost.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate ID unik
      timestamp: DateTime.now(), // Tambahkan timestamp
    );
    _mockPosts.insert(0, postWithId); // Tambahkan di awal daftar
    return postWithId;
  }

  @override
  Future<Post> updatePost(Post updatedPost) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockPosts.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      _mockPosts[index] = updatedPost;
      return updatedPost;
    }
    throw Exception('Postingan tidak ditemukan untuk diperbarui');
  }

  @override
  Future<void> deletePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockPosts.removeWhere((p) => p.id == postId);
  }
}
