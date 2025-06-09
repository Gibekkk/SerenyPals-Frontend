import 'package:flutter/material.dart';

import '../../models/notification_item.dart';
import '../../models/post.dart';

@immutable
abstract class ForumState {
  final List<Post> allPosts;
  final List<Post> myPosts;
  final List<NotificationItem> notifications;

  const ForumState({
    required this.allPosts,
    required this.myPosts,
    required this.notifications,
  });
}

class ForumInitial extends ForumState {
  ForumInitial() : super(allPosts: [], myPosts: [], notifications: []);
}

class ForumLoaded extends ForumState {
  const ForumLoaded({
    required super.allPosts,
    required super.myPosts,
    required super.notifications,
  });

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
}
