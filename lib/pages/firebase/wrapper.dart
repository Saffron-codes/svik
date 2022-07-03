import 'package:chatapp/pages/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/loginpage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<User?>();
    return currentUser !=null?BottomNavBar():LoginPage();
  }
}