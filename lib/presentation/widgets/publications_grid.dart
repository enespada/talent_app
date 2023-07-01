import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/utils/utils.dart';

//GridPage
class PublicationsGrid extends StatelessWidget {
  final List<Post> posts;
  final void Function()? onTap;

  const PublicationsGrid({
    Key? key,
    required this.posts,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: responsive.widthPercent(2),
        mainAxisSpacing: responsive.widthPercent(2),
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FutureBuilder(
              future: postsService.getPostPoster(posts[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return snapshot.data!;
                }
                return Container(color: Colors.white);
              },
            ),
          ),
        );
      },
    );
  }
}
