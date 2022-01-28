import 'dart:async';
import 'dart:io';

import 'package:chatapp/bottomnavbar_provider/bottomnavbarprovider.dart';
import 'package:chatapp/connectivity_services/connectivity_enum.dart';
import 'package:chatapp/connectivity_services/connectivity_services.dart';
import 'package:chatapp/connectivity_services/show_error_snackbar.dart';
import 'package:chatapp/push_notification_Services/push_notification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",),
    BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: "Chats",
),
    BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined), label: "Explore"),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined), label: "Profile"),
  ];
  StreamSubscription? internetconnection;
  @override
  void initState() {
    super.initState();
    PushNotificationService().getdevicetoken();
  }
  

  @override
  void check_connection() async {
    try{
    final result =  await InternetAddress.lookup("google.com");
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
      print("Connected");
    }
  }on SocketException catch(_){
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
    return Consumer2<BottomNavigationBarProvider,ConnectivityStatus>(
      builder: (context,navbarprovider,connection, child) {
        if(connection == ConnectivityStatus.Offline){
          Future.delayed(Duration.zero, () async {
            ScaffoldMessenger.of(context).showSnackBar(Showerror());
          });
        }
        else{
          //ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // Future.delayed(Duration.zero, () async {
          //   ScaffoldMessenger.of(context).showSnackBar(show_back());
          // });
        }
        return Scaffold(
        body: navbarprovider.currentscreen,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          //selectedIconTheme: IconThemeData(size: 30),
          currentIndex: navbarprovider.getcurrentIndex,
          items: _tabs,
          onTap: (int idx) {
            navbarprovider.currentIndex = idx;
          },
        ),
      );
      }
    );
  }
}
