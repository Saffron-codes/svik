import 'dart:io';

import 'package:chatapp/pages/upload_post/models/upload_post.dart';
import 'package:chatapp/providers/edit_image_provider/edit_image_provider.dart';
import 'package:chatapp/services/firebase_services/upload_post_service/upload_post_service.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final UploadPostServices _postServices = UploadPostServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Consumer<EditImageProvider>(
      builder: (context, editProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Upload Post"),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TouchableOpacity(
                  child: Icon(
                    EvaIcons.checkmark,
                    color: Color.fromARGB(255, 36, 147, 221),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                    _postServices.uploadPost(context, UploadPost(
                      userid:_auth.currentUser!.uid,
                      id: UniqueKey().toString(),
                      file: File(editProvider.getImagePath),
                      caption: _textEditingController.text,
                      like: 0,
                      time: Timestamp.now()
                      
                    ));
                  },
                ),
              )
            ],
          ),
          body:
              Consumer<EditImageProvider>(builder: (context, editProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, '/profile_picture',arguments: editProvider.getImagePath);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.file(
                        File(editProvider.getImagePath),
                        height: 160,
                        // width: 200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Add a Caption",
                      hintStyle: TextStyle(color: Color(0xffA3A0AC)),
                    ),
                  ),
                )
              ],
            );
          }),
        );
      }
    );
  }
}
