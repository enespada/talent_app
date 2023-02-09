import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/screens/screens.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(3),
                fontWeight: FontWeight.w700,
                color: AppColors.greyscale5,
              ),
              iconColor: AppColors.blueColor,
              title: Localization.of(context).string('posts_screen_my_posts'),
            ),
            SizedBox(height: responsive.heightPercent(2)),
            PostsListWidget(posts: userService.userPosts),
          ],
        ),
      ),
    );
  }
}
