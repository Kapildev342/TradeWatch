import 'dart:convert';

import '../../Module2/FeatureRequest/feature_response_model.dart';

BillBoardResponseModel billBoardResponseModelFromJson(String str) => BillBoardResponseModel.fromJson(json.decode(str));

String billBoardResponseModelToJson(BillBoardResponseModel data) => json.encode(data.toJson());

class BillBoardResponseModel {
  final bool status;
  final String message;
  final List<BlogResponse> response;

  BillBoardResponseModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BillBoardResponseModel.fromJson(Map<String, dynamic> json) => BillBoardResponseModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response:
            json["response"] == null ? [] : List<BlogResponse>.from(json["response"].map((x) => BlogResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class BlogResponse {
  final String id;
  final String message;
  final List<String> files;
  final String fileType;
  final int likesCount;
  final int dislikesCount;
  final int responseCount;
  final String billboardId;
  final List<dynamic> taggedUser;
  final Users users;
  final String billboardUser;
  final int status;
  final String createdAt;
  final String updatedAt;
  final bool believed;
  final bool likes;
  final bool dislikes;
  final bool translation;
  final String profileType;

  BlogResponse({
    required this.id,
    required this.message,
    required this.files,
    required this.fileType,
    required this.likesCount,
    required this.dislikesCount,
    required this.responseCount,
    required this.billboardId,
    required this.taggedUser,
    required this.users,
    required this.billboardUser,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.believed,
    required this.likes,
    required this.dislikes,
    required this.translation,
    required this.profileType,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) => BlogResponse(
        id: json["_id"] ?? "",
        message: json["message"] ?? "",
        files: json["files"] == null ? [] : List<String>.from(json["files"].map((x) => x)),
        fileType: json["file_type"] ?? '',
        likesCount: json["likes_count"] ?? 0,
        dislikesCount: json["dis_likes_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        billboardId: json["billboard_id"] ?? "",
        taggedUser: json["tagged_user"] == null ? [] : List<dynamic>.from(json["tagged_user"].map((x) => x)),
        users: Users.fromJson(json["users"] ?? {}),
        billboardUser: json["billboard_user"] ?? '',
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        updatedAt: json["updatedAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["updatedAt"]).millisecondsSinceEpoch),
        believed: json["believed"] ?? false,
        likes: json["like"] ?? false,
        dislikes: json["dislike"] ?? false,
        translation: json["translation"] ?? false,
        profileType: json["profile_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "files": List<dynamic>.from(files.map((x) => x)),
        "file_type": fileType,
        "likes_count": likesCount,
        "dis_likes_count": dislikesCount,
        "response_count": responseCount,
        "billboard_id": billboardId,
        "tagged_user": List<dynamic>.from(taggedUser.map((x) => x)),
        "users": users.toJson(),
        "billboard_user": billboardUser,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "believe": believed,
        "like": likes,
        "dislike": dislikes,
        "translation": translation,
        "profile_type": profileType,
      };
}

class Users {
  final String userId;
  final String username;
  final String avatar;
  final int believersCount;

  Users({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.believersCount,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        believersCount: json["believers_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": userId,
        "username": username,
        "avatar": avatar,
        "believers_count": believersCount,
      };
}
