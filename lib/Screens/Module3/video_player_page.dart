import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String url;

  const VideoPlayerPage({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late ChewieController cvController;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    _controller.initialize();
    cvController = ChewieController(videoPlayerController: _controller, aspectRatio: 1.777, allowedScreenSleep: false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    cvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Center(
            child: Container(
              height: 220,
              width: 390,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.hardEdge,
              child: Chewie(
                controller: cvController,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
