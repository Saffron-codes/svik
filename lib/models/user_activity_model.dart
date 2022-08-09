import 'package:chatapp/models/friend_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserActivity{
 String status;
  Timestamp time;
  String friend_uid;
  String category;
  UserActivity({required this.status,required this.time,required this.friend_uid,required this.category});


    UserActivity.fromFirestore(Map<String, dynamic> firestoreMap)
      : status = firestoreMap['status'],
        time = firestoreMap['time'],
        friend_uid = firestoreMap['friend_uid'],
        category = firestoreMap['category'];
}