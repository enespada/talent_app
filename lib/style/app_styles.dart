import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talent_app/style/app_colors.dart';

class AppStyles {
  // App Theme
  static ThemeData lightTheme = ThemeData(
    textTheme: ligthTextTheme,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    useMaterial3: true,
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
    primarySwatch: Colors.blue,
    useMaterial3: true,
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static TextTheme ligthTextTheme = TextTheme(
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
