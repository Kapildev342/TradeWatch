import 'dart:convert';

ChartTopTrendingModel chartTopTrendingModelFromJson(String str) => ChartTopTrendingModel.fromJson(json.decode(str));

String chartTopTrendingModelToJson(ChartTopTrendingModel data) => json.encode(data.toJson());

class ChartTopTrendingModel {
  final bool status;
  final List<Response> response;
  final String message;

  ChartTopTrendingModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory ChartTopTrendingModel.fromJson(Map<String, dynamic> json) => ChartTopTrendingModel(
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
  final String code;
  final String name;
  final String logoUrl;
  final String changeP;
  final String close;
  final String state;
  final String webUrl;
  final bool watchList;

  Response({
    required this.id,
    required this.code,
    required this.name,
    required this.logoUrl,
    required this.changeP,
    required this.close,
    required this.state,
    required this.webUrl,
    required this.watchList,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        logoUrl: json["logo_url"] ?? "",
        changeP: json["change_p"].toStringAsFixed(2),
        close: json["close"].toStringAsFixed(2),
        state: json["state"] ?? "",
        webUrl: json["web_url"] ?? "",
        watchList: json["watchlist"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "name": name,
        "logo_url": logoUrl,
        "change_p": changeP,
        "close": close,
        "state": state,
        "web_url": webUrl,
        "watchList": watchList,
      };
}
