import 'package:chatapp/models/search_user_model.dart';
import 'package:chatapp/pages/search_users/widgets/lottie_animation_widget.dart';
import 'package:chatapp/pages/search_users/widgets/user_tile.dart';
import 'package:chatapp/providers/search_user_provider/search_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    List<SearchUser> searchresult = Provider.of<List<SearchUser>>(context);
    final providerModel = Provider.of<SearchUserProvider>(context);
    List<SearchUser> output = searchresult
        .where((item) => item.keywords.contains(providerModel.getsearch))
        .toList();
    return output.isNotEmpty
        ? ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: output.length,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            itemBuilder: (context, index) {
              return UserTile(user: output[index], isfriendalready: false);
            },
            separatorBuilder: (context, index) => Divider(),
          )
        : providerModel.searchquery.isEmpty
            ? Center(
                child: SvgPicture.asset(
                  "assets/svgs/search_screen.svg",
                  height: 180,
                  width: 180,
                )
              )
            : Center(
                child: Text("Oops!! No user 💩",style: TextStyle(color: Color(0xffA3A0AC),fontSize: 20)),
              );
  }
}
