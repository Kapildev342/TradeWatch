import 'dart:convert';

import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';

BookMarkSeeAllBillBoardModel bookMarkSeeAllBillBoardFromJson(String str) =>
    BookMarkSeeAllBillBoardModel.fromJson(json.decode(str));

String bookMarkSeeAllBillBoardToJson(BookMarkSeeAllBillBoardModel data) => json.encode(data.toJson());

class BookMarkSeeAllBillBoardModel {
  final bool status;
  final String message;
  final List<BillboardMainModelResponse> response;

  BookMarkSeeAllBillBoardModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BookMarkSeeAllBillBoardModel.fromJson(Map<String, dynamic> json) => BookMarkSeeAllBillBoardModel(
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
