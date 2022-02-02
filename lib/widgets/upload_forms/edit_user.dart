import 'dart:ui';

import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:chatapp/widgets/layouts/edit_user_layout.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
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
          initialChildSize: 0.96,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, scrollController) {
            //return EditUserLayout(user: currentUser,);
            return ChangeNotifierProvider<UploadProfile>(
              create: (context) => UploadProfile(),
              child: EditUserLayout(user: currentUser),
            );

            //       // return Stack(
            //       //   alignment: Alignment.center,
            //       //   children: [
            //       //     Positioned(
            //       //       top: 50,
            //       //       left: 155,
            //       //       child: ClipRRect(
            //       //         borderRadius: BorderRadius.circular(50),
            //       //         child: ImageFiltered(
            //       //           imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            //       //           child: Image.network(currentUser.photoURL.toString()),
            //       //         ),
            //       //       ),
            //       //     ),
            //       //     Positioned(
            //       //       top: 15,
            //       //       left: 155,
            //       //       child: Text(
            //       //         "Edit Profile",
            //       //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //       //       ),
            //       //     )
            //       //   ],
            //       // );
          },
        );
      });
}
