import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Module2/FeatureRequest/feature_response_model.dart';
import 'communities_list_page_model.dart';

CommunitiesCommentsInitialModel communitiesCommentsInitialModelFromJson(String str) => CommunitiesCommentsInitialModel.fromJson(json.decode(str));

String communitiesCommentsInitialModelToJson(CommunitiesCommentsInitialModel data) => json.encode(data.toJson());

class CommunitiesCommentsInitialModel {
  final Rx<bool> status;
  final Rx<String> message;
  final RxList<CommunitiesCommentsResponse> response;

  CommunitiesCommentsInitialModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesCommentsInitialModel.fromJson(Map<String, dynamic> json) => CommunitiesCommentsInitialModel(
        status: ((json["status"] ?? false) as bool).obs,
        message: (json["message"] ?? "").toString().obs,
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
  final Rx<String> postedTime;
  final Rx<int> believedCount;
  final Rx<int> believersCount;
  final Rx<bool> believed;
  final Rx<bool> likes;
  final Rx<bool> dislikes;
  final Rx<bool> isEditing;
  final Rx<TextEditingController> commentsController;

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
    required this.postedTime,
    required this.believedCount,
    required this.believersCount,
    required this.believed,
    required this.likes,
    required this.dislikes,
    required this.isEditing,
    required this.commentsController,
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
        postedTime: (json["post_date"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["post_date"]).millisecondsSinceEpoch)).obs,
        believedCount: int.parse("${json["believed_count"] ?? 0}").obs,
        believersCount: int.parse("${json["believers_count"] ?? 0}").obs,
        believed: ((json["believed"] ?? false) as bool).obs,
        likes: ((json["likes"] ?? false) as bool).obs,
        dislikes: ((json["dislikes"] ?? false) as bool).obs,
        isEditing: ((json["is_editing"] ?? false) as bool).obs,
        commentsController: ((json["comments_controller"] ?? TextEditingController()) as TextEditingController).obs,
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
        "post_time": postedTime,
        "believed_count": believedCount,
        "believers_count": believersCount,
        "believed": believed,
        "likes": likes,
        "dislikes": dislikes,
        "isEditing": isEditing,
        "comments_controller": commentsController,
      };
}
