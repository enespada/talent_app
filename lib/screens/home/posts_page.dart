import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/services/services.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    if (postsService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: responsive.heightPercent(2)),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: postsService.postsToShow.length,
              itemBuilder: (context, index) =>
                  PostWidget(post: postsService.postsToShow[index]),
            ),
            SizedBox(height: responsive.heightPercent(5)),
          ],
        ),
      );
    }
  }
}
