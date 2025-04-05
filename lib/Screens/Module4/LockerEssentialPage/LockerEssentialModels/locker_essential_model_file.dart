import 'dart:convert';

import 'package:intl/intl.dart';

LockerEssentialModel lockerEssentialModelFromJson(String str) => LockerEssentialModel.fromJson(json.decode(str));

String lockerEssentialModelToJson(LockerEssentialModel data) => json.encode(data.toJson());

class LockerEssentialModel {
  final bool status;
  final String message;
  final List<LockerEssentialResponse> response;
  final int totalCount;
  final int monthCounts;
  final int quarterCounts;
  final int yearCounts;

  LockerEssentialModel({
    required this.status,
    required this.message,
    required this.response,
    required this.totalCount,
    required this.monthCounts,
    required this.quarterCounts,
    required this.yearCounts,
  });

  factory LockerEssentialModel.fromJson(Map<String, dynamic> json) => LockerEssentialModel(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
        response:
            json["response"] == null ? [] : List<LockerEssentialResponse>.from(json["response"].map((x) => LockerEssentialResponse.fromJson(x))),
        totalCount: json["total_count"] ?? 0,
        monthCounts: json["month_counts"] ?? 0,
        quarterCounts: json["quater_counts"] ?? 0,
        yearCounts: json["year_counts"] ?? 0,
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

class LockerEssentialResponse {
  final String exchange;
  final String industry;
  final String categoryId;
  final String tickerId;
  final String reportDate;
  final String date;
  final String beforeAfterMarket;
  final double actual;
  final double estimate;
  final double difference;
  final int percent;
  final String id;
  final String economicId;
  final String name;
  final String code;
  final String logoUrl;
  final bool watchlist;

  LockerEssentialResponse({
    required this.exchange,
    required this.industry,
    required this.categoryId,
    required this.tickerId,
    required this.reportDate,
    required this.date,
    required this.beforeAfterMarket,
    required this.actual,
    required this.estimate,
    required this.difference,
    required this.percent,
    required this.id,
    required this.economicId,
    required this.name,
    required this.code,
    required this.logoUrl,
    required this.watchlist,
  });

  factory LockerEssentialResponse.fromJson(Map<String, dynamic> json) => LockerEssentialResponse(
      exchange: json["exchange"] ?? "",
      industry: json["industry"] ?? "",
      categoryId: json["category_id"] ?? "",
      tickerId: json["ticker_id"] ?? "",
      reportDate: json["report_date"] == null ? "-" : DateFormat("dd - MM - yyyy").format(DateTime.parse(json["report_date"]).toLocal()),
      date: json["date"] ?? "",
      beforeAfterMarket: json["before_after_market"] ?? "",
      //SvgPicture.asset(json["before_after_market"]=="AfterMarket"?"lib/Constants/Assets/NewAssets/LockerScreen/after_market.svg":"lib/Constants/Assets/NewAssets/LockerScreen/before_market.svg"),
      actual: json["actual"] == null ? 0.0 : json["actual"].toDouble(),
      estimate: json["estimate"] == null ? 0.0 : json["estimate"].toDouble(),
      difference: json["difference"] == null ? 0.0 : json["difference"].toDouble(),
      percent: json["percent"] ?? 0,
      id: json["_id"] ?? "",
      economicId: json["economic_id"] ?? "",
      name: json["name"] ?? "",
      code: json["code"] ?? "",
      logoUrl: json["logo_url"] ?? "",
      watchlist: json["watchlist"] ??
          false //SvgPicture.asset(json["watchlist"]?isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",:isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",),
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "industry": industry,
        "category_id": categoryId,
        "ticker_id": tickerId,
        "report_date": reportDate,
        "date": date,
        "before_after_market": beforeAfterMarket,
        "actual": actual,
        "estimate": estimate,
        "difference": difference,
        "percent": percent,
        "_id": id,
        "economic_id": economicId,
        "name": name,
        "code": code,
        "logo_url": logoUrl,
        "watchlist": watchlist,
      };
}
