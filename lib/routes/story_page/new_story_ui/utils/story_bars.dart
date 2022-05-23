import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyStoryBars extends StatelessWidget {
  List<double> percentWatched = [];
  int storiescount = 0;

  MyStoryBars({required this.percentWatched, required this.storiescount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 60, left: 8, right: 8),
      child: Row(
        children: List<Widget>.generate(
          storiescount,
          (index) => Flexible(
            child: MyProgressBar(
              percentWatched: percentWatched[index],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProgressBar extends StatelessWidget {
  double percentWatched = 0;

  MyProgressBar({required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      //animation: true,
      barRadius: Radius.circular(10),
      lineHeight: 4,
      // /width: 20,
      percent: percentWatched,
      progressColor: Colors.grey[400],
      backgroundColor: Colors.grey[600],
    );
  }
}
