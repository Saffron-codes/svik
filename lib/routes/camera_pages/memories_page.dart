import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MemoriesPage extends StatefulWidget {
  const MemoriesPage({Key? key}) : super(key: key);

  @override
  _MemoriesPageState createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  MethodChannel platform = MethodChannel("com.javesindia/channels");
  List<String> images = [];
  final Directory _photoDir = Directory('/storage/emulated/0/Pictures/');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text("Memos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.9
          ),
          itemCount: images.length,
          itemBuilder: (ctx, idx) {
            //print(File(imagelist[idx]).path.split('/').last);
            return GestureDetector(
              onTap: (){
                //data_img[0] = images[idx];
                Navigator.pushNamed(context, '/memo_view',arguments: {"images":images,"index":images.indexOf(images[idx])});
              },
              child: Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(images[idx])),
                      fit: BoxFit.fitWidth
                      )
                  ),
                )
              ),
            );
                
          },
        ),
      ),
    );
  }

  Future<void> getImages() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final _filelist = directory.listSync(followLinks: false,recursive: false);
    _filelist.forEach((element) {
      if(element.path.endsWith("jpg")){
        setState(() {
          images.add(element.path);
          // images = images.reversed.toList();
        });
      }
      
    });
    print(images);
    //return directory;
    ///data/user/0/com.javesindia.chatbro/cache/CAP3204161973529892242.jpg
    ////data/user/0/com.javesindia.chatbro/app_flutter
}
}
