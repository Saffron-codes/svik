import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/widgets/layouts/search_user_tile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/friend_model.dart';
import '../../services/firebase_services/firestore_services.dart';

class UserFriendsList extends StatefulWidget {
  final List<AppUser> users;
  const UserFriendsList({Key? key, required this.users}) : super(key: key);

  @override
  State<UserFriendsList> createState() => _UserFriendsListState();
}

class _UserFriendsListState extends State<UserFriendsList> {
  @override
  Widget build(BuildContext context) {
    final _users = widget.users;
    final _userFrds = Provider.of<List<AppUser>>(context);
    final _commonFrds = _users.toSet().intersection(_userFrds.toSet()).toList();
    return _users.isNotEmpty?
    ListView.separated(
      shrinkWrap: true,
      itemCount: _users.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(12),
      separatorBuilder: (context, index) => Divider(
        height: 6,
      ),
      itemBuilder: (ctx, idx) {
        bool _isfrd = false;
        for (var item in _userFrds) {
          if(_users[idx].uid==item.uid){
            _isfrd = true;
          }
          // print(item);
        }
        return SearchUserTile(user: _users[idx], isfriendalready: _isfrd);
      },
    ):
    Center(
      child: CircularProgressIndicator(),
    );
    //   return StreamBuilder<List<AppUser>>(
    //     stream: _users,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Center(
    //           child: Icon(Icons.refresh),
    //         );
    //       }
    //       if (snapshot.connectionState == ConnectionState.waiting &&) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }

    //       // return StreamBuilder<List<AppUser>>(
    //       //     stream: _userFriends,
    //       //     builder: (context, snapshot1) {
    //       //       List<AppUser> _users = snapshot.data!;
    //       //       List<AppUser> _friends = snapshot1.data!;
    //       //       List<AppUser> _finalUsers = [];

    //       //       _finalUsers =
    //       //           _users.toSet().intersection(_friends.toSet()).toList();

    //       //       if (snapshot.hasError && snapshot1.hasError) {
    //       //         return Center(
    //       //           child: Icon(Icons.refresh),
    //       //         );
    //       //       }
    //       //       if (snapshot.connectionState == ConnectionState.waiting &&
    //       //           snapshot1.connectionState == ConnectionState.waiting) {
    //       //         return Center(
    //       //           child: CircularProgressIndicator(),
    //       //         );
    //       //       }
    //       //       return ListView.separated(
    //       //         shrinkWrap: true,
    //       //         itemCount: _users.length,
    //       //         physics: BouncingScrollPhysics(),
    //       //         padding: EdgeInsets.all(12),
    //       //         separatorBuilder: (context, index) => Divider(
    //       //           height: 6,
    //       //         ),
    //       //         itemBuilder: (ctx, idx) {
    //       //           return SearchUserTile(
    //       //               user: _users[idx], isfriendalready: true);
    //       //         },
    //       //       );
    //       //     });
    //     },
    //   );
    // }
  }

  // return Consumer<FirestoreServices>(
  //   builder: (context, value, child) => StreamBuilder(
  //       stream: value.getFriendsList(widget.uid),
  //       builder: (context, AsyncSnapshot<List<Friend>> friends) {
  //         if (friends.connectionState == ConnectionState.active) {
  //           return ListView.separated(
  //             itemCount: friends.data!.length,
  //             physics: BouncingScrollPhysics(),
  //             padding: EdgeInsets.all(12),
  //             separatorBuilder: (context, index) => Divider(
  //               height: 6,
  //             ),
  //             itemBuilder: (context, index) {
  //               // for (var user in _userList) {
  //               //   for (var friend in users.data!) {
  //               //     if (user.uid == friend.uid) {
  //               //       return Text("Friend");
  //               //     }
  //               //   }
  //               // }
  //               return Text("Nothing");
  //               // return SearchUserTile(
  //               //   user: users.data![index],
  //               //   isfriendalready: true,
  //               // );
  //             },
  //           );
  //         } else if (friends.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(
  //               color: Colors.grey[600],
  //             ),
  //           );
  //         }
  //         return Center(
  //           child: CircularProgressIndicator(
  //             color: Colors.grey[600],
  //           ),
  //         );
  //       }),
  // );

}
