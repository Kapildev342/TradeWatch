import 'dart:convert';

RelatedFeatureModel relatedFeatureResponseModelFromJson(String str) => RelatedFeatureModel.fromJson(json.decode(str));

String relatedFeatureResponseModelToJson(RelatedFeatureModel data) => json.encode(data.toJson());

class RelatedFeatureModel {
  final bool status;
  final List<Response> response;
  final String message;

  RelatedFeatureModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory RelatedFeatureModel.fromJson(Map<String, dynamic> json) => RelatedFeatureModel(
        status: json["status"],
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class Response {
  final String id;
  final String title;
  final String description;
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
  final User user;

  Response({
    required this.id,
    required this.title,
    required this.description,
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
    required this.user,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        url: json["url"] ?? "",
        urlType: json["url_type"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? 0,
        category: json["category"] ?? "",
        disLikesCount: json["dis_likes_count"] ?? 0,
        dislikes: json["dislikes"] ?? false,
        likes: json["likes"] ?? false,
        likesCount: json["likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        createdAt: json["createdAt"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        user: User.fromJson(json["user"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
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
