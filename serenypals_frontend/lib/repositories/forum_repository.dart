import 'package:serenypals_frontend/models/post.dart';

abstract class ForumRepository {
  Future<List<Post>> fetchAllPosts();
  Future<Post> addPost(Post newPost);
  Future<Post> updatePost(Post updatedPost);
  // Anda bisa menambahkan method lain seperti deletePost, addComment, dll.
}
