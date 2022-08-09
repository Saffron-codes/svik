import 'package:chatapp/models/user_activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<UserActivity>> getActivities() {
    return _firestore
        .collection("activities")
        .doc(_auth.currentUser!.uid)
        .collection("activities")
        .orderBy("time")
        .snapshots()
        .map((event) => event.docs
            .map(
              (activity) => UserActivity.fromFirestore(
                activity.data(),
              ),
            )
            .toList());
  }
}
