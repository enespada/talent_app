// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/presentation/providers/providers.dart';
import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

class RegLogTemplate extends StatefulWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String? userType;

  const RegLogTemplate({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.userType,
  }) : super(key: key);

  @override
  State<RegLogTemplate> createState() => _RegLogTemplateState();
}

class _RegLogTemplateState extends State<RegLogTemplate> {
  UserApp? userApp;
  final _tecEmail = TextEditingController();
  final _tecPassword = TextEditingController();
  bool _passwordHidden = true;
  bool _isValidEmail = false;
  bool _isValidPwd = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(
      context,
      listen: true,
    );
    final UserService userService = Provider.of<UserService>(
      context,
      listen: false,
    );
    final PostsService postsService = Provider.of<PostsService>(
      context,
      listen: false,
    );
    final ChatsService chatsService = Provider.of<ChatsService>(
      context,
      listen: false,
    );
    final SportsService sportsService = Provider.of<SportsService>(
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

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: responsive.height,
            width: responsive.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/background_lineas.png').image,
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------Boton atras----------------------------
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  SizedBox(height: responsive.heightPercent(2)),

                  //---------------------------Titulo----------------------------
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(5),
                        ),
                  ),
                  SizedBox(height: responsive.heightPercent(3)),

                  //-----------------------Subtitulo-----------------------------
                  Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.3),
                        ),
                  ),
                  SizedBox(height: responsive.heightPercent(5)),

                  //-----------------------Email------------------------------
                  Text(
                    Localization.of(context).string('sign_in_username'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.1),
                        ),
                  ),
                  SizedBox(height: responsive.heightPercent(2)),
                  TextFormField(
                    controller: _tecEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.1),
                        ),
                    onChanged: (String value) {
                      _isValidEmail = value.contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 14,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hintText: Localization.of(context)
                          .string('sign_in_username_hint'),
                      suffixIcon: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          _tecEmail.clear();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.blackColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.heightPercent(3)),

                  //-----------------------Password------------------------------
                  Text(
                    Localization.of(context).string('sign_in_password'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.1),
                        ),
                  ),
                  SizedBox(height: responsive.heightPercent(2)),
                  TextFormField(
                    controller: _tecPassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordHidden,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.1),
                        ),
                    onChanged: (String value) {
                      _isValidPwd = value.length >= 6;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 25.0,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hintText: Localization.of(context)
                          .string('sign_in_password_hint'),
                      suffixIcon: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          _passwordHidden = !_passwordHidden;
                          setState(() {});
                        },
                        child: Icon(
                          _passwordHidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.blackColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.heightPercent(5)),

                  //-------------------------Boton-------------------------------
                  YellowTextButton(
                    title: widget.buttonText,
                    backgroundDisabled: AppColors.greyscale1,
                    foregroundDisabled: AppColors.greyscale4,
                    onPressed: (_isValidEmail && _isValidPwd && !isLoading)
                        ? () async {
                            if (isLoading) return;
                            isLoading = true;
                            setState(() {});

                            //----------------------Login------------------------
                            if (widget.userType == null) {
                              String? loginResult = await authService.login(
                                _tecEmail.text,
                                _tecPassword.text,
                              );
                              if (loginResult == null) {
                                await userService.getUser();
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                chatsService.getUserChats(
                                  userService.userApp!,
                                );
                                postsService.getFollowingPosts(
                                  userService.userApp!,
                                );
                                //Si el usuario no completo sus datos en el registro
                                //le obligamos a completarlos
                                if (userService.userApp!.userName!.isEmpty) {
                                  editProfileProvider.initializeData(
                                    userService.userApp!,
                                  );
                                  Navigator.popUntil(
                                    context,
                                    (route) {
                                      return route ==
                                          ModalRoute.withName(
                                              LoginScreen.routeName);
                                    },
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                        isProfileCompleted: false,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.popUntil(
                                    context,
                                    (route) {
                                      return route ==
                                          ModalRoute.withName(
                                              LoginScreen.routeName);
                                    },
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    HomeScreen.routeName,
                                  );
                                }
                              } else {
                                Util.showCustomDialog(
                                  context: context,
                                  child: Text(
                                    loginResult,
                                    style: AppThemes.darkTextTheme.bodyLarge!
                                        .copyWith(
                                      fontSize: responsive.diagonalPercent(2.2),
                                    ),
                                  ),
                                );
                              }
                            }
                            //---------------------Register----------------------
                            else {
                              String? signUpResult = await authService.signUp(
                                _tecEmail.text,
                                _tecPassword.text,
                                widget.userType!,
                              );
                              //Si el sign up es correcto
                              if (signUpResult == null) {
                                await userService.getUser();
                                //Si el usuario aun no ha completado sus datos
                                //le obligamos a hacerlo
                                if (userService.userApp!.userName!.isEmpty) {
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
                                  editProfileProvider.initializeData(
                                    userService.userApp!,
                                  );
                                  Navigator.popUntil(
                                    context,
                                    (route) {
                                      return route ==
                                          ModalRoute.withName(
                                              RegisterScreen.routeName);
                                    },
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                        isProfileCompleted: false,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.popUntil(
                                    context,
                                    (route) {
                                      return route ==
                                          ModalRoute.withName(
                                              RegisterScreen.routeName);
                                    },
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    HomeScreen.routeName,
                                  );
                                }
                              }
                              //Si el sign up NO es correcto
                              else {
                                Util.showCustomDialog(
                                  context: context,
                                  child: Text(
                                    signUpResult,
                                    style: AppThemes.darkTextTheme.bodyLarge!
                                        .copyWith(
                                      fontSize: responsive.diagonalPercent(2.2),
                                    ),
                                  ),
                                );
                              }
                            }
                            isLoading = false;
                            setState(() {});
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
