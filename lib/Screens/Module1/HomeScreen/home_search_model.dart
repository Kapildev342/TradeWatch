
import 'dart:convert';

HomeSearchModel homeSearchModelFromJson(String str) => HomeSearchModel.fromJson(json.decode(str));

String homeSearchModelToJson(HomeSearchModel data) => json.encode(data.toJson());

class HomeSearchModel {
  final bool status;
  final List<HomeSearchResponse> response;
  final String search;
  final String message;

  HomeSearchModel({
    required this.status,
    required this.response,
    required this.search,
    required this.message,
  });

  factory HomeSearchModel.fromJson(Map<String, dynamic> json) => HomeSearchModel(
    status: json["status"]??false,
    response: json["response"]==null?[]:List<HomeSearchResponse>.from(json["response"].map((x) => HomeSearchResponse.fromJson(x))),
    search: json["search"]??"",
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "search": search,
    "message": message,
  };
}

class HomeSearchResponse {
  final String id;
  final String title;
  final String newsUrl;
  final String imageUrl;
  final String type;
  final User user;

  HomeSearchResponse({
    required this.id,
    required this.title,
    required this.newsUrl,
    required this.imageUrl,
    required this.type,
    required this.user,
  });

  factory HomeSearchResponse.fromJson(Map<String, dynamic> json) => HomeSearchResponse(
    id: json["_id"]??"",
    title: json["title"]??"",
    newsUrl: json["news_url"]??"",
    imageUrl: json["image_url"]??"",
    type: json["type"]??"",
    user: User.fromJson(json["user"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "news_url": newsUrl,
    "image_url": imageUrl,
    "type": type,
    "user": user.toJson(),
  };
}

class User {
  final String id;
  final String username;
  final String avatar;

  User({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"]??"",
    username: json["username"]??"",
    avatar: json["avatar"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "avatar": avatar,
  };
}
