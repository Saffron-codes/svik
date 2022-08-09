import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/providers/feed_provider/models/post.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final Map postDetails;
  const PostWidget({Key? key, required this.postDetails}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    final user = widget.postDetails["user"] as AppUser;
    final post = widget.postDetails["post"] as Post;
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      color: Color.fromARGB(50, 48, 48, 48),
      child: Container(
        // height: 400,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.profile),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white70),
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
              SizedBox(height: 10,),
              Hero(
                tag: post.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    post.posturl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*55/100,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
