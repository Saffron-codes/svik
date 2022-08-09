import 'dart:async';

import 'package:chatapp/pages/user_chat/widgets/no_friend_message_widget.dart';
import 'package:chatapp/providers/theme_provider/theme_model.dart';
import 'package:chatapp/utils/chatroom_id.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../../widgets/layouts/new_chat_tile_layout.dart';
import '../../chat/chat.dart';

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
  late Timer _timer;
  @override
  void dispose() {
    _searchController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dateTime = DateTime.now();
      });
    });
  }

  @override
  void initState() {
    // startTimer();
    refresh();
    super.initState();
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

    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      final bool _newUser = _myfriendList.isEmpty ? true : false;
      // Future.delayed(Duration(seconds: 5));
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CupertinoSearchTextField(
              prefixIcon: Icon(
                EvaIcons.search,
                color: themeNotifier.isDark ? null : Colors.black,
              ),
              backgroundColor: themeNotifier.isDark ? Color(0xff303136) : null,
              // itemColor: Color.fromARGB(255, 235, 228, 228),
              itemColor: themeNotifier.isDark
                  ? Color(0xffA3A0AC)
                  : CupertinoColors.secondaryLabel,
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
          search != ""
              ? ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  itemCount: output.length,
                  itemBuilder: (_, idx) {
                    return ChatBox(
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
              : Expanded(
                  child: RefreshIndicator(
                    color: Color.fromARGB(255, 72, 72, 72),
                    backgroundColor: Color.fromARGB(255, 18, 18, 19),
                    onRefresh: refresh,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      //shrinkWrap: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: _myfriendList.length,
                      itemBuilder: (_, idx) {
                        return ChatBox(
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
                    ),
                  ),
                )
        ],
      );
    });
  }
  

  //since the timer is used this method will be removed
  
  Future<void> refresh() async {
    setState(() {
      dateTime = DateTime.now();
    });
    Future.delayed(Duration.zero);
    //return dateTime as Future<DateTime>;
  }
}
