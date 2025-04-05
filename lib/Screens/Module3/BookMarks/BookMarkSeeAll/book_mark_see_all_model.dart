import 'dart:convert';

BookMarkSeeAllModel bookMarkSeeAllModelFromJson(String str) => BookMarkSeeAllModel.fromJson(json.decode(str));

String bookMarkSeeAllModelToJson(BookMarkSeeAllModel data) => json.encode(data.toJson());

class BookMarkSeeAllModel {
  final bool status;
  final String message;
  final List<Response> response;

  BookMarkSeeAllModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BookMarkSeeAllModel.fromJson(Map<String, dynamic> json) => BookMarkSeeAllModel(
        status: json["status"],
        message: json["message"],
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  final String id;
  final String postId;
  final String title;
  final String exchange;
  final String newsUrl;
  final String imageUrl;
  final String sourceName;
  final String type;
  final String url;
  final String urlType;
  final String companyName;
  final int status;
  final String category;
  final int questionsCount;
  final int answerCount;
  final int disLikesCount;
  final int shareCount;
  final int responseCount;
  final bool dislikes;
  final bool likes;
  final int likesCount;
  final int viewsCount;
  final String date;
  final String createdAt;
  final bool bookmark;
  final String description;
  final String snippet;
  final List<Industry> industry;
  final String tickerId;
  final String country;
  final String sentiment;
  final User user;
  final String usernameOnlyUsers;
  final String firstnameOnlyUsers;
  final String lastnameOnlyUsers;
  final String avatarOnlyUsers;

  Response({
    required this.id,
    required this.postId,
    required this.title,
    required this.exchange,
    required this.newsUrl,
    required this.imageUrl,
    required this.sourceName,
    required this.type,
    required this.status,
    required this.category,
    required this.disLikesCount,
    required this.dislikes,
    required this.likes,
    required this.likesCount,
    required this.viewsCount,
    required this.date,
    required this.createdAt,
    required this.bookmark,
    required this.description,
    required this.snippet,
    required this.industry,
    required this.tickerId,
    required this.country,
    required this.sentiment,
    required this.url,
    required this.urlType,
    required this.companyName,
    required this.shareCount,
    required this.responseCount,
    required this.user,
    required this.questionsCount,
    required this.answerCount,
    required this.usernameOnlyUsers,
    required this.firstnameOnlyUsers,
    required this.lastnameOnlyUsers,
    required this.avatarOnlyUsers,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        postId: json["post_id"] ?? "",
        title: json["title"] ?? "",
        exchange: json["exchange"] ?? "",
        newsUrl: json["news_url"] ?? "",
        imageUrl: json["image_url"] ?? "",
        sourceName: json["source_name"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? 0,
        category: json["category"] ?? "",
        disLikesCount: json["dis_likes_count"] ?? 0,
        dislikes: json["dislikes"] ?? false,
        likes: json["likes"] ?? false,
        likesCount: json["likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        date: json["date"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["date"]).millisecondsSinceEpoch),
        createdAt: json["createdAt"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        bookmark: json["bookmark"] ?? false,
        description: json["description"] ?? "",
        snippet: json["snippet"] ?? "",
        industry: json["industry"] == null ? [] : List<Industry>.from(json["industry"].map((x) => Industry.fromJson(x))),
        tickerId: json["ticker_id"] ?? "",
        country: json["country"] ?? "",
        sentiment: (json["sentiment"] ?? "").toLowerCase(),
        url: json["url"] ?? "",
        urlType: json["url_type"] ?? "",
        user: User.fromJson(json["user"] ?? {}),
        companyName: json["company_name"] ?? "",
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        questionsCount: json["questions_count"] ?? 0,
        answerCount: json["answers_count"] ?? 0,
        usernameOnlyUsers: json["username"] ?? "",
        firstnameOnlyUsers: json["first_name"] ?? "",
        lastnameOnlyUsers: json["last_name"] ?? "",
        avatarOnlyUsers: json["avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "post_id": postId,
        "title": title,
        "exchange": exchange,
        "news_url": newsUrl,
        "image_url": imageUrl,
        "url": url,
        "url_type": urlType,
        "user": user.toJson(),
        "company_name": companyName,
        "share_count": shareCount,
        "response_count": responseCount,
        "source_name": sourceName,
        "type": type,
        "status": status,
        "category": category,
        "dis_likes_count": disLikesCount,
        "answers_count": answerCount,
        "questions_count": questionsCount,
        "dislikes": dislikes,
        "likes": likes,
        "likes_count": likesCount,
        "views_count": viewsCount,
        "date": date,
        "createdAt": createdAt,
        "bookmark": bookmark,
        "description": description,
        "snippet": snippet,
        "industry": List<dynamic>.from(industry.map((x) => x.toJson())),
        "ticker_id": tickerId,
        "country": country,
        "sentiment": sentiment,
        "username": usernameOnlyUsers,
        "first_name": firstnameOnlyUsers,
        "last_name": lastnameOnlyUsers,
        "avatar": avatarOnlyUsers,
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
