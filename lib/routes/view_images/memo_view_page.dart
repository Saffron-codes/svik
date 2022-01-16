import 'dart:io';
import 'package:flutter/material.dart';

class MemoView extends StatefulWidget {
  const MemoView({
    Key? key,
  }) : super(key: key);

  @override
  _MemoViewState createState() => _MemoViewState();
}

class _MemoViewState extends State<MemoView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    List<String> images = arguments["images"];
    int initpage = arguments["index"];
    //print(arguments["index"]);
    _pageController = PageController(initialPage: initpage);
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      itemBuilder:(context, index) => Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        fit: StackFit.passthrough,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(images[index].toString())), fit: BoxFit.cover)),
          ),
          Positioned(
              top: 30,  
              left: 10,  
              child: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.close))),
          Positioned(
              top: 30,  
              right: 0,  
              child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border))),
          Positioned(
            bottom: 10,  
            right: 10,
            child: GestureDetector(
              onTap: (){},
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text("do something!"),
                    Icon(Icons.send,size: 15.0,)
                  ],
                ),
              ),
            )
          )
        ],
      ),),
    );
  }
}
