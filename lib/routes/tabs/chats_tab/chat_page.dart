import 'package:chatapp/routes/tabs/chats_tab/sliver_scaffold.dart';
import 'package:flutter/material.dart';

class ChatsTabPage extends StatelessWidget {
  const ChatsTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: Color(0xfffcfcfc),
        child: SliverScaffold(
            body: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemCount: 5,
                itemBuilder: (_, __) => const SizedBox(
                      height: 100,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),
                    ))),
      ),
    );
  }
}
