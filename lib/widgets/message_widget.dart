import 'package:chatapp/models/message.dart';
import 'package:chatapp/widgets/bottom_sheets/add_reactiosns_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final String chatroomid;
  const MessageWidget({Key? key, required this.message,required this.chatroomid}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => addReaction(context,widget.message.id,widget.chatroomid),
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: widget.message.from != _auth.currentUser!.uid
              ? Alignment.topLeft
              : Alignment.topRight,
          child: Stack(
            clipBehavior:Clip.none,
            children: [
              Container(
                  child: Text(widget.message.message,
                  style: TextStyle(
                    color: widget.message.from == _auth.currentUser!.uid?Colors.white:Color(0xffD9D6DF)
                  ),),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.message.from == _auth.currentUser!.uid
                          ? Color(0xff0181FF)
                          : Color(0xff343047))),
              widget.message.reactions.isNotEmpty
                  ? Positioned(
                    bottom: -12,
                      child: Container(
                        height: 20,
                        width: 20,
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(8),
                        color: Color(0xff141E29)
                      ),
                      child: Center(child: Text(widget.message.reactions,style: TextStyle(fontSize: 10),)),
                    ))
                  : Positioned(child: Text(""))
            ],
          ),
          // child: Container(
          //   padding: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20),
          //     color: widget.message.from == _auth.currentUser!.displayName?Color(0xffD3E4CD):Color(0xff99A799)
          //   ),
          //   child: Stack(
          //     children: [
          //       Text(widget.message.message),
          //       widget.message.reactions.isNotEmpty?Positioned(child: CircleAvatar(radius: 10,)):Container()
          //     ],
          //   )
          // ),
        ),
      ),
    );
  }
}
