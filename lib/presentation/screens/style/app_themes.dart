import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:talent_app/presentation/screens/style/styles.dart';

class AppThemes {
  static const Color primary = AppColors.blueColor;

  static ThemeData lightTheme = ThemeData(
    textTheme: lightTextTheme,
    brightness: Brightness.light,
    primaryColor: primary,
    useMaterial3: true,

    //appBarTheme
    appBarTheme: const AppBarTheme(
      color: AppColors.lightBackground,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData darkTheme = ThemeData(
    textTheme: darkTextTheme,
    brightness: Brightness.dark,
    useMaterial3: true,

    //appBarTheme
    appBarTheme: const AppBarTheme(
      color: AppColors.darkBackground,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.urbanist(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.blackColor,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.urbanist(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
    ),
  );
}
