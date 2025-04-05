import 'dart:convert';

HomeSearchTickerModel homeSearchTickerModelFromJson(String str) => HomeSearchTickerModel.fromJson(json.decode(str));

String homeSearchTickerModelToJson(HomeSearchTickerModel data) => json.encode(data.toJson());

class HomeSearchTickerModel {
  final bool status;
  final String message;
  final List<HomeSearchTickerResponse> response;

  HomeSearchTickerModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory HomeSearchTickerModel.fromJson(Map<String, dynamic> json) => HomeSearchTickerModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: json["response"] == null
            ? []
            : List<HomeSearchTickerResponse>.from(json["response"].map((x) => HomeSearchTickerResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class HomeSearchTickerResponse {
  final String id;
  final String exchange;
  final String name;
  final String country;
  final String type;
  final String category;
  final String logoUrl;
  final double changeP;
  final double close;
  final String state;
  final String code;
  bool watchlist;

  HomeSearchTickerResponse({
    required this.id,
    required this.exchange,
    required this.name,
    required this.country,
    required this.type,
    required this.category,
    required this.logoUrl,
    required this.changeP,
    required this.close,
    required this.state,
    required this.code,
    required this.watchlist,
  });

  factory HomeSearchTickerResponse.fromJson(Map<String, dynamic> json) => HomeSearchTickerResponse(
        id: json["_id"] ?? "",
        exchange: json["exchange"] ?? "",
        name: json["name"] ?? "",
        country: json["country"] ?? "",
        type: json["type"] ?? '',
        category: json["category"] ?? "",
        logoUrl: json["logo_url"] ?? "",
        changeP: json["change_p"] == null ? 0.0 : json["change_p"].toDouble(),
        close: json["close"] == null ? 0.0 : json["close"].toDouble(),
        state: json["state"] ?? "Increse",
        code: json["code"] ?? "",
        watchlist: json["watchlist"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "exchange": exchange,
        "name": name,
        "country": country,
        "type": type,
        "category": category,
        "logo_url": logoUrl,
        "change_p": changeP,
        "close": close,
        "state": state,
        "code": code,
        "watchlist": watchlist,
      };
}
