import 'package:camera/camera.dart';
import 'package:chatapp/bottomnavbar_provider/bottomnavbarprovider.dart';
import 'package:chatapp/camera_provider/camera_provider.dart';
import 'package:chatapp/connectivity_services/connectivity_enum.dart';
import 'package:chatapp/connectivity_services/connectivity_services.dart';
import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/chatroom_id.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/search_user.dart';
import 'package:chatapp/models/story.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/routes/camera_pages/camerapage.dart';
import 'package:chatapp/routes/camera_pages/memories_page.dart';
import 'package:chatapp/routes/chatpage/chatpage.dart';
import 'package:chatapp/routes/firebase/wrapper.dart';
import 'package:chatapp/routes/mainpage.dart';
import 'package:chatapp/routes/profile_pages/profile_page.dart';
import 'package:chatapp/routes/storypages/view_story_page.dart';
import 'package:chatapp/routes/tabs/chats_tab/chat_page.dart';
import 'package:chatapp/routes/tabs/profile.dart';
import 'package:chatapp/routes/upload_routes/image_view.dart';
import 'package:chatapp/routes/user_validation/loginpage.dart';
import 'package:chatapp/routes/view_images/memo_view_page.dart';
import 'package:chatapp/story_provider/story_provider.dart';
import 'package:chatapp/user_profile_provider/banner_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_services/firebaseauth_services.dart';
import 'routes/storypages/main_story_page.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirestoreServices firestoreServices = FirestoreServices();
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<FirestoreServices>(
          create: (_) => FirestoreServices(),
        ),
        ChangeNotifierProvider<CameraServices>(
          create: (_) => CameraServices(),
        ),
        ChangeNotifierProvider<bannercolorprovider>(
          create: (context) => bannercolorprovider(),
        ),
        StreamProvider<List<SearchUser>>.value(
          value: FirestoreServices().searchusers,
          initialData: [],
        ),
        // StreamProvider<List<Friend>>.value(
        //   value: FirestoreServices().friendslist,
        //   initialData: [],
        // ),
        StreamProvider<List<Story>>.value(
          value: FirestoreServices().storylist,
          initialData: [],
        ),
        ChangeNotifierProvider<BottomNavigationBarProvider>(
          create: (context) => BottomNavigationBarProvider(),
        ),
        ChangeNotifierProvider<StoryProvider>(
          create: (context) => StoryProvider(),
        ),
        StreamProvider<ConnectivityStatus>.value(
            value: ConnectivityService(context).connectionStatusController.stream,
            initialData: ConnectivityStatus.unknown),
        StreamProvider(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
        StreamProvider<UserModel?>(
          create: (context) => AuthService().userprofile,
          initialData: null,
        ),
        ChangeNotifierProvider<FirebaseStorageServices>(
          create: (context) => FirebaseStorageServices(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.grey,
            appBarTheme: appbartheme,
            bottomNavigationBarTheme: bottomNavigationBarThemeData),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => LoginPage(),
          '/camera': (context) => CameraPage(cameras: cameras),
          '/memories': (context) => MemoriesPage(),
          '/story_upload': (context) => Story_Upload(),
          "/memo_view": (context) => MemoView(),
          '/view_story': (context) => ViewStory(),
          '/chatspage':(context)=>ChatsTabPage(),
          '/profile':(context)=>ProfilePage()
        },
      ),
    );
  }
}
