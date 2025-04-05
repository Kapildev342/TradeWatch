import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/user_profile_data_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/messages_list_model.dart';

import 'file_preview_page.dart';

class ConversationPage extends StatefulWidget {
  final String? fromLink;

  const ConversationPage({Key? key, this.fromLink}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  bool loader = false;
  bool isAttached = false;
  bool isAttachedLoading = false;
  ScrollController scroll = ScrollController();
  List<ChatMessage> messageList = [];
  List<Map<String, dynamic>> attachedFiles = [];
  PageController page = PageController();
  int carouselIndexGlobal = 1;
  int selectedIndex = 1;
  int skipCount = 0;
  List<ChewieController> cvControllerList = [];

  sendMessage() async {
    List<FileElement> fileElements = [];
    String message = mainVariables.messageControllerMain.value.text;
    for (int i = 0; i < attachedFiles.length; i++) {
      FileElement element = FileElement.fromJson(attachedFiles[i]);
      fileElements.add(element);
    }
    if (message.isNotEmpty || attachedFiles.isNotEmpty) {
      mainVariables.audioPlayerList.insert(0, AudioPlayer());
      mainVariables.isPlayingList.insert(0, false);
      mainVariables.isLoadingList.insert(0, false);
      mainVariables.totalTimeList.insert(0, 1);
      mainVariables.currentTimeList.insert(0, 0);
      ChatMessage newMsg = ChatMessage(
          messageContent: message.obs,
          messageType: "sender",
          currentTime: DateTime.now(),
          data: fileElements,
          status: 1.obs,
          messageId: '',
          reply: mainVariables.isReplying.value
              ? ReplyUser(
                  replyId: mainVariables.replyUserDataMain.replyId,
                  userId: mainVariables.replyUserDataMain.userId,
                  avatar: mainVariables.replyUserDataMain.avatar,
                  message: mainVariables.replyUserDataMain.message,
                  username: mainVariables.replyUserDataMain.username,
                  status: mainVariables.replyUserDataMain.status,
                  files: mainVariables.replyUserDataMain.files,
                )
              : ReplyUser.fromJson({}),
          changedDate: mainVariables.recentMessageChangeDate.value != "Today",
          currentDate: "Today",
          isTranslated: false.obs,
          tempMessage: message.obs);
      mainVariables.recentMessageChangeDate.value = "Today";
      mainVariables.messagesListMain.insert(0, newMsg);
      mainVariables.messageControllerMain.value.clear();
      String messageId = await conversationApiMain.sendMessageApiFunctions(
          context: context,
          type: 'private',
          receiverId: mainVariables.conversationUserData.value.userId,
          message: message,
          files: attachedFiles,
          groupId: '',
          messageId: mainVariables.isReplying.value ? mainVariables.isReplyingMessageId.value : "");
      mainVariables.messagesListMain[0].messageId = messageId;
      if (mainVariables.isReplying.value) {
        mainVariables.isReplying.value = false;
        mainVariables.attachmentEditFiles.clear();
        mainVariables.isReplyingMessageId.value = "";
        mainVariables.editingIndexMain.value = 0;
        mainVariables.isReplyingMessage.value = "";
        mainVariables.replyUserDataMain = ReplyUser.fromJson({});
      }
    }
    setState(() {
      isAttached = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
      attachedFiles.clear();
    });
  }

  sendEditingMessage() async {
    List<FileElement> fileElements = [];
    fileElements.addAll(mainVariables.attachmentEditFiles);
    String message = mainVariables.messageControllerMain.value.text;
    for (int i = 0; i < attachedFiles.length; i++) {
      FileElement element = FileElement.fromJson(attachedFiles[i]);
      fileElements.add(element);
    }
    if (message.isNotEmpty || attachedFiles.isNotEmpty) {
      ChatMessage newMsg = ChatMessage(
          messageContent: message.obs,
          messageType: "sender",
          currentTime: DateTime.now(),
          data: fileElements,
          status: 4.obs,
          messageId: mainVariables.isEditingMessageId.value,
          reply: mainVariables.replyUserDataMain,
          changedDate: mainVariables.recentMessageChangeDate.value != "Today",
          currentDate: "Today",
          isTranslated: false.obs,
          tempMessage: message.obs);
      mainVariables.recentMessageChangeDate.value = "Today";
      mainVariables.messagesListMain.removeAt(mainVariables.editingIndexMain.value);
      mainVariables.messagesListMain.insert(mainVariables.editingIndexMain.value, newMsg);
      mainVariables.messageControllerMain.value.clear();
      await conversationApiMain.sendMessageApiFunctions(
          context: context,
          type: 'private',
          receiverId: mainVariables.conversationUserData.value.userId,
          message: message,
          files: attachedFiles,
          groupId: '',
          messageId: mainVariables.isEditingMessageId.value);
    }
    mainVariables.isEditingMessageId.value = "";
    mainVariables.editingIndexMain.value = 0;
    mainVariables.messageControllerMain.value.clear();
    mainVariables.attachmentEditFiles.clear();
    mainVariables.isEditing.value = false;
    mainVariables.replyUserDataMain = ReplyUser.fromJson({});
    setState(() {
      isAttached = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
      attachedFiles.clear();
    });
  }

  @override
  void initState() {
    getData();
    mainVariables.isChatOpen.value = true;
    getAllDataMain(name: 'Chat_initiated_with_${mainVariables.conversationUserData.value.userId}');
    super.initState();
  }

  getData() async {
    mainVariables.messagesList = (await conversationApiMain.getMessagesList(
            type: "private", userId: mainVariables.conversationUserData.value.userId, groupId: "", skip: skipCount.toString()))
        .obs;
    UserProfileDataModel profile = await settingsMain.getUserProfileData(userId: mainVariables.conversationUserData.value.userId);
    mainVariables.isUserActive.value = profile.response.onlineActive;
    mainVariables.isLastActiveTime.value = profile.response.onlineDate;
    mainVariables.messagesListMain.clear();
    mainVariables.audioPlayerList.clear();
    mainVariables.isPlayingList.clear();
    mainVariables.isLoadingList.clear();
    mainVariables.totalTimeList.clear();
    mainVariables.currentTimeList.clear();
    if (mainVariables.messagesList!.value.response.isEmpty) {
      debugPrint("length is zero");
    } else {
      for (int i = 0; i < mainVariables.messagesList!.value.response.length; i++) {
        mainVariables.audioPlayerList.add(AudioPlayer());
        mainVariables.isPlayingList.add(false);
        mainVariables.isLoadingList.add(false);
        mainVariables.totalTimeList.add(1);
        mainVariables.currentTimeList.add(0);
        messageList.add(ChatMessage(
            messageContent: mainVariables.messagesList!.value.response[i].message.obs,
            messageType: mainVariables.messagesList!.value.response[i].userId == userIdMain ? "sender" : "receiver",
            currentTime: DateTime.parse(mainVariables.messagesList!.value.response[i].createdAt),
            data: mainVariables.messagesList!.value.response[i].files,
            status: mainVariables.messagesList!.value.response[i].status.obs,
            messageId: mainVariables.messagesList!.value.response[i].id,
            reply: mainVariables.messagesList!.value.response[i].replyUser,
            changedDate: mainVariables.messagesList!.value.response[i].changedDate,
            currentDate: mainVariables.messagesList!.value.response[i].currentDate,
            isTranslated: false.obs,
            tempMessage: mainVariables.messagesList!.value.response[i].message.obs));
      }
      mainVariables.recentMessageChangeDate.value =
          mainVariables.messagesList!.value.response[mainVariables.messagesList!.value.response.length - 1].currentDate;
      // mainVariables.lastMessageChangeDate.value=mainVariables.messagesList!.value.response[0].currentDate;
      mainVariables.messagesListMain.addAll(messageList.reversed);
    }
    setState(() {
      loader = true;
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < mainVariables.audioPlayerList.length; i++) {
      mainVariables.audioPlayerList[i].dispose();
    }
    mainVariables.audioPlayerList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromLink != null) {
          if (isAttached) {
            attachedFiles.clear();
            mainVariables.isEditingMessageId.value = "";
            mainVariables.currentScrollPositionTime.value = "";
            mainVariables.recentMessageChangeDate.value = "";
            // mainVariables.lastMessageChangeDate.value ="";
            mainVariables.editingIndexMain.value = 0;
            mainVariables.messageListSkipCount.value = 0;
            mainVariables.messageControllerMain.value.clear();
            setState(() {
              isAttached = false;
            });
          } else {
            if (widget.fromLink == "main") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const MainBottomNavigationPage(
                          caseNo1: 0, text: "Stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
            } else {
              Navigator.pop(context);
            }
            mainVariables.isEditingMessageId.value = "";
            mainVariables.currentScrollPositionTime.value = "";
            mainVariables.recentMessageChangeDate.value = "";
            mainVariables.editingIndexMain.value = 0;
            mainVariables.messageListSkipCount.value = 0;
            mainVariables.messageControllerMain.value.clear();
            mainVariables.isChatOpen.value = false;
          }
        } else {
          if (isAttached) {
            attachedFiles.clear();
            mainVariables.isEditingMessageId.value = "";
            mainVariables.currentScrollPositionTime.value = "";
            mainVariables.recentMessageChangeDate.value = "";
            //mainVariables.lastMessageChangeDate.value ="";
            mainVariables.editingIndexMain.value = 0;
            mainVariables.messageListSkipCount.value = 0;
            mainVariables.messageControllerMain.value.clear();
            setState(() {
              isAttached = false;
            });
          } else {
            await conversationApiMain.conversationUsersList(
                type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: 0, fromWhere: 'conversation');
            Navigator.pop(context);
            mainVariables.isEditingMessageId.value = "";
            mainVariables.currentScrollPositionTime.value = "";
            mainVariables.recentMessageChangeDate.value = "";
            //   mainVariables.lastMessageChangeDate.value ="";
            mainVariables.editingIndexMain.value = 0;
            mainVariables.messageListSkipCount.value = 0;
            mainVariables.messageControllerMain.value.clear();
            mainVariables.isChatOpen.value = false;
          }
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            body: Obx(() => Stack(
                  children: [
                    isAttached
                        ? Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('lib/Constants/Assets/Settings/coverImage_default.png'), fit: BoxFit.fill)))
                        : Container(
                            height: mainVariables.messagesListMain.length > 3 ? height / 14.43 : height / 4.02,
                            decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('lib/Constants/Assets/Settings/coverImage_default.png'), fit: BoxFit.fill)),
                          ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        isAttached
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              if (widget.fromLink != null) {
                                                if (isAttached) {
                                                  attachedFiles.clear();
                                                  mainVariables.isEditingMessageId.value = "";
                                                  mainVariables.editingIndexMain.value = 0;
                                                  mainVariables.messageControllerMain.value.clear();
                                                  setState(() {
                                                    isAttached = false;
                                                  });
                                                } else {
                                                  if (widget.fromLink == "main") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext context) => const MainBottomNavigationPage(
                                                                caseNo1: 0,
                                                                text: "Stocks",
                                                                excIndex: 1,
                                                                newIndex: 0,
                                                                countryIndex: 0,
                                                                isHomeFirstTym: false,
                                                                tType: true)));
                                                  } else {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                  }
                                                  mainVariables.isEditingMessageId.value = "";
                                                  mainVariables.editingIndexMain.value = 0;
                                                  mainVariables.messageControllerMain.value.clear();
                                                  mainVariables.isChatOpen.value = false;
                                                }
                                              } else {
                                                if (isAttached) {
                                                  attachedFiles.clear();
                                                  mainVariables.isEditingMessageId.value = "";
                                                  mainVariables.editingIndexMain.value = 0;
                                                  mainVariables.messageControllerMain.value.clear();
                                                  setState(() {
                                                    isAttached = false;
                                                  });
                                                } else {
                                                  await conversationApiMain.conversationUsersList(
                                                      type: mainVariables.isGeneralConversationList.value ? "general" : "believers",
                                                      skipCount: 0,
                                                      fromWhere: 'conversation');
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.pop(context);
                                                  mainVariables.isEditingMessageId.value = "";
                                                  mainVariables.editingIndexMain.value = 0;
                                                  mainVariables.messageControllerMain.value.clear();
                                                  mainVariables.isChatOpen.value = false;
                                                }
                                              }
                                            },
                                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                                          ),
                                          Text(
                                            "Attached Files",
                                            style: TextStyle(color: Colors.white, fontSize: text.scale(18)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                                        child: Text(
                                          "$selectedIndex in ${attachedFiles.length} Files",
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
                                        itemCount: attachedFiles.length,
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
                                          return attachedFiles[index]["file_type"] == "video"
                                              ? billboardWidgetsMain.getVideoPlayer(
                                                  cvController: cvControllerList[index],
                                                  heightValue: height / 3.85,
                                                  widthValue: width,
                                                )
                                              : attachedFiles[index]["file_type"] == "image"
                                                  ? FullScreenImage(
                                                      imageUrl: attachedFiles[index]["file"],
                                                      tag: 'PreviewPage',
                                                    )
                                                  : attachedFiles[index]["file_type"] == "audio"
                                                      ? AudioMainPreview(
                                                          url: attachedFiles[index]["file"],
                                                          isBeforeSending: true,
                                                        )
                                                      : attachedFiles[index]["file_type"] == "doc"
                                                          ? PDFViewerFromUrl(
                                                              url: attachedFiles[index]["file"],
                                                            )
                                                          : const Text(
                                                              "Not a video",
                                                              style: TextStyle(color: Colors.white),
                                                            );
                                        }),
                                  )),
                                  SizedBox(
                                    height: height / 11.54,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  mainVariables.messagesListMain.length > 3
                                      ? Container(
                                          padding: EdgeInsets.only(left: width / 41.1, right: width / 27.4),
                                          height: height / 14.43,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        if (widget.fromLink != null) {
                                                          if (isAttached) {
                                                            attachedFiles.clear();
                                                            mainVariables.isEditingMessageId.value = "";
                                                            mainVariables.currentScrollPositionTime.value = "";
                                                            mainVariables.editingIndexMain.value = 0;
                                                            mainVariables.messageListSkipCount.value = 0;
                                                            mainVariables.messageControllerMain.value.clear();
                                                            setState(() {
                                                              isAttached = false;
                                                            });
                                                          } else {
                                                            if (widget.fromLink == "main") {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext context) => const MainBottomNavigationPage(
                                                                          caseNo1: 0,
                                                                          text: "Stocks",
                                                                          excIndex: 1,
                                                                          newIndex: 0,
                                                                          countryIndex: 0,
                                                                          isHomeFirstTym: false,
                                                                          tType: true)));
                                                            } else {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.pop(context);
                                                            }
                                                            mainVariables.isEditingMessageId.value = "";
                                                            mainVariables.currentScrollPositionTime.value = "";
                                                            mainVariables.editingIndexMain.value = 0;
                                                            mainVariables.messageListSkipCount.value = 0;
                                                            mainVariables.messageControllerMain.value.clear();
                                                            mainVariables.isChatOpen.value = false;
                                                          }
                                                        } else {
                                                          if (isAttached) {
                                                            attachedFiles.clear();
                                                            mainVariables.isEditingMessageId.value = "";
                                                            mainVariables.currentScrollPositionTime.value = "";
                                                            mainVariables.editingIndexMain.value = 0;
                                                            mainVariables.messageListSkipCount.value = 0;
                                                            mainVariables.messageControllerMain.value.clear();
                                                            setState(() {
                                                              isAttached = false;
                                                            });
                                                          } else {
                                                            await conversationApiMain.conversationUsersList(
                                                                type: mainVariables.isGeneralConversationList.value ? "general" : "believers",
                                                                skipCount: 0,
                                                                fromWhere: 'conversation');
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Navigator.pop(context);
                                                            mainVariables.isEditingMessageId.value = "";
                                                            mainVariables.currentScrollPositionTime.value = "";
                                                            mainVariables.editingIndexMain.value = 0;
                                                            mainVariables.messageListSkipCount.value = 0;
                                                            mainVariables.messageControllerMain.value.clear();
                                                            mainVariables.isChatOpen.value = false;
                                                          }
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.arrow_back,
                                                        color: Colors.white,
                                                      )),
                                                  SizedBox(
                                                    width: width / 41.1,
                                                  ),
                                                  Stack(
                                                    alignment: Alignment.topRight,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return UserBillBoardProfilePage(userId: mainVariables.conversationUserData.value.userId);
                                                          }));
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage: NetworkImage(mainVariables.conversationUserData.value.avatar),
                                                        ),
                                                      ),
                                                      Obx(() => mainVariables.isUserActive.value
                                                          ? Container(
                                                              height: height / 57.73,
                                                              width: width / 27.4,
                                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                              child: Center(
                                                                child: Container(
                                                                  height: height / 86.6,
                                                                  width: width / 41.1,
                                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox()),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width / 27.4,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      /* if (mainVariables.userSearchDataList[index].profileType != "user" ||
                                                          mainVariables.userSearchDataList[index].profileType != "intermediate") {
                                                        mainVariables.selectedTickerId.value =
                                                            mainVariables
                                                                .userSearchDataList[index].tickerId;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) {
                                                            return mainVariables.userSearchDataList[index]
                                                                .profileType ==
                                                                "intermediate"
                                                                ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables
                                                                    .userSearchDataList[index].id)
                                                                : mainVariables.userSearchDataList[index]
                                                                .profileType !=
                                                                "user"
                                                                ? BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                userId: mainVariables
                                                                    .userSearchDataList[index].id);
                                                          }));*/
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: mainVariables.conversationUserData.value.userId);
                                                      }));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /*Text(
                                                          "${mainVariables.conversationUserData.value.firstName} ${mainVariables.conversationUserData.value.lastName}",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  _text.scale(10)14,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color:
                                                                  Colors.white),
                                                        ),*/
                                                        Text(
                                                          "+${mainVariables.conversationUserData.value.userName}",
                                                          style:
                                                              TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w500, color: Colors.white),
                                                        ),
                                                        Obx(
                                                          () => mainVariables.isUserActive.value
                                                              ? const SizedBox() /* Text(
                                                          "active",
                                                          style: TextStyle(
                                                              fontSize:
                                                              _text.scale(10)8,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color:
                                                              Colors.white),
                                                        )*/
                                                              : Text(
                                                                  "Last seen at ${mainVariables.isLastActiveTime.value}",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(8), fontWeight: FontWeight.w500, color: Colors.white),
                                                                ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  conversationWidgetsMain.getConversationBelieveButton(
                                                      heightValue: height / 28.86, context: context, background: true, modelSetState: setState),
                                                  GestureDetector(
                                                      onTap: () {
                                                        conversationWidgetsMain.bottomSheet(
                                                            context: context, modelSetState: setState, fromWhere: 'single', index: 0);
                                                      },
                                                      child: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      if (widget.fromLink != null) {
                                                        if (isAttached) {
                                                          attachedFiles.clear();
                                                          mainVariables.isEditingMessageId.value = "";
                                                          mainVariables.currentScrollPositionTime.value = "";
                                                          mainVariables.editingIndexMain.value = 0;
                                                          mainVariables.messageListSkipCount.value = 0;
                                                          mainVariables.messageControllerMain.value.clear();
                                                          setState(() {
                                                            isAttached = false;
                                                          });
                                                        } else {
                                                          if (widget.fromLink == "main") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => const MainBottomNavigationPage(
                                                                        caseNo1: 0,
                                                                        text: "Stocks",
                                                                        excIndex: 1,
                                                                        newIndex: 0,
                                                                        countryIndex: 0,
                                                                        isHomeFirstTym: false,
                                                                        tType: true)));
                                                          } else {
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Navigator.pop(context);
                                                          }
                                                          mainVariables.isEditingMessageId.value = "";
                                                          mainVariables.currentScrollPositionTime.value = "";
                                                          mainVariables.editingIndexMain.value = 0;
                                                          mainVariables.messageListSkipCount.value = 0;
                                                          mainVariables.messageControllerMain.value.clear();
                                                          mainVariables.isChatOpen.value = false;
                                                        }
                                                      } else {
                                                        if (isAttached) {
                                                          attachedFiles.clear();
                                                          mainVariables.isEditingMessageId.value = "";
                                                          mainVariables.currentScrollPositionTime.value = "";
                                                          mainVariables.editingIndexMain.value = 0;
                                                          mainVariables.messageListSkipCount.value = 0;
                                                          mainVariables.messageControllerMain.value.clear();
                                                          setState(() {
                                                            isAttached = false;
                                                          });
                                                        } else {
                                                          await conversationApiMain.conversationUsersList(
                                                              type: mainVariables.isGeneralConversationList.value ? "general" : "believers",
                                                              skipCount: 0,
                                                              fromWhere: 'conversation');
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          mainVariables.isEditingMessageId.value = "";
                                                          mainVariables.currentScrollPositionTime.value = "";
                                                          mainVariables.editingIndexMain.value = 0;
                                                          mainVariables.messageListSkipCount.value = 0;
                                                          mainVariables.messageControllerMain.value.clear();
                                                          mainVariables.isChatOpen.value = false;
                                                        }
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    )),
                                                IconButton(
                                                  onPressed: () {
                                                    conversationWidgetsMain.bottomSheet(
                                                        context: context, modelSetState: setState, fromWhere: 'single', index: 0);
                                                  },
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                /* if (mainVariables.userSearchDataList[index].profileType != "user" ||
                                                          mainVariables.userSearchDataList[index].profileType != "intermediate") {
                                                        mainVariables.selectedTickerId.value =
                                                            mainVariables
                                                                .userSearchDataList[index].tickerId;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) {
                                                            return mainVariables.userSearchDataList[index]
                                                                .profileType ==
                                                                "intermediate"
                                                                ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables
                                                                    .userSearchDataList[index].id)
                                                                : mainVariables.userSearchDataList[index]
                                                                .profileType !=
                                                                "user"
                                                                ? BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                userId: mainVariables
                                                                    .userSearchDataList[index].id);
                                                          }));*/
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(userId: mainVariables.conversationUserData.value.userId);
                                                }));
                                              },
                                              child: Center(
                                                child: CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: NetworkImage(mainVariables.conversationUserData.value.avatar),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 173.2,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                /* if (mainVariables.userSearchDataList[index].profileType != "user" ||
                                                          mainVariables.userSearchDataList[index].profileType != "intermediate") {
                                                        mainVariables.selectedTickerId.value =
                                                            mainVariables
                                                                .userSearchDataList[index].tickerId;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) {
                                                            return mainVariables.userSearchDataList[index]
                                                                .profileType ==
                                                                "intermediate"
                                                                ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables
                                                                    .userSearchDataList[index].id)
                                                                : mainVariables.userSearchDataList[index]
                                                                .profileType !=
                                                                "user"
                                                                ? BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                userId: mainVariables
                                                                    .userSearchDataList[index].id);
                                                          }));*/
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(userId: mainVariables.conversationUserData.value.userId);
                                                }));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 5.48),
                                                padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Theme.of(context).colorScheme.background,
                                                    border: Border.all(color: Colors.black26.withOpacity(0.1))),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        mainVariables.isUserActive.value
                                                            ? Container(
                                                                height: height / 86.6,
                                                                width: width / 41.1,
                                                                decoration: const BoxDecoration(color: Color(0XFF0EA102), shape: BoxShape.circle),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                    Text(
                                                      "${mainVariables.conversationUserData.value.firstName} ${mainVariables.conversationUserData.value.lastName}",
                                                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                                    ),
                                                    Text(
                                                      "+${mainVariables.conversationUserData.value.userName}",
                                                      style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                                    ),
                                                    SizedBox(
                                                      height: height / 108.25,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 8.22),
                                                      child: conversationWidgetsMain.getConversationBelieveButton(
                                                          heightValue: height / 34.64, context: context, background: false, modelSetState: setState),
                                                    ),
                                                    SizedBox(
                                                      height: height / 108.25,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        mainVariables.isUserActive.value
                                                            ? const SizedBox()
                                                            : Text(
                                                                "Last seen at  ${mainVariables.isLastActiveTime.value}",
                                                                style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                              )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                  Expanded(
                                    child: loader
                                        ? mainVariables.messagesListMain.isEmpty
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: height / 5.77,
                                                      width: width / 2.74,
                                                      child: SvgPicture.asset(
                                                        "lib/Constants/Assets/SMLogos/noResponse_green.svg",
                                                        colorFilter: const ColorFilter.mode(Color(0XFF0EA102), BlendMode.srcIn),
                                                      )),
                                                  RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Seems like no messages found to display',
                                                          style: TextStyle(fontFamily: "Poppins", fontSize: text.scale(12)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : conversationWidgetsMain.chatMessages(
                                                context: context,
                                                modelSetState: setState,
                                              )
                                        /*Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  conversationWidgetsMain
                                                      .chatMessages(
                                                          context: context,
                                                          modelSetState:
                                                              setState,
                                                          skipCount: 0),
                                                  Obx(() => Container(
                                                      height: _height / 24.74,
                                                      width: _width,
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                              horizontal:
                                                                  _width / 4.11,
                                                              vertical:
                                                                  _height /
                                                                      57.73),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  _height /
                                                                      86.6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        mainVariables
                                                            .currentScrollPositionTime
                                                            .value,
                                                        style: TextStyle(
                                                            fontSize:
                                                                _text.scale(10)12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ))))
                                                ],
                                              )*/
                                        : Center(
                                            child:
                                                Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                                          ),
                                  ),
                                  SizedBox(
                                    height: height / 10.825,
                                  ),
                                  mainVariables.isReplying.value
                                      ? SizedBox(
                                          height: height / 34.64,
                                        )
                                      : const SizedBox()
                                ],
                              ),
                        loader
                            ? Obx(() => mainVariables.messagesList!.value.blocked
                                ? mainVariables.messagesList!.value.blockedBy!.userId == userIdMain
                                    ? Container(
                                        height: height / 11.54,
                                        color: Theme.of(context).colorScheme.background,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "lib/Constants/Assets/activity/block.png",
                                                      height: height / 17.32,
                                                      width: width / 8.22,
                                                    ),
                                                    SizedBox(
                                                        width: width / 2,
                                                        child: Text(
                                                          "You have blocked ${mainVariables.conversationUserData.value.firstName}, Do you want to unblock?",
                                                          textAlign: TextAlign.center,
                                                        )),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          bool response = await conversationApiMain.unblockUser(
                                                              context: context, userId: mainVariables.messagesList!.value.blockedBy!.id);
                                                          if (response) {
                                                            mainVariables.messagesList!.value = await conversationApiMain.getMessagesList(
                                                                type: "private",
                                                                userId: mainVariables.conversationUserData.value.userId,
                                                                groupId: "",
                                                                skip: '0');
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Unblock",
                                                          style: TextStyle(color: Colors.white),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ]))
                                    : Container(
                                        height: height / 17.32,
                                        width: width,
                                        color: Theme.of(context).colorScheme.background,
                                        child: Center(
                                          child: Text("${mainVariables.conversationUserData.value.firstName} can no longer be contacted"),
                                        ),
                                      )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: height / 86.6,
                                      ),
                                      Obx(() => mainVariables.isUserTagging.value ? const UserTaggingContainer() : const SizedBox()),
                                      Obx(() => mainVariables.isReplying.value
                                          ? Container(
                                              margin: EdgeInsets.only(left: width / 16.44, right: width / 8.22),
                                              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                              decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: isDarkTheme.value ? Colors.black.withOpacity(0.1) : Colors.black, width: 1.5),
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(mainVariables.isUserTagging.value ? 0 : 15),
                                                    topLeft: Radius.circular(mainVariables.isUserTagging.value ? 0 : 15)),
                                                color: Colors.black26.withOpacity(0.3),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      mainVariables.isReplyingMessage.value,
                                                      style: TextStyle(
                                                          fontSize: text.scale(14),
                                                          fontStyle: FontStyle.italic,
                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                          overflow: TextOverflow.ellipsis),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        mainVariables.isReplying.value = false;
                                                        mainVariables.attachmentEditFiles.clear();
                                                        mainVariables.isReplyingMessageId.value = "";
                                                        mainVariables.editingIndexMain.value = 0;
                                                        mainVariables.isReplyingMessage.value = "";
                                                        mainVariables.replyUserDataMain = ReplyUser.fromJson({});
                                                      },
                                                      icon: const Icon(Icons.clear))
                                                ],
                                              ),
                                            )
                                          : const SizedBox()),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                        padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color.fromRGBO(0, 0, 0, 0.15),
                                            )
                                          ],
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            isAttached
                                                ? const SizedBox()
                                                : InkWell(
                                                    splashColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () async {
                                                      mainVariables.isReplying.value = false;
                                                      if (mainVariables.isMicPressed.value) {
                                                        await mainVariables.recorderController.stop(false);
                                                        mainVariables.isRecording.value = false;
                                                        setState(() {
                                                          mainVariables.isMicPressed.value = false;
                                                        });
                                                      } else {
                                                        if (mainVariables.isEditing.value == false) {
                                                          setState(() {
                                                            isAttachedLoading = true;
                                                          });
                                                          attachedFiles = await conversationFunctionsMain.getAttachFile();
                                                          if (attachedFiles.isNotEmpty) {
                                                            for (int i = 0; i < attachedFiles.length; i++) {
                                                              cvControllerList.add(await functionsMain.getVideoPlayer(
                                                                url: attachedFiles[i]["file"],
                                                              ));
                                                            }
                                                            setState(() {
                                                              isAttached = true;
                                                              isAttachedLoading = false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isAttachedLoading = false;
                                                            });
                                                          }
                                                        } else {
                                                          mainVariables.isEditingMessageId.value = "";
                                                          mainVariables.editingIndexMain.value = 0;
                                                          mainVariables.messageControllerMain.value.clear();
                                                          mainVariables.attachmentEditFiles.clear();
                                                          mainVariables.isEditing.value = false;
                                                        }
                                                      }
                                                    },
                                                    child: SizedBox(
                                                        width: width / 16.44,
                                                        child: Center(
                                                            child: mainVariables.isMicPressed.value || mainVariables.isEditing.value
                                                                ? const Icon(Icons.clear)
                                                                : SvgPicture.asset(
                                                                    "lib/Constants/Assets/BillBoard/attach.svg",
                                                                    height: height / 43.3,
                                                                    width: width / 20.55,
                                                                  )))),
                                            Obx(
                                              () => mainVariables.isRecording.value
                                                  ? Expanded(
                                                      child: AudioWaveforms(
                                                        enableGesture: true,
                                                        size: Size(width / 4.11, height / 17.32),
                                                        recorderController: mainVariables.recorderController,
                                                        waveStyle: WaveStyle(
                                                          waveColor: Theme.of(context).colorScheme.onPrimary,
                                                          extendWaveform: true,
                                                          showMiddleLine: false,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12.0),
                                                          color: Theme.of(context).colorScheme.background,
                                                        ),
                                                        padding: EdgeInsets.only(left: width / 22.83),
                                                        margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: TextFormField(
                                                        controller: mainVariables.messageControllerMain.value,
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
                                                        style: TextStyle(fontSize: text.scale(15)),
                                                        showCursor: true,
                                                        maxLines: 4,
                                                        minLines: 1,
                                                        decoration: InputDecoration(
                                                            hintText: "Type a message...",
                                                            hintStyle: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color.fromRGBO(118, 118, 118, 1),
                                                                fontSize: text.scale(15)),
                                                            border: InputBorder.none),
                                                      ),
                                                    ),
                                            ),
                                            isAttachedLoading
                                                ? Center(
                                                    child: Lottie.asset('lib/Constants/Assets/SMLogos/LockerScreen/Loading Dots.json',
                                                        height: height / 17.32, width: width / 4.11),
                                                  )
                                                : SizedBox(
                                                    width: mainVariables.isMicPressed.value || isAttached ? width / 16.44 : width / 8.22,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                            splashColor: Colors.transparent,
                                                            highlightColor: Colors.transparent,
                                                            onTap: () async {
                                                              if (mainVariables.isMicPressed.value) {
                                                                attachedFiles = await conversationFunctionsMain.recording();
                                                                attachedFiles.isNotEmpty
                                                                    ? mainVariables.isEditing.value
                                                                        ? sendEditingMessage()
                                                                        : await sendMessage()
                                                                    : debugPrint("do nothing");
                                                                setState(() {
                                                                  mainVariables.isMicPressed.value = false;
                                                                });
                                                              } else {
                                                                mainVariables.isEditing.value ? sendEditingMessage() : sendMessage();
                                                              }
                                                            },
                                                            child: SvgPicture.asset(
                                                              "lib/Constants/Assets/BillBoard/send.svg",
                                                              height: height / 43.3,
                                                              width: width / 20.55,
                                                            )),
                                                        mainVariables.isMicPressed.value || isAttached
                                                            ? const SizedBox()
                                                            : InkWell(
                                                                splashColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                onTap: () async {
                                                                  setState(() {
                                                                    mainVariables.isMicPressed.value = true;
                                                                  });
                                                                  attachedFiles = await conversationFunctionsMain.recording();
                                                                  attachedFiles.isNotEmpty
                                                                      ? sendMessage()
                                                                      : debugPrint("nothing"); //nonVoiceRecorder();
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "lib/Constants/Assets/BillBoard/mic.svg",
                                                                  height: height / 43.3,
                                                                  width: width / 20.55,
                                                                )),
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 57.73,
                                      ),
                                    ],
                                  ))
                            : const SizedBox()
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}
