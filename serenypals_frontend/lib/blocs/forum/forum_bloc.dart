import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/notification.dart';
import '../../models/post.dart';
import 'forum_state.dart';

class ForumCubit extends Cubit<ForumState> {
  // Initial state is ForumInitial, representing an uninitialized state
  ForumCubit() : super(const ForumInitial());

  // Method to load initial data (e.g., from a database or API)
  // This is a placeholder for actual data loading logic
  Future<void> loadForumData() async {
    try {
      emit(const ForumLoading()); // Emit loading state
      // Simulate network delay or data fetching
      await Future.delayed(const Duration(seconds: 1));

      // For demonstration, let's start with some dummy data if empty
      // In a real app, you would fetch from a persistent source
      final initialPosts = <Post>[
        const Post(
          title: 'Welcome to the Forum!',
          content: 'This is your first post. Feel free to share anything!',
          likes: 5,
          comments: 2,
        ),
        const Post(
          title: 'Flutter Widgets',
          content: 'What are your favorite Flutter widgets and why?',
          likes: 10,
          comments: 3,
        ),
      ];

      final initialNotifications = <NotificationItem>[
        NotificationItem(
          message: 'A new user has joined the forum!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ];

      // Emit loaded state with initial data
      emit(
        ForumLoaded(
          allPosts: initialPosts,
          myPosts:
              initialPosts, // Assuming all initial posts are 'mine' for simplicity
          notifications: initialNotifications,
        ),
      );
    } catch (e) {
      emit(ForumError('Failed to load forum data: $e')); // Emit error state
    }
  }

  void addPost(Post newPost) {
    if (state is ForumLoaded) {
      final currentState = state as ForumLoaded;
      final updatedAllPosts = List<Post>.from(currentState.allPosts)
        ..insert(0, newPost);
      final updatedMyPosts = List<Post>.from(currentState.myPosts)
        ..insert(0, newPost);
      emit(
        currentState.copyWith(
          allPosts: updatedAllPosts,
          myPosts: updatedMyPosts,
        ),
      );
    }
  }

  void toggleLikePost(Post post) {
    if (state is ForumLoaded) {
      final currentState = state as ForumLoaded;
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );

      final updatedAllPosts =
          currentState.allPosts.map((p) {
            return p == post ? updatedPost : p;
          }).toList();

      final updatedMyPosts =
          currentState.myPosts.map((p) {
            return p == post ? updatedPost : p;
          }).toList();

      emit(
        currentState.copyWith(
          allPosts: updatedAllPosts,
          myPosts: updatedMyPosts,
        ),
      );

      if (updatedPost.isLiked) {
        addNotification('Postinganmu "${post.title}" disukai.');
      }
    }
  }

  void addComment(Post post, String commentText) {
    if (state is ForumLoaded) {
      final currentState = state as ForumLoaded;
      final updatedPost = post.copyWith(comments: post.comments + 1);

      final updatedAllPosts =
          currentState.allPosts.map((p) {
            return p == post ? updatedPost : p;
          }).toList();

      final updatedMyPosts =
          currentState.myPosts.map((p) {
            return p == post ? updatedPost : p;
          }).toList();

      emit(
        currentState.copyWith(
          allPosts: updatedAllPosts,
          myPosts: updatedMyPosts,
        ),
      );

      String notificationMessage;
      if (updatedPost.comments == 1) {
        notificationMessage =
            'Postinganmu "${post.title}" mendapatkan 1 komentar: "$commentText"';
      } else {
        notificationMessage =
            'Postinganmu "${post.title}" mendapatkan ${updatedPost.comments} komentar. Komentar terbaru: "$commentText"';
      }
      addNotification(notificationMessage);
    }
  }

  void addNotification(String message) {
    if (state is ForumLoaded) {
      final currentState = state as ForumLoaded;
      final updatedNotifications = List<NotificationItem>.from(
        currentState.notifications,
      )..insert(
        0,
        NotificationItem(message: message, timestamp: DateTime.now()),
      );
      emit(currentState.copyWith(notifications: updatedNotifications));
    }
  }
}
