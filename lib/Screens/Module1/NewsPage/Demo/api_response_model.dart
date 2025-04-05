import 'dart:convert';

DemoResponseModel demoResponseModelFromJson(String str) => DemoResponseModel.fromJson(json.decode(str));

String demoResponseModelToJson(DemoResponseModel data) => json.encode(data.toJson());

class DemoResponseModel {
  final bool status;
  final Response response;
  final String message;

  DemoResponseModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory DemoResponseModel.fromJson(Map<String, dynamic> json) => DemoResponseModel(
        status: json["status"] ?? false,
        response: Response.fromJson(json["response"] ?? {}),
        message: json["message"] ?? "",
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
  final String newsUrl;
  final String imageUrl;
  final String sourceName;
  final String type;
  final String description;
  final String snippet;
  final String exchange;
  final String date;
  final String category;
  final String searchType;
  final int likesCount;
  final int disLikesCount;
  final int viewsCount;
  final int shareCount;
  final List<String> likes;
  final List<String> dislikes;
  final String categoryId;
  final String exchangeId;
  final String userId;
  final List<String> tickers;
  final int status;
  final int reportCount;
  final int blocked;
  final int reported;
  final List<String> tickerIds;
  final String postType;
  final int repostedCount;
  final int repostStatus;
  final String profileType;
  final String createdAt;
  final String updatedAt;
  final String sentiment;
  final bool bookmark;

  Response({
    required this.id,
    required this.title,
    required this.newsUrl,
    required this.imageUrl,
    required this.sourceName,
    required this.type,
    required this.description,
    required this.snippet,
    required this.exchange,
    required this.date,
    required this.category,
    required this.searchType,
    required this.likesCount,
    required this.disLikesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.likes,
    required this.dislikes,
    required this.categoryId,
    required this.exchangeId,
    required this.userId,
    required this.tickers,
    required this.status,
    required this.reportCount,
    required this.blocked,
    required this.reported,
    required this.tickerIds,
    required this.postType,
    required this.repostedCount,
    required this.repostStatus,
    required this.profileType,
    required this.createdAt,
    required this.updatedAt,
    required this.sentiment,
    required this.bookmark,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        newsUrl: json["news_url"] ?? "",
        imageUrl: json["image_url"] ?? "",
        sourceName: json["source_name"] ?? "",
        type: json["type"] ?? "",
        description: json["description"] ?? "",
        snippet: json["snippet"] ?? "",
        exchange: json["exchange"] ?? "",
        date: json["date"] ?? "",
        category: json["category"] ?? "",
        searchType: json["search_type"] ?? "",
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        likes: List<String>.from((json["likes"] ?? []).map((x) => x)),
        dislikes: List<String>.from((json["dislikes"] ?? []).map((x) => x)),
        categoryId: json["category_id"] ?? "",
        exchangeId: json["exchange_id"] ?? "",
        userId: json["user_id"] ?? "",
        tickers: List<String>.from((json["tickers"]) ?? [].map((x) => x)),
        status: json["status"] ?? 0,
        reportCount: json["report_count"] ?? 0,
        blocked: json["blocked"] ?? 0,
        reported: json["reported"] ?? 0,
        tickerIds: List<String>.from((json["tickerIds"] ?? []).map((x) => x)),
        postType: json["post_type"] ?? "",
        repostedCount: json["reposted_count"] ?? 0,
        repostStatus: json["repost_status"] ?? 0,
        profileType: json["profile_type"] ?? '',
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? '',
        sentiment: json["sentiment"] ?? "",
        bookmark: json["bookmark"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "news_url": newsUrl,
        "image_url": imageUrl,
        "source_name": sourceName,
        "type": type,
        "description": description,
        "snippet": snippet,
        "exchange": exchange,
        "date": date,
        "category": category,
        "search_type": searchType,
        "likes_count": likesCount,
        "dis_likes_count": disLikesCount,
        "views_count": viewsCount,
        "share_count": shareCount,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "dislikes": List<dynamic>.from(dislikes.map((x) => x)),
        "category_id": categoryId,
        "exchange_id": exchangeId,
        "user_id": userId,
        "tickers": List<dynamic>.from(tickers.map((x) => x)),
        "status": status,
        "report_count": reportCount,
        "blocked": blocked,
        "reported": reported,
        "tickerIds": List<dynamic>.from(tickerIds.map((x) => x)),
        "post_type": postType,
        "reposted_count": repostedCount,
        "repost_status": repostStatus,
        "profile_type": profileType,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "sentiment": sentiment,
        "bookmark": bookmark,
      };
}
