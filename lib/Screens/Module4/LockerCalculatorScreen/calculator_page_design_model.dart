
import 'dart:convert';

import 'package:get/get.dart';

CalculatorPageDesignModel calculatorPageDesignModelFromJson(String str) => CalculatorPageDesignModel.fromJson(json.decode(str));

String calculatorPageDesignModelToJson(CalculatorPageDesignModel data) => json.encode(data.toJson());

class CalculatorPageDesignModel {
  final List<Response> response;

  CalculatorPageDesignModel({
    required this.response,
  });

  factory CalculatorPageDesignModel.fromJson(Map<String, dynamic> json) => CalculatorPageDesignModel(
    response: json["response"]==null?[]:List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  final String topic;
  final String imageUrl;
  final RxList<ResponseCalculatorList> responseList;

  Response({
    required this.topic,
    required this.imageUrl,
    required this.responseList,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    topic: json["topic"]??"",
    imageUrl: json["imageUrl"]??"",
    responseList: json["responseList"]==null?RxList<ResponseCalculatorList>([]):RxList<ResponseCalculatorList>.from(json["responseList"].map((x) => ResponseCalculatorList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "topic": topic,
    "imageUrl": imageUrl,
    "responseList": List<dynamic>.from(responseList.map((x) => x.toJson())),
  };
}

class ResponseCalculatorList {
  final String name;
  final Ticker ticker;

  ResponseCalculatorList({
    required this.name,
    required this.ticker,
  });

  factory ResponseCalculatorList.fromJson(Map<String, dynamic> json) => ResponseCalculatorList(
    name: json["name"]??"",
    ticker: Ticker.fromJson(json["ticker"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "ticker": ticker.toJson(),
  };
}


class Ticker {
  final String id;
  final String imageUrl;
  final String name;
  final String category;
  final String exchange;
  final String country;
  final String code;
  final double close;
  final RxString value;
  final String fromWhere;

  Ticker({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.exchange,
    required this.country,
    required this.code,
    required this.close,
    required this.value,
    required this.fromWhere,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
    id: json["id"]??"",
    imageUrl: json["imageUrl"]??"",
    name: json["name"]??"",
    category: json["category"]??"",
    exchange: json["exchange"]??"",
    country: json["country"]??"",
    code: json["code"]??"",
    close: json["close"]??"",
    value: json["value"]==null?"".obs:(json["value"].toString()).obs,
    fromWhere: json["fromWhere"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imageUrl": imageUrl,
    "name": name,
    "category": category,
    "exchange": exchange,
    "country": country,
    "code": code,
    "close": close,
    "value": value,
    "fromWhere": fromWhere,
  };
}
