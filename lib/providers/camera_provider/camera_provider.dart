import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CameraServices with ChangeNotifier {
  int camerastate = 0;
  String last_image = "";
  static const platform = MethodChannel('com.javesindia/channels');
  change_camera(int state) {
    camerastate = state;
    notifyListeners();
  }

  void save_image(XFile image)async{
    final path = await getApplicationDocumentsDirectory();
    //print(image.path);
    // String final_path = "${path.toString()}/${image.name}";
    // print(final_path);
    File(image.path)
        .copy("${path.path.toString()}/${image.name}")
        .then((data) {
      platform.invokeMethod("toast", {"data": "Saved Successfully"});
    });
    notifyListeners();
  }

  void change_last_image(String path) {
    last_image = path;
    notifyListeners();
  }

  Future<bool?> show_dialog(BuildContext ctx)=>
    showDialog<bool>(
        context: ctx,
        builder: (ctx) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                height: 200,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Are you sure to Discard',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: ()=>Navigator.of(ctx).pop(true),
                            child: Text(
                              'Discard',
                              style: TextStyle(
                                  color: Colors.purple, fontSize: 18.0),
                            )),
                        TextButton(
                            onPressed: ()=>Navigator.of(ctx).pop(false),
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.purple, fontSize: 18.0),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ));
}
