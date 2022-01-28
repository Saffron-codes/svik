import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/chatroom_id.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/routes/chatpage/chatpage.dart';
import 'package:chatapp/routes/chatpage/userchat_list.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var chatid = "";
    return StreamProvider<List<Friend>>.value(
      value: FirestoreServices().friendslist,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TouchableOpacity(child: Icon(Icons.add_comment_outlined), onTap: (){}),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TouchableOpacity(child: Icon(Icons.settings_outlined), onTap: (){}),
            )
          ],
        ),
        body: UserChatList(),
      ),
    );
  }
}
