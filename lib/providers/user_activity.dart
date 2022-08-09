import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/models/user_activity_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:chatapp/services/firebase_services/activity_service/activity_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserActivityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DataProgress activityProgress = DataProgress.none;
  List<UserActivity> userActivities = [];

  
  Stream<List<UserActivity>>? getAllActivities() {
    return ActivityService().getActivities();
  }

  addActivity(String uid, SearchUser user) async {
    var logger = Logger();
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
      "category": "sent"
    });
    logger.i("Added sent activity");
    await _firestore
        .collection("activities")
        .doc(uid)
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .set({
      "friend_uid": _auth.currentUser!.uid,
      "status": "pending",
      "time": Timestamp.now(),
      "category": "received"
    });
    logger.i("Added received activity");
  }

  Future<void> removeActivity(String uid) async {
    // delete the current user's received activity
    await _firestore
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .collection("activities")
        .doc(uid)
        .delete();

    //delete the friend's sent activity
    await _firestore
        .collection("activities")
        .doc(uid)
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .delete();
  }
}
