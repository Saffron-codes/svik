import 'dart:ui';

import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/widgets/upload_forms/choose_option_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future editUserSheet(BuildContext context, UserModel currentUser) {
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            final storage_services = Provider.of<FirebaseStorageServices>(context);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.grey,
                  height: 3,
                  width: 35,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                GestureDetector(
                  onTap: (){
                    showOption(context);
                    //storage_services.selectFile();
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Stack(
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Image.network(currentUser.photourl.toString(),height: 70,width: 70,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                          )
                        ],
                      )),
                ),
                TextButton(onPressed: ()=>storage_services.change_name(), child: Text("Change my name"))
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
