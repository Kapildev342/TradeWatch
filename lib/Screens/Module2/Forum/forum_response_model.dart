// To parse this JSON data, do
//
//     final forumsResponseModel = forumsResponseModelFromJson(jsonString);

import 'dart:convert';

ForumsResponseModel forumsResponseModelFromJson(String str) => ForumsResponseModel.fromJson(json.decode(str));

String forumsResponseModelToJson(ForumsResponseModel data) => json.encode(data.toJson());

class ForumsResponseModel {
  final bool status;
  final Response response;
  final String message;
  final int postViewCounts;

  ForumsResponseModel({
    required this.status,
    required this.response,
    required this.message,
    required this.postViewCounts,
  });

  factory ForumsResponseModel.fromJson(Map<String, dynamic> json) => ForumsResponseModel(
    status: json["status"],
    response: Response.fromJson(json["response"]),
    message: json["message"],
    postViewCounts: json["post_view_counts"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
    "message": message,
    "post_view_counts": postViewCounts,
  };
}

class Response {
  final String id;
  final String title;
  final String category;
  final bool typeGeneral;
  final List<String> tickers;
  final String exchange;
  final String companyName;
  final String type;
  final int disLikesCount;
  final int likesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final String createdAt;
  final bool bookmark;
  final String url;
  final String description;
  final String urlType;
  final User user;
  final bool likes;
  final bool dislikes;
  final String country;
  final String sentiment;
  final List<Industry> industry;

  Response({
    required this.id,
    required this.title,
    required this.category,
    required this.typeGeneral,
    required this.tickers,
    required this.exchange,
    required this.companyName,
    required this.type,
    required this.disLikesCount,
    required this.likesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.createdAt,
    required this.bookmark,
    required this.description,
    required this.url,
    required this.urlType,
    required this.user,
    required this.likes,
    required this.dislikes,
    required this.country,
    required this.sentiment,
    required this.industry,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??"",
    title: json["title"]??'',
    category: json["category"]??"",
    typeGeneral: json["type_general"]??false,
    tickers: json["tickers"].isEmpty||json["tickers"]==null?[]:List<String>.from(json["tickers"].map((x) => x)),
    exchange: json["exchange"]??"",
    companyName: json["company_name"]??"",
    type: json["type"]??"",
    disLikesCount: json["dis_likes_count"]??0,
    likesCount: json["likes_count"]??0,
    viewsCount: json["views_count"]??0,
    shareCount: json["share_count"]??0,
    responseCount: json["response_count"]??0,
    createdAt: json["createdAt"]==null?"few seconds ago":readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
    bookmark: json["bookmark"]??false,
    description: json["description"]??"",
    url: json["url"]??"",
    urlType: json["url_type"]??"",
    user: User.fromJson(json["user"]??{}),
    likes: json["likes"]??false,
    dislikes: json["dislikes"]??false,
    country: json["country"]??"",
    sentiment: (json["sentiment"]??"").toLowerCase(),
    industry: json["industry"]==null?[]:List<Industry>.from(json["industry"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "category": category,
    "type_general": typeGeneral,
    "tickers": List<dynamic>.from(tickers.map((x) => x)),
    "exchange": exchange,
    "company_name": companyName,
    "type": type,
    "country": country,
    "sentiment": sentiment,
    "dis_likes_count": disLikesCount,
    "likes_count": likesCount,
    "views_count": viewsCount,
    "share_count": shareCount,
    "response_count": responseCount,
    "createdAt": createdAt,
    "bookmark": bookmark,
    "description": description,
    "url": url,
    "url_type": urlType,
    "user": user.toJson(),
    "likes": likes,
    "dislikes": dislikes,
    "industry": List<dynamic>.from(industry.map((x) => x)),
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

class Industry {
  final String id;
  final String name;

  Industry({
    required this.id,
    required this.name,
  });

  factory Industry.fromJson(Map<String, dynamic> json) => Industry(
    id: json["_id"]??"",
    name: json["name"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };
}

String readTimestampMain(int timestamp) {
  String time="";
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
    time = "few sec ago";
  }
  else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
    time = "${diff.inMinutes} min ago";
  }
  else if (diff.inHours >= 0 && diff.inHours <= 23) {
    time = time="${diff.inHours} hrs ago";
  }
  else if (diff.inDays >= 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day ago';
    } else {
      time = '${diff.inDays} days ago';
    }
  }
  else {
    if (diff.inDays >= 7 && diff.inDays <= 13) {
      time = '${(diff.inDays / 7).floor()} week ago';
    } else if (diff.inDays > 13 && diff.inDays <= 29) {
      time = '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays > 29 && diff.inDays <= 59) {
      time = '${(diff.inDays / 30).floor()} month ago';
    } else if (diff.inDays > 59 && diff.inDays <= 360) {
      time = '${(diff.inDays / 30).floor()} months ago';
    } else {
      time = "a year ago";
    }
  }
  return time;
}
