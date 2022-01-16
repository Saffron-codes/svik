import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chatapp/camera_provider/camera_provider.dart';
import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Story_Upload extends StatefulWidget {
  const Story_Upload({
    Key? key,
  }) : super(key: key);

  @override
  _Story_UploadState createState() => _Story_UploadState();
}

class _Story_UploadState extends State<Story_Upload> {
  @override
  Widget build(BuildContext context) {
    final images = ModalRoute.of(context)!.settings.arguments as String;
    final camera_provider = context.read<CameraServices>();
    final storage_services = context.watch<FirebaseStorageServices>();
    return WillPopScope(
      onWillPop: () async{
        final shouldpop = await camera_provider.show_dialog(context);
        return shouldpop ?? false;
      },
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          fit: StackFit.passthrough,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(images.toString())),
                      fit: BoxFit.cover)),
            ),
            Positioned(
                top: 30,
                left: 10,
                child: IconButton(
                    onPressed: () => camera_provider.show_dialog(context),
                    icon: Icon(Icons.close))),
            Positioned(
                top: 30,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      camera_provider.save_image(XFile(images.toString()));
                      camera_provider.change_last_image(images.toString());
                    },
                    icon: Icon(Icons.save))),
            Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          context: context,
                          builder: (context) => Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.add_a_photo),
                                title: Text("Add Story"),
                                onTap: () {
                                  storage_services.uploadFile().then((task) {
                                    show_uploading();
                                    task!.whenComplete(() {
                                      storage_services.upload_story_data();
                                      Future.delayed(Duration.zero, show_uploaded);
                                    });
                                    
                                  });
                                  //storage_services.getpercentage();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.post_add),
                                title: Text("Upload Post"),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text("do something!"),
                          Icon(
                            Icons.send,
                            size: 15.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  show_uploaded() {
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Uploaded Successfully"),
      )
    );
  }

  show_uploading(){
    ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Uploading"),
      )
    );
  }
}
