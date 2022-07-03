import 'package:chatapp/services/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/userchat_list.dart';

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
          elevation: 0,
          title: Text("Chats"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TouchableOpacity(child: Icon(EvaIcons.personAdd), onTap: (){}),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TouchableOpacity(child: Icon(EvaIcons.moreHorizontal), onTap: (){}),
            )
          ],
        ),
        body: UserChatList(),
      ),
    );
  }
}
