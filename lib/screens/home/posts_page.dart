import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    final List<Image> images = [
      Image.asset('assets/images/playImage.png'),
      Image.asset('assets/images/sharedImage.png'),
      Image.asset('assets/images/sharedImage.png'),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: responsive.heightPercent(2)),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) => Publication(images: images),
          ),
          SizedBox(height: responsive.heightPercent(6)),
        ],
      ),
    );
  }
}
