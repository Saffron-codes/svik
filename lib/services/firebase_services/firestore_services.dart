import 'package:chatapp/config/toast/app_toast.dart';
import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/services/firebase_services/firebaseauth_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/models/story_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/user_profile_provider/banner_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
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

  Stream<List<AppUser>> getuserfriends() {
    return _firestore
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .collection("Friends")
        .snapshots()
        .map(
          (snaphots) => snaphots.docs
              .map(
                (doc) => AppUser.fromFirestore(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Story>> get storylist {
    return _firestore
        .collection("stories")
        .orderBy("time", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((DocumentSnapshot ds) => Story(
                [ds.get("url")], ds.get("time"), ds.get("name"), ds.get("uid")))
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

  Future<void> addfriend(Friend newfriend) async {
    await _firestore
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .collection("Friends")
        .doc(newfriend.uid)
        .set({
      "added@": newfriend.added,
      "name": newfriend.name,
      "photourl": newfriend.photourl,
      "keywords": newfriend.keywords,
      "lastmessage": "",
      "lastmessagetime": Timestamp.now(),
      "uid": newfriend.uid
    });

    await _firestore
        .collection("Friends")
        .doc(newfriend.uid)
        .collection("Friends")
        .doc(_auth.currentUser!.uid)
        .set({
      "added@": newfriend.added,
      "name": newfriend.name,
      "photourl": newfriend.photourl,
      "keywords": newfriend.keywords,
      "lastmessage": "",
      "lastmessagetime": Timestamp.now(),
      "uid": _auth.currentUser!.uid
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
                .map((DocumentSnapshot ds) => Message(
                    ds.get("message"),
                    ds.get("from"),
                    ds.get("time"),
                    ds.get("type"),
                    ds.get("reactions"),
                    ds.get("id")))
                .toList())
        : null;
  }

  Stream<List<AppUser>> getFriendsList(String id) {
    return _firestore
        .collection("Friends")
        .doc(id)
        .collection("Friends")
        .snapshots()
        .map((event) => event.docs
            .map(
              (DocumentSnapshot ds) =>
                  AppUser(ds.get("name"), ds.get("uid"), ds.get("photourl")),
            )
            .toList());
  }

  Stream<List<AppUser>>? getAppUsersList() {
    return _firestore.collection("users").snapshots().map((event) => event.docs
        .map(
          (DocumentSnapshot ds) =>
              AppUser(ds.get("name"), ds.get("uid"), ds.get("photourl")),
        )
        .toList());
  }

  sendmessage(Message message, String chatroomid, String receiverid) async {
    print(chatroomid);
    await _firestore
        .collection("chats")
        .doc(chatroomid)
        .collection("Chats")
        .add({
      "from": message.from,
      "message": message.message,
      "time": Timestamp.now(),
      "type": message.type,
      "reactions": "",
      "id": ""
    }).then((value) {
      print(value.id);
      value.update({"id": value.id});
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
        .doc(_auth.currentUser!.uid)
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
        .doc(_auth.currentUser!.uid)
        .get();
    if (doc.exists) {
      //friend_provider.isfriend = true;
      return true;
    } else {
      //friend_provider.isfriend = false;
      return false;
    }
  }

  Future<bool> addReactions(String chatroomid, String id, String emoji) async {
    bool isdone = false;
    await _firestore
        .collection("chats")
        .doc(chatroomid)
        .collection("Chats")
        .doc(id)
        .update({"reactions": emoji}).then((value) => isdone = true);
    return isdone;
  }

  deleteMessage(
      BuildContext context, String chatRoomId, String messageId) async {
    try {
      await _firestore
          .collection("chats")
          .doc(chatRoomId)
          .collection("Chats")
          .doc(messageId)
          .delete()
          .then((value) {
        Navigator.pop(context);
        ToastHelper().infoToast("Deleted message...");
      });
    } catch (e) {
      Logger().i(e);
    }
  }

  editMessage(BuildContext context, String chatRoomId, String messageId,
      String newMessage) async {
    try {
      await _firestore
          .collection("chats")
          .doc(chatRoomId)
          .collection("Chats")
          .doc(messageId)
          .update({"message": newMessage});
      print("DoneEditing");
    } catch (e) {
      Logger().i(e);
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

  Stream<List<Friend>> getFriends(String uid) {
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

  // Stream<List<UserModel>> get getUsers {
  //   return _firestore
  //   .collection("users")
  //   .snapshots()
  // }
}
