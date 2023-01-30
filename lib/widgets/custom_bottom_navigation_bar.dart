import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talent_app/screens/explorer/explorer_screen.dart';

import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/screens/profile/profile_screen.dart';
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
  static const double _iconsWidth = 24.0;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.greyscale5,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        //---------------------------------Home---------------------------------
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icon_home.svg',
            color: AppColors.greyscale2,
            width: _iconsWidth,
            height: _iconsWidth,
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
          icon: ElevatedButton(
              onPressed: () {
                // String type = UserViewModel.user!.type!;
                // switch (type) {
                //   case "athlete":
                //     context.navigateTo(const UploadPostHomePage());
                //     break;
                //   case "scouter":
                //   case "manager":
                //     context.navigateTo(const UploadChallengeHomePage());
                //     break;
                // }
              },
              child: const Icon(Icons.add)),
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
      onTap: (int index) {
        switch (index) {
          case 0:
            // context.navigatePopReplacing(const HomePage());
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
            Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
            break;
        }
      },
    );
  }
}
