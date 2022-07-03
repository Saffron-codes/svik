import 'package:chatapp/models/story_model.dart';
import 'package:chatapp/pages/story/view/story_page.dart';
import 'package:flutter/material.dart';

class StoriesPage extends StatefulWidget {
  final  routedata;
  const StoriesPage({ Key? key, required this.routedata }) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {

  @override
  void initState() {
    super.initState();
    print(widget.routedata);
  }
  @override
  Widget build(BuildContext context) {
    List<Story> _userStories = widget.routedata["stories"];
    List<String> _profiles = widget.routedata["profiles"];
    PageController _storiespageController = PageController(initialPage: widget.routedata["initialPageIndex"]);
    return PageView.builder(
      controller: _storiespageController,
      itemCount: _userStories.length,
      itemBuilder:(context,index){
        return StoryPage(story: _userStories[index],profile: _profiles[index],);
      },
    );
  }
}