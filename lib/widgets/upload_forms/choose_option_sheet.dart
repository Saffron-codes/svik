import 'package:chatapp/services/firebase_services/firebasestorage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future showOption(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        final storage_services = Provider.of<FirebaseStorageServices>(context);
        return Wrap(
          children: [
            ListTile(
              iconColor: Color(0xffD8D8D8),
              textColor: Color(0xffD8D8D8),
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () => Navigator.pushNamed(context, '/camera'),
            ),
            ListTile(
              iconColor: Color(0xffD8D8D8),
              textColor: Color(0xffD8D8D8),
              leading: Icon(Icons.image),
              title: Text("Choose File"),
              onTap: () {
                //Navigator.pop(context);
                storage_services.selectFile().then((value){
                storage_services.uploadProfile();
                });
                    // .then((value) => Navigator.pushNamed(
                    //     context, "/story_upload",
                    //     arguments: storage_services.file!.path))
                //     .then((value) {
                //   return showDialog(
                //       context: context,
                //       builder: (context) {
                //         return AlertDialog(
                //           title: Text("Are you sure to upload"),
                //           //content: Text(((storage_services.uploadStoryTask!.snapshot.bytesTransferred/storage_services.uploadStoryTask!.snapshot.totalBytes)*100).toString()),
                //           content:  FirebaseStorageServices().uploadProgress(),
                //           //content: storage_services.t !=null? Text((storage_services.task!.snapshot.bytesTransferred/storage_services.task!.snapshot.totalBytes).toString()):Text("Status"),
                //           actions: [
                //             TextButton(
                //               onPressed: () {
                //                 storage_services.uploadProfile();
                //                 // storage_services
                //                 // .upload_profile().then((value){
                //                 //   Navigator.pop(context);
                //                 //   Navigator.pop(context);
                //                 //   Navigator.pop(context);
                //                 //   ScaffoldMessenger.of(context).showSnackBar(
                //                 //     SnackBar(content: Text("Uploaded Profile"),behavior: SnackBarBehavior.floating,)
                //                 //   );
                //                 // });
                //               },
                //               child: Text("Upload"),
                //             ),
                //             TextButton(
                //                 onPressed: () {
                //                   Navigator.pop(context);
                //                   Navigator.pop(context);
                //                 },
                //                 child: Text("Cancel"))
                //           ],
                //         );
                //       });
                // }

              },
            ),
          ],
        );
      });
}
