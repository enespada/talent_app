import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/presentation/providers/providers.dart';
import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/screens/style/styles.dart';

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

    final authenticated = await authService.isAuthenticated();

    if (authenticated) {
      await userService.getUser();
      if (userService.userApp!.userName!.isEmpty) {
        // authService.userApp = userService.userApp;
        await sportsService.getSports();
        for (Sport s in sportsService.sports) {
          if (s.id == userService.userApp!.sport) {
            await modalitiesService.getModalitiesBySport(s);
            editProfileProvider.sport = s;
            break;
          }
        }
        for (Modality m in modalitiesService.modalities) {
          if (m.id == userService.userApp!.modality) {
            editProfileProvider.modality = m;
            break;
          }
        }
        editProfileProvider.initializeData(userService.userApp!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(isProfileCompleted: false),
          ),
        );
        return;
      } else {
        chatsService.getUserChats(userService.userApp!);
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
