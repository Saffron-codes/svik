import 'package:chatapp/providers/feed_provider/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

class PostCard extends StatefulWidget {
  final int index;
  final Post? post;
  const PostCard({Key? key, required this.index, required this.post})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return widget.post != null
        ? Container(
            margin: EdgeInsets.all(4),
            child: ClipRRect(
              // clip the image to a circle
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.post!.posturl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  // final loadedPercent = (loadingProgress!.cumulativeBytesLoaded /loadingProgress.expectedTotalBytes!);
                  // Logger().i(loadedPercent);
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200.0,
                      height: 400.0,
                      color: Colors.white30,
                    ),
                  );
                },
                // frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded){
                //   return Center(child: Text("Frame"),);
                // },
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 400,
              // color: Colors.white30,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(20)),
            ),
          );
  }
}
