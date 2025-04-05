import 'dart:convert';

import 'package:get/get.dart';

TickersListModel tickersListPageFromJson(String str) => TickersListModel.fromJson(json.decode(str));

String tickersListPageToJson(TickersListModel data) => json.encode(data.toJson());

class TickersListModel {
  final bool status;
  final List<TickersListResponse> response;
  final String message;

  TickersListModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory TickersListModel.fromJson(Map<String, dynamic> json) => TickersListModel(
        status: json["status"] ?? false,
        response: List<TickersListResponse>.from((json["response"] ?? []).map((x) => TickersListResponse.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class TickersListResponse {
  final RxString id;
  final String exchange;
  final String code;
  final String name;
  final String logoUrl;
  final String tvSymbol;

  TickersListResponse({
    required this.id,
    required this.exchange,
    required this.code,
    required this.name,
    required this.logoUrl,
    required this.tvSymbol,
  });

  factory TickersListResponse.fromJson(Map<String, dynamic> json) => TickersListResponse(
        id: (json["_id"] ?? "").toString().obs,
        exchange: json["exchange"] ?? "",
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        logoUrl: json["logo_url"] ?? "",
        tvSymbol: json["tv_symbol"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "exchange": exchange,
        "code": code,
        "name": name,
        "logo_url": logoUrl,
        "tv_symbol": tvSymbol,
      };
}
