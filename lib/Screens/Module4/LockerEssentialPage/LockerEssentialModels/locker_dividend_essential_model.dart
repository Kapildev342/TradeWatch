
import 'dart:convert';

import 'package:intl/intl.dart';

LockerDividendEssentialModel lockerDividendEssentialModelFromJson(String str) => LockerDividendEssentialModel.fromJson(json.decode(str));

String lockerDividendEssentialModelToJson(LockerDividendEssentialModel data) => json.encode(data.toJson());

class LockerDividendEssentialModel {
  final bool status;
  final String message;
  final List<LockerDividendEssentialResponse> response;
  final int totalCount;
  final int monthCounts;
  final int quarterCounts;
  final int yearCounts;

  LockerDividendEssentialModel({
    required this.status,
    required this.message,
    required this.response,
    required this.totalCount,
    required this.monthCounts,
    required this.quarterCounts,
    required this.yearCounts,
  });

  factory LockerDividendEssentialModel.fromJson(Map<String, dynamic> json) => LockerDividendEssentialModel(
    status: json["status"]??false,
    message: json["message"]??'',
    response: json["response"]==null?[]:List<LockerDividendEssentialResponse>.from(json["response"].map((x) => LockerDividendEssentialResponse.fromJson(x))),
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

class LockerDividendEssentialResponse {
  final String exchange;
  final String industry;
  final String categoryId;
  final String tickerId;
  final String date;
  final String year;
  final double value;
  final String id;
  final String dividendId;
  final String name;
  final String code;
  final String logoUrl;
  final bool watchlist;

  LockerDividendEssentialResponse({
    required this.exchange,
    required this.industry,
    required this.categoryId,
    required this.tickerId,
    required this.date,
    required this.year,
    required this.value,
    required this.id,
    required this.dividendId,
    required this.name,
    required this.code,
    required this.logoUrl,
    required this.watchlist,
  });

  factory LockerDividendEssentialResponse.fromJson(Map<String, dynamic> json) => LockerDividendEssentialResponse(
    exchange: json["exchange"]??"",
    industry: json["industry"]??"",
    categoryId: json["category_id"]??"",
    tickerId: json["ticker_id"]??"",
    date: json["date"]==null?"-":DateFormat("dd - MM - yyyy").format(DateTime.parse(json["date"]).toLocal()),
    year: json["date"]==null?"-":DateFormat("yyyy").format(DateTime.parse(json["date"]).toLocal()),
    value: json["value"]==null?0.0:json["value"].toDouble(),
    id: json["_id"]??"",
    dividendId: json["dividend_id"]??"",
    name: json["name"]??"",
    code: json["code"]??"",
    logoUrl: json["logo_url"]??"",
    watchlist: json["watchlist"]??false,
  );

  Map<String, dynamic> toJson() => {
    "exchange": exchange,
    "industry": industry,
    "category_id": categoryId,
    "ticker_id": tickerId,
    "date": date,
    "value": value,
    "_id": id,
    "dividend_id": dividendId,
    "name": name,
    "code": code,
    "logo_url": logoUrl,
    "watchlist": watchlist,
  };
}
