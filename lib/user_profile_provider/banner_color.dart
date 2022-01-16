import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class bannercolorprovider extends ChangeNotifier {
  Color bannercolor = Color(0xffFFC0CB);
  bool isfriend = false;
  void color_change(Color _color) {
    bannercolor = _color;
    notifyListeners();
  }
  void opendialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Choose a color"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                    pickerColor: bannercolor,
                    onColorChanged: (color) => color_change(color)),
                TextButton(onPressed: (){
                  color_change(bannercolor);
                  Navigator.pop(context);
                  }, child: Text("Save"))
              ],
            ),
          ));
          
}
