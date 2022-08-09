import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/pages/chat/widgets/message_action/message_action_sheet.dart';
import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:chatapp/services/firebase_services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final String chatroomid;
  const MessageWidget(
      {Key? key, required this.message, required this.chatroomid})
      : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showMessageActionSheet() {
    final chatProvider = Provider.of<ChatPageProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => MessageActionSheet(
        chatRoomId: widget.chatroomid,
        message: widget.message,
        chatProvider: chatProvider,
      ),
    );
  }

  void addCustomReaction() {
    final chatProvider = Provider.of<ChatPageProvider>(context, listen: false);
    chatProvider.getfavEmoji();
    FirestoreServices().addReactions(widget.chatroomid, widget.message.id, chatProvider.favEmoji);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showMessageActionSheet();
      },
      onDoubleTap: () {
        addCustomReaction();
      },
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: widget.message.from != _auth.currentUser!.uid
              ? Alignment.topLeft
              : Alignment.topRight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                child: Text(
                  widget.message.message,
                  style: TextStyle(
                    color: widget.message.from == _auth.currentUser!.uid
                        ? Colors.white
                        : Color(0xffD9D6DF),
                  ),
                ),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: widget.message.from == _auth.currentUser!.uid
                      ? Color(0xff0181FF)
                      : Color(0xff32363E),
                ),
              ),
              widget.message.reactions.isNotEmpty
                  ? Positioned(
                      bottom: -12,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff141E29),
                        ),
                        child: Center(
                          child: Text(
                            widget.message.reactions,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    )
                  : Positioned(
                      child: Text(""),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
