import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/models/chatroom_id.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user.dart';
import 'package:chatapp/routes/chatpage/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class UserChatList extends StatefulWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  //FocusNode search_node = FocusNode();
  String search = "";
  DateTime dateTime =  DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<Friend> _myfriendList = [];
    final FirebaseAuth _auth = FirebaseAuth.instance;
    List<Friend> friendslist = Provider.of<List<Friend>>(context);
    List<SearchUser> _userList = Provider.of<List<SearchUser>>(context);
    friendslist.sort((a,b)=>b.lastmessagetime.compareTo(a.lastmessagetime));
    for(var user in _userList){
      for(var friend in friendslist){
        if(friend.uid == user.uid){
          print(friend.name);
          setState(() {
            _myfriendList.add(
              Friend(friend.added, user.name, user.photourl, friend.lastmessage, friend.lastmessagetime, friend.keywords, user.uid)
            );
          });
        }
      }
    }
    _myfriendList.sort((a,b)=>b.lastmessagetime.compareTo(a.lastmessagetime));
    List<Friend> output =
        _myfriendList.where((item) => item.keywords.contains(search)).toList();
    return RefreshIndicator(
      color: Color(0xff209EF1),
      backgroundColor: Color(0xff242232),
      onRefresh: refresh,
      child: ListView(
          physics: BouncingScrollPhysics(),
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
                  style: TextStyle(color: Color(0xffA3A0AC)),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  controller: _searchController,
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
                              SwipeablePageRoute(
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
                        leading: GestureDetector(
                          onTap: ()=>Navigator.pushNamed(context, "/profile",arguments: output[idx]),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(output[idx].photourl),
                          ),
                        ),
                        // leading: CircleAvatar(
                        //   backgroundImage:
                        //       NetworkImage(friendslist[idx].photourl),
                        // ),
                        title: Text(output[idx].name,style:chatTextName,),
                        subtitle: output[idx].lastmessage.isEmpty?Text("Added ${convertToAgo(output[idx].added.toDate())}",style: chatTextName,):Text(output[idx].lastmessage,style: chatTextName,),
                        trailing:
                          _myfriendList[idx].lastmessagetime !=null?
                            Text(convertToAgo(output[idx].lastmessagetime.toDate()),style: chatTextName,):
                            Container()
                      );
                    },
                  )
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _myfriendList.length,
                    itemBuilder: (_, idx) {
                      return ListTile(
                        onTap: () {
                          
                          Navigator.push<void>(
                              context,
                              SwipeablePageRoute(
                                  builder: (_) => ChatPage(
                                        chatroomid: chatRoomId(
                                            _auth.currentUser!.uid
                                                .toString(),
                                            _myfriendList[idx].uid),
                                        friend: Friend(
                                            _myfriendList[idx].added,
                                            _myfriendList[idx].name,
                                            _myfriendList[idx].photourl,
                                            _myfriendList[idx].lastmessage,
                                            _myfriendList[idx].lastmessagetime, [],_myfriendList[idx].uid),
                                      )));
                        },
                        leading: GestureDetector(
                          onTap: ()=>Navigator.pushNamed(context, "/profile",arguments: _myfriendList[idx]),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(_myfriendList[idx].photourl),
                          ),
                        ),
                        // leading: CircleAvatar(
                        //   backgroundImage:
                        //       NetworkImage(friendslist[idx].photourl),
                        // ),
                        title: Text(_myfriendList[idx].name,style:chatTextName,),
                        subtitle: _myfriendList[idx].lastmessage.isEmpty?Text("Added ${convertToAgo(_myfriendList[idx].added.toDate())}",style: chatTextName,):Text(friendslist[idx].lastmessage,style: chatTextName,),
                        trailing:
                          _myfriendList[idx].lastmessagetime !=null?
                            Text(convertToAgo(_myfriendList[idx].lastmessagetime.toDate()),style: chatTextName,):
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
        return '${difference.inDays} d ago'; 
      }
      return '${difference.inDays} d ago';
    }
     else if (difference.inHours >= 1 && difference.inHours<24) {
       if(difference.inDays == 1){
        return '${difference.inHours} h ago'; 
      }
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes >= 1 && difference.inMinutes <60) {
      if(difference.inMinutes == 1){
        return '${difference.inMinutes} m ago';
      }
      return '${difference.inMinutes} m ago';
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
