import 'dart:convert';

import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

BelieversListModel believersListModelFromJson(String str) => BelieversListModel.fromJson(json.decode(str));

String believersListModelToJson(BelieversListModel data) => json.encode(data.toJson());

class BelieversListModel {
  final bool status;
  final String message;
  final List<UsersListResponse> response;

  BelieversListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BelieversListModel.fromJson(Map<String, dynamic> json) => BelieversListModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: json["response"] == null
            ? []
            : List<UsersListResponse>.from(json["response"].map((x) => UsersListResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class UsersListResponse {
  final String id;
  final String userId;
  final String tickerId;
  final String username;
  final String firstName;
  final String lastName;
  int believersCount;
  final String avatar;
  bool believed;
  final String profileType;
  final String visitedDateTime;

  UsersListResponse({
    required this.id,
    required this.userId,
    required this.tickerId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.believersCount,
    required this.avatar,
    required this.believed,
    required this.profileType,
    required this.visitedDateTime,
  });

  factory UsersListResponse.fromJson(Map<String, dynamic> json) => UsersListResponse(
        id: json["_id"] ?? "",
        userId: json["user_id"] ?? "",
        tickerId: json["ticker_id"] ?? "",
        username: json["username"],
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        believersCount: json["believers_count"] ?? 0,
        avatar: json["avatar"] ?? "",
        believed: json["believed"] ?? false,
        profileType: json["profile_type"] ?? "",
        visitedDateTime: json["createdAt"] == null
            ? ""
            : billBoardFunctionsMain.readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "ticker_id": tickerId,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "believers_count": believersCount,
        "avatar": avatar,
        "believed": believed,
        "profile_type": profileType,
        "createdAt": visitedDateTime,
      };
}
