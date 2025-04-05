import 'dart:convert';

import 'package:get/get.dart';

ExchangeListModel exchangeListPageFromJson(String str) => ExchangeListModel.fromJson(json.decode(str));

String exchangeListPageToJson(ExchangeListModel data) => json.encode(data.toJson());

class ExchangeListModel {
  final bool status;
  final List<ExchangeListResponse> response;
  final String message;

  ExchangeListModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory ExchangeListModel.fromJson(Map<String, dynamic> json) => ExchangeListModel(
        status: json["status"] ?? false,
        response: List<ExchangeListResponse>.from((json["response"] ?? []).map((x) => ExchangeListResponse.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class ExchangeListResponse {
  final RxString id;
  final RxString name;
  final String code;
  final String operatingMic;
  final String country;
  final String currency;
  final int status;
  final String createdAt;
  final String updatedAt;

  ExchangeListResponse({
    required this.id,
    required this.name,
    required this.code,
    required this.operatingMic,
    required this.country,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExchangeListResponse.fromJson(Map<String, dynamic> json) => ExchangeListResponse(
        id: (json["_id"] ?? "").toString().obs,
        name: (json["name"] ?? "").toString().obs,
        code: json["code"] ?? "",
        operatingMic: json["OperatingMIC"] ?? "",
        country: json["Country"] ?? '',
        currency: json["Currency"] ?? '',
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "code": code,
        "OperatingMIC": operatingMic,
        "Country": country,
        "Currency": currency,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
