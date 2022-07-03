import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/providers/theme_provider/theme_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/story_model.dart';
import '../utils/story_bars.dart';

class StoryPage extends StatefulWidget {
  final Story story;
  final String profile;
  const StoryPage({Key? key, required this.story, required this.profile})
      : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  TransformationController controller = TransformationController();
  List<Widget> SubStories = [
    // StoryView(
    //     storyImage:
    //         "https://www.kindacode.com/wp-content/uploads/2020/11/Screen-Shot-2020-11-25-at-20.42.21.jpg"),
    // StoryView(
    //     storyImage:
    //         "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2014%2F01%2F347642%2Cxcitefun-amazing-photographs-from-national-geogra.jpg&f=1&nofb=1"),
    // StoryView(
    //     storyImage:
    //         "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.S6VHLLTVQNoJS8d_IeG3xwHaHa%26pid%3DApi&f=1"),
    // Scaffold(
    //   backgroundColor: Colors.blueGrey[200],
    //   body: Center(child: Text("4")),
    // ),
    // Scaffold(
    //   backgroundColor: Colors.green[200],
    //   body: Center(child: Text("5")),
    // ),
  ];

  List<double> percentWatched = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      for (var item in widget.story.url) {
        SubStories.add(StoryView(storyImage: item));
      }
    });
    // initially, all stories haven't been watched yet
    for (int i = 0; i < SubStories.length; i++) {
      percentWatched.add(0);
    }

    _startWatching();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      setState(() {
        // only add 0.01 as long as it's below 1
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.0025;
        }
        // if adding 0.01 exceeds 1, set percentage to 1 and cancel timer
        else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();

          // also go to next story as long as there are more stories to go through
          if (currentStoryIndex < SubStories.length - 1) {
            currentStoryIndex++;
            // restart story timer
            _startWatching();
          }
          // if we are finishing the last story then return to homepage
          else {
            //Navigator.pop(context);
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
        if (currentStoryIndex < SubStories.length - 1) {
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
      child: Consumer<ThemeModel>(builder: (context, themeNotifier, child) {
        return Stack(
          children: [
          Container(
            color: themeNotifier.isDark ? Colors.black : Colors.white,
          ),
          // story
          Positioned(
            child: SubStories[currentStoryIndex],
          ),

          // progress bar
          MyStoryBars(
            percentWatched: percentWatched,
            storiescount: SubStories.length,
          ),
          Positioned(
            top: 75,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              //color: Colors.blue[100],
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.profile),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Text(
                  //   widget.story.name,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     decoration: TextDecoration.none,
                  //   ),
                  // ),
                  Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        // The text border
                        Text(
                          widget.story.name,
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.5
                              ..color = Color(0xff141E29),
                          ),
                        ),
                        // The text inside
                        Text(
                          widget.story.name,
                          style: TextStyle(
                            fontSize: 17,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]);
      }),
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
            child: CachedNetworkImage(
          imageUrl: widget.storyImage,
          progressIndicatorBuilder: (context, n, progress) {
            return Center(
                child: Container(
                    width: 80,
                    child: LinearProgressIndicator(
                      value: progress.progress,
                    )));
          },
        )),
      ),
    );
  }
}
