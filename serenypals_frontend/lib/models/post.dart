class Post {
  String? id; // Tambahkan ID untuk mengidentifikasi postingan di backend
  String title;
  String content;
  int likes;
  int comments;
  bool isLiked;

  Post({
    this.id,
    required this.title,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  // Method untuk mengubah Post menjadi Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
    };
  }

  // Factory method untuk membuat Post dari Map (JSON)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      isLiked: json['isLiked'] as bool,
    );
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    int? likes,
    int? comments,
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
}
