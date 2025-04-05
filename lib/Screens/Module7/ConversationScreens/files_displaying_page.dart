import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/file_preview_page.dart';

class FilesDisplayingPage extends StatefulWidget {
  final String fileType;

  const FilesDisplayingPage({Key? key, required this.fileType}) : super(key: key);

  @override
  State<FilesDisplayingPage> createState() => _FilesDisplayingPageState();
}

class _FilesDisplayingPageState extends State<FilesDisplayingPage> {
  bool loader = false;
  List<FileElement> data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    data.clear();
    await conversationApiMain.getDocumentsList(
        type: "private", userId: mainVariables.conversationUserData.value.userId, groupId: "", docType: widget.fileType, skip: "0", limit: "100");
    for (int i = 0; i < mainVariables.getDocument!.value.response.length; i++) {
      data.add(FileElement.fromJson(mainVariables.getDocument!.value.response[i].toJson()));
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            if (!mounted) {
              return;
            }
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.fileType == "doc"
              ? "Documents"
              : widget.fileType == "image"
                  ? "Images"
                  : widget.fileType == "video"
                      ? "Videos"
                      : widget.fileType == "audio"
                          ? "AudiosList"
                          : "",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: loader
          ? mainVariables.getDocument!.value.response.isNotEmpty
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                  child: widget.fileType == "image"
                      ? GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: height / 2.88),
                          itemCount: mainVariables.getDocument!.value.response.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => FilePreviewPage(
                                              data: data,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImage(
                                  imageUrl: mainVariables.getDocument!.value.response[index].file,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          })
                      : ListView.builder(
                          itemCount: mainVariables.getDocument!.value.response.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => FilePreviewPage(
                                              data: data,
                                            )));
                              },
                              child: Container(
                                height: height / 14.43,
                                width: width,
                                margin: EdgeInsets.only(
                                    top: index == 0 ? height / 57.73 : height / 108.25,
                                    bottom: index == mainVariables.getDocument!.value.response.length - 1 ? height / 57.73 : height / 108.25),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    widget.fileType == "video"
                                        ? const Icon(
                                            Icons.video_library,
                                            size: 30,
                                          )
                                        : widget.fileType == "audio"
                                            ? const Icon(
                                                Icons.multitrack_audio,
                                                size: 30,
                                              )
                                            : widget.fileType == "doc"
                                                ? const Icon(
                                                    Icons.file_copy_outlined,
                                                    size: 30,
                                                  )
                                                : const Icon(Icons.add),
                                    SizedBox(
                                      width: width / 20.55,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(mainVariables.getDocument!.value.response[index].fileName),
                                        Text(
                                          mainVariables.getDocument!.value.response[index].createdAt,
                                          style: TextStyle(fontSize: text.scale(10), fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            );
                          }),
                )
              : Center(
                  child: Column(
                    children: [
                      SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'No users found',
                                style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
    ));
  }
}
