
import 'dart:convert';

LockerScreenModel lockerScreenModelFromJson(String str) => LockerScreenModel.fromJson(json.decode(str));

String lockerScreenModelToJson(LockerScreenModel data) => json.encode(data.toJson());

class LockerScreenModel {
  final List<Response> response;

  LockerScreenModel({
    required this.response,
  });

  factory LockerScreenModel.fromJson(Map<String, dynamic> json) => LockerScreenModel(
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  final String topic;
  final List<ResponseList> responseList;

  Response({
    required this.topic,
    required this.responseList,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    topic: json["topic"],
    responseList: List<ResponseList>.from(json["responseList"].map((x) => ResponseList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "topic": topic,
    "responseList": List<dynamic>.from(responseList.map((x) => x.toJson())),
  };
}

class ResponseList {
  final String imageUrl;
  final String name;
  final String id;

  ResponseList({
    required this.imageUrl,
    required this.name,
    required this.id,
  });

  factory ResponseList.fromJson(Map<String, dynamic> json) => ResponseList(
    imageUrl: json["imageUrl"]??"",
    name: json["name"]??"",
    id: json["id"]??"0",
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "name": name,
    "id": id,
  };
}
