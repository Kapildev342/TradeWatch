
import 'dart:convert';

import 'package:intl/intl.dart';

LockerSplitEssentialModel lockerSplitEssentialModelFromJson(String str) => LockerSplitEssentialModel.fromJson(json.decode(str));

String lockerSplitEssentialModelToJson(LockerSplitEssentialModel data) => json.encode(data.toJson());

class LockerSplitEssentialModel {
  final bool status;
  final String message;
  final List<LockerSplitEssentialResponse> response;
  final int totalCount;
  final int monthCounts;
  final int quarterCounts;
  final int yearCounts;

  LockerSplitEssentialModel({
    required this.status,
    required this.message,
    required this.response,
    required this.totalCount,
    required this.monthCounts,
    required this.quarterCounts,
    required this.yearCounts,
  });

  factory LockerSplitEssentialModel.fromJson(Map<String, dynamic> json) => LockerSplitEssentialModel(
    status: json["status"]??false,
    message: json["message"]??'',
    response: json["response"]==null?[]:List<LockerSplitEssentialResponse>.from(json["response"].map((x) => LockerSplitEssentialResponse.fromJson(x))),
    totalCount: json["total_count"]??0,
    monthCounts: json["month_counts"]??0,
    quarterCounts: json["quater_counts"]??0,
    yearCounts: json["year_counts"]??0,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "total_count": totalCount,
    "month_counts": monthCounts,
    "quater_counts": quarterCounts,
    "year_counts": yearCounts,
  };
}

class LockerSplitEssentialResponse {
  final String id;
  final String industry;
  final String tickerId;
  final String splitDate;
  final String optionable;
  final int oldShares;
  final int newShares;
  final String name;
  final String code;
  final String logoUrl;

  LockerSplitEssentialResponse({
    required this.id,
    required this.industry,
    required this.tickerId,
    required this.splitDate,
    required this.optionable,
    required this.oldShares,
    required this.newShares,
    required this.name,
    required this.code,
    required this.logoUrl,
  });

  factory LockerSplitEssentialResponse.fromJson(Map<String, dynamic> json) => LockerSplitEssentialResponse(
    id: json["_id"]??"",
    industry: json["industry"]??"",
    tickerId: json["ticker_id"]??"",
    splitDate: json["split_date"]==null?"-":DateFormat("dd - MM - yyyy").format(DateTime.parse(json["split_date"]).toLocal()),
    optionable: json["optionable"]??"",
    oldShares: json["old_shares"]??0,
    newShares: json["new_shares"]??0,
    name: json["name"]??"",
    code: json["code"]??"",
    logoUrl: json["logo_url"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "industry": industry,
    "ticker_id": tickerId,
    "split_date": splitDate,
    "optionable": optionable,
    "old_shares": oldShares,
    "new_shares": newShares,
    "name": name,
    "code": code,
    "logo_url": logoUrl,
  };
}
