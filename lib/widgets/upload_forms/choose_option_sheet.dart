import 'package:chatapp/firebase_services/firebasestorage_services.dart';
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
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () => Navigator.pushNamed(context, '/camera'),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Choose File"),
              onTap: () {
                storage_services.selectFile()
                    // .then((value) => Navigator.pushNamed(
                    //     context, "/story_upload",
                    //     arguments: storage_services.file!.path))
                    .then((value) {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Upload Profile"),
                          content: Text("Are you sure to upload choose pic"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                storage_services.upload_profile().then((value){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Uploaded Profile"),behavior: SnackBarBehavior.floating,)
                                  );
                                });
                              },
                              child: Text("Upload"),
                            ),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel"))
                          ],
                        );
                      });
                });
              },
            )
          ],
        );
      });
}
