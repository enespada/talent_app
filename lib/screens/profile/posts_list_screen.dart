import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class PostsListScreen extends StatelessWidget {
  static const String routeName = 'posts_screen';

  final String title;
  final List<Post> posts;

  const PostsListScreen({
    Key? key,
    required this.title,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final UserService userService = Provider.of<UserService>(context);

    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      //--------------------------------appBar----------------------------------
      appBar: CustomAppBar(
        title: title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: responsive.diagonalPercent(3),
              fontWeight: FontWeight.bold,
            ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
            size: responsive.heightPercent(3),
          ),
        ),
      ),

      //--------------------------------body-------------------------------------
      body: SafeArea(
        // child: PostsListWidget(posts: userService.userPosts),
        child: PostsListWidget(posts: posts),
      ),
    );
  }
}
