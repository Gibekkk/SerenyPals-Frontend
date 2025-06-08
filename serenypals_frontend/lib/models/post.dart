// post.dart
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String title;
  final String content;
  final int likes;
  final int comments;
  final bool isLiked;

  const Post({
    required this.title,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  Post copyWith({
    String? title,
    String? content,
    int? likes,
    int? comments,
    bool? isLiked,
  }) {
    return Post(
      title: title ?? this.title,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [title, content, likes, comments, isLiked];
}
