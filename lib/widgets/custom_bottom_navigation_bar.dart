import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/utils.dart';

enum WhiteBottomNavigationBarMenu {
  homePage,
  explorerPage,
  chatsPage,
  profilePage
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  static const double _iconsWidth = 20;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);
    final PostsService postsService = Provider.of<PostsService>(context);
    final ChatsService chatsService = Provider.of<ChatsService>(context);

    final Responsive responsive = Responsive.of(context);

    return BottomNavigationBar(
      backgroundColor: AppColors.greyscale5,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      unselectedLabelStyle: const TextStyle(fontSize: 0),
      selectedLabelStyle: const TextStyle(fontSize: 0),
      type: BottomNavigationBarType.fixed,
      items: [
        //---------------------------------Home---------------------------------
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icon_home.svg',
            color: AppColors.greyscale2,
            height: _iconsWidth,
            width: _iconsWidth,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/icon_home.svg',
            color: AppColors.blueColor,
            width: _iconsWidth,
            height: _iconsWidth,
          ),
          label: Localization.of(context).string('home_title'),
        ),

        //--------------------------------Busqueda------------------------------
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icon_search.svg',
            color: AppColors.greyscale2,
            height: _iconsWidth,
            width: _iconsWidth,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/icon_search.svg',
            color: AppColors.blueColor,
            height: _iconsWidth,
            width: _iconsWidth,
          ),
          label: Localization.of(context).string('about_title'),
        ),

        //------------------------------Subida (+)------------------------------
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.add,
            color: AppColors.greyscale2,
            size: _iconsWidth + 20,
          ),
          label: Localization.of(context).string('about_title'),
        ),

        //-------------------------------Chats----------------------------------
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icon_chat.svg',
            color: AppColors.greyscale2,
            width: _iconsWidth,
            height: _iconsWidth,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/icon_chat.svg',
            color: AppColors.blueColor,
            width: _iconsWidth,
            height: _iconsWidth,
          ),
          label: Localization.of(context).string('about_title'),
        ),

        //-------------------------------Perfil---------------------------------
        BottomNavigationBarItem(
          icon: FutureBuilder(
            future: userService.getProfileImageURL(
                userService.userApp!.id!.path.split('/')[1]),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                height: responsive.diagonalPercent(4),
                width: responsive.diagonalPercent(4),
                decoration: BoxDecoration(
                  border: (selectedIndex == 4)
                      ? Border.all(
                          color: AppColors.yellowColor,
                          width: 1,
                        )
                      : const Border(),
                  shape: BoxShape.circle,
                  image: (snapshot.hasData && snapshot.data != '')
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data!),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/images/profile.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              );
            },
          ),
          label: Localization.of(context).string('about_title'),
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (int index) async {
        if (selectedIndex == index) return;
        switch (index) {
          case 0:
            if (postsService.followingUsersPosts == null) {
              await postsService.getFollowingPosts(userService.userApp!);
            }
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            break;
          case 1:
            // context.navigatePopReplacing(ExplorerHomePage());
            if (postsService.allUsersPosts == null) {
              postsService.getUsersPosts(userService.userApp!);
            }
            Navigator.pushReplacementNamed(context, ExplorerScreen.routeName);
            break;
          case 2:
            Navigator.pushNamed(context, UploadPostHomeScreen.routeName);
            break;
          case 3:
            // context.navigatePopReplacing(MessagesHomePage());
            if (chatsService.chats == null) {
              chatsService.getUserChats(userService.userApp!);
            }
            Navigator.pushReplacementNamed(context, ChatsScreen.routeName);
            break;
          case 4:
            // context.navigatePopReplacing(const WallHomePage());
            if (userService.userPosts.isEmpty) await userService.getPosts();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userApp: userService.userApp!,
                  isLoguedUser: true,
                ),
              ),
            );
            break;
        }
      },
    );
  }
}
