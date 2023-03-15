// ignore_for_file: unnecessary_this
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/posts_service.dart';
import 'package:talent_app/services/services.dart';

import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/style/app_styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/carousel_images.dart';
import 'package:talent_app/widgets/widgets.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  // final List<Image> images;

  const PostWidget({
    Key? key,
    // required this.images,
    required this.post,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final PostsService postsService =
        Provider.of<PostsService>(context, listen: true);
    final UserService userService =
        Provider.of<UserService>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HeaderPublication(
        //   responsive: responsive,
        //   onPopupSelected: (item) {},
        // ),
        Container(
          margin: const EdgeInsets.only(bottom: 2),
          height: responsive.heightPercent(40),
          width: responsive.width,
          child: Stack(
            children: [
              FutureBuilder(
                future: postsService.getPostFiles(widget.post),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<String> postFilesUrls = snapshot.data!;
                    List<ImageProvider<Object>> postImages = [];
                    for (String file in postFilesUrls) {
                      postImages.add(CachedNetworkImageProvider(file));
                    }
                    return CarouselImages(
                      assetEntities: null,
                      images: postImages,
                    );
                  }
                  return Container(
                    color: AppColors.whiteColor,
                  );
                },
              ),
              if (userService.userApp!.type == 'scouter' ||
                  userService.userApp!.type == 'manager')
                Positioned(
                  bottom: 6,
                  left: responsive.widthPercent(5),
                  child: GestureDetector(
                    onTap: () {
                      //TODO: crear chat con el usuario
                    },
                    child: const Icon(
                      Icons.send,
                      color: AppColors.greyscale5,
                    ),
                  ),
                ),
              // Positioned(
              //   bottom: 6,
              //   right: responsive.widthPercent(5),
              //   child: const Icon(
              //     Icons.bookmark_border_rounded,
              //     color: AppColors.greyscale5,
              //   ),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.post.userApp!.userName} ',
                      style: TextStyle(
                        color: AppColors.greyscale5,
                        fontSize: responsive.diagonalPercent(2.2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${widget.post.description} ',
                      style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                        color: AppColors.greyscale5,
                        fontSize: responsive.diagonalPercent(1.8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              Text(
                Util.postDateTime(widget.post.datetime!),
                style: TextStyle(
                  color: AppColors.greyscale2,
                  fontSize: responsive.widthPercent(3),
                ),
              ),
              SizedBox(height: responsive.heightPercent(2)),
            ],
          ),
        ),
        SizedBox(height: responsive.heightPercent(4)),
      ],
    );
  }
}
