
import 'dart:convert';

UserSearchDataModel userSearchDataModelFromJson(String str) => UserSearchDataModel.fromJson(json.decode(str));

String userSearchDataModelToJson(UserSearchDataModel data) => json.encode(data.toJson());

class UserSearchDataModel {
  final bool status;
  final List<UserSearchDataResponse> response;
  final String key;
  final String message;

  UserSearchDataModel({
    required this.status,
    required this.response,
    required this.key,
    required this.message,
  });

  factory UserSearchDataModel.fromJson(Map<String, dynamic> json) => UserSearchDataModel(
    status: json["status"]??false,
    response: json["response"]==null?[]:List<UserSearchDataResponse>.from(json["response"].map((x) => UserSearchDataResponse.fromJson(x))),
    key: json["key"]??"",
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "key": key,
    "message": message,
  };
}

class UserSearchDataResponse {
  final String id;
  final String firstname;
  final String lastname;
  final String username;
  final String avatar;
  final String tickerId;
  final String sourceId;
  final String profileType;
  int believersCount;
  bool believed;

  UserSearchDataResponse({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.avatar,
    required this.tickerId,
    required this.sourceId,
    required this.profileType,
    required this.believersCount,
    required this.believed,
  });

  factory UserSearchDataResponse.fromJson(Map<String, dynamic> json) => UserSearchDataResponse(
    id: json["_id"]??"",
    firstname: json["firstname"]??"",
    lastname: json["lastname"]??"",
    username: json["username"]??"",
    avatar: json["avatar"]??"",
    tickerId: json["ticker_id"]??"",
    sourceId: json["source_id"]??"",
    profileType: json["profile_type"]??"",
    believersCount: json["believers_count"]??0,
    believed: json["believed"]??false,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "avatar": avatar,
    "ticker_id": tickerId,
    "source_id": sourceId,
    "profile_type": profileType,
    "believers_count": believersCount,
    "believed": believed,
  };
}
