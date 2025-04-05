import 'dart:convert';

import '../../Module2/FeatureRequest/response_feature_response_model.dart';

NewsMainPageModel newsMainPageModelFromJson(String str) => NewsMainPageModel.fromJson(json.decode(str));

String newsMainPageModelToJson(NewsMainPageModel data) => json.encode(data.toJson());

class NewsMainPageModel {
  final bool status;
  final List<Response> response;
  final String message;

  NewsMainPageModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory NewsMainPageModel.fromJson(Map<String, dynamic> json) => NewsMainPageModel(
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
  final dynamic tickerId;
  final String date;
  final String createdAt;
  final bool bookmark;
  final bool translation;
  final String description;
  final String snippet;
  final String sentiment;
  final dynamic country;
  final List<String> tickers;
  final List<dynamic> industry;
  final int sortInd;

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
    required this.translation,
    required this.description,
    required this.snippet,
    required this.sentiment,
    required this.country,
    required this.tickers,
    required this.industry,
    required this.sortInd,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
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
        tickerId: json["ticker_id"] ?? "",
        date: json["date"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["date"]).millisecondsSinceEpoch),
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        bookmark: json["bookmark"] ?? false,
        translation: json["translation"] ?? false,
        description: json["description"] ?? "",
        snippet: json["snippet"] ?? "",
        sentiment: json["sentiment"] ?? "",
        country: json["country"] ?? "",
        tickers: json["tickers"] == null ? [] : List<String>.from(json["tickers"].map((x) => x)),
        industry: json["industry"] == null ? [] : List<dynamic>.from(json["industry"].map((x) => x)),
        sortInd: json["sort_ind"] ?? "",
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
        "ticker_id": tickerId,
        "date": date,
        "createdAt": createdAt,
        "bookmark": bookmark,
        "translation": translation,
        "description": description,
        "snippet": snippet,
        "sentiment": sentiment,
        "country": country,
        "tickers": List<dynamic>.from(tickers.map((x) => x)),
        "industry": List<dynamic>.from(industry.map((x) => x)),
        "sort_ind": sortInd,
      };
}
