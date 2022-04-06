import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/constants/theme_constants.dart';
import 'package:chatapp/models/story.dart';
import 'package:chatapp/utils/convert_to_ago.dart';
import 'package:chatapp/widgets/touchable_opacity.dart';
import 'package:flutter/material.dart';

class ViewStory extends StatefulWidget {
  const ViewStory({Key? key}) : super(key: key);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  @override
  Widget build(BuildContext context) {
    final arguements = ModalRoute.of(context)!.settings.arguments as Map;
    List<Story> _stories = arguements["stories"];
    List<String> _profiles = arguements["profiles"];
    int _initialPageIndex = arguements["initialPageIndex"];
    PageController _pageController = PageController(initialPage: _initialPageIndex);
    return Material(
      child: PageView.builder(  
          controller: _pageController,
          itemCount: _stories.length,
          itemBuilder: (context, index) => GestureDetector(
                onTapDown: (details) {
                  var x = details.globalPosition.dx;
                  var y = details.globalPosition.dy;
                  // or user the local position method to get the offset
                  //print(details.localPosition);
                  //print("tap down " + x.toString() + ", " + y.toString());
                  if (x >= 300) {
                    if (index != _stories.length - 1) {
                      _pageController.animateToPage(index + 1,
                          duration: Duration(seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn);
                    } else if (index == _stories.length - 1) {
                      print("Last Story");
                      Navigator.pop(context);
                    }
                  } else if (x <= 83.6319247159091) {
                    if (index != 0) {
                      _pageController.animateToPage(index - 1,
                          duration: Duration(seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  }
                },
                // onTap: () {
                //   _pageController.animateToPage(index + 1,
                //               duration: Duration(seconds: 2),
                //               curve: Curves.fastLinearToSlowEaseIn);
                // },
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 44, left: 8),
                        child: Row(
                          children: [
                            // Container(
                            //   height: 32,
                            //   width: 32,
                            //   decoration: BoxDecoration(
                            //     image: DecorationImage(
                            //       image: NetworkImage(_profiles[index]),
                            //       fit: BoxFit.cover,
                            //     ),
                            //     shape: BoxShape.circle,
                            //   ),
                            // ),
                            CachedNetworkImage(
                              imageUrl: _profiles[index],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,

                                )),
                              ),
                              errorWidget: (context,url,error)=>Container(color: Colors.grey,),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              _stories[index].name,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              convertToAgo(_stories[index].time.toDate(),DateTime.now()),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      CachedNetworkImage(
                        imageUrl: _stories[index].url,
                        height: MediaQuery.of(context).size.height / 1.3,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff0181FF),
                          ),
                        ),
                        errorWidget: (context,url,error)=>Center(
                          child: TouchableOpacity(child: Icon(Icons.refresh_outlined,color: themeWhiteColor,),onTap: (){},),
                        ),
                      ),
                      //  Image.network(_stories[index].url,
                      //  height: MediaQuery.of(context).size.height/1.3,
                      //     loadingBuilder: (context, child, loadingProgress) {
                      //   if (loadingProgress == null) return child;
                      //   print(loadingProgress.cumulativeBytesLoaded /
                      //               loadingProgress.expectedTotalBytes!);
                      //   loadingProgress.cumulativeBytesLoaded /
                      //               loadingProgress.expectedTotalBytes! == 0.0?Center(
                      //                 child: CircularProgressIndicator(
                      //                   color: Color(0xff0181FF),
                      //                 ),
                      //               ):Center(
                      //     child: CircularProgressIndicator(
                      //       color: Color(0xff0181FF),
                      //       value: loadingProgress.expectedTotalBytes != null
                      //           ? loadingProgress.cumulativeBytesLoaded /
                      //               loadingProgress.expectedTotalBytes!
                      //           : null,
                      //     ),
                      //   );
                      //   return Center(
                      //     child: CircularProgressIndicator(
                      //       color: Color(0xff0181FF),
                      //       // value: loadingProgress.expectedTotalBytes != null
                      //       //     ? loadingProgress.cumulativeBytesLoaded /
                      //       //         loadingProgress.expectedTotalBytes!
                      //       //     : null,
                      //     ),
                      //   );
                      // }),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                // child: Stack(
                //   children: [
                //     Positioned.fill(
                //       child: Container(color: Colors.black),
                //     ),
                //     Positioned.fill(
                //       child: Image.network(_stories[index].url,
                //           fit: BoxFit.contain,
                //           loadingBuilder: (context, child, loadingProgress) {
                //         if (loadingProgress == null) return child;
                //         print(loadingProgress.cumulativeBytesLoaded /
                //                     loadingProgress.expectedTotalBytes!);
                //         loadingProgress.cumulativeBytesLoaded /
                //                     loadingProgress.expectedTotalBytes! == 0.0?Center(
                //                       child: CircularProgressIndicator(
                //                         color: Color(0xff0181FF),
                //                       ),
                //                     ):Center(
                //           child: CircularProgressIndicator(
                //             color: Color(0xff0181FF),
                //             value: loadingProgress.expectedTotalBytes != null
                //                 ? loadingProgress.cumulativeBytesLoaded /
                //                     loadingProgress.expectedTotalBytes!
                //                 : null,
                //           ),
                //         );
                //         return Center(
                //           child: CircularProgressIndicator(
                //             color: Color(0xff0181FF),
                //             // value: loadingProgress.expectedTotalBytes != null
                //             //     ? loadingProgress.cumulativeBytesLoaded /
                //             //         loadingProgress.expectedTotalBytes!
                //             //     : null,
                //           ),
                //         );
                //       }),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 44, left: 8),
                //       child: Row(
                //         children: [
                //           Container(
                //             height: 32,
                //             width: 32,
                //             decoration: BoxDecoration(
                //               image: DecorationImage(
                //                 image: NetworkImage(_profiles[index]),
                //                 fit: BoxFit.cover,
                //               ),
                //               shape: BoxShape.circle,
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 8,
                //           ),
                //           Text(
                //             _stories[index].name,
                //             style: TextStyle(
                //               fontSize: 17,
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text(convertToAgo(_stories[index].time.toDate()),
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 12,
                //                   inherit: true,
                //                   shadows: const[
                //                     Shadow(
                //                         // bottomLeft
                //                         offset: Offset(-0.7, -0.7),
                //                         color: Colors.black),
                //                     Shadow(
                //                         // bottomRight
                //                         offset: Offset(0.7, -0.7),
                //                         color: Colors.black),
                //                     Shadow(
                //                         // topRight
                //                         offset: Offset(0.7, 0.7),
                //                         color: Colors.black),
                //                     Shadow(
                //                         // topLeft
                //                         offset: Offset(-0.7, 0.7),
                //                         color: Colors.black),
                //                   ])),
                //         ],
                //       ),
                //     )
                //   ],
                // ),
              )),
    );
  }
}
