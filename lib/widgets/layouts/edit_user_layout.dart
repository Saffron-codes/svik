import 'dart:io';

import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:chatapp/widgets/upload_forms/choose_option_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../touchable_opacity.dart';

class EditUserLayout extends StatefulWidget {
  final UserModel user;
  const EditUserLayout({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserLayoutState createState() => _EditUserLayoutState();
}

class _EditUserLayoutState extends State<EditUserLayout> {
  final TextEditingController _nameController = TextEditingController();
  String ProfieUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.user.name!;
    ProfieUrl = widget.user.photourl!;
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final storage_services = Provider.of<FirebaseStorageServices>(context);
    final uploadProfileService = Provider.of<UploadProfile>(context);
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
                  size: 28,
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
              uploadProfileService.userDataProgress != DataProgress.loading?
              uploadProfileService.userDataProgress == DataProgress.done?
              //disabled btn
              Icon(
                Icons.done,
                size: 28,
                color: themeWhiteColor,
              ):
              TouchableOpacity(
                onTap: () {
                  _nameController.text != user.name ?uploadProfileService.changeName(_nameController.text):null;
                   uploadProfileService.loadUserData(context);
                },
                child: Icon(
                  Icons.done,
                  size: 28,
                  color: themeBlueColor,
                ),
              ):
              SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: themeBlueColor,
                  strokeWidth: 2,
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
                onTap: ()async {
                  //showOption(context);
                  final bool ischosen = await uploadProfileService.chooseImage();
                  // print(ischosen);
                  //print(uploadProfileService.chosenImagePath);
                  //storage_services.selectFile();
                },
                child: Stack(
                  children: [
                    uploadProfileService.isFileChosen?
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:FileImage(File(uploadProfileService.chosenImagePath!)),
                    ):
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.photourl!),
                    ),
                    Positioned(
                      child: CircleAvatar(
                          backgroundColor: Color(0xff141E29),
                          radius: 12,
                          child: uploadProfileService.isFileChosen?
                          GestureDetector(
                            onTap: () {
                              uploadProfileService.removeImage();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ):Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 15,
                          )
                          ),
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
                        borderSide: BorderSide(color: Color(0xffD8D8D8))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD8D8D8)))),
              ),
              // Text(uploadProfileService.userDataProgress.toString(),style: chatTextName,)
            ],
          ),
        )
        //TextButton(onPressed: ()=>storage_services.change_name(), child: Text("Change my name"))
      ],
    );
  }
}
