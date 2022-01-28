import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/routes/chatpage/message_list.dart';
import 'package:chatapp/user_profile_provider/banner_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String chatroomid;
  final Friend friend;
  const ChatPage({Key? key, required this.chatroomid, required this.friend})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messagecontroller = TextEditingController();
  String isfriend = "loading";
  late Future<bool> friend_load;
  @override
  void initState() {
    friend_load =
        FirestoreServices().checkbothfriends(widget.friend.uid, context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.chatroomid);
    final friend_provider = Provider.of<bannercolorprovider>(context);

    return StreamProvider<List<Message>>.value(
        value: FirestoreServices().getmessages(widget.chatroomid),
        initialData: [],
        child: Scaffold(
            backgroundColor: Color(0xff242232),
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Color(0xff242232),
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back,color: Color(0xffD8D8D8),)),
                      SizedBox(
                        width: 2,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.friend.photourl),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.friend.name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600,color: Color(0xffD8D8D8)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Online",
                              style:
                                  TextStyle(color: Color(0xffA3A0AC), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.more_vert_outlined,
                        color: Color(0xffD8D8D8),
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: FutureBuilder<dynamic>(
              future: friend_load,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == false) {
                    return Center(
                      child: Text(
                          "🤝waiting for ${widget.friend.name} to add you as friend🤝"),
                    );
                  }
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.25,
                          width: MediaQuery.of(context).size.width,
                          child: MessageList(
                            friend: widget.friend,
                            chatroomid: widget.chatroomid,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(2),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.tag_faces_outlined,color: Color(0xffA3A0AC),))),
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: _messagecontroller,
                                  style: TextStyle(color: Colors.white),
                                  minLines: 1,
                                  maxLines: 100,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintText: "Write message...",
                                      hintStyle:
                                          TextStyle(color: Color(0xffA3A0AC)),
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              FloatingActionButton(
                                backgroundColor: Color(0xff0150FA),
                                onPressed: () {
                                  if (_messagecontroller.text == "") {
                                  } else if (_messagecontroller.text ==
                                          "Fuck" ||
                                      _messagecontroller.text == "shit" ||
                                      _messagecontroller.text == "ass") {
                                    //Toast.show("Hey No Bad Words 😔 ", context,gravity: Toast.CENTER);
                                  } else {
                                    FirestoreServices().sendmessage(
                                        Message(
                                            _messagecontroller.text,
                                            _auth.currentUser!.uid.toString(),
                                            Timestamp.now(),
                                            "text",
                                            "",
                                            ""),
                                        widget.chatroomid,
                                        widget.friend.uid);
                                    //PushNotificationService().callOnFcmApiSendPushNotifications();
                                    _messagecontroller.text = "";
                                  }
                                },
                                child: Icon(Icons.send_rounded),
                                mini: true,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0181FF),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
            // :Center(
            //   child: Text("🤝waiting for ${widget.friend.name} to add you as friend🤝"),
            // )
            ));
  }
}
