import 'dart:convert';

SingleTickerNewsModel singleTickerNewsModelFromJson(String str) => SingleTickerNewsModel.fromJson(json.decode(str));

String singleTickerNewsModelToJson(SingleTickerNewsModel data) => json.encode(data.toJson());

class SingleTickerNewsModel {
  final bool status;
  final List<Response> response;
  final String message;

  SingleTickerNewsModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory SingleTickerNewsModel.fromJson(Map<String, dynamic> json) => SingleTickerNewsModel(
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
  final String description;
  final String snippet;
  final String createdAt;

  Response({
    required this.id,
    required this.title,
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
    required this.description,
    required this.snippet,
    required this.date,
    required this.createdAt,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
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
        date: json["date"] ?? "",
        createdAt: json["createdAt"] ?? "",
        description: json["description"] ?? "",
        snippet: json["snippet"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
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
        "description": description,
        "snippet": snippet,
      };
}
