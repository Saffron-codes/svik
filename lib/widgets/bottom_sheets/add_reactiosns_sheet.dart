import 'package:chatapp/services/firebase_services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future addReaction(BuildContext context, String id,String chatroomid) {
  List<String> _emojis = [
    '😀',
    '😊',
    '🤣',
    '😁',
    '🤩',
    '😛',
    '🤪',
    '🤫',
    '😴',
    '🥳',
    '💖','💔','💓','❤️','✨','👍','🎉'
  ];
  print(id);
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 50,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _emojis.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: ()async{
                      FirestoreServices().addReactions(chatroomid, id, _emojis[index]).then((value) => Navigator.pop(context));
                      
                    },
                      child: Text(
                    _emojis[index],
                    style: TextStyle(fontSize: 30),
                  )),
                ),
              )
            ],
          ),
        );
      });
}
