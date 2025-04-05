import 'dart:convert';

RelatedForumsModel relatedForumsModelFromJson(String str) => RelatedForumsModel.fromJson(json.decode(str));

String relatedForumsModelToJson(RelatedForumsModel data) => json.encode(data.toJson());

class RelatedForumsModel {
  final bool status;
  final String message;
  final List<Response> response;

  RelatedForumsModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory RelatedForumsModel.fromJson(Map<String, dynamic> json) => RelatedForumsModel(
        status: json["status"],
        message: json["message"],
        response: json["response"] == null || json["response"].isEmpty
            ? []
            : List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  final String id;
  final String title;
  final String url;
  final String urlType;
  final String companyName;
  final String exchange;
  final String userId;
  final String avatar;
  final String userName;
  final int likesCount;
  final int disLikesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final String createdAt;
  final bool bookmark;
  final bool likes;
  final bool dislikes;
  final String sentiment;
  final String category;
  final String country;
  final List<Industry> industry;

  Response({
    required this.id,
    required this.title,
    required this.url,
    required this.urlType,
    required this.companyName,
    required this.exchange,
    required this.userId,
    required this.avatar,
    required this.userName,
    required this.likesCount,
    required this.disLikesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.createdAt,
    required this.bookmark,
    required this.likes,
    required this.dislikes,
    required this.sentiment,
    required this.category,
    required this.country,
    required this.industry,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? '',
        url: json["url"] ?? "",
        urlType: json["url_type"] ?? "",
        companyName: json["company_name"] ?? "",
        exchange: json["exchange"] ?? "",
        userId: json["user_id"] ?? "",
        userName: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        bookmark: json["bookmark"] ?? false,
        likes: json["likes"] ?? false,
        dislikes: json["dislikes"] ?? false,
        sentiment: (json["sentiment"] ?? "").toLowerCase(),
        category: json["category"] ?? "",
        country: json["country"] ?? "",
        industry: json["industry"] == null ? [] : List<Industry>.from(json["industry"].map((x) => Industry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "url": url,
        "url_type": urlType,
        "company_name": companyName,
        "exchange": exchange,
        "user_id": exchange,
        "username": exchange,
        "avatar": exchange,
        "likes_count": likesCount,
        "dis_likes_count": disLikesCount,
        "views_count": viewsCount,
        "share_count": shareCount,
        "response_count": responseCount,
        "createdAt": createdAt,
        "bookmark": bookmark,
        "likes": likes,
        "dislikes": dislikes,
        "sentiment": sentiment,
        "category": category,
        "country": country,
        "industry": List<dynamic>.from(industry.map((x) => x.toJson())),
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
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
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
