import 'dart:convert';

import 'package:get/get.dart';

PostLimitationModel postLimitationModelFromJson(String str) => PostLimitationModel.fromJson(json.decode(str));

String postLimitationModelToJson(PostLimitationModel data) => json.encode(data.toJson());

class PostLimitationModel {
  final bool status;
  final List<PostLimitationResponse> response;

  PostLimitationModel({
    required this.status,
    required this.response,
  });

  factory PostLimitationModel.fromJson(Map<String, dynamic> json) => PostLimitationModel(
        status: json["status"] ?? false,
        response: List<PostLimitationResponse>.from((json["response"] ?? []).map((x) => PostLimitationResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class PostLimitationResponse {
  final RxString name;
  final RxString slug;
  final List<PostLimitationResponseOption> options;

  PostLimitationResponse({
    required this.name,
    required this.slug,
    required this.options,
  });

  factory PostLimitationResponse.fromJson(Map<String, dynamic> json) => PostLimitationResponse(
        name: (json["name"] ?? "").toString().obs,
        slug: (json["slug"] ?? "").toString().obs,
        options: List<PostLimitationResponseOption>.from((json["options"] ?? []).map((x) => PostLimitationResponseOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class PostLimitationResponseOption {
  final RxString name;
  final RxString slug;

  PostLimitationResponseOption({
    required this.name,
    required this.slug,
  });

  factory PostLimitationResponseOption.fromJson(Map<String, dynamic> json) => PostLimitationResponseOption(
        name: (json["name"] ?? "").toString().obs,
        slug: (json["slug"] ?? "").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
      };
}
