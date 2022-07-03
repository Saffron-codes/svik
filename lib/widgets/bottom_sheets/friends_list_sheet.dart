import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/widgets/layouts/user_friends_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future showFriendsSheet(BuildContext context, List<Friend> friends) {
  double screenHeight = MediaQuery.of(context).size.height;
   List<SearchUser> _userList = Provider.of<List<SearchUser>>(context);
   List<Friend> _friendList = [];
   for(var user in _userList){
     for(var friend in friends){
       if(user.uid == friend.uid){
         _friendList.add(
           Friend(friend.added, user.name, user.photourl, friend.lastmessage, friend.lastmessagetime, user.keywords, user.uid)
         );
       }
     }
   }
  //print(screenHeight/1000-(friends.length/10));
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: _friendList.length/10>1?0.9:friends.length/14.5,
        builder: (context, scrollController) {
          return UserFriendListLayout();
          // return ListView(
          //   physics: const NeverScrollableScrollPhysics(),
          //   controller: scrollController,
          //   children: [
          //     SizedBox(
          //       height: 10,
          //     ),
          //     // Padding(
          //     //   padding: const EdgeInsets.symmetric(horizontal: 170),
          //     //   child: Container(
          //     //     color: Colors.grey,
          //     //     height: 3,
          //     //     width: 10,
          //     //   ),
          //     // ),
          //     Center(
          //       child: Container(
          //         color: Colors.grey,
          //         height: 3,
          //         width: 35,
          //       ),
          //     ),
          //     SizedBox(
          //       height: 10,
          //     ),
          //     Center(
          //       child: Text(
          //         "Friends",
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
          //       ),
          //     ),
          //     // Padding(
          //     //   padding: const EdgeInsets.symmetric(horizontal: 168),
          //     //   child: Text(
          //     //     "Friends",
          //     //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
          //     //   ),
          //     // ),
          //     ListView.builder(
          //       shrinkWrap: true,
          //       physics: BouncingScrollPhysics(),
          //       controller: scrollController,
          //       itemCount: _friendList.length,
          //       itemBuilder: (context, index) => ListTile(
          //         onTap: () => print(_friendList.length.toDouble() / 10),
          //         title: Text(_friendList[index].name,style: chatTextName,),
          //         // leading: CircleAvatar(
          //         //   backgroundImage: NetworkImage(friends[index].photourl),
          //         // ),
          //         leading: ClipRRect(
          //           borderRadius: BorderRadius.all(Radius.circular(100)),
          //           child: Image.network(
          //             _friendList[index].photourl,
          //             loadingBuilder: (context, child, loadingProgress) {
          //               if (loadingProgress == null) return child;
          //               return CircleAvatar(
          //                 backgroundColor: Colors.grey,
          //               );
          //             },
          //             errorBuilder: (context, error, stackTrace) {
          //               return CircleAvatar(
          //                 backgroundColor: Colors.white,
          //               );
          //             },
          //             width: 30,
          //             height: 30,
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // );
        },
      );
    },
  );
}
