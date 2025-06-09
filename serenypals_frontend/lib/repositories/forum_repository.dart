import 'package:serenypals_frontend/models/post.dart';

abstract class ForumRepository {
  Future<List<Post>> fetchAllPosts();
  Future<Post> addPost(Post newPost);
  Future<Post> updatePost(Post updatedPost);
  Future<void> deletePost(String postId); // Tambahkan ini
  // Bisa ditambah: getPostById, dsb.
}
