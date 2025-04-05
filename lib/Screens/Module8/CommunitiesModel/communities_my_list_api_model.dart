import 'dart:convert';

import 'communities_list_page_model.dart';

CommunitiesMyListApiModel communitiesMyListApiModelFromJson(String str) => CommunitiesMyListApiModel.fromJson(json.decode(str));

String communitiesMyListApiModelToJson(CommunitiesMyListApiModel data) => json.encode(data.toJson());

class CommunitiesMyListApiModel {
  final bool status;
  final String message;
  final List<CommunityListDatum> response;

  CommunitiesMyListApiModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesMyListApiModel.fromJson(Map<String, dynamic> json) => CommunitiesMyListApiModel(
        status: json["status"],
        message: json["message"],
        response: List<CommunityListDatum>.from(json["response"].map((x) => CommunityListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}
