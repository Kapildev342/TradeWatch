
import 'dart:convert';

import 'package:intl/intl.dart';

LockerDividendHistoryModel lockerDividendHistoryModelFromJson(String str) => LockerDividendHistoryModel.fromJson(json.decode(str));

String lockerDividendHistoryModelToJson(LockerDividendHistoryModel data) => json.encode(data.toJson());

class LockerDividendHistoryModel {
  final bool status;
  final String message;
  final List<LockerDividendHistoryResponse> response;

  LockerDividendHistoryModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LockerDividendHistoryModel.fromJson(Map<String, dynamic> json) => LockerDividendHistoryModel(
    status: json["status"]??false,
    message: json["message"]??'',
    response: json["response"]==null?[]:List<LockerDividendHistoryResponse>.from(json["response"].map((x) => LockerDividendHistoryResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class LockerDividendHistoryResponse {
  final String id;
  final String exchange;
  final String date;
  final String year;
  final double value;

  LockerDividendHistoryResponse({
    required this.id,
    required this.exchange,
    required this.date,
    required this.year,
    required this.value,
  });

  factory LockerDividendHistoryResponse.fromJson(Map<String, dynamic> json) => LockerDividendHistoryResponse(
    id: json["_id"]??"",
    exchange: json["exchange"]??"",
    date: json["date"]==null?"-":DateFormat("dd - MM - yyyy").format(DateTime.parse(json["date"]).toLocal()),
    year: json["date"]==null?"-":DateFormat("yyyy").format(DateTime.parse(json["date"]).toLocal()),
    value: json["value"]==null?0.0:json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "exchange": exchange,
    "date": date,
    "value": value,
  };
}
