import 'dart:convert';

import 'package:get/get.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_page_initial_model.dart';

MembersListApiModel membersListApiModelFromJson(String str) => MembersListApiModel.fromJson(json.decode(str));

String membersListApiModelToJson(MembersListApiModel data) => json.encode(data.toJson());

class MembersListApiModel {
  final bool status;
  final String message;
  final RxList<MembersList> response;

  MembersListApiModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory MembersListApiModel.fromJson(Map<String, dynamic> json) => MembersListApiModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: RxList<MembersList>.from((json["response"] ?? []).map((x) => MembersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}
