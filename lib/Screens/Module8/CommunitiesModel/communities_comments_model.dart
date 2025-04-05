/*import 'dart:convert';

import 'package:get/get.dart';

import 'communities_list_page_model.dart';

CommunitiesCommentsListModel communitiesCommentsListModelFromJson(String str) => CommunitiesCommentsListModel.fromJson(json.decode(str));

String communitiesCommentsListModelToJson(CommunitiesCommentsListModel data) => json.encode(data.toJson());

class CommunitiesCommentsListModel {
  final Rx<bool> status;
  final Rx<String> message;
  final RxList<CommunitiesCommentsResponse> response;

  CommunitiesCommentsListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesCommentsListModel.fromJson(Map<String, dynamic> json) => CommunitiesCommentsListModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: RxList<CommunitiesCommentsResponse>.from((json["response"] ?? []).map((x) => CommunitiesCommentsResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class CommunitiesCommentsResponse {
  final Rx<String> id;
  final Rx<String> communityId;
  final Rx<String> postId;
  final Rx<String> userId;
  final Rx<String> responseId;
  final Rx<int> likesCount;
  final Rx<int> dislikesCount;
  final RxList<CommunityFileElement> files;
  final Rx<String> message;
  final Rx<String> firstName;
  final Rx<String> avatar;
  final Rx<String> lastName;
  final Rx<String> username;
  final Rx<int> believedCount;
  final Rx<int> believersCount;
  final Rx<bool> believed;

  CommunitiesCommentsResponse({
    required this.id,
    required this.communityId,
    required this.postId,
    required this.userId,
    required this.responseId,
    required this.likesCount,
    required this.dislikesCount,
    required this.files,
    required this.message,
    required this.firstName,
    required this.avatar,
    required this.lastName,
    required this.username,
    required this.believedCount,
    required this.believersCount,
    required this.believed,
  });

  factory CommunitiesCommentsResponse.fromJson(Map<String, dynamic> json) => CommunitiesCommentsResponse(
        id: (json["_id"] ?? "").toString().obs,
        communityId: (json["community_id"] ?? "").toString().obs,
        postId: (json["post_id"] ?? "").toString().obs,
        userId: (json["user_id"] ?? "").toString().obs,
        responseId: (json["response_id"] ?? "").toString().obs,
        likesCount: int.parse("${json["likes_count"] ?? 0}").obs,
        dislikesCount: int.parse("${json["dislikes_count"] ?? 0}").obs,
        files: RxList<CommunityFileElement>.from((json["files"] ?? []).map((x) => x)),
        message: (json["message"] ?? "").toString().obs,
        firstName: (json["first_name"] ?? "").toString().obs,
        avatar: (json["avatar"] ?? "").toString().obs,
        lastName: (json["last_name"] ?? "").toString().obs,
        username: (json["username"] ?? "").toString().obs,
        believedCount: int.parse("${json["believed_count"] ?? 0}").obs,
        believersCount: int.parse("${json["believers_count"] ?? 0}").obs,
        believed: ((json["believed"] ?? false) as bool).obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "community_id": communityId,
        "post_id": postId,
        "user_id": userId,
        "response_id": responseId,
        "likes_count": likesCount,
        "dislikes_count": dislikesCount,
        "files": List<CommunityFileElement>.from(files.map((x) => x)),
        "message": message,
        "first_name": firstName,
        "avatar": avatar,
        "last_name": lastName,
        "username": username,
        "believed_count": believedCount,
        "believers_count": believersCount,
        "believed": believed,
      };
}*/

import 'dart:convert';

import '../../Module1/NewsPage/news_single_model.dart';

CommunitiesCommentsModel billBoardCommentsModelFromJson(String str) => CommunitiesCommentsModel.fromJson(json.decode(str));

String billBoardCommentsModelToJson(CommunitiesCommentsModel data) => json.encode(data.toJson());

class CommunitiesCommentsModel {
  final bool status;
  final String message;
  final List<CommunitiesCommentsResponse> response;

  CommunitiesCommentsModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesCommentsModel.fromJson(Map<String, dynamic> json) => CommunitiesCommentsModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: json["response"] == null
            ? []
            : List<CommunitiesCommentsResponse>.from(json["response"].map((x) => CommunitiesCommentsResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class CommunitiesCommentsResponse {
  final String id;
  final String message;
  final List<String> files;
  final String fileType;
  final int likesCount;
  final int disLikesCount;
  final String billboardId;
  final String responseId;
  final List<dynamic> taggedUser;
  final CommunitiesUsers users;
  final String billboardUser;
  final String responseUser;
  final int status;
  final String createdAt;
  final String updatedAt;
  final bool believed;
  final bool likes;
  final bool dislikes;
  final bool translation;

  CommunitiesCommentsResponse({
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

  factory CommunitiesCommentsResponse.fromJson(Map<String, dynamic> json) => CommunitiesCommentsResponse(
        id: json["_id"] ?? "",
        message: json["message"] ?? "",
        files: json["files"] == null ? [] : List<String>.from(json["files"].map((x) => x)),
        fileType: json["file_type"] ?? '',
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        billboardId: json["billboard_id"] ?? "",
        responseId: json["response_id"] ?? "",
        taggedUser: json["tagged_user"] == null ? [] : List<dynamic>.from(json["tagged_user"].map((x) => x)),
        users: CommunitiesUsers.fromJson(json["users"] ?? {}),
        billboardUser: json["billboard_user"] ?? "",
        responseUser: json["response_user"] ?? "",
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        updatedAt: json["updatedAt"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["updatedAt"]).millisecondsSinceEpoch),
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

class CommunitiesUsers {
  final String userId;
  final String username;
  final String avatar;
  final String profileType;
  final String tickerId;
  final int believersCount;

  CommunitiesUsers({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.profileType,
    required this.tickerId,
    required this.believersCount,
  });

  factory CommunitiesUsers.fromJson(Map<String, dynamic> json) => CommunitiesUsers(
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
