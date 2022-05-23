import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './utils/story_bars.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  TransformationController controller = TransformationController();
  final List<Widget> myStories = [
    StoryView(
        storyImage:
            "https://www.kindacode.com/wp-content/uploads/2020/11/Screen-Shot-2020-11-25-at-20.42.21.jpg"),
    StoryView(
        storyImage:
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2014%2F01%2F347642%2Cxcitefun-amazing-photographs-from-national-geogra.jpg&f=1&nofb=1"),
    StoryView(
        storyImage:
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.S6VHLLTVQNoJS8d_IeG3xwHaHa%26pid%3DApi&f=1"),
    Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Center(child: Text("4")),
    ),
    Scaffold(
      backgroundColor: Colors.green[200],
      body: Center(child: Text("5")),
    ),
  ];

  List<double> percentWatched = [];
  @override
  void initState() {
    super.initState();

    // initially, all stories haven't been watched yet
    for (int i = 0; i < myStories.length; i++) {
      percentWatched.add(0);
    }

    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      setState(() {
        // only add 0.01 as long as it's below 1
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        }
        // if adding 0.01 exceeds 1, set percentage to 1 and cancel timer
        else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();

          // also go to next story as long as there are more stories to go through
          if (currentStoryIndex < myStories.length - 1) {
            currentStoryIndex++;
            // restart story timer
            _startWatching();
          }
          // if we are finishing the last story then return to homepage
          else {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    // user taps on first half of screen
    if (dx < screenWidth / 2) {
      setState(() {
        // as long as this isnt the first story
        if (currentStoryIndex > 0) {
          // set previous and curent story watched percentage back to 0
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;

          // go to previous story
          currentStoryIndex--;
        }
      });
    }
    // user taps on second half of screen
    else {
      setState(() {
        // if there are more stories left
        if (currentStoryIndex < myStories.length - 1) {
          // finish current story
          percentWatched[currentStoryIndex] = 1;
          // move to next story
          currentStoryIndex++;
        }
        // if user is on the last story, finish this story
        else {
          percentWatched[currentStoryIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      child: Stack(children: [
        // story
        myStories[currentStoryIndex],

        // progress bar
        MyStoryBars(
          percentWatched: percentWatched,
          storiescount: myStories.length,
        ),
        Positioned(
          top: 75,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            //color: Colors.blue[100],
            child: Row(
              children:const [
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  radius: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Justin Bieber",
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class StoryView extends StatefulWidget {
  final String storyImage;
  const StoryView({
    Key? key,
    required this.storyImage,
  }) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  TransformationController controller = TransformationController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: InteractiveViewer(
        transformationController: controller,
        onInteractionEnd: (ScaleEndDetails endDetails) {
          controller.value = Matrix4.identity();
        },
        child: Center(
          child: Image.network(
            widget.storyImage,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
