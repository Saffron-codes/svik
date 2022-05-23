import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/routes/profile_pages/new_profile_page.dart';
import 'package:chatapp/routes/tabs/activitytab.dart';
import 'package:chatapp/routes/tabs/chatstab.dart';
import 'package:chatapp/routes/tabs/hometab.dart';
import 'package:chatapp/routes/tabs/profile.dart';
import 'package:chatapp/routes/tabs/searchtab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;
  List<Widget> tabs = [HomeTab(), ChatsTab(), SearchTab(),ActivityTabPage(), NewProfilePage()];
  get getcurrentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  get currentscreen => tabs[_currentIndex];
}
