import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_card.dart';

class MyPostsContent extends StatelessWidget {
  final List<Post> posts;

  const MyPostsContent({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PostCard(post: posts[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
