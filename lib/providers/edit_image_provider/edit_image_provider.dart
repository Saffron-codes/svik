import 'package:flutter/foundation.dart';

class EditImageProvider extends ChangeNotifier {
  String? imagePath = "";


  set setImagePath(path){
    imagePath = path;
    notifyListeners();
    print(imagePath);
  }

  get getImagePath => imagePath;
}
