// To parse this JSON data, do
//
//     final tapeTickerModel = tapeTickerModelFromJson(jsonString);

import 'dart:convert';

TapeTickerModel tapeTickerModelFromJson(String str) => TapeTickerModel.fromJson(json.decode(str));

String tapeTickerModelToJson(TapeTickerModel data) => json.encode(data.toJson());

class TapeTickerModel {
  final bool status;
  final String message;
  final List<Response> response;

  TapeTickerModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory TapeTickerModel.fromJson(Map<String, dynamic> json) => TapeTickerModel(
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
  final String exchange;
  final String code;
  final String name;
  final String country;
  final String category;
  final String logoUrl;
  final double changeP;
  final double close;
  final String state;
  final bool watchlist;
  final List<Industry> industry;

  Response({
    required this.id,
    required this.exchange,
    required this.code,
    required this.name,
    required this.country,
    required this.category,
    required this.logoUrl,
    required this.changeP,
    required this.close,
    required this.state,
    required this.watchlist,
    required this.industry,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??"",
    exchange: json["exchange"]??"",
    code: json["code"]??"",
    name: json["name"]??"",
    country: json["country"]??"",
    category: json["category"]??"",
    logoUrl: json["logo_url"]??"",
    changeP: json["change_p"].toDouble()??0.0,
    close: json["close"].toDouble()??0.0,
    state: json["state"]??"",
    watchlist: json["watchlist"]??false,
    industry: json["industry"]==null?[]:List<Industry>.from(json["industry"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "exchange": exchange,
    "code": code,
    "name": name,
    "country": country,
    "category": category,
    "logo_url": logoUrl,
    "change_p": changeP,
    "close": close,
    "state": state,
    "watchlist": watchlist,
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
