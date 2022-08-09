import 'package:chatapp/pages/welcome/widgets/start_now_button.dart';
import 'package:chatapp/providers/theme_provider/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _titleStyleLight = TextStyle(fontSize: 56, fontWeight: FontWeight.bold);
  final _titleStyleDark = TextStyle(
      fontSize: 56, color: Colors.grey[300], fontWeight: FontWeight.bold);

  final _subtitleStyleDark = TextStyle(fontSize: 18, color: Colors.grey[500]);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return Consumer<ThemeModel>(builder: (context, model, child) {
      // if (mounted) {
      //   brightness == Brightness.dark
      //       ? model.isDark = true
      //       : model.isDark = false;
      // }
      return Scaffold(
        backgroundColor: model.isDark ? Color(0xFF202225) : null,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              // Lottie.network(
              //     "https://assets8.lottiefiles.com/packages/lf20_rst3usxp.json"),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  "assets/svgs/intro_screen.svg",
                  height: 400,
                  width: 400,
                ),
              ),
              // Spacer(),
              Text("Svik",style: _titleStyleDark,),
              // SizedBox(height: 5),

              Text("Let's  Get",
                  style: model.isDark ? _titleStyleDark : _titleStyleLight),
              Text("Started",
                  style: model.isDark ? _titleStyleDark : _titleStyleLight),
              // Text(
              //   "Connect with people who you like",
              //   style: _subtitleStyleDark,
              // ),
              // SizedBox(height: 10),
              Text(
                "Add Friends    Chat    Express",
                style: _subtitleStyleDark,
              ),
              SizedBox(height: 40),
              Center(child: StartNowButton()),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "Already have an account",
                    style: _subtitleStyleDark,
                  ),
                  SizedBox(height: 3),
                  CupertinoButton(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                      onPressed: () {})
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    });
  }
}
