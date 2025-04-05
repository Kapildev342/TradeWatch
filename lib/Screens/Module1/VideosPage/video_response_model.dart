// To parse this JSON data, do
//
//     final videosResponseModel = videosResponseModelFromJson(jsonString);

import 'dart:convert';

VideosResponseModel videosResponseModelFromJson(String str) => VideosResponseModel.fromJson(json.decode(str));

String videosResponseModelToJson(VideosResponseModel data) => json.encode(data.toJson());

class VideosResponseModel {
  final bool status;
  final Response response;
  final String message;

  VideosResponseModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory VideosResponseModel.fromJson(Map<String, dynamic> json) => VideosResponseModel(
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
  final String exchange;
  final String newsUrl;
  final String imageUrl;
  final String sourceName;
  final String type;
  final int status;
  final String category;
  final int disLikesCount;
  final bool dislikes;
  final bool likes;
  final int likesCount;
  final int viewsCount;
  final String tickerId;
  final String date;
  final String createdAt;
  final bool bookmark;
  final List<String> tickers;
  final int shareCount;
  final String country;
  final String sentiment;
  final List<Industry> industry;


  Response({
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
    required this.tickerId,
    required this.date,
    required this.createdAt,
    required this.bookmark,
    required this.tickers,
    required this.shareCount,
    required this.country,
    required this.sentiment,
    required this.industry,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??'',
    title: json["title"]??'',
    exchange: json["exchange"]??"",
    newsUrl: json["news_url"]??"",
    imageUrl: json["image_url"]??"",
    sourceName: json["source_name"]??"",
    country: json["country"]??"",
    sentiment: (json["sentiment"]??"").toLowerCase(),
    type: json["type"]??"",
    status: json["status"]??0,
    category: json["category"]??"",
    disLikesCount: json["dis_likes_count"]??0,
    dislikes: json["dislikes"]??false,
    likes: json["likes"]??false,
    likesCount: json["likes_count"]??0,
    viewsCount: json["views_count"]??0,
    shareCount: json["share_count"]??0,
    tickerId: json["ticker_id"]??"",
    date: json["date"]==null?"few seconds ago":readTimestampMain(DateTime.parse(json["date"]).millisecondsSinceEpoch),
    createdAt: json["createdAt"]==null?"few seconds ago":readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
    bookmark: json["bookmark"]??false,
    tickers: json["tickers"]==null?[]:List<String>.from(json["tickers"].map((x) => x)),
    industry: json["industry"]==null?[]:List<Industry>.from(json["industry"].map((x) => x)),
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
    "country": country,
    "sentiment": sentiment,
    "dis_likes_count": disLikesCount,
    "dislikes": dislikes,
    "likes": likes,
    "likes_count": likesCount,
    "views_count": viewsCount,
    "share_count": shareCount,
    "ticker_id": tickerId,
    "date": date,
    "createdAt": createdAt,
    "bookmark": bookmark,
    "tickers": List<dynamic>.from(tickers.map((x) => x)),
    "industry": List<dynamic>.from(industry.map((x) => x)),
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
