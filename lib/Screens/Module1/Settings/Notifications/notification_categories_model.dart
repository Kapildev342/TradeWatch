
import 'dart:convert';

NotificationCategoriesModel notificationCategoriesModelFromJson(String str) => NotificationCategoriesModel.fromJson(json.decode(str));

String notificationCategoriesModelToJson(NotificationCategoriesModel data) => json.encode(data.toJson());

class NotificationCategoriesModel {
  final bool status;
  final String message;
  final bool notification;
  final List<NotificationCategoryResponse> response;

  NotificationCategoriesModel({
    required this.status,
    required this.message,
    required this.notification,
    required this.response,
  });

  factory NotificationCategoriesModel.fromJson(Map<String, dynamic> json) => NotificationCategoriesModel(
    status: json["status"]??false,
    message: json["message"]??"",
    notification: json["notification"]??false,
    response: json["response"]==null?[]:List<NotificationCategoryResponse>.from(json["response"].map((x) => NotificationCategoryResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "notification": notification,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class NotificationCategoryResponse {
  final String name;
  final String slug;
  final String image;
  final bool notify;

  NotificationCategoryResponse({
    required this.name,
    required this.slug,
    required this.image,
    required this.notify,
  });

  factory NotificationCategoryResponse.fromJson(Map<String, dynamic> json) => NotificationCategoryResponse(
    name: json["name"]??"",
    slug: json["slug"]??"",
    image: json["image_url"]??"",
    notify: json["notify"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "image_url": image,
    "notify": notify,
  };
}
