
import 'package:chatapp/config/pallete.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider/theme_model.dart';
import '../models/settings_panel_model.dart';
import '../widgets//settings_panel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> _settings = ['Account', 'Help', 'About', 'Theme'];
  bool _isOn = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeNotifier.isDark
              ? SystemUiOverlayStyle(
                  //statusBarColor: Palette.kToDark.shade900,
                  systemNavigationBarColor: Palette.kToDark.shade900,

                  //systemNavigationBarColor: Palette.kToDark.shade900,
                  //statusBarIconBrightness: Brightness.light,
                )
              : SystemUiOverlayStyle(
                  //statusBarColor: Palette.kToLight.shade900,
                  systemNavigationBarColor: Palette.kToLight.shade900,
                  // statusBarIconBrightness: Brightness.dark,
                ),
          child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 140,
                  excludeHeaderSemantics: true,
                  // title: Text("Settings"),
                  pinned: true,
                  leading: CupertinoButton(
                    child: Icon(
                      CupertinoIcons.chevron_back,
                      size: 30,
                      color: Palette.kToLight.shade900,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text("Settings",style: TextStyle(fontSize: 25),),
                    titlePadding: EdgeInsets.only(left: 50, bottom: 12),
                  ),
                )
              ];
            },
            body: Container(
              color: themeNotifier.isDark
                  ? Palette.kToDark.shade900
                  : Palette.kToLight.shade900,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SettingsPanel(
                    items: PanelModel(
                      title: "Account",
                      topics: ["Change Password"],
                    ),
                  ),
                  SettingsPanel(
                    items: PanelModel(
                      title: "More",
                      topics: ["Theme"],
                    ),
                  ),
                 CupertinoButton(
                   onPressed: (){},
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(EvaIcons.logOut,color: Palette.kToLight.shade900),
                      SizedBox(width: 10,),
                        Text(
                          "Logout",
                          style: TextStyle(color: Palette.kToLight.shade900),
                        ),
                     ],
                   ),
                 )
                ],
              ),
            ),
          ));
    });
  }
}


//  Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             title: Text("Settings"),
//           ),
//           body: ListView.builder(
//             physics: BouncingScrollPhysics(),
//             itemCount: _settings.length,
//             itemBuilder: (ctx, idx) {
//               if (_settings[idx] == 'Theme') {
//                 return Consumer<ThemeModel>(
//                     builder: (context, ThemeModel themeNotifier, child) {
//                   return SwitchListTile(
//                     title: Text(_settings[idx]),
//                     value: _isOn,
//                     onChanged: (val) {
//                       setState(() {
//                         _isOn = !_isOn;
//                         themeNotifier.isDark
//                             ? themeNotifier.isDark = false
//                             : themeNotifier.isDark = true;
//                       });
//                     },
//                   );
//                 });
//               }
//               return ListTile(
//                 title: Text(_settings[idx]),
//               );
//             },
//           ),
//         ),