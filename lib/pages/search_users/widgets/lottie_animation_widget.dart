import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatefulWidget {
  const LottieAnimationWidget({ Key? key }) : super(key: key);

  @override
  State<LottieAnimationWidget> createState() => _LottieAnimationWidgetState();
}

class _LottieAnimationWidgetState extends State<LottieAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      "assets/search_user.json",
      width: 140,
      height: 140,
    );
  }
}