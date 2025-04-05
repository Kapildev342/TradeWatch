import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'messages_list_model.dart';

ConversationUsersListModel conversationUsersListModelFromJson(String str) =>
    ConversationUsersListModel.fromJson(json.decode(str));

String conversationUsersListModelToJson(ConversationUsersListModel data) => json.encode(data.toJson());

class ConversationUsersListModel {
  final bool status;
  final String message;
  final List<IndividualChatUserResponse> response;

  ConversationUsersListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory ConversationUsersListModel.fromJson(Map<String, dynamic> json) => ConversationUsersListModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: json["response"] == null
            ? []
            : List<IndividualChatUserResponse>.from(json["response"].map((x) => IndividualChatUserResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class IndividualChatUserResponse {
  final String roomId;
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String avatar;
  bool believed;
  final bool onlineActive;
  final String onlineDate;
  final int believersCount;
  final int believedCount;
  RxInt unreadMessages;
  Rx<Message> message;

  IndividualChatUserResponse({
    required this.roomId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.avatar,
    required this.believed,
    required this.onlineActive,
    required this.onlineDate,
    required this.believersCount,
    required this.believedCount,
    required this.unreadMessages,
    required this.message,
  });

  factory IndividualChatUserResponse.fromJson(Map<String, dynamic> json) => IndividualChatUserResponse(
        roomId: json["room_id"] ?? '',
        userId: json["user_id"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        believed: json["believed"] ?? false,
        onlineActive: json["online_active"] ?? false,
        onlineDate: DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format(
            (json["online_date"] != null ? DateTime.parse(json["online_date"]) : DateTime.now()).toLocal().toLocal()),
        believersCount: json["believers_count"] ?? 0,
        believedCount: json["believed_count"] ?? 0,
        unreadMessages: int.parse((json["unread_messages"] ?? 0).toString()).obs,
        message: (Message.fromJson(json["message"] ?? {})).obs,
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "avatar": avatar,
        "believed": believed,
        "online_active": onlineActive,
        "online_date": onlineDate,
        "believers_count": believersCount,
        "believed_count": believedCount,
        "unread_messages": unreadMessages,
        "message": message.toJson(),
      };
}

class Message {
  final String message;
  final String userId;
  final String receiverId;
  final List<dynamic> files;
  final String roomId;
  final bool readStatus;
  final String type;
  final ReplyUser replyUser;
  final int status;
  final String createdAt;

  Message({
    required this.message,
    required this.userId,
    required this.receiverId,
    required this.files,
    required this.roomId,
    required this.readStatus,
    required this.type,
    required this.replyUser,
    required this.status,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json["message"] ?? "",
        userId: json["user_id"] ?? "",
        receiverId: json["reciever_id"] ?? "",
        files: json["files"] == null ? [] : List<dynamic>.from(json["files"].map((x) => x)),
        roomId: json["room_id"] ?? "",
        readStatus: json["read_status"] ?? false,
        type: json["type"] ?? "",
        status: json["status"] ?? 0,
        replyUser: ReplyUser.fromJson(json["reply"] ?? {}),
        createdAt: DateFormat('yyyy-MM-dd hh:mm a', 'en_US')
            .format((json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now()).toLocal().toLocal()),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
        "reciever_id": receiverId,
        "files": List<dynamic>.from(files.map((x) => x)),
        "room_id": roomId,
        "read_status": readStatus,
        "type": type,
        "status": status,
        "reply": replyUser.toJson(),
        "createdAt": createdAt,
      };
}
