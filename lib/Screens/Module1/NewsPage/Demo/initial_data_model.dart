import 'dart:convert';

DemoInitialData demoInitialDataFromJson(String str) => DemoInitialData.fromJson(json.decode(str));

String demoInitialDataToJson(DemoInitialData data) => json.encode(data.toJson());

class DemoInitialData {
  String id;
  String type;
  String title;
  String link;
  String intermediaryProfileId;
  String newsTickerId;
  String newsTickerCategoryId;
  String newsTickerExchangeId;
  bool isLiked;
  bool isDisliked;
  bool bookmark;
  bool loading;
  bool appBarLoading;

  DemoInitialData({
    required this.id,
    required this.type,
    required this.title,
    required this.link,
    required this.intermediaryProfileId,
    required this.newsTickerId,
    required this.newsTickerCategoryId,
    required this.newsTickerExchangeId,
    required this.isLiked,
    required this.isDisliked,
    required this.bookmark,
    required this.loading,
    required this.appBarLoading,
  });

  factory DemoInitialData.fromJson(Map<String, dynamic> json) => DemoInitialData(
        id: json["id"] ?? "",
        type: json["type"] ?? "",
        title: json["title"] ?? "",
        link: json["link"] ?? "",
        intermediaryProfileId: json["intermediary_profile_id"] ?? "",
        newsTickerId: json["news_ticker_id"] ?? "",
        newsTickerCategoryId: json["news_ticker_category_id"] ?? "",
        newsTickerExchangeId: json["news_ticker_exchange_id"] ?? "",
        isLiked: json["isLiked"] ?? false,
        isDisliked: json["isDisliked"] ?? false,
        bookmark: json["bookmark"] ?? false,
        loading: json["loading"] ?? false,
        appBarLoading: json["app_bar_loading"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "link": link,
        "intermediary_profile_id": intermediaryProfileId,
        "news_ticker_id": newsTickerId,
        "news_ticker_category_id": newsTickerCategoryId,
        "news_ticker_exchange_id": newsTickerExchangeId,
        "isLiked": isLiked,
        "isDisliked": isDisliked,
        "bookmark": bookmark,
        "loading": loading,
        "app_bar_loading": appBarLoading,
      };
}
