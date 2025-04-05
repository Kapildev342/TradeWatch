
import 'dart:convert';

import 'package:intl/intl.dart';

UserProfileDataModel userProfileDataModelFromJson(String str) => UserProfileDataModel.fromJson(json.decode(str));

String userProfileDataModelToJson(UserProfileDataModel data) => json.encode(data.toJson());

class UserProfileDataModel {
  final bool status;
  final String message;
  final Response response;

  UserProfileDataModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory UserProfileDataModel.fromJson(Map<String, dynamic> json) => UserProfileDataModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: Response.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
  };
}

class Response {
  final String firstName;
  final String lastName;
  final String username;
  final int postCount;
  final int reportCount;
  int believersCount;
  final int believedCount;
  final String profileType;
  final int usersView;
  final String about;
  final String avatar;
  final String coverImage;
  final String thumbnail;
  final String id;
  bool believed;
  final bool onlineActive;
  bool bookmark;
  final String onlineDate;

  Response({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.postCount,
    required this.reportCount,
    required this.believersCount,
    required this.believedCount,
    required this.profileType,
    required this.usersView,
    required this.about,
    required this.avatar,
    required this.coverImage,
    required this.thumbnail,
    required this.id,
    required this.believed,
    required this.onlineActive,
    required this.onlineDate,
    required this.bookmark,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    username: json["username"]??"",
    postCount: json["post_count"]??0,
    reportCount: json["report_count"]??0,
    believersCount: json["believers_count"]??0,
    believedCount: json["believed_count"]??0,
    profileType: json["profile_type"]??"",
    usersView: json["users_view"]??0,
    about: json["about"]??"",
    avatar: json["avatar"]??"",
    coverImage: json["cover_image"]??"",
    thumbnail: json["thumbnail"]??"",
    id: json["_id"]??"",
    believed: json["believed"]??false,
    onlineActive: json["online_active"]??false,
    bookmark: json["bookmark"]??false,
    onlineDate: DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format((json["online_date"]!=null?DateTime.parse(json["online_date"]):DateTime.now()).toLocal().toLocal()),
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "post_count": postCount,
    "report_count": reportCount,
    "believers_count": believersCount,
    "believed_count": believedCount,
    "profile_type": profileType,
    "users_view": usersView,
    "about": about,
    "avatar": avatar,
    "cover_image": coverImage,
    "thumbnail": thumbnail,
    "_id": id,
    "believed": believed,
    "online_active": onlineActive,
    "bookmark": bookmark,
    "online_date": onlineDate,
  };
}
