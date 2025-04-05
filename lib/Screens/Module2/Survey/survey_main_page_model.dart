import 'dart:convert';

import '../../Module3/BookMarks/BookMarkOverAll/book_mark_over_view_model.dart';

SurveyMainPageModel surveyMainPageModelFromJson(String str) => SurveyMainPageModel.fromJson(json.decode(str));

String surveyMainPageModelToJson(SurveyMainPageModel data) => json.encode(data.toJson());

class SurveyMainPageModel {
  final bool status;
  final List<Response> response;
  final String type;
  final String message;

  SurveyMainPageModel({
    required this.status,
    required this.response,
    required this.type,
    required this.message,
  });

  factory SurveyMainPageModel.fromJson(Map<String, dynamic> json) => SurveyMainPageModel(
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
  final String category;
  final String companyName;
  final String type;
  final int viewsCount;
  final int likesCount;
  final int disLikesCount;
  final int answersCount;
  final int questionsCount;
  final int status;
  final String createdAt;
  final User user;
  final bool bookmark;
  final bool likes;
  final bool dislikes;
  final bool translation;

  Response({
    required this.id,
    required this.title,
    required this.category,
    required this.companyName,
    required this.type,
    required this.viewsCount,
    required this.likesCount,
    required this.disLikesCount,
    required this.answersCount,
    required this.questionsCount,
    required this.status,
    required this.createdAt,
    required this.user,
    required this.bookmark,
    required this.likes,
    required this.dislikes,
    required this.translation,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        category: json["category"] ?? "",
        companyName: json["company_name"] ?? "",
        type: json["type"] ?? "",
        viewsCount: json["views_count"] ?? 0,
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        answersCount: json["answers_count"] ?? 0,
        questionsCount: json["questions_count"] ?? 0,
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        user: User.fromJson(json["user"] ?? {}),
        bookmark: json["bookmark"] ?? false,
        likes: json["likes"] ?? false,
        dislikes: json["dislikes"] ?? false,
        translation: json["translation"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "category": category,
        "company_name": companyName,
        "type": type,
        "views_count": viewsCount,
        "likes_count": likesCount,
        "dis_likes_count": disLikesCount,
        "answers_count": answersCount,
        "questions_count": questionsCount,
        "status": status,
        "createdAt": createdAt,
        "user": user.toJson(),
        "bookmark": bookmark,
        "likes": likes,
        "dislikes": dislikes,
        "translation": translation,
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
