import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;
  final String tag;

  const FullScreenImage({super.key, required this.imageUrl, required this.tag});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  void initState() {
    getAllDataMain(name: 'Full_Screen_Image_View_Page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: widget.tag == "PreviewPage"
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Container(
                    height: 20,
                    width: 20,
                    margin: const EdgeInsets.only(top: 30, left: 20),
                    decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                    child: const Center(
                        child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ))),
              ),
      ),
      body: Center(
        child: Hero(
          tag: widget.tag,
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
            imageUrl: widget.imageUrl,
          ),
        ),
      ),
    );
  }
}
