import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/posts_service.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

enum HomeMenuOption { challenges, publications }

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String homeAppBarTitle = '';
  HomeMenuOption _selectedHomeMenuOption = HomeMenuOption.publications;
  final pageController = PageController();
  // late SharedPreferences pref;
  bool _isAthlete = false;

  @override
  void initState() {
    // _inicializeSharedPreferences();
    super.initState();
  }

  // void _inicializeSharedPreferences() async {
  //   pref = await SharedPreferences.getInstance();
  //   (pref.getString('athleteType') == 'athlete')
  //       ? _isAthlete = true
  //       : _isAthlete = false;
  //   print(_isAthlete);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    if (_selectedHomeMenuOption == HomeMenuOption.publications) {
      homeAppBarTitle = Localization.of(context).string('publications_title');
    }
    if (_selectedHomeMenuOption == HomeMenuOption.challenges) {
      homeAppBarTitle = Localization.of(context).string('challenges_title');
    }

    final List<Widget> pages = [
      PostsListWidget(posts: postsService.postsToShow),
      // const ChallengesPage(),
      Container(color: Colors.green),
    ];

    return Scaffold(
      backgroundColor: AppColors.greyscale0,
      //--------------------------------body------------------------------------
      body: SafeArea(
        child: Column(
          children: [
            //----------------------------Dropdown-------------------------------
            _HomeAppBar(
              title: homeAppBarTitle,
              isAthlete: _isAthlete,
              onSelected: (HomeMenuOption hmo) {
                if (_selectedHomeMenuOption == hmo) return;
                _selectedHomeMenuOption = hmo;
                if (hmo == HomeMenuOption.publications) {
                  homeAppBarTitle =
                      Localization.of(context).string('publications_title');
                  pageController.jumpToPage(0);
                }
                if (hmo == HomeMenuOption.challenges) {
                  homeAppBarTitle =
                      Localization.of(context).string('challenges_title');
                  pageController.jumpToPage(1);
                }
                setState(() {});
              },
            ),
            SizedBox(height: responsive.heightPercent(2)),

            //----------------------Publicaciones o retos-----------------------
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: pages,
              ),
            ),
          ],
        ),
      ),

      //----------------------CustomBottomNavigationBar--------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
    );
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
                    style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
                      style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
                      style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
