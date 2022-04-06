import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/bottomnavbar_provider/bottomnavbarprovider.dart';
import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/firebase_services/firebaseauth_services.dart';
import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/user_profile_provider/banner_color.dart';
import 'package:chatapp/widgets/upload_forms/edit_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Friend>>.value(
      initialData: [],
      value: FirestoreServices().friendslist,
      child:SafeArea(
          child: Material(
              child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverPersistentHeader(
                delegate: MySliverAppBar(expandedHeight: 170),
                pinned: true,
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Color(0xff141E29),
                      //color: Colors.teal[100 * (index % 9)],
                      child: Text('grid item $index'),
                    );
                  },
                  childCount: 20,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 2.0,
                ),
              ),
            ],
          )),
        )
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //print((1 - shrinkOffset / expandedHeight));
    UserModel currentUser = Provider.of<UserModel>(context);
    List<Friend> friendslist = Provider.of<List<Friend>>(context);
    //print(currentUser.name);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.grey,
        ),
        //the flexible animated appbar
        AppBar(
          flexibleSpace: Stack(
            children: [
              //the animated profile

              Positioned(
                top: 80,
                left: 100,
                child: CachedNetworkImage(
                  imageUrl: currentUser.photourl.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: (1 - shrinkOffset / expandedHeight) <= 0.49510674298128043
              //       ? 6
              //       : expandedHeight / 2.6 - shrinkOffset * 0.7,
              //   left: (1 - shrinkOffset / expandedHeight) <= 0.49510674298128043
              //       ? 10
              //       : expandedHeight / 1.1 - shrinkOffset * 1.7,
              //   child: Opacity(
              //     opacity:
              //         (1 - shrinkOffset / expandedHeight) <= 0.48235398562833964
              //             ? 1.0
              //             : (1 - shrinkOffset / expandedHeight),
              //             child: CachedNetworkImage(
              //   imageUrl: currentUser.photourl.toString(),
              //   imageBuilder: (context, imageProvider) => Container(
              //     height: 50,
              //     width: 50,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       image: DecorationImage(
              //         image: imageProvider,
              //       ),
              //     ),
              //   ),
              // ),
              //     // child: CircleAvatar(
              //     //   radius: (1 - shrinkOffset / expandedHeight) <=
              //     //           0.48235398562833964
              //     //       ? 20
              //     //       : (1 - shrinkOffset / expandedHeight) * 46,
              //     //   backgroundImage:
              //     //       NetworkImage(currentUser.photourl.toString()),
              //     // ),
              //   ),
              // ),
              //the animated display name
              Positioned(
                top: (1 - shrinkOffset / expandedHeight) <= 0.8224758209391703
                    ? 10
                    : expandedHeight / 4.6 - shrinkOffset * 0.7,
                left: currentUser.name!.length <=14?currentUser.name!.length<=5?165:145:110,
                right: MediaQuery.of(context).size.width / 4,
                child: Opacity(
                  opacity:
                      (1 - shrinkOffset / expandedHeight) <= 0.8758055335060152
                          ? 1.0
                          : (1 - shrinkOffset / expandedHeight),
                  child: Text(
                    currentUser.name.toString(),
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
                  child: Column(
                    children: [
                      Text("Friends",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15,color: Color(0xffD8D8D8))),
                      Text(friendslist.length.toString(),style: chatTextName,)
                    ],
                  ),
                ),
              ),
              //Message button
              // Positioned(
              //     top: expandedHeight / 1.5 - shrinkOffset,
              //     right: 49,
              //     child: Opacity(
              //       opacity: (1 - shrinkOffset / expandedHeight) <=
              //               0.36265196774732344
              //           ? 0.0
              //           : (1 - shrinkOffset / expandedHeight),
              //       child: IconButton(
              //         icon: Icon(Icons.chat_bubble_outline),
              //         onPressed: () => null,
              //       ),
              //     )),
                  Positioned(
                    top: expandedHeight / 1.5 - shrinkOffset,
                    right: 0,
                    child: Opacity(
                      opacity: (1 - shrinkOffset / expandedHeight) <=
                            0.36265196774732344
                        ? 0.0
                        : (1 - shrinkOffset / expandedHeight),
                        child: IconButton(
                onPressed: () => AuthService().signOut(),
                icon: Icon(Icons.logout_outlined),color: Color(0xff209EF1),)
                    ),
                  ),
                  Positioned(
          top: 22,
          right: 70,
          child: Opacity(
            opacity: shrinkOffset >= 0.6662545433656402
                ? 0.0
                : (1 - shrinkOffset / expandedHeight),
            child: IconButton(
              color: Color(0xff209EF1),
              onPressed: () {
                editUserSheet(context,currentUser);
              },
              icon: Icon(Icons.edit),
            ),
          ),
        ),
                  
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
