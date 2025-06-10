import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/forum/forum_bloc.dart';
import '../../blocs/forum/forum_event.dart';
import '../../blocs/forum/forum_state.dart';
import '../../models/comment.dart';
import '../../models/post.dart';
import '../../widget/chatinputtext.dart';

class CommentScreen extends StatefulWidget {
  final Post post;

  const CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Comment? _replyingTo;
  bool _isAnonymous = false;
  List<Comment> parentComments = [];
  List<Comment> comments = [];

  List<Comment> childComments(String parentId) =>
      comments.where((c) => c.parentCommentId == parentId).toList();

  void _sendComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().toIso8601String(),
      postId: widget.post.id ?? '',
      author: _isAnonymous ? null : 'Pengguna',
      content: _commentController.text.trim(),
      timestamp: DateTime.now(),
      parentCommentId: _replyingTo?.id,
    );

    context.read<ForumBloc>().add(AddCommentEvent(widget.post, newComment));

    setState(() {
      _commentController.clear();
      _replyingTo = null;
    });

    // Scroll ke bawah setelah frame selesai
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Komentar')),
      body: SafeArea(
        child: Column(
          children: [
            if (_replyingTo != null)
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Membalas ${_replyingTo!.author ?? "Anonim"}: "${_replyingTo!.content}"',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() => _replyingTo = null);
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: BlocBuilder<ForumBloc, ForumState>(
                builder: (context, state) {
                  if (state is ForumLoaded) {
                    final updatedPost = state.allPosts.firstWhere(
                      (p) => p.id == widget.post.id,
                      orElse: () => widget.post,
                    );

                    comments = updatedPost.comments;
                    parentComments = comments
                        .where((c) => c.parentCommentId == null)
                        .toList();

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: parentComments.length,
                      itemBuilder: (context, index) {
                        final parent = parentComments[index];
                        final children = childComments(parent.id);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(parent.author ?? 'Anonim'),
                              subtitle: Text(parent.content),
                              trailing: Text(
                                TimeOfDay.fromDateTime(parent.timestamp)
                                    .format(context),
                              ),
                              onTap: () {
                                setState(() => _replyingTo = parent);
                              },
                            ),
                            ...children.map((child) => Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: ListTile(
                                    title: Text(child.author ?? 'Anonim'),
                                    subtitle: Text(child.content),
                                    trailing: Text(
                                      TimeOfDay.fromDateTime(child.timestamp)
                                          .format(context),
                                    ),
                                    onTap: () {
                                      setState(() => _replyingTo = child);
                                    },
                                  ),
                                )),
                          ],
                        );
                      },
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isAnonymous,
                        onChanged: (val) {
                          setState(() => _isAnonymous = val ?? false);
                        },
                      ),
                      const Text('Anonim'),
                    ],
                  ),
                  ChatInputField(
                    controller: _commentController,
                    onSend: _sendComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
