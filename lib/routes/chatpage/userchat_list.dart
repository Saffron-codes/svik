import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/utils/chatroom_id.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user.dart';
import 'package:chatapp/routes/chatpage/chatpage.dart';
import 'package:chatapp/widgets/layouts/user_chat_tile_layout.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../utils/convert_to_ago.dart';

class UserChatList extends StatefulWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  //FocusNode search_node = FocusNode();
  String search = "";
  DateTime dateTime = DateTime.now();
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
    friendslist.sort((a, b) => b.lastmessagetime.compareTo(a.lastmessagetime));
    for (var user in _userList) {
      for (var friend in friendslist) {
        if (friend.uid == user.uid) {
          // print(friend.name);
          setState(() {
            _myfriendList.add(Friend(
                friend.added,
                user.name,
                user.photourl,
                friend.lastmessage,
                friend.lastmessagetime,
                friend.keywords,
                user.uid));
          });
        }
      }
    }
    _myfriendList
        .sort((a, b) => b.lastmessagetime.compareTo(a.lastmessagetime));
    List<Friend> output =
        _myfriendList.where((item) => item.keywords.contains(search)).toList();
    return RefreshIndicator(
      color: Color(0xff209EF1),
      backgroundColor: Color(0xff242232),
      onRefresh: refresh,
      child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          // shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 50,
                child: CupertinoSearchTextField(
                  backgroundColor: Color(0xff202A44),
                  // itemColor: Color.fromARGB(255, 235, 228, 228),
                  itemColor: Color(0xffA3A0AC),
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
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: output.length,
                    itemBuilder: (_, idx) {
                      return UserChatTile(
                        friend: output[idx],
                        onTapChat: () {
                          Navigator.push(
                            context,
                            SwipeablePageRoute(
                              builder: (_) => ChatPage(
                                chatroomid: chatRoomId(
                                    _auth.currentUser!.uid.toString(),
                                    output[idx].uid),
                                friend: Friend(
                                    output[idx].added,
                                    output[idx].name,
                                    output[idx].photourl,
                                    output[idx].lastmessage,
                                    output[idx].lastmessagetime,
                                    [],
                                    output[idx].uid),
                              ),
                            ),
                          );
                        },
                        currentTime: dateTime,
                      );
                    },
                  )
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _myfriendList.length,
                    itemBuilder: (_, idx) {
                      return UserChatTile(
                        friend: _myfriendList[idx],
                        onTapChat: () {
                          Navigator.push(
                            context,
                            SwipeablePageRoute(
                              builder: (_) => ChatPage(
                                chatroomid: chatRoomId(
                                    _auth.currentUser!.uid.toString(),
                                    _myfriendList[idx].uid),
                                friend: Friend(
                                    _myfriendList[idx].added,
                                    _myfriendList[idx].name,
                                    _myfriendList[idx].photourl,
                                    _myfriendList[idx].lastmessage,
                                    _myfriendList[idx].lastmessagetime,
                                    [],
                                    _myfriendList[idx].uid),
                              ),
                            ),
                          );
                        },
                        currentTime: dateTime,
                      );
                    },
                  )
          ]),
    );
  }

  Future<void> refresh() async {
    setState(() {
      dateTime = DateTime.now();
    });
    Future.delayed(Duration.zero);
    //return dateTime as Future<DateTime>;
  }
}
