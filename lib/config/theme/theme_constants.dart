import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AppBarTheme appbartheme = AppBarTheme(
//     systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.grey));
class ThemeConstants {
  final Color themeBlueColor = Color(0xff209EF1);
  final Color themeWhiteColor = Color(0xffD8D8D8);
  final Color chatPageBg = Color(0xff242232);
  final Color darkthemeBg = Color(0xff13141A);
  final Color darkBg = Color(0xff202225);
  BottomNavigationBarThemeData bottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: Color(0xffFBFBFC),
          backgroundColor: Color(0xff202225));
  BottomNavigationBarThemeData bottomNavThemeLight =
      BottomNavigationBarThemeData(
    backgroundColor: Color(0xfff6f6f6),
    elevation: 0,
    unselectedItemColor: Colors.black54,
    selectedItemColor: Colors.black87,
  );

  BottomSheetThemeData bottomSheetThemeData = BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 33, 34, 37), elevation: 0);

  AppBarTheme appBarTheme = AppBarTheme(
    elevation: 0.0,
    backgroundColor: Color(0xff202225),
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Color(0xff202225)),
    actionsIconTheme: IconThemeData(color: Color(0xffD8D8D8)),
  );

  AppBarTheme appBarThemeLight = AppBarTheme(
    elevation: 0.0,
    //backgroundColor: Colors.white38,
    systemOverlayStyle:
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.white38),
    actionsIconTheme: IconThemeData(color: Color(0xffD8D8D8)),
  );

  TextStyle chatTextName = TextStyle(color: Color(0xffD8D8D8));

  TextStyle chatTitle = TextStyle(color: Color(0xffD8D8D8), fontSize: 25);

  final systemThemeLight = SystemUiOverlayStyle.light
      .copyWith(systemNavigationBarColor: Color(0xfff6f6f6));

  final systemThemeDark = SystemUiOverlayStyle.light
      .copyWith(systemNavigationBarColor: Color(0xff202225));
}
