import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class ChooseEmojiWidget extends StatefulWidget {
  final ChatPageProvider providerModel;
  const ChooseEmojiWidget({Key? key, required this.providerModel}) : super(key: key);

  @override
  State<ChooseEmojiWidget> createState() => _ChooseEmojiWidgetState();
}

class _ChooseEmojiWidgetState extends State<ChooseEmojiWidget> {
  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {},
      customWidget: (config, state) => CustomView(config, state,widget.providerModel),
    );
  }
}

class CustomView extends EmojiPickerBuilder {
  final ChatPageProvider  chatprovider;
  CustomView(Config config, EmojiViewState state, this.chatprovider) : super(config, state);

  @override
  _CustomViewState createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.state.categoryEmoji.length,
        itemBuilder: (context, categoryIndex) {
          return EmojiCategoryWidget(state: widget.state,categoryIndex: categoryIndex, chatprovider: widget.chatprovider,);
        },
      ),
    );
  }
}

class EmojiCategoryWidget extends StatefulWidget {
  const EmojiCategoryWidget({
    foundation.Key? key,
    required this.state,required this.categoryIndex, required this.chatprovider,
  }) : super(key: key);

  final EmojiViewState state;
  final int categoryIndex;
  final ChatPageProvider  chatprovider;


  @override
  State<EmojiCategoryWidget> createState() => _EmojiCategoryWidgetState();
}

class _EmojiCategoryWidgetState extends State<EmojiCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.state.categoryEmoji[widget.categoryIndex + 1].category.name,style: TextStyle(color: Colors.grey[500],fontSize: 20,fontWeight: FontWeight.w700),),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 40,
              childAspectRatio: 0.5,
              crossAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            itemCount:
                widget.state.categoryEmoji[widget.categoryIndex + 1].emoji.length,
            itemBuilder: (context, emojiIndex) {
              String emoji = widget.state.categoryEmoji[widget.categoryIndex + 1]
                        .emoji[emojiIndex].emoji;
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  widget.chatprovider.getChooseState?
                  widget.chatprovider.setfavEmoji(emoji):null;
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                    child: Text(widget.state.categoryEmoji[widget.categoryIndex + 1]
                        .emoji[emojiIndex].emoji)
                    // child: Text(widget.state.categoryEmoji[0].emoji[index].emoji),
                    ),
              );
            },
          )
        ],
      ),
    );
  }
}
