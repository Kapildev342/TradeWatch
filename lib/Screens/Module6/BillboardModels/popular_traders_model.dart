
import 'dart:convert';

PopularTradersModel popularTradersModelFromJson(String str) => PopularTradersModel.fromJson(json.decode(str));

String popularTradersModelToJson(PopularTradersModel data) => json.encode(data.toJson());

class PopularTradersModel {
  final bool status;
  final String message;
  final List<Response> response;

  PopularTradersModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory PopularTradersModel.fromJson(Map<String, dynamic> json) => PopularTradersModel(
    status: json["status"]??false,
    message: json["message"]??'',
    response: json["response"]==null?[]:List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  int believersCount;
  final String avatar;
  bool believed;
  final String profileType;
  final String tickerId;

  Response({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.believersCount,
    required this.avatar,
    required this.believed,
    required this.profileType,
    required this.tickerId,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??"",
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    username: json["username"]??'',
    believersCount: json["believers_count"]??0,
    avatar: json["avatar"]??"",
    believed: json["believed"]??false,
    profileType: json["profile_type"]??"",
    tickerId: json["ticker_id"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "believers_count": believersCount,
    "avatar": avatar,
    "believed": believed,
    "profile_type": profileType,
    "ticker_id": tickerId,
  };
}
