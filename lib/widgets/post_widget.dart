// ignore_for_file: unnecessary_this
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
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
    final PostsService postsService = Provider.of<PostsService>(
      context,
      listen: true,
    );
    final UserService userService = Provider.of<UserService>(
      context,
      listen: false,
    );
    final ChatsService chatsService = Provider.of<ChatsService>(
      context,
      listen: false,
    );

    final Responsive responsive = Responsive.of(context);

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
                  return Container(color: AppColors.whiteColor);
                },
              ),
              Visibility(
                visible: (userService.userApp!.type == 'scouter' ||
                        userService.userApp!.type == 'manager') ||
                    (userService.userApp!.type == 'athlete' ||
                        widget.post.userApp!.type == 'athlete'),
                child: Positioned(
                  bottom: 6,
                  left: responsive.widthPercent(5),
                  child: GestureDetector(
                    onTap: () async {
                      //TODO: crear chat con el usuario
                      Chat chat = Chat(
                        messages: [],
                        name: null,
                        users: [userService.userApp!.id!, widget.post.userId!],
                      );
                      await chatsService.newChat(chat);
                      Navigator.pushReplacementNamed(
                        context,
                        ChatsScreen.routeName,
                      );
                    },
                    child: const Icon(
                      Icons.send,
                      color: AppColors.greyscale5,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.post.userId == userService.userApp!.id,
                child: Positioned(
                  bottom: 6,
                  right: responsive.widthPercent(5),
                  child: const Icon(
                    Icons.bookmark_border_rounded,
                    color: AppColors.greyscale5,
                  ),
                ),
              ),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: responsive.diagonalPercent(2.2),
                            fontWeight: FontWeight.bold,
                          ),
                      // style: TextStyle(
                      //   color: AppColors.greyscale5,
                      //   fontSize: responsive.diagonalPercent(2.2),
                      //   fontWeight: FontWeight.bold,
                      // ),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            (userService.userApp!.id == widget.post.userId)
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            userApp: widget.post.userApp!,
                                            isLoguedUser: false),
                                      ),
                                    );
                                  },
                    ),
                    TextSpan(
                      text: '${widget.post.description} ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: responsive.diagonalPercent(1.8),
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              Text(
                Util.postTimestamp(widget.post.timestamp!),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.greyscale2,
                      fontSize: responsive.diagonalPercent(1.8),
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
