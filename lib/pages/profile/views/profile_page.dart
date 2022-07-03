import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider/theme_model.dart';
import '../../../widgets/upload_forms/edit_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  static final mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Color(0xff242232),
      statusBarColor: Color(0xff202225));
  late TabController _tabController;
  bool _isexpanded = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<UserModel>(context);
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Color.fromARGB(255, 94, 79, 193)));
    //https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.8MRcnKRZN-IPhPzQ_Qkq4gHaEo%26pid%3DApi&f=1
    //https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwritestylesonline.com%2Fwp-content%2Fuploads%2F2016%2F08%2FFollow-These-Steps-for-a-Flawless-Professional-Profile-Picture.jpg&f=1&nofb=1
    // return Scaffold(
    //   appBar: AppBar(
    //     toolbarHeight: 100,
    //     title: Hero(
    //           tag: "p-${widget.index}",
    //           child: CircleAvatar(
    //             backgroundImage: NetworkImage("https://picsum.photos/seed/${widget.index}/800"),
    //           )
    //         ),
    //   ),

    // );
    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  systemOverlayStyle:
                      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                  automaticallyImplyLeading: false,
                  //systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: Colors.amber),
                  elevation: 0,
                  //title: Text("Sliver Title"),
                  actions: [
                    // IconButton(
                    //     onPressed: () {
                    //       if (name == "Justin Bieber") {
                    //         setState(() {
                    //           name = "Saffron Dionysius";
                    //           url =
                    //               "https://lh3.googleusercontent.com/R69ZYHuiM-czsg8-z61uELmUmGeigpyAg2YCfcosMI99fyx-f-wz0slKERDfYywkMfFiG-W4HktS4UKqTLjgbt7IclmnGTD6eMf1rnVCZgI6h3XwUzot70f4ZI3hRBvRwTT6tAwY548K_NRnZYBGwOBObQo650Zpf0tRna2Hj3DfBvC9RXwAnxLNPKge_OWremJTP23ylI0FGpRDozoX-kIk87w89YxsXhnX0OhDK0wvlRBYgrJPH3pP6xSlCgkhsAa7RZ8Dgvkw1LWM7kT3vZ9voVlYzhZg0ahViIR194ODjjMYyr4-wUvQ9T3J-FMJCeEEX2KdiFDiYqwwrkcV5te3_c8h9ohcI8Npo5Y1Yeq291J_H78caoyIQX_E8_YmMqxZFLIJJaeBGEUBrSTbhnJLe-PQB7Hqs0svE7ER43qZmPcV5fANx0Mpq6W_zZ6Ur-2AW7RywOEPyH_cekHFMv4jqKoZ3EZk8PBul2IvCfWC16zlTei3zJT4GqTMBWYL1nQS73Vlz_nH06ztapH8RfzhocYAAkd-CaUT1r6Wswtura0VqBh7Y8EvYvqbIP18VmDvUARoFb5O8xfFST7rfeWwY30O424mbsBccLo3RdeCrPa6N8TQlrMl_dzpMT2y_-Hi2AzJNcpQ69da9sRrGoHrgOwdxa6zvQh4Fz1BNBkRL-mpQhSSZFgvBaajyzs-ecWP1CvihVRj4VHYe-O-A3q1D9CJ8UV1S8qgV7uvPSdbrqtN3WJ6MxqJsbc=w660-h879-no?authuser=0";
                    //         });
                    //       } else {
                    //         setState(() {
                    //           name = "Justin Bieber";
                    //           url =
                    //               "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.billboard.com%2Ffiles%2F2020%2F10%2FJustin-Bieber-Justin-Bieber-Seasons-Premiere-2020-Billboard-1548-1604003367-compressed.jpg&f=1&nofb=1";
                    //         });
                    //       }
                    //     },
                    //     icon: Icon(Icons.add)),
                    CupertinoButton(
                      onPressed: () => editUserSheet(context, currentUser),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                    Consumer<ThemeModel>(
                        builder: (context, ThemeModel themeNotifier, child) {
                      return CupertinoButton(
                        child: Icon(
                          EvaIcons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                          // themeNotifier.isDark
                          //     ? themeNotifier.isDark = false
                          //     : themeNotifier.isDark = true;
                        },
                        padding: EdgeInsets.zero,
                      );
                    })
                  ],
                  expandedHeight: 260,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(bottom: 16, left: 10),
                    stretchModes: const [StretchMode.zoomBackground],
                    collapseMode: CollapseMode.parallax,
                    expandedTitleScale: 2,
                    title: Stack(
                      children: [
                        // The text border
                        Text(
                          currentUser.name.toString(),
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.5
                              ..color = Color(0xff141E29),
                          ),
                        ),
                        // The text inside
                        Text(
                          currentUser.name.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    background: Hero(
                        tag: "",
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile_picture',
                                arguments: currentUser.photourl);
                          },
                          child: CachedNetworkImage(
                            imageUrl: currentUser.photourl.toString(),
                            fit: BoxFit.cover,
                          ),
                        )),
                    // background: Hero(
                    //   tag: "p-${widget.index}",
                    //   child: Image.network(
                    //     url,
                    //     //fit: BoxFit.cover,
                    //   ),
                    // ),
                  ),
                ),
                // SliverPersistentHeader(
                //   floating: true,
                //   delegate: _SliverAppBarDelegate(
                //     minHeight: 100,
                //     maxHeight: 60,
                //     child: Container(
                //       height: 60,
                //       color: Color(0xff141E29),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: ElevatedButton(
                //               onPressed: () {
                //                 setState(() {
                //                   _isloading = true;
                //                 });
                //                 _load().then((value) {
                //                   setState(() {
                //                     _isloading = false;
                //                   });
                //                 });
                //               },
                //               child: _isloading
                //                   ? Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceAround,
                //                       children: [
                //                         Text("Add"),
                //                         SizedBox(
                //                           width: 10,
                //                         ),
                //                         Container(
                //                           height: 10,
                //                           width: 10,
                //                           child: CircularProgressIndicator(
                //                             color: Colors.white,
                //                             strokeWidth: 1.0,
                //                           ),
                //                         )
                //                       ],
                //                     )
                //                   : Text("Add"),
                //               style: ElevatedButton.styleFrom(
                //                 shape: new RoundedRectangleBorder(
                //                   borderRadius:
                //                       new BorderRadius.circular(30.0),
                //                 ),
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (BuildContext context, int index){
                //       return Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child: Container(
                //           height: 40,
                //           color: Colors.amber,
                //         ),
                //       );
                //     }
                //   ),
                // )
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 40,
                    maxHeight: 40,
                    child: Material(
                      child: Consumer(
                          builder: (context, ThemeModel themeNotifier, child) {
                        return Container(
                            color: themeNotifier.isDark
                                ? ThemeConstants().darkBg
                                : Colors.white30,
                            child: TabBar(
                              controller: _tabController,
                              tabs: const [
                                Tab(
                                  child: Text(
                                    'Posts',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Friends',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'About',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              ],
                            ));
                      }),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                Center(
                  child: Text("Posts"),
                ),
                ListView.builder(
                  itemCount: 51,
                  itemBuilder: (context, index) => ListTile(
                    title: Text("Flutter-${index}"),
                  ),
                ),
                Center(
                  child: Text("About"),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
//lib\pages\profile\view\profile_page.dart

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Future _load() async {
  await Future.delayed(Duration(seconds: 3));
}
