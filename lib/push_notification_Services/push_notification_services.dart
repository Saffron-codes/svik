import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fcm_key = "AIzaSyC9XkHQOqG4IDsevE4X6pJ0jmg_KKPqeCU";
  getdevicetoken() async {
    Future<String?> _devicetoken = _fcm.getToken();
    _devicetoken.then((value) async {
      //await _auth.signOut();
      // await _firestore
      //     .collection("users")
      //     .doc(_auth.currentUser!.displayName)
      //     .update({"token": value});
    });
  }

  Future<bool> sendFcmMessage(String title, String message) async {
    _fcm.subscribeToTopic('all'); 
    _fcm.requestPermission();
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAA-USqtME:APA91bE7aNnxDBDobn411KO1EFkdywilLi4xDQbtg2Q0nWSkyTbGeGhLuYxaHB_AOGMJvsP9ljV_sD3kXAz6guxulystXS7p8tLluzD-El6_03v6v52bWXmQDhVo2tR-SzezaT6w0zE2",
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": "/topics/all",
      };

      var client = Client();
      var response = await client.post(Uri.parse(url),
          headers: header, body: json.encode(request));
      var loggerNoStack = Logger(
        printer: PrettyPrinter(methodCount: 0),
      );
      loggerNoStack.i(response.body);
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }

  Future<bool> callOnFcmApiSendPushNotifications() async {
    Map<String, String>? data = {"title": "LOL It works", "body": "Good"};
    String postUrl = 'https://fcm.googleapis.com/v1/send&key$fcm_key';
    String javes_token =
        "e_Q1HgoFTH62vy_-EUeBbO:APA91bE4i4TgffvZtZvw6THCp6ytEG1ygpuMdcHmMD-NDta5f4ybrGvGMlcTADTqgirwQJaByrDL55uM0KQrbJE1LrZRK1gvc1WwIuzL6gDyleucw_E1dI7jdXlvkxoakyEg_ew8WyEt";
    if (Platform.isAndroid) {
      _fcm.sendMessage(
        to: javes_token,
        data: data,
        collapseKey: "type_a",
      );
    }

    return true;

    // if (response.statusCode == 200) {
    //   // on success do sth
    //   print('test ok push CFM');
    //   return true;
    // } else {
    //   print(' CFM error');
    //   // on failure do sth
    //   return false;
    // }
  }
  //fcm key
  //AIzaSyC9XkHQOqG4IDsevE4X6pJ0jmg_KKPqeCU

  //javes india token
  //e_Q1HgoFTH62vy_-EUeBbO:APA91bE4i4TgffvZtZvw6THCp6ytEG1ygpuMdcHmMD-NDta5f4ybrGvGMlcTADTqgirwQJaByrDL55uM0KQrbJE1LrZRK1gvc1WwIuzL6gDyleucw_E1dI7jdXlvkxoakyEg_ew8WyEt

  // Future initialise() async {
  //   _fcm.getToken();
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //     },
  //   );
  // }
}
