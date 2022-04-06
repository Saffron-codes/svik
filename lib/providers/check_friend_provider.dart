import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class checkFriend extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DataProgress dataProgress = DataProgress.none;
   Future<DataProgress> check(String receiver) async {
     dataProgress = DataProgress.loading;
     notifyListeners();
    var doc = await _firestore
        .collection("Friends")
        .doc(receiver)
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .get();
    if (doc.exists) {
      //friend_provider.isfriend = true;
      return DataProgress.done;
    } else {
      //friend_provider.isfriend = false;
      return DataProgress.none;
    }
  }
}
