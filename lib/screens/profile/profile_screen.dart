// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/providers/providers.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

//WallHomePage
class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile_screen';

  final UserApp userApp;
  final List<Post> userPosts;
  final bool isloggedUser;

  const ProfileScreen({
    Key? key,
    required this.userApp,
    required this.userPosts,
    required this.isloggedUser,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;

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
    final UserService userService = Provider.of<UserService>(context);
    final SportsService sportsService = Provider.of<SportsService>(
      context,
      listen: false,
    );
    final PostsService postsService = Provider.of<PostsService>(
      context,
      listen: false,
    );
    final ModalitiesService modalitiesService = Provider.of<ModalitiesService>(
      context,
      listen: false,
    );
    final EditProfileProvider editProfileProvider =
        Provider.of<EditProfileProvider>(context);

    final Responsive responsive = Responsive.of(context);

    double followersValue = widget.userApp.followers?.length.toDouble() ?? -1;
    String followersString = Util.adaptNumFollow(followersValue);
    double followingValue = widget.userApp.following?.length.toDouble() ?? -1;
    String followingString = Util.adaptNumFollow(followingValue);
    double publicationsValue = widget.userPosts.length.toDouble();
    String publicationsString = Util.adaptNumFollow(publicationsValue);
    if (!widget.isloggedUser) {
      isFollowing = false;
      for (DocumentReference? idFollowing in userService.userApp!.following!) {
        if (idFollowing == widget.userApp.id) {
          isFollowing = true;
          break;
        }
      }
    }

    return Scaffold(
      //----------------------------------appBar----------------------------------
      appBar: CustomAppBar(
        title: (widget.isloggedUser)
            ? Localization.of(context).string('wall_home_title')
            : Localization.of(context).string('profile'),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: responsive.diagonalPercent(3),
              fontWeight: FontWeight.bold,
            ),
        leading: (!widget.isloggedUser)
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.blueColor,
                  size: responsive.heightPercent(3),
                ),
              )
            : null,
      ),

      //----------------------------------body----------------------------------
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              //-------------Foto perfil, nombre, editar, ajustes------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //---------------------Foto perfil--------------------------
                  FutureBuilder(
                    future: userService.getProfileImageURL(
                        widget.userApp.id!.path.split('/')[1]),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        height: responsive.diagonalPercent(10),
                        width: responsive.diagonalPercent(10),
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
                                  image:
                                      AssetImage('assets/images/profile.png'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: responsive.widthPercent(7)),

                  //-----------------Nombre, editar, ajustes-----------------
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //-------------------Nombre------------------------
                        Text(
                          widget.userApp.fullName ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: responsive.diagonalPercent(2.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: responsive.heightPercent(0.8)),

                        //-------------------Deporte------------------------
                        Text(
                          '${toBeginningOfSentenceCase(widget.userApp.type ?? '')} | ${widget.userApp.country ?? ''}',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: responsive.diagonalPercent(2.1),
                                    color: AppColors.greyscale2,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: responsive.heightPercent(1)),

                        //----------------Editar y ajustes-------------------
                        Visibility(
                          visible: widget.isloggedUser,
                          child: Row(
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
                                    if (m.id == userService.userApp!.modality) {
                                      editProfileProvider.modality = m;
                                      break;
                                    }
                                  }
                                  editProfileProvider
                                      .initializeData(userService.userApp!);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: responsive.widthPercent(4)),

                              //----------------------Ajustes----------------------
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    SettingsScreen.routeName,
                                  );
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
                        ),

                        Visibility(
                          visible: !widget.isloggedUser,
                          child: SizedBox(
                            width: responsive.width,
                            child: MaterialButton(
                              textColor: (isFollowing)
                                  ? AppColors.brandColor
                                  : AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0.0,
                              color: (isFollowing)
                                  ? AppColors.whiteColor
                                  : AppColors.brandColor,
                              onPressed: (isFollowing)
                                  ? () async {
                                      //Opcion Siguiendo
                                      await userService.unfollow(
                                        widget.userApp,
                                      );
                                      await postsService.getFollowingPosts(
                                        userService.userApp!,
                                      );
                                      setState(() {});
                                    }
                                  : () async {
                                      //Opcion Seguir
                                      await userService.follow(
                                        widget.userApp,
                                      );
                                      await postsService.getFollowingPosts(
                                        userService.userApp!,
                                      );
                                      setState(() {});
                                    },
                              child: Text(
                                (isFollowing)
                                    ? Localization.of(context)
                                        .string("wall_followers_following")
                                    : Localization.of(context)
                                        .string("wall_followers_follow"),
                                style: TextStyle(
                                  fontSize: responsive.diagonalPercent(1.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.heightPercent(1.5)),
              if (userService.userApp?.bio != null)
                Text(userService.userApp!.bio!),
              if (userService.userApp?.bio != null)
                SizedBox(height: responsive.heightPercent(1.5)),
              const Divider(),
              SizedBox(height: responsive.heightPercent(1)),

              //----------------Seguidores, siguiendo, publicaciones---------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //------------------------Seguidores---------------------------
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: responsive.diagonalPercent(2.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              Localization.of(context)
                                  .string('wall_home_followers_text'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: responsive.diagonalPercent(2.1),
                                  ),
                            ),
                          ],
                        ),
                      ),

                      //---------------------------Seguidos---------------------------
                      GestureDetector(
                        onTap: () async {
                          await userService.getFollowing();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileFollowScreen(
                                userApp: userService.userApp!,
                                typeFollow: TypeFollow.seguidos,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              followingString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: responsive.diagonalPercent(2.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              Localization.of(context)
                                  .string('wall_home_following_text'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: responsive.diagonalPercent(2.1),
                                  ),
                            ),
                          ],
                        ),
                      ),

                      //-----------------------------Posts----------------------------
                      GestureDetector(
                        child: Column(
                          children: [
                            Text(
                              publicationsString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: responsive.diagonalPercent(2.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              Localization.of(context)
                                  .string('wall_home_publications_text'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: responsive.diagonalPercent(2.1),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: responsive.heightPercent(1)),
              const Divider(),
              SizedBox(height: responsive.heightPercent(1.5)),

              //---------------Publicaciones, retos y guardados------------------
              (widget.userPosts.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Center(
                        child: Text(
                          Localization.of(context).string("no_posts_to_show"),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.greyscale2,
                                    fontSize: responsive.diagonalPercent(2.5),
                                  ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: PublicationsGrid(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostsListScreen(
                                title: Localization.of(context)
                                    .string('posts_screen_my_posts'),
                                posts: widget.userPosts,
                              ),
                            ),
                          );
                        },
                        posts: widget.userPosts,
                      ),
                    )
            ],
          ),
        ),
      ),

      //-------------------------CustomBottomNavigationBar------------------------
      bottomNavigationBar: (!widget.isloggedUser)
          ? null
          : const CustomBottomNavigationBar(
              selectedIndex: 4,
            ),
    );
  }
}
