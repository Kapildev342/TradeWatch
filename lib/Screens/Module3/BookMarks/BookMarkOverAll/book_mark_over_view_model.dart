import 'dart:convert';

import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';

BookMarkOverviewModel bookMarkOverviewModelFromJson(String str) => BookMarkOverviewModel.fromJson(json.decode(str));

String bookMarkOverviewModelToJson(BookMarkOverviewModel data) => json.encode(data.toJson());

class BookMarkOverviewModel {
  final bool status;
  final String message;
  final List<Response> response;

  BookMarkOverviewModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BookMarkOverviewModel.fromJson(Map<String, dynamic> json) => BookMarkOverviewModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: json["response"] == null ? [] : List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  final List<News> news;
  final List<News> videos;
  final List<Forum> forums;
  final List<Survey> survey;
  final List<UserElement> users;
  final List<BillboardMainModelResponse> billBoard;

  Response({
    required this.news,
    required this.videos,
    required this.forums,
    required this.survey,
    required this.users,
    required this.billBoard,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        news: json["news"] == null ? [] : List<News>.from(json["news"].map((x) => News.fromJson(x))),
        videos: json["videos"] == null ? [] : List<News>.from(json["videos"].map((x) => News.fromJson(x))),
        forums: json["forums"] == null ? [] : List<Forum>.from(json["forums"].map((x) => Forum.fromJson(x))),
        survey: json["survey"] == null ? [] : List<Survey>.from(json["survey"].map((x) => Survey.fromJson(x))),
        users: json["users"] == null ? [] : List<UserElement>.from(json["users"].map((x) => UserElement.fromJson(x))),
        billBoard: json["billboard"] == null
            ? []
            : List<BillboardMainModelResponse>.from(json["billboard"].map((x) => BillboardMainModelResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "news": List<dynamic>.from(news.map((x) => x.toJson())),
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
        "forums": List<dynamic>.from(forums.map((x) => x.toJson())),
        "survey": List<dynamic>.from(survey.map((x) => x.toJson())),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "billboard": List<dynamic>.from(billBoard.map((x) => x.toJson())),
      };
}

class Forum {
  final String id;
  final String title;
  final String url;
  final String urlType;
  final String type;
  final int status;
  final String category;
  int disLikesCount;
  bool dislikes;
  bool likes;
  int likesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final String createdAt;
  final String companyName;
  final UsersClass user;
  bool bookmark;
  final String description;
  final String sentiment;
  final String postId;

  Forum({
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
    required this.description,
    required this.sentiment,
    required this.postId,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
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
        companyName: json["company_name"] ?? "",
        user: UsersClass.fromJson(json["user"] ?? {}),
        bookmark: json["bookmark"] ?? false,
        description: json["description"] ?? "",
        postId: json["post_id"] ?? "",
        sentiment: (json["sentiment"] ?? "").toLowerCase(),
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
        "description": description,
        "sentiment": sentiment,
        "post_id": postId,
      };
}

class UsersClass {
  final String id;
  final String username;
  final String avatar;

  UsersClass({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory UsersClass.fromJson(Map<String, dynamic> json) => UsersClass(
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

class News {
  final String id;
  final String title;
  final String exchange;
  final String newsUrl;
  final String imageUrl;
  final String sourceName;
  final String type;
  final int status;
  final String category;
  int disLikesCount;
  bool dislikes;
  bool likes;
  int likesCount;
  final int viewsCount;
  final String date;
  final String createdAt;
  bool bookmark;
  final String description;
  final String snippet;
  final List<Industry> industry;
  final String tickerId;
  final String country;
  final String sentiment;
  final String postId;
  final String labelExchange;

  News({
    required this.id,
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
    required this.postId,
    required this.labelExchange,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["_id"] ?? "",
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
        postId: json["post_id"] ?? "",
        labelExchange: findExactExchange(
            category: json["category"] ?? "",
            exchange: json["exchange"] ?? "",
            industry: json["industry"] == null ? [] : List<Industry>.from(json["industry"].map((x) => Industry.fromJson(x))),
            country: json["country"] ?? ""),
        sentiment: (json["sentiment"] ?? "").toLowerCase(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "exchange": exchange,
        "news_url": newsUrl,
        "image_url": imageUrl,
        "source_name": sourceName,
        "type": type,
        "status": status,
        "category": category,
        "dis_likes_count": disLikesCount,
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
        "post_id": postId,
        "sentiment": sentiment,
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

class Survey {
  final String id;
  final String surveyId;
  final String category;
  final String type;
  final String title;
  final int questionsCount;
  final int status;
  final String companyName;
  final int viewsCount;
  final int answersCount;
  final String createdAt;
  final UsersClass users;
  bool bookmark;
  final String sentiment;
  final String postId;

  Survey({
    required this.id,
    required this.surveyId,
    required this.category,
    required this.type,
    required this.title,
    required this.questionsCount,
    required this.status,
    required this.companyName,
    required this.viewsCount,
    required this.answersCount,
    required this.createdAt,
    required this.users,
    required this.bookmark,
    required this.sentiment,
    required this.postId,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        id: json["_id"] ?? "",
        surveyId: json["survey_id"] ?? "",
        category: json["category"] ?? "",
        type: json["type"] ?? "",
        title: json["title"] ?? "",
        questionsCount: json["questions_count"] ?? 0,
        status: json["status"] ?? 0,
        companyName: json["company_name"] ?? "",
        viewsCount: json["views_count"] ?? 0,
        answersCount: json["answers_count"] ?? 0,
        createdAt: json["createdAt"] == null ? "few seconds ago" : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        users: UsersClass.fromJson(json["users"] ?? {}),
        bookmark: json["bookmark"] ?? false,
        postId: json["post_id"] ?? "",
        sentiment: (json["sentiment"] ?? "").toLowerCase(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "survey_id": surveyId,
        "category": category,
        "type": type,
        "title": title,
        "questions_count": questionsCount,
        "status": status,
        "company_name": companyName,
        "views_count": viewsCount,
        "answers_count": answersCount,
        "createdAt": createdAt,
        "users": users.toJson(),
        "bookmark": bookmark,
        "sentiment": sentiment,
        "post_id": postId,
      };
}

class UserElement {
  final String id;
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String avatar;
  final bool bookmark;
  final String postId;

  UserElement({
    required this.id,
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.bookmark,
    required this.postId,
  });

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
        id: json["_id"] ?? "",
        userId: json["user_id"] ?? "",
        username: json["username"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        avatar: json["avatar"] ?? "",
        postId: json["post_id"] ?? "",
        bookmark: json["bookmark"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "bookmark": bookmark,
        "post_id": postId,
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

String findExactExchange({
  required String category,
  required String exchange,
  required List<Industry> industry,
  required String country,
}) {
  if (category.toLowerCase() == 'stocks') {
    if (exchange == "NSE" || exchange == "BSE" || exchange == "INDX") {
      return exchange.toLowerCase();
    } else if (exchange == "") {
      return "";
    } else {
      return "usastocks";
    }
  } else if (category.toLowerCase() == 'crypto') {
    return industry.isEmpty ? "coin" : industry[0].name;
  } else if (category.toLowerCase() == 'commodity') {
    return country.toLowerCase();
  } else {
    return "inrusd";
  }
}
