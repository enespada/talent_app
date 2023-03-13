import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/localization.dart';
import 'package:video_player/video_player.dart';

enum Menu { share, report }

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key? key}) : super(key: key);

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with AutomaticKeepAliveClientMixin {
  // final viewModel = inject<AuthViewModel>();
  final PageController _pageController = PageController();
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _visibleVideoTitle = true;
  int videoPosition = 0;

  // TODO: Delete when api implementation
  String defaultVideo =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  @override
  void initState() {
    super.initState();
    // TODO: Change this for the actual video
    _videoController = VideoPlayerController.network(defaultVideo);

    _initializeVideoPlayerFuture = _videoController.initialize();

    _videoController.setLooping(true);

    _videoController.addListener(() async {
      setState(() {
        _visibleVideoTitle = true;
        videoPosition = _videoController.value.position.inMilliseconds;
      });
    });

    // viewModel.signOutState.stream.listen((state) {
    //   switch (state) {
    //     case true:
    //       context.navigateReplacing(const SplashPage());
    //       break;
    //     default:
    //       break;
    //   }
    // });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inMinutes)}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(_videoController);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          },
          onPageChanged: (index) {
            _videoController.dispose();

            _videoController = VideoPlayerController.network(
              defaultVideo, // TODO: Next video instead of this
            );

            _videoController.pause();
            _videoController.seekTo(Duration.zero);

            _initializeVideoPlayerFuture = _videoController.initialize();

            _videoController.setLooping(true);

            _videoController.addListener(() async {
              setState(() {
                _visibleVideoTitle = true;
                videoPosition = _videoController.value.position.inMilliseconds;
              });
            });

            _visibleVideoTitle = false;

            setState(() {});
          },
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            height: 240,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                AppColors.transparentGrey,
                Colors.transparent,
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              stops: [0.6, 1.0],
            )),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  opacity: _visibleVideoTitle ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.asset(
                                    'assets/images/profile_pic_example.png',
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Max Jacobson',
                                      // style: AppStyles
                                      //     .darkTextTheme.bodyLarge!
                                      //     .copyWith(
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                    ),
                                    Text(
                                      'Manhattan, NYC',
                                      // style:
                                      //     AppStyles.darkTextTheme.bodyLarge,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            PopupMenuButton<Menu>(
                                // Callback that sets the selected popup menu item.
                                onSelected: (Menu item) {
                                  setState(() {
                                    switch (item) {
                                      case Menu.share:
                                        break;
                                      case Menu.report:
                                        break;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.adaptive.more,
                                  color: AppColors.whiteColor,
                                ),
                                color: AppColors.greyscale5,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<Menu>>[
                                      PopupMenuItem<Menu>(
                                        value: Menu.share,
                                        child: Text(
                                          Localization.of(context)
                                              .string('action_share'),
                                          // style: AppStyles
                                          //     .darkTextTheme.bodyLarge,
                                        ),
                                      ),
                                      PopupMenuItem<Menu>(
                                        value: Menu.report,
                                        child: Text(
                                          Localization.of(context)
                                              .string('action_report'),
                                          // style: AppStyles
                                          //     .darkTextTheme.bodyLarge,
                                        ),
                                      ),
                                    ]),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              // TalentCustomIconButton(
                              //   backgroundColor: AppColors.brandColor,
                              //   padding: const EdgeInsets.symmetric(
                              //     vertical: AppDimens.extraSmallMargin,
                              //     horizontal: AppDimens.smallMargin,
                              //   ),
                              //   borderRadius: const BorderRadius.all(
                              //     Radius.circular(AppDimens.extraSmallMargin),
                              //   ),
                              //   icon: SvgPicture.asset(
                              //       'assets/images/icon_like.svg',
                              //       color: AppColors.whiteColor),
                              // ),
                              const SizedBox(
                                width: 5,
                              ),
                              // TalentCustomButton(
                              //   backgroundColor: AppColors.brandColor,
                              //   padding: const EdgeInsets.symmetric(
                              //     vertical: 5,
                              //     horizontal: 10,
                              //   ),
                              //   borderRadius: const BorderRadius.all(
                              //     Radius.circular(5),
                              //   ),
                              //   child: Text(
                              //     'Voleas con rebote',
                              //     // style: AppStyles.darkTextTheme.bodyLarge!
                              //     //     .copyWith(
                              //     //         color: AppColors.whiteColor,
                              //     //         fontSize: 13,
                              //     //         fontWeight: FontWeight.normal),
                              //   ),
                              // )
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Increíble haber conseguido este reto! 😁',
                          // style: AppStyles.darkTextTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final duration =
                            _videoController.value.duration.inMilliseconds;

                        final Duration positionDuration =
                            Duration(milliseconds: videoPosition);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                (_videoController.value.isPlaying)
                                    ? _videoController.pause()
                                    : _videoController.play();
                              },
                              icon: Icon(
                                (_videoController.value.isPlaying)
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: AppColors.whiteColor,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 32,
                            ),
                            Expanded(
                              child: Slider(
                                value: videoPosition.toDouble(),
                                max: duration.toDouble(),
                                divisions: null,
                                onChanged: (double value) {
                                  setState(() {
                                    _videoController.seekTo(
                                        Duration(milliseconds: value.toInt()));
                                  });
                                },
                                activeColor: AppColors.whiteColor,
                                inactiveColor: Colors.white38,
                              ),
                            ),
                            Text(
                              _printDuration(positionDuration),
                              style:
                                  const TextStyle(color: AppColors.whiteColor),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                const SizedBox(height: kBottomNavigationBarHeight + 15)
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    // viewModel.dispose(); // Avoid memory leaks
    _pageController.dispose();
    _videoController.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}
