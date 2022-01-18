import 'package:chatapp/firebase_services/firebaseauth_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/search_user.dart';
import 'package:chatapp/models/story.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/user_profile_provider/banner_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class FirestoreServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isfriendadded = true;
  void added_friend(bool value) {
    isfriendadded = value;
    notifyListeners();
  }

  Stream<List<Friend>> get friendslist {
    return _firestore
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .collection("Friends")
        .orderBy("lastmessagetime")
        .snapshots()
        .map((event) => event.docs
            .map((DocumentSnapshot ds) => Friend(
                ds.get("added@"),
                ds.get("name"),
                ds.get("photourl"),
                ds.get("lastmessage"),
                ds.get("lastmessagetime"),
                ds.get("keywords"),
                ds.get("uid")))
            .toList());
  }

  Stream<List<Story>> get storylist {
    return _firestore
        .collection("stories")
        .orderBy("time", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((DocumentSnapshot ds) =>
                Story(ds.get("url"), ds.get("time"), ds.get("name")))
            .toList());
  }

  Stream<List<SearchUser>> get searchusers {
    return _firestore.collection("users").snapshots().map((event) => event.docs
        .map((DocumentSnapshot ds) => SearchUser(
            ds.get("email"),
            ds.get("keywords"),
            ds.get("name"),
            ds.get("photourl"),
            ds.get("uid")))
        .toList());
  }

  addfriend(Friend friend) {
    added_friend(false);
    return _firestore
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .collection("Friends")
        .doc(friend.uid)
        .set({
      "added@": friend.added,
      "name": friend.name,
      "photourl": friend.photourl,
      "keywords": friend.keywords,
      "lastmessage": "",
      "lastmessagetime": Timestamp.now(),
      "uid": friend.uid
    });
  }

  Stream<List<Message>>? getmessages(String id) {
    return AuthService().user != null
        ? _firestore
            .collection("chats")
            .doc(id)
            .collection("Chats")
            .orderBy("time")
            .snapshots()
            .map((event) => event.docs
                .map((DocumentSnapshot ds) => Message(ds.get("message"),
                    ds.get("from"), ds.get("time"), ds.get("type"),ds.get("reactions")))
                .toList())
        : null;
  }

  sendmessage(Message message, String chatroomid, String receiverid) async {
    print(chatroomid);
    await _firestore
        .collection("chats")
        .doc(chatroomid)
        .collection("Chats")
        .doc()
        .set({
      "from": message.from,
      "message": message.message,
      "time": Timestamp.now(),
      "type": message.type,
      "reactions":[]
    });
    await _firestore
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .collection("Friends")
        .doc(receiverid)
        .update({
      "lastmessage": message.message,
      "lastmessagetime": Timestamp.now()
    });
    await _firestore
        .collection("Friends")
        .doc(receiverid)
        .collection("Friends")
        .doc(_auth.currentUser!.displayName)
        .update({
      "lastmessage": message.message,
      "lastmessagetime": Timestamp.now()
    });
  }

  Future<bool> checkbothfriends(String receiver, context) async {
    print(_auth.currentUser!.displayName);
    //final friend_provider = Provider.of<bannercolorprovider>(context);
    var doc = await _firestore
        .collection("Friends")
        .doc(receiver)
        .collection("Friends")
        .doc(_auth.currentUser!.displayName)
        .get();
    if (doc.exists) {
      //friend_provider.isfriend = true;
      return true;
    } else {
      //friend_provider.isfriend = false;
      return false;
    }
  }

  // Future<List<Friend>> getFriends(String uid) {
  //   return _firestore
  //       .collection("Friends")
  //       .doc(uid)
  //       .collection("Friends")
  //       .get()
  //       .then((value) {
  //     return value.docs.map((ds) {
  //       return Friend(
  //           ds.get("added@"),
  //           ds.get("name"),
  //           ds.get("photourl"),
  //           ds.get("lastmessage"),
  //           ds.get("lastmessagetime"),
  //           ds.get("keywords"),
  //           ds.get("uid"));
  //     }).toList();
  //   });
  // }

  Stream<List<Friend>>  getFriends(String uid) {
    return _firestore
        .collection("Friends")
        .doc(uid)
        .collection("Friends")
        .snapshots()
        .map((event) => event.docs
            .map((DocumentSnapshot ds) => Friend(
                ds.get("added@"),
                ds.get("name"),
                ds.get("photourl"),
                ds.get("lastmessage"),
                ds.get("lastmessagetime"),
                ds.get("keywords"),
                ds.get("uid")))
            .toList());
  }
}
