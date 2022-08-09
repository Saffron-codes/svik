import 'dart:io';
import 'dart:developer';
import 'package:chatapp/config/toast/app_toast.dart';
import 'package:chatapp/pages/chat/widgets/chat_text_field.dart';
import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:chatapp/services/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/chat_settings.dart';
import 'widgets/message_list.dart';

class ChatPage extends StatefulWidget {
  final String chatroomid;
  final Friend friend;
  const ChatPage({Key? key, required this.chatroomid, required this.friend})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String isfriend = "loading";
  bool isShowSticker = false;
  final FocusNode _focusNode = FocusNode();
  // late Future<bool> friend_load;
  @override
  void initState() {
    // friend_load = FirestoreServices().checkbothfriends(widget.friend.uid, context);
    super.initState();
  }

  void toggleEmoji() {
    if (isShowSticker) {
      _focusNode.requestFocus();
      setState(() {
        isShowSticker = false;
      });
    } else {
      _focusNode.unfocus();
      setState(() {
        isShowSticker = true;
      });
    }
  }

  void showChatDetailSHeet() {
    final chatProvider = Provider.of<ChatPageProvider>(context, listen: false);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => ChatDetailsPage(providerModel: chatProvider,));
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Message>>.value(
      value: FirestoreServices().getmessages(widget.chatroomid),
      initialData: [],
      child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromRGBO(48, 49, 54, 1),
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      CupertinoButton(
                          onPressed: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: Color(0xffD8D8D8),
                          )),
                      // SizedBox(
                      //   width: 2,
                      // ),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(widget.friend.photourl),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.friend.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffD8D8D8)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Online",
                              style: TextStyle(
                                  color: Color(0xffA3A0AC), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          showChatDetailSHeet();
                        },
                        padding: EdgeInsets.zero,
                        child: Icon(
                          EvaIcons.moreHorizontalOutline,
                          color: Color(0xffD8D8D8),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: Consumer<ChatPageProvider>(
              builder: (context, providerModel, child) {
                TextEditingController _messagecontroller =
                    TextEditingController(text: providerModel.getmessage);

                return Column(
                  children: [
                    Expanded(
                      child: MessageList(
                        friend: widget.friend,
                        chatroomid: widget.chatroomid,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            children: [
                              Flexible(
                                child: ChatTextField(
                                  messagecontroller: _messagecontroller,
                                  focusNode: providerModel.getFoucsNode,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.only(left: 10),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xff0150FA),
                                  child: Icon(EvaIcons.navigation2),
                                ),
                                onPressed: () {
                                  if (_messagecontroller.text.isNotEmpty) {
                                    log(providerModel.getEditState.toString());
                                    if (!providerModel.getEditState) {
                                      FirestoreServices().sendmessage(
                                        Message(
                                          _messagecontroller.text,
                                          _auth.currentUser!.uid.toString(),
                                          Timestamp.now(),
                                          "text",
                                          "",
                                          "",
                                        ),
                                        widget.chatroomid,
                                        widget.friend.uid,
                                      );
                                    } else {
                                      // Logger().i(providerModel.messageId);
                                      FirestoreServices().editMessage(
                                          context,
                                          widget.chatroomid,
                                          providerModel.messageId,
                                          _messagecontroller.text);
                                      ToastHelper()
                                          .infoToast("Updated message");
                                    }
                                    _messagecontroller.text = "";
                                    providerModel.setmessage = "";
                                    providerModel.changeEditState(false, "");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        providerModel.isEmojiOpen
                            ? SizedBox(
                                height: 310,
                                child: EmojiPicker(
                                  config: Config(
                                    columns: 7,
                                    emojiSizeMax: 32 *
                                        (Platform.isIOS
                                            ? 1.30
                                            : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    gridPadding: EdgeInsets.zero,
                                    initCategory: Category.RECENT,
                                    bgColor: Color(0xFFF2F2F2),
                                    indicatorColor: Colors.blue,
                                    iconColor: Colors.grey,
                                    iconColorSelected: Colors.blue,
                                    progressIndicatorColor: Colors.blue,
                                    backspaceColor: Colors.blue,
                                    skinToneDialogBgColor: Colors.white,
                                    skinToneIndicatorColor: Colors.grey,
                                    enableSkinTones: true,
                                    showRecentsTab: true,
                                    recentsLimit: 28,
                                    noRecents: const Text(
                                      'No Recents',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black26),
                                      textAlign: TextAlign.center,
                                    ),
                                    tabIndicatorAnimDuration:
                                        kTabScrollDuration,
                                    categoryIcons: const CategoryIcons(),
                                    buttonMode: ButtonMode.MATERIAL,
                                  ),
                                  onBackspacePressed: () {
                                    _messagecontroller.text =
                                        _messagecontroller.text.substring(0,
                                            _messagecontroller.text.length - 1);
                                  },
                                  onEmojiSelected: (category, emoji) {
                                    _messagecontroller.text += emoji.emoji;
                                  },
                                ),
                              )
                            : SizedBox()
                      ],
                    )
                  ],
                );
              },
            ),
          )
    );
  }
}
