import 'dart:convert';

import 'package:get/get.dart';

CommodityCountriesModel commodityCountriesModelFromJson(String str) => CommodityCountriesModel.fromJson(json.decode(str));

String commodityCountriesModelToJson(CommodityCountriesModel data) => json.encode(data.toJson());

class CommodityCountriesModel {
  final bool status;
  final List<CommoditiesCountriesResponse> response;
  final String message;

  CommodityCountriesModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory CommodityCountriesModel.fromJson(Map<String, dynamic> json) => CommodityCountriesModel(
        status: json["status"] ?? false,
        response: List<CommoditiesCountriesResponse>.from((json["response"] ?? []).map((x) => CommoditiesCountriesResponse.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class CommoditiesCountriesResponse {
  final RxString id;
  final RxString name;

  CommoditiesCountriesResponse({
    required this.id,
    required this.name,
  });

  factory CommoditiesCountriesResponse.fromJson(Map<String, dynamic> json) => CommoditiesCountriesResponse(
        id: (json["_id"] ?? "").toString().obs,
        name: (json["name"] ?? "").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
