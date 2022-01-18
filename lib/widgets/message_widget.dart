import 'package:chatapp/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: widget.message.from != _auth.currentUser!.displayName
            ? Alignment.topLeft
            : Alignment.topRight,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
                child: Text(widget.message.message),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.message.from == _auth.currentUser!.displayName
                        ? Color(0xffD3E4CD)
                        : Color(0xff99A799))),
            widget.message.reactions.isNotEmpty
                ? Positioned(
                  bottom: -12,
                    child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: Text(widget.message.reactions[0],style: TextStyle(fontSize: 13),),
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
    );
  }
}
