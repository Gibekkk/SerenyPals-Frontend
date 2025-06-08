import 'package:equatable/equatable.dart';

import '../../models/notification.dart';
import '../../models/post.dart';

// Abstract base class for all Forum states
abstract class ForumState extends Equatable {
  const ForumState();

  @override
  List<Object> get props => [];
}

// Initial state before any data is loaded or operations are performed
class ForumInitial extends ForumState {
  const ForumInitial();
}

// State indicating that data is being loaded or an operation is in progress
class ForumLoading extends ForumState {
  const ForumLoading();
}

// State indicating that an error has occurred
class ForumError extends ForumState {
  final String message;

  const ForumError(this.message);

  @override
  List<Object> get props => [message];
}

// State indicating that data has been successfully loaded and is available
class ForumLoaded extends ForumState {
  final List<Post> allPosts;
  final List<Post> myPosts;
  final List<NotificationItem> notifications;

  const ForumLoaded({
    this.allPosts = const [],
    this.myPosts = const [],
    this.notifications = const [],
  });

  // Helper method to create a new ForumLoaded state with updated properties
  ForumLoaded copyWith({
    List<Post>? allPosts,
    List<Post>? myPosts,
    List<NotificationItem>? notifications,
  }) {
    return ForumLoaded(
      allPosts: allPosts ?? this.allPosts,
      myPosts: myPosts ?? this.myPosts,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [allPosts, myPosts, notifications];
}
