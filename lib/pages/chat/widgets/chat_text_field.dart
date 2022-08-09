import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController messagecontroller;
  final FocusNode focusNode;
  const ChatTextField(
      {Key? key, required this.messagecontroller, required this.focusNode})
      : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatPageProvider>(builder: (context, providerModel, child) {
      return SizedBox(
        height: 46,
        child: TextField(
          //autofocus: true,
          cursorColor: Colors.white,
          controller: widget.messagecontroller,
          focusNode: widget.focusNode,
          style: TextStyle(
            color: Colors.white,
          ),
          textInputAction: TextInputAction.send,
          decoration: InputDecoration(
            // isCollapsed: true,
            contentPadding: EdgeInsets.all(10),
            filled: true,
            fillColor: Color(0xFF31333a),
            hintText: "Write message...",
            hintStyle: TextStyle(color: Color(0xffA3A0AC)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Color(0xff202225)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Color(0xff202225)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Color(0xff202225)),
            ),
            prefixIcon: providerModel.getState
                ? CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Icon(
                      Icons.keyboard,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      widget.focusNode.requestFocus();
                      providerModel.toggleEmoji = !providerModel.getState;
                      // toggleEmoji();
                    },
                  )
                : CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      widget.focusNode.unfocus();
                      providerModel.toggleEmoji = !providerModel.getState;
                      // toggleEmoji();
                    },
                  ),
          ),
        ),
      );
    });
  }
}
