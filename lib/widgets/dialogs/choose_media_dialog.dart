import 'package:chatapp/enums/camera_page_enum.dart';
import 'package:flutter/material.dart';

Future chooseMedia(BuildContext context,Function()? ontap2) {
  final TextStyle _style = TextStyle(color: Colors.white);
  return showDialog(
    context: context,
    barrierColor: Colors.black12,
    builder: (context) => AlertDialog(
      backgroundColor: Color(0xFF212225),
      contentPadding: EdgeInsets.zero,
      content: Wrap(
        children: [
          ListTile(
            title: Text(
              "Take a photo",
              style: _style,
            ),
            onTap: ()=>Navigator.pushNamed(context, '/new_cam',arguments:CameraPickMode.fromProfile),
          ),
          ListTile(
            title: Text(
              "Choose a existing one",
              style: _style,
            ),
            onTap:ontap2
          )
        ],
      ),
    ),
  );
}
