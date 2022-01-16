import 'package:chatapp/firebase_services/firebaseauth_services.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/routes/mainpage.dart';
import 'package:chatapp/routes/user_validation/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<User?>();
    return currentUser !=null?BottomNavBar():LoginPage();
  }
}