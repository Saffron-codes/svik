import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPageProvider extends ChangeNotifier {
  bool isEmojiOpen = false;
  bool isEditMessage = false;
  String messageId = "";
  String message = "";
  String favEmoji = "";
  FocusNode focusNode = FocusNode();
  late SharedPreferences  prefs;
  bool isChoosingEmojiForFav = false;

  bool get getState => isEmojiOpen;
  set toggleEmoji(state) {
    isEmojiOpen = state;
    notifyListeners();
  }

  bool get getEditState => isEditMessage;

  void changeEditState(bool state, String usermessageId) {
    isEditMessage = state;
    messageId = usermessageId;
    notifyListeners();
    print(messageId);
  }

  get getmessage => message;

  get getFoucsNode => focusNode;
  set setmessage(value) {
    message = value;
    notifyListeners();
  }

  void requestFocus() {
    focusNode.requestFocus();
    notifyListeners();
  }

  void removeFocus() {
    focusNode.unfocus();
    notifyListeners();
  }

  //shared prefs init
  sharedPrefsInit()async{
     prefs = await SharedPreferences.getInstance();
     notifyListeners();
    //  print(prefs);
  }

  // fav emoji section
  get favEmojiState => favEmoji;

  get getChooseState => isChoosingEmojiForFav;

  set changeChooseEmojiState(state){
    isChoosingEmojiForFav=state;
    notifyListeners();
  }

  void getfavEmoji()async{
    // sharedPrefsInit();
    final pre = await SharedPreferences.getInstance();

    final emoji = pre.getString("favEmoji");
    favEmoji = emoji ?? "❤️";
    notifyListeners();
  }

  void setfavEmoji(String emoji)async{
    sharedPrefsInit();
    await prefs.setString('favEmoji', emoji);
    favEmoji = emoji;
    notifyListeners();
  }
}
