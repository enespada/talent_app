import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/profile/settings_screen.dart';

import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/auth_service.dart';
import 'package:talent_app/utils/utils.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
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
        initialRoute: HomeScreen.routeName,
        routes: {
          //explorer
          ExplorerHomeScreen.routeName: (context) => ExplorerHomeScreen(),
          //home
          HomeScreen.routeName: (context) => const HomeScreen(),
          //profile
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
