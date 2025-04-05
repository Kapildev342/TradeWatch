import 'dart:convert';

import 'package:get/get.dart';

IndustriesListModel industriesListPageFromJson(String str) => IndustriesListModel.fromJson(json.decode(str));

String industriesListPageToJson(IndustriesListModel data) => json.encode(data.toJson());

class IndustriesListModel {
  final bool status;
  final List<IndustriesListResponse> response;
  final String message;

  IndustriesListModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory IndustriesListModel.fromJson(Map<String, dynamic> json) => IndustriesListModel(
        status: json["status"] ?? false,
        response: List<IndustriesListResponse>.from((json["response"] ?? []).map((x) => IndustriesListResponse.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
      };
}

class IndustriesListResponse {
  final RxString id;
  final String name;
  final String categoryId;

  IndustriesListResponse({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory IndustriesListResponse.fromJson(Map<String, dynamic> json) => IndustriesListResponse(
        id: (json["_id"] ?? "").toString().obs,
        name: json["name"] ?? "",
        categoryId: json["category_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category_id": categoryId,
      };
}
