import 'package:chatapp/main.dart';
import 'package:chatapp/pages/camera/view/camera_page.dart';
import 'package:chatapp/pages/post/views/view_post_page.dart';
import 'package:chatapp/pages/upload_post/view/upload_post_page.dart';
import 'package:chatapp/providers/chat_page_provider/chat_page_provider.dart';
import 'package:chatapp/providers/edit_image_provider/edit_image_provider.dart';
import 'package:chatapp/providers/feed_provider/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'config/theme/themes.dart';
import 'enums/camera_page_enum.dart';
import 'models/friend_model.dart';
import 'models/search_user_model.dart';
import 'models/story_model.dart';
import 'models/user_model.dart';
import 'pages/camera/memories_page.dart';
import 'pages/firebase/wrapper.dart';
import 'pages/login/loginpage.dart';
import 'pages/main/main_page.dart';
import 'pages/profile/views/profile_picture_page.dart';
import 'pages/profile/views/user_profile_page.dart';
import 'pages/settings/view/settings_page.dart';
import 'pages/story/view/stories_page.dart';
import 'pages/view_images/validate_image_page.dart';
import 'providers/bottomnavbar_provider/bottomnavbarprovider.dart';
import 'providers/camera_provider/camera_provider.dart';
import 'providers/theme_provider/theme_model.dart';
import 'providers/upload_profile_provider.dart';
import 'providers/user_activity.dart';
import 'services/connectivity_services/connectivity_enum.dart';
import 'services/connectivity_services/connectivity_services.dart';
import 'services/firebase_services/firebase_services.dart';
import 'story_provider/story_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    //final FirestoreServices firestoreServices = FirestoreServices();
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<FirestoreServices>(
          create: (_) => FirestoreServices(),
        ),
        ChangeNotifierProvider<UploadProfile>(
          create: (_) => UploadProfile(),
        ),
        ChangeNotifierProvider<CameraServices>(
          create: (_) => CameraServices(),
        ),
        StreamProvider<List<SearchUser>>.value(
          value: FirestoreServices().searchusers,
          initialData: const [],
        ),
        // StreamProvider<List<Friend>>.value(
        //   value: FirestoreServices().friendslist,
        //   initialData: [],
        // ),
        StreamProvider<List<Story>>.value(
          value: FirestoreServices().storylist,
          initialData: const [],
        ),
        ChangeNotifierProvider<UserActivityProvider>(
          create: (context) => UserActivityProvider(),
        ),
        ChangeNotifierProvider<BottomNavigationBarProvider>(
          create: (context) => BottomNavigationBarProvider(),
        ),
        ChangeNotifierProvider<StoryProvider>(
          create: (context) => StoryProvider(),
        ),
        StreamProvider<ConnectivityStatus>.value(
            value:
                ConnectivityService(context).connectionStatusController.stream,
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
        ChangeNotifierProvider(
          create: (context) => ThemeModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatPageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditImageProvider(),
        ),
        ChangeNotifierProvider<FeedProvider>(
          create: (context) => FeedProvider(),
        ),
      ],
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return MaterialApp(
          // showPerformanceOverlay: true,
          // darkTheme: ThemeData(
          //   //primaryColor: Color(0xff78909c),
          //   primarySwatch: Palette.kToDark,

          //   //appBarTheme: appBarTheme,
          //   bottomNavigationBarTheme: ThemeConstants().bottomNavigationBarThemeData,
          //   bottomSheetTheme: ThemeConstants().bottomSheetThemeData,
          //   scaffoldBackgroundColor: Color(0xff202225),
          // ),
          // themeMode: ThemeMode.system,
          theme:
              themeNotifier.isDark ? Themes().darkTheme : Themes().lightTheme,

          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => Wrapper(),
            '/login': (context) => LoginPage(),
            //'/camera': (context) => CameraPage(cameras: cameras),
            '/new_cam': (context) => CameraPage(
                  cameras: cameras,
                  pickmode: ModalRoute.of(context)!.settings.arguments
                      as CameraPickMode,
                ),
            '/memories': (context) => MemoriesPage(),
            //'/story_upload': (context) => Story_Upload(),
            //"/memo_view": (context) => MemoView(),
            "/view_image": (context) => ValidateImagePage(
                  imagePath:
                      ModalRoute.of(context)!.settings.arguments as String,
                ),
            //'/view_story': (context) => ViewStory(),
            '/story': (context) => StoriesPage(
                  routedata: ModalRoute.of(context)!.settings.arguments,
                ),
            '/profile': (context) => ProfilePage(),
            '/user_profile': (context) => UserProfilePage(
                profileData:
                    ModalRoute.of(context)!.settings.arguments as Friend),
            '/new_profile': (context) => ProfilePage(),
            '/settings': (context) => SettingsPage(),
            //view user profile
            '/profile_picture': (context) => ProfilePicturePage(
                  src: ModalRoute.of(context)!.settings.arguments as String,
                ),
            '/upload_post': (context) => UploadPostPage(),
            '/post':(context) => ViewPostPage( postDetails:ModalRoute.of(context)!.settings.arguments as Map)
          },
        );
      }),
    );
  }
}
