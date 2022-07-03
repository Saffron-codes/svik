

import 'package:camera/camera.dart';
import 'package:chatapp/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(App());
}


