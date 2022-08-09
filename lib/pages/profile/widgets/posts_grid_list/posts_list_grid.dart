import 'package:chatapp/pages/profile/widgets/posts_grid_list/image_tile.dart';
import 'package:chatapp/providers/feed_provider/feed_provider.dart';
import 'package:chatapp/providers/feed_provider/models/post.dart';
import 'package:chatapp/services/firebase_services/feed_service/feed_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GridTile {
  const GridTile(this.crossAxisCount, this.mainAxisCount);
  final int crossAxisCount;
  final int mainAxisCount;
}

class PostsGridList extends StatefulWidget {
  const PostsGridList({Key? key}) : super(key: key);

  @override
  State<PostsGridList> createState() => _PostsGridListState();
}

class _PostsGridListState extends State<PostsGridList> {
  static const tiles = [
    GridTile(1, 2),
    GridTile(2, 1),
    GridTile(1, 2),
    GridTile(1, 1),
    GridTile(2, 2),
    GridTile(1, 2),
    GridTile(1, 1),
    GridTile(3, 1),
    GridTile(1, 1),
    GridTile(4, 1),
  ];
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context);
    Logger().i(posts.isEmpty);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: posts.isNotEmpty?
      StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                ...posts.mapIndexed((index, post) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: index % 2 == 0 ? 2 : 1,
                    child: PostCard(
                      index: index,
                      post: post,
                    ),
                  );
                }),
              ],
            ):
                  StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                ...tiles.mapIndexed((index, tile) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: index % 2 == 0 ? 2 : 1,
                    child: PostCard(
                      index: index,
                      post: null,
                    ),
                  );
                }),
              ],
            )
    );
  }
}
