import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/screens/register/register_user_type_screen.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class RegLogTemplate extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isLogin;

  const RegLogTemplate({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isLogin,
  }) : super(key: key);

  @override
  State<RegLogTemplate> createState() => _RegLogTemplateState();
}

class _RegLogTemplateState extends State<RegLogTemplate> {
  UserApp? userApp;
  final _tecEmail = TextEditingController();
  final _tecPassword = TextEditingController();
  bool _passwordHidden = true;
  bool _isValidEmail = false, _isValidPwd = false;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final UserService userService = Provider.of<UserService>(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    final Responsive responsive = Responsive.of(context);

    return Scaffold(
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
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  SizedBox(height: responsive.heightPercent(2)),

                  //---------------------------Titulo----------------------------
                  Text(
                    widget.title,
                    style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                      fontSize: responsive.diagonalPercent(5),
                    ),
                  ),
                  SizedBox(height: responsive.heightPercent(3)),

                  //---------------------------Subtitulo-------------------------
                  Text(
                    widget.subtitle,
                    style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                      fontSize: responsive.diagonalPercent(2.5),
                    ),
                  ),
                  SizedBox(height: responsive.heightPercent(5)),

                  //----------------------Registro/Login---------------------------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-----------------------Email------------------------------
                      Text(
                        Localization.of(context).string('sign_in_username'),
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.1),
                        ),
                      ),
                      SizedBox(height: responsive.heightPercent(2)),
                      TextFormField(
                        controller: _tecEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.1),
                        ),
                      ),
                      SizedBox(height: responsive.heightPercent(2)),
                      TextFormField(
                        controller: _tecPassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _passwordHidden,
                        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
                    ],
                  ),
                  SizedBox(height: responsive.heightPercent(5)),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: YellowTextButton(
                            title: Localization.of(context).string('sign_in'),
                            backgroundDisabled: AppColors.greyscale1,
                            foregroundDisabled: AppColors.greyscale4,
                            onPressed: (_isValidEmail &&
                                    _isValidPwd &&
                                    !authService.isLoading)
                                ? () async {
                                    if (widget.isLogin) {
                                      bool loginOK = await authService.login(
                                          _tecEmail.text, _tecPassword.text);
                                      if (loginOK) {
                                        print('Login correcto');
                                        await userService.getUser();
                                        postsService.getFollowingPosts(
                                            userService.userApp!);

                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.routeName);
                                      } else {
                                        print('Login fallido');
                                      }
                                    } else {
                                      userApp = UserApp(
                                        email: _tecEmail.text,
                                        followers: [],
                                        following: [],
                                        phone: '',
                                        birthday: '',
                                        userName: '',
                                      );
                                      authService.userApp = userApp;
                                      await authService.signUp(
                                          _tecEmail.text, _tecPassword.text);
                                      Navigator.pushNamed(
                                        context,
                                        RegisterUserTypeScreen.routeName,
                                      );
                                    }
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: Platform.isIOS
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.center,
                            children: [
                              // CustomSocialButton(
                              //   assetImage: 'assets/images/google_icon.svg',
                              //   paddingVertical: 10.0,
                              //   onPressed: () => _viewModel.loginWithGoogle(),
                              // ),
                              // Visibility(
                              //   visible: Platform.isIOS,
                              //   child: const CustomSocialButton(
                              //     colorIcon: AppColors.mediunLightGrey,
                              //     paddingVertical: 10.0,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
