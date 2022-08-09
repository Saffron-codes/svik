import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/providers/user_activity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final SearchUser user;
  final bool isfriendalready;
  const UserTile(
      {Key? key, required this.user, required this.isfriendalready})
      : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

enum AddState {
  none,
  loading,
  added,
}

class _UserTileState extends State<UserTile> {
  AddState _addState = AddState.none;
  @override
  Widget build(BuildContext context) {
    SearchUser _user = widget.user;
    bool _isfriend = widget.isfriendalready;
    bool _added = false;
    double height = 75;
    return Container(
        height: height,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color.fromARGB(50, 48, 48, 48),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 65,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(_user.photourl),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _user.name,
                    style: TextStyle(
                      color: Color(0xffD8D8D8),
                    ),
                  ),
                  Spacer(),
                  CupertinoButton(
                    child: _isfriend
                        ? Icon(EvaIcons.personRemove)
                        : _addState == AddState.none
                            ? Icon(
                                EvaIcons.plus,
                              )
                            : _addState == AddState.added
                                ? Icon(EvaIcons.personDone)
                                : Icon(EvaIcons.loaderOutline),
                    padding: EdgeInsets.zero,
                    color: Color.fromARGB(255, 32, 158, 220),
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      setState(() {
                        _addState = AddState.loading;
                      });
                      _load().then((value) {
                        setState(() {
                          _addState = AddState.added;
                          _added = true;
                          height = 150;
                        });
                      });
                    },
                  )
                ],
              ),
            ),
            _added?
            Container(
              height: 77,
              color: Colors.blue,
            ):Spacer()
            
          ],
        )
        // padding: EdgeInsets.all(12),
        );
  }

  Future _load() async {
    await UserActivityProvider().addActivity(widget.user.uid, widget.user);
  }
}
