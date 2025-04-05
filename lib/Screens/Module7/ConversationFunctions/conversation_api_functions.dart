import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/contact_users_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/get_documets_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/messages_list_model.dart';

import '../ConversationModels/conversation_users_list_model.dart';

class ConversationApiFunctions {
  conversationUsersList({
    required String type,
    required String fromWhere,
    required int skipCount,
  }) async {
    var uri = Uri.parse(baseurl + versionChat + userList);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "type": type,
      "skip": skipCount.toString(),
      "limit": "20",
      "search": fromWhere == "conversation"
          ? mainVariables.billBoardListSearchControllerMain.value.text
          : mainVariables.sendMessageListSearchControllerMain.value.text,
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (skipCount == 0) {
      mainVariables.chatUserList.clear();
      mainVariables.chatUserSendList.clear();
    }
    mainVariables.conversationUsers = (ConversationUsersListModel.fromJson(responseData)).obs;
    mainVariables.chatUserList.addAll(mainVariables.conversationUsers!.value.response);
    mainVariables.chatUserSendList.addAll(mainVariables.conversationUsers!.value.response);
    for (int i = 0; i < mainVariables.chatUserList.length; i++) {
      mainVariables.isActiveStatusList.add(mainVariables.chatUserList[i].onlineActive);
      mainVariables.isLastActiveList.add(mainVariables.chatUserList[i].onlineDate);
    }
    for (int i = 0; i < mainVariables.chatUserSendList.length; i++) {
      mainVariables.isActiveStatusSendList.add(mainVariables.chatUserSendList[i].onlineActive);
      mainVariables.isLastActiveSendList.add(mainVariables.chatUserSendList[i].onlineDate);
    }
  }

  activeUsersList({
    required int skipCount,
  }) async {
    var uri = Uri.parse(baseurl + versionChat + activeUserList);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "skip": skipCount.toString(),
      "limit": "20",
      "search": mainVariables.billBoardListSearchControllerMain.value.text,
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (skipCount == 0) {
      mainVariables.activeUserList.clear();
    }
    mainVariables.activeUsers = (ConversationUsersListModel.fromJson(responseData)).obs;
    mainVariables.activeUserList.addAll(mainVariables.activeUsers!.value.response);
    for (int i = 0; i < mainVariables.activeUserList.length; i++) {
      mainVariables.isActiveStatusUsersList.add(mainVariables.activeUserList[i].onlineActive);
      mainVariables.isLastActiveUsersList.add(mainVariables.activeUserList[i].onlineDate);
    }
  }

  Future<String> sendMessageApiFunctions({
    required BuildContext context,
    required String type,
    required String receiverId,
    required String message,
    required String messageId,
    required List<Map<String, dynamic>> files,
    required String groupId,
  }) async {
    var uri = baseurl + versionChat + sendMessage;
    Map<String, dynamic> data = mainVariables.isEditing.value
        ? {
            "type": type,
            "reciever_id": receiverId,
            "message": message,
            "message_id": messageId,
            "files": files,
            "group_id": groupId,
          }
        : mainVariables.isReplying.value
            ? {
                "type": type,
                "reciever_id": receiverId,
                "message": message,
                "reply_id": messageId,
                "files": files,
                "group_id": groupId,
              }
            : {
                "type": type,
                "reciever_id": receiverId,
                "message": message,
                "files": files,
                "group_id": groupId,
              };
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": kToken,
        }),
        data: data);
    Map<String, dynamic> responseData = response.data;
    if (responseData["status"] == false) {
      if (!context.mounted) {
        return "";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData["message"])));
    }
    return responseData["message_id"] ?? "";
  }

  getUsersList({
    required int skipCount,
  }) async {
    Uri uri = Uri.parse(baseurl + versions + tradersList);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "search": mainVariables.believedListSearchControllerMain.value.text,
      "skip": skipCount.toString(),
      "limit": "10",
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    ContactUsersListModel contactUsers = ContactUsersListModel.fromJson(responseData);
    mainVariables.usersList.addAll(contactUsers.response);
  }

  Future<MessageListModel> getMessagesList({
    required String type,
    required String userId,
    required String groupId,
    required String skip,
  }) async {
    var uri = Uri.parse(baseurl + versionChat + messageList);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "type": type,
      "userId": userId,
      "group_id": groupId,
      "skip": skip,
      "limit": "10",
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    MessageListModel messagesList = MessageListModel.fromJson(responseData);
    return messagesList;
  }

  getMessageClearFunction({
    required BuildContext context,
    required String type,
    required String userId,
    required String groupId,
  }) async {
    var uri = Uri.parse(baseurl + versionChat + messageClear);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "type": type,
      "userId": userId,
      "group_id": groupId
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    debugPrint(responseData["status"]);
    debugPrint(responseData["message"]);
  }

  Future<bool> getMessageDeleteFunction({
    required BuildContext context,
    required String messageId,
    required bool isSender,
  }) async {
    var uri = isSender ? baseurl + versionChat + messageDelete : baseurl + versionChat + deleteOthersChatMessage;
    List<String> idsList = [];
    idsList.add(messageId);
    Map<String, dynamic> data = isSender
        ? {
            "message_id": messageId,
          }
        : {
            "message_ids": idsList,
          };
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": kToken,
        }),
        data: data);
    Map<String, dynamic> responseData = response.data;
    return responseData["status"];
  }

  reportUser(
      {required BuildContext context,
      required String action,
      required String why,
      required String description,
      required String userId,
      String? fromWhere}) async {
    debugPrint("hello");
    debugPrint(why);
    if (why == "Other") {
      debugPrint(description);
      if (description == "") {
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versions + report);
        var responseNew = await http
            .post(url, body: {"action": action, "why": why, "description": description, "reported_user": userId}, headers: {'Authorization': kToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (fromWhere == "profile") {
            if (action == "Block") {
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
            }
          } else {
            mainVariables.messagesList!.value = await conversationApiMain.getMessagesList(
                type: "private", userId: mainVariables.conversationUserData.value.userId, groupId: "", skip: '0');
          }
          //mainVariables.messagesList!.value.blockedBy!.userId=userIdMain;
          if (!context.mounted) {
            return;
          }
          Navigator.pop(context);
        } else {
          if (!context.mounted) {
            return;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      debugPrint(fromWhere);
      debugPrint(action);
      var url = Uri.parse(baseurl + versions + report);
      var responseNew = await http
          .post(url, body: {"action": action, "why": why, "description": description, "reported_user": userId}, headers: {'Authorization': kToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (fromWhere == "profile") {
          if (action == "Block") {
            if (!context.mounted) {
              return;
            }
            Navigator.pop(context);
          }
        } else {
          mainVariables.messagesList!.value = await conversationApiMain.getMessagesList(
              type: "private", userId: mainVariables.conversationUserData.value.userId, groupId: "", skip: '0');
        }
        //mainVariables.messagesList!.value.blockedBy!.userId=userIdMain;
        if (!context.mounted) {
          return;
        }
        Navigator.pop(context);
      } else {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  Future<bool> unblockUser({required BuildContext context, required String userId}) async {
    var url = Uri.parse(baseurl + versions + blockUnblock);
    var responseNew = await http.post(url, body: {"block_user": userId}, headers: {'Authorization': kToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseDataNew["status"];
  }

  getDocumentsList({
    required String type,
    required String userId,
    required String groupId,
    required String docType,
    required String skip,
    required String limit,
  }) async {
    var uri = Uri.parse(baseurl + versionChat + getDocuments);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "type": type,
      "userId": userId,
      "group_id": groupId,
      "document_type": docType,
      "skip": skip,
      "limit": limit,
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    mainVariables.getDocument = (GetDocumentsModel.fromJson(responseData)).obs;
  }

  getValuesData({required String value, required BuildContext context}) async {
    var url = Uri.parse(baseurl + versions + getUserData);
    var newResponse = await http.post(url, headers: {'Authorization': kToken}, body: {'username': value});
    var newResponseData = jsonDecode(newResponse.body.toString());
    if (newResponseData['status'] == true) {
      if (newResponseData['page_view'] == 0) {
        if (!context.mounted) {
          return false;
        }
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return const BlockListPage(blockBool: true, tabIndex: 0);
        }));
      } else if (newResponseData['page_view'] == 1) {
        if (!context.mounted) {
          return false;
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${newResponseData['data']['username']} blocked you, You don't have permission to visit this profile")));
      } else if (newResponseData['page_view'] == 2) {
        if (!context.mounted) {
          return false;
        }
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return UserBillBoardProfilePage(userId: newResponseData['data']['_id']);
        }));
      } else {
        if (!context.mounted) {
          return false;
        }
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return UserBillBoardProfilePage(userId: newResponseData['data']['_id']);
        }));
      }
    } else {
      if (!context.mounted) {
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Name is not valid")));
    }
  }

  Future<bool> translatingChatFunc({required String id, required int index}) async {
    Uri uri = Uri.parse(baseurl + versionChat + chatTranslate);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "message_id": id,
    });
    var responseData = jsonDecode(response.body);
    if (responseData["response"] != null) {
      mainVariables.messagesListMain[index].messageContent.value = responseData["response"]["message"];
      return responseData["status"];
    } else {
      return false;
    }
  }
}
