import 'dart:io';

import 'package:chatapp/services/firebase_services/feed_service/feed_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class FeedProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final _postsSnapShot = <DocumentSnapshot>[];
  int documentLimit = 2;
  bool _hasNext = true;
  bool _isFetchingPosts = false;
  bool get hasNext => _hasNext;
  bool get isFecthingPosts => _isFetchingPosts;

  List<Map> get posts => _postsSnapShot.map((postSnap) {
        final post = postSnap.data() as Map;
        return {
          "postid": post["postid"],
          "time": post["time"],
          "userid": post["userid"]
        };
      }).toList();

  Future fetchPosts() async {
    // _isFetchingRequested = true;
    try {
      final snap = await FeedService().getPosts(documentLimit, startAfter: null);
      // Logger().i(_postsSnapShot.length);
      if (_postsSnapShot.isEmpty) {
        _postsSnapShot.addAll(snap.docs);
        if(snap.docs.length < documentLimit) _hasNext = false;
      }
      // (snap.docs.length < documentLimit) ? _hasNext = false : true;
      notifyListeners();
    } catch (error) {}
  }

  Future fetchNextPosts() async {
    Logger().i(_isFetchingPosts);
    if (_isFetchingPosts) return;
    _isFetchingPosts = true;
    try {
      final snap = await FeedService().getPosts(2,
          startAfter: _postsSnapShot.isNotEmpty ? _postsSnapShot.last : null);
      _postsSnapShot.addAll(snap.docs);
      if(snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      print(error);
    }
    _isFetchingPosts = false;
  }

  getPost(String userId, String postId) async {
    return FeedService().getPost(userId, postId);
  }
}
