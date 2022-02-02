import 'dart:io';

import 'package:chatapp/constants/theme_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageServices extends ChangeNotifier {
  UploadTask? task;
  UploadTask? uploadProfileTask;
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
    _firestore.collection("stories").doc(_auth.currentUser!.uid).set({
      "name": _auth.currentUser!.displayName,
      "time": Timestamp.now(),
      "url": urlDownload,
      "uid": _auth.currentUser!.uid
    });
  }

  Future uploadProfile() async {
    if (file == null) return null;
    final destination = "Profiles/${_auth.currentUser!.uid}";
    final ref = FirebaseStorage.instance.ref(destination);
    print("The Task is null $uploadProfileTask");
    try {
      uploadProfileTask = ref.putFile(file!);
      notifyListeners();
      print("The Task is active $uploadProfileTask");
      final snapshot = await uploadProfileTask!.whenComplete(() {
        uploadProfileTask = null;
        print("Making Task Null");
      });
      final urlDownload = await snapshot.ref.getDownloadURL();
      _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"photourl": urlDownload});
      await _auth.currentUser!.updatePhotoURL(urlDownload);
      await _auth.currentUser!.reload();
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Widget uploadProgress() {
    return uploadProfileTask != null
        ? StreamBuilder<TaskSnapshot>(
            stream: uploadProfileTask!.snapshotEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final snap = snapshot.data;
                final progress = snap!.bytesTransferred / snap.totalBytes;
                return Text((progress * 100).toString(),style: chatTextName,);
              } else {
                return Text("No task started",style: chatTextName,);
              }
            },
          )
        : Text("No Task NULL",style: chatTextName,);
  }

  Future<UploadTask?> upload_post() async {
    if (file == null) return null;
    final destination = "Posts/${_auth.currentUser!.displayName.toString()}";
    final ref = FirebaseStorage.instance.ref(destination);
    try {
      task = ref.putFile(file!);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"photourl": urlDownload});
      await _auth.currentUser!.updatePhotoURL(urlDownload);
      await _auth.currentUser!.reload();
      return task;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<String?> changeName(String name) async {
    String response = "error";
    await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"name": name});
    await _auth.currentUser!.updateDisplayName(name).then((value) {
      response = "success";
    }).onError((error, stackTrace) {
      response = "error";
    });
    await _auth.currentUser!.reload();
    return response;
  }
}
