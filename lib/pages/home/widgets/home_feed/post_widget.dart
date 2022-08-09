import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/pages/home/widgets/home_feed/post_widget_loader_shimmer.dart';
import 'package:chatapp/providers/feed_provider/feed_provider.dart';
import 'package:chatapp/providers/feed_provider/models/post.dart';
import 'package:chatapp/services/firebase_services/feed_service/feed_service.dart';
import 'package:chatapp/utils/convert_to_ago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  final String userId;
  final String postId;
  final FeedProvider feedProvider;
  const PostWidget(
      {Key? key,
      required this.userId,
      required this.postId,
      required this.feedProvider})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with AutomaticKeepAliveClientMixin<PostWidget> {
  final TextStyle _userNameStyleDark = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white70);

  final TextStyle _countStyleDark =
      TextStyle(fontSize: 16, color: Colors.white70);

  final TextStyle _postTimeStyleDark =
      TextStyle(fontSize: 14, color: Colors.white38);

  final TextStyle _postDesStyleDark =
      TextStyle(fontSize: 13, color: Colors.white38);
  // Map<String, Map<String, dynamic>?> _postDetails = {};
  late Future<dynamic> getPosts;

  getPost() async {
    setState(() {
      getPosts = widget.feedProvider.getPost(widget.userId, widget.postId);
      // getPosts = widget.feedProvider.getPostDetails(widget.userId, widget.postId);
    });
    // Logger().i(_postDetails.entries);
  }

  @override
  void initState() {
    getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    return StreamBuilder<AppUser>(
        stream: FeedService().getPostUser(widget.userId),
        builder: (context, AsyncSnapshot<AppUser> userSnapshot) {
          return StreamBuilder<Post>(
            stream: FeedService().getPost(widget.userId, widget.postId),
            builder: (context, AsyncSnapshot<Post> postSnapshot) {
              final userData = userSnapshot.data;
              final postData = postSnapshot.data;
              if (!userSnapshot.hasData || !postSnapshot.hasData) {
                return PostWidgetShimmer();
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/post', arguments: {
                      "user": userSnapshot.data,
                      "post": postSnapshot.data
                    });
                    //Logger().i("Cliked post");
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    color: Color.fromARGB(50, 48, 48, 48),
                    child: Container(
                      // height: 300,
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: CachedNetworkImageProvider(
                                    userData!.profile),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                userData.name,
                                style: _userNameStyleDark,
                              ),
                              Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  EvaIcons.moreHorizontal,
                                  color: Colors.white70,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profile_picture',
                                    arguments: postData!.posturl);
                              },
                              child: Hero(
                                tag: postData!.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    postData.posturl,
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width*80/100,
                                    height: MediaQuery.of(context).size.height *
                                        60 /
                                        100,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        heightFactor: 4,
                                        child: CircularProgressIndicator(
                                          color: Colors.white30,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, obj, st) {
                                      return Center(
                                        child: Icon(
                                          EvaIcons.refresh,
                                          color: Colors.white30,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.only(left: 0),
                                child: Icon(
                                  EvaIcons.heartOutline,
                                  color: Colors.white70,
                                  size: 26,
                                ),
                                onPressed: () {},
                              ),
                              Text(
                                postData.like.toString(),
                                style: _countStyleDark,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  EvaIcons.messageCircleOutline,
                                  color: Colors.white70,
                                  size: 26,
                                ),
                                onPressed: () {},
                              ),
                              Text(
                                "300",
                                style: _countStyleDark,
                              ),
                              Spacer(),
                              Text(
                                convertToAgo(
                                    (postData.time).toDate(), DateTime.now()),
                                style: _postTimeStyleDark,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              postData.caption,
                              style: _postDesStyleDark,
                            ),
                          )
                        ],
                      ),
                      // width: 50,
                    ),
                  ),
                );
              }
            },
          );
          // return StreamBuilder(
          //     stream: FeedService().getPost(widget.userId, widget.postId),
          //     builder: (context, AsyncSnapshot snapshot) {
          //       // Logger().i(snapshot.connectionState);
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasError) {
          //           return Card(
          //             margin: EdgeInsets.all(10),
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(28)),
          //             color: Color.fromARGB(49, 237, 80, 80),
          //             child: Container(
          //               height: 300,
          //             ),
          //           );
          //         } else if (snapshot.hasData) {

          //           return Card(
          //             margin: EdgeInsets.all(10),
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(28)),
          //             color: Color.fromARGB(50, 48, 48, 48),
          //             child: Container(
          //               // height: 300,
          //               padding: EdgeInsets.all(18),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Row(
          //                     children: [
          //                       CircleAvatar(
          //                         radius: 14,
          //                         backgroundImage: CachedNetworkImageProvider(
          //                             _postDetails["user"]!["photourl"]),
          //                       ),
          //                       SizedBox(
          //                         width: 10,
          //                       ),
          //                       Text(
          //                         _postDetails["user"]!["name"],
          //                         style: _userNameStyleDark,
          //                       ),
          //                       Spacer(),
          //                       CupertinoButton(
          //                         padding: EdgeInsets.zero,
          //                         child: Icon(
          //                           EvaIcons.moreHorizontal,
          //                           color: Colors.white70,
          //                         ),
          //                         onPressed: () {},
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(
          //                     height: 10,
          //                   ),
          //                   Center(
          //                     child: ClipRRect(
          //                       borderRadius: BorderRadius.circular(28.0),
          //                       child: GestureDetector(
          //                         onTap: () {
          //                           Navigator.pushNamed(
          //                               context, '/profile_picture',
          //                               arguments:
          //                                   _postDetails["post"]!["post_url"]);
          //                         },
          //                         child: Image.network(
          //                           _postDetails["post"]!["post_url"],
          //                           height: 400,
          //                           loadingBuilder:
          //                               (context, child, loadingProgress) {
          //                             if (loadingProgress == null) return child;
          //                             return Center(
          //                               heightFactor: 4,
          //                               child: CircularProgressIndicator(
          //                                 color: Colors.white30,
          //                               ),
          //                             );
          //                           },
          //                           errorBuilder: (context, obj, st) {
          //                             return Center(
          //                               child: Icon(
          //                                 EvaIcons.refresh,
          //                                 color: Colors.white30,
          //                               ),
          //                             );
          //                           },
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 10,
          //                   ),
          //                   Row(
          //                     children: [
          //                       CupertinoButton(
          //                         padding: EdgeInsets.only(left: 0),
          //                         child: Icon(
          //                           EvaIcons.heartOutline,
          //                           color: Colors.white70,
          //                           size: 26,
          //                         ),
          //                         onPressed: () {},
          //                       ),
          //                       Text(
          //                         _postDetails["post"]!["like"].toString(),
          //                         style: _countStyleDark,
          //                       ),
          //                       SizedBox(
          //                         width: 10,
          //                       ),
          //                       CupertinoButton(
          //                         padding: EdgeInsets.zero,
          //                         child: Icon(
          //                           EvaIcons.messageCircleOutline,
          //                           color: Colors.white70,
          //                           size: 26,
          //                         ),
          //                         onPressed: () {},
          //                       ),
          //                       Text(
          //                         "300",
          //                         style: _countStyleDark,
          //                       ),
          //                       Spacer(),
          //                       Text(
          //                         convertToAgo(
          //                             (_postDetails["post"]!["time"]
          //                                     as Timestamp)
          //                                 .toDate(),
          //                             DateTime.now()),
          //                         style: _postTimeStyleDark,
          //                       )
          //                     ],
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text(
          //                       _postDetails["post"]!["caption"],
          //                       style: _postDesStyleDark,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //               // width: 50,
          //             ),
          //           );
          //         }
          //       }

          //       return Card(
          //         margin: EdgeInsets.all(10),
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(28)),
          //         color: Color.fromARGB(50, 48, 48, 48),
          //         child: Container(
          //           height: 300,
          //         ),
          //       );
          //     });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
