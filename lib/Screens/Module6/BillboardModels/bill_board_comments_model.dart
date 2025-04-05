import 'dart:convert';

import '../../Module2/FeatureRequest/feature_response_model.dart';

BillBoardCommentsModel billBoardCommentsModelFromJson(String str) => BillBoardCommentsModel.fromJson(json.decode(str));

String billBoardCommentsModelToJson(BillBoardCommentsModel data) => json.encode(data.toJson());

class BillBoardCommentsModel {
  final bool status;
  final String message;
  final List<CommentsResponse> response;

  BillBoardCommentsModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BillBoardCommentsModel.fromJson(Map<String, dynamic> json) => BillBoardCommentsModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: json["response"] == null
            ? []
            : List<CommentsResponse>.from(json["response"].map((x) => CommentsResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class CommentsResponse {
  final String id;
  final String message;
  final List<String> files;
  final String fileType;
  final int likesCount;
  final int disLikesCount;
  final String billboardId;
  final String responseId;
  final List<dynamic> taggedUser;
  final Users users;
  final String billboardUser;
  final String responseUser;
  final int status;
  final String createdAt;
  final String updatedAt;
  final bool believed;
  final bool likes;
  final bool dislikes;
  final bool translation;

  CommentsResponse({
    required this.id,
    required this.message,
    required this.files,
    required this.fileType,
    required this.likesCount,
    required this.disLikesCount,
    required this.billboardId,
    required this.responseId,
    required this.taggedUser,
    required this.users,
    required this.billboardUser,
    required this.responseUser,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.believed,
    required this.likes,
    required this.dislikes,
    required this.translation,
  });

  factory CommentsResponse.fromJson(Map<String, dynamic> json) => CommentsResponse(
        id: json["_id"] ?? "",
        message: json["message"] ?? "",
        files: json["files"] == null ? [] : List<String>.from(json["files"].map((x) => x)),
        fileType: json["file_type"] ?? '',
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        billboardId: json["billboard_id"] ?? "",
        responseId: json["response_id"] ?? "",
        taggedUser: json["tagged_user"] == null ? [] : List<dynamic>.from(json["tagged_user"].map((x) => x)),
        users: Users.fromJson(json["users"] ?? {}),
        billboardUser: json["billboard_user"] ?? "",
        responseUser: json["response_user"] ?? "",
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        updatedAt: json["updatedAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["updatedAt"]).millisecondsSinceEpoch),
        believed: json["believe"] ?? false,
        likes: json["likes"] ?? false,
        dislikes: json["dislikes"] ?? false,
        translation: json["translation"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "files": List<dynamic>.from(files.map((x) => x)),
        "file_type": fileType,
        "likes_count": likesCount,
        "dis_likes_count": disLikesCount,
        "billboard_id": billboardId,
        "response_id": responseId,
        "tagged_user": List<dynamic>.from(taggedUser.map((x) => x)),
        "users": users.toJson(),
        "billboard_user": billboardUser,
        "response_user": responseUser,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "believed": believed,
        "likes": likes,
        "dislikes": dislikes,
        "translation": translation,
      };
}

class Users {
  final String userId;
  final String username;
  final String avatar;
  final String profileType;
  final String tickerId;
  final int believersCount;

  Users({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.profileType,
    required this.tickerId,
    required this.believersCount,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["user_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        profileType: json["profile_type"] ?? "",
        tickerId: json["ticker_id"] ?? "",
        believersCount: json["believers_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "avatar": avatar,
        "profile_type": profileType,
        "ticker_id": tickerId,
        "believers_count": believersCount,
      };
}
