import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showFriendsSheet(BuildContext context, List<Friend> friends) {
  double screenHeight = MediaQuery.of(context).size.height;
  //print(screenHeight/1000-(friends.length/10));
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: friends.length/10>1?0.9:friends.length/14.5,
        builder: (context, scrollController) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            children: [
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 170),
              //   child: Container(
              //     color: Colors.grey,
              //     height: 3,
              //     width: 10,
              //   ),
              // ),
              Center(
                child: Container(
                  color: Colors.grey,
                  height: 3,
                  width: 35,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Friends",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 168),
              //   child: Text(
              //     "Friends",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
              //   ),
              // ),
              ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                itemCount: friends.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () => print(friends.length.toDouble() / 10),
                  title: Text(friends[index].name,style: chatTextName,),
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(friends[index].photourl),
                  // ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Image.network(
                      friends[index].photourl,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircleAvatar(
                          backgroundColor: Colors.grey,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                        );
                      },
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      );
    },
  );
}
