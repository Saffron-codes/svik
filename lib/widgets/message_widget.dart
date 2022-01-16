import 'package:chatapp/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MessageWidget extends StatefulWidget {
  final Message message;
  const MessageWidget({ Key? key, required this.message }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: widget.message.from != _auth.currentUser!.displayName?Alignment.topLeft:Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.message.from == _auth.currentUser!.displayName?Color(0xffD3E4CD):Color(0xff99A799)
          ),
          child: Text(widget.message.message)
        ),
      ),
    );
  }
}