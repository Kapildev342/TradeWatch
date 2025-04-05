import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_list_page_model.dart';

CommunitiesDescriptionResponseListModel communitiesDescriptionResponseListModelFromJson(String str) =>
    CommunitiesDescriptionResponseListModel.fromJson(json.decode(str));

String communitiesDescriptionResponseListModelToJson(CommunitiesDescriptionResponseListModel data) => json.encode(data.toJson());

class CommunitiesDescriptionResponseListModel {
  final RxList<CommunitiesPostsResponsesList> responsesList;

  CommunitiesDescriptionResponseListModel({
    required this.responsesList,
  });

  factory CommunitiesDescriptionResponseListModel.fromJson(Map<String, dynamic> json) => CommunitiesDescriptionResponseListModel(
        responsesList:
            RxList<CommunitiesPostsResponsesList>.from((json["responses_list"] ?? []).map((x) => CommunitiesPostsResponsesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responses_list": List<dynamic>.from(responsesList.map((x) => x.toJson())),
      };
}

class CommunitiesPostsResponsesList {
  final RxString id;
  final Rx<int> likesCount;
  final Rx<int> dislikesCount;
  final Rx<int> responseCount;
  final RxList<CommunityFileElement> files;
  final RxString message;
  final RxString username;
  final RxString userId;
  final RxString profileType;
  final RxString createdAt;
  final Rx<bool> believed;
  final RxString firstName;
  final RxString lastName;
  final RxString avatar;
  final Rx<int> believedCount;
  final Rx<int> believersCount;
  final Rx<bool> likes;
  final Rx<bool> translation;
  final Rx<bool> dislikes;
  final Rx<bool> isEditing;
  Rx<TextEditingController> responseController;

  CommunitiesPostsResponsesList({
    required this.id,
    required this.userId,
    required this.likesCount,
    required this.dislikesCount,
    required this.responseCount,
    required this.files,
    required this.message,
    required this.username,
    required this.profileType,
    required this.createdAt,
    required this.believed,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.believedCount,
    required this.believersCount,
    required this.likes,
    required this.translation,
    required this.dislikes,
    required this.isEditing,
    required this.responseController,
  });

  factory CommunitiesPostsResponsesList.fromJson(Map<String, dynamic> json) => CommunitiesPostsResponsesList(
        id: (json["_id"] ?? "").toString().obs,
        userId: (json["user_id"] ?? "").toString().obs,
        likesCount: int.parse("${json["likes_count"] ?? 0}").obs,
        dislikesCount: int.parse("${json["dislikes_count"] ?? 0}").obs,
        responseCount: int.parse("${json["response_count"] ?? 0}").obs,
        files: RxList<CommunityFileElement>.from((json["files"] ?? "").map((x) => CommunityFileElement.fromJson(x))),
        message: (json["message"] ?? "").toString().obs,
        username: (json["username"] ?? "").toString().obs,
        profileType: (json["profile_type"] ?? "").toString().obs,
        createdAt: (DateFormat('yyyy-MM-dd hh:mm a', 'en_US')
                .format((json["createdAt"] != null ? DateTime.parse(json["post_date"]) : DateTime.now()).toLocal().toLocal()))
            .obs,
        firstName: (json["first_name"] ?? "").toString().obs,
        lastName: (json["last_name"] ?? "").toString().obs,
        avatar: (json["avatar"] ?? "").toString().obs,
        believedCount: int.parse("${json["believed_count"] ?? 0}").obs,
        believersCount: int.parse("${json["believers_count"] ?? 0}").obs,
        likes: ((json["likes"] ?? false) as bool).obs,
        believed: ((json["believed"] ?? false) as bool).obs,
        translation: ((json["translation"] ?? false) as bool).obs,
        dislikes: ((json["dislikes"] ?? false) as bool).obs,
        isEditing: ((json["is_editing"] ?? false) as bool).obs,
        responseController: ((json["response_controller"] ?? TextEditingController()) as TextEditingController).obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "likes_count": likesCount,
        "dislikes_count": dislikesCount,
        "response_count": responseCount,
        "files": List<dynamic>.from(files.map((x) => x)),
        "message": message,
        "username": username,
        "profile_type": profileType,
        "createdAt": createdAt,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "believed_count": believedCount,
        "believers_count": believersCount,
        "likes": likes,
        "believed": believed,
        "translation": translation,
        "dislikes": dislikes,
        "is_editing": isEditing,
        "response_controller": responseController,
      };
}
