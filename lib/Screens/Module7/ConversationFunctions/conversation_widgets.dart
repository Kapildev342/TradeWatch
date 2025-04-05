import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/contact_users_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/messages_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/active_traders_screen.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/contact_list_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/file_preview_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/files_displaying_page.dart';

import 'focused_menu.dart';

class ConversationWidgets {
  createGroupBottomWidget({required BuildContext context}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const CreateGroupBottomPage();
        });
  }

  showChangeBottomSheet({required BuildContext context, required StateSetter modelSetState}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                      onTap: () {
                        Navigator.pop(context);
                        cameraImage(modelSetState: modelSetState);
                      },
                      minLeadingWidth: width / 25,
                      leading: SvgPicture.asset(
                        "lib/Constants/Assets/Settings/camera.svg",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Camera",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        galleryImage(modelSetState: modelSetState);
                      },
                      minLeadingWidth: width / 25,
                      leading: SvgPicture.asset(
                        "lib/Constants/Assets/Settings/gallery.svg",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Image",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  galleryImage({required StateSetter modelSetState}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    cropImageFunc(currentImage: image!, modelSetState: modelSetState);
  }

  cameraImage({required StateSetter modelSetState}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    cropImageFunc(currentImage: image!, modelSetState: modelSetState);
  }

  cropImageFunc({required XFile currentImage, required StateSetter modelSetState}) async {
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
      modelSetState(() {
        mainVariables.pickedImageGroupSingle = File(croppedFile.path);
      });
    } else {}
  }

  Widget getChatBelieveButton(
      {required double heightValue,
      required int index,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(id: billboardUserid, name: billboardUserName);
          if (responseData['message'] == "Believed successfully") {
            mainVariables.believersCountMainMyself.value++;
            mainVariables.chatUserList[index].believed = true;
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            mainVariables.believersCountMainMyself.value--;
            mainVariables.chatUserList[index].believed = false;
            modelSetState(() {});
          }
        },
        child: Container(
          height: heightValue,
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          decoration: BoxDecoration(
            color: mainVariables.chatUserList[index].believed ? Colors.transparent : Colors.green,
            border: Border.all(color: mainVariables.chatUserList[index].believed ? const Color(0XFFD9D9D9) : Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              mainVariables.chatUserList[index].believed ? "Believed" : "Believe",
              style: TextStyle(
                  fontSize: text.scale(12),
                  color: mainVariables.chatUserList[index].believed
                      ? background == true
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.background),
            ),
          ),
        ));
  }

  Widget getActiveChatBelieveButton(
      {required double heightValue,
      required int index,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(id: billboardUserid, name: billboardUserName);
          if (responseData['message'] == "Believed successfully") {
            mainVariables.believersCountMainMyself.value++;
            mainVariables.activeUserList[index].believed = true;
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            mainVariables.believersCountMainMyself.value--;
            mainVariables.activeUserList[index].believed = false;
            modelSetState(() {});
          }
        },
        child: Container(
          height: heightValue,
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          decoration: BoxDecoration(
            color: mainVariables.activeUserList[index].believed ? Colors.transparent : Colors.green,
            border: Border.all(color: mainVariables.activeUserList[index].believed ? const Color(0XFFD9D9D9) : Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              mainVariables.activeUserList[index].believed ? "Believed" : "Believe",
              style: TextStyle(
                  fontSize: text.scale(12),
                  color: mainVariables.activeUserList[index].believed
                      ? background == true
                          ? Colors.white
                          : isDarkTheme.value
                              ? Colors.white
                              : Colors.black
                      : Colors.white),
            ),
          ),
        ));
  }

  Widget getLinkSendButton(
      {required double heightValue,
      required int index,
      required bool isSent,
      required String billboardUserid,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
        onTap: () async {},
        child: Container(
          height: heightValue,
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          decoration: BoxDecoration(
            color: isSent ? Colors.transparent : Colors.green,
            border: Border.all(color: isSent ? const Color(0XFFD9D9D9) : Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              isSent ? "Sent" : "Send",
              style: TextStyle(
                  fontSize: text.scale(12),
                  color: isSent
                      ? background == true
                          ? Colors.white
                          : Colors.black
                      : Colors.white),
            ),
          ),
        ));
  }

  Widget getConversationBelieveButton(
      {required double heightValue, required BuildContext context, required StateSetter modelSetState, bool? background}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: mainVariables.conversationUserData.value.userId,
            name: mainVariables.conversationUserData.value.userName,
          );
          if (responseData['message'] == "Believed successfully") {
            mainVariables.believersCountMainMyself.value++;
            mainVariables.conversationUserData.value.isBelieved = true;
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            mainVariables.believersCountMainMyself.value--;
            mainVariables.conversationUserData.value.isBelieved = false;
            modelSetState(() {});
          }
        },
        child: Container(
          height: heightValue,
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          decoration: BoxDecoration(
            color: mainVariables.conversationUserData.value.isBelieved ? Colors.transparent : Colors.green,
            border: Border.all(color: mainVariables.conversationUserData.value.isBelieved ? const Color(0XFFD9D9D9) : Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              mainVariables.conversationUserData.value.isBelieved ? "Believed" : "Believe",
              style: TextStyle(
                  fontSize: text.scale(12),
                  color: mainVariables.conversationUserData.value.isBelieved
                      ? background == true
                          ? Colors.white
                          : isDarkTheme.value
                              ? Colors.white
                              : Colors.black
                      : Colors.white),
            ),
          ),
        ));
  }

  Widget getContactBelieveButton(
      {required double heightValue,
      required int index,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: billboardUserid,
            name: billboardUserName,
          );
          if (responseData['message'] == "Believed successfully") {
            mainVariables.believersCountMainMyself.value++;
            mainVariables.usersList[index].believed = true;
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            mainVariables.believersCountMainMyself.value--;
            mainVariables.usersList[index].believed = false;
            modelSetState(() {});
          }
        },
        child: Container(
          height: heightValue,
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          decoration: BoxDecoration(
            color: mainVariables.usersList[index].believed ? Colors.transparent : Colors.green,
            border: Border.all(color: mainVariables.usersList[index].believed ? const Color(0XFFD9D9D9) : Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              mainVariables.usersList[index].believed ? "Believed" : "Believe",
              style: TextStyle(
                  fontSize: text.scale(12),
                  color: mainVariables.usersList[index].believed
                      ? background == true
                          ? Colors.white
                          : Colors.black
                      : Colors.white),
            ),
          ),
        ));
  }

  Widget getUserListSearchField({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return TextFormField(
      controller: mainVariables.believedListSearchControllerMain.value,
      onChanged: (value) async {
        if (value.isEmpty || value.isEmpty) {
          ContactUsersListModel contactUsers = await conversationApiMain.getUsersList(skipCount: 0);
          mainVariables.usersList.clear();
          mainVariables.usersList.addAll(contactUsers.response);
          modelSetState(() {});
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          ContactUsersListModel contactUsers = await conversationApiMain.getUsersList(skipCount: 0);
          mainVariables.usersList.clear();
          mainVariables.usersList.addAll(contactUsers.response);
          modelSetState(() {});
        }
      },
      cursorColor: Colors.green,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: mainVariables.believedListSearchControllerMain.value.text.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onTap: () async {
                    mainVariables.believedListSearchControllerMain.value.clear();
                    ContactUsersListModel contactUsers = await conversationApiMain.getUsersList(skipCount: 0);
                    mainVariables.usersList.clear();
                    mainVariables.usersList.addAll(contactUsers.response);
                    modelSetState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Icon(Icons.cancel, size: 22, color: Colors.black),
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
          ),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
          filled: true,
          hintText: 'Search here',
          errorStyle: TextStyle(fontSize: text.scale(10))),
    );
  }

  Widget chatMessages({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SmartRefresher(
      controller: chatMessagesListController,
      scrollController: ScrollController(),
      enablePullDown: false,
      enablePullUp: true,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("No more Data");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      onLoading: () async {
        mainVariables.messageListSkipCount.value = mainVariables.messageListSkipCount.value + 10;
        mainVariables.messagesList!.value = await conversationApiMain.getMessagesList(
            type: "private",
            userId: mainVariables.conversationUserData.value.userId,
            groupId: "",
            skip: mainVariables.messageListSkipCount.value.toString());
        List<ChatMessage> messageList = [];
        if (mainVariables.messagesList!.value.response.isEmpty) {
          debugPrint("length is zero");
        } else {
          if (mainVariables.messagesListMain[mainVariables.messagesListMain.length - 1].currentDate ==
              mainVariables.messagesList!.value.response[mainVariables.messagesList!.value.response.length - 1].currentDate) {
            mainVariables.messagesListMain[mainVariables.messagesListMain.length - 1].changedDate = false;
          }
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
          // mainVariables.lastMessageChangeDate.value=mainVariables.messagesList!.value.response[0].currentDate;
          mainVariables.messagesListMain.addAll(messageList.reversed);
        }
        chatMessagesListController.loadComplete();
        modelSetState(() {});
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: mainVariables.messagesListMain.length,
        addAutomaticKeepAlives: true,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          return Obx(
            () => Column(
              children: [
                mainVariables.messagesListMain[index].changedDate == true
                    ? Container(
                        height: 25,
                        width: width,
                        //margin:EdgeInsets.symmetric(horizontal:_width/4.11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Center(
                            child: Text(
                          mainVariables.messagesListMain[index].currentDate,
                          style: TextStyle(
                              color: const Color(0XFF0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                        )),
                      )
                    : const SizedBox(),
                mainVariables.messagesListMain[index].reply.replyId == ""
                    ? mainVariables.messagesListMain[index].status.value == 3
                        ? deleteMessage(
                            context: context, modelSetState: modelSetState, isSender: mainVariables.messagesListMain[index].messageType != "receiver")
                        : FocusedMenuHolder(
                            menuWidth: width / 1.75,
                            blurSize: 5,
                            menuItemExtent: height / 21.65,
                            duration: const Duration(milliseconds: 100),
                            animateMenuItems: true,
                            blurBackgroundColor: Colors.transparent,
                            bottomOffsetHeight: height / 4.33,
                            openWithTap: true,
                            menuOffset: height / 43.3,
                            onPressed: () {
                              return true;
                            },
                            menuItems: mainVariables.messagesListMain[index].messageType == "receiver"
                                ? <FocusedMenuItem>[
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.copy,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        Clipboard.setData(ClipboardData(text: mainVariables.messagesListMain[index].messageContent.value));
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Reply",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.reply,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        mainVariables.isReplying.value = true;
                                        mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                                        mainVariables.isReplyingMessageId.value = mainVariables.messagesListMain[index].messageId;
                                        mainVariables.editingIndexMain.value = index;
                                        mainVariables.isReplyingMessage.value = mainVariables.messagesListMain[index].messageContent.value == ""
                                            ? "attachments"
                                            : mainVariables.messagesListMain[index].messageContent.value;
                                        mainVariables.replyUserDataMain = ReplyUser(
                                            replyId: mainVariables.messagesListMain[index].messageId,
                                            userId: "",
                                            avatar: "",
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            username: "",
                                            status: mainVariables.messagesListMain[index].status.value,
                                            files: mainVariables.messagesListMain[index].data);
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Forward",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: const Icon(
                                            Icons.reply,
                                            color: Color(0XFF0EA102),
                                          )),
                                      onPressed: () async {
                                        mainVariables.forwardMessage.value = mainVariables.messagesListMain[index].messageContent.value;
                                        billboardWidgetsMain.linkSharingTabBottomSheet(context: context, isFromShare: false);
                                      },
                                    ),
                                    FocusedMenuItem(
                                        title: SizedBox(
                                          width: width / 2.34,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red, fontSize: text.scale(14)),
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Color(0XFFFB1212),
                                        ),
                                        onPressed: () async {
                                          mainVariables.messagesListMain[index].status.value = 3;
                                          modelSetState(() {});
                                          conversationApiMain.getMessageDeleteFunction(
                                              context: context, messageId: mainVariables.messagesListMain[index].messageId, isSender: false);
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        }),
                                  ]
                                : <FocusedMenuItem>[
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.copy,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        Clipboard.setData(ClipboardData(text: mainVariables.messagesListMain[index].messageContent.value));
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Reply",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.reply,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        mainVariables.isReplying.value = true;
                                        mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                                        mainVariables.isReplyingMessageId.value = mainVariables.messagesListMain[index].messageId;
                                        mainVariables.editingIndexMain.value = index;
                                        mainVariables.isReplyingMessage.value = mainVariables.messagesListMain[index].messageContent.value == ""
                                            ? "attachments"
                                            : mainVariables.messagesListMain[index].messageContent.value;
                                        mainVariables.replyUserDataMain = ReplyUser(
                                            replyId: mainVariables.messagesListMain[index].messageId,
                                            userId: "",
                                            avatar: "",
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            username: "",
                                            status: mainVariables.messagesListMain[index].status.value,
                                            files: mainVariables.messagesListMain[index].data);
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Forward",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: const Icon(
                                            Icons.reply,
                                            color: Color(0XFF0EA102),
                                          )),
                                      onPressed: () async {
                                        mainVariables.forwardMessage.value = mainVariables.messagesListMain[index].messageContent.value;
                                        billboardWidgetsMain.linkSharingTabBottomSheet(context: context, isFromShare: false);
                                      },
                                    ),
                                    FocusedMenuItem(
                                        title: SizedBox(
                                          width: width / 2.34,
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(fontSize: text.scale(14)),
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.edit_note,
                                          color: Color(0XFF0EA102),
                                        ),
                                        onPressed: () {
                                          mainVariables.isEditing.value = true;
                                          mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                                          mainVariables.isEditingMessageId.value = mainVariables.messagesListMain[index].messageId;
                                          mainVariables.editingIndexMain.value = index;
                                          mainVariables.messageControllerMain.value.text = mainVariables.messagesListMain[index].messageContent.value;
                                          mainVariables.replyUserDataMain = ReplyUser(
                                              replyId: mainVariables.messagesListMain[index].reply.replyId,
                                              userId: mainVariables.messagesListMain[index].reply.userId,
                                              avatar: mainVariables.messagesListMain[index].reply.avatar,
                                              message: mainVariables.messagesListMain[index].reply.message,
                                              username: mainVariables.messagesListMain[index].reply.username,
                                              status: mainVariables.messagesListMain[index].reply.status,
                                              files: mainVariables.messagesListMain[index].reply.files);
                                        }),
                                    FocusedMenuItem(
                                        title: SizedBox(
                                          width: width / 2.34,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red, fontSize: text.scale(14)),
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Color(0XFFFB1212),
                                        ),
                                        onPressed: () async {
                                          mainVariables.messagesListMain[index].status.value = 3;
                                          modelSetState(() {});
                                          conversationApiMain.getMessageDeleteFunction(
                                              context: context, messageId: mainVariables.messagesListMain[index].messageId, isSender: true);
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        }),
                                  ],
                            isMe: mainVariables.messagesListMain[index].messageType != "receiver",
                            child: mainVariables.messagesListMain[index].messageType == "receiver"
                                ? replyCard(context: context, index: index, modelSetState: modelSetState)
                                : ownMessageCard(context: context, index: index, modelSetState: modelSetState),
                          )
                    : mainVariables.messagesListMain[index].status.value == 3
                        ? deleteMessage(
                            context: context, modelSetState: modelSetState, isSender: mainVariables.messagesListMain[index].messageType != "receiver")
                        : FocusedMenuHolder(
                            menuWidth: width / 1.75,
                            blurSize: 5,
                            menuItemExtent: height / 21.65,
                            duration: const Duration(milliseconds: 100),
                            animateMenuItems: true,
                            blurBackgroundColor: Colors.transparent,
                            bottomOffsetHeight: height / 4.33,
                            openWithTap: true,
                            menuOffset: height / 43.3,
                            onPressed: () {
                              return true;
                            },
                            menuItems: mainVariables.messagesListMain[index].messageType == "receiver"
                                ? <FocusedMenuItem>[
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.copy,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        Clipboard.setData(ClipboardData(text: mainVariables.messagesListMain[index].messageContent.value));
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Reply",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.reply,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        mainVariables.isReplying.value = true;
                                        mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                                        mainVariables.isReplyingMessageId.value = mainVariables.messagesListMain[index].messageId;
                                        mainVariables.editingIndexMain.value = index;
                                        mainVariables.isReplyingMessage.value = mainVariables.messagesListMain[index].messageContent.value == ""
                                            ? "attachments"
                                            : mainVariables.messagesListMain[index].messageContent.value;
                                        mainVariables.replyUserDataMain = ReplyUser(
                                            replyId: mainVariables.messagesListMain[index].messageId,
                                            userId: "",
                                            avatar: "",
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            username: "",
                                            status: mainVariables.messagesListMain[index].status.value,
                                            files: mainVariables.messagesListMain[index].data);
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Forward",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: const Icon(
                                            Icons.reply,
                                            color: Color(0XFF0EA102),
                                          )),
                                      onPressed: () async {
                                        mainVariables.forwardMessage.value = mainVariables.messagesListMain[index].messageContent.value;
                                        billboardWidgetsMain.linkSharingTabBottomSheet(context: context, isFromShare: false);
                                      },
                                    ),
                                    FocusedMenuItem(
                                        title: SizedBox(
                                          width: width / 2.34,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red, fontSize: text.scale(14)),
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Color(0XFFFB1212),
                                        ),
                                        onPressed: () async {
                                          mainVariables.messagesListMain[index].status.value = 3;
                                          modelSetState(() {});
                                          conversationApiMain.getMessageDeleteFunction(
                                              context: context, messageId: mainVariables.messagesListMain[index].messageId, isSender: false);
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        }),
                                  ]
                                : <FocusedMenuItem>[
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Copy",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.copy,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        Clipboard.setData(ClipboardData(text: mainVariables.messagesListMain[index].messageContent.value));
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Reply",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: const Icon(
                                        Icons.reply,
                                        color: Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        mainVariables.isReplying.value = true;
                                        mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                                        mainVariables.isReplyingMessageId.value = mainVariables.messagesListMain[index].messageId;
                                        mainVariables.editingIndexMain.value = index;
                                        mainVariables.isReplyingMessage.value = mainVariables.messagesListMain[index].messageContent.value == ""
                                            ? "attachments"
                                            : mainVariables.messagesListMain[index].messageContent.value;
                                        mainVariables.replyUserDataMain = ReplyUser(
                                            replyId: mainVariables.messagesListMain[index].messageId,
                                            userId: "",
                                            avatar: "",
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            username: "",
                                            status: mainVariables.messagesListMain[index].status.value,
                                            files: mainVariables.messagesListMain[index].data);
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: SizedBox(
                                        width: width / 2.34,
                                        child: Text(
                                          "Forward",
                                          style: TextStyle(fontSize: text.scale(14)),
                                        ),
                                      ),
                                      trailingIcon: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: const Icon(
                                            Icons.reply,
                                            color: Color(0XFF0EA102),
                                          )),
                                      onPressed: () async {
                                        mainVariables.forwardMessage.value = mainVariables.messagesListMain[index].messageContent.value;
                                        billboardWidgetsMain.linkSharingTabBottomSheet(context: context, isFromShare: false);
                                      },
                                    ),
                                    FocusedMenuItem(
                                        title: SizedBox(
                                          width: width / 2.34,
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(fontSize: text.scale(14)),
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.edit_note,
                                          color: Color(0XFF0EA102),
                                        ),
                                        onPressed: () {
                                          mainVariables.isEditing.value = true;
                                          mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                                          mainVariables.isEditingMessageId.value = mainVariables.messagesListMain[index].messageId;
                                          mainVariables.editingIndexMain.value = index;
                                          mainVariables.messageControllerMain.value.text = mainVariables.messagesListMain[index].messageContent.value;
                                          mainVariables.replyUserDataMain = ReplyUser(
                                              replyId: mainVariables.messagesListMain[index].reply.replyId,
                                              userId: mainVariables.messagesListMain[index].reply.userId,
                                              avatar: mainVariables.messagesListMain[index].reply.avatar,
                                              message: mainVariables.messagesListMain[index].reply.message,
                                              username: mainVariables.messagesListMain[index].reply.username,
                                              status: mainVariables.messagesListMain[index].reply.status,
                                              files: mainVariables.messagesListMain[index].reply.files);
                                        }),
                                    FocusedMenuItem(
                                        title: SizedBox(
                                          width: width / 2.34,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red, fontSize: text.scale(14)),
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Color(0XFFFB1212),
                                        ),
                                        onPressed: () async {
                                          mainVariables.messagesListMain[index].status.value = 3;
                                          modelSetState(() {});
                                          conversationApiMain.getMessageDeleteFunction(
                                              context: context, messageId: mainVariables.messagesListMain[index].messageId, isSender: true);
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        }),
                                  ],
                            isMe: mainVariables.messagesListMain[index].messageType != "receiver",
                            child: replyMessageCard(
                                context: context,
                                index: index,
                                modelSetState: modelSetState,
                                isSender: mainVariables.messagesListMain[index].messageType != "receiver",
                                replyUserData: mainVariables.messagesListMain[index].reply),
                          ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget replyCard({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => mainVariables.messagesListMain[index].status.value == 4
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                  margin: EdgeInsets.only(left: width / 8.22),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0EA102),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(0)),
                  ),
                  child: Text(
                    "Edited",
                    style: TextStyle(
                      fontSize: text.scale(10),
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        SizedBox(
          height: height / 288.67,
        ),
        Obx(
          () => mainVariables.messagesListMain[index].data.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    mainVariables.messagesListMain[index].messageContent.value == ""
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            child: billboardWidgetsMain.getProfile(
                                context: context,
                                heightValue: height / 21.65,
                                widthValue: width / 10.275,
                                myself: false,
                                isProfile: "user",
                                userId: mainVariables.conversationUserData.value.userId,
                                avatar: mainVariables.conversationUserData.value.avatar),
                          )
                        : Container(
                            height: height / 24.74,
                            width: width / 10.275,
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                          ),
                    InkWell(
                      onTap: () {
                        for (int i = 0; i < mainVariables.audioPlayerList.length; i++) {
                          mainVariables.audioPlayerList[i].pause();
                          mainVariables.audioPlayerList[i].seek(Duration.zero);
                          mainVariables.currentTimeList[i] = 0;
                          mainVariables.totalTimeList[i] = 1;
                          mainVariables.isPlayingList[i] = false;
                          mainVariables.isLoadingList[i] = false;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return FilePreviewPage(
                            data: mainVariables.messagesListMain[index].data,
                          );
                        }));
                      },
                      child: SizedBox(
                        height: mainVariables.messagesListMain[index].data.length == 1
                            ? mainVariables.messagesListMain[index].data[0].fileType == "audio"
                                ? height / 14.43
                                : mainVariables.messagesListMain[index].data[0].fileType == "video"
                                    ? height / 5.77
                                    : mainVariables.messagesListMain[index].data[0].fileType == "doc"
                                        ? height / 14.43
                                        : height / 4.33
                            : mainVariables.messagesListMain[index].data.length < 3
                                ? height / 86.6
                                : height / 4.33,
                        width: mainVariables.messagesListMain[index].data.length == 1
                            ? mainVariables.messagesListMain[index].data[0].fileType == "audio"
                                ? width / 2.05
                                : mainVariables.messagesListMain[index].data[0].fileType == "video"
                                    ? width / 1.64
                                    : mainVariables.messagesListMain[index].data[0].fileType == "doc"
                                        ? width / 2.055
                                        : width / 2.74
                            : width / 2.055,
                        child: Center(
                          child: mainVariables.messagesListMain[index].data.length == 1
                              ? Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                  child: mainVariables.messagesListMain[index].data[0].fileType == "image"
                                      ? Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: BorderRadius.circular(15),
                                                      image: DecorationImage(
                                                          image: NetworkImage(mainVariables.messagesListMain[index].data[0].file), fit: BoxFit.fill)),
                                                ),
                                              ),
                                              mainVariables.messagesListMain[index].messageContent.value != ""
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.only(bottom: height / 173.2, right: width / 51.375),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                                            style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: text.scale(10),
                                                                fontWeight: FontWeight.w400,
                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                        )
                                      : mainVariables.messagesListMain[index].data[0].fileType == "video"
                                          ? Container(
                                              height: height / 5.77,
                                              width: width / 1.64,
                                              margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black26.withOpacity(0.1),
                                                    offset: const Offset(0.0, 0.0),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: height / 108.25, left: width / 51.375),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: width / 51.375,
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Icon(
                                                              Icons.video_camera_back,
                                                              color: Colors.white54,
                                                              size: 20,
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            mainVariables.messagesListMain[index].data[0].fileName,
                                                            style: TextStyle(fontSize: text.scale(12), color: Colors.white54),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: height / 24.74,
                                                      width: width / 11.74,
                                                      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                                                      child: const Icon(
                                                        Icons.play_arrow_sharp,
                                                        color: Colors.black,
                                                        size: 35,
                                                      ),
                                                    ),
                                                  ),
                                                  mainVariables.messagesListMain[index].messageContent.value != ""
                                                      ? const SizedBox()
                                                      : Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height / 173.2),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                                                style: TextStyle(
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: text.scale(10),
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.white),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                ],
                                              ),
                                            )
                                          : mainVariables.messagesListMain[index].data[0].fileType == "audio"
                                              ? audioWidget(
                                                  context: context,
                                                  path: mainVariables.messagesListMain[index].data[0].file,
                                                  index: index,
                                                  modelSetState: modelSetState)
                                              : mainVariables.messagesListMain[index].data[0].fileType == "doc"
                                                  ? Container(
                                                      height: height / 14.43,
                                                      width: width / 2.055,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          // border: Border.all(color: Colors.grey.shade200, width: 1.5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                                                blurRadius: 2.0,
                                                                spreadRadius: 0.0)
                                                          ]),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: height / 14.43,
                                                            width: width / 9.13,
                                                            decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                              color: const Color(0XFF0EA102).withOpacity(0.8),
                                                            ),
                                                            child: const Icon(
                                                              Icons.file_copy_outlined,
                                                              color: Colors.white60,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width / 51.375,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: height / 108.25),
                                                                  child: Text(
                                                                    mainVariables.messagesListMain[index].data[0].fileName,
                                                                    style: TextStyle(color: Colors.black, fontSize: text.scale(13)),
                                                                  ),
                                                                ),
                                                                mainVariables.messagesListMain[index].messageContent.value != ""
                                                                    ? const SizedBox()
                                                                    : Padding(
                                                                        padding: EdgeInsets.only(bottom: height / 173.2, right: width / 51.375),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              DateFormat('hh:mm a')
                                                                                  .format(mainVariables.messagesListMain[index].currentTime),
                                                                              style: TextStyle(
                                                                                  fontStyle: FontStyle.italic,
                                                                                  fontSize: text.scale(10),
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.black26),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "lib/Constants/Assets/Settings/coverImage_default.png",
                                                      fit: BoxFit.fill,
                                                      height: height / 4.33,
                                                      width: width / 2.74,
                                                    ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).colorScheme.background,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26.withOpacity(0.1),
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 1.0,
                                            spreadRadius: 2.0)
                                      ]
                                      //border: Border.all(color: Colors.grey,width: 1.5)
                                      ),
                                  child: GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0,
                                      ),
                                      itemCount: mainVariables.messagesListMain[index].data.length < 5
                                          ? mainVariables.messagesListMain[index].data.length
                                          : 4,
                                      itemBuilder: (BuildContext context, int gridIndex) {
                                        return mainVariables.messagesListMain[index].data.length > 4 && gridIndex == 3
                                            ? Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 102.75, vertical: height / 216.5),
                                                decoration:
                                                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black.withOpacity(0.3)),
                                                clipBehavior: Clip.hardEdge,
                                                child: Center(
                                                  child: Container(
                                                    height: height / 24.74,
                                                    width: width / 11.74,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                    child: Center(
                                                      child: Text(
                                                        "${mainVariables.messagesListMain[index].data.length - 3}+",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: text.scale(14),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            : Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 102.75, vertical: height / 216.5),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 0.5)),
                                                clipBehavior: Clip.hardEdge,
                                                child: mainVariables.messagesListMain[index].data[gridIndex].fileType == "image"
                                                    ? Image.network(
                                                        mainVariables.messagesListMain[index].data[gridIndex].file,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : mainVariables.messagesListMain[index].data[gridIndex].fileType == "video"
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Theme.of(context).colorScheme.onBackground,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: height / 86.6,
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Container(
                                                                      height: height / 30,
                                                                      width: width / 15,
                                                                      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                                                                      child: const Icon(
                                                                        Icons.play_arrow_sharp,
                                                                        color: Colors.black,
                                                                        size: 25,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        DateFormat('hh:mm a')
                                                                            .format(mainVariables.messagesListMain[index].currentTime),
                                                                        style: TextStyle(
                                                                            fontStyle: FontStyle.italic,
                                                                            fontSize: text.scale(8),
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : mainVariables.messagesListMain[index].data[gridIndex].fileType == "audio"
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(context).colorScheme.onBackground,
                                                                    borderRadius: BorderRadius.circular(8)),
                                                                clipBehavior: Clip.hardEdge,
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height: height / 86.6,
                                                                    ),
                                                                    Expanded(
                                                                      child: Center(
                                                                        child: Container(
                                                                          height: height / 34.64,
                                                                          width: width / 16.44,
                                                                          decoration:
                                                                              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                                          child: const Icon(
                                                                            Icons.multitrack_audio,
                                                                            color: Colors.white,
                                                                            size: 25,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            DateFormat('hh:mm a')
                                                                                .format(mainVariables.messagesListMain[index].currentTime),
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                fontSize: text.scale(8),
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : mainVariables.messagesListMain[index].data[gridIndex].fileType == "doc"
                                                                ? Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Theme.of(context).colorScheme.onBackground,
                                                                        borderRadius: BorderRadius.circular(8)),
                                                                    clipBehavior: Clip.hardEdge,
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: height / 86.6,
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Container(
                                                                              height: height / 24.74,
                                                                              width: width / 11.74,
                                                                              decoration:
                                                                                  const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                                              child: const Icon(
                                                                                Icons.file_copy_outlined,
                                                                                color: Colors.white,
                                                                                size: 20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                DateFormat('hh:mm a')
                                                                                    .format(mainVariables.messagesListMain[index].currentTime),
                                                                                style: TextStyle(
                                                                                    fontStyle: FontStyle.italic,
                                                                                    fontSize: text.scale(8),
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Image.asset(
                                                                    "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                    fit: BoxFit.fill,
                                                                    height: height / 8.66,
                                                                    width: width / 4.11,
                                                                  ),
                                              );
                                      }),
                                ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
        Obx(
          () => mainVariables.messagesListMain[index].messageContent.value == ""
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                      child: billboardWidgetsMain.getProfile(
                          context: context,
                          heightValue: height / 21.65,
                          widthValue: width / 10.275,
                          myself: false,
                          isProfile: "user",
                          userId: mainVariables.conversationUserData.value.userId,
                          avatar: mainVariables.conversationUserData.value.avatar),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 51.375),
                      margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0XFF0EA102).withOpacity(0.2), offset: const Offset(0.5, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                          ]),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              mainVariables.messagesListMain[index].messageContent.value.length > 30
                                  ? SizedBox(
                                      width: width * 0.6,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: conversationFunctionsMain.spanList(
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            context: context,
                                          ),
                                        ),
                                      ),
                                    )
                                  : mainVariables.messagesListMain[index].messageContent.value.length < 6
                                      ? SizedBox(
                                          width: width * 0.2,
                                          child: RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                                children: conversationFunctionsMain.spanList(
                                              message: mainVariables.messagesListMain[index].messageContent.value,
                                              context: context,
                                            )),
                                          ),
                                        )
                                      : RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              children: conversationFunctionsMain.spanList(
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            context: context,
                                          )),
                                        ),
                              SizedBox(
                                height: height / 57.73,
                              ),
                            ],
                          ),
                          Text(
                            DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                            style: TextStyle(
                              fontSize: text.scale(10),
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (mainVariables.messagesListMain[index].isTranslated.value) {
                            mainVariables.messagesListMain[index].messageContent.value = mainVariables.messagesListMain[index].tempMessage.value;
                            mainVariables.messagesListMain[index].isTranslated.value = false;
                          } else {
                            bool response =
                                await conversationApiMain.translatingChatFunc(id: mainVariables.messagesListMain[index].messageId, index: index);
                            if (response) {
                              mainVariables.messagesListMain[index].isTranslated.value = true;
                            }
                          }
                        },
                        child: Card(
                          elevation: 2.0,
                          shadowColor: const Color(0XFF0EA102),
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                          child: Container(
                            height: height / 34.64,
                            width: width / 16.44,
                            padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Image.asset(mainVariables.messagesListMain[index].isTranslated.value
                                  ? "lib/Constants/Assets/Settings/translation_enabled.png"
                                  : "lib/Constants/Assets/Settings/translation.png"),
                            ),
                          ),
                          /*child: Image.asset(
                  translationList[index]?
                  "lib/Constants/Assets/Settings/translation_logo_filled.png":
                  "lib/Constants/Assets/Settings/translation_logo.png"),*/
                        ))
                  ],
                ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget ownMessageCard({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(
          () => mainVariables.messagesListMain[index].status.value == 4
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                  margin: EdgeInsets.only(right: width / 8.22),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0EA102),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(15)),
                  ),
                  child: Text(
                    "Edited",
                    style: TextStyle(
                      fontSize: text.scale(10),
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        const SizedBox(
          height: 3,
        ),
        Obx(
          () => mainVariables.messagesListMain[index].data.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        for (int i = 0; i < mainVariables.audioPlayerList.length; i++) {
                          mainVariables.audioPlayerList[i].pause();
                          mainVariables.audioPlayerList[i].seek(Duration.zero);
                          mainVariables.currentTimeList[i] = 0;
                          mainVariables.totalTimeList[i] = 1;
                          mainVariables.isPlayingList[i] = false;
                          mainVariables.isLoadingList[i] = false;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return FilePreviewPage(
                            data: mainVariables.messagesListMain[index].data,
                          );
                        }));
                      },
                      child: SizedBox(
                        height: mainVariables.messagesListMain[index].data.length == 1
                            ? mainVariables.messagesListMain[index].data[0].fileType == "audio"
                                ? height / 14.43
                                : mainVariables.messagesListMain[index].data[0].fileType == "video"
                                    ? height / 5.77
                                    : mainVariables.messagesListMain[index].data[0].fileType == "doc"
                                        ? height / 14.43
                                        : height / 4.33
                            : mainVariables.messagesListMain[index].data.length < 3
                                ? height / 8.66
                                : height / 4.33,
                        width: mainVariables.messagesListMain[index].data.length == 1
                            ? mainVariables.messagesListMain[index].data[0].fileType == "audio"
                                ? width / 2.055
                                : mainVariables.messagesListMain[index].data[0].fileType == "video"
                                    ? width / 1.644
                                    : mainVariables.messagesListMain[index].data[0].fileType == "doc"
                                        ? width / 2.055
                                        : width / 2.74
                            : width / 2.055,
                        child: Center(
                          child: mainVariables.messagesListMain[index].data.length == 1
                              ? Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                  child: mainVariables.messagesListMain[index].data[0].fileType == "image"
                                      ? Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: BorderRadius.circular(15),
                                                      image: DecorationImage(
                                                          image: NetworkImage(mainVariables.messagesListMain[index].data[0].file), fit: BoxFit.fill)),
                                                ),
                                              ),
                                              mainVariables.messagesListMain[index].messageContent.value != ""
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.only(bottom: height / 173.2, right: width / 51.375),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                                            style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: text.scale(10),
                                                                fontWeight: FontWeight.w400,
                                                                color: Theme.of(context).colorScheme.onPrimary),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                        )
                                      : mainVariables.messagesListMain[index].data[0].fileType == "video"
                                          ? Container(
                                              height: height / 5.77,
                                              width: width / 1.644,
                                              margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black26.withOpacity(0.1),
                                                    offset: const Offset(0.0, 0.0),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: height / 108.25, left: width / 51.375),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: width / 82.2,
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Icon(
                                                              Icons.video_camera_back,
                                                              color: Colors.white54,
                                                              size: 20,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: width / 82.2,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            mainVariables.messagesListMain[index].data[0].fileName,
                                                            style: TextStyle(fontSize: text.scale(12), color: Colors.white54),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: height / 24.74,
                                                      width: width / 11.74,
                                                      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                                                      child: const Icon(
                                                        Icons.play_arrow_sharp,
                                                        color: Colors.black,
                                                        size: 35,
                                                      ),
                                                    ),
                                                  ),
                                                  mainVariables.messagesListMain[index].messageContent.value != ""
                                                      ? const SizedBox()
                                                      : Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height / 108.25),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                                                style: TextStyle(
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: text.scale(10),
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.white),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                ],
                                              ),
                                            )
                                          : mainVariables.messagesListMain[index].data[0].fileType == "audio"
                                              ? audioWidget(
                                                  context: context,
                                                  path: mainVariables.messagesListMain[index].data[0].file,
                                                  index: index,
                                                  modelSetState: modelSetState)
                                              : mainVariables.messagesListMain[index].data[0].fileType == "doc"
                                                  ? Container(
                                                      height: height / 14.43,
                                                      width: width / 2.055,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          color: Theme.of(context).colorScheme.background,
                                                          //border: Border.all(color: Colors.grey.shade500, width: 1.5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                                                blurRadius: 2.0,
                                                                spreadRadius: 0.0)
                                                          ]),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: height / 14.43,
                                                            width: width / 9.13,
                                                            decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                              color: const Color(0XFF0EA102).withOpacity(0.8),
                                                            ),
                                                            child: const Icon(
                                                              Icons.file_copy_outlined,
                                                              color: Colors.white60,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width / 51.375,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: height / 108.25),
                                                                  child: Text(
                                                                    mainVariables.messagesListMain[index].data[0].fileName,
                                                                    style: TextStyle(fontSize: text.scale(13)),
                                                                  ),
                                                                ),
                                                                mainVariables.messagesListMain[index].messageContent.value != ""
                                                                    ? const SizedBox()
                                                                    : Padding(
                                                                        padding: EdgeInsets.only(bottom: height / 173.2, right: width / 51.375),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              DateFormat('hh:mm a')
                                                                                  .format(mainVariables.messagesListMain[index].currentTime),
                                                                              style: TextStyle(
                                                                                  fontStyle: FontStyle.italic,
                                                                                  fontSize: text.scale(10),
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "lib/Constants/Assets/Settings/coverImage_default.png",
                                                      fit: BoxFit.fill,
                                                      height: height / 4.33,
                                                      width: width / 2.74,
                                                    ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context).colorScheme.background,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 2.0),
                                    ],
                                  ),
                                  child: GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0,
                                      ),
                                      itemCount: mainVariables.messagesListMain[index].data.length < 5
                                          ? mainVariables.messagesListMain[index].data.length
                                          : 4,
                                      itemBuilder: (BuildContext context, int gridIndex) {
                                        return mainVariables.messagesListMain[index].data.length > 4 && gridIndex == 3
                                            ? Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 102.75, vertical: height / 216.5),
                                                decoration:
                                                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black.withOpacity(0.3)),
                                                clipBehavior: Clip.hardEdge,
                                                child: Center(
                                                  child: Container(
                                                    height: height / 24.74,
                                                    width: width / 11.74,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                    child: Center(
                                                      child: Text(
                                                        "${mainVariables.messagesListMain[index].data.length - 3}+",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: text.scale(14),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            : Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 102.75, vertical: height / 216.5),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 0.5)),
                                                clipBehavior: Clip.hardEdge,
                                                child: mainVariables.messagesListMain[index].data[gridIndex].fileType == "image"
                                                    ? Image.network(
                                                        mainVariables.messagesListMain[index].data[gridIndex].file,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : mainVariables.messagesListMain[index].data[gridIndex].fileType == "video"
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Theme.of(context).colorScheme.onBackground,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: height / 86.6,
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Container(
                                                                      height: height / 30,
                                                                      width: width / 15,
                                                                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                                      child: const Icon(
                                                                        Icons.play_arrow_sharp,
                                                                        color: Colors.white,
                                                                        size: 25,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        DateFormat('hh:mm a')
                                                                            .format(mainVariables.messagesListMain[index].currentTime),
                                                                        style: TextStyle(
                                                                            fontStyle: FontStyle.italic,
                                                                            fontSize: text.scale(8),
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : mainVariables.messagesListMain[index].data[gridIndex].fileType == "audio"
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(context).colorScheme.onBackground,
                                                                    borderRadius: BorderRadius.circular(8)),
                                                                clipBehavior: Clip.hardEdge,
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height: height / 86.6,
                                                                    ),
                                                                    Expanded(
                                                                      child: Center(
                                                                        child: Container(
                                                                          height: height / 34.64,
                                                                          width: width / 16.44,
                                                                          decoration:
                                                                              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                                          child: const Icon(
                                                                            Icons.multitrack_audio,
                                                                            color: Colors.white,
                                                                            size: 25,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                              DateFormat('hh:mm a')
                                                                                  .format(mainVariables.messagesListMain[index].currentTime),
                                                                              style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                fontSize: text.scale(8),
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : mainVariables.messagesListMain[index].data[gridIndex].fileType == "doc"
                                                                ? Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Theme.of(context).colorScheme.onBackground,
                                                                        borderRadius: BorderRadius.circular(8)),
                                                                    clipBehavior: Clip.hardEdge,
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: height / 86.6,
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Container(
                                                                              height: height / 24.74,
                                                                              width: width / 11.74,
                                                                              decoration:
                                                                                  const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                                              child: const Icon(
                                                                                Icons.file_copy_outlined,
                                                                                color: Colors.white,
                                                                                size: 20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                DateFormat('hh:mm a')
                                                                                    .format(mainVariables.messagesListMain[index].currentTime),
                                                                                style: TextStyle(
                                                                                    fontStyle: FontStyle.italic,
                                                                                    fontSize: text.scale(8),
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Image.asset(
                                                                    "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                    fit: BoxFit.fill,
                                                                    height: height / 8.66,
                                                                    width: width / 4.11,
                                                                  ),
                                              );
                                      }),
                                ),
                        ),
                      ),
                    ),
                    mainVariables.messagesListMain[index].messageContent.value == ""
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            child: billboardWidgetsMain.getProfile(
                              context: context,
                              heightValue: height / 24.74,
                              widthValue: width / 16.44,
                              myself: true,
                              isProfile: "user",
                              userId: userIdMain,
                            ),
                          )
                        : Container(
                            height: height / 24.74,
                            width: width / 10.275,
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                          ),
                  ],
                )
              : const SizedBox(),
        ),
        Obx(
          () => mainVariables.messagesListMain[index].messageContent.value == ""
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          if (mainVariables.messagesListMain[index].isTranslated.value) {
                            mainVariables.messagesListMain[index].messageContent.value = mainVariables.messagesListMain[index].tempMessage.value;
                            mainVariables.messagesListMain[index].isTranslated.value = false;
                          } else {
                            bool response =
                                await conversationApiMain.translatingChatFunc(id: mainVariables.messagesListMain[index].messageId, index: index);
                            if (response) {
                              mainVariables.messagesListMain[index].isTranslated.value = true;
                            }
                          }
                        },
                        child: Card(
                          elevation: 2.0,
                          shadowColor: const Color(0XFF0EA102),
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                          child: Container(
                            height: height / 34.64,
                            width: width / 16.44,
                            padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Image.asset(mainVariables.messagesListMain[index].isTranslated.value
                                  ? "lib/Constants/Assets/Settings/translation_enabled.png"
                                  : "lib/Constants/Assets/Settings/translation.png"),
                            ),
                          ),
                          /*child: Image.asset(
                  translationList[index]?
                  "lib/Constants/Assets/Settings/translation_logo_filled.png":
                  "lib/Constants/Assets/Settings/translation_logo.png"),*/
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                      padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 51.375),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0XFF0EA102).withOpacity(0.2), offset: const Offset(0.5, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                          ]),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mainVariables.messagesListMain[index].messageContent.value.length > 30
                                  ? SizedBox(
                                      width: width * 0.6,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: conversationFunctionsMain.spanList(
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            context: context,
                                          ),
                                        ),
                                      ),
                                    )
                                  : mainVariables.messagesListMain[index].messageContent.value.length < 6
                                      ? SizedBox(
                                          width: width * 0.2,
                                          child: RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                                children: conversationFunctionsMain.spanList(
                                              message: mainVariables.messagesListMain[index].messageContent.value,
                                              context: context,
                                            )),
                                          ))
                                      : RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              children: conversationFunctionsMain.spanList(
                                            message: mainVariables.messagesListMain[index].messageContent.value,
                                            context: context,
                                          )),
                                        ),
                              SizedBox(
                                height: height / 57.73,
                              ),
                            ],
                          ),
                          Text(
                            DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                            style: TextStyle(
                              fontSize: text.scale(10),
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                      child: billboardWidgetsMain.getProfile(
                        context: context,
                        heightValue: height / 24.74,
                        widthValue: width / 16.44,
                        myself: true,
                        isProfile: "user",
                        userId: userIdMain,
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(
          height: height / 86.6,
        ),
      ],
    );
  }

  Widget audioWidget({
    required BuildContext context,
    required String path,
    required int index,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => Container(
          height: height / 14.43,
          width: width / 2.055,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            // border: Border.all(color: Colors.grey.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                spreadRadius: 0.0,
                blurRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (mainVariables.audioPlayerList[index].playing) {
                      mainVariables.audioPlayerList[index].pause();
                      modelSetState(() {
                        mainVariables.isPlayingList[index] = false;
                      });
                    } else {
                      modelSetState(() {
                        mainVariables.isPlayingList[index] = true;
                        mainVariables.isLoadingList[index] = true;
                      });
                      if (mainVariables.currentTimeList[index] == 0) {
                        await mainVariables.audioPlayerList[index].setUrl(path);
                        mainVariables.totalTimeList[index] = mainVariables.audioPlayerList[index].duration!.inSeconds;
                        mainVariables.currentTimeList[index] = (Duration.zero).inSeconds;
                      }
                      for (int i = 0; i < mainVariables.audioPlayerList.length; i++) {
                        if (i == index) {
                          mainVariables.audioPlayerList[index].play();
                          mainVariables.isLoadingList[index] = false;
                          mainVariables.audioPlayerList[index].positionStream.listen((event) {
                            if (event != mainVariables.audioPlayerList[index].duration) {
                              mainVariables.currentTimeList[index] = event.inSeconds;
                            } else if (event == mainVariables.audioPlayerList[index].duration) {
                              mainVariables.audioPlayerList[index].pause();
                              mainVariables.audioPlayerList[index].seek(Duration.zero);
                              mainVariables.currentTimeList[index] = 0;
                              mainVariables.totalTimeList[index] = mainVariables.audioPlayerList[index].duration!.inSeconds;
                              mainVariables.isPlayingList[index] = false;
                            } else {
                              mainVariables.audioPlayerList[index].pause();
                              mainVariables.audioPlayerList[index].seek(Duration.zero);
                              mainVariables.currentTimeList[index] = 0;
                              mainVariables.totalTimeList[index] = mainVariables.audioPlayerList[index].duration!.inSeconds;
                              mainVariables.isPlayingList[index] = false;
                            }
                            modelSetState(() {});
                          });
                        } else {
                          mainVariables.audioPlayerList[i].pause();
                          mainVariables.isPlayingList[i] = false;
                          mainVariables.isLoadingList[i] = false;
                          modelSetState(() {});
                        }
                      }
                    }
                  },
                  child: Container(
                    width: width / 9.13,
                    height: height / 14.43,
                    decoration: BoxDecoration(
                        color: const Color(0XFF0EA102).withOpacity(0.8),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
                    child: Center(
                      child: Icon(
                        mainVariables.isPlayingList[index] ? Icons.pause_circle_filled : Icons.play_circle,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    mainVariables.isLoadingList[index]
                        ? Shimmer.fromColors(
                            enabled: true,
                            baseColor: Colors.white,
                            highlightColor: Colors.grey.withOpacity(0.5),
                            direction: ShimmerDirection.ltr,
                            child: Container(
                              height: height / 14.43,
                              width: width / 2.74,
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
                            width: width / 2.74,
                            padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            foregroundDecoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                                image: DecorationImage(
                                  image: AssetImage("lib/Constants/Assets/BillBoard/Subtractlatest.png"),
                                  fit: BoxFit.fill,
                                )),
                            child: Obx(() => LinearProgressIndicator(
                                  value: (mainVariables.currentTimeList[index]) / mainVariables.totalTimeList[index],
                                  color: Colors.green /*Color(0XFF0EA102)*/,
                                  backgroundColor: Colors.green.withOpacity(0.5),
                                )),
                          ),
                    Padding(
                      padding: EdgeInsets.only(right: width / 51.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                            style:
                                TextStyle(fontStyle: FontStyle.italic, fontSize: text.scale(10), fontWeight: FontWeight.w400, color: Colors.black26),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget deleteMessage({
    required BuildContext context,
    required StateSetter modelSetState,
    required bool isSender,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isSender
            ? const SizedBox()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                child: billboardWidgetsMain.getProfile(
                    context: context,
                    heightValue: height / 21.65,
                    widthValue: width / 10.275,
                    myself: false,
                    isProfile: "user",
                    userId: mainVariables.conversationUserData.value.userId,
                    avatar: mainVariables.conversationUserData.value.avatar),
              ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
          padding: EdgeInsets.symmetric(vertical: height / 108.25, horizontal: width / 27.4),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.only(
                  topRight: isSender ? const Radius.circular(0) : const Radius.circular(15),
                  topLeft: isSender ? const Radius.circular(15) : const Radius.circular(0),
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15)),
              boxShadow: [
                BoxShadow(color: const Color(0XFF0EA102).withOpacity(0.2), offset: const Offset(0.5, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
              ]),
          child: Center(
              child: Text(
            isSender ? "You deleted this message" : "${mainVariables.conversationUserData.value.userName} deleted this message",
            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
          )),
        ),
        isSender
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                child: billboardWidgetsMain.getProfile(
                  context: context,
                  heightValue: height / 24.74,
                  widthValue: width / 16.44,
                  myself: true,
                  isProfile: "user",
                  userId: userIdMain,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget replyMessageCard({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
    required ReplyUser replyUserData,
    required bool isSender,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return isSender
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => mainVariables.messagesListMain[index].status.value == 4
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                        margin: EdgeInsets.only(right: width / 8.22),
                        decoration: const BoxDecoration(
                          color: Color(0XFF0EA102),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15)),
                        ),
                        child: Text(
                          "Edited",
                          style: TextStyle(
                            fontSize: text.scale(10),
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(
                height: height / 288.6,
              ),
              Obx(
                () => replyUserData.message == ""
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (mainVariables.messagesListMain[index].isTranslated.value) {
                                mainVariables.messagesListMain[index].messageContent.value = mainVariables.messagesListMain[index].tempMessage.value;
                                mainVariables.messagesListMain[index].isTranslated.value = false;
                              } else {
                                bool response =
                                    await conversationApiMain.translatingChatFunc(id: mainVariables.messagesListMain[index].messageId, index: index);
                                if (response) {
                                  mainVariables.messagesListMain[index].isTranslated.value = true;
                                }
                              }
                            },
                            child: Card(
                              elevation: 2.0,
                              shadowColor: const Color(0XFF0EA102),
                              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                              child: Container(
                                height: height / 34.64,
                                width: width / 16.44,
                                padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Image.asset(mainVariables.messagesListMain[index].isTranslated.value
                                      ? "lib/Constants/Assets/Settings/translation_enabled.png"
                                      : "lib/Constants/Assets/Settings/translation.png"),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 51.375),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0XFF0EA102).withOpacity(0.2),
                                      offset: const Offset(0.5, -0.5),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0)
                                ]),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        conversationFunctionsMain.handleReplyToMessage(originalMessage: replyUserData.message, context: context);
                                        for (int i = 0; i < mainVariables.messagesListMain.length; i++) {
                                          if (mainVariables.messagesListMain[i].messageId == replyUserData.replyId) {
                                            //   conversationFunctionsMain.animateToIndex(i);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height / 108.25),
                                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6)),
                                        child: Text(
                                          replyUserData.status == 3 ? "deleted message" : "attachments",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: replyUserData.status == 3 ? text.scale(8) : text.scale(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        mainVariables.messagesListMain[index].messageContent.value.length > 40
                                            ? SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  mainVariables.messagesListMain[index].status.value == 3
                                                      ? "deleted message"
                                                      : mainVariables.messagesListMain[index].messageContent.value,
                                                  style: TextStyle(
                                                    fontSize:
                                                        mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                mainVariables.messagesListMain[index].status.value == 3
                                                    ? "deleted message"
                                                    : mainVariables.messagesListMain[index].messageContent.value,
                                                style: TextStyle(
                                                  fontSize: mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                ),
                                              ),
                                        SizedBox(
                                          height: height / 57.73,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                  style: TextStyle(
                                    fontSize: text.scale(10),
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            child: billboardWidgetsMain.getProfile(
                              context: context,
                              heightValue: height / 24.74,
                              widthValue: width / 16.44,
                              myself: true,
                              isProfile: "user",
                              userId: userIdMain,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                if (mainVariables.messagesListMain[index].isTranslated.value) {
                                  mainVariables.messagesListMain[index].messageContent.value =
                                      mainVariables.messagesListMain[index].tempMessage.value;
                                  mainVariables.messagesListMain[index].isTranslated.value = false;
                                } else {
                                  bool response = await conversationApiMain.translatingChatFunc(
                                      id: mainVariables.messagesListMain[index].messageId, index: index);
                                  if (response) {
                                    mainVariables.messagesListMain[index].isTranslated.value = true;
                                  }
                                }
                              },
                              child: Card(
                                elevation: 2.0,
                                shadowColor: const Color(0XFF0EA102),
                                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                                child: Container(
                                  height: height / 34.64,
                                  width: width / 16.44,
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Image.asset(mainVariables.messagesListMain[index].isTranslated.value
                                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                                        : "lib/Constants/Assets/Settings/translation.png"),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 51.375),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0XFF0EA102).withOpacity(0.2),
                                      offset: const Offset(0.5, -0.5),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0)
                                ]),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        conversationFunctionsMain.handleReplyToMessage(originalMessage: replyUserData.message, context: context);
                                        for (int i = 0; i < mainVariables.messagesListMain.length; i++) {
                                          debugPrint("replyUserData.replyId");
                                          debugPrint(replyUserData.replyId);
                                          debugPrint(mainVariables.messagesListMain[i].messageId);
                                          if (mainVariables.messagesListMain[i].messageId == replyUserData.replyId) {
                                            // conversationFunctionsMain.handleReplyToMessage(originalMessage: mainVariables.messagesListMain[i].messageContent.value, context: context);
                                            //conversationFunctionsMain.animateToIndex(i);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height / 108.25),
                                        decoration:
                                            BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.circular(6)),
                                        child: replyUserData.message.length > 40
                                            ? SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  replyUserData.status == 3 ? "deleted message" : replyUserData.message,
                                                  style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: replyUserData.status == 3 ? text.scale(8) : text.scale(14),
                                                      overflow: TextOverflow.ellipsis),
                                                  maxLines: 1,
                                                ),
                                              )
                                            : Text(
                                                replyUserData.status == 3 ? "deleted message" : replyUserData.message,
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: replyUserData.status == 3 ? text.scale(8) : text.scale(14),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        mainVariables.messagesListMain[index].messageContent.value.length > 40
                                            ? SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  mainVariables.messagesListMain[index].status.value == 3
                                                      ? "deleted message"
                                                      : mainVariables.messagesListMain[index].messageContent.value,
                                                  style: TextStyle(
                                                    fontSize:
                                                        mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                mainVariables.messagesListMain[index].status.value == 3
                                                    ? "deleted message"
                                                    : mainVariables.messagesListMain[index].messageContent.value,
                                                style: TextStyle(
                                                  fontSize: mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                ),
                                              ),
                                        SizedBox(
                                          height: height / 57.73,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                  style: TextStyle(
                                    fontSize: text.scale(10),
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            child: billboardWidgetsMain.getProfile(
                              context: context,
                              heightValue: height / 24.74,
                              widthValue: width / 16.44,
                              myself: true,
                              isProfile: "user",
                              userId: userIdMain,
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: height / 86.6,
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => mainVariables.messagesListMain[index].status.value == 4
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                        margin: EdgeInsets.only(left: width / 8.22),
                        decoration: const BoxDecoration(
                          color: Color(0XFF0EA102),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(0)),
                        ),
                        child: Text(
                          "Edited",
                          style: TextStyle(
                            fontSize: text.scale(10),
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(
                height: height / 288.6,
              ),
              Obx(
                () => replyUserData.message == ""
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            child: billboardWidgetsMain.getProfile(
                                context: context,
                                heightValue: height / 21.65,
                                widthValue: width / 10.275,
                                myself: false,
                                isProfile: "user",
                                userId: mainVariables.conversationUserData.value.userId,
                                avatar: mainVariables.conversationUserData.value.avatar),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 51.375),
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0XFF0EA102).withOpacity(0.2),
                                      offset: const Offset(0.5, -0.5),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0)
                                ]),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        conversationFunctionsMain.handleReplyToMessage(originalMessage: replyUserData.message, context: context);
                                        for (int i = 0; i < mainVariables.messagesListMain.length; i++) {
                                          if (mainVariables.messagesListMain[i].messageId == replyUserData.replyId) {
                                            //conversationFunctionsMain.animateToIndex(i);
                                            // conversationFunctionsMain.handleReplyToMessage(originalMessage: mainVariables.messagesListMain[i].messageContent.value, context: context);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height / 108.25),
                                        decoration:
                                            BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.circular(6)),
                                        child: Text(
                                          replyUserData.status == 3 ? "deleted message" : "attachments",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: replyUserData.status == 3 ? text.scale(8) : text.scale(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        mainVariables.messagesListMain[index].messageContent.value.length > 40
                                            ? SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  mainVariables.messagesListMain[index].status.value == 3
                                                      ? "deleted message"
                                                      : mainVariables.messagesListMain[index].messageContent.value,
                                                  style: TextStyle(
                                                    fontSize:
                                                        mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                mainVariables.messagesListMain[index].status.value == 3
                                                    ? "deleted message"
                                                    : mainVariables.messagesListMain[index].messageContent.value,
                                                style: TextStyle(
                                                  fontSize: mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                ),
                                              ),
                                        SizedBox(
                                          height: height / 57.73,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                  style: TextStyle(
                                    fontSize: text.scale(10),
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (mainVariables.messagesListMain[index].isTranslated.value) {
                                  mainVariables.messagesListMain[index].messageContent.value =
                                      mainVariables.messagesListMain[index].tempMessage.value;
                                  mainVariables.messagesListMain[index].isTranslated.value = false;
                                } else {
                                  bool response = await conversationApiMain.translatingChatFunc(
                                      id: mainVariables.messagesListMain[index].messageId, index: index);
                                  if (response) {
                                    mainVariables.messagesListMain[index].isTranslated.value = true;
                                  }
                                }
                              },
                              child: Card(
                                elevation: 2.0,
                                shadowColor: const Color(0XFF0EA102),
                                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                                child: Container(
                                  height: height / 34.64,
                                  width: width / 16.44,
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Image.asset(mainVariables.messagesListMain[index].isTranslated.value
                                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                                        : "lib/Constants/Assets/Settings/translation.png"),
                                  ),
                                ),
                              )),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            child: billboardWidgetsMain.getProfile(
                                context: context,
                                heightValue: height / 21.65,
                                widthValue: width / 10.275,
                                myself: false,
                                isProfile: "user",
                                userId: mainVariables.conversationUserData.value.userId,
                                avatar: mainVariables.conversationUserData.value.avatar),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 51.375),
                            margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0XFF0EA102).withOpacity(0.2),
                                      offset: const Offset(0.5, -0.5),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0)
                                ]),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        conversationFunctionsMain.handleReplyToMessage(originalMessage: replyUserData.message, context: context);
                                        for (int i = 0; i < mainVariables.messagesListMain.length; i++) {
                                          if (mainVariables.messagesListMain[i].messageId == replyUserData.replyId) {
                                            //  conversationFunctionsMain.handleReplyToMessage(originalMessage: mainVariables.messagesListMain[i].messageContent.value, context: context);
                                            // conversationFunctionsMain.animateToIndex(i);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height / 108.25),
                                        decoration:
                                            BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.circular(6)),
                                        child: replyUserData.message.length > 40
                                            ? SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  replyUserData.status == 3 ? "deleted message" : replyUserData.message,
                                                  style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: replyUserData.status == 3 ? text.scale(8) : text.scale(14),
                                                      overflow: TextOverflow.ellipsis),
                                                  maxLines: 1,
                                                ),
                                              )
                                            : Text(
                                                replyUserData.status == 3 ? "deleted message" : replyUserData.message,
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: replyUserData.status == 3 ? text.scale(8) : text.scale(14),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        mainVariables.messagesListMain[index].messageContent.value.length > 40
                                            ? SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  mainVariables.messagesListMain[index].status.value == 3
                                                      ? "deleted message"
                                                      : mainVariables.messagesListMain[index].messageContent.value,
                                                  style: TextStyle(
                                                    fontSize:
                                                        mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                mainVariables.messagesListMain[index].status.value == 3
                                                    ? "deleted message"
                                                    : mainVariables.messagesListMain[index].messageContent.value,
                                                style: TextStyle(
                                                  fontSize: mainVariables.messagesListMain[index].status.value == 3 ? text.scale(8) : text.scale(14),
                                                ),
                                              ),
                                        SizedBox(
                                          height: height / 57.73,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(mainVariables.messagesListMain[index].currentTime),
                                  style: TextStyle(
                                    fontSize: text.scale(10),
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (mainVariables.messagesListMain[index].isTranslated.value) {
                                  mainVariables.messagesListMain[index].messageContent.value =
                                      mainVariables.messagesListMain[index].tempMessage.value;
                                  mainVariables.messagesListMain[index].isTranslated.value = false;
                                } else {
                                  bool response = await conversationApiMain.translatingChatFunc(
                                      id: mainVariables.messagesListMain[index].messageId, index: index);
                                  if (response) {
                                    mainVariables.messagesListMain[index].isTranslated.value = true;
                                  }
                                }
                              },
                              child: Card(
                                elevation: 2.0,
                                shadowColor: const Color(0XFF0EA102),
                                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                                child: Container(
                                  height: height / 34.64,
                                  width: width / 16.44,
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Image.asset(mainVariables.messagesListMain[index].isTranslated.value
                                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                                        : "lib/Constants/Assets/Settings/translation.png"),
                                  ),
                                ),
                              )),
                        ],
                      ),
              ),
              SizedBox(
                height: height / 86.6,
              )
            ],
          );
  }

  Future<dynamic> popUpBar({
    required BuildContext context,
    required ReplyUser replyUserData,
    required bool isSender,
  }) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showDialog(
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          alignment: Alignment.topCenter,
          insetPadding:
              EdgeInsets.only(top: height / 17.32, left: isSender ? width / 4.11 : width / 27.4, right: isSender ? width / 27.4 : width / 4.11),
          content: SizedBox(
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  replyUserData.username,
                  style: TextStyle(fontSize: text.scale(12), color: Colors.black87, fontWeight: FontWeight.w400),
                ),
                const Divider(
                  thickness: 1.5,
                  color: Colors.black,
                ),
                Text(
                  replyUserData.message,
                  style: TextStyle(fontSize: text.scale(14), color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const Divider(
                  thickness: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format(DateTime.now().toLocal().toLocal()),
                      style: TextStyle(fontSize: text.scale(8), color: Colors.black, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bottomSheet({
    required BuildContext context,
    required StateSetter modelSetState,
    required String fromWhere,
    required int index,
    String? userId,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  fromWhere == "list"
                      ? const SizedBox()
                      : ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            filesBottomSheet(context: context, modelSetState: modelSetState);
                          },
                          minLeadingWidth: width / 25,
                          leading: SvgPicture.asset(
                            "lib/Constants/Assets/BillBoard/more.svg",
                            height: height / 43.3,
                            width: width / 20.55,
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            "More",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                  fromWhere == "list"
                      ? const SizedBox()
                      : const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                  fromWhere == "list"
                      ? const SizedBox()
                      : ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            mainVariables.messagesListMain.clear();
                            mainVariables.audioPlayerList.clear();
                            mainVariables.isPlayingList.clear();
                            mainVariables.isLoadingList.clear();
                            mainVariables.totalTimeList.clear();
                            mainVariables.currentTimeList.clear();
                            mainVariables.recentMessageChangeDate.value = "";
                            // mainVariables.lastMessageChangeDate.value ="";
                            await conversationApiMain.getMessageClearFunction(
                                context: context, type: 'private', userId: mainVariables.conversationUserData.value.userId, groupId: '');
                          },
                          minLeadingWidth: width / 25,
                          leading: SvgPicture.asset(
                            "lib/Constants/Assets/BillBoard/clearChat.svg",
                            height: height / 43.3,
                            width: width / 20.55,
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            "Clear chat",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                  fromWhere == "list"
                      ? const SizedBox()
                      : const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      modelSetState(() {
                        mainVariables.actionValueMain = "Report";
                      });
                      mainShowAlertDialog(
                          context: context,
                          modelSetState: modelSetState,
                          userId: userId ??
                              (fromWhere == "list" ? mainVariables.chatUserList[index].userId : mainVariables.conversationUserData.value.userId),
                          isFromProfile: userId != null);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.shield,
                      size: 25,
                    ),
                    title: Text(
                      "Report User",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () {
                      modelSetState(() {
                        mainVariables.actionValueMain = "Block";
                      });

                      Navigator.pop(context);
                      mainShowAlertDialog(
                          context: context,
                          userId: userId ??
                              (fromWhere == "list" ? mainVariables.chatUserList[index].userId : mainVariables.conversationUserData.value.userId),
                          modelSetState: modelSetState,
                          isFromProfile: userId != null);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.flag,
                      size: 25,
                    ),
                    title: Text(
                      "Block User",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  singleBottomSheet({required BuildContext context, required StateSetter modelSetState, required int index, required bool isSender}) {
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
                      Navigator.pop(context);
                      mainVariables.messagesListMain[index].status.value = 3;
                      modelSetState(() {});
                      conversationApiMain.getMessageDeleteFunction(
                          context: context, messageId: mainVariables.messagesListMain[index].messageId, isSender: true);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    leading: const Icon(
                      Icons.delete,
                      size: 25,
                    ),
                    title: Text(
                      "Delete",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  isSender
                      ? ListTile(
                          onTap: () {
                            mainVariables.isEditing.value = true;

                            Navigator.pop(context);
                            mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                            mainVariables.isEditingMessageId.value = mainVariables.messagesListMain[index].messageId;
                            mainVariables.editingIndexMain.value = index;
                            mainVariables.messageControllerMain.value.text = mainVariables.messagesListMain[index].messageContent.value;
                            mainVariables.replyUserDataMain = ReplyUser(
                                replyId: mainVariables.messagesListMain[index].reply.replyId,
                                userId: mainVariables.messagesListMain[index].reply.userId,
                                avatar: mainVariables.messagesListMain[index].reply.avatar,
                                message: mainVariables.messagesListMain[index].reply.message,
                                username: mainVariables.messagesListMain[index].reply.username,
                                status: mainVariables.messagesListMain[index].reply.status,
                                files: mainVariables.messagesListMain[index].reply.files);
                          },
                          leading: const Icon(
                            Icons.edit,
                            size: 25,
                          ),
                          title: Text(
                            "Edit",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        )
                      : const SizedBox(),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      mainVariables.isReplying.value = true;

                      Navigator.pop(context);
                      mainVariables.attachmentEditFiles.addAll(mainVariables.messagesListMain[index].data);
                      mainVariables.isReplyingMessageId.value = mainVariables.messagesListMain[index].messageId;
                      mainVariables.editingIndexMain.value = index;
                      mainVariables.isReplyingMessage.value = mainVariables.messagesListMain[index].messageContent.value == ""
                          ? "attachments"
                          : mainVariables.messagesListMain[index].messageContent.value;
                      mainVariables.replyUserDataMain = ReplyUser(
                          replyId: mainVariables.messagesListMain[index].messageId,
                          userId: "",
                          avatar: "",
                          message: mainVariables.messagesListMain[index].messageContent.value,
                          username: "",
                          status: mainVariables.messagesListMain[index].status.value,
                          files: mainVariables.messagesListMain[index].data);
                    },
                    leading: const Icon(
                      Icons.reply,
                      size: 25,
                    ),
                    title: Text(
                      "Reply",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void mainShowAlertDialog({
    required BuildContext context,
    required StateSetter modelSetState,
    required String userId,
    required bool isFromProfile,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return SingleChildScrollView(
          reverse: true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: height / 1.18,
              width: width / 1.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 3.67,
                      width: width / 1.96,
                      child: Image.asset(
                        mainVariables.actionValueMain == "Report"
                            ? isDarkTheme.value
                                ? "assets/settings/report_dark.png"
                                : "assets/settings/report_light.png"
                            : isDarkTheme.value
                                ? "assets/settings/block_dark.png"
                                : "assets/settings/block_light.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20.3,
                  ),
                  Center(
                    child: Text(
                      'Help us understand why?',
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Action:",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                alignment: AlignmentDirectional.center,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: mainVariables.actionListMain
                                    .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                        )))
                                    .toList(),
                                value: mainVariables.actionValueMain,
                                onChanged: (String? value) {
                                  modelSetState(() {
                                    mainVariables.actionValueMain = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 108.25,
                      ),
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Why?",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: mainVariables.whyListMain
                                    .map((label) => DropdownMenuItem<String>(
                                          value: label,
                                          child: Text(
                                            label,
                                            style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                          ),
                                        ))
                                    .toList(),
                                value: mainVariables.whyValueMain,
                                onChanged: (String? value) {
                                  modelSetState(() {
                                    mainVariables.whyValueMain = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  TextFormField(
                    controller: controller,
                    minLines: 4,
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: width / 26.78, vertical: height / 50.75),
                      hintText: "Enter a description...",
                      hintStyle: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  GestureDetector(
                    onTap: () {
                      logEventFunc(name: mainVariables.actionValueMain == "Report" ? 'Reported_Users' : 'Blocked_Users', type: 'User');
                      conversationApiMain.reportUser(
                          action: mainVariables.actionValueMain,
                          why: mainVariables.whyValueMain,
                          description: controller.text,
                          userId: userId,
                          context: context,
                          fromWhere: isFromProfile ? "profile" : "");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isDarkTheme.value
                            ? const Color(0xff464646)
                            : mainVariables.actionValueMain == "Report"
                                ? const Color(0XFF0EA102)
                                : const Color(0xffFF0000),
                      ),
                      height: height / 18.45,
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(14), fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  filesBottomSheet({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
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
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const FilesDisplayingPage(
                                    fileType: "image",
                                  )));
                    },
                    leading: const Icon(
                      Icons.image,
                      size: 25,
                    ),
                    title: Text(
                      "Images",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FilesDisplayingPage(fileType: "video")));
                    },
                    leading: const Icon(
                      Icons.video_library,
                      size: 25,
                    ),
                    title: Text(
                      "Videos",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FilesDisplayingPage(fileType: "audio")));
                    },
                    leading: const Icon(
                      Icons.multitrack_audio,
                      size: 25,
                    ),
                    title: Text(
                      "Audios",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FilesDisplayingPage(fileType: "doc")));
                    },
                    leading: const Icon(
                      Icons.file_copy_outlined,
                      size: 25,
                    ),
                    title: Text(
                      "Documents",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CreateGroupBottomPage extends StatefulWidget {
  const CreateGroupBottomPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupBottomPage> createState() => _CreateGroupBottomPageState();
}

class _CreateGroupBottomPageState extends State<CreateGroupBottomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  String avatar = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.only(top: height / 57.73, left: width / 27.4, right: width / 27.4),
      height: height / 1.5,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Create Group",
                style: TextStyle(fontSize: text.scale(20), fontWeight: FontWeight.w600, color: const Color(0XFF0EA102)),
              ),
              IconButton(
                  onPressed: () {
                    mainVariables.pickedImageGroupSingle = null;
                    mainVariables.isGroupCreated.value = false;
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ))
            ],
          ),
          SizedBox(
            height: height / 43.3,
          ),
          Center(
            child: Container(
              height: height / 7.87,
              width: width / 3.73,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0XFF202020).withOpacity(0.6)),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: mainVariables.pickedImageGroupSingle != null
                    ? Image.file(
                        mainVariables.pickedImageGroupSingle!,
                        fit: BoxFit.fill,
                        height: height / 7.87,
                        width: width / 3.73,
                      )
                    : avatar != ""
                        ? Image.network(
                            avatar,
                            fit: BoxFit.fill,
                            height: height / 7.87,
                            width: width / 3.73,
                          )
                        : const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
              ),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          mainVariables.pickedImageGroupSingle != null || avatar != ""
              ? IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          conversationWidgetsMain.showChangeBottomSheet(context: context, modelSetState: setState);
                        },
                        child: Text(
                          "change photo",
                          style: TextStyle(
                            fontSize: text.scale(12),
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF828282),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1.5,
                      ),
                      GestureDetector(
                          onTap: () {
                            mainVariables.pickedImageGroupSingle = null;
                            setState(() {});
                          },
                          child: Text(
                            "remove photo",
                            style: TextStyle(
                              fontSize: text.scale(12),
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF828282),
                            ),
                          ))
                    ],
                  ),
                )
              : Center(
                  child: GestureDetector(
                    onTap: () {
                      conversationWidgetsMain.showChangeBottomSheet(context: context, modelSetState: setState);
                    },
                    child: Text(
                      "add photo",
                      style: TextStyle(
                        fontSize: text.scale(14),
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF828282),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            height: height / 57.73,
          ),
          Text(
            "Group name",
            style: TextStyle(
              fontSize: text.scale(12),
              fontWeight: FontWeight.w400,
              color: const Color(0XFF828282),
            ),
          ),
          TextFormField(
            controller: _nameController,
            cursorColor: Colors.green,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA2A2A2), width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA2A2A2), width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA2A2A2), width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorStyle: TextStyle(fontSize: text.scale(10))),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Text(
            "About",
            style: TextStyle(
              fontSize: text.scale(12),
              fontWeight: FontWeight.w400,
              color: const Color(0XFF828282),
            ),
          ),
          TextFormField(
            controller: _aboutController,
            cursorColor: Colors.green,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA2A2A2), width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA2A2A2), width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA2A2A2), width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorStyle: TextStyle(fontSize: text.scale(10))),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            height: height / 11.54,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 3,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 82.2),
                        height: height / 13.32,
                        width: width / 6.32,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            image:
                                const DecorationImage(image: AssetImage("lib/Constants/Assets/FinalChartImages/profileImage.png"), fit: BoxFit.fill)),
                      ),
                      Container(
                          height: height / 43.3,
                          width: width / 20.55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26.withOpacity(0.3),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ))
                    ],
                  );
                }),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0EA102),
                minimumSize: Size(width, height / 17.32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
            onPressed: () {
              mainVariables.isGroupCreated.value = true;
              if (!mounted) {
                return;
              }
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: Colors.white),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
        ],
      ),
    );
  }
}

class BelieversTabConversationList extends StatefulWidget {
  const BelieversTabConversationList({Key? key}) : super(key: key);

  @override
  State<BelieversTabConversationList> createState() => _BelieversTabConversationListState();
}

class _BelieversTabConversationListState extends State<BelieversTabConversationList> {
  bool loader = false;
  int skipCount = 0;

  @override
  void initState() {
    mainVariables.isGeneralConversationList.value = false;
    mainVariables.billBoardListSearchControllerMain.value.clear();
    getAllDataMain(name: 'Conversation_Believers_List_Page');
    getData();
    super.initState();
  }

  getData() async {
    await conversationApiMain.activeUsersList(skipCount: 0);
    await conversationApiMain.conversationUsersList(
        type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: skipCount, fromWhere: 'conversation');
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    final RefreshController homeRefreshController = RefreshController();
    return loader
        ? Column(
            children: [
              Obx(() => mainVariables.activeUserList.isEmpty
                  ? SizedBox(
                      height: height / 57.73,
                    )
                  : Container(
                      width: width,
                      height: height / 8.66,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: mainVariables.activeUserList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      mainVariables.conversationUserData.value = ConversationUserData(
                                          userId: mainVariables.activeUserList[index].userId,
                                          avatar: mainVariables.activeUserList[index].avatar,
                                          firstName: mainVariables.activeUserList[index].firstName,
                                          lastName: mainVariables.activeUserList[index].lastName,
                                          userName: mainVariables.activeUserList[index].username,
                                          isBelieved: mainVariables.activeUserList[index].believed);
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return const ConversationPage();
                                      }));
                                    },
                                    child: SizedBox(
                                      width: width / 5.87,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: height / 15.74,
                                                width: width / 7.47,
                                                color: Colors.transparent,
                                              ),
                                              Positioned(
                                                top: 0,
                                                child: Container(
                                                  height: height / 17.32,
                                                  width: width / 8.22,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(mainVariables.activeUserList[index].avatar), fit: BoxFit.fill)),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: height / 173.2,
                                                child: Container(
                                                  height: height / 57.73,
                                                  width: width / 27.4,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height / 173.2,
                                          ),
                                          Text(
                                            mainVariables.activeUserList[index].username,
                                            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ActiveTradersScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.onPrimary)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.onPrimary)),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              Obx(() => mainVariables.activeUserList.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: height / 57.73,
                    )),
              Obx(() => mainVariables.chatUserList.isEmpty
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 5.77,
                            width: width / 2.74,
                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg"),
                          ),
                          SizedBox(
                            height: height / 57.73,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '😟 Looks like there is no conversations in this list, Would you like to a add ',
                                      style:
                                          TextStyle(fontFamily: "Poppins", color: Theme.of(context).colorScheme.onPrimary, fontSize: text.scale(12))),
                                  TextSpan(
                                    text: ' Add here',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        //userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const ContactsList();
                                        }));
                                      },
                                    style: TextStyle(
                                        fontFamily: "Poppins", color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SmartRefresher(
                          controller: homeRefreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                          ),
                          onLoading: () async {
                            skipCount = skipCount + 20;
                            getData();
                            if (mounted) {
                              setState(() {});
                            }
                            homeRefreshController.loadComplete();
                          },
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: mainVariables.chatUserList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    mainVariables.conversationUserData.value = ConversationUserData(
                                        userId: mainVariables.chatUserList[index].userId,
                                        avatar: mainVariables.chatUserList[index].avatar,
                                        firstName: mainVariables.chatUserList[index].firstName,
                                        lastName: mainVariables.chatUserList[index].lastName,
                                        userName: mainVariables.chatUserList[index].username,
                                        isBelieved: mainVariables.chatUserList[index].believed);
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return const ConversationPage();
                                    }));
                                  },
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          bottom: index == 14 ? height / 34.64 : height / 86.6,
                                          left: width / 27.4,
                                          right: width / 27.4,
                                          top: height / 173.2,
                                        ),
                                        padding: EdgeInsets.only(
                                          left: width / 27.4,
                                          right: width / 82.2,
                                          top: height / 86.6,
                                          bottom: height / 86.6,
                                        ),
                                        height: height / 11.54,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Theme.of(context).colorScheme.onBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                              blurRadius: 4.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                        child: Row(children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                height: height / 17.32,
                                                width: width / 8.22,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(mainVariables.chatUserList[index].avatar), fit: BoxFit.fill)),
                                              ),
                                              //mainVariables.chatUserList[index].activeStatus?
                                              Obx(() => mainVariables.isActiveStatusList[index]
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
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 108.25),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${mainVariables.chatUserList[index].firstName} ${mainVariables.chatUserList[index].lastName}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400, fontSize: text.scale(14), overflow: TextOverflow.ellipsis),
                                                    maxLines: 1,
                                                  ),
                                                  Obx(() => Text(
                                                        '${mainVariables.chatUserList[index].message.value.message} ',
                                                        style: TextStyle(
                                                            fontWeight: mainVariables.chatUserList[index].message.value.readStatus
                                                                ? FontWeight.w400
                                                                : FontWeight.w900,
                                                            fontSize: text.scale(10),
                                                            color: mainVariables.chatUserList[index].message.value.readStatus
                                                                ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                                                                : Theme.of(context).colorScheme.onPrimary,
                                                            overflow: TextOverflow.ellipsis),
                                                        maxLines: 1,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width / 3.1,
                                            padding: EdgeInsets.only(
                                              top: height / 108.25,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    conversationWidgetsMain.getChatBelieveButton(
                                                        heightValue: height / 33.76,
                                                        index: index,
                                                        billboardUserid: mainVariables.chatUserList[index].userId,
                                                        billboardUserName: mainVariables.chatUserList[index].username,
                                                        context: context,
                                                        modelSetState: setState),
                                                    GestureDetector(
                                                        onTap: () {
                                                          conversationWidgetsMain.bottomSheet(
                                                            context: context,
                                                            modelSetState: setState,
                                                            fromWhere: 'list',
                                                            index: index,
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                        ))
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: width / 27.4),
                                                  child: Text(
                                                    mainVariables.chatUserList[index].message.value.createdAt
                                                    /*DateFormat('kk:mm a')
                                                                        .format(DateTime
                                                                            .now())*/
                                                    ,
                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(10)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Obx(() => mainVariables.chatUserList[index].unreadMessages.value == 0
                                          ? const SizedBox()
                                          : Positioned(
                                              right: width / 27.4,
                                              child: Container(
                                                height: height / 57.73,
                                                width: width / 27.4,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    mainVariables.chatUserList[index].unreadMessages.value < 10
                                                        ? "${mainVariables.chatUserList[index].unreadMessages.value}"
                                                        : "9+",
                                                    style: TextStyle(
                                                        fontSize: mainVariables.chatUserList[index].unreadMessages.value < 10
                                                            ? text.scale(10)
                                                            : text.scale(8),
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )),
                                    ],
                                  ),
                                );
                              })),
                    )),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}

class GeneralTabConversationList extends StatefulWidget {
  const GeneralTabConversationList({Key? key}) : super(key: key);

  @override
  State<GeneralTabConversationList> createState() => _GeneralTabConversationListState();
}

class _GeneralTabConversationListState extends State<GeneralTabConversationList> {
  bool loader = false;
  int skipCount = 0;

  @override
  void initState() {
    mainVariables.isGeneralConversationList.value = true;
    mainVariables.billBoardListSearchControllerMain.value.clear();
    getAllDataMain(name: 'Conversation_Believers_List_Page');
    getData();
    super.initState();
  }

  getData() async {
    await conversationApiMain.activeUsersList(skipCount: 0);
    await conversationApiMain.conversationUsersList(
        type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: skipCount, fromWhere: 'conversation');
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    final RefreshController homeRefreshController = RefreshController();
    return loader
        ? Column(
            children: [
              Obx(() => mainVariables.activeUserList.isEmpty
                  ? SizedBox(
                      height: height / 57.73,
                    )
                  : Container(
                      width: width,
                      height: height / 8.66,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: mainVariables.activeUserList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      mainVariables.conversationUserData.value = ConversationUserData(
                                          userId: mainVariables.activeUserList[index].userId,
                                          avatar: mainVariables.activeUserList[index].avatar,
                                          firstName: mainVariables.activeUserList[index].firstName,
                                          lastName: mainVariables.activeUserList[index].lastName,
                                          userName: mainVariables.activeUserList[index].username,
                                          isBelieved: mainVariables.activeUserList[index].believed);
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return const ConversationPage();
                                      }));
                                    },
                                    child: SizedBox(
                                      width: width / 5.87,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: height / 15.74,
                                                width: width / 7.47,
                                                color: Colors.transparent,
                                              ),
                                              Positioned(
                                                top: 0,
                                                child: Container(
                                                  height: height / 17.32,
                                                  width: width / 8.22,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(mainVariables.activeUserList[index].avatar), fit: BoxFit.fill)),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: height / 173.2,
                                                child: Container(
                                                  height: height / 57.73,
                                                  width: width / 27.4,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height / 173.2,
                                          ),
                                          Text(
                                            mainVariables.activeUserList[index].username,
                                            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ActiveTradersScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.onPrimary)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.onPrimary)),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              Obx(() => mainVariables.activeUserList.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: height / 57.73,
                    )),
              Obx(() => mainVariables.chatUserList.isEmpty
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 57.73),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 5.77,
                            width: width / 2.74,
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/add.svg",
                            ),
                          ),
                          SizedBox(
                            height: height / 57.73,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '😟 Looks like there is no conversations in this list, Would you like to a add ',
                                      style: TextStyle(fontFamily: "Poppins", fontSize: text.scale(12))),
                                  TextSpan(
                                    text: ' Add here',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        //userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const ContactsList();
                                        }));
                                      },
                                    style: TextStyle(
                                        fontFamily: "Poppins", color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SmartRefresher(
                          controller: homeRefreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                          ),
                          onLoading: () async {
                            skipCount = skipCount + 20;
                            getData();
                            if (mounted) {
                              setState(() {});
                            }
                            homeRefreshController.loadComplete();
                          },
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: mainVariables.chatUserList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    mainVariables.conversationUserData.value = ConversationUserData(
                                        userId: mainVariables.chatUserList[index].userId,
                                        avatar: mainVariables.chatUserList[index].avatar,
                                        firstName: mainVariables.chatUserList[index].firstName,
                                        lastName: mainVariables.chatUserList[index].lastName,
                                        userName: mainVariables.chatUserList[index].username,
                                        isBelieved: mainVariables.chatUserList[index].believed);
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return const ConversationPage();
                                    }));
                                  },
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          bottom: index == 14 ? height / 34.64 : height / 86.6,
                                          left: width / 27.4,
                                          right: width / 27.4,
                                          top: height / 173.2,
                                        ),
                                        padding: EdgeInsets.only(
                                          left: width / 27.4,
                                          right: width / 82.2,
                                          top: height / 86.6,
                                          bottom: height / 86.6,
                                        ),
                                        height: height / 11.54,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Theme.of(context).colorScheme.onBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                              blurRadius: 4.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                        child: Row(children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                height: height / 17.32,
                                                width: width / 8.22,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(mainVariables.chatUserList[index].avatar), fit: BoxFit.fill)),
                                              ),
                                              //mainVariables.chatUserList[index].activeStatus?
                                              Obx(() => mainVariables.isActiveStatusList[index]
                                                  ? Container(
                                                      height: height / 57.73,
                                                      width: width / 27.4,
                                                      decoration:
                                                          BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.background),
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
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 108.25),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${mainVariables.chatUserList[index].firstName} ${mainVariables.chatUserList[index].lastName}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400, fontSize: text.scale(14), overflow: TextOverflow.ellipsis),
                                                    maxLines: 1,
                                                  ),
                                                  Obx(() => Text(
                                                        '${mainVariables.chatUserList[index].message.value.message} ',
                                                        style: TextStyle(
                                                            fontWeight: mainVariables.chatUserList[index].message.value.readStatus
                                                                ? FontWeight.w400
                                                                : FontWeight.w900,
                                                            fontSize: text.scale(10),
                                                            color: mainVariables.chatUserList[index].message.value.readStatus
                                                                ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                                                                : Theme.of(context).colorScheme.onPrimary,
                                                            overflow: TextOverflow.ellipsis),
                                                        maxLines: 1,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width / 3.1,
                                            padding: EdgeInsets.only(
                                              top: height / 108.25,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    conversationWidgetsMain.getChatBelieveButton(
                                                        heightValue: height / 33.76,
                                                        index: index,
                                                        billboardUserid: mainVariables.chatUserList[index].userId,
                                                        billboardUserName: mainVariables.chatUserList[index].username,
                                                        context: context,
                                                        modelSetState: setState),
                                                    GestureDetector(
                                                        onTap: () {
                                                          conversationWidgetsMain.bottomSheet(
                                                            context: context,
                                                            modelSetState: setState,
                                                            fromWhere: 'list',
                                                            index: index,
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                        ))
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: width / 27.4),
                                                  child: Text(
                                                    mainVariables.chatUserList[index].message.value.createdAt
                                                    /*DateFormat('kk:mm a')
                                                                        .format(DateTime
                                                                            .now())*/
                                                    ,
                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(10)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Obx(() => mainVariables.chatUserList[index].unreadMessages.value == 0
                                          ? const SizedBox()
                                          : Positioned(
                                              right: width / 27.4,
                                              child: Container(
                                                height: height / 57.73,
                                                width: width / 27.4,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    mainVariables.chatUserList[index].unreadMessages.value < 10
                                                        ? "${mainVariables.chatUserList[index].unreadMessages.value}"
                                                        : "9+",
                                                    style: TextStyle(
                                                        fontSize: mainVariables.chatUserList[index].unreadMessages.value < 10
                                                            ? text.scale(10)
                                                            : text.scale(8),
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )),
                                    ],
                                  ),
                                );
                              })),
                    )),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}

class UserTaggingContainer extends StatefulWidget {
  const UserTaggingContainer({Key? key}) : super(key: key);

  @override
  State<UserTaggingContainer> createState() => _UserTaggingContainerState();
}

class _UserTaggingContainerState extends State<UserTaggingContainer> {
  List<String> splitOne = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    conversationFunctionsMain.conversationSearchData(newResponseValue: mainVariables.messageControllerMain.value.text, newSetState: setState);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      height: height / 5.77,
      width: width,
      margin: EdgeInsets.only(left: width / 16.44, right: width / 8.22),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 1.5, spreadRadius: 1.5, offset: const Offset(0.0, -1.0))]),
      child: ListView.builder(
          itemCount: mainVariables.searchResultMain.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: height / 24.74,
              margin: index == mainVariables.searchResultMain.length - 1 ? EdgeInsets.only(bottom: height / 57.73) : const EdgeInsets.all(0),
              child: ListTile(
                onTap: () {
                  setState(() {
                    mainVariables.isUserTagging.value = false;
                    splitOne = mainVariables.messageControllerMain.value.text.split("+");
                    mainVariables.searchUserIdMain.value = mainVariables.searchIdResultMain[index];
                  });
                  String controllerText = "";
                  for (int i = 0; i < splitOne.length; i++) {
                    if (splitOne.length <= 2) {
                      if (i != splitOne.length - 1) {
                        setState(() {
                          controllerText = "$controllerText ${splitOne[i]}";
                          mainVariables.isUserTagging.value = false;
                        });
                      } else {
                        mainVariables.messageControllerMain.value.text = "$controllerText +${mainVariables.searchResultMain[index]} ";
                        mainVariables.messageControllerMain.value.selection =
                            TextSelection.fromPosition(TextPosition(offset: mainVariables.messageControllerMain.value.text.length));
                        setState(() {
                          mainVariables.isUserTagging.value = false;
                        });
                      }
                    } else {
                      if (i == 0) {
                        setState(() {
                          controllerText = "$controllerText ${splitOne[i]}";
                          mainVariables.isUserTagging.value = false;
                        });
                      } else if (i != splitOne.length - 1) {
                        setState(() {
                          controllerText = "$controllerText +${splitOne[i]}";
                          mainVariables.isUserTagging.value = false;
                        });
                      } else {
                        mainVariables.messageControllerMain.value.text = "$controllerText +${mainVariables.searchResultMain[index]} ";
                        mainVariables.messageControllerMain.value.selection =
                            TextSelection.fromPosition(TextPosition(offset: mainVariables.messageControllerMain.value.text.length));
                        setState(() {
                          mainVariables.isUserTagging.value = false;
                        });
                      }
                    }
                  }
                  setState(() {
                    mainVariables.isUserTagging.value = false;
                  });
                },
                title: Text(
                  mainVariables.searchResultMain[index],
                  style: TextStyle(color: Colors.black, fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                ),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(
                    mainVariables.searchLogoMain[index],
                  ),
                  radius: 15,
                ),
              ),
            );
          }),
    );
  }
}

class UserTaggingBillBoardHomeContainer extends StatefulWidget {
  final int billboardListIndex;

  const UserTaggingBillBoardHomeContainer({Key? key, required this.billboardListIndex}) : super(key: key);

  @override
  State<UserTaggingBillBoardHomeContainer> createState() => _UserTaggingBillBoardHomeContainerState();
}

class _UserTaggingBillBoardHomeContainerState extends State<UserTaggingBillBoardHomeContainer> {
  List<String> splitOne = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    conversationFunctionsMain.conversationSearchData(
        newResponseValue: mainVariables.responseControllerList[widget.billboardListIndex].text, newSetState: setState);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      height: height / 5.77,
      width: width / 1.3,
      margin: EdgeInsets.only(left: width / 5.13, right: width / 8.22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 1.5, spreadRadius: 1.5, offset: const Offset(0.0, -1.0))]),
      child: ListView.builder(
          itemCount: mainVariables.searchResultMain.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: height / 24.74,
              margin: index == mainVariables.searchResultMain.length - 1 ? EdgeInsets.only(bottom: height / 57.73) : const EdgeInsets.all(0),
              child: ListTile(
                onTap: () {
                  setState(() {
                    mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                    splitOne = mainVariables.responseControllerList[widget.billboardListIndex].text.split("+");
                    mainVariables.searchUserIdMain.value = mainVariables.searchIdResultMain[index];
                  });
                  String controllerText = "";
                  for (int i = 0; i < splitOne.length; i++) {
                    if (splitOne.length <= 2) {
                      if (i != splitOne.length - 1) {
                        setState(() {
                          controllerText = "$controllerText ${splitOne[i]}";
                          mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                        });
                      } else {
                        mainVariables.responseControllerList[widget.billboardListIndex].text =
                            "$controllerText +${mainVariables.searchResultMain[index]} ";
                        mainVariables.responseControllerList[widget.billboardListIndex].selection = TextSelection.fromPosition(
                            TextPosition(offset: mainVariables.responseControllerList[widget.billboardListIndex].text.length));
                        setState(() {
                          mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                        });
                      }
                    } else {
                      if (i == 0) {
                        setState(() {
                          controllerText = "$controllerText ${splitOne[i]}";
                          mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                        });
                      } else if (i != splitOne.length - 1) {
                        setState(() {
                          controllerText = "$controllerText +${splitOne[i]}";
                          mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                        });
                      } else {
                        mainVariables.responseControllerList[widget.billboardListIndex].text =
                            "$controllerText +${mainVariables.searchResultMain[index]} ";
                        mainVariables.responseControllerList[widget.billboardListIndex].selection = TextSelection.fromPosition(
                            TextPosition(offset: mainVariables.responseControllerList[widget.billboardListIndex].text.length));
                        setState(() {
                          mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                        });
                      }
                    }
                  }
                  setState(() {
                    mainVariables.isUserTaggingList[widget.billboardListIndex] = false;
                  });
                },
                title: Text(
                  mainVariables.searchResultMain[index],
                  style: TextStyle(color: Colors.black, fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                ),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(
                    mainVariables.searchLogoMain[index],
                  ),
                  radius: 15,
                ),
              ),
            );
          }),
    );
  }
}

class UserTaggingBillBoardSingleContainer extends StatefulWidget {
  final int billboardListIndex;

  const UserTaggingBillBoardSingleContainer({Key? key, required this.billboardListIndex}) : super(key: key);

  @override
  State<UserTaggingBillBoardSingleContainer> createState() => _UserTaggingBillBoardSingleContainerState();
}

class _UserTaggingBillBoardSingleContainerState extends State<UserTaggingBillBoardSingleContainer> {
  List<String> splitOne = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    conversationFunctionsMain.conversationSearchData(
        newResponseValue: mainVariables.responseControllerList[widget.billboardListIndex].text, newSetState: setState);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      height: height / 5.77,
      width: width / 1.3,
      margin: EdgeInsets.only(left: width / 5.13, right: width / 8.22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 1.5, spreadRadius: 1.5, offset: const Offset(0.0, -1.0))]),
      child: ListView.builder(
          itemCount: mainVariables.searchResultMain.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: height / 24.74,
              margin: index == mainVariables.searchResultMain.length - 1 ? EdgeInsets.only(bottom: height / 57.73) : const EdgeInsets.all(0),
              child: ListTile(
                onTap: () {
                  setState(() {
                    mainVariables.isUserTagged.value = false;
                    splitOne = mainVariables.billboardSingleControllerMain.value.text.split("+");
                    mainVariables.searchUserIdMain.value = mainVariables.searchIdResultMain[index];
                  });
                  String controllerText = "";
                  for (int i = 0; i < splitOne.length; i++) {
                    if (splitOne.length <= 2) {
                      if (i != splitOne.length - 1) {
                        setState(() {
                          controllerText = "$controllerText ${splitOne[i]}";
                          mainVariables.isUserTagged.value = false;
                        });
                      } else {
                        mainVariables.billboardSingleControllerMain.value.text = "$controllerText +${mainVariables.searchResultMain[index]} ";
                        mainVariables.billboardSingleControllerMain.value.selection =
                            TextSelection.fromPosition(TextPosition(offset: mainVariables.billboardSingleControllerMain.value.text.length));
                        setState(() {
                          mainVariables.isUserTagged.value = false;
                        });
                      }
                    } else {
                      if (i == 0) {
                        setState(() {
                          controllerText = "$controllerText ${splitOne[i]}";
                          mainVariables.isUserTagged.value = false;
                        });
                      } else if (i != splitOne.length - 1) {
                        setState(() {
                          controllerText = "$controllerText +${splitOne[i]}";
                          mainVariables.isUserTagged.value = false;
                        });
                      } else {
                        mainVariables.billboardSingleControllerMain.value.text = "$controllerText +${mainVariables.searchResultMain[index]} ";
                        mainVariables.billboardSingleControllerMain.value.selection =
                            TextSelection.fromPosition(TextPosition(offset: mainVariables.billboardSingleControllerMain.value.text.length));
                        setState(() {
                          mainVariables.isUserTagged.value = false;
                        });
                      }
                    }
                  }
                  setState(() {
                    mainVariables.isUserTagged.value = false;
                  });
                },
                title: Text(
                  mainVariables.searchResultMain[index],
                  style: TextStyle(color: Colors.black, fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                ),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(
                    mainVariables.searchLogoMain[index],
                  ),
                  radius: 15,
                ),
              ),
            );
          }),
    );
  }
}

class BelieversTabConversationSendMessageList extends StatefulWidget {
  final bool isFromShare;

  const BelieversTabConversationSendMessageList({Key? key, required this.isFromShare}) : super(key: key);

  @override
  State<BelieversTabConversationSendMessageList> createState() => _BelieversTabConversationSendMessageListState();
}

class _BelieversTabConversationSendMessageListState extends State<BelieversTabConversationSendMessageList> {
  bool loader = false;
  int skipCount = 0;

  @override
  void initState() {
    mainVariables.isGeneralConversationList.value = false;
    getData();
    super.initState();
  }

  getData() async {
    mainVariables.sendMessageListSearchControllerMain.value.clear();
    await conversationApiMain.conversationUsersList(
        type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: skipCount, fromWhere: 'conversation');
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Obx(() => mainVariables.chatUserSendList.isEmpty
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: width / 57.73),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: '😟 Looks like there is no conversations in this list, Would you like to a add ',
                                style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: text.scale(12))),
                            TextSpan(
                              text: ' Add here',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  //userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const ContactsList();
                                  }));
                                },
                              style: TextStyle(
                                  fontFamily: "Poppins", color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SmartRefresher(
                controller: loadingRefreshControllerSendMessageListBelievers,
                enablePullDown: false,
                enablePullUp: true,
                footer: const ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                ),
                onLoading: () async {
                  skipCount = skipCount + 20;
                  getData();
                  if (mounted) {
                    setState(() {});
                  }
                  loadingRefreshControllerSendMessageListBelievers.loadComplete();
                },
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: mainVariables.chatUserSendList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: index == 14 ? height / 34.64 : height / 86.6, left: width / 27.4, right: width / 27.4, top: height / 173.2),
                        padding: EdgeInsets.only(left: width / 27.4, right: width / 82.2, top: height / 86.6, bottom: height / 86.6),
                        height: height / 11.54,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                          BoxShadow(color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                        ]),
                        child: Row(children: [
                          Container(
                            height: height / 17.32,
                            width: width / 8.22,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(mainVariables.chatUserSendList[index].avatar), fit: BoxFit.fill)),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 108.25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${mainVariables.chatUserSendList[index].firstName} ${mainVariables.chatUserSendList[index].lastName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0XFF262626),
                                        fontSize: text.scale(14),
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    mainVariables.chatUserSendList[index].username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0XFF262626),
                                        fontSize: text.scale(10),
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              billboardWidgetsMain.getSendButton(
                                  modelSetState: setState,
                                  context: context,
                                  id: mainVariables.chatUserSendList[index].userId,
                                  isFromShare: widget.isFromShare),
                              billboardWidgetsMain.verticalMenuButton(
                                context: context,
                                userId: mainVariables.chatUserSendList[index].userId,
                                modelSetState: setState,
                                index: 0,
                                isBelieved: true,
                              ),
                            ],
                          )
                        ]),
                      );
                    })))
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}

class GeneralTabConversationSendMessageList extends StatefulWidget {
  final bool isFromShare;

  const GeneralTabConversationSendMessageList({Key? key, required this.isFromShare}) : super(key: key);

  @override
  State<GeneralTabConversationSendMessageList> createState() => _GeneralTabConversationSendMessageListState();
}

class _GeneralTabConversationSendMessageListState extends State<GeneralTabConversationSendMessageList> {
  bool loader = false;
  int skipCount = 0;

  @override
  void initState() {
    mainVariables.sendMessageListSearchControllerMain.value.clear();
    mainVariables.isGeneralConversationList.value = true;
    getData();
    super.initState();
  }

  getData() async {
    await conversationApiMain.conversationUsersList(
        type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: skipCount, fromWhere: 'conversation');
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Obx(() => mainVariables.chatUserSendList.isEmpty
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: width / 57.73),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: '😟 Looks like there is no conversations in this list, Would you like to a add ',
                                style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: text.scale(12))),
                            TextSpan(
                              text: ' Add here',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  //userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const ContactsList();
                                  }));
                                },
                              style: TextStyle(
                                  fontFamily: "Poppins", color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SmartRefresher(
                controller: loadingRefreshControllerSendMessageListGeneral,
                enablePullDown: false,
                enablePullUp: true,
                footer: const ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                ),
                onLoading: () async {
                  skipCount = skipCount + 20;
                  getData();
                  if (mounted) {
                    setState(() {});
                  }
                  loadingRefreshControllerSendMessageListGeneral.loadComplete();
                },
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: mainVariables.chatUserSendList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: index == 14 ? height / 34.64 : height / 86.6, left: width / 27.4, right: width / 27.4, top: height / 173.2),
                        padding: EdgeInsets.only(left: width / 27.4, right: width / 82.2, top: height / 86.6, bottom: height / 86.6),
                        height: height / 11.54,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                          BoxShadow(color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                        ]),
                        child: Row(children: [
                          Container(
                            height: height / 17.32,
                            width: width / 8.22,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(mainVariables.chatUserSendList[index].avatar), fit: BoxFit.fill)),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 108.25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${mainVariables.chatUserSendList[index].firstName} ${mainVariables.chatUserSendList[index].lastName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0XFF262626),
                                        fontSize: text.scale(14),
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    mainVariables.chatUserSendList[index].username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0XFF262626),
                                        fontSize: text.scale(10),
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              billboardWidgetsMain.getSendButton(
                                  modelSetState: setState,
                                  context: context,
                                  isFromShare: widget.isFromShare,
                                  id: mainVariables.chatUserList[index].userId),
                              billboardWidgetsMain.verticalMenuButton(
                                context: context,
                                userId: mainVariables.chatUserList[index].userId,
                                modelSetState: setState,
                                index: 0,
                                isBelieved: true,
                              ),
                            ],
                          )
                        ]),
                      );
                    })))
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}
