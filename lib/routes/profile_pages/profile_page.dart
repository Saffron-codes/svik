import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/widgets/bottom_sheets/friends_list_sheet.dart';
import 'package:chatapp/widgets/dialogs/no_friend_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //late Future<List<Friend>> friend_load;

  @override
  void initState() {
    //getFriends(friend);
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    Friend friend = ModalRoute.of(context)!.settings.arguments as Friend;
    
    return StreamProvider<List<Friend>>(
      create: (context) => FirestoreServices().getFriends(friend.uid),
      initialData: [],
      child: SafeArea(
        child: Material(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: CustomAppBar(expandedHeight: 170, friend: friend),
              ),
              // SliverGrid(
              //   delegate: SliverChildBuilderDelegate((context, index) {
              //     return Container(
              //       color: Colors.amber,
              //     );
              //   }, childCount: 20),
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     mainAxisSpacing: 15,
              //     crossAxisSpacing: 15,
              //     childAspectRatio: 2.0,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends SliverPersistentHeaderDelegate{
  final double expandedHeight;
  final Friend friend;
  CustomAppBar({required this.expandedHeight, required this.friend});

  
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //print((1 - shrinkOffset / expandedHeight));
    //print(friends);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.grey,
        ),
        //the flexible animated appbar
        AppBar(
          backgroundColor: Color(0xff13202D),
          automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: [
              //animated back button
              Positioned(
                top: 3,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back,color: Color(0xffD8D8D8),)),
              ),
              //the animated profile
              Positioned(
                top: (1 - shrinkOffset / expandedHeight) <= 0.6662545433656402
                    ? 6
                    : expandedHeight / 2.6 - shrinkOffset * 1.1,
                left: (1 - shrinkOffset / expandedHeight) <= 0.6662545433656402
                    ? 60
                    : expandedHeight / 1.1 - shrinkOffset * 1.7,
                child: Opacity(
                  opacity:
                      (1 - shrinkOffset / expandedHeight) <= 0.6662545433656402
                          ? 1.0
                          : (1 - shrinkOffset / expandedHeight),
                  child: CircleAvatar(
                    radius: (1 - shrinkOffset / expandedHeight) <=
                            0.6662545433656402
                        ? 20
                        : (1 - shrinkOffset / expandedHeight) * 40,
                    backgroundImage: NetworkImage(friend.photourl),
                  ),
                ),
              ),
              //the animated display name
              Positioned(
                top: (1 - shrinkOffset / expandedHeight) <= 0.8224758209391703
                    ? 10
                    : expandedHeight / 4.6 - shrinkOffset * 0.7,
                left: friend.name.length <=14?friend.name.length<=5?165:145:110,
                //right: MediaQuery.of(context).size.width / 4,
                child: Opacity(
                  opacity:
                      (1 - shrinkOffset / expandedHeight) <= 0.8758055335060152
                          ? 1.0
                          : (1 - shrinkOffset / expandedHeight),
                  child: Text(
                    friend.name.length>=20?"${friend.name.substring(0,15)}....":friend.name.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color(0xffD8D8D8)),
                  ),
                ),
              ),
              //friends list count widget
              Positioned(
                top: 120,
                left: 10,
                child: Opacity(
                  opacity: (1 - shrinkOffset / expandedHeight),
                  child: Consumer<List<Friend>>(
                    builder:(context,value,child)=> InkWell(
                      onTap: () {
                        value.length>0?showFriendsSheet(context, value):showNoFriendDialog(context);
                      },
                      child: Column(
                        children: [
                          Text("Friends",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15,color: Color(0xffD8D8D8))),
                          Text(value.length.toString(),style: chatTextName,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // FutureBuilder(
              //     future: FirestoreServices().getFriends(friend.uid),
              //     builder: (context, AsyncSnapshot snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {}
              //       return Positioned(
              //         top: 120,
              //         left: 10,
              //         child: Opacity(
              //           opacity: (1 - shrinkOffset / expandedHeight),
              //           child: Column(
              //             children: [
              //               Text("Friends",
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.bold, fontSize: 15)),
              //               Text(snapshot.data.length.toString())
              //             ],
              //           ),
              //         ),
              //       );
              //     }),
              //Message button
              Positioned(
                  top: expandedHeight / 1.5 - shrinkOffset,
                  right: 49,
                  child: Opacity(
                    opacity: (1 - shrinkOffset / expandedHeight) <=
                            0.36265196774732344
                        ? 0.0
                        : (1 - shrinkOffset / expandedHeight),
                    child: IconButton(
                      icon: Icon(Icons.chat_bubble_outline,color: Color(0xffD8D8D8),),
                      onPressed: () => null,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}




// return Material(
//       child: Stack(
//         children: [
//           Container(
//             color: Colors.blue,
//           ),
//           Positioned(
//             height: MediaQuery.of(context).size.height/1.5,
//             width: MediaQuery.of(context).size.width,
//             bottom: 0,
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
//               child: ListView(
//                 padding: EdgeInsets.all(25),
//                 children: [
//                   SizedBox(height: 70,),
//                   Row(
//                     children: [
//                       SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 70,
//             left: 30,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(names[0],style: TextStyle(fontSize: 40),),
//                 SizedBox(height: 20,),
//                 Text(names[1],style: TextStyle(fontSize: 40),)
//               ],
//             ),
//           ),
//           Positioned(
//             top: 220,
//             left: 30,
//             child:ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Image.network(friend.photourl),
//             )
//           )
//         ],
//       ),
//     );