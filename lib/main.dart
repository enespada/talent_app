import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/firebase_options.dart';
import 'package:talent_app/presentation/providers/providers.dart';
import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/style/styles.dart';
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
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => UserService()),
        ChangeNotifierProvider(create: (context) => SportsService()),
        ChangeNotifierProvider(create: (context) => ModalitiesService()),
        ChangeNotifierProvider(create: (context) => ChatsService()),
        ChangeNotifierProvider(create: (context) => PostsService()),
        ChangeNotifierProvider(create: (context) => EditProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Talent App',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: SplashScreen.routeName,
        routes: {
          //chats
          ChatsScreen.routeName: (context) => const ChatsScreen(),
          //explorer
          ExplorerScreen.routeName: (context) => ExplorerScreen(),
          //home
          HomeScreen.routeName: (context) => const HomeScreen(),
          //login
          LoginScreen.routeName: (context) => const LoginScreen(),
          //onboarding
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          //profile
          // ProfileScreen.routeName: (context) => const ProfileScreen(),
          // EditProfileScreen.routeName: (context) => const EditProfileScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          //register
          // RegisterScreen.routeName: (context) => const RegisterScreen(),
          RegisterUserTypeScreen.routeName: (context) =>
              const RegisterUserTypeScreen(),
          //splash
          SplashScreen.routeName: (context) => const SplashScreen(),
          //upload
          UploadPostHomeScreen.routeName: (context) =>
              const UploadPostHomeScreen(),
        },
      ),
    );
  }
}
