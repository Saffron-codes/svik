import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/enums/camera_page_enum.dart';
import 'package:chatapp/pages/home/widgets/home_feed/home_feed_list.dart';
import 'package:chatapp/pages/home/widgets/your_story_container.dart';
import 'package:chatapp/providers/feed_provider/feed_provider.dart';
import 'package:chatapp/services/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/services/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:chatapp/widgets/upload_forms/choose_option_sheet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/story_list.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel>();
    final storage_services = context.watch<FirebaseStorageServices>();
    return StreamProvider<List<Friend>>.value(
      value: FirestoreServices().friendslist,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text("Svik"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TouchableOpacity(
                child: Icon(EvaIcons.plus),
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                    ),
                    context: context,
                    builder: (context) => Wrap(
                      children: [
                        ListTile(
                          iconColor: Color(0xffD8D8D8),
                          textColor: Color(0xffD8D8D8),
                          leading: Icon(EvaIcons.camera),
                          title: Text("Camera"),
                          onTap: () => Navigator.pushNamed(context, '/new_cam',
                              arguments: CameraPickMode.fromHome),
                        ),
                        ListTile(
                          iconColor: Color(0xffD8D8D8),
                          textColor: Color(0xffD8D8D8),
                          leading: Icon(EvaIcons.image),
                          title: Text("Choose File"),
                          onTap: () {
                            storage_services.selectFile().then((value) =>
                                Navigator.pushNamed(context, "/story_upload",
                                    arguments: storage_services.file!.path));
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            // PopupMenuButton(
            //   tooltip: "Add Something",
            //   color: Colors.grey[900],
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       textStyle: ThemeConstants().chatTextName,
            //       child: Text("Post"),
            //       value: "Post",
            //     ),
            //     PopupMenuItem(
            //       textStyle: ThemeConstants().chatTextName,
            //       child: Text("Story"),
            //       value: "Story",
            //     ),
            //     PopupMenuItem(
            //       textStyle: ThemeConstants().chatTextName,
            //       child: Text("Memos"),
            //       value: "Memos",
            //     )
            //   ],
            //   icon: Icon(EvaIcons.plus),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10)),
            //   onSelected: (value) {
            //     print(value.toString());
            //     showOption(context);
            //   },
            // )
          ],
        ),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          physics: BouncingScrollPhysics(),
          // shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              height: 90,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: const[
                  YourStoryContainer(),
                  StoryListWidget(),
                ],
              ),
            ),
            Consumer<FeedProvider>(
              builder: (context,feedProvider,_) {
                return HomeFeedList(feedProvider: feedProvider,);
              }
            )
          ],
        ),
      ),
    );
  }
}
