// ignore_for_file: unnecessary_new, must_be_immutable

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/providers/edit_profile_provider.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = 'edit_profile_screen';
  bool isProfileCompleted;

  EditProfileScreen({
    Key? key,
    this.isProfileCompleted = true,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<void> _saveChanges(UserService userService, File? file,
      EditProfileProvider editProfileProvider) async {
    UserApp userAppToUpdate = UserApp();

    userAppToUpdate.fullName = editProfileProvider.tecFullName.text;
    userAppToUpdate.userName = editProfileProvider.tecUserName.text;
    userAppToUpdate.bio = editProfileProvider.tecBio.text;
    userAppToUpdate.phone = editProfileProvider.tecPhone.text;
    userAppToUpdate.birthdate = editProfileProvider.birthdate;
    userAppToUpdate.country = editProfileProvider.tecCountry.text;
    userAppToUpdate.sport = editProfileProvider.sport!.id;
    userAppToUpdate.modality = editProfileProvider.modality!.id;

    await userService.updateUser(userAppToUpdate);
    if (file != null) {
      await userService.uploadImageProfile(file.path);
    }
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProfileScreen(
    //       userApp: userService.userApp!,
    //       userPosts: userService.userPosts,
    //       isloggedUser: true,
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);
    final SportsService sportsService = Provider.of<SportsService>(context);
    final PostsService postsService = Provider.of<PostsService>(
      context,
      listen: false,
    );
    final ChatsService chatsService = Provider.of<ChatsService>(
      context,
      listen: false,
    );
    final ModalitiesService modalitiesService = Provider.of<ModalitiesService>(
      context,
    );
    final EditProfileProvider editProfileProvider =
        Provider.of<EditProfileProvider>(
      context,
    );

    final Responsive responsive = Responsive.of(context);

    final double spaceBetweenFacts = responsive.heightPercent(2.5);
    final double avatarSize = responsive.heightPercent(20);
    CircleEditableAvatar circleEditableAvatar = CircleEditableAvatar(
      size: avatarSize,
      image: null,
      file: null,
      iconColor: AppColors.greyscale5,
      iconBackgroundColor: AppColors.yellowColor,
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      //-----------------------------appBar---------------------------------------
      appBar: CustomAppBar(
        title: Localization.of(context).string('wall_profile_title'),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: responsive.diagonalPercent(3),
              fontWeight: FontWeight.bold,
            ),
        leading: (widget.isProfileCompleted)
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ProfileScreen(
                  //       userApp: userService.userApp!,
                  //       userPosts: userService.userPosts,
                  //       isloggedUser: true,
                  //     ),
                  //   ),
                  // );
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.blueColor,
                  size: responsive.heightPercent(3),
                ),
              )
            : null,
      ),

      //-------------------------------body-------------------------------------
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //-----------------------Info mi perfil-------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-------------------------Foto-----------------------------
                      FutureBuilder(
                        future: userService
                            .getProfileImageURL(userService.userApp!.id!.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData && snapshot.data != '') {
                            circleEditableAvatar.image = Image(
                              image: CachedNetworkImageProvider(snapshot.data!),
                              fit: BoxFit.cover,
                            );
                          } else {
                            circleEditableAvatar.image = const Image(
                              image: AssetImage('assets/images/profile.png'),
                              fit: BoxFit.cover,
                            );
                          }
                          return Center(
                            child: circleEditableAvatar,
                          );
                          // return Center(
                          //   child: CircleEditableAvatar(
                          //     size: avatarSize,
                          //     image: const Image(
                          //       image: AssetImage('assets/images/profile.png'),
                          //     ),
                          //     file: file,
                          //     iconColor: AppColors.greyscale5,
                          //     iconBackgroundColor: AppColors.yellowColor,
                          //   ),
                          // );
                        },
                      ),
                      SizedBox(height: spaceBetweenFacts),

                      //-------------------Informacion personal----------------------
                      Text(
                        Localization.of(context)
                            .string('wall_profile_personal_info'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: responsive.diagonalPercent(3),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text: Localization.of(context)
                            .string('wall_profile_name'),
                        textEditingController: editProfileProvider.tecFullName,
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text: Localization.of(context)
                            .string('wall_profile_user'),
                        textEditingController: editProfileProvider.tecUserName,
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text:
                            Localization.of(context).string('wall_profile_bio'),
                        textEditingController: editProfileProvider.tecBio,
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text: Localization.of(context)
                            .string('wall_profile_phone'),
                        textEditingController: editProfileProvider.tecPhone,
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text: Localization.of(context).string(
                          'wall_profile_birthdate',
                        ),
                        textEditingController: editProfileProvider.tecbirthdate,
                        isbirthdate: true,
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text: Localization.of(context).string(
                          'wall_profile_country',
                        ),
                        textEditingController: editProfileProvider.tecCountry,
                      ),
                      SizedBox(height: spaceBetweenFacts + 30),

                      //-------------------Categoría deportiva--------------------
                      Text(
                        Localization.of(context).string(
                          'wall_profile_sport_category',
                        ),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: responsive.diagonalPercent(3),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      _WallProfileDropdownFactSports(
                        text: Localization.of(context).string(
                          'wall_profile_sport',
                        ),
                        dropdownOptions: sportsService.sports,
                        dropdownValue: editProfileProvider.sport,
                        onChanged: (Sport? newValue) async {
                          editProfileProvider.sport = newValue;
                          await modalitiesService
                              .getModalitiesBySport(newValue!);
                          editProfileProvider.modality =
                              modalitiesService.modalities[0];
                          setState(() {});
                        },
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      _WallProfileDropdownFactModalities(
                        text: Localization.of(context).string(
                          'wall_profile_modality',
                        ),
                        dropdownOptions: modalitiesService.modalities,
                        dropdownValue: editProfileProvider.modality,
                        onChanged: (Modality? newValue) {
                          editProfileProvider.modality = newValue;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: spaceBetweenFacts + 30),

                      //---------------------Guardar cambios---------------------
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: YellowTextButton(
                            title: Localization.of(context).string(
                              'wall_profile_save_changes',
                            ),
                            onPressed: (userService.isLoading)
                                ? null
                                : () async {
                                    if (editProfileProvider.isValid()) {
                                      if (!widget.isProfileCompleted) {
                                        chatsService.getUserChats(
                                          userService.userApp!,
                                        );
                                        postsService.getFollowingPosts(
                                          userService.userApp!,
                                        );
                                      }
                                      await _saveChanges(
                                        userService,
                                        circleEditableAvatar.file,
                                        editProfileProvider,
                                      );
                                    } else {
                                      //TODO: alertdialog
                                      Util.showCustomDialog(
                                        context: context,
                                        child: Text(
                                          Localization.of(context).string(
                                            "edit_profile_empty_fields",
                                          ),
                                          style: AppThemes
                                              .darkTextTheme.bodyLarge!
                                              .copyWith(
                                            fontSize:
                                                responsive.diagonalPercent(2),
                                          ),
                                        ),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            elevation: 0.0,
                                            textColor: AppColors.whiteColor,
                                            child: Text(
                                              Localization.of(context)
                                                  .string("common_ok"),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                          ),
                        ),
                      ),
                      SizedBox(height: spaceBetweenFacts),

                      //--------------------Descartar cambios--------------------
                      if (widget.isProfileCompleted)
                        GestureDetector(
                          onTap: (userService.isLoading)
                              ? null
                              : () => Navigator.pop(context),
                          child: SizedBox(
                            width: responsive.width,
                            child: Text(
                              Localization.of(context)
                                  .string('wall_profile_discard'),
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.blackColor,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      SizedBox(height: spaceBetweenFacts + 90),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WallProfileDropdownFact<T> extends StatelessWidget {
  final String text;
  final List<T> dropdownOptions;
  final void Function(T?)? onChanged;
  T? dropdownValue;

  _WallProfileDropdownFact({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownOptions,
  }) : super(key: key);

  List<DropdownMenuItem<T>> dropdownMenuItems = [];

  @override
  Widget build(BuildContext context) {
    bool isSport;
    bool isModality;
    try {
      isSport = ((T as Sport) == true);
    } catch (e) {
      isSport = false;
    }
    try {
      isModality = ((T as Modality) == true);
    } catch (e) {
      isModality = false;
    }
    if (!isModality && !isSport) {
      return const Text('Error');
    }

    final Responsive responsive = Responsive.of(context);
    for (T dropdownOption in dropdownOptions) {
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: dropdownOption,
          child: Text((isSport)
              ? (dropdownOption as Sport).name!
              : (dropdownOption as Modality).name!),
        ),
      );
    }

    final T? value = (dropdownValue != null)
        ? dropdownOptions.firstWhere((T doc) {
            if (isSport) {
              return (doc as Sport).name == (dropdownValue as Sport).name;
            } else {
              return (doc as Modality).name == (dropdownValue as Modality).name;
            }
          })
        : null;

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.greyscale2),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              dropdownColor: AppColors.whiteColor,
              focusColor: AppColors.greyscale5.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.greyscale1,
              ),
              items: dropdownMenuItems,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _WallProfileDropdownFactSports extends StatelessWidget {
  final String text;
  final List<Sport> dropdownOptions;
  final void Function(Sport?)? onChanged;
  Sport? dropdownValue;
  List<DropdownMenuItem<Sport>> dropdownMenuItems = [];

  _WallProfileDropdownFactSports({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    for (Sport dropdownOption in dropdownOptions) {
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: dropdownOption,
          child: Text(dropdownOption.name!),
        ),
      );
    }

    final Sport? value = (dropdownValue != null)
        ? dropdownOptions.firstWhere((doc) => doc.id == dropdownValue!.id)
        : null;

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.greyscale2),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Sport>(
              dropdownColor: AppColors.whiteColor,
              focusColor: AppColors.greyscale5.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.greyscale1,
              ),
              items: dropdownMenuItems,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _WallProfileDropdownFactModalities extends StatelessWidget {
  final String text;
  final List<Modality> dropdownOptions;
  final void Function(Modality?)? onChanged;
  Modality? dropdownValue;
  List<DropdownMenuItem<Modality>> dropdownMenuItems = [];

  _WallProfileDropdownFactModalities({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    for (Modality dropdownOption in dropdownOptions) {
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: dropdownOption,
          child: Text(dropdownOption.name!),
        ),
      );
    }

    Modality? value;
    if (dropdownValue != null &&
        dropdownOptions.any((doc) => doc.id == dropdownValue!.id)) {
      value = dropdownOptions
          .firstWhere((Modality doc) => doc.id == dropdownValue?.id);
    } else if (dropdownOptions.isNotEmpty) {
      value = dropdownOptions[0];
    }

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.greyscale2),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Modality>(
              dropdownColor: AppColors.whiteColor,
              focusColor: AppColors.greyscale5.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.greyscale1,
              ),
              items: dropdownMenuItems,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
