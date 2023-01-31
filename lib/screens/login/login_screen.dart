import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/auth_service.dart';
import 'package:talent_app/services/user_service.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserApp? user;

  bool _passwordHidden = true;
  bool _isValidEmail = false, _isValidPwd = false;

  final _tecEmail = TextEditingController();
  final _tecPassword = TextEditingController();
  User? userFirebase;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final UserService userService = Provider.of<UserService>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: double.infinity,
            width: double.infinity,
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
                  // CustomBackButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      Localization.of(context).string('sign_in'),
                      // style: AppStyles.ligthTextTheme.displayLarge,
                    ),
                  ),
                  Text(
                    Localization.of(context).string('login_welcome'),
                    // style: AppStyles.ligthTextTheme.bodyLarge,
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          Localization.of(context).string('sign_in_username'),
                          // style: AppStyles.ligthTextTheme.bodyMedium,
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: _tecEmail,
                        keyboardType: TextInputType.emailAddress,
                        // style: AppStyles.ligthTextTheme.labelSmall,
                        onChanged: (value) {
                          setState(() {
                            _isValidEmail = value.contains(RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 25.0),
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          Localization.of(context).string('sign_in_password'),
                        ),
                      ),
                      TextFormField(
                        controller: _tecPassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _passwordHidden,
                        // style: AppStyles.ligthTextTheme.labelSmall,
                        onChanged: (value) {
                          setState(() {
                            _isValidPwd = value.length >= 6;
                          });
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
                  const SizedBox(height: 25),
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
                            onPressed: (_isValidEmail && _isValidPwd)
                                ? () async {
                                    // _viewModel.login(
                                    //     _tecEmail.text, _tecPassword.text);
                                    bool loginOK = await authService.login(
                                        _tecEmail.text, _tecPassword.text);
                                    if (loginOK) {
                                      print('Login correcto');
                                      await userService.getUser();
                                      print(userService.userApp?.bio);
                                    } else {
                                      print('Login fallido');
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
