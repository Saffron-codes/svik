import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chatapp/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  kIsWeb?
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDyLQBWL57RK0KkxJib8VSviSWzA1OFXbc",
      authDomain: "chatbro-818b8.firebaseapp.com",
      projectId: "chatbro-818b8",
      storageBucket: "chatbro-818b8.appspot.com",
      messagingSenderId: "1070598894785",
      appId: "1:1070598894785:web:56eed9e86e351b1a6a5040",
      measurementId: "G-JNJEN37FD4",
    ),
  ):
    await Firebase.initializeApp(
    // options: FirebaseOptions(
    //   apiKey: "AIzaSyDyLQBWL57RK0KkxJib8VSviSWzA1OFXbc",
    //   authDomain: "chatbro-818b8.firebaseapp.com",
    //   projectId: "chatbro-818b8",
    //   storageBucket: "chatbro-818b8.appspot.com",
    //   messagingSenderId: "1070598894785",
    //   appId: "1:1070598894785:web:56eed9e86e351b1a6a5040",
    //   measurementId: "G-JNJEN37FD4",
    // ),
  );
  cameras = await availableCameras();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(App());
}
