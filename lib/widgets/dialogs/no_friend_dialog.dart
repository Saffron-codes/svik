import 'package:chatapp/constants/styles/button_styles.dart';
import 'package:flutter/material.dart';

Future showNoFriendDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            child: Container(
              height: 180,
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Followers 😟",
                      style: TextStyle(
                        fontSize: 25,
                      )),
                      SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: ()=>Navigator.pop(context),
                    child: Text("Okay",style: TextStyle(
                        fontSize: 17,
                      )),
                    style: curvedStyle,
                  )
                ],
              ),
            ),
          ));
}
