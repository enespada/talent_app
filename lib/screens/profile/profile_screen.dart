import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/providers/edit_profile_provider.dart';
import 'package:talent_app/screens/profile/posts_screen.dart';
import 'package:talent_app/screens/profile/profile_follow_screen.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/sports_service.dart';
import 'package:talent_app/services/user_service.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/style/styles.dart';
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
  int _selectedPage = 0;
  //Grids a mostrar con los posts, lso challenges o los posts guardados

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    final UserService userService = Provider.of<UserService>(context);
    final SportsService sportsService =
        Provider.of<SportsService>(context, listen: false);
    final ModalitiesService modalitiesService =
        Provider.of<ModalitiesService>(context, listen: false);
    final PostsService postsService = Provider.of<PostsService>(context);

    final EditProfileProvider editProfileProvider =
        Provider.of<EditProfileProvider>(context);

    double followersValue =
        userService.userApp?.followers?.length.toDouble() ?? -1;
    String followersString = Util.adaptNumFollow(followersValue);
    double followingValue =
        userService.userApp?.following?.length.toDouble() ?? -1;
    String followingString = Util.adaptNumFollow(followingValue);
    double publicationsValue = userService.userPosts.length.toDouble() ?? -1;
    String publicationsString = Util.adaptNumFollow(publicationsValue);

    final List<Widget> _pages = [
      _PublicationsGrid(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostsScreen(),
            ),
          );
        },
        posts: userService.userPosts,
      ),
      _PublicationsGrid(
        onTap: () {},
        posts: [],
      ),
      _PublicationsGrid(
        onTap: () {},
        posts: [],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  //------------------------Mi perfil-------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Localization.of(context).string('wall_home_title'),
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(3.5),
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
                  SizedBox(height: responsive.heightPercent(1)),

                  //-----------Foto perfil, nombre, editar, ajustes-----------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //-------------------Foto perfil------------------------
                      FutureBuilder(
                        future: userService.getProfileImageURL(
                            userService.userApp!.id!.path.split('/')[1]),
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

                      //-----------------Nombre, editar, ajustes-----------------
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //-------------------Nombre------------------------
                            Text(
                              userService.userApp?.fullName ?? '',
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: responsive.heightPercent(0.8)),

                            //-------------------Deporte------------------------
                            Text(
                              '${toBeginningOfSentenceCase(userService.userApp?.type ?? '')} | ${userService.userApp?.country ?? ''}',
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.1),
                                color: AppColors.greyscale2,
                                fontWeight: FontWeight.bold,
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
                                  onPressed: () async {
                                    await sportsService.getSports();
                                    for (Sport s in sportsService.sports) {
                                      if (s.id == userService.userApp!.sport) {
                                        await modalitiesService
                                            .getModalitiesBySport(s);
                                        editProfileProvider.sport = s;
                                        break;
                                      }
                                    }
                                    for (Modality m
                                        in modalitiesService.modalities) {
                                      if (m.id ==
                                          userService.userApp!.modality) {
                                        editProfileProvider.modality = m;
                                        break;
                                      }
                                    }

                                    editProfileProvider
                                        .initializeData(userService.userApp!);

                                    Navigator.pushNamed(
                                      context,
                                      EditProfileScreen.routeName,
                                    );
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
                      ),
                    ],
                  ),

                  //-----------Seguidores, siguiendo, publicaciones-------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //------------------------Seguidores-----------------------
                      GestureDetector(
                        onTap: () async {
                          await userService.getFollowers();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileFollowScreen(
                                userApp: userService.userApp!,
                                typeFollow: TypeFollow.seguidores,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              followersString,
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Localization.of(context)
                                  .string('wall_home_followers_text'),
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //-------------------------Seguidos-------------------------
                      GestureDetector(
                        onTap: () async {
                          await userService.getFollowing();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileFollowScreen(
                                  userApp: userService.userApp!,
                                  typeFollow: TypeFollow.seguidos),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              followingString,
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Localization.of(context)
                                  .string('wall_home_following_text'),
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //--------------------------Posts--------------------------
                      GestureDetector(
                        // onTap: () => context
                        //     .navigateTo(const WallPublishedImagesPage()),
                        child: Column(
                          children: [
                            Text(
                              publicationsString,
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Localization.of(context)
                                  .string('wall_home_publications_text'),
                              style:
                                  AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                                fontSize: responsive.diagonalPercent(2.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //---------------Publicaciones, retos y guardados--------------
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
                            //----------------------Posts------------------------
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

                            //--------------------Challenges---------------------
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

                            //-----------------------Saved-----------------------
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

                  Expanded(child: _pages[_selectedPage]),
                ],
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
  final List<Post> posts;
  final void Function()? onTap;

  const _PublicationsGrid({
    Key? key,
    required this.posts,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: responsive.widthPercent(2),
        mainAxisSpacing: responsive.widthPercent(2),
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FutureBuilder(
              future: postsService.getPostPoster(posts[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return snapshot.data!;
                }
                return Container(color: Colors.white);
              },
            ),
          ),
        );
      },
    );
  }
}
