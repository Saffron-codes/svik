import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/models/story_model.dart';
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
    List<SearchUser> _userlist = Provider.of<List<SearchUser>>(context);

    // for (var user in _userlist) {
    //   for(var friend in friendlist){
    //     if(user.uid == friend.uid){
    //       for(var story in storylist){
    //         setState(() {
    //           if(story.uid == friend.uid){
    //               _stories.add(
    //                 Story(story.url, story.time, user.name, story.uid)
    //               );
    //               profiles.add(user.photourl);
    //           }
    //         });
    //       }
    //     }
    //   }
    // }
    for (var story in storylist) {
      for (var friend in friendlist) {
        for (var user in _userlist) {
          if (story.uid == friend.uid && user.uid == friend.uid) {
            setState(() {
              profiles.add(user.photourl);
              _stories.add(Story(story.url, story.time, user.name, story.uid));
            });
          }
        }
      }
    }
    // storylist.map((story){
    //   print(story.name == friendlist[0].name);
    // });
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 5),
      shrinkWrap: true,
      separatorBuilder: (_, idx) => SizedBox(
        width: 6,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: _stories.length,
      itemBuilder: (_, idx) {
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/view_story", arguments: {
                "stories": _stories,
                "profiles": profiles,
                "initialPageIndex": idx
              });
            },
            child: SizedBox(
              //color: Colors.blueGrey,
              height: 120,
              width: 66,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: profiles[idx],
                    imageBuilder: (context, imageProvider) => Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    placeholder: (context, str) => Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey[600]),
                    ),
                  ),
                  _stories[idx].name.length < 9
                      ? Text(
                          _stories[idx].name,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      : Text(
                          "${_stories[idx].name.substring(0, 7)}..",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                ],
              ),
            ));
      },
    );
  }
}
