import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'messages_list_model.dart';

ReceivedSocketDataModel receivedSocketDataModelFromJson(String str) => ReceivedSocketDataModel.fromJson(json.decode(str));

String receivedSocketDataModelToJson(ReceivedSocketDataModel data) => json.encode(data.toJson());

class ReceivedSocketDataModel {
  final String message;
  final String userId;
  final String receiverId;
  final String roomId;
  final bool readStatus;
  final String type;
  int status;
  final String createdAt;
  final String id;
  final bool believed;
  final UsersMain users;
  final ReplyUser replyUser;
  final List<FileElement> files;

  ReceivedSocketDataModel({
    required this.message,
    required this.userId,
    required this.receiverId,
    required this.roomId,
    required this.readStatus,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.id,
    required this.believed,
    required this.users,
    required this.replyUser,
    required this.files,
  });

  factory ReceivedSocketDataModel.fromJson(Map<String, dynamic> json) => ReceivedSocketDataModel(
        message: json["message"] ?? "",
        userId: json["user_id"] ?? "",
        receiverId: json["reciever_id"] ?? "",
        roomId: json["room_id"] ?? "",
        readStatus: json["read_status"] ?? false,
        type: json["type"] ?? "",
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] ?? "",
        id: json["_id"] ?? "",
        believed: json["believed"] ?? false,
        users: UsersMain.fromJson(json["users"] ?? {}),
        replyUser: ReplyUser.fromJson(json["reply"] ?? {}),
        files: json["files"] == null ? [] : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
        "reciever_id": receiverId,
        "room_id": roomId,
        "read_status": readStatus,
        "type": type,
        "status": status,
        "createdAt": createdAt,
        "_id": id,
        "believed": believed,
        "users": users.toJson(),
        "reply": replyUser.toJson(),
        "files": List<FileElement>.from(files.map((x) => x.toJson())),
      };
}

class UsersMain {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String avatar;

  UsersMain({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.avatar,
  });

  factory UsersMain.fromJson(Map<String, dynamic> json) => UsersMain(
        userId: json["user_id"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "avatar": avatar,
      };
}

class ChatMessage {
  String messageId;
  RxString messageContent;
  String messageType;
  bool changedDate;
  String currentDate;
  DateTime currentTime;
  List<FileElement> data;
  RxInt status;
  ReplyUser reply;
  RxBool isTranslated;
  RxString tempMessage;

  ChatMessage({
    required this.messageId,
    required this.messageContent,
    required this.messageType,
    required this.currentTime,
    required this.data,
    required this.status,
    required this.reply,
    required this.changedDate,
    required this.currentDate,
    required this.isTranslated,
    required this.tempMessage,
  });
}

class ConversationUserData {
  String userId;
  String avatar;
  String firstName;
  String lastName;
  String userName;
  bool isBelieved;

  ConversationUserData({
    required this.userId,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.isBelieved,
  });
}

class FileElement {
  final String file;
  final String fileName;
  final String fileType;

  FileElement({
    required this.file,
    required this.fileName,
    required this.fileType,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        file: json["file"] ?? "",
        fileName: json["file_name"] ?? "",
        fileType: json["file_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "file_name": fileName,
        "file_type": fileType,
      };
}
