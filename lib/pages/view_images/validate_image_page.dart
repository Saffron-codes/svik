import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';

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
    _imagePath = widget.imagePath;

    return Scaffold(
        appBar: AppBar(
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
              onPressed: () => cropImage(_imagePath),
            )
          ],
        ),
        body: Column(
          children: [
            InteractiveViewer(
              child: Image.file(File(_imagePath)),
            ),
            SizedBox(
              // height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(),
                  CupertinoButton(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ThemeConstants().themeBlueColor,
                          borderRadius: BorderRadius.circular(12)),
                      height: 40,
                      width: 100,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Done"),
                            Icon(EvaIcons.chevronRight)
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void cropImage(String path) async {
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    var loggerNoStack = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );
    croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
        cropStyle: CropStyle.rectangle,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Profile",
            toolbarColor: ThemeConstants().chatPageBg,
            toolbarWidgetColor: ThemeConstants().themeBlueColor,
            hideBottomControls: true,
            showCropGrid: false,
            //initAspectRatio: CropAspectRatioPreset.ratio5x4
          )
        ]);
    setState(() {
      _imagePath = croppedFile!.path;
    });

    loggerNoStack.i(croppedFile!.path);
    loggerNoStack.i(_imagePath);
  }
}
