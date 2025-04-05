

import 'dart:convert';

ContactUsersListModel contactUsersListModelFromJson(String str) => ContactUsersListModel.fromJson(json.decode(str));

String contactUsersListModelToJson(ContactUsersListModel data) => json.encode(data.toJson());

class ContactUsersListModel {
  final bool status;
  final String message;
  final List<ContactUsersListResponse> response;

  ContactUsersListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory ContactUsersListModel.fromJson(Map<String, dynamic> json) => ContactUsersListModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: json["response"]==null?[]:List<ContactUsersListResponse>.from(json["response"].map((x) => ContactUsersListResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class ContactUsersListResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final int believersCount;
  final String profileType;
  final String avatar;
  bool believed;

  ContactUsersListResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.believersCount,
    required this.profileType,
    required this.avatar,
    required this.believed,
  });

  factory ContactUsersListResponse.fromJson(Map<String, dynamic> json) => ContactUsersListResponse(
    id: json["_id"]??"",
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??'',
    username: json["username"]??'',
    believersCount: json["believers_count"]??0,
    profileType: json["profile_type"]??'',
    avatar: json["avatar"]??"",
    believed: json["believed"]??false,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "believers_count": believersCount,
    "profile_type": profileType,
    "avatar": avatar,
    "believed": believed,
  };
}
