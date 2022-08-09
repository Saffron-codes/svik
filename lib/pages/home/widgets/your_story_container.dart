import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/enums/camera_page_enum.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/services/firebase_services/firebase_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class YourStoryContainer extends StatefulWidget {
  const YourStoryContainer({Key? key}) : super(key: key);

  @override
  State<YourStoryContainer> createState() => _YourStoryContainerState();
}

class _YourStoryContainerState extends State<YourStoryContainer> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel>();
    final storage_services = context.watch<FirebaseStorageServices>();

    return GestureDetector(
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
        //Navigator.pushNamed(context, '/camera');
      },
      child: SizedBox(
        //color: Colors.blueGrey,
        height: 120,
        width: 66,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: currentUser.photourl.toString(),
              imageBuilder: (context, imageProvider) => Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: imageProvider,
                  ),
                ),
              ),
            ),
            Text(
              "You",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
