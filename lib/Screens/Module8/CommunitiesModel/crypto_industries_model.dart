import 'dart:convert';

import 'package:get/get.dart';

CryptoIndustriesModel cryptoIndustriesModelFromJson(String str) => CryptoIndustriesModel.fromJson(json.decode(str));

String cryptoIndustriesModelToJson(CryptoIndustriesModel data) => json.encode(data.toJson());

class CryptoIndustriesModel {
  final bool status;
  final List<CryptoIndustriesResponse> response;
  final String message;

  CryptoIndustriesModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory CryptoIndustriesModel.fromJson(Map<String, dynamic> json) => CryptoIndustriesModel(
        status: json["status"] ?? false,
        response: List<CryptoIndustriesResponse>.from((json["response"] ?? []).map((x) => CryptoIndustriesResponse.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class CryptoIndustriesResponse {
  final RxString id;
  final RxString name;
  final String categoryId;

  CryptoIndustriesResponse({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory CryptoIndustriesResponse.fromJson(Map<String, dynamic> json) => CryptoIndustriesResponse(
        id: (json["_id"] ?? "").toString().obs,
        name: (json["name"] ?? "").toString().obs,
        categoryId: json["category_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category_id": categoryId,
      };
}
