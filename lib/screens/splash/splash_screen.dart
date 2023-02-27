import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/register/register_user_type_screen.dart';

import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.blueColor),
          );
        },
      ),
    );
  }

  Future<void> checkLoginState(BuildContext context) async {
    final AuthService authService = Provider.of<AuthService>(context);
    final UserService userService =
        Provider.of<UserService>(context, listen: false);
    final PostsService postsService =
        Provider.of<PostsService>(context, listen: false);

    final authenticated = await authService.isAuthenticated();

    if (authenticated) {
      await userService.getUser();
      if (userService.userApp!.type == null) {
        authService.userApp = userService.userApp;
        Navigator.pushReplacementNamed(
            context, RegisterUserTypeScreen.routeName);
        return;
      } else {
        postsService.getFollowingPosts(userService.userApp!);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        return;
      }
    } else {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
      return;
    }
  }
}
