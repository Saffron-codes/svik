import 'dart:io';

import 'package:chatapp/config/toast/app_toast.dart';
import 'package:chatapp/pages/upload_post/models/upload_post.dart';
import 'package:chatapp/services/firebase_services/upload_post_service/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UploadPostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UploadState uploadState = UploadState.none;
  UploadTask? task;
  final ToastHelper _toastHelper = ToastHelper();

  void uploadPost(BuildContext contextPost, UploadPost post) async {
    final ref =
        _firebaseStorage.ref("/Posts/${_auth.currentUser!.uid}/${post.id}");
    try {
      task = ref.putFile(post.file);
    } on FirebaseException catch (e) {
      _toastHelper.errorToast("message:$e");
    }

    try {
      final snapshot = await task!.whenComplete(() {
        _toastHelper.infoToast("Uploaded Image");
      });
      final urlDownload = await snapshot.ref.getDownloadURL();
      final time = Timestamp.now();
      _firestore
          .collection("posts")
          .doc(_auth.currentUser!.uid)
          .collection("posts")
          .doc(post.id)
          .set({
        'uid': _auth.currentUser!.uid,
        'id': post.id,
        'caption': post.caption,
        'post_url': urlDownload,
        'like': 0,
        'time':time
      }).then((value) async {
        _toastHelper.infoToast("Uploaded Info 🚀 ");
        final friends = await _firestore
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .collection("Friends")
        .get();
        Logger().i(friends.docs);
        friends.docs.forEach((element)async {
          await _firestore.collection("feeds")
          .doc(element.get("uid"))
          .collection("posts")
          .doc(post.id)
          .set({
            "userid":_auth.currentUser!.uid,
            "postid":post.id,
            "time":time
          });
        });
      });
    } on FirebaseException catch (e) {
      _toastHelper.errorToast("message:$e");
    }
  }
}
