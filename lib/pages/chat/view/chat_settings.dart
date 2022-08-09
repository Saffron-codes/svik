import 'package:chatapp/pages/chat/widgets/add_reactions/choose_emoji_sheet.dart';
import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatDetailsPage extends StatefulWidget {
  final ChatPageProvider providerModel;
  const ChatDetailsPage({Key? key, required this.providerModel}) : super(key: key);

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {

  @override
  void initState() {
    widget.providerModel.getfavEmoji();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chat Settings",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold,fontSize: 20),),
          SizedBox(height: 10,),
          // Text("Reactions",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.w400,fontSize: 16),),
          CupertinoButton(
            onPressed: () {
              widget.providerModel.changeChooseEmojiState=true;
              showModalBottomSheet(context: context, builder: (context)=>ChooseEmojiWidget(providerModel: widget.providerModel,));
            },
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Custom Reaction",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.w400,fontSize: 16),),
                  Consumer<ChatPageProvider>(
                    builder: (context,value,child) {
                      return CircleAvatar(
                        radius: 16,
                        child: Text(value.favEmoji),
                        backgroundColor: Colors.grey[850],
                      );
                    }
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}