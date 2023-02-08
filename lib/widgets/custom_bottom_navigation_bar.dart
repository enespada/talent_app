import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/explorer/explorer_screen.dart';

import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/screens/profile/profile_screen.dart';
import 'package:talent_app/services/posts_service.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/utils.dart';

enum WhiteBottomNavigationBarMenu {
  homePage,
  explorerPage,
  messagesPage,
  wallPage
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

    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
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
            icon: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(_iconsWidth / 2),
                child: Image.asset(
                  'assets/images/profile_pic_example.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            label: Localization.of(context).string('about_title'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (int index) async {
          switch (index) {
            case 0:
              if (postsService.postsToShow.isEmpty)
                postsService.getFollowingPosts(userService.userApp!);
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              break;
            case 1:
              // context.navigatePopReplacing(ExplorerHomePage());
              Navigator.pushReplacementNamed(
                context,
                ExplorerScreen.routeName,
              );
              break;
            case 3:
              // context.navigatePopReplacing(MessagesHomePage());
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              break;
            case 4:
              // context.navigatePopReplacing(const WallHomePage());
              if (userService.userPosts.isEmpty) await userService.getPosts();
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
              break;
          }
        },
      ),
    );
  }
}
