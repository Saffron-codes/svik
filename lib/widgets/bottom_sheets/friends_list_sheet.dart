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
      builder:(context, scrollController) {
        return ListView.builder(
          controller: scrollController,
          itemCount: friends.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(friends[index].name),
            leading: CircleAvatar(backgroundImage: NetworkImage(friends[index].photourl),),
          ),
        );
      },
    );
  },);
}