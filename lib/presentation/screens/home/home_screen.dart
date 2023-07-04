import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:talent_app/services/posts_service.dart';
import 'package:talent_app/services/user_service.dart';
import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

enum HomeMenuOption { challenges, publications }

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String homeAppBarTitle = '';
  final pageController = PageController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PostsService postsService = Provider.of<PostsService>(context);
    final UserService userService =
        Provider.of<UserService>(context, listen: false);

    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      //--------------------------------appBar------------------------------------
      appBar: CustomAppBar(
        title: Localization.of(context).string("home_screen_title"),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: responsive.diagonalPercent(3),
              fontWeight: FontWeight.bold,
            ),
      ),

      //--------------------------------body------------------------------------
      body: SafeArea(
        child: (postsService.isLoadingFollowing && isRefresh)
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blueColor,
                ),
              )
            : SmartRefresher(
                physics: const BouncingScrollPhysics(),
                header: const WaterDropHeader(
                  waterDropColor: AppColors.whiteColor,
                  idleIcon: Icon(
                    Icons.arrow_downward,
                    color: AppColors.greyscale3,
                  ),
                  refresh: CupertinoActivityIndicator(),
                  complete: Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                  failed: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
                enablePullDown: true,
                onLoading: () {
                  _refreshController.loadComplete();
                },
                onRefresh: () async {
                  if (isRefresh) isRefresh = false;
                  await postsService.getFollowingPosts(userService.userApp!);
                  // await Future.delayed(const Duration(seconds: 2));
                  _refreshController.refreshCompleted();
                  setState(() {});
                },
                controller: _refreshController,
                child: (postsService.followingUsersPosts!.isEmpty)
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Center(
                          child: Text(
                            Localization.of(context).string("no_posts_to_show"),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.greyscale2,
                                      fontSize: responsive.diagonalPercent(2.8),
                                    ),
                          ),
                        ),
                      )
                    : PostsListWidget(posts: postsService.followingUsersPosts!),
              ),
      ),

      //----------------------CustomBottomNavigationBar--------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
    );

    // if (_selectedHomeMenuOption == HomeMenuOption.publications) {
    //   homeAppBarTitle = Localization.of(context).string('publications_title');
    // }
    // if (_selectedHomeMenuOption == HomeMenuOption.challenges) {
    //   homeAppBarTitle = Localization.of(context).string('challenges_title');
    // }

    // final List<Widget> pages = [
    //   PostsListWidget(posts: postsService.postsToShow),
    //   // const ChallengesPage(),
    //   Container(color: Colors.green),
    // ];

    // return Scaffold(
    //   backgroundColor: AppColors.greyscale0,
    //   //--------------------------------body------------------------------------
    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         //----------------------------Dropdown-------------------------------
    //         _HomeAppBar(
    //           title: homeAppBarTitle,
    //           isAthlete: _isAthlete,
    //           onSelected: (HomeMenuOption hmo) {
    //             if (_selectedHomeMenuOption == hmo) return;
    //             _selectedHomeMenuOption = hmo;
    //             if (hmo == HomeMenuOption.publications) {
    //               homeAppBarTitle =
    //                   Localization.of(context).string('publications_title');
    //               pageController.jumpToPage(0);
    //             }
    //             if (hmo == HomeMenuOption.challenges) {
    //               homeAppBarTitle =
    //                   Localization.of(context).string('challenges_title');
    //               pageController.jumpToPage(1);
    //             }
    //             setState(() {});
    //           },
    //         ),
    //         SizedBox(height: responsive.heightPercent(2)),

    //         //----------------------Publicaciones o retos-----------------------
    //         Expanded(
    //           child: PageView(
    //             physics: const NeverScrollableScrollPhysics(),
    //             controller: pageController,
    //             children: pages,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),

    //   //----------------------CustomBottomNavigationBar--------------------------
    //   bottomNavigationBar: const CustomBottomNavigationBar(
    //     selectedIndex: 0,
    //   ),
    // );
  }
}

class _HomeAppBar extends StatelessWidget {
  final String title;
  final void Function(HomeMenuOption)? onSelected;
  final bool isAthlete;

  const _HomeAppBar({
    Key? key,
    required this.title,
    required this.onSelected,
    required this.isAthlete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: responsive.heightPercent(8),
      width: responsive.width,
      color: AppColors.greyscale0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //----------------------------Dropdown-------------------------------
          Expanded(
            child: PopupMenuButton<HomeMenuOption>(
              onSelected: onSelected,
              icon: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.5),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(width: responsive.widthPercent(10)),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.greyscale5,
                    size: 30,
                  ),
                ],
              ),
              position: PopupMenuPosition.under,
              color: AppColors.greyscale0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              itemBuilder: (BuildContext context) {
                List<PopupMenuEntry<HomeMenuOption>> opciones = [
                  PopupMenuItem<HomeMenuOption>(
                    value: HomeMenuOption.publications,
                    child: Text(
                      Localization.of(context).string('publications_title'),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: responsive.diagonalPercent(2.1),
                          ),
                    ),
                  ),
                ];
                if (isAthlete == false) {
                  opciones.add(PopupMenuItem<HomeMenuOption>(
                    value: HomeMenuOption.challenges,
                    child: Text(
                      Localization.of(context).string('challenges_title'),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: responsive.diagonalPercent(2.1),
                          ),
                    ),
                  ));
                }
                return opciones;
              },
            ),
          ),

          //-------------------------Notificaciones-------------------------------
          // GestureDetector(
          //   child: const Padding(
          //     padding: EdgeInsets.only(right: 4),
          //     child: Icon(
          //       Icons.notifications_outlined,
          //       size: 30,
          //       color: AppColors.greyscale5,
          //     ),
          //   ),
          //   onTap: () {
          //     // context.navigateTo(NotificationsPage());
          //   },
          // ),
        ],
      ),
    );
  }
}
