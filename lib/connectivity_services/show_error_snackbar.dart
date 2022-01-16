import 'package:flutter/material.dart';

SnackBar Showerror()=>SnackBar(
  behavior: SnackBarBehavior.floating,
  content: Text('No Internet Connection'),
  duration: Duration(days: 1),
);


SnackBar show_back()=>SnackBar(
  behavior: SnackBarBehavior.floating,
  content: Text('Good to go 🎉 🎉'),
);