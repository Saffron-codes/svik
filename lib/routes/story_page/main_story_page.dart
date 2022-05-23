import 'dart:async';
import 'dart:ui';

import 'package:chatapp/models/story_model.dart';
import 'package:chatapp/story_provider/story_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  void pop_route() {
    Navigator.pop(context);
  }

  initiateRoute() {
    var duration = Duration(seconds: 3);
    return Timer(duration, pop_route);
  }

  @override
  void initState() {
    //initiateRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final story_provider = context.read<StoryProvider>();
    final arguemnts = ModalRoute.of(context)!.settings.arguments as Map;
    Story story = arguemnts["story"];
    String _profile = arguemnts["profile"];
    story_provider.progress = 0;
    story_provider.startTimer(context);
    return Consumer<StoryProvider>(builder: (context, storyprovider, child) {
      return Material(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(story.url), fit: BoxFit.cover)),
            ),
            Positioned(
              top: 35,
              right: 10,
              child: CircularProgressIndicator(
                value: storyprovider.progress,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
            Positioned(
              top: 30,
              left: 15,
              child: CircleAvatar(radius: 25,backgroundImage: NetworkImage(_profile),),
            ),
            Positioned(
              top: 45,
              left: 85,
              child: Text(story.name,style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          ],
        ),
      );
    });
  }
}
