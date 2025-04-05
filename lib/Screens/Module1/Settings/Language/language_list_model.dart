
import 'dart:convert';

LanguageListModel languageListModelFromJson(String str) => LanguageListModel.fromJson(json.decode(str));

String languageListModelToJson(LanguageListModel data) => json.encode(data.toJson());

class LanguageListModel {
  final bool status;
  final String message;
  final List<LanguageResponse> response;
  final int limit;
  final String defaultLanguage;

  LanguageListModel({
    required this.status,
    required this.message,
    required this.response,
    required this.limit,
    required this.defaultLanguage,
  });

  factory LanguageListModel.fromJson(Map<String, dynamic> json) => LanguageListModel(
    status: json["status"]??false,
    message: json["message"]??"",
    defaultLanguage: json["default_language"]??"",
    limit: json["popular_limit"]??0,
    response: json["response"]==null?[]:List<LanguageResponse>.from(json["response"].map((x) => LanguageResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "default_language": defaultLanguage,
    "popular_limit": limit,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class LanguageResponse {
  final String code;
  final String name;
  final String nativeName;

  LanguageResponse({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  factory LanguageResponse.fromJson(Map<String, dynamic> json) => LanguageResponse(
    code: json["code"]??"",
    name: json["name"]??"",
    nativeName: json["nativeName"]??"",
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "nativeName": nativeName,
  };
}
