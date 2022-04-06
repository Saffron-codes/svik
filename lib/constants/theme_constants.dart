import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AppBarTheme appbartheme = AppBarTheme(
//     systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.grey));
final Color themeBlueColor = Color(0xff209EF1);
final Color themeWhiteColor = Color(0xffD8D8D8);
final Color chatPageBg = Color(0xff242232);
final Color darkthemeBg = Color(0xff13141A);
BottomNavigationBarThemeData bottomNavigationBarThemeData = BottomNavigationBarThemeData(
  unselectedItemColor: Color(0xffD8D8D8),
    selectedItemColor: Color(0xff209EF1),
    backgroundColor: Color(0xff141d26)
  );

BottomSheetThemeData bottomSheetThemeData = BottomSheetThemeData(
  backgroundColor: Color(0xff13141A),
);

AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0.0,
  backgroundColor: Color(0xff141E29),
  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Color(0xff141E29)),
  actionsIconTheme: IconThemeData(
    color: Color(0xffD8D8D8)
  ),
);


TextStyle chatTextName = TextStyle(
  color: Color(0xffD8D8D8)
);


TextStyle chatTitle = TextStyle(
  color: Color(0xffD8D8D8),
  fontSize: 25
);