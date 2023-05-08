// ignore_for_file: sort_child_properties_last
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/screens/profile/profile_screen.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

enum TypeFollow { seguidores, seguidos }

enum TypeUser { todos, scouters, deportistas }

//WallFollowersPage
class ProfileFollowScreen extends StatefulWidget {
  final UserApp userApp;
  final TypeFollow typeFollow;

  const ProfileFollowScreen({
    Key? key,
    required this.typeFollow,
    required this.userApp,
  }) : super(key: key);

  @override
  State<ProfileFollowScreen> createState() => _ProfileFollowScreenState();
}

class _ProfileFollowScreenState extends State<ProfileFollowScreen> {
  UserApp? userApp;
  // Para mostrar a los seguidores o a los seguidos usamos esta variable:
  late TypeFollow _typeFollow;
  // Para mostrar a los seguidores/seguidos que son scouters o deportistas usamos esta variable:
  TypeUser _typeUser = TypeUser.todos;
  String followersString = '';
  String followingString = '';
  int scoutersValue = 0;
  int athletesValue = 0;
  // Lista de usuarios a mostrar en la pantalla
  List<UserApp> usersToShow = [];

  @override
  void initState() {
    super.initState();
    _typeFollow = widget.typeFollow;
    userApp = widget.userApp;
    changeFollow();
  }

  void changeFollow() async {
    double followersValue = userApp!.followers!.length.toDouble();
    followersString = Util.adaptNumFollow(followersValue);
    double followingValue = userApp!.following!.length.toDouble();
    followingString = Util.adaptNumFollow(followingValue);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final UserService userService = Provider.of<UserService>(
      context,
      listen: true,
    );

    switch (_typeFollow) {
      case TypeFollow.seguidores:
        usersToShow.clear();
        usersToShow.addAll(userService.followers);
        scoutersValue = 0;
        athletesValue = 0;
        for (UserApp userToShow in usersToShow) {
          if (userToShow.type == 'scouter') scoutersValue++;
          if (userToShow.type == 'athlete') athletesValue++;
        }
        switch (_typeUser) {
          case TypeUser.todos:
            break;
          case TypeUser.scouters:
            usersToShow
                .removeWhere((UserApp element) => element.type != 'scouter');
            break;
          case TypeUser.deportistas:
            usersToShow
                .removeWhere((UserApp element) => element.type != 'athlete');
            break;
          default:
        }
        break;
      case TypeFollow.seguidos:
        usersToShow.clear();
        usersToShow.addAll(userService.following);
        scoutersValue = 0;
        athletesValue = 0;
        for (UserApp userToShow in usersToShow) {
          if (userToShow.type == 'scouter') scoutersValue++;
          if (userToShow.type == 'athlete') athletesValue++;
        }
        switch (_typeUser) {
          case TypeUser.todos:
            break;
          case TypeUser.scouters:
            usersToShow
                .removeWhere((UserApp element) => element.type != 'scouter');
            break;
          case TypeUser.deportistas:
            usersToShow
                .removeWhere((UserApp element) => element.type != 'athlete');
            break;
          default:
        }
        break;
      default:
    }

    List<Widget> typeUserContainers = [
      //----------------------todos--------------------------
      _TypeUserContainer(
        title: 'todos',
        typeUser: _typeUser,
        typeUserCompare: TypeUser.todos,
        onTap: () {
          _typeUser = TypeUser.todos;
          //TODO: mostrar todos los seguidores/seguidos
          setState(() {});
        },
      ),

      //----------------------scouters-------------------------
      _TypeUserContainer(
        title: '$scoutersValue scouters',
        typeUser: _typeUser,
        typeUserCompare: TypeUser.scouters,
        onTap: () {
          _typeUser = TypeUser.scouters;
          //TODO: mostrar seguidores/seguidos que son scouters
          setState(() {});
        },
      ),

      //--------------------deportistas-----------------------
      _TypeUserContainer(
        title: '$athletesValue deportistas',
        typeUser: _typeUser,
        typeUserCompare: TypeUser.deportistas,
        onTap: () {
          _typeUser = TypeUser.deportistas;
          //TODO: mostrar seguidores/seguidos que son deportistas
          setState(() {});
        },
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      //---------------------Nombre usuario y flecha atras----------------------
      appBar: CustomAppBar(
        title: userService.userApp!.fullName!,
        style: AppThemes.ligthTextTheme.bodyLarge!.copyWith(
          fontSize: responsive.diagonalPercent(3),
          fontWeight: FontWeight.w700,
          color: AppColors.greyscale5,
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userApp: userApp!,
                isLoguedUser: userApp!.id == userService.userApp!.id,
              ),
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
            size: responsive.heightPercent(3),
          ),
        ),
      ),
      //-------------------------------body-------------------------------------
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: responsive.heightPercent(1)),

                //---------------------Filtros de busqueda----------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //----------------------seguidores - seguidos----------------
                      Row(
                        children: [
                          //--------------------seguidores-------------------------
                          _TypeFollowContainer(
                            title:
                                '$followersString ${Localization.of(context).string("wall_home_followers_text")}',
                            typeFollow: _typeFollow,
                            typeFollowCompare: TypeFollow.seguidores,
                            onTap: () async {
                              _typeFollow = TypeFollow.seguidores;
                              if (userService.followers.isEmpty) {
                                await userService.getFollowers();
                              }
                              changeFollow();
                              setState(() {});
                            },
                          ),
                          SizedBox(width: responsive.widthPercent(6)),

                          //---------------------seguidos-------------------------
                          _TypeFollowContainer(
                            title:
                                '$followingString  ${Localization.of(context).string("wall_home_following_text")}',
                            typeFollow: _typeFollow,
                            typeFollowCompare: TypeFollow.seguidos,
                            onTap: () async {
                              _typeFollow = TypeFollow.seguidos;
                              if (userService.following.isEmpty) {
                                await userService.getFollowing();
                              }
                              changeFollow();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.heightPercent(2)),

                      //-----------------todos-scouters-deportistas---------------
                      SizedBox(
                        height: responsive.heightPercent(5),
                        width: responsive.width,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: typeUserContainers.length,
                          itemBuilder: (context, index) {
                            return typeUserContainers[index];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.heightPercent(2)),

                //-----------------Lista seguidores/seguidos------------------
                if (userService.isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!userService.isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: responsive.heightPercent(63),
                    width: responsive.width,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: usersToShow.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (userService.userApp == null) return Container();
                        bool isFollowing = false;
                        // String stringToCompare = '';
                        for (DocumentReference? idFollowing
                            in userService.userApp!.following!) {
                          // stringToCompare = idFollowing
                          //     .toString()
                          //     .split('(')[1]
                          //     .split(')')[0]
                          //     .split('/')[1];
                          if (idFollowing == usersToShow[index].id) {
                            isFollowing = true;
                            break;
                          }
                        }

                        return ListTile(
                          leading: FutureBuilder(
                            future: userService.getProfileImageURL(
                                usersToShow[index].id!.path.split('/')[1]),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return Container(
                                height: responsive.heightPercent(16),
                                width: responsive.widthPercent(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: (snapshot.hasData)
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              snapshot.data!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                          title: Text(
                            usersToShow[index].fullName!,
                            style: AppThemes.ligthTextTheme.bodyLarge!.copyWith(
                              color: AppColors.greyscale5,
                              fontSize: responsive.widthPercent(4),
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            typeString(context, usersToShow[index].type ?? ''),
                            style: AppThemes.ligthTextTheme.bodyLarge!.copyWith(
                              color: AppColors.greyscale2,
                              fontSize: responsive.widthPercent(3.5),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //--------------------Icono x-----------------------
                              if (_typeFollow == TypeFollow.seguidores)
                                GestureDetector(
                                  onTap: () {
                                    if (Platform.isAndroid) {
                                      showDialogX(context, usersToShow[index]);
                                    }
                                    if (Platform.isIOS) {
                                      showCupertinoDialogX(
                                          context, usersToShow[index]);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.greyscale2,
                                  ),
                                ),
                              SizedBox(width: responsive.widthPercent(2.5)),

                              //-------------Boton seguir/siguiendo----------------
                              SizedBox(
                                width: responsive.widthPercent(25),
                                child: MaterialButton(
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
                                          await userService
                                              .unfollow(usersToShow[index]);
                                          changeFollow();
                                          setState(() {});
                                        }
                                      : () async {
                                          //Opcion Seguir
                                          // await _viewModel
                                          //     .follow(usersToShow[index]);
                                          await userService
                                              .follow(usersToShow[index]);
                                          // await Future.delayed(
                                          //     const Duration(seconds: 2));
                                          // await _viewModel.getUser();
                                          // await userService.getFollowing();
                                          changeFollow();
                                          setState(() {});
                                        },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String typeString(BuildContext context, String string) {
    switch (string) {
      case 'athlete':
        String aux = Localization.of(context).string('register_type_athlete');
        String inicial = aux.substring(0, 1).toUpperCase();
        String resto = aux.substring(1, aux.length);
        return '$inicial$resto';
      case 'scouter':
        String aux = Localization.of(context).string('register_type_scouter');
        String inicial = aux.substring(0, 1).toUpperCase();
        String resto = aux.substring(1, aux.length);
        return '$inicial$resto';
      case 'manager':
        String aux = Localization.of(context).string('register_type_manager');
        String inicial = aux.substring(0, 1).toUpperCase();
        String resto = aux.substring(1, aux.length);
        return '$inicial$resto';
      default:
        return '';
    }
  }

  Future<void> onPressedDialogX(
      BuildContext context, UserApp followerToRemove) async {
    // await _viewModel.removeFollower(followerToRemove);
    // Navigator.pop(context);
    // await Future.delayed(const Duration(seconds: 2));
    // await _viewModel.getUser();
  }

  Future<dynamic> showDialogX(BuildContext context, UserApp followerToRemove) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            title: Center(
              child: Text(
                Localization.of(context).string("wall_followers_delete"),
                style: AppThemes.darkTextTheme.displayMedium,
              ),
            ),
            actionsAlignment: MainAxisAlignment.end,
            backgroundColor: AppColors.greyscale5,
            content: Text(
              Localization.of(context).string("wall_followers_message",
                  params: [followerToRemove.fullName!]),
              style: AppThemes.darkTextTheme.bodyLarge,
            ),
            actions: [
              MaterialButton(
                onPressed: () => onPressedDialogX(context, followerToRemove),
                elevation: 0.0,
                textColor: AppColors.greyscale2,
                child: Text(
                  Localization.of(context).string("wall_followers_yes"),
                ),
              ),
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                elevation: 5,
                textColor: AppColors.brandColor,
                child: Text(
                  Localization.of(context).string("wall_followers_no"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showCupertinoDialogX(
      BuildContext context, UserApp followerToRemove) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: CupertinoAlertDialog(
            title: Center(
              child: Text(
                Localization.of(context).string("wall_followers_delete"),
                style: AppThemes.ligthTextTheme.displayMedium,
              ),
            ),
            content: Text(
              Localization.of(context).string("wall_followers_message",
                  params: [followerToRemove.fullName!]),
              style: AppThemes.ligthTextTheme.bodyLarge,
            ),
            actions: [
              MaterialButton(
                onPressed: () => onPressedDialogX(context, followerToRemove),
                elevation: 0.0,
                textColor: AppColors.greyscale2,
                child: Text(
                  Localization.of(context).string("wall_followers_yes"),
                ),
              ),
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                elevation: 5,
                textColor: AppColors.brandColor,
                child: Text(
                  Localization.of(context).string("wall_followers_no"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TypeFollowContainer extends StatelessWidget {
  final String title;
  final TypeFollow _typeFollow;
  final TypeFollow _typeFollowCompare;
  final Function()? onTap;

  const _TypeFollowContainer({
    Key? key,
    required TypeFollow typeFollow,
    required this.title,
    this.onTap,
    required TypeFollow typeFollowCompare,
  })  : _typeFollow = typeFollow,
        _typeFollowCompare = typeFollowCompare,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: Responsive.of(context).widthPercent(4),
            fontWeight: (_typeFollow == _typeFollowCompare)
                ? FontWeight.bold
                : FontWeight.normal,
            color: (_typeFollow == _typeFollowCompare)
                ? AppColors.blackColor
                : AppColors.greyscale2,
          ),
        ),
        decoration: BoxDecoration(
          border: (_typeFollow == _typeFollowCompare)
              ? const Border(
                  bottom: BorderSide(
                    width: 1.7,
                    color: AppColors.blackColor,
                  ),
                )
              : const Border(),
        ),
      ),
    );
  }
}

class _TypeUserContainer extends StatelessWidget {
  final String title;
  final TypeUser _typeUser;
  final TypeUser _typeUserCompare;
  final Function()? onTap;

  const _TypeUserContainer({
    Key? key,
    required TypeUser typeUser,
    required this.title,
    this.onTap,
    required TypeUser typeUserCompare,
  })  : _typeUser = typeUser,
        _typeUserCompare = typeUserCompare,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 5),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.brandColor,
              fontSize: responsive.widthPercent(3.5),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (_typeUser == _typeUserCompare)
              ? Colors.white
              : AppColors.brandColor.withOpacity(0.2),
          border: (_typeUser == _typeUserCompare)
              ? Border.all(
                  color: AppColors.brandColor,
                  width: 2,
                )
              : const Border(),
        ),
      ),
    );
  }
}
