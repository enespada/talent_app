// import 'dart:collection';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:flutter_mvvm/view/common/localization/localization.dart';
// import 'package:flutter_mvvm/view/common/resources/app_colors.dart';
// import 'package:flutter_mvvm/view/common/resources/app_dimens.dart';
// import 'package:flutter_mvvm/view/common/resources/app_styles.dart';
// import 'package:flutter_mvvm/view/common/resources/responsive.dart';
// import 'package:flutter_mvvm/view/di/app_modules.dart';
// import 'package:flutter_mvvm/view/viewmodel/user_view_model.dart';
// import 'package:flutter_mvvm/view/widget/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_mvvm/model/sport.dart';
// import 'package:flutter_mvvm/model/user.dart';
// import 'package:flutter_mvvm/view/base/resource_state.dart';
// import 'package:flutter_mvvm/view/viewmodel/viewmodels.dart';
// import 'package:flutter_mvvm/view/widget/error/error_overlay.dart';
// import 'package:flutter_mvvm/view/widget/loading/loading_overlay.dart';
////WallProfilePage
// class WallProfilePage extends StatefulWidget {
//   // static const List<String> _examples = [
//   //   'Ejemplo1',
//   //   'Ejemplo2',
//   //   'Ejemplo3',
//   // ];

//   const WallProfilePage({Key? key, this.user}) : super(key: key);
//   final UserApp? user;

//   @override
//   State<WallProfilePage> createState() => _WallProfilePageState();
// }

// class _WallProfilePageState extends State<WallProfilePage> {
//   final _userViewModel = inject<UserViewModel>();
//   final _authViewModel = inject<AuthViewModel>();
//   List<DocumentReference>? _listSport;
//   List<DocumentSnapshot>? _sports;
//   List<DocumentSnapshot>? _modalities;

//   TextEditingController? _controllerName;
//   TextEditingController? _controllerUser;
//   TextEditingController? _controllerAge;
//   TextEditingController? _controllerBio;
//   TextEditingController? _controllerEmail;
//   TextEditingController? _controllerPhone;
//   DocumentSnapshot? _sport; //user.sport
//   DocumentSnapshot? _modality; //user.modality
//   // String _example = WallProfilePage._examples[0];
//   UserApp? _user;

//   @override
//   void initState() {
//     super.initState();

//     _userViewModel.getUserState.stream.listen((state) {
//       switch (state.status) {
//         case Status.LOADING:
//           LoadingOverlay.of(context).show();
//           break;
//         case Status.COMPLETED:
//           LoadingOverlay.of(context).hide();
//           setState(() {
//             _user = state.data;
//           });
//           break;
//         case Status.ERROR:
//           LoadingOverlay.of(context).hide();
//           ErrorOverlay.of(context).show(state.error);
//           break;
//         default:
//           LoadingOverlay.of(context).hide();
//           break;
//       }
//     });

//     //-------------------------------getSports---------------------------------
//     _authViewModel.getModalitiesState.stream.listen((state) {
//       switch (state.status) {
//         case Status.LOADING:
//           LoadingOverlay.of(context).show();
//           break;
//         case Status.COMPLETED:
//           LoadingOverlay.of(context).hide();
//           _modalities = state.data;
//           setState(() {});
//           break;
//         case Status.ERROR:
//           LoadingOverlay.of(context).hide();
//           ErrorOverlay.of(context).show(state.error);
//           break;
//         default:
//           LoadingOverlay.of(context).hide();
//           break;
//       }
//     });

//     _authViewModel.getSportsState.stream.listen((state) async {
//       switch (state.status) {
//         case Status.LOADING:
//           LoadingOverlay.of(context).show();
//           break;
//         case Status.COMPLETED:
//           LoadingOverlay.of(context).hide();
//           _sports = state.data;
//           await initData();
//           setState(() {});
//           _authViewModel.getModalitiesBySport(_sport!.reference);
//           // for (var sport in _listSport!) {
//           //   _sports?.add(sport);
//           //
//           //   _authViewModel.getModalities();
//           //   // if (sport.name == _sport) {
//           //   //   _modalities = sport.modalities;
//           //   // }
//           // }
//           // setState(() {});
//           break;
//         case Status.ERROR:
//           LoadingOverlay.of(context).hide();
//           ErrorOverlay.of(context).show(state.error);
//           break;
//         default:
//           LoadingOverlay.of(context).hide();
//           break;
//       }
//     });
//     _authViewModel.getSports();

//     //-------------------------------UpdateUser---------------------------------
//     _authViewModel.registerUserState.stream.listen((state) {
//       switch (state.status) {
//         case Status.LOADING:
//           LoadingOverlay.of(context).show();
//           break;
//         case Status.COMPLETED:
//           LoadingOverlay.of(context).hide();
//           _userViewModel.getUser();
//           break;
//         case Status.ERROR:
//           LoadingOverlay.of(context).hide();
//           ErrorOverlay.of(context).show(state.error);
//           break;
//         default:
//           LoadingOverlay.of(context).hide();
//           break;
//       }
//     });
//   }

//   Future<void> _saveUserData() async {
//     _user?.fullname = _controllerName?.text;
//     _user?.userName = _controllerUser?.text;
//     _user?.birthday = _controllerAge?.text;
//     _user?.bio = _controllerBio?.text;
//     _user?.email = _controllerEmail?.text;
//     _user?.phone = _controllerPhone?.text;
//     _user?.sportType = _sport?.reference;
//     _user?.modality = _modality?.reference;
//   }

//   Future<void> initData() async {
//     _user = widget.user;
//     _sport = await _user!.sportType!.get();
//     _modality = await _user!.modality!.get();

//     _controllerName = new TextEditingController(text: '${_user?.fullname}');

//     _controllerUser = new TextEditingController(text: '${_user?.userName}');

//     _controllerAge = new TextEditingController(text: '${_user?.birthday}');

//     _controllerBio = new TextEditingController(text: '${_user?.bio}');

//     _controllerEmail = new TextEditingController(text: '${_user?.email}');

//     _controllerPhone = new TextEditingController(text: '${_user?.phone}');
//   }

//   @override
//   void dispose() {
//     _userViewModel.dispose();
//     _authViewModel.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);
//     final double spaceBetweenFacts = responsive.heightPercent(2.5);

//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       //-------------------------------body-------------------------------------
//       body: SafeArea(
//         child: Stack(
//           children: [
//             GestureDetector(
//               onTap: FocusScope.of(context).unfocus,
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     //--------------------Mi perfil y flecha atras------------------
//                     CustomAppBar(
//                       title:
//                           Localization.of(context).string('wall_profile_title'),
//                       responsive: Responsive.of(context),
//                       style: TextStyle(
//                         fontSize: responsive.widthPercent(7),
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.blackColor,
//                       ),
//                       iconColor: AppColors.brandColor,
//                     ),

//                     //-----------------------Info mi perfil-------------------------
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 25),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //-------------------------Foto-----------------------------
//                           Center(
//                               child: Avatar(
//                             size: 200,
//                             user: _user,
//                           )),
//                           SizedBox(height: spaceBetweenFacts),

//                           //-------------------Datos principales----------------------
//                           _WallProfileFact(
//                             text: Localization.of(context)
//                                 .string('wall_profile_name'),
//                             textEditingController: _controllerName,
//                           ),
//                           SizedBox(height: spaceBetweenFacts),
//                           _WallProfileFact(
//                             text: Localization.of(context)
//                                 .string('wall_profile_user'),
//                             textEditingController: _controllerUser,
//                           ),
//                           SizedBox(height: spaceBetweenFacts),
//                           _WallProfileFact(
//                             text: Localization.of(context)
//                                 .string('wall_profile_age'),
//                             textEditingController: _controllerAge,
//                           ),
//                           SizedBox(height: spaceBetweenFacts),
//                           _WallProfileFact(
//                             text: Localization.of(context)
//                                 .string('wall_profile_bio'),
//                             textEditingController: _controllerBio,
//                           ),
//                           SizedBox(height: spaceBetweenFacts + 30),

//                           //----------------Información personal----------------------
//                           Text(
//                             Localization.of(context)
//                                 .string('wall_profile_personal_info'),
//                             style:
//                                 AppStyles.ligthTextTheme.displaySmall!.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: spaceBetweenFacts),
//                           _WallProfileFact(
//                             text: Localization.of(context)
//                                 .string('wall_profile_email'),
//                             textEditingController: _controllerEmail,
//                           ),
//                           SizedBox(height: spaceBetweenFacts),
//                           _WallProfileFact(
//                             text: Localization.of(context)
//                                 .string('wall_profile_phone'),
//                             textEditingController: _controllerPhone,
//                           ),
//                           SizedBox(height: spaceBetweenFacts + 30),

//                           //-------------------Categoría deportiva--------------------
//                           Text(
//                             Localization.of(context)
//                                 .string('wall_profile_sport_category'),
//                             style:
//                                 AppStyles.ligthTextTheme.displaySmall!.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: spaceBetweenFacts),

//                           _WallProfileDropdownFactSports(
//                             text: Localization.of(context)
//                                 .string('wall_profile_sport'),
//                             dropdownOptions: _sports ?? [],
//                             dropdownValue: _sport, //${user.sport}
//                             onChanged: (newValue) {
//                               _sport = newValue;
//                               _authViewModel.getModalitiesBySport(newValue!.reference);
//                               // setState(() {
//                               //   // _setModalities(_sport!);
//                               // });
//                             },
//                           ),
//                           SizedBox(height: spaceBetweenFacts),
//                           _WallProfileDropdownFactModalities(
//                             text: Localization.of(context)
//                                 .string('wall_profile_modality'),
//                             dropdownOptions: _modalities ?? [],
//                             dropdownValue: _modality, //${user.modality}
//                             onChanged: (newValue) {
//                               _modality = newValue;
//                               setState(() {});
//                             },
//                           ),

//                           SizedBox(height: spaceBetweenFacts + 30),

//                           //---------------------Guardar cambios---------------------
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               child: TalentPrimaryButton(
//                                 title: Localization.of(context)
//                                     .string('wall_profile_save_changes'),
//                                 onPressed: () async {
//                                   await _saveUserData();
//                                   _authViewModel.registerUser(_user!);
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: spaceBetweenFacts),

//                           //--------------------Descartar cambios--------------------
//                           GestureDetector(
//                             onTap: () async {
//                               await initData();
//                               _userViewModel.getUser();
//                             },
//                             child: SizedBox(
//                               width: responsive.width,
//                               child: Text(
//                                 Localization.of(context)
//                                     .string('wall_profile_discard'),
//                                 style: GoogleFonts.urbanist(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 18,
//                                   color: AppColors.blackColor,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: spaceBetweenFacts + 90),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Align(
//               alignment: Alignment.bottomCenter,
//               child: WhiteBottomNavigationBar(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Future<bool> _getSportsAndModalities() async {
//   //   final firebase = FirebaseFirestore.instance;
//   //   try {
//   //     await initData();
//   //
//   //     final sports = await firebase.collection("sports").get();
//   //     _sports = sports.docs;
//   //
//   //     final modalities = await firebase.collection("modalities").where("sport", isEqualTo: _sport!.reference).get();
//   //     _modalities = modalities.docs;
//   //
//   //     return true;
//   //   } catch (e) {
//   //     throw RemoteErrorMapper.getException(e);
//   //   }
//   // }
// }

// class _WallProfileFact extends StatefulWidget {
//   final String text;
//   final TextEditingController? textEditingController;

//   const _WallProfileFact({
//     Key? key,
//     this.text = '',
//     this.textEditingController,
//   }) : super(key: key);

//   @override
//   State<_WallProfileFact> createState() => _WallProfileFactState();
// }

// class _WallProfileFactState extends State<_WallProfileFact> {
//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);

//     return Row(
//       children: [
//         SizedBox(
//           width: responsive.widthPercent(20),
//           child: Text(
//             widget.text,
//             style: const TextStyle(color: AppColors.mediunLightGrey),
//           ),
//         ),
//         SizedBox(width: responsive.widthPercent(8)),
//         Expanded(
//           child: TextFormField(
//             controller: widget.textEditingController,
//             style: const TextStyle(
//               fontSize: AppDimens.textMidMedium,
//               fontWeight: FontWeight.bold,
//               color: AppColors.darkGrey,
//             ),
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//             ),
//             onChanged: (String newValue) {
//               setState(() {});
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _WallProfileDropdownFactSports extends StatelessWidget {
//   final String text;
//   final List<DocumentSnapshot> dropdownOptions;
//   final void Function(DocumentSnapshot?)? onChanged;
//   DocumentSnapshot? dropdownValue;

//   _WallProfileDropdownFactSports({
//     Key? key,
//     required this.text,
//     required this.onChanged,
//     required this.dropdownValue,
//     required this.dropdownOptions,
//   }) : super(key: key);

//   List<DropdownMenuItem<DocumentSnapshot>> dropdownMenuItems = [];

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);
//     for (var doc in dropdownOptions) {
//       String name = SportType.fromJson(doc.data() as Map<String, dynamic>).name!;
//       dropdownMenuItems.add(
//         DropdownMenuItem(
//           value: doc,
//           child: Text(toBeginningOfSentenceCase(name)!),
//         ),
//       );
//     }

//     final DocumentSnapshot? value = (dropdownValue != null) ? dropdownOptions.firstWhere((doc) => doc.id == dropdownValue?.id) : null;

//     return Row(
//       children: [
//         SizedBox(
//           width: responsive.widthPercent(20),
//           child: Text(
//             text,
//             style: const TextStyle(color: AppColors.mediunLightGrey),
//           ),
//         ),
//         SizedBox(width: responsive.widthPercent(8)),
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<DocumentSnapshot>(
//               dropdownColor: AppColors.whiteColor,
//               focusColor: AppColors.darkGrey.withOpacity(0.03),
//               borderRadius: BorderRadius.circular(15),
//               value: value,
//               icon: const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: AppColors.coinGrey,
//               ),
//               items: dropdownMenuItems,
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _WallProfileDropdownFactModalities extends StatelessWidget {
//   final String text;
//   final List<DocumentSnapshot> dropdownOptions;
//   final void Function(DocumentSnapshot?)? onChanged;
//   DocumentSnapshot? dropdownValue;

//   _WallProfileDropdownFactModalities({
//     Key? key,
//     required this.text,
//     required this.onChanged,
//     required this.dropdownValue,
//     required this.dropdownOptions,
//   }) : super(key: key);

//   List<DropdownMenuItem<DocumentSnapshot>> dropdownMenuItems = [];

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);
//     for (var doc in dropdownOptions) {
//       String name = Modality.fromJson(doc.data() as Map<String, dynamic>).name!;
//       dropdownMenuItems.add(
//         DropdownMenuItem(
//           value: doc,
//           child: Text(toBeginningOfSentenceCase(name)!),
//         ),
//       );
//     }

//     DocumentSnapshot? value;
//     if (dropdownValue != null && dropdownOptions.any((doc) => doc.id == dropdownValue!.id)) {
//       value = dropdownOptions.firstWhere((doc) => doc.id == dropdownValue?.id);
//     } else if (dropdownOptions.isNotEmpty) {
//       value = dropdownOptions[0];
//     }

//     return Row(
//       children: [
//         SizedBox(
//           width: responsive.widthPercent(20),
//           child: Text(
//             text,
//             style: const TextStyle(color: AppColors.mediunLightGrey),
//           ),
//         ),
//         SizedBox(width: responsive.widthPercent(8)),
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<DocumentSnapshot>(
//               dropdownColor: AppColors.whiteColor,
//               focusColor: AppColors.darkGrey.withOpacity(0.03),
//               borderRadius: BorderRadius.circular(15),
//               value: value,
//               icon: const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: AppColors.coinGrey,
//               ),
//               items: dropdownMenuItems,
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
