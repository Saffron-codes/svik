import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

//enums

enum DataProgress {
  none,
  done,
  loading,
  failed,
}

class UploadProfile extends ChangeNotifier {
  String? chosenImagePath = "";
  bool isFileChosen = false;
  String userName = "";
  // bool? isUserDataLoaded = false;
  DataProgress userDataProgress = DataProgress.none;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Choose Image for profile
  Future<bool> chooseImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    chosenImagePath = result?.files.single.path;
    notifyListeners();
    if (result != null) {
      isFileChosen = true;
      userDataProgress = DataProgress.none;
      notifyListeners();
      return true;
    }
    isFileChosen = false;
    // chosenImagePath = "";
    notifyListeners();
    return false;
  }

  //Remove Image
  void removeImage() {
    isFileChosen = false;
    notifyListeners();
  }

  //Change Name State
  void changeName(String name) {
    userName = name;
    notifyListeners();
  }

  // Future loadUserData() async {
  //   userDataProgress = DataProgress.loading;
  //   notifyListeners();
  //   DataProgress currentProgress = uploadProfile();
  //   userDataProgress = currentProgress;
  //   print(currentProgress);
  //   notifyListeners();
  //   // await Future.delayed(Duration(seconds: 4)).whenComplete(() {
  //   //   userDataProgress = DataProgress.done;
  //   //   notifyListeners();
  //   // });
  // }

  Future loadUserData(BuildContext ctx) async {
    if (userName.isNotEmpty) {
      userDataProgress = DataProgress.loading;
      notifyListeners();
      await _auth.currentUser!.updateDisplayName(userName).whenComplete(()async {
        await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"name": userName});
        userDataProgress = DataProgress.done;
        userName = "";
        notifyListeners();
        Navigator.pop(ctx);
      }).catchError((e, s) {
        userDataProgress = DataProgress.failed;
        notifyListeners();
      });
    }
    if (isFileChosen) {
      //uploading the file
      userDataProgress = DataProgress.loading;
      notifyListeners();
      final destination = "Profiles/${_auth.currentUser!.uid}";
      final ref = FirebaseStorage.instance.ref(destination);
      ref.putFile(File(chosenImagePath!)).whenComplete(() async {
        userDataProgress = DataProgress.done;
        isFileChosen = false;
        final urlDownload = await ref.getDownloadURL();
        _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"photourl": urlDownload});
        await _auth.currentUser!.updatePhotoURL(urlDownload);
        await _auth.currentUser!.reload();
        //update the user name
        // userName.isNotEmpty?
        // await _auth.currentUser!.updateDisplayName(userName):null;

        notifyListeners();
        Navigator.pop(ctx);
      }).catchError((e, s) {
        userDataProgress = DataProgress.failed;
        notifyListeners();
      });
    }
  }
}
