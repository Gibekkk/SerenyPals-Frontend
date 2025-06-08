import 'package:flutter/material.dart';

import '../models/post.dart';
import 'post_card.dart';

class SharingForumContent extends StatelessWidget {
  final List<Post> posts;

  const SharingForumContent({super.key, required this.posts});

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
                child: PostCard(post: posts[index]), // Meneruskan objek Post
              );
            },
          ),
        ),
      ],
    );
  }
}
