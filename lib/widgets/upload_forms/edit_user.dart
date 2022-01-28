import 'dart:ui';

import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:chatapp/widgets/upload_forms/choose_option_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future editUserSheet(BuildContext context, UserModel currentUser) {
  TextEditingController _nameController = TextEditingController();
  _nameController.text = currentUser.name!;
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            final storage_services =
                Provider.of<FirebaseStorageServices>(context);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                // Container(
                //   color: Colors.grey,
                //   height: 3,
                //   width: 35,
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TouchableOpacity(
                        onTap: () {
                          Navigator.pop(context);
                          //_nameController.dispose();
                          _nameController
                              .removeListener(() => _nameController.dispose());
                        },
                        child: Icon(
                          Icons.close,
                          color: Color(0xff209EF1),
                        ),
                      ),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xffD8D8D8)),
                      ),
                      TouchableOpacity(
                        onTap: ()async{
                          await storage_services.changeName(_nameController.text).then((value) => {
                            if(value == "success"){
                              _nameController
                              .removeListener(() => _nameController.dispose()),
                              Navigator.pop(context)
                            }
                          });
                          //print(response.toString());
                        },
                        child: Icon(
                          Icons.done,
                          color: Color(0xff209EF1),
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showOption(context);
                          //storage_services.selectFile();
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(currentUser.photourl.toString()),
                            ),
                            Positioned(
                              child: CircleAvatar(
                                  backgroundColor: Color(0xff141E29),
                                  radius: 12,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 15,
                                  )),
                              bottom: 0,
                              left: 55,
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffD8D8D8))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffD8D8D8)))),
                      )
                    ],
                  ),
                )
                //TextButton(onPressed: ()=>storage_services.change_name(), child: Text("Change my name"))
              ],
            );
            // return Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     Positioned(
            //       top: 50,
            //       left: 155,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(50),
            //         child: ImageFiltered(
            //           imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            //           child: Image.network(currentUser.photoURL.toString()),
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       top: 15,
            //       left: 155,
            //       child: Text(
            //         "Edit Profile",
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //       ),
            //     )
            //   ],
            // );
          },
        );
      });
}
