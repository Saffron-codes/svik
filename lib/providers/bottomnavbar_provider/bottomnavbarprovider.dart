import 'package:flutter/cupertino.dart';

import '../../pages/main/main_page.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;
  List<Widget> tabs = [HomeTab(), ChatsTab(), SearchPage(),ActivityTabPage(), ProfilePage()];
  get getcurrentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  get currentscreen => tabs[_currentIndex];
}
