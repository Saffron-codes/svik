import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/user_activity_model.dart';
import 'package:chatapp/pages/activity/utils/enums.dart';
import 'package:chatapp/pages/activity/widgets/dialogs/cancel_activity_dialog.dart';
import 'package:chatapp/providers/user_activity.dart';
import 'package:chatapp/services/firebase_services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../config/theme/theme_constants.dart';
import '../../../utils/convert_to_ago.dart';
import '../../../widgets/touchable_opacity.dart';

class UserActivityTile extends StatefulWidget {
  final Map<String, String> profile;
  final UserActivity activity;
  final bool isSent;
  const UserActivityTile(
      {Key? key,
      required this.profile,
      required this.activity,
      required this.isSent})
      : super(key: key);

  @override
  State<UserActivityTile> createState() => _UserActivityTileState();
}

class _UserActivityTileState extends State<UserActivityTile> {
  AprooveTask _approvetask = AprooveTask.none;
  @override
  Widget build(BuildContext context) {
    bool _isapproved = false;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  widget.profile["photo_url"].toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.profile["name"].toString(),
                  style: TextStyle(
                      color: ThemeConstants().themeWhiteColor, fontSize: 16),
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
            !widget.isSent
                ? Container()
                : _approvetask == AprooveTask.none
                    ? CupertinoButton(
                        child: Icon(Icons.done,
                            color: ThemeConstants().themeBlueColor),
                        onPressed: () {
                          setState(() {
                            _approvetask = AprooveTask.loading;
                          });
                          final frd = Friend(Timestamp.now(), "", "", "",
                              Timestamp.now(), [], widget.activity.friend_uid);
                          _addTask(frd).then((val) {
                            setState(() {
                              _approvetask = AprooveTask.done;
                            });
                          }).catchError((e) {
                            Logger().e(e);
                          });
                        },
                      )
                    : _approvetask == AprooveTask.loading
                        ? CircularProgressIndicator(
                            color: Colors.blue,
                          )
                        : Container(),
            SizedBox(
              width: 10,
            ),
            TouchableOpacity(
              child: CircleAvatar(
                backgroundColor: Color(0xFF262e36),
                radius: 14,
                child:
                    Icon(Icons.close, color: ThemeConstants().themeWhiteColor,size: 18,),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black12,
                  builder: (c) => CancelActivityDialog(),
                );
              },
            )
          ],
        )
      ]),
    );
  }

  Future<void> _addTask(Friend friend) async {
    // add friend
    await FirestoreServices().addfriend(friend);
    //remove activity
    await UserActivityProvider().removeActivity(friend.uid);
  }
}
