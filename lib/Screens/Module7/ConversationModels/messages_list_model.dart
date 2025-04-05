import 'dart:convert';

import 'package:intl/intl.dart';

import 'conversation_models.dart';

MessageListModel messageListModelFromJson(String str) => MessageListModel.fromJson(json.decode(str));

String messageListModelToJson(MessageListModel data) => json.encode(data.toJson());

class MessageListModel {
  final bool status;
  final String message;
  final List<MessageListResponse> response;
  bool blocked;
  BlockDetail? blockedBy;

  MessageListModel({
    required this.status,
    required this.message,
    required this.response,
    required this.blocked,
    required this.blockedBy,
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        response: json["response"] == null
            ? []
            : List<MessageListResponse>.from(json["response"].map((x) => MessageListResponse.fromJson(x))),
        blocked: json["blocked"] ?? false,
        blockedBy: BlockDetail.fromJson(json["block_details"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<MessageListResponse>.from(response.map((x) => x.toJson())),
        "blocked": blocked,
        "block_details": blockedBy!.toJson(),
      };
}

class MessageListResponse {
  final String id;
  final String message;
  final String userId;
  final String receiverId;
  final List<FileElement> files;
  final String roomId;
  final bool readStatus;
  final String type;
  final int status;
  final Users users;
  final ReplyUser replyUser;
  final String createdAt;
  final bool changedDate;
  final String currentDate;

  MessageListResponse({
    required this.id,
    required this.message,
    required this.userId,
    required this.receiverId,
    required this.files,
    required this.roomId,
    required this.readStatus,
    required this.type,
    required this.status,
    required this.users,
    required this.replyUser,
    required this.createdAt,
    required this.changedDate,
    required this.currentDate,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) => MessageListResponse(
        id: json["_id"] ?? "",
        message: json["message"] ?? "",
        userId: json["user_id"] ?? "",
        receiverId: json["reciever_id"] ?? "",
        files: json["files"] == null ? [] : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        roomId: json["room_id"] ?? "",
        readStatus: json["read_status"] ?? false,
        type: json["type"] ?? "",
        changedDate: json["changed_date"] ?? false,
        currentDate: json["date_change"] ?? "",
        status: json["status"] ?? 0,
        users: Users.fromJson(json["reply"] ?? {}),
        replyUser: ReplyUser.fromJson(json["reply"] ?? {}),
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US')
            .format((json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now()).toLocal().toLocal()),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "user_id": userId,
        "reciever_id": receiverId,
        "files": List<FileElement>.from(files.map((x) => x.toJson())),
        "room_id": roomId,
        "read_status": readStatus,
        "type": type,
        "status": status,
        "users": users.toJson(),
        "reply": replyUser.toJson(),
        "createdAt": createdAt,
        "changed_date": currentDate,
        "date_change": createdAt,
      };
}

class Users {
  final String id;
  final String username;
  final String avatar;

  Users({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar": avatar,
      };
}

class BlockDetail {
  String id;
  String userId;
  final String blockedUser;
  final String createdAt;
  final String updatedAt;

  BlockDetail({
    required this.id,
    required this.userId,
    required this.blockedUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlockDetail.fromJson(Map<String, dynamic> json) => BlockDetail(
        id: json["_id"] ?? "",
        userId: json["user_id"] ?? "",
        blockedUser: json["blocked_user"] ?? "",
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "blocked_user": blockedUser,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class ReplyUser {
  final String replyId;
  final String userId;
  final String avatar;
  final String message;
  final String username;
  final int status;
  final List<FileElement> files;

  ReplyUser({
    required this.replyId,
    required this.userId,
    required this.avatar,
    required this.message,
    required this.username,
    required this.status,
    required this.files,
  });

  factory ReplyUser.fromJson(Map<String, dynamic> json) => ReplyUser(
        replyId: json["reply_id"] ?? "",
        userId: json["user_id"] ?? "",
        avatar: json["avatar"] ?? "",
        message: json["message"] ?? "",
        username: json["username"] ?? "",
        status: json["status"] ?? 0,
        files: json["files"] == null ? [] : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reply_id": replyId,
        "user_id": userId,
        "avatar": avatar,
        "message": message,
        "username": username,
        "status": status,
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
      };
}
