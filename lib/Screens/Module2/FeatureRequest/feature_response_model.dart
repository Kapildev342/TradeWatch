import 'dart:convert';

FeatureResponseModel featureResponseModelFromJson(String str) => FeatureResponseModel.fromJson(json.decode(str));

String featureResponseModelToJson(FeatureResponseModel data) => json.encode(data.toJson());

class FeatureResponseModel {
  final bool status;
  final Response response;
  final String message;

  FeatureResponseModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory FeatureResponseModel.fromJson(Map<String, dynamic> json) => FeatureResponseModel(
        status: json["status"],
        response: Response.fromJson(json["response"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
        "message": message,
      };
}

class Response {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool typeGeneral;
  final String type;
  final int disLikesCount;
  final int likesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final String createdAt;
  final List<dynamic> tickers;
  final String url;
  final bool bookmark;
  final String urlType;
  final User user;
  final bool likes;
  final bool dislikes;

  Response({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.typeGeneral,
    required this.type,
    required this.disLikesCount,
    required this.likesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.createdAt,
    required this.tickers,
    required this.url,
    required this.bookmark,
    required this.urlType,
    required this.user,
    required this.likes,
    required this.dislikes,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        typeGeneral: json["type_general"] ?? false,
        type: json["type"] ?? "",
        disLikesCount: json["dis_likes_count"] ?? 0,
        likesCount: json["likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        createdAt: json["createdAt"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        tickers: json["tickers"].isEmpty || json["tickers"] == null ? [] : List<dynamic>.from(json["tickers"].map((x) => x)),
        url: json["url"] ?? "",
        bookmark: json["bookmark"] ?? false,
        urlType: json["url_type"] ?? "",
        user: User.fromJson(json["user"] ?? {}),
        likes: json["likes"] ?? false,
        dislikes: json["dislikes"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "category": category,
        "type_general": typeGeneral,
        "type": type,
        "dis_likes_count": disLikesCount,
        "likes_count": likesCount,
        "views_count": viewsCount,
        "share_count": shareCount,
        "response_count": responseCount,
        "createdAt": createdAt,
        "tickers": List<dynamic>.from(tickers.map((x) => x)),
        "url": url,
        "bookmark": bookmark,
        "url_type": urlType,
        "user": user.toJson(),
        "likes": likes,
        "dislikes": dislikes,
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
        id: json["_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar": avatar,
      };
}

String readTimestampMain(int timestamp) {
  String time = "";
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
    time = "few sec ago";
  } else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
    time = "${diff.inMinutes} min ago";
  } else if (diff.inHours >= 0 && diff.inHours <= 23) {
    time = time = "${diff.inHours} hrs ago";
  } else if (diff.inDays >= 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day ago';
    } else {
      time = '${diff.inDays} days ago';
    }
  } else {
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
