import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/widgets/widgets.dart';

class PostsListWidget extends StatelessWidget {
  final List<Post> posts;

  const PostsListWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final PostsService postsService = Provider.of<PostsService>(context);

    // final Responsive responsive = Responsive.of(context);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) => PostWidget(post: posts[index]),
    );
  }
}
