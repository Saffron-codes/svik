import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class addButton extends StatefulWidget {
  final bool isFriend;
  const addButton({Key? key, required this.isFriend}) : super(key: key);

  @override
  _addButtonState createState() => _addButtonState();
}

class _addButtonState extends State<addButton> {
  @override
  Widget build(BuildContext context) {
    DataProgress friendLoad = Provider.of<DataProgress>(context);
    print(friendLoad);
    if(friendLoad == DataProgress.done){
    return IconButton(
      color: themeWhiteColor,
      onPressed: () {},
      icon: Icon(Icons.person_remove)
    );
    }
    else if(friendLoad == DataProgress.loading){
      return Icon(
       Icons.sync_outlined,
       color: themeWhiteColor,
      );
    }
    else if(friendLoad == DataProgress.none){
      return Icon(
       Icons.person_add,
       color: themeWhiteColor,
      );
    }
     return Icon(
       Icons.sync_outlined,
       color: themeWhiteColor,
      );
  }
}
