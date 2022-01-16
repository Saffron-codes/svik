import 'package:chatapp/firebase_services/firestore_services.dart';
import 'package:chatapp/models/friend_model.dart';
import 'package:chatapp/models/search_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _search = TextEditingController();
  String searchquery = "";
  @override
  Widget build(BuildContext context) {
    List<SearchUser> searchresult = Provider.of<List<SearchUser>>(context);
    //List<Friend> friendslist = Provider.of<List<Friend>>(context);
    List<SearchUser> output = searchresult
        .where((item) => item.keywords.contains(searchquery))
        .toList();
    return StreamProvider<List<Friend>>.value(
      value: FirestoreServices().friendslist,
      initialData: [],
      child: Scaffold(
          appBar: AppBar(
              title: CupertinoSearchTextField(
            itemColor: Colors.black,
            controller: _search,
            onChanged: (value) {
              setState(() {
                searchquery = value;
              });
            },
          )),
          body: output.length != 0
              ? SearchList(
                  getdata: output,
                )
              : Center(
                  child: _search.text != ""
                      ? Text(
                          "🗑️No results",
                          style: TextStyle(fontSize: 30),
                        )
                      : Text(
                          " 🔍 Search for users",
                          style: TextStyle(fontSize: 30),
                        ))),
    );
  }
}

class SearchList extends StatefulWidget {
  final List<SearchUser> getdata;
  const SearchList({Key? key, required this.getdata}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    List<Friend> friendslist = Provider.of<List<Friend>>(context);
    final isfriendadded = Provider.of<FirestoreServices>(context);
    List<SearchUser> output = widget.getdata;
    int test = 0;
    //output.removeWhere((element) => friendslist.contains(element));
    return ListView.builder(
      itemCount: output.length,
      itemBuilder: (_, idx) {
        print(test);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(output[idx].photourl),
          ),
          title: Text(output[idx].name),
          // ignore: iterable_contains_unrelated_type
          trailing: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                print(output[idx].uid);
                FirestoreServices().addfriend(Friend(
                    Timestamp.now(),
                    output[idx].name,
                    output[idx].photourl,
                    "",
                    Timestamp.now(),
                    output[idx].keywords,
                    output[idx].uid
                    ));
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                  content:  Text('Added ${output[idx].name} as Friend'),
                  leading: const Icon(Icons.person),
                  actions: [
                    TextButton(
                        onPressed: () {}, child: const Text('Chat Now')),
                    TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                        },
                        child: const Text('Dismiss')),
                  ],
                ));
                //isfriendadded.added_friend(false);
              },
              icon: Icon(Icons.person_add_alt),
              label: Text("Add")),
        );
      },
    );
  }
}
