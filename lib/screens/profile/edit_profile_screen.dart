// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/providers/edit_profile_provider.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/services/sports_service.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

//WallProfilePage
class EditProfileScreen extends StatefulWidget {
  static const String routeName = 'edit_profile_screen';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<void> _saveChanges(
      UserService userService, EditProfileProvider editProfileProvider) async {
    UserApp userAppToUpdate = userService.userApp!;

    userAppToUpdate.fullName = editProfileProvider.tecFullName.text;
    userAppToUpdate.userName = editProfileProvider.tecUserName.text;
    userAppToUpdate.bio = editProfileProvider.tecBio.text;
    userAppToUpdate.phone = editProfileProvider.tecPhone.text;
    userAppToUpdate.sport = editProfileProvider.sport!.id;
    userAppToUpdate.modality = editProfileProvider.modality!.id;

    await userService.updateUser(userAppToUpdate);
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
    final EditProfileProvider editProfileProvider =
        Provider.of<EditProfileProvider>(context);

    final Responsive responsive = Responsive.of(context);
    final double spaceBetweenFacts = responsive.heightPercent(2.5);
    final double avatarSize = responsive.heightPercent(20);

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      //-------------------------------body-------------------------------------
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //--------------------Mi perfil y flecha atras------------------
                CustomAppBar(
                  title: Localization.of(context).string('wall_profile_title'),
                  style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                    fontSize: responsive.diagonalPercent(3.5),
                    fontWeight: FontWeight.bold,
                  ),
                  iconColor: AppColors.blueColor,
                ),

                //-----------------------Info mi perfil-------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-------------------------Foto-----------------------------
                      FutureBuilder(
                        future: userService
                            .profileImageURL(userService.userApp!.id ?? ''),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData && snapshot.data != '') {
                            return Center(
                              child: CircleEditableAvatar(
                                size: avatarSize,
                                image:
                                    CachedNetworkImageProvider(snapshot.data!),
                                iconColor: AppColors.greyscale5,
                                iconBackgroundColor: AppColors.yellowColor,
                              ),
                            );
                          }
                          return Center(
                            child: CircleEditableAvatar(
                              size: avatarSize,
                              image:
                                  const AssetImage('assets/images/profile.png'),
                              iconColor: AppColors.greyscale5,
                              iconBackgroundColor: AppColors.yellowColor,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: spaceBetweenFacts),

                      //-------------------Datos principales----------------------
                      Text(
                        Localization.of(context)
                            .string('wall_profile_personal_info'),
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
                      // _WallProfileFact(
                      //   text: Localization.of(context)
                      //       .string('wall_profile_age'),
                      //   textEditingController: _controllerAge,
                      // ),
                      // SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text:
                            Localization.of(context).string('wall_profile_bio'),
                        textEditingController: editProfileProvider.tecBio,
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      // _WallProfileFact(
                      //   text: Localization.of(context)
                      //       .string('wall_profile_email'),
                      //   textEditingController: _controllerEmail,
                      // ),
                      // SizedBox(height: spaceBetweenFacts),
                      EditProfileFact(
                        text: Localization.of(context)
                            .string('wall_profile_phone'),
                        textEditingController: editProfileProvider.tecPhone,
                      ),
                      SizedBox(height: spaceBetweenFacts + 30),

                      //-------------------Categoría deportiva--------------------
                      Text(
                        Localization.of(context)
                            .string('wall_profile_sport_category'),
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      _WallProfileDropdownFactSports(
                        text: Localization.of(context)
                            .string('wall_profile_sport'),
                        dropdownOptions: sportsService.sports ?? [],
                        dropdownValue: editProfileProvider.sport,
                        onChanged: (Sport? newValue) {
                          editProfileProvider.sport = newValue;
                          // _authViewModel
                          //     .getModalitiesBySport(newValue!.reference);
                          // setState(() {
                          //   // _setModalities(_sport!);
                          // });
                        },
                      ),
                      SizedBox(height: spaceBetweenFacts),
                      // _WallProfileDropdownFactModalities(
                      //   text: Localization.of(context)
                      //       .string('wall_profile_modality'),
                      //   dropdownOptions: _modalities ?? [],
                      //   dropdownValue: _modality, //${user.modality}
                      //   onChanged: (newValue) {
                      //     _modality = newValue;
                      //     setState(() {});
                      //   },
                      // ),

                      SizedBox(height: spaceBetweenFacts + 30),

                      //---------------------Guardar cambios---------------------
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: YellowTextButton(
                            title: Localization.of(context)
                                .string('wall_profile_save_changes'),
                            onPressed: (userService.isLoading)
                                ? null
                                : () async {
                                    // await _saveUserData();
                                    // _authViewModel.registerUser(_userApp!);
                                    _saveChanges(
                                        userService, editProfileProvider);
                                  },
                          ),
                        ),
                      ),
                      SizedBox(height: spaceBetweenFacts),

                      //--------------------Descartar cambios--------------------
                      GestureDetector(
                        onTap: (userService.isLoading)
                            ? null
                            : () async {
                                Navigator.pop(context);
                              },
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
      //-------------------------CustomBottomNavigationBar-----------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 4,
      ),
    );
  }
}

class _WallProfileDropdownFactSports extends StatelessWidget {
  final String text;
  final List<Sport> dropdownOptions;
  final void Function(Sport?)? onChanged;
  Sport? dropdownValue;

  _WallProfileDropdownFactSports({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownOptions,
  }) : super(key: key);

  List<DropdownMenuItem<Sport>> dropdownMenuItems = [];

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    for (Sport dropdownOption in dropdownOptions) {
      String name =
          'SportType.fromJson(doc.data() as Map<String, dynamic>).name!';
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: dropdownOption,
          child: Text(dropdownOption.name!),
        ),
      );
    }

    final Sport? value = (dropdownValue != null)
        ? dropdownOptions.firstWhere((doc) => doc.name == dropdownValue?.name)
        : null;

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.mediunLightGrey),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Sport>(
              dropdownColor: AppColors.whiteColor,
              focusColor: AppColors.darkGrey.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.coinGrey,
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
  final List<DocumentSnapshot> dropdownOptions;
  final void Function(DocumentSnapshot?)? onChanged;
  DocumentSnapshot? dropdownValue;

  _WallProfileDropdownFactModalities({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownOptions,
  }) : super(key: key);

  List<DropdownMenuItem<DocumentSnapshot>> dropdownMenuItems = [];

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    for (var doc in dropdownOptions) {
      // String name = Modality.fromJson(doc.data() as Map<String, dynamic>).name!;
      String name =
          'Modality.fromJson(doc.data() as Map<String, dynamic>).name!';
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: doc,
          child: Text(toBeginningOfSentenceCase(name)!),
        ),
      );
    }

    DocumentSnapshot? value;
    if (dropdownValue != null &&
        dropdownOptions.any((doc) => doc.id == dropdownValue!.id)) {
      value = dropdownOptions.firstWhere((doc) => doc.id == dropdownValue?.id);
    } else if (dropdownOptions.isNotEmpty) {
      value = dropdownOptions[0];
    }

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.mediunLightGrey),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DocumentSnapshot>(
              dropdownColor: AppColors.whiteColor,
              focusColor: AppColors.darkGrey.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.coinGrey,
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
