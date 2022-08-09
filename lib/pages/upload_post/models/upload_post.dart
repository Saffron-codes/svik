import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPost {
  String userid;
  String id;
  File file;
  String caption;
  Timestamp time;
  int like;
  UploadPost(
      {required this.userid,
      required this.id,
      required this.file,
      required this.caption,
      required this.like,
      required this.time});

  // Map<String, dynamic> toMap() {
  // return {
  //   'userid':userid,
  //   'id':'id',
  //   ''
  // };
  // }
}
