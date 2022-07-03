import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pallete.dart';
import 'theme_constants.dart';

class Themes {
  ThemeData darkTheme = ThemeData(
    primarySwatch: Palette.kToDark,
    bottomNavigationBarTheme: ThemeConstants().bottomNavigationBarThemeData,
    bottomSheetTheme: ThemeConstants().bottomSheetThemeData,
    scaffoldBackgroundColor: Color(0xff202225),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: ThemeConstants().themeBlueColor)),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Palette.kToDark.shade900,
        statusBarIconBrightness: Brightness.light,
        // systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
  );
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
