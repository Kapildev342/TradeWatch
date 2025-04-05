
import 'dart:convert';

import 'bill_board_main_model.dart';

BillBoardRepostListModel repostListModelFromJson(String str) => BillBoardRepostListModel.fromJson(json.decode(str));

String repostListModelToJson(BillBoardRepostListModel data) => json.encode(data.toJson());

class BillBoardRepostListModel {
  final bool status;
  final String message;
  final List<BillboardMainModelResponse> response;

  BillBoardRepostListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BillBoardRepostListModel.fromJson(Map<String, dynamic> json) => BillBoardRepostListModel(
    status: json["status"],
    message: json["message"],
    response: List<BillboardMainModelResponse>.from(json["response"].map((x) => BillboardMainModelResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}
