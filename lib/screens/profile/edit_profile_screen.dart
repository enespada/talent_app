// ignore_for_file: unnecessary_new

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/auth_service.dart';
import 'package:talent_app/services/user_service.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/style/app_styles.dart';
import 'package:talent_app/widgets/square_editable_avatar.dart';
import 'package:talent_app/widgets/yellow_text_button.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

//WallProfilePage
class EditProfileScreen extends StatefulWidget {
  // static const List<String> _examples = [
  //   'Ejemplo1',
  //   'Ejemplo2',
  //   'Ejemplo3',
  // ];
  static const String routeName = 'edit_profile_screen';
  final UserApp? user;

  const EditProfileScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<DocumentReference>? _listSport;
  List<DocumentSnapshot>? _sports;
  List<DocumentSnapshot>? _modalities;

  TextEditingController? _controllerName;
  TextEditingController? _controllerUser;
  TextEditingController? _controllerAge;
  TextEditingController? _controllerBio;
  TextEditingController? _controllerEmail;
  TextEditingController? _controllerPhone;
  DocumentSnapshot? _sport;
  DocumentSnapshot? _modality;
  UserApp? _userApp;

  @override
  void initState() {
    super.initState();

    // _userViewModel.getUserState.stream.listen((state) {
    //   switch (state.status) {
    //     case Status.LOADING:
    //       LoadingOverlay.of(context).show();
    //       break;
    //     case Status.COMPLETED:
    //       LoadingOverlay.of(context).hide();
    //       setState(() {
    //         _user = state.data;
    //       });
    //       break;
    //     case Status.ERROR:
    //       LoadingOverlay.of(context).hide();
    //       ErrorOverlay.of(context).show(state.error);
    //       break;
    //     default:
    //       LoadingOverlay.of(context).hide();
    //       break;
    //   }
    // });

    //-------------------------------getSports---------------------------------
    // _authViewModel.getModalitiesState.stream.listen((state) {
    //   switch (state.status) {
    //     case Status.LOADING:
    //       LoadingOverlay.of(context).show();
    //       break;
    //     case Status.COMPLETED:
    //       LoadingOverlay.of(context).hide();
    //       _modalities = state.data;
    //       setState(() {});
    //       break;
    //     case Status.ERROR:
    //       LoadingOverlay.of(context).hide();
    //       ErrorOverlay.of(context).show(state.error);
    //       break;
    //     default:
    //       LoadingOverlay.of(context).hide();
    //       break;
    //   }
    // });

    // _authViewModel.getSportsState.stream.listen((state) async {
    //   switch (state.status) {
    //     case Status.LOADING:
    //       LoadingOverlay.of(context).show();
    //       break;
    //     case Status.COMPLETED:
    //       LoadingOverlay.of(context).hide();
    //       _sports = state.data;
    //       await initData();
    //       setState(() {});
    //       _authViewModel.getModalitiesBySport(_sport!.reference);
    //       break;
    //     case Status.ERROR:
    //       LoadingOverlay.of(context).hide();
    //       ErrorOverlay.of(context).show(state.error);
    //       break;
    //     default:
    //       LoadingOverlay.of(context).hide();
    //       break;
    //   }
    // });
    // _authViewModel.getSports();

    //-------------------------------UpdateUser---------------------------------
    // _authViewModel.registerUserState.stream.listen((state) {
    //   switch (state.status) {
    //     case Status.LOADING:
    //       LoadingOverlay.of(context).show();
    //       break;
    //     case Status.COMPLETED:
    //       LoadingOverlay.of(context).hide();
    //       _userViewModel.getUser();
    //       break;
    //     case Status.ERROR:
    //       LoadingOverlay.of(context).hide();
    //       ErrorOverlay.of(context).show(state.error);
    //       break;
    //     default:
    //       LoadingOverlay.of(context).hide();
    //       break;
    //   }
    // });
  }

  Future<void> _saveUserData() async {
    _userApp?.fullName = _controllerName?.text;
    _userApp?.userName = _controllerUser?.text;
    _userApp?.birthday = _controllerAge?.text;
    _userApp?.bio = _controllerBio?.text;
    _userApp?.email = _controllerEmail?.text;
    _userApp?.phone = _controllerPhone?.text;
    _userApp?.sport = _sport?.reference;
    _userApp?.modality = _modality?.reference;
  }

  Future<void> initData() async {
    _userApp = widget.user;
    _sport = await _userApp!.sport!.get();
    _modality = await _userApp!.modality!.get();

    _controllerName = new TextEditingController(text: '${_userApp?.fullName}');
    _controllerUser = new TextEditingController(text: '${_userApp?.userName}');
    _controllerAge = new TextEditingController(text: '${_userApp?.birthday}');
    _controllerBio = new TextEditingController(text: '${_userApp?.bio}');
    _controllerEmail = new TextEditingController(text: '${_userApp?.email}');
    _controllerPhone = new TextEditingController(text: '${_userApp?.phone}');
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);

    final Responsive responsive = Responsive.of(context);
    final double spaceBetweenFacts = responsive.heightPercent(2.5);
    final double avatarSize = responsive.heightPercent(20);
    ImageProvider<Object> avatarImage =
        const AssetImage('assets/images/profile.png');
    FutureBuilder(
      future: userService.profileImageURL(_userApp?.id ?? ''),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data == '') return Container();
        avatarImage = CachedNetworkImageProvider(snapshot.data!);
        return Container();
      },
    );

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      //-------------------------------body-------------------------------------
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //--------------------Mi perfil y flecha atras------------------
                    CustomAppBar(
                      title:
                          Localization.of(context).string('wall_profile_title'),
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
                          Center(
                            child: CircleEditableAvatar(
                              size: avatarSize,
                              image: avatarImage,
                              iconColor: AppColors.greyscale5,
                              iconBackgroundColor: AppColors.yellowColor,
                            ),
                          ),
                          SizedBox(height: spaceBetweenFacts),

                          //-------------------Datos principales----------------------
                          _WallProfileFact(
                            text: Localization.of(context)
                                .string('wall_profile_name'),
                            textEditingController: _controllerName,
                          ),
                          SizedBox(height: spaceBetweenFacts),
                          _WallProfileFact(
                            text: Localization.of(context)
                                .string('wall_profile_user'),
                            textEditingController: _controllerUser,
                          ),
                          SizedBox(height: spaceBetweenFacts),
                          _WallProfileFact(
                            text: Localization.of(context)
                                .string('wall_profile_age'),
                            textEditingController: _controllerAge,
                          ),
                          SizedBox(height: spaceBetweenFacts),
                          _WallProfileFact(
                            text: Localization.of(context)
                                .string('wall_profile_bio'),
                            textEditingController: _controllerBio,
                          ),
                          SizedBox(height: spaceBetweenFacts + 30),

                          //----------------Información personal----------------------
                          Text(
                            Localization.of(context)
                                .string('wall_profile_personal_info'),
                            style: TextStyle(
                              color: AppColors.greyscale5,
                              fontSize: responsive.widthPercent(5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spaceBetweenFacts),
                          _WallProfileFact(
                            text: Localization.of(context)
                                .string('wall_profile_email'),
                            textEditingController: _controllerEmail,
                          ),
                          SizedBox(height: spaceBetweenFacts),
                          _WallProfileFact(
                            text: Localization.of(context)
                                .string('wall_profile_phone'),
                            textEditingController: _controllerPhone,
                          ),
                          SizedBox(height: spaceBetweenFacts + 30),

                          //-------------------Categoría deportiva--------------------
                          Text(
                            Localization.of(context)
                                .string('wall_profile_sport_category'),
                            // style:
                            //     AppStyles.ligthTextTheme.displaySmall!.copyWith(
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                          SizedBox(height: spaceBetweenFacts),

                          _WallProfileDropdownFactSports(
                            text: Localization.of(context)
                                .string('wall_profile_sport'),
                            dropdownOptions: _sports ?? [],
                            dropdownValue: _sport, //${user.sport}
                            onChanged: (newValue) {
                              // _sport = newValue;
                              // _authViewModel
                              //     .getModalitiesBySport(newValue!.reference);
                              // setState(() {
                              //   // _setModalities(_sport!);
                              // });
                            },
                          ),
                          SizedBox(height: spaceBetweenFacts),
                          _WallProfileDropdownFactModalities(
                            text: Localization.of(context)
                                .string('wall_profile_modality'),
                            dropdownOptions: _modalities ?? [],
                            dropdownValue: _modality, //${user.modality}
                            onChanged: (newValue) {
                              _modality = newValue;
                              setState(() {});
                            },
                          ),

                          SizedBox(height: spaceBetweenFacts + 30),

                          //---------------------Guardar cambios---------------------
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: YellowTextButton(
                                title: Localization.of(context)
                                    .string('wall_profile_save_changes'),
                                onPressed: () async {
                                  // await _saveUserData();
                                  // _authViewModel.registerUser(_userApp!);
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: spaceBetweenFacts),

                          //--------------------Descartar cambios--------------------
                          GestureDetector(
                            onTap: () async {
                              // await initData();
                              // _userViewModel.getUser();
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
          ],
        ),
      ),
      //-------------------------CustomBottomNavigationBar-----------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 4,
      ),
    );
  }

  // Future<bool> _getSportsAndModalities() async {
  //   final firebase = FirebaseFirestore.instance;
  //   try {
  //     await initData();
  //
  //     final sports = await firebase.collection("sports").get();
  //     _sports = sports.docs;
  //
  //     final modalities = await firebase.collection("modalities").where("sport", isEqualTo: _sport!.reference).get();
  //     _modalities = modalities.docs;
  //
  //     return true;
  //   } catch (e) {
  //     throw RemoteErrorMapper.getException(e);
  //   }
  // }
}

class _WallProfileFact extends StatefulWidget {
  final String text;
  final TextEditingController? textEditingController;

  const _WallProfileFact({
    Key? key,
    this.text = '',
    this.textEditingController,
  }) : super(key: key);

  @override
  State<_WallProfileFact> createState() => _WallProfileFactState();
}

class _WallProfileFactState extends State<_WallProfileFact> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            widget.text,
            style: const TextStyle(color: AppColors.mediunLightGrey),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        Expanded(
          child: TextFormField(
            controller: widget.textEditingController,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (String newValue) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}

class _WallProfileDropdownFactSports extends StatelessWidget {
  final String text;
  final List<DocumentSnapshot> dropdownOptions;
  final void Function(DocumentSnapshot?)? onChanged;
  DocumentSnapshot? dropdownValue;

  _WallProfileDropdownFactSports({
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
      // String name =
      //     SportType.fromJson(doc.data() as Map<String, dynamic>).name!;
      String name =
          'SportType.fromJson(doc.data() as Map<String, dynamic>).name!';
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: doc,
          child: Text(toBeginningOfSentenceCase(name)!),
        ),
      );
    }

    final DocumentSnapshot? value = (dropdownValue != null)
        ? dropdownOptions.firstWhere((doc) => doc.id == dropdownValue?.id)
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
