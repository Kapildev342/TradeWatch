
import 'dart:convert';

ExchangesListModel exchangesListModelFromJson(String str) => ExchangesListModel.fromJson(json.decode(str));

String exchangesListModelToJson(ExchangesListModel data) => json.encode(data.toJson());

class ExchangesListModel {
  final bool status;
  final List<ExchangesListResponse> response;
  final String message;

  ExchangesListModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory ExchangesListModel.fromJson(Map<String, dynamic> json) => ExchangesListModel(
    status: json["status"],
    response: List<ExchangesListResponse>.from(json["response"].map((x) => ExchangesListResponse.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "message": message,
  };
}

class ExchangesListResponse {
  final String id;
  final String name;
  final String categoryId;
  bool isChecked;

  ExchangesListResponse({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.isChecked,
  });

  factory ExchangesListResponse.fromJson(Map<String, dynamic> json) => ExchangesListResponse(
    id: json["_id"]??"",
    name: json["name"]??"",
    categoryId: json["category_id"]??"",
    isChecked: json["is_checked"]??false,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "category_id": categoryId,
    "is_checked": isChecked,
  };
}
