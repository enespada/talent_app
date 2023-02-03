import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/firebase_options.dart';
import 'package:talent_app/providers/edit_profile_provider.dart';
import 'package:talent_app/screens/login/login_screen.dart';
import 'package:talent_app/screens/onboarding/onboarding_screen.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/screens/splash/splash_screen.dart';
import 'package:talent_app/services/auth_service.dart';
import 'package:talent_app/services/search_service.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/services/sports_service.dart';
import 'package:talent_app/services/user_service.dart';
import 'package:talent_app/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SportsService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ModalitiesService(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Talent App',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          Localization.delegate,
          // GlobalMaterialLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
          // GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: SplashScreen.routeName,
        routes: {
          //explorer
          ExplorerScreen.routeName: (context) => ExplorerScreen(),
          //home
          HomeScreen.routeName: (context) => const HomeScreen(),
          //login
          LoginScreen.routeName: (context) => const LoginScreen(),
          //onboarding
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          //profile
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          //splash
          SplashScreen.routeName: (context) => const SplashScreen(),
        },
      ),
    );
  }
}
