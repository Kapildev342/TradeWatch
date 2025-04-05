import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

BillboardMainModel billboardMainModelFromJson(String str) => BillboardMainModel.fromJson(json.decode(str));

String billboardMainModelToJson(BillboardMainModel data) => json.encode(data.toJson());

class BillboardMainModel {
  final bool status;
  final String message;
  final List<BillboardMainModelResponse> response;
  final int newCounts;

  BillboardMainModel({
    required this.status,
    required this.message,
    required this.response,
    required this.newCounts,
  });

  factory BillboardMainModel.fromJson(Map<String, dynamic> json) {
    return BillboardMainModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      response: json["response"] == null
          ? []
          : List<BillboardMainModelResponse>.from(json["response"].map((x) => BillboardMainModelResponse.fromJson(x))),
      newCounts: json["new_counts"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "new_counts": newCounts,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class BillboardMainModelResponse {
  final String id;
  String title;
  final String content;
  final List<Files> files;
  final String billboardType;
  final String type;
  final String category;
  final String exchange;
  final int status;
  int likesCount;
  int disLikesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final String skipName;
  final String companyName;
  bool like;
  bool dislike;
  final String tickerId;
  final String userId;
  final String username;
  final String avatar;
  final String profileType;
  RxBool bookmarks;
  bool translation;
  bool believed;
  int believersCount;
  final String createdAt;
  final String dateTime;
  final String newsImage;
  final String country;
  final String description;
  final String publicView;
  final String postId;
  final String postType;
  bool repostBelieved;
  final String repostId;
  final String repostAvatar;
  final String repostUser;
  final String repostUserName;
  final int repostCount;
  final String repostType; // original post public or private
  final String repostProfileType; // original post user whether user,intermiary or business
  final int repostStatus;
  final List<Industry> industry;

  BillboardMainModelResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.files,
    required this.billboardType,
    required this.type,
    required this.category,
    required this.exchange,
    required this.status,
    required this.likesCount,
    required this.disLikesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.skipName,
    required this.companyName,
    required this.like,
    required this.dislike,
    required this.tickerId,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.profileType,
    required this.bookmarks,
    required this.translation,
    required this.believed,
    required this.believersCount,
    required this.createdAt,
    required this.dateTime,
    required this.newsImage,
    required this.country,
    required this.description,
    required this.publicView,
    required this.postId,
    required this.postType,
    required this.repostId,
    required this.repostBelieved,
    required this.repostAvatar,
    required this.repostUser,
    required this.repostUserName,
    required this.repostCount,
    required this.repostType,
    required this.repostProfileType,
    required this.repostStatus,
    required this.industry,
  });

  factory BillboardMainModelResponse.fromJson(Map<String, dynamic> json) => BillboardMainModelResponse(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        content: json["content"] ?? "",
        files: json["files"] == null ? [] : List<Files>.from(json["files"].map((x) => Files.fromJson(x))),
        category: json["category"] ?? "",
        billboardType: json["billboard_type"] ?? "",
        type: json["type"] ?? "",
        exchange: json["exchange"] ?? "",
        status: json["status"] ?? 0,
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        skipName: json["skip_name"] ?? "",
        companyName: json["company_name"] ?? "",
        like: json["like"] ?? false,
        dislike: json["dislike"] ?? false,
        tickerId: json["ticker_id"] ?? "",
        userId: json["user_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        profileType: json["profile_type"] ?? "",
        bookmarks: ((json["bookmarks"] ?? false) as bool).obs,
        translation: json["translation"] ?? false,
        believed: json["believed"] ?? false,
        believersCount: json["believers_count"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : billBoardFunctionsMain.readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        dateTime: json["createdAt"] ?? DateTime.now(),
        newsImage: json['image_url'] ?? "",
        country: json["country"] ?? "",
        description: json["description"] ?? "",
        publicView: json["public_view"] ?? "",
        postId: json["post_id"] ?? "",
        postType: json["post_type"] ?? "",
        repostBelieved: json["repost_believed"] ?? false,
        repostAvatar: json["repost_avatar"] ?? "",
        repostId: json["repost_id"] ?? "",
        repostUser: json["repost_user"] ?? "",
        repostUserName: json["repost_username"] ?? "",
        repostCount: json["reposted_count"] ?? 0,
        repostType: json["repost_type"] ?? "",
        repostProfileType: json["repost_profile_type"] ?? "",
        repostStatus: json["repost_status"] ?? 0,
        industry: json["industry"] == null ? [] : List<Industry>.from(json["industry"].map((x) => Industry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "files": List<dynamic>.from(files.map((x) => x)),
        "billboard_type": billboardType,
        "type": type,
        "category": category,
        "exchange": exchange,
        "status": status,
        "likes_count": likesCount,
        "dis_likes_count": disLikesCount,
        "views_count": viewsCount,
        "share_count": shareCount,
        "response_count": responseCount,
        "company_name": companyName,
        "skip_name": skipName,
        "like": like,
        "dislike": dislike,
        "username": username,
        "ticker_id": tickerId,
        "user_id": userId,
        "avatar": avatar,
        "profile_type": profileType,
        "bookmarks": bookmarks,
        "translation": translation,
        "believed": believed,
        "believers_count": believersCount,
        "createdAt": createdAt,
        "image_url": newsImage,
        "country": country,
        "description": description,
        "public_view": publicView,
        "post_id": postId,
        "post_type": postType,
        "repost_believed": repostBelieved,
        "repost_avatar": repostAvatar,
        "repost_id": repostId,
        "repost_user": repostUser,
        "repost_username": repostUserName,
        "reposted_count": repostCount,
        "repost_type": repostType,
        "repost_profile_type": repostProfileType,
        "repost_status": repostStatus,
        "industry": industry,
      };
}

class Industry {
  final String id;
  final String name;
  final String categoryId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String category;

  Industry({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory Industry.fromJson(Map<String, dynamic> json) => Industry(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        categoryId: json["category_id"] ?? "",
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        category: json["category"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category_id": categoryId,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "category": category,
      };
}

class Files {
  final String file;
  final String type;

  Files({
    required this.file,
    required this.type,
  });

  factory Files.fromJson(Map<String, dynamic> json) => Files(
        file: json["file"] ?? "",
        type: json["file_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "file_type": type,
      };
}
