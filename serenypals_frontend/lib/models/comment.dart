class Comment {
  final String id;
  final String postId;
  final String? author;
  final String content;
  final DateTime timestamp;
  // Tambahkan ini:
  final String? parentCommentId;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.timestamp,
    this.author,
    this.parentCommentId,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? author,
    String? content,
    DateTime? timestamp,
    String? parentCommentId,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }

  // Jangan lupa ini kalau kamu parsing dari JSON:
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      author: json['author'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      parentCommentId: json['parentCommentId'], // ← Ini penting
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'author': author,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'parentCommentId': parentCommentId,
      };
}
