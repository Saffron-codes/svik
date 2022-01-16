import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageServices extends ChangeNotifier {
  UploadTask? task;
  File? file;
  String? percentage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //select a file
  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    file = File(path!);
    notifyListeners();
    print(file!.path);
  }

  change_file(String file_path) {
    file = File(file_path);
    notifyListeners();
  }

  Future<UploadTask?> uploadFile() async {
    if (file == null) return null;
    final fileName = DateTime.now().toString();
    final destination = "Stories/${_auth.currentUser!.displayName.toString()}";
    final ref = FirebaseStorage.instance.ref(destination);
    try {
      task = ref.putFile(file!);
      return task;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  upload_story_data() async {
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    _firestore.collection("stories").doc(_auth.currentUser!.displayName).set({
      "name": _auth.currentUser!.displayName,
      "time": Timestamp.now(),
      "url": urlDownload
    });
  }

  Future<UploadTask?> upload_profile() async {
    if (file == null) return null;
    final fileName = DateTime.now().toString();
    final destination = "Profiles/${_auth.currentUser!.uid.toString()}/$fileName";
    final ref = FirebaseStorage.instance.ref(destination);
    try {
      task = ref.putFile(file!);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      _firestore.collection("users").doc(_auth.currentUser!.uid).update({
        "photourl":urlDownload
      });
      await _auth.currentUser!.updatePhotoURL(urlDownload);
      await _auth.currentUser!.reload();
      return task;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<UploadTask?> upload_post()async{
    if (file == null) return null;
    final destination = "Posts/${_auth.currentUser!.displayName.toString()}";
    final ref = FirebaseStorage.instance.ref(destination);
    try {
      task = ref.putFile(file!);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      _firestore.collection("users").doc(_auth.currentUser!.uid).update({
        "photourl":urlDownload
      });
      await _auth.currentUser!.updatePhotoURL(urlDownload);
      await _auth.currentUser!.reload();
      return task;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  change_name()async{
    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({"name":"Saffron Dionysius T"});

    await _auth.currentUser!.updateDisplayName("Saffron Dionysius T").then((value)=>print("Updated Username"));
    await _auth.currentUser!.reload();
  }
}
