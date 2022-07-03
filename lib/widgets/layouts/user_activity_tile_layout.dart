import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/user_activity_model.dart';
import 'package:flutter/material.dart';

import '../../config/theme/theme_constants.dart';
import '../../utils/convert_to_ago.dart';
import '../touchable_opacity.dart';

class UserActivityTile extends StatefulWidget {
  final Map<String,String> profile;
  final UserActivity activity;
  const UserActivityTile({Key? key, required this.profile, required this.activity}) : super(key: key);

  @override
  State<UserActivityTile> createState() => _UserActivityTileState();
}

class _UserActivityTileState extends State<UserActivityTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.profile["photo_url"].toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.profile["name"].toString(),
                  style: TextStyle(color: ThemeConstants().themeWhiteColor, fontSize: 16),
                ),
                Text(
                  convertToAgo(widget.activity.time.toDate(), DateTime.now()),
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            )
          ],
        ),
        //IconButton(onPressed: (){}, icon: Icon(Icons.done,color: themeBlueColor,))
        Row(
          children: [
            TouchableOpacity(
              child: Icon(Icons.done, color: ThemeConstants().themeBlueColor),
              onTap: () {},
            ),
            SizedBox(
              width: 10,
            ),
            TouchableOpacity(
              child: Icon(Icons.close, color: ThemeConstants().themeWhiteColor),
              onTap: () {},
            )
          ],
        )
      ]),
    );
  }
}
