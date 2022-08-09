import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/services/firebase_services/firebase_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUserTile extends StatefulWidget {
  final AppUser user;
  final bool isfriendalready;
  const SearchUserTile(
      {Key? key, required this.user, required this.isfriendalready})
      : super(key: key);

  @override
  State<SearchUserTile> createState() => _SearchUserTileState();
}

enum AddState {
  none,
  loading,
  added,
}

class _SearchUserTileState extends State<SearchUserTile> {
  AddState _addState = AddState.none;
  @override
  Widget build(BuildContext context) {
    AppUser _user = widget.user;
    bool _isfriend = widget.isfriendalready;
    bool _added = false;
    double height = 75;
    return Container(
        height: height,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color.fromARGB(50, 48, 48, 48),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 65,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(_user.profile),
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
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () {
                      setState(() {
                        _addState = AddState.loading;
                      });
                      _load().then((value) {
                        setState(() {
                          _addState = AddState.added;
                        });
                      });
                    },
                  )
                ],
              ),
            ),
            
          ],
        )
        // padding: EdgeInsets.all(12),
        );
  }

  Future _load() async {
   // await FirestoreServices().addfriend(widget.user);
  }
}
