//Switching themes in the flutter apps - Flutterant
//theme_preference.dart
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const prefKey = "pref_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(prefKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(prefKey) ?? false;
  }
}
//Switching themes in the flutter apps - Flutterant