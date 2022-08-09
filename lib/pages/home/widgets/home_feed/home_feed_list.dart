import 'package:chatapp/providers/feed_provider/feed_provider.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'post_widget.dart';

class HomeFeedList extends StatefulWidget {
  final FeedProvider feedProvider;
  const HomeFeedList({Key? key, required this.feedProvider}) : super(key: key);

  @override
  State<HomeFeedList> createState() => _HomeFeedListState();
}

class _HomeFeedListState extends State<HomeFeedList> {
  ScrollController feedcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    // feedcontroller.addListener(listenscroll);s
    widget.feedProvider.fetchPosts();
  }

  @override
  void dispose() {
    feedcontroller.dispose();
    super.dispose();
  }

  void listenscroll() {
    feedcontroller.addListener(() {
      // if (feedcontroller.offset >= feedcontroller.position.maxScrollExtent &&
      //     !feedcontroller.position.outOfRange) {
      //     widget.feedProvider.fetchNextPosts();
      // }
      if (feedcontroller.hasClients) {
        feedcontroller.animateTo(feedcontroller.position.maxScrollExtent,
            duration: Duration(microseconds: 1), curve: Curves.fastOutSlowIn);
      } else {
        //Timer(Duration(milliseconds: 400), () => _scrollToBottom());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => listenscroll());
    final feedProvider = Provider.of<FeedProvider>(context);
    return ListView(
      controller: feedcontroller,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        ...feedProvider.posts.map((post) {
          // Logger().i(post);
          return PostWidget(
              userId: post["userid"],
              postId: post["postid"],
              feedProvider: feedProvider);
        }),
        feedProvider.hasNext
            ? Center(
                child: GestureDetector(
                  onTap: feedProvider.fetchNextPosts,
                  child: feedProvider.isFecthingPosts
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child:
                              CircularProgressIndicator(color: Colors.white30),
                        )
                      : Icon(
                          EvaIcons.plusCircleOutline,
                          color: Colors.white30,
                          size: 34,
                        ),
                ),
              )
            : Center(
                child: Icon(
                EvaIcons.personDoneOutline,
                color: Colors.white30,
                size: 34,
              ))
      ],
    );
  }
}
