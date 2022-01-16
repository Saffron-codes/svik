import 'package:chatapp/models/chatroom_id.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/routes/chatpage/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserChatList extends StatefulWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  //FocusNode search_node = FocusNode();
  String search = "";
  DateTime dateTime =  DateTime.now();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    List<Friend> friendslist = Provider.of<List<Friend>>(context);
    friendslist.sort((a,b)=>b.lastmessagetime.compareTo(a.lastmessagetime));
    List<Friend> output =
        friendslist.where((item) => item.keywords.contains(search)).toList();
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
          //physics: ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 50,
                child: CupertinoSearchTextField(
                  // focusNode: search_node,
                  onChanged: (val) {
                    setState(() {
                      search = val;
                    });
                  },
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            search != ""
                ? ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: output.length,
                    itemBuilder: (_, idx) {
                      return ListTile(
                        onTap: () {
                          //print()
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                        chatroomid: chatRoomId(
                                            _auth.currentUser!.uid
                                                .toString(),
                                            output[idx].uid),
                                        friend: Friend(
                                            output[idx].added,
                                            output[idx].name,
                                            output[idx].photourl,
                                            output[idx].lastmessage,
                                            output[idx].lastmessagetime, [],output[idx].uid),
                                      )));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(output[idx].photourl),
                        ),
                        title: Text(output[idx].name),
                        subtitle: Text(output[idx].lastmessage),
                        trailing:
                          friendslist[idx].lastmessagetime !=null?
                            Text(convertToAgo(output[idx].lastmessagetime.toDate())):
                            Container()
                      );
                    },
                  )
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: friendslist.length,
                    itemBuilder: (_, idx) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                        chatroomid: chatRoomId(
                                            _auth.currentUser!.uid
                                                .toString(),
                                            friendslist[idx].uid),
                                        friend: Friend(
                                            friendslist[idx].added,
                                            friendslist[idx].name,
                                            friendslist[idx].photourl,
                                            friendslist[idx].lastmessage,
                                            friendslist[idx].lastmessagetime, [],friendslist[idx].uid),
                                      )));
                        },
                        leading: GestureDetector(
                          onTap: ()=>Navigator.pushNamed(context, "/profile",arguments: friendslist[idx]),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(friendslist[idx].photourl),
                          ),
                        ),
                        // leading: CircleAvatar(
                        //   backgroundImage:
                        //       NetworkImage(friendslist[idx].photourl),
                        // ),
                        title: Text(friendslist[idx].name),
                        subtitle: Text(friendslist[idx].lastmessage),
                        trailing:
                          friendslist[idx].lastmessagetime !=null?
                            Text(convertToAgo(friendslist[idx].lastmessagetime.toDate())):
                            Container()
                      );
                    },
                  )
          ]),
    );
  }

  String convertToAgo(DateTime input) {
    Duration difference = dateTime.difference(input);

    if (difference.inDays>=31){
      return '${(difference.inDays/30).toInt()} mon ago';
    }
    else if (difference.inDays>=1 && difference.inDays<30) {
      if(difference.inDays == 1){
        return '${difference.inDays} day ago'; 
      }
      return '${difference.inDays} days ago';
    }
     else if (difference.inHours >= 1 && difference.inHours<24) {
       if(difference.inDays == 1){
        return '${difference.inHours} hour ago'; 
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1 && difference.inMinutes <60) {
      if(difference.inMinutes == 1){
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inMinutes} mins ago';
    } else if (difference.inSeconds >= 1 && difference.inSeconds <60) {
      return '${difference.inSeconds} sec ago';
    }
    else {
      return 'just now';
    }
  }
  Future<void> refresh()async{
    setState(() {
      dateTime = DateTime.now();
    });
    Future.delayed(Duration.zero);
    //return dateTime as Future<DateTime>;
  }
}
