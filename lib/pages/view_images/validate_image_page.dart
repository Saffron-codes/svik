import 'dart:io';
import 'package:chatapp/providers/edit_image_provider/edit_image_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../config/theme/theme_constants.dart';

class ValidateImagePage extends StatefulWidget {
  final String imagePath;
  const ValidateImagePage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<ValidateImagePage> createState() => _ValidateImagePageState();
}

class _ValidateImagePageState extends State<ValidateImagePage> {
  String _imagePath = "";
  CroppedFile? croppedFile;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditImageProvider>(
        builder: (context, editImageProvider, child) {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Color(0x44000000),
            elevation: 0,
            leading: CupertinoButton(
              child: Icon(
                EvaIcons.arrowBack,
                color: Colors.grey[300],
              ),
              onPressed: () => Navigator.pop(
                context,
              ),
            ),
            actions: [
              CupertinoButton(
                child: Icon(
                  EvaIcons.crop,
                  color: Colors.grey[300],
                ),
                onPressed: () => cropImage(widget.imagePath, editImageProvider),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 36, 147, 221),
            // icon: Icon(EvaIcons.chevronRight),
            label: Row(
              children: const [Text("Continue"), Icon(EvaIcons.chevronRight)],
            ),

            onPressed: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                ),
                context: context,
                builder: (context) => Wrap(
                  children: [
                    ListTile(
                      iconColor: Color(0xffD8D8D8),
                      textColor: Color(0xffD8D8D8),
                      leading: Icon(EvaIcons.camera),
                      title: Text("Post"),
                      onTap: ()=>Navigator.pushNamed(context, '/upload_post')
                    ),
                    ListTile(
                      iconColor: Color(0xffD8D8D8),
                      textColor: Color(0xffD8D8D8),
                      leading: Icon(EvaIcons.image),
                      title: Text("Story"),
                      onTap: () {
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          body: Stack(
            children: [
              Consumer<EditImageProvider>(
                  builder: (context, editImageProvider, child) {
                return InteractiveViewer(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: FileImage(
                      File(editImageProvider.getImagePath ?? widget.imagePath),
                    ),
                    fit: BoxFit.contain,
                  )),
                ));
              }),
              // SizedBox(
              //   // height: 60,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Spacer(),
              //       CupertinoButton(
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: ThemeConstants().themeBlueColor,
              //               borderRadius: BorderRadius.circular(12)),
              //           height: 40,
              //           width: 100,
              //           child: Center(
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: const [
              //                 Text("Done"),
              //                 Icon(EvaIcons.chevronRight)
              //               ],
              //             ),
              //           ),
              //         ),
              //         onPressed: () {},
              //       ),
              //     ],
              //   ),
              // )
            ],
          ));
    });
  }

  void cropImage(String path, EditImageProvider editImageProvider) async {
    // var logger = Logger(
    //   printer: PrettyPrinter(),
    // );
    // var loggerNoStack = Logger(
    //   printer: PrettyPrinter(methodCount: 0),
    // );
    croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        // aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
        // cropStyle: CropStyle.,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Profile",
            toolbarColor: ThemeConstants().chatPageBg,
            toolbarWidgetColor: ThemeConstants().themeBlueColor,
            // hideBottomControls: true,
            showCropGrid: true,
            //initAspectRatio: CropAspectRatioPreset.ratio5x4
          )
        ]);

    editImageProvider.setImagePath = croppedFile!.path;

    // loggerNoStack.i(croppedFile!.path);
    // loggerNoStack.i(_imagePath);
  }
}
