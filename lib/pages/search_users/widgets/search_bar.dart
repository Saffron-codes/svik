import 'package:chatapp/config/pallete.dart';
import 'package:chatapp/providers/search_user_provider/search_user_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchUserProvider>(
      builder: (BuildContext context, model, Widget? child) {
        return CupertinoSearchTextField(
          placeholder: "Search of Friends",
          borderRadius: BorderRadius.circular(16),
          style: TextStyle(color: Color(0xffA3A0AC)),
          autofocus: true,
          onChanged: (val){
            model.setsearch(val);
            print(model.getsearch);
          },
          prefixIcon: Icon(EvaIcons.search, color: Palette.kToDark.shade600),
          suffixIcon: Icon(EvaIcons.closeCircleOutline,
              color: Palette.kToDark.shade600),
        );
      },
    );
  }
}
