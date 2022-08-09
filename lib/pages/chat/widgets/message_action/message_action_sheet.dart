import 'package:chatapp/config/toast/app_toast.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/pages/chat/widgets/add_reactions/choose_emoji_sheet.dart';
import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:chatapp/services/firebase_services/firebase_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageActionSheet extends StatefulWidget {
  final String chatRoomId;
  final Message message;
  final ChatPageProvider chatProvider;
  const MessageActionSheet(
      {Key? key,
      required this.chatRoomId,
      required this.message,
      required this.chatProvider})
      : super(key: key);

  @override
  State<MessageActionSheet> createState() => _MessageActionSheetState();
}

class _MessageActionSheetState extends State<MessageActionSheet> {
  ToastHelper _toastHelper = ToastHelper();
  void addReaction(String reaction) {
    FirestoreServices()
        .addReactions(widget.chatRoomId, widget.message.id, reaction)
        .then((value) {
          _toastHelper.infoToast("added  $reaction");
      Navigator.pop(context);
    });
  }

  void editMessage(String message) {
    widget.chatProvider.requestFocus();
    widget.chatProvider.changeEditState(true, widget.message.id);
    widget.chatProvider.setmessage = message;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin:EdgeInsets.all(6),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    child: Text("❤️"),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () {
                    addReaction("❤️");
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    child: Text("👍"),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () => addReaction("👍"),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    child: Text("👎"),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () => addReaction("👎"),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    child: Text("😂"),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () => addReaction("😂"),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    child: Text("😮"),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () => addReaction("😮"),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    child: Icon(EvaIcons.plus),
                    backgroundColor: Colors.black26,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ChooseEmojiWidget(providerModel: widget.chatProvider,));
                  },
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              EvaIcons.edit,
              color: Colors.grey[500],
            ),
            title: Text(
              "Edit Message",
              style: TextStyle(color: Colors.grey[500]),
            ),
            onTap: () {
              editMessage(widget.message.message);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              EvaIcons.trash2,
              color: Colors.grey[500],
            ),
            title: Text(
              "Delete Message",
              style: TextStyle(color: Colors.grey[500]),
            ),
            onTap: () {
              FirestoreServices()
                  .deleteMessage(context, widget.chatRoomId, widget.message.id);
            },
          )
        ],
      ),
    );
  }
}
