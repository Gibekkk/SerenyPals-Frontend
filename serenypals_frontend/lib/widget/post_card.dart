import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/models/comment.dart';
import '../../blocs/forum/forum_bloc.dart';
import '../../blocs/forum/forum_event.dart';
import '../../blocs/forum/forum_state.dart';
import '../../models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showCommentInput = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForumBloc, ForumState>(
      builder: (context, state) {
        // Find the current post in the updated state to ensure UI reflects latest data
        final currentPost = state.allPosts.firstWhere(
          (p) => p == widget.post,
          orElse: () => widget.post,
        );

        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentPost.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  currentPost.content,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<ForumBloc>()
                            .add(ToggleLikePostEvent(currentPost));
                      },
                      child: Icon(
                        currentPost.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: currentPost.isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '${currentPost.likes >= 1000 ? (currentPost.likes / 1000).toStringAsFixed(0) + 'k' : currentPost.likes}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showCommentInput = !_showCommentInput;
                        });
                      },
                      child: IconButton(
                        icon: Icon(Icons.comment_outlined),
                        color: Colors.grey,
                        onPressed: () {
                          context.push('/comments',
                              extra: currentPost); // Gunakan GoRouter
                        },
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '${currentPost.comments.length >= 1000 ? (currentPost.comments.length / 1000).toStringAsFixed(0) + 'k' : currentPost.comments.length}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                if (_showCommentInput)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Tulis komentar...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              context.read<ForumBloc>().add(AddCommentEvent(
                                  currentPost,
                                  _commentController.text as Comment));

                              _commentController.clear();
                              setState(() {
                                _showCommentInput = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Komentar berhasil ditambahkan!',
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade100,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                          ),
                          child: Text('Kirim'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
