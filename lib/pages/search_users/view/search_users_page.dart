import 'package:chatapp/config/pallete.dart';
import 'package:chatapp/pages/search_users/widgets/search_bar.dart';
import 'package:chatapp/pages/search_users/widgets/search_result_list.dart';
import 'package:chatapp/providers/search_user_provider/search_user_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>SearchUserProvider(),
      builder: (context,child) {
        return NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 80,
                elevation: 0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 10, right: 10),
                    title: SearchBar()),
              )
            ];
          },
          body: SearchResult(),
        );
      }
    );
  }
}
