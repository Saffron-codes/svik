import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/firebase_services/firebaseauth_services.dart';
import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/routes/homepage/story_list.dart';
import 'package:chatapp/widgets/upload_forms/choose_option_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            elevation: 2,
            title: Text("AIO"),
            actions: [
              PopupMenuButton(
                tooltip: "Add Something",
                color: Color(0xff141E29),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    textStyle: chatTextName,
                    child: Text("Post"),
                    value: "Post",
                  ),
                  PopupMenuItem(
                    textStyle: chatTextName,
                    child: Text("Story"),
                    value: "Story",
                  ),
                  PopupMenuItem(
                    textStyle: chatTextName,
                    child: Text("Memos"),
                    value: "Memos",
                  )
                ],
                icon: Icon(Icons.add),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onSelected: (value) {
                  print(value.toString());
                  showOption(context);
                },
              )
            ],
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 2,
              ),
              Container(
                  padding: EdgeInsets.only(left: 5, top: 10),
                  height: 80,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            context: context,
                            builder: (context) => Wrap(
                              children: [
                                ListTile(
                                  iconColor: Color(0xffD8D8D8),
                                  textColor: Color(0xffD8D8D8),
                                  leading: Icon(Icons.camera_alt),
                                  title: Text("Camera"),
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/camera'),
                                ),
                                ListTile(
                                  iconColor: Color(0xffD8D8D8),
                                  textColor: Color(0xffD8D8D8),
                                  leading: Icon(Icons.image),
                                  title: Text("Choose File"),
                                  onTap: () {
                                    storage_services.selectFile().then(
                                        (value) => Navigator.pushNamed(
                                            context, "/story_upload",
                                            arguments:
                                                storage_services.file!.path));
                                  },
                                )
                              ],
                            ),
                          );
                          //Navigator.pushNamed(context, '/camera');
                        },
                        child: Stack(children: [
                          Positioned(
                              child: currentUser != null
                                  ? CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                          currentUser.photourl.toString()),
                                    )
                                  : CircleAvatar()),
                          Positioned(
                              top: 44,
                              left: 46,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue,
                                child: Center(child: Icon(Icons.add)),
                              ))
                        ]),
                      ),
                      StoryListWidget()
                    ],
                  )),
              // StreamBuilder<UserModel?>(
              //   stream: AuthService().user,
              //   builder: (context, snapshot) {
              //     if(snapshot.connectionState == ConnectionState.waiting){
              //       return Text("Loading");
              //     }else{
              //       return Text(snapshot.data!.name.toString());
              //     }
              //   },
              // )
            ],
          )),
    );
  }
}
