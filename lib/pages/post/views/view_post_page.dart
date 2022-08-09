import 'package:chatapp/pages/post/widgets/post_widget.dart';
import 'package:chatapp/providers/feed_provider/models/post.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ViewPostPage extends StatefulWidget {
  final Map postDetails;
  const ViewPostPage({Key? key, required this.postDetails}) : super(key: key);

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    // Logger().i(data);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Post"),
      ),
      body: ListView(
        children: [
          PostWidget(postDetails: data,)
        ],
      ),
    );
  }
}