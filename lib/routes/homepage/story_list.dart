import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/story.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryListWidget extends StatefulWidget {
  const StoryListWidget({Key? key}) : super(key: key);

  @override
  _StoryListWidgetState createState() => _StoryListWidgetState();
}

class _StoryListWidgetState extends State<StoryListWidget> {
  
  @override
  Widget build(BuildContext context) {
    List<Story> _stories = [];
    List<Friend> friendlist = Provider.of<List<Friend>>(context);
    List<Story> storylist = Provider.of<List<Story>>(context);
    List<String> profiles = [];
    for(var story in storylist){
      for(var friend in friendlist){
        if(story.name == friend.name){
          setState(() {
            profiles.add(friend.photourl);
            _stories.add(story);
          });
        }
      }
    }
    // storylist.map((story){
    //   print(story.name == friendlist[0].name);
    // });
    return ListView.separated(
      padding: EdgeInsets.only(left: 5),
      shrinkWrap: true,
      separatorBuilder: (_, idx) => SizedBox(
        width: 10,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: _stories.length,
      itemBuilder: (_, idx) {
        return GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/view_story",arguments: {"stories":_stories,"profiles":profiles});
          },
          child: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(profiles[idx]),
            
          ),
        );
      },
    );
  }
}
