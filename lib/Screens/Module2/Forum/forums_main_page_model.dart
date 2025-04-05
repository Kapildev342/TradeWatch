import 'dart:convert';

import '../../Module3/BookMarks/BookMarkOverAll/book_mark_over_view_model.dart';

ForumsMainPageModel forumsMainPageModelFromJson(String str) => ForumsMainPageModel.fromJson(json.decode(str));

String forumsMainPageModelToJson(ForumsMainPageModel data) => json.encode(data.toJson());

class ForumsMainPageModel {
  final bool status;
  final List<Response> response;
  final String type;
  final String message;

  ForumsMainPageModel({
    required this.status,
    required this.response,
    required this.type,
    required this.message,
  });

  factory ForumsMainPageModel.fromJson(Map<String, dynamic> json) => ForumsMainPageModel(
        status: json["status"] ?? false,
        response: json["response"] == null ? [] : List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
        type: json["type"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "type": type,
        "message": message,
      };
}

class Response {
  final String id;
  final String title;
  final String url;
  final String urlType;
  final String type;
  final int status;
  final String category;
  final int disLikesCount;
  final bool dislikes;
  final bool likes;
  final int likesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final String createdAt;
  final String companyName;
  final User user;
  final bool bookmark;
  final bool translation;
  final String description;

  Response({
    required this.id,
    required this.title,
    required this.url,
    required this.urlType,
    required this.type,
    required this.status,
    required this.category,
    required this.disLikesCount,
    required this.dislikes,
    required this.likes,
    required this.likesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.createdAt,
    required this.companyName,
    required this.user,
    required this.bookmark,
    required this.translation,
    required this.description,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        url: json["url"] ?? "",
        urlType: json["url_type"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? false,
        category: json["category"] ?? "",
        disLikesCount: json["dis_likes_count"] ?? 0,
        dislikes: json["dislikes"] ?? false,
        likes: json["likes"] ?? false,
        likesCount: json["likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        companyName: json["company_name"] ?? "",
        user: User.fromJson(json["user"] ?? {}),
        bookmark: json["bookmark"] ?? false,
        translation: json["translation"] ?? false,
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "url": url,
        "url_type": urlType,
        "type": type,
        "status": status,
        "category": category,
        "dis_likes_count": disLikesCount,
        "dislikes": dislikes,
        "likes": likes,
        "likes_count": likesCount,
        "views_count": viewsCount,
        "share_count": shareCount,
        "response_count": responseCount,
        "createdAt": createdAt,
        "company_name": companyName,
        "user": user.toJson(),
        "bookmark": bookmark,
        "translation": translation,
        "description": description,
      };
}

class User {
  final String id;
  final String username;
  final String avatar;
  final String profileType;
  final String tickerId;

  User({
    required this.id,
    required this.username,
    required this.avatar,
    required this.profileType,
    required this.tickerId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        profileType: json["profile_type"] ?? "",
        tickerId: json["ticker_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar": avatar,
        "profile_type": profileType,
        "ticker_id": tickerId,
      };
}
