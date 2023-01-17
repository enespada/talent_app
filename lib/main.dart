import 'package:flutter/material.dart';
import 'package:talent_app/screens/explorer/explorer_home_screen.dart';
import 'package:talent_app/screens/home/home_screen.dart';
import 'package:talent_app/screens/profile/profile_screen.dart';
import 'package:talent_app/utils/localization.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        HomeScreen.routeName: (context) => const HomeScreen(),
        ExplorerHomeScreen.routeName: (context) => ExplorerHomeScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
    );
  }
}
