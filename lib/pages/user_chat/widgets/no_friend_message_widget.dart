import 'package:chatapp/config/pallete.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoFriendWidget extends StatefulWidget {
  const NoFriendWidget({Key? key}) : super(key: key);

  @override
  State<NoFriendWidget> createState() => _NoFriendWidgetState();
}

class _NoFriendWidgetState extends State<NoFriendWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Text("Welcome to Chat",
            style: TextStyle(
                color: Palette.kToLight.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 36)),
        SizedBox(height: 30),
        Text(
          "Add a friend to Start one..",
          style: TextStyle(color: Palette.kToLight.shade500, fontSize: 18),
        ),
        SizedBox(height: 30),
        CupertinoButton(
          child: Text("Add now",style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () {},
          color: ThemeConstants().themeBlueColor,
          padding: EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(26),
        )
      ],
    );
  }
}
