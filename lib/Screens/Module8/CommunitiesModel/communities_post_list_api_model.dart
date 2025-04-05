import 'dart:convert';

import 'communities_page_initial_model.dart';

CommunitiesPostListApiModel communitiesPostListApiModelFromJson(String str) => CommunitiesPostListApiModel.fromJson(json.decode(str));

String communitiesPostListApiModelToJson(CommunitiesPostListApiModel data) => json.encode(data.toJson());

class CommunitiesPostListApiModel {
  final bool status;
  final String message;
  final List<PostContent> response;

  CommunitiesPostListApiModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesPostListApiModel.fromJson(Map<String, dynamic> json) => CommunitiesPostListApiModel(
        status: json["status"],
        message: json["message"],
        response: List<PostContent>.from(json["response"].map((x) => PostContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}
