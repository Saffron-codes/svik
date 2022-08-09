import 'dart:async';
import 'dart:io';
import 'package:chatapp/providers/theme_provider/theme_model.dart';
import 'package:chatapp/services/connectivity_services/connectivity_enum.dart';
import 'package:chatapp/services/connectivity_services/show_error_snackbar.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/push_notification_Services/push_notification_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../models/user_activity_model.dart';
import '../providers/bottomnavbar_provider/bottomnavbarprovider.dart';
import '../providers/user_activity.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<BottomNavigationBarItem> _tabs = [];
  StreamSubscription? internetconnection;
  @override
  void initState() {
    super.initState();
    initializeApp();
    // PushNotificationService().getdevicetoken();

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   systemNavigationBarColor: Color(0xff202225),
    // ));
  }

  void initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
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
    FlutterNativeSplash.remove();

    //var connectionStatus = Provider.of<ConnectivityStatus>(context);

    // final _connectivitystream =
    //     Provider.of<ConnectivityResult>(context);
    // Future.delayed(Duration.zero,(){
    //   ConnectivityServices().showinterneterror(context, _connectivitystream);
    // });
    return Consumer3<BottomNavigationBarProvider, ConnectivityStatus,
            ThemeModel>(
        builder: (context, navbarprovider, connection, themeModel, child) {
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
      return StreamProvider<List<UserActivity>>.value(
        value: UserActivityProvider().getAllActivities(),
        initialData: [],
        child: 
           AnnotatedRegion<SystemUiOverlayStyle>(
            value: themeModel.isDark
                ? ThemeConstants().systemThemeDark
                : ThemeConstants().systemThemeLight,
            child: Scaffold(
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
                items: [
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
                        Consumer<List<UserActivity>>(
                          builder: (context,activityProvider,_) {
                            return Positioned(
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 18, 18, 19),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints:
                                      BoxConstraints(minWidth: 12, minHeight: 12),
                                  child: Text(
                                    activityProvider.length.toString(),
                                    style: TextStyle(
                                      color: ThemeConstants().themeWhiteColor,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ));
                          }
                        )
                      ],
                    ),
                    label: "Activity",
                  ),
                  BottomNavigationBarItem(
                      tooltip: "", icon: Icon(EvaIcons.person), label: "Profile"),
                ],
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
            ),
          ),
      );
    });
  }
}
