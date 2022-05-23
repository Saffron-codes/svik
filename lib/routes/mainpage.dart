import 'dart:async';
import 'dart:io';

import 'package:chatapp/bottomnavbar_provider/bottomnavbarprovider.dart';
import 'package:chatapp/connectivity_services/connectivity_enum.dart';
import 'package:chatapp/connectivity_services/show_error_snackbar.dart';
import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/push_notification_Services/push_notification_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(
      tooltip: "",
      icon: Icon(EvaIcons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      tooltip: "",
      icon: Icon(EvaIcons.messageCircle),
      label: "Chats",
    ),
    BottomNavigationBarItem(
      tooltip: "",
      icon: Icon(EvaIcons.searchOutline),
      label: "Explore",
    ),
    BottomNavigationBarItem(
      tooltip: "",
      icon: Stack(
        children: [
          Icon(EvaIcons.bell),
          Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: themeBlueColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                child: Text(
                  "1",
                  style: TextStyle(
                    color: themeWhiteColor,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
      label: "Activity",
    ),
    BottomNavigationBarItem(
        tooltip: "",
        icon: Icon(EvaIcons.person),
        label: "Profile"),
  ];
  StreamSubscription? internetconnection;
  @override
  void initState() {
    super.initState();
    PushNotificationService().getdevicetoken();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xff202225),
    ));
  }

  @override
  void check_connection() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("Connected");
      }
    } on SocketException catch (_) {
      print("Not Connected");
    }
  }

  @override
  Widget build(BuildContext context) {
    //var connectionStatus = Provider.of<ConnectivityStatus>(context);

    // final _connectivitystream =
    //     Provider.of<ConnectivityResult>(context);
    // Future.delayed(Duration.zero,(){
    //   ConnectivityServices().showinterneterror(context, _connectivitystream);
    // });
    return Consumer2<BottomNavigationBarProvider, ConnectivityStatus>(
        builder: (context, navbarprovider, connection, child) {
      if (connection == ConnectivityStatus.Offline) {
        Future.delayed(Duration.zero, () async {
          ScaffoldMessenger.of(context).showSnackBar(Showerror());
        });
      } else {
        //ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Future.delayed(Duration.zero, () async {
        //   ScaffoldMessenger.of(context).showSnackBar(show_back());
        // });
      }
      return Scaffold(
        // body: navbarprovider.currentscreen,
        body: navbarprovider.currentscreen,
        bottomNavigationBar: BottomNavigationBar(
          // enableFeedback: false,
          elevation: 40,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          //selectedIconTheme: IconThemeData(size: 30),
          currentIndex: navbarprovider.getcurrentIndex,
          items: _tabs,
          onTap: (int idx) {
            navbarprovider.currentIndex = idx;
          },
        ),
        //  body: Stack(
        //    children: [
        //      navbarprovider.currentscreen,
        //      Positioned(
        //           left: 0,
        //           right: 0,
        //           bottom: 2,
        //           child: BottomNavigationBar(
        //             enableFeedback: false,
        //             showSelectedLabels: false,
        //             showUnselectedLabels: false,
        //     type: BottomNavigationBarType.fixed,
        //     landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        //     //selectedIconTheme: IconThemeData(size: 30),
        //     currentIndex: navbarprovider.getcurrentIndex,
        //     items: _tabs,
        //     onTap: (int idx) {
        //       navbarprovider.currentIndex = idx;
        //     },
        //   ),
        //         )
        //    ],
        //  ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        //   //selectedIconTheme: IconThemeData(size: 30),
        //   currentIndex: navbarprovider.getcurrentIndex,
        //   items: _tabs,
        //   onTap: (int idx) {
        //     navbarprovider.currentIndex = idx;
        //   },
        // ),
      );
    });
  }
}
