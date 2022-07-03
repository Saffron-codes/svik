import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/utils/convert_to_ago.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:flutter/material.dart';

import '../../config/theme/theme_constants.dart';

class UserChatTile extends StatefulWidget {
  final Friend friend;
  final void Function()?  onTapChat;
  final DateTime currentTime;
  const UserChatTile({Key? key, required this.friend, this.onTapChat, required this.currentTime}) : super(key: key);

  @override
  State<UserChatTile> createState() => _UserChatTileState();
}

class _UserChatTileState extends State<UserChatTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TouchableOpacity(
              onTap: () {},
              child: CachedNetworkImage(
                imageUrl: widget.friend.photourl,
                imageBuilder: (context, imageProvider) => Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TouchableOpacity(
                onTap:widget.onTapChat,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.friend.name,
                          style:
                              TextStyle(color: Color(0xffD8D8D8), fontSize: 16),
                        ),
                        widget.friend.lastmessage.isEmpty
                            ? Text(
                                "Added ${convertToAgo(widget.friend.added.toDate(),widget.currentTime)}",
                                style: ThemeConstants().chatTextName,
                              )
                            : 
                            widget.friend.lastmessage.length <=26?
                            widget.friend.lastmessage.contains("\n")?
                            Text(
                                "${widget.friend.lastmessage.substring(0,5)}...",
                                style: TextStyle(color: Colors.grey),
                              ):
                              Text(
                                widget.friend.lastmessage,
                                style: TextStyle(color: Colors.grey),
                              ):

                              Text(
                                "${widget.friend.lastmessage.substring(0,23)}...",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                    Spacer(),
                    widget.friend.lastmessagetime != null
                        ? Text(
                            convertToAgo(widget.friend.lastmessagetime.toDate(),widget.currentTime),
                            style: ThemeConstants().chatTextName,
                          )
                        : Container(),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
