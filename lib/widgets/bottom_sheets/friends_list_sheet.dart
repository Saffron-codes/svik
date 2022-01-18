import 'package:chatapp/models/friend_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showFriendsSheet(BuildContext context,List<Friend> friends){
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
  builder:(context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: friends.length.toDouble()<10?friends.length.toDouble()/10:0.9,
      builder:(context, scrollController) {
        return ListView.builder(
          shrinkWrap: true,
          controller: scrollController,
          itemCount: friends.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () => print(friends.length.toDouble()/10),
            title: Text(friends[index].name),
            leading: CircleAvatar(backgroundImage: NetworkImage(friends[index].photourl),),
          ),
        );
      },
    );
  },);
}