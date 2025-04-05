import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/add_watch_list_page.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/watch_list.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';
import 'package:tradewatchfinal/Screens/Module5/set_alert_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_users_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_page.dart';

class ConversationCommonFunctions {
  getSocketFunction({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdMain = prefs.getString('newUserId') ?? "";
    if (userIdMain == "") {
      debugPrint("nothing");
    } else {
      mainVariables.socket = io.io('https://live.tradewatch.in', OptionBuilder().setTransports(['websocket']).enableAutoConnect().build());
      mainVariables.socket!.connect();
      mainVariables.socket!.onConnect((data) {
        debugPrint('connected');
      });
      mainVariables.socket!.emit('join_room', <String, dynamic>{"user_id": userIdMain});
      mainVariables.socket!.on('join_room', (data) {});
      mainVariables.socket!.on('new_message', (data) {
        debugPrint("newMessage");
        badgeMessageCount.value = badgeMessageCount.value + 1;
        if (data != null) {
          debugPrint("data");
          debugPrint(data);
          mainVariables.receivedSocketData = (ReceivedSocketDataModel.fromJson(data)).obs;
          if (mainVariables.isChatOpen.value) {
            if (mainVariables.conversationUserData.value.userId == mainVariables.receivedSocketData!.value.userId) {
              mainVariables.audioPlayerList.insert(0, AudioPlayer());
              mainVariables.isPlayingList.insert(0, false);
              mainVariables.isLoadingList.insert(0, false);
              mainVariables.totalTimeList.insert(0, 1);
              mainVariables.currentTimeList.insert(0, 0);
              ChatMessage newMsg = ChatMessage(
                  messageContent: mainVariables.receivedSocketData!.value.message.obs,
                  messageType: "receiver",
                  currentTime: DateTime.parse(mainVariables.receivedSocketData!.value.createdAt),
                  data: mainVariables.receivedSocketData!.value.files,
                  status: mainVariables.receivedSocketData!.value.status.obs,
                  messageId: mainVariables.receivedSocketData!.value.id,
                  reply: mainVariables.receivedSocketData!.value.replyUser,
                  changedDate: mainVariables.recentMessageChangeDate.value != "Today",
                  currentDate: "Today",
                  isTranslated: false.obs,
                  tempMessage: mainVariables.receivedSocketData!.value.message.obs);
              mainVariables.recentMessageChangeDate.value = "Today";
              mainVariables.messagesListMain.insert(0, newMsg);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                  elevation: 0,
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100),
                  content: InkWell(
                    onTap: () {
                      mainVariables.conversationUserData.value = ConversationUserData(
                          userId: mainVariables.receivedSocketData!.value.userId,
                          avatar: mainVariables.receivedSocketData!.value.users.avatar,
                          firstName: mainVariables.receivedSocketData!.value.users.firstName,
                          lastName: mainVariables.receivedSocketData!.value.users.lastName,
                          userName: mainVariables.receivedSocketData!.value.users.username,
                          isBelieved: mainVariables.receivedSocketData!.value.believed);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const ConversationPage();
                      }));
                    },
                    child: Container(
                      height: 80,
                      width: 350,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green.shade300,
                          boxShadow: const [BoxShadow(color: Color(0XFF0EA102), offset: Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0)]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(mainVariables.receivedSocketData!.value.users.avatar), fit: BoxFit.fill)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${mainVariables.receivedSocketData!.value.users.firstName} ${mainVariables.receivedSocketData!.value.users.lastName}",
                                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              // Text(mainVariables.receivedSocketData!.value.users.username,style: TextStyle(fontSize: 14, color: Colors.grey,fontWeight: FontWeight.w500),),
                              SizedBox(
                                  width: 250,
                                  child: Text(
                                    mainVariables.receivedSocketData!.value.message,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
            }
          } else {
            for (int i = 0; i < mainVariables.chatUserList.length; i++) {
              if (mainVariables.receivedSocketData!.value.userId == mainVariables.chatUserList[i].userId) {
                mainVariables.chatUserList[i].message.value = Message(
                    message: mainVariables.receivedSocketData!.value.message,
                    userId: mainVariables.receivedSocketData!.value.userId,
                    receiverId: mainVariables.receivedSocketData!.value.receiverId,
                    files: mainVariables.receivedSocketData!.value.files,
                    roomId: mainVariables.receivedSocketData!.value.roomId,
                    readStatus: mainVariables.receivedSocketData!.value.readStatus,
                    type: mainVariables.receivedSocketData!.value.type,
                    status: mainVariables.receivedSocketData!.value.status,
                    replyUser: mainVariables.receivedSocketData!.value.replyUser,
                    createdAt: mainVariables.receivedSocketData!.value.createdAt);
                mainVariables.chatUserList[i].unreadMessages.value++;
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                elevation: 0,
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 200),
                content: InkWell(
                  onTap: () {
                    mainVariables.conversationUserData.value = ConversationUserData(
                        userId: mainVariables.receivedSocketData!.value.userId,
                        avatar: mainVariables.receivedSocketData!.value.users.avatar,
                        firstName: mainVariables.receivedSocketData!.value.users.firstName,
                        lastName: mainVariables.receivedSocketData!.value.users.lastName,
                        userName: mainVariables.receivedSocketData!.value.users.username,
                        isBelieved: mainVariables.receivedSocketData!.value.believed);
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const ConversationPage();
                    }));
                  },
                  child: Container(
                    height: 80,
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green.shade300,
                        boxShadow: const [BoxShadow(color: Color(0XFF0EA102), offset: Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0)]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(image: NetworkImage(mainVariables.receivedSocketData!.value.users.avatar), fit: BoxFit.fill)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${mainVariables.receivedSocketData!.value.users.firstName} ${mainVariables.receivedSocketData!.value.users.lastName}",
                              style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                            ),
                            // Text(mainVariables.receivedSocketData!.value.users.username,style: TextStyle(fontSize: 14, color: Colors.grey,fontWeight: FontWeight.w500),),
                            SizedBox(
                                width: 250,
                                child: Text(
                                  mainVariables.receivedSocketData!.value.message,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
          }
        }
      });
      mainVariables.socket!.on('delete_message', (data) {
        debugPrint("deletetetete");
        if (mainVariables.isChatOpen.value) {
          if (data != null) {
            debugPrint("data");
            debugPrint(data);
            mainVariables.receivedSocketData = (ReceivedSocketDataModel.fromJson(data)).obs;
            debugPrint(mainVariables.receivedSocketData!.value.id);
            for (int i = 0; i < mainVariables.messagesListMain.length; i++) {
              if (mainVariables.messagesListMain[i].messageId == mainVariables.receivedSocketData!.value.id) {
                debugPrint("matched");
                debugPrint(mainVariables.messagesListMain[i].messageId);
                mainVariables.messagesListMain[i].status.value = 3;
              } else {
                debugPrint("not matched");
              }
            }
          }
        }
      });
      mainVariables.socket!.on('edit_message', (data) {
        debugPrint("edittitit");
        if (mainVariables.isChatOpen.value) {
          if (data != null) {
            debugPrint("data");
            debugPrint(data);
            mainVariables.receivedSocketData = (ReceivedSocketDataModel.fromJson(data)).obs;
            debugPrint(mainVariables.receivedSocketData!.value.id);
            for (int i = 0; i < mainVariables.messagesListMain.length; i++) {
              if (mainVariables.messagesListMain[i].messageId == mainVariables.receivedSocketData!.value.id) {
                mainVariables.messagesListMain[i].status.value = 4;
                mainVariables.messagesListMain[i].messageContent.value = mainVariables.receivedSocketData!.value.message;
              }
            }
          }
        }
      });
      mainVariables.socket!.on('connected-users', (data) {
        if (mainVariables.isChatOpen.value && mainVariables.conversationUserData.value.userId == data["user_id"]) {
          mainVariables.isUserActive.value = true;
          mainVariables.isLastActiveTime.value = "";
        }
        for (int i = 0; i < mainVariables.chatUserList.length; i++) {
          if (data["user_id"] == mainVariables.chatUserList[i].userId) {
            mainVariables.isActiveStatusList[i] = true;
          }
        }
      });
      mainVariables.socket!.on('disconnect-users', (data) {
        if (mainVariables.isChatOpen.value && mainVariables.conversationUserData.value.userId == data["user_id"]) {
          mainVariables.isUserActive.value = false;
          mainVariables.isLastActiveTime.value =
              DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format(DateTime.parse(data["online_date"]).toLocal().toLocal());
        }
        for (int i = 0; i < mainVariables.chatUserList.length; i++) {
          if (data["user_id"] == mainVariables.chatUserList[i].userId) {
            mainVariables.isActiveStatusList[i] = false;
          }
        }
      });
      Timer.periodic(const Duration(seconds: 30), (Timer t) {
        debugPrint("emitted online ping socket");
        mainVariables.socket!.emit('online-ping', <String, dynamic>{"user_id": userIdMain});
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAttachFile() async {
    List<Map<String, dynamic>> data = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'mp4', 'png', 'mp3', 'ogg', 'wav'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path ?? "")).toList();
      List<Map<String, File>> fileData = [];
      for (int i = 0; i < files.length; i++) {
        Map<String, File> data = {"file[$i]": files[i]};
        fileData.add(data);
      }
      var response = await functionsMain.sendMultipleFileForm(selectedFiles: fileData);
      for (int i = 0; i < response.data["response"].length; i++) {
        String fileType = "";
        if (response.data["response"][i].split(".").last == "jpg" || response.data["response"][i].split(".").last == "png") {
          fileType = "image";
        } else if (response.data["response"][i].split(".").last == "doc" || response.data["response"][i].split(".").last == "pdf") {
          fileType = "doc";
        } else if (response.data["response"][i].split(".").last == "mp4") {
          fileType = "video";
        } else if (response.data["response"][i].split(".").last == "mp3" ||
            response.data["response"][i].split(".").last == "wav" ||
            response.data["response"][i].split(".").last == "ogg") {
          fileType = "audio";
        }
        Map<String, dynamic> mapData = {
          "file": response.data["response"][i],
          "file_name": response.data["response"][i].split('/').last,
          "file_type": fileType
        };
        data.add(mapData);
      }
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> recording() async {
    List<Map<String, dynamic>> mapData = [];
    if (mainVariables.isRecording.value) {
      mainVariables.recorderController.reset();
      String? path1 = await mainVariables.recorderController.stop(false);
      if (path1 != null) {
        Map<String, File> data = {"file[0]": File(path1)};
        var response = await functionsMain.sendMultipleFileForm(selectedFiles: [data]);
        mapData.add({"file": response.data["response"][0], "file_name": response.data["response"][0].split('/').last, "file_type": 'audio'});
      }
      mainVariables.isRecording.value = false;
      return mapData;
    } else {
      PermissionStatus permission = await Permission.microphone.request();
      if (permission == PermissionStatus.granted) {
        String currentPath = await _getDir();
        await mainVariables.recorderController.record(path: currentPath);
        mainVariables.isRecording.value = true;
        return mapData;
      } else {
        mainVariables.isMicPressed.value = false;
        return mapData;
      }
    }
  }

  Future<String> _getDir() async {
    String currentPath = "";
    mainVariables.appDirectory = (await getExternalStorageDirectory())!;
    currentPath = "${mainVariables.appDirectory!.path}/${DateTime.now().millisecondsSinceEpoch}.m4a";
    return currentPath;
  }

  void handleReplyToMessage({required String originalMessage, required BuildContext context}) {
    // Implement logic to handle viewing the original message when tapped
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Original Message',
            style: TextStyle(fontSize: 12, decoration: TextDecoration.underline),
          ),
          content: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: conversationFunctionsMain.spanList(
                  message: originalMessage.length > 200 ? originalMessage.substring(0, 200) : originalMessage, context: context),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<TextSpan> spanList({required String message, required BuildContext context}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    List<TextSpan> textSpan = [];
    List<String> newSplit = message.split(' ');
    for (int i = 0; i < newSplit.length; i++) {
      if (newSplit[i].contains("+")) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                debugPrint(newSplit[i]);
                conversationApiMain.getValuesData(value: newSplit[i].substring(1), context: context);
              }));
      } else if ((RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"))
          .hasMatch(newSplit[i])) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: Colors.blue,
                fontSize: text.scale(14),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (newSplit[i].contains("://share.")) {
                  debugPrint("dynamic link");
                  debugPrint(newSplit[i]);
                  dynamicLinkToDeepLink(dynamicLinkString: newSplit[i], context: context);
                } else {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DemoPage(url: newSplit[i], text: "", image: "", id: "", type: "", activity: false)));*/
                  Get.to(const DemoView(), arguments: {"id": "", "type": '', "url": newSplit[i]});
                }
              }));
      } else {
        textSpan.add(
          TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary),
          ),
        );
      }
    }
    return textSpan;
  }

  List<TextSpan> spanListBillBoardHome({required String message, required BuildContext context, required bool isByte}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    List<TextSpan> textSpan = [];
    List<String> newSplit = message.split(' ');
    for (int i = 0; i < newSplit.length; i++) {
      if (newSplit[i].contains("+")) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                conversationApiMain.getValuesData(value: newSplit[i].substring(1), context: context);
              }));
      }
      // else if((RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+')).hasMatch(newSplit[i])){
      else if ((RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"))
          .hasMatch(newSplit[i])) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: Colors.blue,
                fontSize: text.scale(14),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (newSplit[i].contains("://share.")) {
                  debugPrint("dynamic link");
                  debugPrint(newSplit[i]);
                  dynamicLinkToDeepLink(dynamicLinkString: newSplit[i], context: context);
                } else {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DemoPage(url: newSplit[i], text: "", image: "", id: "", type: "", activity: false)));*/
                  Get.to(const DemoView(), arguments: {"id": "", "type": '', "url": newSplit[i]});
                }
              }));
      } else {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: isByte
                    ? isDarkTheme.value
                        ? Colors.white
                        : Colors.black
                    : Colors.white,
                fontSize: text.scale(14),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400)));
      }
    }
    return textSpan;
  }

  void dynamicLinkToDeepLink({required BuildContext context, required String dynamicLinkString}) async {
    PendingDynamicLinkData? details = await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(dynamicLinkString));
    List<String> dynamics = [];
    dynamics = details!.link.pathSegments;
    if (dynamics[0] == "DemoPage") {
      if (!context.mounted) {
        return;
      }
      /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return DemoPage(
          image: '',
          text: '',
          id: dynamics[1],
          url: '',
          type: dynamics[2],
          activity: true,
          checkMain: true,
        );
      }));*/
      Get.to(const DemoView(), arguments: {"id": dynamics[1], "type": dynamics[2], "url": ""});
    } else if (dynamics[0] == "VideoDescriptionPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return YoutubePlayerLandscapeScreen(
          id: dynamics[1],
          comeFrom: '',
        );
      }));
    } else if (dynamics[0] == "ForumPostDescriptionPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return ForumPostDescriptionPage(
          forumId: dynamics[1],
          comeFrom: '',
          idList: const [],
        );
      }));
    } else if (dynamics[0] == "FeaturePostDescriptionPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return FeaturePostDescriptionPage(
          navBool: '',
          sortValue: dynamics[3],
          featureId: dynamics[1],
          featureDetail: const {},
          idList: const [],
        );
      }));
    } else if (dynamics[0] == "AnalyticsPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return AnalyticsPage(
          surveyTitle: dynamics[3],
          activity: true,
          surveyId: dynamics[1],
        );
      }));
    } else if (dynamics[0] == "HomeScreen") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const MainBottomNavigationPage(
          tType: true,
          text: "",
          caseNo1: 0,
          newIndex: 0,
          excIndex: 1,
          countryIndex: 0,
          isHomeFirstTym: true,
        );
      }));
    } else if (dynamics[0] == "LockerPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return MainBottomNavigationPage(
          tType: true,
          text: dynamics[1],
          caseNo1: 1,
          newIndex: 0,
          excIndex: 1,
          countryIndex: 0,
          fromLink: true,
          isHomeFirstTym: false,
        );
      }));
    } else if (dynamics[0] == "FeatureRequestPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const FeatureRequestPage(
          fromWhere: "link",
        );
      }));
    } else if (dynamics[0] == "StocksAddFilterPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const StocksAddFilterPage(
          text: 'Stocks',
          page: 'locker',
        );
      }));
    } else if (dynamics[0] == "NewsMainPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return NewsMainPage(
          tickerId: '',
          tickerName: '',
          text: dynamics[1],
          fromCompare: false,
        );
      }));
    } else if (dynamics[0] == "VideosMainPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return VideosMainPage(
          tickerId: '',
          tickerName: '',
          text: dynamics[1],
          fromCompare: false,
        );
      }));
    } else if (dynamics[0] == "ForumPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return ForumPage(text: dynamics[1]);
      }));
    } else if (dynamics[0] == "SurveyPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SurveyPage(text: dynamics[1]);
      }));
    } else if (dynamics[0] == "FeaturePostPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const FeaturePostPage(
          fromLink: true,
        );
      }));
    } else if (dynamics[0] == "ForumPostPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return ForumPostPage(
          text: dynamics[1],
          fromLink: true,
        );
      }));
    } else if (dynamics[0] == "SurveyPostPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SurveyPostPage(
          text: dynamics[1],
          fromLink: true,
        );
      }));
    } else if (dynamics[0] == "WatchList") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const WatchList(
          excIndex: 1,
          countryIndex: 0,
          newIndex: 0,
        );
      }));
    } else if (dynamics[0] == "AddWatchlistPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return AddWatchlistPage(
            excIndex: int.parse(dynamics[2][1]), countryIndex: int.parse(dynamics[2][2]), newIndex: int.parse(dynamics[2][0]), tickerId: dynamics[1]);
      }));
    } else if (dynamics[0] == "TickersDetailsPage") {
      if (!context.mounted) {
        return;
      }
      switch (dynamics[2]) {
        case "000":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: dynamics[1],
                exchange: 'US',
                country: 'USA',
                name: '',
                fromWhere: 'main',
              );
            }));
            /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
          }
          break;
        case "010":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: dynamics[1],
                exchange: 'NSE',
                country: 'India',
                name: '',
                fromWhere: 'main',
              );
            }));
            /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
          }
          break;
        case "020":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: dynamics[1],
                exchange: 'BSE',
                country: 'India',
                name: '',
                fromWhere: 'main',
              );
            }));
            /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
          }
          break;
        case "100":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'crypto',
                id: dynamics[1],
                exchange: 'NSE',
                country: 'India',
                name: '',
                fromWhere: 'main',
              );
            }));
            /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
          }
          break;
        case "200":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'commodity',
                id: dynamics[1],
                exchange: 'NSE',
                country: 'India',
                name: '',
                fromWhere: 'main',
              );
            }));
            /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
          }
          break;
        case "201":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'commodity',
                id: dynamics[1],
                exchange: 'NSE',
                country: 'USA',
                name: '',
                fromWhere: 'main',
              );
            }));
            /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
          }
          break;
        case "300":
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'forex',
                id: dynamics[1],
                exchange: 'NSE',
                country: 'USA',
                name: '',
                fromWhere: 'main',
              );
            }));
            /*  mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
          }
          break;
        default:
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: dynamics[1],
                exchange: 'NSE',
                country: 'India',
                name: '',
                fromWhere: 'main',
              );
            }));
            /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
             */
          }
      }
    } else if (dynamics[0] == "SetAlertPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SetAlertPage(
          tickerId: dynamics[1],
          indexValue: dynamics[2],
        );
      }));
    } else if (dynamics[0] == "MyActivityPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const MyActivityPage(
          fromLink: true,
        );
      }));
    } else if (dynamics[0] == "BlockListPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return mainSkipValue
            ? const MainBottomNavigationPage(
                caseNo1: 0,
                text: '',
                excIndex: 1,
                newIndex: 0,
                countryIndex: 0,
                tType: true,
                isHomeFirstTym: true,
              )
            : const BlockListPage(tabIndex: 0, blockBool: true, fromLink: true);
      }));
    } else if (dynamics[0] == "SettingsPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const SettingsView();
      }));
    } else if (dynamics[0] == "EditProfilePage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const EditProfilePage(
          comeFrom: true,
        );
      }));
    } else if (dynamics[0] == "FinalChartPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return FinalChartPage(
          tickerId: dynamics[1],
          category: dynamics[2],
          exchange: dynamics[3],
          chartType: dynamics[4],
          fromLink: true,
          index: 0,
        );
      }));
    } else if (dynamics[0] == "BillBoardHome") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return MainBottomNavigationPage(
            caseNo1: 2,
            text: finalisedCategory.toString().capitalizeFirst ?? "Stocks",
            excIndex: 1,
            newIndex: 0,
            countryIndex: 0,
            isHomeFirstTym: false,
            tType: true);
      }));
    } else if (dynamics[0] == "BytesDescriptionPage") {
      if (!context.mounted) {
        return;
      }
      mainVariables.selectedBillboardIdMain.value = dynamics[1];
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const BytesDescriptionPage(
          fromWhere: "profile",
        );
      }));
    } else if (dynamics[0] == "BlogDescriptionPage") {
      if (!context.mounted) {
        return;
      }
      mainVariables.selectedBillboardIdMain.value = dynamics[1];
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const BlogDescriptionPage(
          fromWhere: "profile",
        );
      }));
    } else if (dynamics[0] == "UserProfilePage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return UserBillBoardProfilePage(
          userId: dynamics[1],
        );
      }));
    } else if (dynamics[0] == "IntermediaryPage") {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return IntermediaryBillBoardProfilePage(
          userId: dynamics[1],
        );
      }));
    } else if (dynamics[0] == "BusinessProfilePage") {
      if (!context.mounted) {
        return;
      }
      mainVariables.selectedTickerId.value = dynamics[1];
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const BusinessProfilePage();
      }));
    } else {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const MainBottomNavigationPage(
          caseNo1: 0,
          text: '',
          excIndex: 1,
          newIndex: 0,
          countryIndex: 0,
          tType: true,
          isHomeFirstTym: true,
        );
      }));
    }
  }

  conversationSearchData({required String newResponseValue, required StateSetter newSetState}) async {
    var split = newResponseValue.split('+');
    var val = split[split.length - 1];
    var url = Uri.parse(baseurl + versions + tagSearch);
    var newResponse = await http.post(url, headers: {'Authorization': kToken}, body: {'search': val});
    var newResponseData = jsonDecode(newResponse.body.toString());
    if (newResponseData["status"]) {
      mainVariables.searchResultMain.clear();
      mainVariables.searchLogoMain.clear();
      mainVariables.searchIdResultMain.clear();
      if (newResponseData["response"].length == 0) {
        newSetState(() {
          mainVariables.isUserTagging.value = false;
        });
      } else {
        for (int i = 0; i < newResponseData["response"].length; i++) {
          newSetState(() {
            mainVariables.isUserTagging.value = true;
            mainVariables.searchResultMain.add(newResponseData["response"][i]["username"]);
            mainVariables.searchIdResultMain.add(newResponseData["response"][i]["_id"]);
            if (newResponseData["response"][i].containsKey("avatar")) {
              mainVariables.searchLogoMain.add(newResponseData["response"][i]["avatar"]);
            } else {
              mainVariables.searchLogoMain.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
          });
        }
      }
    } else {
      newSetState(() {
        mainVariables.isUserTagging.value = false;
      });
    }
  }
}
