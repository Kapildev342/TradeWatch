import 'dart:convert';

import '../../Module2/Forum/related_forums_model.dart';

VideosMainPageModel videosMainPageModelFromJson(String str) => VideosMainPageModel.fromJson(json.decode(str));

String videosMainPageModelToJson(VideosMainPageModel data) => json.encode(data.toJson());

class VideosMainPageModel {
  final bool status;
  final List<Response> response;
  final String message;

  VideosMainPageModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory VideosMainPageModel.fromJson(Map<String, dynamic> json) => VideosMainPageModel(
        status: json["status"] ?? false,
        response: json["response"] == null ? [] : List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class Response {
  final String title;
  final String id;
  final String newsUrl;
  final String imageUrl;
  final String exchange;
  final String sourceName;
  final String type;
  final int status;
  final String tickerId;
  final String category;
  final int disLikesCount;
  final bool dislikes;
  final bool likes;
  final int likesCount;
  final int viewsCount;
  final String date;
  final String createdAt;
  final dynamic sentiment;
  final bool bookmark;
  final bool translation;
  final dynamic country;
  final List<String> tickers;
  final dynamic description;
  final dynamic snippet;
  final List<dynamic> industry;
  final int sortInd;

  Response({
    required this.title,
    required this.id,
    required this.newsUrl,
    required this.imageUrl,
    required this.exchange,
    required this.sourceName,
    required this.type,
    required this.status,
    required this.tickerId,
    required this.category,
    required this.disLikesCount,
    required this.dislikes,
    required this.likes,
    required this.likesCount,
    required this.viewsCount,
    required this.date,
    required this.createdAt,
    required this.sentiment,
    required this.bookmark,
    required this.translation,
    required this.country,
    required this.tickers,
    required this.description,
    required this.snippet,
    required this.industry,
    required this.sortInd,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        title: json["title"] ?? "",
        id: json["_id"] ?? "",
        newsUrl: json["news_url"] ?? "",
        imageUrl: json["image_url"] ?? "",
        exchange: json["exchange"] ?? "",
        sourceName: json["source_name"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? 0,
        tickerId: json["ticker_id"] ?? "",
        category: json["category"] ?? "",
        disLikesCount: json["dis_likes_count"] ?? 0,
        dislikes: json["dislikes"] ?? false,
        likes: json["likes"] ?? false,
        likesCount: json["likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        date: json["date"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["date"]).millisecondsSinceEpoch),
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        sentiment: json["sentiment"] ?? "",
        bookmark: json["bookmark"] ?? false,
        translation: json["translation"] ?? false,
        country: json["country"] ?? "",
        tickers: json["tickers"] == null ? [] : List<String>.from(json["tickers"].map((x) => x)),
        description: json["description"] ?? "",
        snippet: json["snippet"] ?? "",
        industry: json["industry"] == null ? [] : List<dynamic>.from(json["industry"].map((x) => x)),
        sortInd: json["sort_ind"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "_id": id,
        "news_url": newsUrl,
        "image_url": imageUrl,
        "exchange": exchange,
        "source_name": sourceName,
        "type": type,
        "status": status,
        "ticker_id": tickerId,
        "category": category,
        "dis_likes_count": disLikesCount,
        "dislikes": dislikes,
        "likes": likes,
        "likes_count": likesCount,
        "views_count": viewsCount,
        "date": date,
        "createdAt": createdAt,
        "sentiment": sentiment,
        "bookmark": bookmark,
        "translation": translation,
        "country": country,
        "tickers": List<dynamic>.from(tickers.map((x) => x)),
        "description": description,
        "snippet": snippet,
        "industry": List<dynamic>.from(industry.map((x) => x)),
        "sort_ind": sortInd,
      };
}
