import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatapp/enums/camera_page_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/upload_profile_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final CameraPickMode pickmode;
  const CameraPage({Key? key, required this.cameras, required this.pickmode})
      : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late CameraController controller;
  int camIndx = 0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      startCam(camIndx);
      //initialize_camera(camera_state);
    } else if (state == AppLifecycleState.paused) {
      controller.dispose();
    }
  }

  @override
  void initState() {
    startCam(camIndx);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Color(0xff202225)));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadProfileService = Provider.of<UploadProfile>(context,listen: true);
    return Material(
      child: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Listener(
            onPointerDown: (_) => _pointers++,
            onPointerUp: (_) => _pointers--,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: CameraPreview(
                controller,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onScaleStart: _handleScaleStart,
                    onScaleUpdate: _handleScaleUpdate,
                    onDoubleTap: () {
                      if (camIndx == 0) {
                        setState(() {
                          camIndx = 1;
                        });
                      } else {
                        setState(() {
                          camIndx = 0;
                        });
                      }
                      startCam(camIndx);
                    },
                    onTapDown: (TapDownDetails details) =>
                        onViewFinderTap(details, constraints),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: GestureDetector(
                onTap: () {
                  if (camIndx == 0) {
                    setState(() {
                      camIndx = 1;
                    });
                  } else {
                    setState(() {
                      camIndx = 0;
                    });
                  }
                  startCam(camIndx);
                },
                child: Icon(
                  Icons.flip_camera_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2.5,
            child: GestureDetector(
              onTap: () async {
                XFile _pic = await controller.takePicture();
                File _picture = File(_pic.path);
                if (widget.pickmode == CameraPickMode.fromProfile) {
                  uploadProfileService.imageFromCamera(context, _picture.path);
                }else if(widget.pickmode == CameraPickMode.fromHome){
                  uploadProfileService.imageFromHome(context, _picture.path);
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void startCam(int camIndx) async {
    controller = CameraController(
        widget.cameras[camIndx], ResolutionPreset.ultraHigh,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
    controller.unlockCaptureOrientation();
    controller.setFocusMode(FocusMode.auto);
    try {
      controller.initialize().then((_) {
        controller
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value);
        controller
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value);
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } on CameraException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Alert"),
          content: Text("Error accessing camera"),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (controller == null || _pointers != 2) {
      return;
    }
    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller.setZoomLevel(_currentScale);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void takePic(UploadProfile profileProvider) async {
    CameraPickMode _mode = widget.pickmode;
    try {
      // final Directory path = await getApplicationDocumentsDirectory();
      XFile _pic = await controller.takePicture();
      File _picture = File(_pic.path);
      if (_mode == CameraPickMode.fromProfile) {
        // profileProvider.imageFromCamera(context, _picture.path);
        // profileProvider.changeImagePath(_picture.path);
        profileProvider.chooseImage();
        print(_picture.path);
        //showDialog(context: context, builder:(context)=>AlertDialog(title: Text(_mode.toString()),));
      }
      //showDialog(context: context, builder: (context)=>Text(_pic.path));
    } catch (e) {
      print(e);
    }
    //navigate to new page
  }
}
