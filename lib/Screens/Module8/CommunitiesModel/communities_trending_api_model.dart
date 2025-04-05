import 'dart:convert';

import 'communities_list_page_model.dart';

CommunitiesTrendingApiModel communitiesTrendingApiModelFromJson(String str) => CommunitiesTrendingApiModel.fromJson(json.decode(str));

String communitiesTrendingApiModelToJson(CommunitiesTrendingApiModel data) => json.encode(data.toJson());

class CommunitiesTrendingApiModel {
  final bool status;
  final String message;
  final List<TrendingDatum> response;

  CommunitiesTrendingApiModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesTrendingApiModel.fromJson(Map<String, dynamic> json) => CommunitiesTrendingApiModel(
        status: json["status"],
        message: json["message"],
        response: List<TrendingDatum>.from(json["response"].map((x) => TrendingDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}
