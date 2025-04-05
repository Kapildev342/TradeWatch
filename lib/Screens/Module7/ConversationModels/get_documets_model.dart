
import 'dart:convert';

import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

GetDocumentsModel getDocumentsModelFromJson(String str) => GetDocumentsModel.fromJson(json.decode(str));

String getDocumentsModelToJson(GetDocumentsModel data) => json.encode(data.toJson());

class GetDocumentsModel {
  final bool status;
  final String message;
  final List<Response> response;

  GetDocumentsModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory GetDocumentsModel.fromJson(Map<String, dynamic> json) => GetDocumentsModel(
    status: json["status"]??false,
    message: json["message"]??"",
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
  final String createdAt;
  final String file;
  final String fileName;
  final String fileType;

  Response({
    required this.id,
    required this.createdAt,
    required this.file,
    required this.fileName,
    required this.fileType,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??"",
    createdAt: json["createdAt"]==null?"few seconds ago":billBoardFunctionsMain.readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
    file: json["file"]??"",
    fileName: json["file_name"]??"",
    fileType: json["file_type"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "createdAt": createdAt,
    "file": file,
    "file_name": fileName,
    "file_type": fileType,
  };
}
