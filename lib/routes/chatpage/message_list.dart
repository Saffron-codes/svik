import 'dart:async';

import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/widgets/message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  final Friend friend;
  const MessageList({Key? key, required this.friend}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollcontroller = ScrollController();

  void _scrollToBottom() {
    if (_scrollcontroller.hasClients) {
      _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  void initState() {
    //_scrollToBottom();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    List<Message> messagelist = Provider.of<List<Message>>(context);
    final currentUser = context.watch<User>();
    final friend = widget.friend;
    return ListView(
      controller: _scrollcontroller,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 80,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(currentUser.photoURL.toString()),
                  radius: 30,
                ),
              ),
              Positioned(
                top: 25,
                left: 180,
                child: Text(
                  "❤️",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Positioned(
                top: 80,
                left: 100,
                child: Text(
                  "Begining of chat with ${friend.name}",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              Positioned(
                top: 10,
                right: 80,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(friend.photourl),
                  radius: 30,
                ),
              )
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: messagelist.length,
          itemBuilder: (_, idx) {
            return MessageWidget(
                message: Message(
                    messagelist[idx].message,
                    messagelist[idx].from,
                    messagelist[idx].time,
                    messagelist[idx].type));
          },
        )
      ],
    );
  }
}
