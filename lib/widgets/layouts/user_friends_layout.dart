import 'package:chatapp/models/search_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserFriendListLayout extends StatefulWidget {
  const UserFriendListLayout({ Key? key }) : super(key: key);

  @override
  _UserFriendListLayoutState createState() => _UserFriendListLayoutState();
}

class _UserFriendListLayoutState extends State<UserFriendListLayout> {
  @override
  Widget build(BuildContext context) {
   List<SearchUser> _userList = Provider.of<List<SearchUser>>(context);
    return Container(
      
    );
  }
}