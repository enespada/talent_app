import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/user_service.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

//WallHomePage
class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Usuario principal (el logueado)
  UserApp? userApp;
  int _selectedPage = 0;
  // final _viewModel = inject<UserViewModel>();
  String sportTypeName = "";
  String modalityName = "";
  //Grids a mostrar con los posts, lso challenges o los posts guardados
  final List<Widget> _pages = [
    _PublicationsGrid(
      // onTap: () => context.navigateTo(const WallChallengePage()),
      onTap: () {},
      images: [
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
      ],
    ),
    _PublicationsGrid(
      onTap: () {},
      images: [
        Image.asset(
          'assets/images/gridImage.png',
          fit: BoxFit.cover,
        ),
      ],
    ),
    _PublicationsGrid(
      onTap: () {},
      images: const [],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final UserService userService = Provider.of<UserService>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    //------------------------Mi perfil-------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Localization.of(context).string('wall_home_title'),
                          style: TextStyle(
                            color: AppColors.greyscale5,
                            fontSize: responsive.widthPercent(6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     context.navigateTo(NotificationsPage());
                        //   },
                        //   child: Icon(
                        //     Icons.notifications_outlined,
                        //     size: responsive.widthPercent(7),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: responsive.heightPercent(2)),

                    //-----------Foto perfil, nombre, editar, ajustes-----------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //-------------------Foto perfil------------------------
                        FutureBuilder(
                          future: userService.urlImag(userApp?.id ?? ''),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: responsive.heightPercent(4),
                                right: responsive.heightPercent(3),
                                top: responsive.heightPercent(4),
                              ),
                              height: responsive.widthPercent(22),
                              width: responsive.widthPercent(22),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                                image: (snapshot.hasData && snapshot.data != '')
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            snapshot.data!),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/profile.png'),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            );
                          },
                        ),
                        //---------------Nombre, editar, ajustes---------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //-------------------Nombre------------------------
                            Text(
                              userApp?.fullname ?? 'Pepe',
                              style: TextStyle(
                                color: AppColors.greyscale5,
                                fontSize: responsive.widthPercent(5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            //-------------------Deporte------------------------
                            Text(
                              '${toBeginningOfSentenceCase(sportTypeName)} ${toBeginningOfSentenceCase(modalityName)} | ${userApp?.country}',
                              style: TextStyle(
                                color: AppColors.greyscale2,
                                fontSize: responsive.widthPercent(3.5),
                              ),
                            ),
                            SizedBox(height: responsive.heightPercent(1)),

                            //----------------Editar y ajustes-------------------
                            Row(
                              children: [
                                //----------------Editar-----------------------
                                BlueTextButton(
                                  title: Localization.of(context)
                                      .string('wall_home_primary_button'),
                                  fontSize: responsive.widthPercent(4),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, EditProfileScreen.routeName);
                                  },
                                ),
                                SizedBox(width: responsive.widthPercent(4)),

                                //----------------Ajustes----------------------
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SettingsScreen.routeName);
                                  },
                                  elevation: 0,
                                  color: AppColors.greyscale0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                      color: AppColors.blackColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    Localization.of(context)
                                        .string('wall_home_secundary_button'),
                                    style: TextStyle(
                                      color: AppColors.greyscale5,
                                      fontSize: responsive.widthPercent(4),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    //-----------Seguidores, siguiendo, publicaciones-------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          // onTap: () =>
                          //     context.navigateTo(const WallFollowersPage()),
                          child: Column(
                            children: [
                              Text(
                                '150',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.widthPercent(5),
                                ),
                              ),
                              Text(
                                Localization.of(context)
                                    .string('wall_home_followers_text'),
                                // style: AppStyles.ligthTextTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          // onTap: () =>
                          //     context.navigateTo(const WallFollowersPage()),
                          child: Column(
                            children: [
                              Text(
                                '1.5k',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsive.widthPercent(5)),
                              ),
                              Text(
                                Localization.of(context)
                                    .string('wall_home_following_text'),
                                // style: AppStyles.ligthTextTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          // onTap: () => context
                          //     .navigateTo(const WallPublishedImagesPage()),
                          child: Column(
                            children: [
                              Text(
                                '500',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.widthPercent(5),
                                ),
                              ),
                              Text(
                                Localization.of(context)
                                    .string('wall_home_publications_text'),
                                // style: AppStyles.ligthTextTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.heightPercent(1.5)),

                    //--------------Publicaciones, retos y guardados------------
                    Column(
                      children: [
                        const Divider(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.heightPercent(1),
                          ),
                          width: responsive.widthPercent(75),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //--------------------Posts-----------------------
                              GestureDetector(
                                onTap: () {
                                  _selectedPage = 0;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.apps_sharp,
                                  color: (_selectedPage == 0)
                                      ? AppColors.blueColor
                                      : AppColors.greyscale1,
                                  size: responsive.widthPercent(8),
                                ),
                              ),

                              //-------------------Challenges--------------------
                              GestureDetector(
                                onTap: () {
                                  _selectedPage = 1;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: (_selectedPage == 1)
                                      ? AppColors.blueColor
                                      : AppColors.greyscale1,
                                  size: responsive.widthPercent(8),
                                ),
                              ),

                              //----------------------Saved----------------------
                              GestureDetector(
                                onTap: () {
                                  _selectedPage = 2;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.bookmark_border_rounded,
                                  color: (_selectedPage == 2)
                                      ? AppColors.blueColor
                                      : AppColors.greyscale1,
                                  size: responsive.widthPercent(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                    SizedBox(height: responsive.heightPercent(1.5)),

                    SizedBox(
                      height: responsive.heightPercent(45),
                      child: _pages[_selectedPage],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      //-------------------------CustomBottomNavigationBar------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 4,
      ),
    );
  }
}

//GridPage
class _PublicationsGrid extends StatelessWidget {
  final List<Image> images;
  final void Function()? onTap;

  const _PublicationsGrid({
    Key? key,
    required this.images,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: responsive.widthPercent(2),
        mainAxisSpacing: responsive.widthPercent(2),
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: images[index],
          ),
        );
      },
    );
  }
}
