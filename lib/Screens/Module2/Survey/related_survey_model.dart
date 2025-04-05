import 'dart:convert';

RelatedSurveyModel relatedSurveyModelFromJson(String str) => RelatedSurveyModel.fromJson(json.decode(str));

String relatedSurveyModelToJson(RelatedSurveyModel data) => json.encode(data.toJson());

class RelatedSurveyModel {
  final bool status;
  final String message;
  final List<Response> response;

  RelatedSurveyModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory RelatedSurveyModel.fromJson(Map<String, dynamic> json) => RelatedSurveyModel(
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
  final String companyName;
  final String userId;
  final String exchange;
  final int viewsCount;
  final int shareCount;
  final int answersCount;
  final int questionCount;
  final String createdAt;
  final String avatar;
  final String username;
  final bool bookmark;
  final String sentiment;
  final String category;
  final String country;
  final List<Industry> industry;

  Response({
    required this.id,
    required this.title,
    required this.companyName,
    required this.userId,
    required this.exchange,
    required this.viewsCount,
    required this.shareCount,
    required this.answersCount,
    required this.questionCount,
    required this.createdAt,
    required this.avatar,
    required this.username,
    required this.bookmark,
    required this.sentiment,
    required this.category,
    required this.country,
    required this.industry,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        companyName: json["company_name"] ?? "",
        userId: json["user_id"] ?? "",
        exchange: json["exchange"] ?? "",
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        answersCount: json["answers_count"] ?? 0,
        questionCount: json["questions_count"] ?? 0,
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        avatar: json["avatar"] ?? "",
        username: json["username"] ?? "",
        bookmark: json["bookmark"] ?? false,
        sentiment: (json["sentiment"] ?? "").toLowerCase(),
        category: json["category"] ?? "",
        country: json["country"] ?? "",
        industry: json["industry"] == null ? [] : List<Industry>.from(json["industry"].map((x) => Industry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "company_name": companyName,
        "user_id": userId,
        "exchange": exchange,
        "views_count": viewsCount,
        "share_count": shareCount,
        "answers_count": answersCount,
        "questions_count": questionCount,
        "createdAt": createdAt,
        "avatar": avatar,
        "username": username,
        "bookmark": bookmark,
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
