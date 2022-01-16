

import 'dart:async';

import 'package:chatapp/connectivity_services/connectivity_enum.dart';
import 'package:chatapp/connectivity_services/show_error_snackbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectivityService {

  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>(); 

  ConnectivityService(BuildContext context){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      connectionStatusController.add(_getStatusFromResult(result,context));
    });
  }


  ConnectivityStatus _getStatusFromResult(ConnectivityResult result,BuildContext context) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        //ScaffoldMessenger.of(context).showSnackBar(Showerror());
        return ConnectivityStatus.Offline;
      default:
        //ScaffoldMessenger.of(context).showSnackBar(Showerror());
        return ConnectivityStatus.unknown;
    }
  }
  
}