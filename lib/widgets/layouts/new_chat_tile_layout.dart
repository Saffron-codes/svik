import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/friend_model.dart';
import '../../utils/convert_to_ago.dart';

class ChatBox extends StatefulWidget {
  final Friend friend;
  final void Function()? onTapChat;
  final DateTime currentTime;
  const ChatBox(
      {Key? key,
      required this.friend,
      this.onTapChat,
      required this.currentTime})
      : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onTapChat,
      child: Container(
        height: 60,
        //color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CachedNetworkImage(
              imageUrl: widget.friend.photourl,
              imageBuilder: (context, imageProvider) => Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
              placeholder: (context,str)=>Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[600]
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friend.name,
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
                SizedBox(
                  height: 2,
                ),
                widget.friend.lastmessage.length <= 26
                    ? widget.friend.lastmessage.contains("\n")
                        ? Text(
                            "${widget.friend.lastmessage.substring(0, 5)}...",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          )
                        : Text(
                            widget.friend.lastmessage,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          )
                    : Text(
                        "${widget.friend.lastmessage.substring(0, 23)}...",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      )
              ],
            ),
            Expanded(child: Container()),
            widget.friend.lastmessagetime != null
                ? Text(
                    convertToAgo(widget.friend.lastmessagetime.toDate(),
                        widget.currentTime),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  )
                : Container(),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
