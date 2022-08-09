import 'dart:io';

import 'package:chatapp/config/theme/theme_constants.dart';
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
  void chooseImage() async {
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
              toolbarColor: ThemeConstants().chatPageBg,
              toolbarWidgetColor: ThemeConstants().themeBlueColor,
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
    }
    // isFileChosen = false;
    // chosenImagePath = "";
    notifyListeners();
  }

  void imageFromCamera(BuildContext ctx, String path) async {
    isFileChosen = true;
    userDataProgress = DataProgress.none;
    chosenImagePath = path;
    notifyListeners();
    croppedFile = await ImageCropper().cropImage(
        sourcePath: chosenImagePath.toString(),
        aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
        cropStyle: CropStyle.rectangle,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Profile",
            toolbarColor: ThemeConstants().chatPageBg,
            toolbarWidgetColor: ThemeConstants().themeBlueColor,
            hideBottomControls: true,
            showCropGrid: false,
            //initAspectRatio: CropAspectRatioPreset.ratio5x4
          )
        ]);
    if (croppedFile != null) {
      isFileChosen = true;
      chosenImagePath = croppedFile!.path;
      print("Cropped image from camera");
      notifyListeners();
      Navigator.pop(ctx);
      Navigator.pop(ctx);
    }
    // isFileChosen = false;
    // userDataProgress = DataProgress.none;
    notifyListeners();
  }

  void imageFromHome(BuildContext context, String path) async {
    isFileChosen = true;
    userDataProgress = DataProgress.none;
    chosenImagePath = path;
    notifyListeners();
    Navigator.pushNamed(context, '/view_image', arguments: path);
    // croppedFile = await ImageCropper().cropImage(
    //     sourcePath: chosenImagePath.toString(),
    //     //aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
    //     //cropStyle: CropStyle.rectangle,
    //     compressQuality: 70,
    //     uiSettings: [
    //       AndroidUiSettings(
    //         toolbarTitle: "Crop Profile",
    //         toolbarColor: ThemeConstants().chatPageBg,
    //         toolbarWidgetColor: ThemeConstants().themeBlueColor,
    //         //hideBottomControls: true,
    //         //showCropGrid: false,
    //         //initAspectRatio: CropAspectRatioPreset.ratio5x4
    //       )
    //     ]);
    // if (croppedFile != null) {
    //   isFileChosen = true;
    //   chosenImagePath = croppedFile!.path;
    //   notifyListeners();
    //   Navigator.pushNamed(context, '/view_image');
    // }
    // isFileChosen = false;
    // userDataProgress = DataProgress.none;
    notifyListeners();
  }

  //Remove Image
  void removeImage() {
    isFileChosen = false;
    notifyListeners();
  }

  //Change Name State
  void changeName(String name) {
    userName = name;
    chosenImagePath = "";
    notifyListeners();
  }

  void changeImagePath(path) {
    isFileChosen = true;
    chosenImagePath = path;
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
    List<String> keywords = [];

    for (int i = 1; i <= userName.length; i++) {
      keywords.add(userName.substring(0, i));
      keywords.add(userName.toLowerCase().substring(0, i));
    }
    if (userName.isNotEmpty) {
      userDataProgress = DataProgress.loading;
      notifyListeners();
      await _auth.currentUser!
          .updateDisplayName(userName)
          .whenComplete(() async {
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"name": userName,"keywords":keywords});
        userDataProgress = DataProgress.done;
        userName = "";
        notifyListeners();
        Navigator.pop(ctx);
        userDataProgress = DataProgress.none;
        notifyListeners();
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
          userDataProgress = DataProgress.none;
          notifyListeners();
        });
      }
    }
  }
}
