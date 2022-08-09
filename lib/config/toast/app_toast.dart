import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  void infoToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromRGBO(69, 41, 48, 1),
        textColor: Colors.grey[400],
        fontSize: 12.0);
  }

  void errorToast(String message){
        Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 159, 52, 79),
        textColor: Colors.grey[400],
        fontSize: 12.0);
  }
}
