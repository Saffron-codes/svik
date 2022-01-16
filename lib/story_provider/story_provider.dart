import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class StoryProvider extends ChangeNotifier{
  double progress = 0;

  void startTimer(BuildContext context) {
      Timer.periodic(
        Duration(milliseconds: 500),
        (Timer timer){
            if (progress == 0.9999999999999999) {
              timer.cancel();
              print("Canceled");
              Navigator.pop(context);
            } else {
              progress += 0.1;
              //print(progress);
              notifyListeners();
            }
          },
      );
    }
}