import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chatapp/camera_provider/camera_provider.dart';
import 'package:chatapp/firebase_services/firebasestorage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraPage({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver  {
  late CameraController controller;
  int camera_state = 0;
  double scale = 0;
  var image = "";

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    final camera_provider = context.read<CameraServices>();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    initialize_camera(camera_provider.camerastate);
    getImages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
        initialize_camera(camera_state);
    }else if(state == AppLifecycleState.paused){
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final camera_provider = Provider.of<CameraServices>(context);
    final storage_services = context.watch<FirebaseStorageServices>();
    if (!controller.value.isInitialized) {
      return Container();
    }
    scale = 1 / (controller.value.aspectRatio * MediaQuery.of(context).size.aspectRatio);
    //print(scale);
    return Material(
      child: Stack(
        children: [
        Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: (){
              if (camera_state == 1)
                  camera_state = 0;
                else
                  camera_state = 1;
                camera_provider.change_camera(camera_state);
                initialize_camera(camera_state);
            },
            onScaleStart: (ScaleStartDetails details){
              _baseScale = _currentScale;
            },
            onScaleUpdate:_handleScaleUpdate,
                child: Transform.scale(
                  scale: scale,
                  child: CameraPreview(controller),
                ),
              ),
            ),
          Positioned(
              left: 10,
              top: 20,
              child: IconButton(
                  onPressed: ()=>Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ))),

          Positioned(
              left: 10,
              bottom: 50,
              child: IconButton(
                  onPressed: () {
                    if (camera_state == 1)
                  camera_state = 0;
                else
                  camera_state = 1;
                camera_provider.change_camera(camera_state);
                initialize_camera(camera_state);
                  },
                  icon: Icon(
                    Icons.camera_front,
                    color: Colors.white,
                  ))),
          Positioned(
            bottom: 50,
            left: 180,
            child: GestureDetector(
              onTap: ()async{
                XFile file  = await controller.takePicture();
                getImages();
                storage_services.change_file(file.path);
      Navigator.pushNamed(context, '/story_upload',arguments: storage_services.file!.path);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 50,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/memories');
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
              },
              child: camera_provider.last_image.isNotEmpty?ClipOval(
                child: Image.file(
                  File(camera_provider.last_image),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ):CircleAvatar()
              // Container(
              //   height: 50,
              //   width: 50,
              //   decoration: camera_provider.last_image.isNotEmpty?BoxDecoration(
              //     image: DecorationImage(image: FileImage(File(camera_provider.last_image)))
              //   ):BoxDecoration(color: Colors.white)
              // ),
            ),
          )
        ],
      ),
    );
  }

  initialize_camera(int index) {
    controller = CameraController(
        widget.cameras[index],
        ResolutionPreset.veryHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.unknown);
    controller.unlockCaptureOrientation();
    controller.initialize().then((value) => null).then((_) {
      controller
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value);
        controller
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value);
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> getImages() async {
    final camera_provider = context.read<CameraServices>();
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final _filelist = directory.listSync(followLinks: false, recursive: true);
    if(_filelist.last.path.endsWith("jpg") || _filelist.last.path.endsWith("png")){
      camera_provider.change_last_image(_filelist.last.path);
    }
    // setState(() {
    //   image = _filelist.last.path;
    // });
    //camera_provider.change_last_image(_filelist.last.path);
    //return directory;
    ///data/user/0/com.javesindia.chatbro/cache/CAP3204161973529892242.jpg
    ////data/user/0/com.javesindia.chatbro/app_flutter
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);
    print(_minAvailableZoom);
    setState(() {
      scale = 2.0;
    });
    setState(() {});
  }
}
