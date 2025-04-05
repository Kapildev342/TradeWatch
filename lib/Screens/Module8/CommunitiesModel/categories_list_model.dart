import 'dart:convert';

import 'package:get/get.dart';

CategoriesListModel communitiesListPageFromJson(String str) => CategoriesListModel.fromJson(json.decode(str));

String communitiesListPageToJson(CategoriesListModel data) => json.encode(data.toJson());

class CategoriesListModel {
  final List<CategoriesListModelResponse> response;

  CategoriesListModel({
    required this.response,
  });

  factory CategoriesListModel.fromJson(Map<String, dynamic> json) => CategoriesListModel(
        response: List<CategoriesListModelResponse>.from((json["response"] ?? []).map((x) => CategoriesListModelResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class CategoriesListModelResponse {
  Rx<String> name;
  Rx<String> id;
  Rx<String> slug;
  Rx<String> image;

  CategoriesListModelResponse({
    required this.name,
    required this.id,
    required this.slug,
    required this.image,
  });

  factory CategoriesListModelResponse.fromJson(Map<String, dynamic> json) => CategoriesListModelResponse(
        name: (json["name"] ?? "").toString().obs,
        id: (json["id"] ?? "").toString().obs,
        slug: (json["slug"] ?? "").toString().obs,
        image: (json["image_url"] ?? "").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "slug": slug,
        "image_url": image,
      };
}
