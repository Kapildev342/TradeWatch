import 'dart:convert';

import 'communities_page_initial_model.dart';

CommunitiesPostResponseModel communitiesPostResponseModelFromJson(String str) => CommunitiesPostResponseModel.fromJson(json.decode(str));

String communitiesPostResponseModelToJson(CommunitiesPostResponseModel data) => json.encode(data.toJson());

class CommunitiesPostResponseModel {
  final bool status;
  final String message;
  final List<PostRequest> response;

  CommunitiesPostResponseModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesPostResponseModel.fromJson(Map<String, dynamic> json) => CommunitiesPostResponseModel(
        status: json["status"],
        message: json["message"],
        response: List<PostRequest>.from(json["response"].map((x) => PostRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}
