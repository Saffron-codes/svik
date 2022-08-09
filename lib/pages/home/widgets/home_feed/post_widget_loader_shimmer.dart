import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class PostWidgetShimmer extends StatelessWidget {
  const PostWidgetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(50, 48, 48, 48),
      highlightColor: Colors.grey[500]!,
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        color: Color.fromARGB(50, 48, 48, 48),
        child: Container(
          height: 300,
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 8,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(28.0),
                child: Container(
                  height: 200,
                  width: 600,
                  color: Colors.white54,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 8,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
