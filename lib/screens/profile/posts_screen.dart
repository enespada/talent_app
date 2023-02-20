import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class PostsScreen extends StatelessWidget {
  static const String routeName = 'posts_screen';

  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final UserService userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: Localization.of(context).string('posts_screen_my_posts'),
        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
          fontSize: responsive.diagonalPercent(3),
          fontWeight: FontWeight.bold,
          color: AppColors.greyscale5,
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
      body: SafeArea(
        child: PostsListWidget(posts: userService.userPosts),
      ),
    );
  }
}
