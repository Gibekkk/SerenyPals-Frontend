import 'package:equatable/equatable.dart';
import '../../models/post.dart';
import '../../models/notification_item.dart';

abstract class ForumState extends Equatable {
  final List<Post> allPosts;
  final List<Post> myPosts;
  final List<NotificationItem> notifications;

  const ForumState({
    this.allPosts = const [],
    this.myPosts = const [],
    this.notifications = const [],
  });

  @override
  List<Object> get props => [allPosts, myPosts, notifications];
}

class ForumInitial extends ForumState {}

// Sertakan data yang sudah ada saat loading untuk pengalaman pengguna yang lebih baik
class ForumLoading extends ForumState {
  const ForumLoading({
    super.allPosts,
    super.myPosts,
    super.notifications,
  });
}

class ForumLoaded extends ForumState {
  const ForumLoaded({
    required super.allPosts,
    required super.myPosts,
    required super.notifications,
  });
}

class ForumError extends ForumState {
  final String message;
  const ForumError(this.message)
      : super(); // Error tanpa mengubah data yang ada

  @override
  List<Object> get props => [
        message,
        allPosts,
        myPosts,
        notifications
      ]; // Sertakan data lama saat error
}

// State baru untuk penanganan sukses dan gagal posting
class AddPostSuccess extends ForumLoaded {
  final Post addedPost;

  const AddPostSuccess({
    required this.addedPost,
    required List<Post> allPosts,
    required List<Post> myPosts,
    required List<NotificationItem> notifications,
  }) : super(
          allPosts: allPosts,
          myPosts: myPosts,
          notifications: notifications,
        );

  @override
  List<Object> get props => [addedPost, allPosts, myPosts, notifications];
}

class AddPostFailure extends ForumLoaded {
  // Bisa juga extend ForumError jika tidak perlu data
  final String message;
  const AddPostFailure({
    required this.message,
    required super.allPosts,
    required super.myPosts,
    required super.notifications,
  });

  @override
  List<Object> get props => [message, allPosts, myPosts, notifications];
}
