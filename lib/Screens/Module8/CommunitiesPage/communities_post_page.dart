import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:river_player/river_player.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/profile_data_model.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module3/video_player_page.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_list_page_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_page_initial_model.dart';

class CommunitiesPostPage extends StatefulWidget {
  final String communityId;
  final PostContent? postDetails;

  const CommunitiesPostPage({super.key, required this.communityId, this.postDetails});

  @override
  State<CommunitiesPostPage> createState() => _CommunitiesPostPageState();
}

class _CommunitiesPostPageState extends State<CommunitiesPostPage> {
  bool releaseLoader = false;
  bool loader = false;
  FocusNode titleFocus = FocusNode();
  RxList<CommunityFileElement> fileList = RxList<CommunityFileElement>([]);
  File? pickedImage;
  File? pickedVideo;
  File? pickedFile;
  String selectedUrlType = "";
  late BetterPlayerController _betterPlayerController;
  FilePickerResult? doc;
  List<File> file1 = [];
  late ProfileDataModel profile;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    mainVariables.messageControllerMain.value.clear();
    profile = await settingsMain.getData();
    mainVariables.messageControllerMain.value.text = widget.postDetails == null ? "" : widget.postDetails!.title.value;
    fileList = widget.postDetails == null ? RxList<CommunityFileElement>([]) : widget.postDetails!.files;
    mainVariables.userNameMyselfMain = profile.response.username;
    mainVariables.firstNameMyselfMain = profile.response.firstName;
    mainVariables.lastNameMyselfMain = profile.response.lastName;
    mainVariables.believersCountMainMyself.value = profile.response.believedCount;
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              toolbarHeight: height / 10.68,
              automaticallyImplyLeading: false,
              elevation: 10,
              title: SizedBox(
                width: width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontSize: text.scale(14), color: const Color(0XFFB0B0B0), fontWeight: FontWeight.w500, fontFamily: "Poppins")),
                        ),
                      ),
                      Center(
                        child: Text("Byte", style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700, fontFamily: "Poppins")),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                logEventFunc(name: 'community_post_Complete', type: "Community");
                                List<Map<String, dynamic>> filesMapList = List.generate(
                                    fileList.length, (index) => {"file": fileList[index].file.value, "file_type": fileList[index].fileType.value});
                                communitiesFunctions.getCommunityPost(data: {
                                  "title": mainVariables.messageControllerMain.value.text,
                                  "community_id": widget.communityId,
                                  "files": filesMapList,
                                  "post_id": widget.postDetails == null ? "" : widget.postDetails!.id.value
                                });
                                setState(() {
                                  releaseLoader = true;
                                });
                                communitiesVariables.communitiesPostSortValue.value = 0;
                                communitiesVariables.communitiesPostList = null;
                                await communitiesFunctions.getCommunityPostList(communityId: widget.communityId, skipCount: 0, sortType: 'Recent');
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Center(
                                child: Text("Release",
                                    style: TextStyle(
                                        fontSize: text.scale(14),
                                        color: const Color(0XFF0EA102),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (scroll) {
                scroll.disallowIndicator();
                return true;
              },
              child: loader
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(children: [
                                      SizedBox(
                                        height: height / 57.73,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            billboardWidgetsMain.getProfile(
                                                context: context,
                                                heightValue: height / 14.93,
                                                widthValue: width / 7.08,
                                                myself: true,
                                                userId: '',
                                                isProfile: "user"),
                                            SizedBox(
                                              width: width / 16.44,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${mainVariables.firstNameMyselfMain} ${mainVariables.lastNameMyselfMain}",
                                                  style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w600),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return UserBillBoardProfilePage(userId: userIdMain)
                                                          /*UserProfilePage(
                                                        id:userIdMain,type:'forums',index:0)*/
                                                          ;
                                                    }));
                                                  },
                                                  child: Text(
                                                    mainVariables.userNameMyselfMain,
                                                    style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF737373)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                                    Obx(() => mainVariables.isUserTagging.value ? const UserTaggingContainer() : const SizedBox()),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 50.75,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins"),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          String newResponseValue = value.trim();
                                          if (newResponseValue.isNotEmpty) {
                                            String messageText = newResponseValue;
                                            if (messageText.startsWith("+")) {
                                              if (messageText.substring(messageText.length - 1) == '+') {
                                                setState(() {
                                                  mainVariables.isUserTagging.value = true;
                                                  mainVariables.isUserTaggingLoader.value = true;
                                                });
                                              } else {
                                                if (mainVariables.isUserTagging.value) {
                                                  conversationFunctionsMain.conversationSearchData(
                                                    newResponseValue: newResponseValue,
                                                    newSetState: setState,
                                                  );
                                                  setState(() {
                                                    mainVariables.isUserTaggingLoader.value = false;
                                                  });
                                                } else {
                                                  conversationFunctionsMain.conversationSearchData(
                                                    newResponseValue: newResponseValue,
                                                    newSetState: setState,
                                                  );
                                                }
                                              }
                                            } else {
                                              if (messageText.contains(" +")) {
                                                if (messageText.substring(messageText.length - 1) == '+') {
                                                  setState(() {
                                                    mainVariables.isUserTagging.value = true;
                                                    mainVariables.isUserTaggingLoader.value = true;
                                                  });
                                                } else {
                                                  if (mainVariables.isUserTagging.value) {
                                                    conversationFunctionsMain.conversationSearchData(
                                                      newResponseValue: newResponseValue,
                                                      newSetState: setState,
                                                    );
                                                    setState(() {
                                                      mainVariables.isUserTaggingLoader.value = false;
                                                    });
                                                  } else {
                                                    conversationFunctionsMain.conversationSearchData(
                                                        newResponseValue: newResponseValue, newSetState: setState);
                                                  }
                                                }
                                              } else {
                                                setState(() {
                                                  mainVariables.isUserTagging.value = false;
                                                  mainVariables.isUserTaggingLoader.value = true;
                                                });
                                              }
                                            }
                                          }
                                        });
                                      } else if (value.isEmpty) {
                                        setState(() {
                                          mainVariables.isUserTagging.value = false;
                                        });
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    controller: mainVariables.messageControllerMain.value,
                                    focusNode: titleFocus,
                                    maxLines: 25,
                                    minLines: 12,
                                    keyboardType: TextInputType.multiline,
                                    showCursor: true,
                                    cursorColor: Theme.of(context).colorScheme.onPrimary,
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).colorScheme.background,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintStyle: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                      hintText: '**Content Playground**',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 50.75,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        showSheetFilePicker(context: context, modelSetState: setState);
                                      },
                                      child: Container(
                                        height: height / 8.82,
                                        width: width / 4.07,
                                        margin: EdgeInsets.symmetric(horizontal: width / 41.1),
                                        child: Image.asset(
                                          "assets/settings/add_file.png",
                                          height: height / 8.82,
                                          width: width / 4.07,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 8.82,
                                      width: width / 1.5,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          physics: const ScrollPhysics(),
                                          itemCount: fileList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (fileList[index].fileType.value == "image") {
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return FullScreenImage(imageUrl: fileList[index].file.value, tag: "generate_a_unique_tag");
                                                      }));
                                                    } else if (fileList[index].fileType.value == "video") {
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return VideoPlayerPage(
                                                          url: fileList[index].file.value,
                                                        );
                                                      }));
                                                    } else if (fileList[index].fileType.value == "document") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<dynamic>(
                                                          builder: (_) => PDFViewerFromUrl(
                                                            url: fileList[index].file.value,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 137),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                                          blurRadius: 4,
                                                          spreadRadius: 0)
                                                    ]),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: fileList[index].fileType.value == "image"
                                                        ? Image.network(
                                                            fileList[index].file.value,
                                                            height: height / 8.82,
                                                            width: width / 4.07,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : fileList[index].fileType.value == "video"
                                                            ? Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Image.asset(
                                                                    "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                    height: height / 8.82,
                                                                    width: width / 4.07,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                  Container(
                                                                      height: height / 34.64,
                                                                      width: width / 16.44,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                      child: const Icon(
                                                                        Icons.play_arrow_sharp,
                                                                        color: Colors.white,
                                                                        size: 15,
                                                                      ))
                                                                ],
                                                              )
                                                            : fileList[index].fileType.value == "document"
                                                                ? Stack(
                                                                    alignment: Alignment.center,
                                                                    children: [
                                                                      Image.asset(
                                                                        "lib/Constants/Assets/Settings/coverImage.png",
                                                                        height: height / 8.82,
                                                                        width: width / 4.07,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                      Container(
                                                                        height: height / 34.64,
                                                                        width: width / 16.44,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: Colors.black26.withOpacity(0.3),
                                                                        ),
                                                                        child: Center(
                                                                          child: Image.asset(
                                                                            "lib/Constants/Assets/BillBoard/document.png",
                                                                            color: Colors.white,
                                                                            height: height / 57.73,
                                                                            width: width / 27.4,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 7,
                                                  top: 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      bool response = await billBoardApiMain.fileRemoveBillBoard(
                                                          context: context, filePath: fileList[index].file.value);
                                                      if (response) {
                                                        fileList.removeAt(index);
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      height: height / 48.11,
                                                      width: width / 22.83,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3)),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Theme.of(context).colorScheme.background,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showSheetFilePicker({required BuildContext context, required StateSetter modelSetState}) async {
    ImagePicker picker = ImagePicker();
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        if (!mounted) {
                          return;
                        }
                        await cropImageFunc(
                          context: context,
                          currentImage: image,
                          type: "image",
                          modelSetState: modelSetState,
                        );
                        modelSetState(() {
                          pickedImage = File(image.path);
                          selectedUrlType = "image";
                          pickedVideo = null;
                        });
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.image_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Image",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      final video = await picker.pickVideo(source: ImageSource.gallery);
                      if (video != null) {
                        if (!mounted) {
                          return;
                        }
                        String imagePath = await billBoardApiMain.fileUploadBillBoard(file: File(video.path), context: context);
                        fileList.add(CommunityFileElement.fromJson({"file": imagePath, "file_type": "video"}));
                        modelSetState(() {
                          pickedVideo = File(video.path);
                          pickedImage = null;
                          selectedUrlType = "video";
                        });
                        BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
                            aspectRatio: 16 / 9,
                            fit: BoxFit.contain,
                            controlsConfiguration: BetterPlayerControlsConfiguration(
                              enableFullscreen: false,
                              enablePip: false,
                              enableOverflowMenu: false,
                              enablePlayPause: false,
                              enableProgressText: false,
                              controlsHideTime: Duration(microseconds: 300),
                            ));
                        BetterPlayerDataSource dataSource = BetterPlayerDataSource(
                          BetterPlayerDataSourceType.file,
                          video.path,
                        );
                        _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
                        _betterPlayerController.setupDataSource(dataSource);
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.video_library_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Video",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.of(context).pop();
                      doc = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'docx'],
                      );
                      if (doc != null) {
                        file1 = doc!.paths.map((path) => File(path!)).toList();
                        pickedFile = file1[0];
                        if (!mounted) {
                          return;
                        }
                        String imagePath = await billBoardApiMain.fileUploadBillBoard(file: pickedFile!, context: context);
                        fileList.add(CommunityFileElement.fromJson({"file": imagePath, "file_type": "document"}));
                        modelSetState(() {
                          selectedUrlType = "document";
                        });
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.attach_file_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Document",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  cropImageFunc({required BuildContext context, required XFile currentImage, required String type, required StateSetter modelSetState}) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(sourcePath: currentImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: const Color(0XFF0EA102),
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: const Color(0XFF0EA102),
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: false,
          lockAspectRatio: false),
    ]);
    if (croppedFile != null) {
      pickedImage = File(croppedFile.path);
      if (!mounted) {
        return;
      }
      String imagePath = await billBoardApiMain.fileUploadBillBoard(file: pickedImage!, context: context);
      fileList.add(CommunityFileElement.fromJson({"file": imagePath, "file_type": "image"}));
    }
  }
}
