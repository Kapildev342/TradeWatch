
import 'dart:convert';

import 'bill_board_main_model.dart';

BillboardFeaturesListModel billboardMainModelFromJson(String str) => BillboardFeaturesListModel.fromJson(json.decode(str));

String billboardMainModelToJson(BillboardFeaturesListModel data) => json.encode(data.toJson());

class BillboardFeaturesListModel {
  final bool status;
  final String message;
  final List<BillboardMainModelResponse> response;

  BillboardFeaturesListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BillboardFeaturesListModel.fromJson(Map<String, dynamic> json) => BillboardFeaturesListModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: json["response"]==null?[]:List<BillboardMainModelResponse>.from(json["response"].map((x) => BillboardMainModelResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}
