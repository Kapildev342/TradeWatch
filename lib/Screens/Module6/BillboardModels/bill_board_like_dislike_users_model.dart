
import 'dart:convert';

BillBoardLikeDisLikeUsersModel billBoardLikeDisLikeUsersModelFromJson(String str) => BillBoardLikeDisLikeUsersModel.fromJson(json.decode(str));

String billBoardLikeDisLikeUsersModelToJson(BillBoardLikeDisLikeUsersModel data) => json.encode(data.toJson());

class BillBoardLikeDisLikeUsersModel {
  final bool status;
  final List<BillBoardLikeDisLikeUsersResponse> response;
  final String message;

  BillBoardLikeDisLikeUsersModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory BillBoardLikeDisLikeUsersModel.fromJson(Map<String, dynamic> json) => BillBoardLikeDisLikeUsersModel(
    status: json["status"]??false,
    response:json["response"]==null?[]:List<BillBoardLikeDisLikeUsersResponse>.from(json["response"].map((x) => BillBoardLikeDisLikeUsersResponse.fromJson(x))),
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "message": message,
  };
}

class BillBoardLikeDisLikeUsersResponse {
  final String id;
  final int viewsCount;
  final int status;
  final String createdAt;
  final String userId;
  final String username;
  final String avatar;
  final String profileType;
  int believersCount;
  final String firstName;
  final String lastName;
  bool believed;
  final String tickerId;

  BillBoardLikeDisLikeUsersResponse({
    required this.id,
    required this.viewsCount,
    required this.status,
    required this.createdAt,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.profileType,
    required this.believersCount,
    required this.firstName,
    required this.lastName,
    required this.believed,
    required this.tickerId,
  });

  factory BillBoardLikeDisLikeUsersResponse.fromJson(Map<String, dynamic> json) => BillBoardLikeDisLikeUsersResponse(
    id: json["_id"]??"",
    viewsCount: json["views_count"]??0,
    status: json["status"]??0,
    createdAt: json["createdAt"]??"",
    userId: json["user_id"]??"",
    username: json["username"]??"",
    avatar: json["avatar"]??"",
    profileType: json["profile_type"]??"",
    believersCount: json["believers_count"]??0,
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    believed: json["believed"]??false,
    tickerId: json["ticker_id"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "views_count": viewsCount,
    "status": status,
    "createdAt": createdAt,
    "user_id": userId,
    "username": username,
    "avatar": avatar,
    "profile_type": profileType,
    "believers_count": believersCount,
    "first_name": firstName,
    "last_name": lastName,
    "believed": believed,
    "ticker_id": tickerId,
  };
}
