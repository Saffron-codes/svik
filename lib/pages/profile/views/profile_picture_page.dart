import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ProfilePicturePage extends StatefulWidget {
  final String src;
  const ProfilePicturePage({Key? key, required this.src}) : super(key: key);

  @override
  State<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  Color bgColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    final imagesrc = widget.src;
    return FutureBuilder<PaletteGenerator>(
      future: _updatePaletteGenerator(imagesrc),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 80,
              child: LinearProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Icon(Icons.error,color: Colors.grey,),
          );
        } else {
          bgColor = snapshot.data!.dominantColor!.color;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: bgColor,
            body: InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(imageUrl: imagesrc,),
              ),
            ),
          );
        }
      },
    );
  }

  Future<PaletteGenerator> _updatePaletteGenerator(src) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(Image.network(src).image);
    return paletteGenerator;
  }
}
