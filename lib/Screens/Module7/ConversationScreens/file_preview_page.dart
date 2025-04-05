import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';

import '../../Module6/BillBoardCommonFunctions/bill_board_widgets.dart';

class FilePreviewPage extends StatefulWidget {
  final List<FileElement> data;

  const FilePreviewPage({Key? key, required this.data}) : super(key: key);

  @override
  State<FilePreviewPage> createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> {
  bool loader = false;
  int selectedIndex = 1;
  PageController page = PageController();
  List<ChewieController> cvControllerList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i].fileType == "video") {
        cvControllerList.add(await functionsMain.getVideoPlayer(
          url: widget.data[i].file,
        ));
      } else {
        cvControllerList.add(await functionsMain.getVideoPlayer(
          url: widget.data[i].file,
        ));
      }
    }
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black26,
      body: loader
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Text(
                          "Files",
                          style: TextStyle(color: Colors.white, fontSize: text.scale(18)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width / 16.44),
                      child: Text(
                        "$selectedIndex in ${widget.data.length} Files",
                        style: TextStyle(color: Colors.white, fontSize: text.scale(14)),
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: Center(
                  child: PageView.builder(
                      controller: page,
                      physics: const ScrollPhysics(),
                      itemCount: widget.data.length,
                      onPageChanged: (value) {
                        selectedIndex = value + 1;
                        for (int i = 0; i < cvControllerList.length; i++) {
                          if (cvControllerList[i].isPlaying) {
                            cvControllerList[value].pause();
                          }
                        }
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return widget.data[index].fileType == "video"
                            ? billboardWidgetsMain.getVideoPlayer(
                                cvController: cvControllerList[index],
                                heightValue: height / 3.85,
                                widthValue: width,
                              )
                            : widget.data[index].fileType == "image"
                                ? FullScreenImage(
                                    imageUrl: widget.data[index].file,
                                    tag: 'PreviewPage',
                                  )
                                : widget.data[index].fileType == "audio"
                                    ? AudioMainPreview(
                                        url: widget.data[index].file,
                                        isBeforeSending: false,
                                      )
                                    : widget.data[index].fileType == "doc"
                                        ? PDFViewerFromUrl(
                                            url: widget.data[index].file,
                                          )
                                        : const Text(
                                            "Not a video",
                                            style: TextStyle(color: Colors.white),
                                          );
                      }),
                ))
              ],
            )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
    ));
  }
}

class AudioMainPreview extends StatefulWidget {
  final String url;
  final bool isBeforeSending;

  const AudioMainPreview({Key? key, required this.url, required this.isBeforeSending}) : super(key: key);

  @override
  State<AudioMainPreview> createState() => _AudioMainPreviewState();
}

class _AudioMainPreviewState extends State<AudioMainPreview> {
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  int totalTime = 1;
  RxInt currentTime = 0.obs;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await player.setUrl(widget.url);
    totalTime = (player.duration ?? Duration.zero).inSeconds;
    currentTime.value = (Duration.zero).inSeconds;
    setState(() {});
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: height / 4.33,
          width: width / 1.17,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              image: DecorationImage(image: AssetImage("lib/Constants/Assets/BillBoard/Subtractlatest.png"), fit: BoxFit.fill)),
        ),
        Container(
          height: height / 14.43,
          width: width / 1.17,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (player.playing) {
                      player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      setState(() {
                        isPlaying = true;
                        isLoading = true;
                      });
                      if (currentTime.value == 0) {
                        await player.setUrl(widget.url);
                        totalTime = player.duration!.inSeconds;
                        currentTime.value = (Duration.zero).inSeconds;
                      }
                      player.play();
                      isLoading = false;
                      player.positionStream.listen((event) {
                        if (event != player.duration) {
                          currentTime.value = event.inSeconds;
                        } else if (event == player.duration) {
                          player.pause();
                          player.seek(Duration.zero);
                          currentTime.value = 0;
                          totalTime = player.duration!.inSeconds;
                          isPlaying = false;
                        } else {
                          player.pause();
                          player.seek(Duration.zero);
                          currentTime.value = 0;
                          totalTime = player.duration!.inSeconds;
                          isPlaying = false;
                        }
                        setState(() {});
                      });
                    }
                  },
                  child: Container(
                    width: width / 6.85,
                    height: height / 14.43,
                    decoration: BoxDecoration(
                        color: const Color(0XFF0EA102).withOpacity(0.8),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), topRight: Radius.circular(15))),
                    child: Center(
                      child: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    isLoading
                        ? Shimmer.fromColors(
                            enabled: true,
                            baseColor: Colors.white,
                            highlightColor: Colors.grey.withOpacity(0.5),
                            direction: ShimmerDirection.ltr,
                            child: Container(
                              height: height / 14.43,
                              width: width / 1.44,
                              color: const Color(0XFF0EA102).withOpacity(0.1),
                              foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: AssetImage("lib/Constants/Assets/BillBoard/Subtractlatest.png"),
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          )
                        : Container(
                            height: height / 14.43,
                            width: width / 1.44,
                            padding: const EdgeInsets.all(5),
                            foregroundDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  image: AssetImage("lib/Constants/Assets/BillBoard/Subtractlatest.png"),
                                  fit: BoxFit.fill,
                                )),
                            child: Obx(() => LinearProgressIndicator(
                                  value: (currentTime.value) / totalTime,
                                  color: Colors.green /*Color(0XFF0EA102)*/,
                                  backgroundColor: Colors.green.withOpacity(0.5),
                                )),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
