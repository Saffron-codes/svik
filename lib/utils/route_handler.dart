import 'package:chatapp/models/friend_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/profile_pages/user_profile_page.dart';


Route onGenerateRoute(RouteSettings settings){
  switch(settings.name){
    case '/user_profile':
      return CupertinoPageRoute(
        settings: settings,
        builder: (context)=>UserProfilePage(profileData:ModalRoute.of(context)!.settings.arguments as Friend),
      );
    default:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context)=>UserProfilePage(profileData:ModalRoute.of(context)!.settings.arguments as Friend),
      );
  }
}