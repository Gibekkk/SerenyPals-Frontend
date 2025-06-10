import 'package:serenypals_frontend/models/comment.dart';

class Post {
  String? id;
  String title;
  String content;
  int likes;
  List<Comment> comments;
  bool isLiked;

  Post({
    this.id,
    required this.title,
    required this.content,
    this.likes = 0,
    this.comments = const [],
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'likes': likes,
      'comments': comments.map((c) => c.toJson()).toList(),
      'isLiked': isLiked,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      likes: json['likes'],
      comments: (json['comments'] as List<dynamic>)
          .map((c) => Comment.fromJson(c))
          .toList(),
      isLiked: json['isLiked'] ?? false,
    );
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    int? likes,
    List<Comment>? comments,
    bool? isLiked,
    required DateTime timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Post addComment(Comment newComment) {
    final updatedComments = List<Comment>.from(comments)..add(newComment);
    return Post(
      id: id,
      title: title,
      content: content,
      likes: likes,
      isLiked: isLiked,
      comments: updatedComments,
    );
  }
}
