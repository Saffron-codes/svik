import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pallete.dart';
import 'theme_constants.dart';

class Themes {
  ThemeData darkTheme = ThemeData(
      primarySwatch: Palette.kToDark,
      bottomNavigationBarTheme: ThemeConstants().bottomNavigationBarThemeData,
      bottomSheetTheme: ThemeConstants().bottomSheetThemeData,
      scaffoldBackgroundColor: Color(0xFF202225),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        // labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        indicator: UnderlineTabIndicator(
          borderSide:
              BorderSide(width: 3, color: ThemeConstants().themeBlueColor),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 20),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Color(0xFF202225),
          statusBarIconBrightness: Brightness.light,
          // systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      dialogTheme: DialogTheme(
          backgroundColor: Color(0xFF202225),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  ThemeData lightTheme = ThemeData(
    primarySwatch: Palette.kToLight,
    tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black45))),
    bottomNavigationBarTheme: ThemeConstants().bottomNavThemeLight,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Palette.kToLight.shade900,
        systemNavigationBarColor: Palette.kToLight.shade900,
        statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    visualDensity: VisualDensity.comfortable,
  );
}
