
import 'dart:convert';

import 'package:intl/intl.dart';

LockerIpoEssentialModel lockerIpoEssentialModelFromJson(String str) => LockerIpoEssentialModel.fromJson(json.decode(str));

String lockerIpoEssentialModelToJson(LockerIpoEssentialModel data) => json.encode(data.toJson());

class LockerIpoEssentialModel {
  final bool status;
  final String message;
  final List<LockerIpoEssentialResponse> response;
  final int totalCount;
  final int monthCounts;
  final int quarterCounts;
  final int yearCounts;

  LockerIpoEssentialModel({
    required this.status,
    required this.message,
    required this.response,
    required this.totalCount,
    required this.monthCounts,
    required this.quarterCounts,
    required this.yearCounts,
  });

  factory LockerIpoEssentialModel.fromJson(Map<String, dynamic> json) => LockerIpoEssentialModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: json["response"]==null?[]:List<LockerIpoEssentialResponse>.from(json["response"].map((x) => LockerIpoEssentialResponse.fromJson(x))),
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

class LockerIpoEssentialResponse {
  final String exchange;
  final String id;
  final String tickerId;
  final String startDate;
  final String filingDate;
  final String amendedDate;
  final double priceFrom;
  final double priceTo;
  final double offerPrice;
  final int shares;
  final String dealType;
  final String name;
  final String code;
  final String logoUrl;
  final String industry;

  LockerIpoEssentialResponse({
    required this.exchange,
    required this.id,
    required this.tickerId,
    required this.startDate,
    required this.filingDate,
    required this.amendedDate,
    required this.priceFrom,
    required this.priceTo,
    required this.offerPrice,
    required this.shares,
    required this.dealType,
    required this.name,
    required this.code,
    required this.logoUrl,
    required this.industry,
  });

  factory LockerIpoEssentialResponse.fromJson(Map<String, dynamic> json) => LockerIpoEssentialResponse(
    exchange: json["exchange"]??"",
    id: json["_id"]??"",
    tickerId: json["ticker_id"]??"",
    startDate: json["start_date"]==null?"_":DateFormat("dd - MM - yyyy").format(DateTime.parse(json["start_date"]).toLocal()),
    filingDate: json["filing_date"]==null?"_":DateFormat("dd - MM - yyyy").format(DateTime.parse(json["filing_date"]).toLocal()),//json["filing_date"]??"",
    amendedDate: json["amended_date"]==null?"_":DateFormat("dd - MM - yyyy").format(DateTime.parse(json["amended_date"]).toLocal()),//json["amended_date"]??"",
    priceFrom: json["price_from"]==null?0.0:json["price_from"].toDouble(),
    priceTo: json["price_to"]==null?0.0:json["price_to"].toDouble(),
    offerPrice: json["offer_price"]==null?0.0:json["offer_price"].toDouble(),
    shares: json["shares"]??0,
    dealType: json["deal_type"]??"",
    name: json["name"]??"",
    code: json["code"]??"",
    logoUrl: json["logo_url"]??"",
    industry: json["industry"]??"",
  );

  Map<String, dynamic> toJson() => {
    "exchange": exchange,
    "_id": id,
    "ticker_id": tickerId,
    "start_date": startDate,
    "filing_date": filingDate,
    "amended_date": amendedDate,
    "price_from": priceFrom,
    "price_to": priceTo,
    "offer_price": offerPrice,
    "shares": shares,
    "deal_type": dealType,
    "name": name,
    "code": code,
    "logo_url": logoUrl,
    "industry": industry,
  };
}
