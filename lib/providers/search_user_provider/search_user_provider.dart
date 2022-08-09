import 'package:flutter/foundation.dart';

class SearchUserProvider with ChangeNotifier{
  String searchquery = "";

  get getsearch => searchquery;

  void setsearch(query){
    searchquery =query;
    notifyListeners();
  }
}