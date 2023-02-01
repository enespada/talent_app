import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/home/home_screen.dart';
import 'package:talent_app/screens/onboarding/onboarding_screen.dart';
import 'package:talent_app/services/auth_service.dart';
import 'package:talent_app/services/user_service.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  method() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final AuthService authService = Provider.of<AuthService>(context);
    final UserService userService = Provider.of<UserService>(context);

    final authenticated = await authService.isAuthenticated();

    if (authenticated) {
      await userService.getUser();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    }
  }
}
