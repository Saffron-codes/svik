import 'dart:io';

import 'package:chatapp/constants/theme_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
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
  CroppedFile? croppedFile;
  static const platform = MethodChannel('com.javesindia/channels');
  UploadTask? uploadTask;
  //Choose Image for profile
  Future<bool> chooseImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    chosenImagePath = result?.files.single.path;
    notifyListeners();
    if (result != null) {
      isFileChosen = true;
      userDataProgress = DataProgress.none;
      croppedFile = await ImageCropper().cropImage(
          sourcePath: chosenImagePath.toString(),
          aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
          cropStyle: CropStyle.rectangle,
          compressQuality: 70,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "Crop Profile",
              toolbarColor: chatPageBg,
              toolbarWidgetColor: themeBlueColor,
              hideBottomControls: true,
              showCropGrid: false,
              //initAspectRatio: CropAspectRatioPreset.ratio5x4
            )
          ]);
      if (croppedFile != null) {
        chosenImagePath = croppedFile!.path;
        print("Cropped");
        notifyListeners();
      } else {}
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

  //crop a choosen image again
  void cropImage() async {
    croppedFile = await ImageCropper().cropImage(
        sourcePath: chosenImagePath.toString(),
        aspectRatioPresets: [CropAspectRatioPreset.original],
        cropStyle: CropStyle.circle,
        compressQuality: 70);
    if (croppedFile != null) {
      chosenImagePath = croppedFile!.path;
      print("Cropped");
      notifyListeners();
    } else {}
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
  showToast() {
    platform.invokeMethod("toast", {"data": "An Error Occured"});
  }

  Future loadUserData(BuildContext ctx) async {
    if (userName.isNotEmpty) {
      userDataProgress = DataProgress.loading;
      notifyListeners();
      await _auth.currentUser!
          .updateDisplayName(userName)
          .whenComplete(() async {
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
      try {
        final result = await InternetAddress.lookup("www.google.com").timeout(
          Duration(seconds: 3),
          onTimeout: () => showToast(),
        );
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          uploadTask = ref.putFile(File(chosenImagePath!));
        }
      } on SocketException catch (_) {
        userDataProgress = DataProgress.none;
        showToast();
        notifyListeners();
      }
      if (uploadTask != null) {
        uploadTask!.whenComplete(() async {
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
        });
      }
    }
  }
}
