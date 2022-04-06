import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/user_activity_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserActivityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DataProgress activityProgress = DataProgress.none;
  Stream<List<UserActivity>>? getAllActivities() {
    return _firestore
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .collection("activities")
        .orderBy("time")
        .snapshots()
        .map((event) => event.docs
            .map(
              (DocumentSnapshot ds) => UserActivity(status: ds.get("status"), time: ds.get("time"), friend_uid: ds.get("friend_uid"),category: ds.get("category")),
            )
            .toList());
  }

  addActivity(String uid, UserModel user) async {
    activityProgress = DataProgress.loading;
    notifyListeners();
    await _firestore
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .collection("activities")
        .doc(uid)
        .set({
      "friend_uid": uid,
      "status": "pending",
      "time": Timestamp.now(),
      "category":"sent"
    });
    await _firestore
        .collection("activities")
        .doc(uid)
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .set({
      "friend_uid": _auth.currentUser!.uid,
      "status": "pending",
      "time": Timestamp.now(),
      "category":"received"
    });
  }
}
