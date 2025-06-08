import 'package:equatable/equatable.dart';
import '../../models/post.dart'; // Sesuaikan path

abstract class ForumEvent extends Equatable {
  const ForumEvent();

  @override
  List<Object> get props => [];
}

// Event dasar yang sudah ada:
class AddPostEvent extends ForumEvent {
  final Post newPost;
  const AddPostEvent(this.newPost);
  @override
  List<Object> get props => [newPost];
}

class ToggleLikePostEvent extends ForumEvent {
  final Post post;
  const ToggleLikePostEvent(this.post);
  @override
  List<Object> get props => [post];
}

class AddCommentEvent extends ForumEvent {
  final Post post;
  final String commentText;
  const AddCommentEvent(this.post, this.commentText);
  @override
  List<Object> get props => [post, commentText];
}

class AddNotificationEvent extends ForumEvent {
  final String message;
  const AddNotificationEvent(this.message);
  @override
  List<Object> get props => [message];
}

// --- Event Baru yang Mungkin Anda Butuhkan ---

// Event untuk memuat data awal forum (misalnya saat aplikasi pertama kali dibuka)
class LoadForumData extends ForumEvent {
  const LoadForumData();
}

// Event untuk menyegarkan data forum (misalnya untuk pull-to-refresh)
class RefreshForumData extends ForumEvent {
  const RefreshForumData();
}

// Event untuk menghapus postingan (jika ada fitur hapus postingan)
class DeletePostEvent extends ForumEvent {
  final Post postToDelete;
  const DeletePostEvent(this.postToDelete);
  @override
  List<Object> get props => [postToDelete];
}

// Event untuk mengedit postingan (jika ada fitur edit postingan)
class EditPostEvent extends ForumEvent {
  final Post originalPost;
  final Post updatedPost; // Post dengan data yang sudah diubah
  const EditPostEvent({required this.originalPost, required this.updatedPost});
  @override
  List<Object> get props => [originalPost, updatedPost];
}

// Event untuk menandai notifikasi sudah dibaca (jika ada status baca notifikasi)
class MarkNotificationAsRead extends ForumEvent {
  final String notificationId; // ID unik untuk notifikasi
  const MarkNotificationAsRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

// Event untuk memfilter postingan (misalnya berdasarkan kategori atau tag)
// Jika Anda ingin menerapkan fitur filter
class FilterPostsEvent extends ForumEvent {
  final String? category; // Contoh filter berdasarkan kategori
  final String? searchTerm; // Contoh filter berdasarkan kata kunci pencarian

  const FilterPostsEvent({this.category, this.searchTerm});

  @override
  List<Object> get props => [category ?? '', searchTerm ?? ''];
}

// Event untuk memuat lebih banyak postingan (jika Anda menerapkan pagination/lazy loading)
class LoadMorePosts extends ForumEvent {
  const LoadMorePosts();
}
