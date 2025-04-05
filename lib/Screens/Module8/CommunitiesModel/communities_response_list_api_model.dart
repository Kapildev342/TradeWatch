import 'dart:convert';

import 'communities_description_responses_list_model.dart';

CommunitiesResponseListApiModel communitiesResponseListApiModelFromJson(String str) => CommunitiesResponseListApiModel.fromJson(json.decode(str));

String communitiesResponseListApiModelToJson(CommunitiesResponseListApiModel data) => json.encode(data.toJson());

class CommunitiesResponseListApiModel {
  final bool status;
  final String message;
  final List<CommunitiesPostsResponsesList> response;

  CommunitiesResponseListApiModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesResponseListApiModel.fromJson(Map<String, dynamic> json) => CommunitiesResponseListApiModel(
        status: json["status"],
        message: json["message"],
        response: List<CommunitiesPostsResponsesList>.from(json["response"].map((x) => CommunitiesPostsResponsesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}
