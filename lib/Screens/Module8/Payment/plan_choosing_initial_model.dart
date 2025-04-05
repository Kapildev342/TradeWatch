import 'dart:convert';

import 'package:flutter/material.dart';

PlanChoosingInitialModel planChoosingInitialModelFromJson(String str) => PlanChoosingInitialModel.fromJson(json.decode(str));

String planChoosingInitialModelToJson(PlanChoosingInitialModel data) => json.encode(data.toJson());

class PlanChoosingInitialModel {
  final List<PlanChoosingInitialResponse> response;

  PlanChoosingInitialModel({
    required this.response,
  });

  factory PlanChoosingInitialModel.fromJson(Map<String, dynamic> json) => PlanChoosingInitialModel(
        response: List<PlanChoosingInitialResponse>.from((json["response"] ?? []).map((x) => PlanChoosingInitialResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class PlanChoosingInitialResponse {
  final String subscriptionPeriod;
  final int paymentAmount;
  final int discount;
  final int trailPeriod;
  final Color initialColor;
  final Color endColor;

  PlanChoosingInitialResponse({
    required this.subscriptionPeriod,
    required this.paymentAmount,
    required this.discount,
    required this.trailPeriod,
    required this.initialColor,
    required this.endColor,
  });

  factory PlanChoosingInitialResponse.fromJson(Map<String, dynamic> json) => PlanChoosingInitialResponse(
        subscriptionPeriod: json["subscription_period"] ?? "",
        paymentAmount: json["payment_amount"] ?? "",
        discount: json["discount"] ?? "",
        trailPeriod: json["trail_period"] ?? "",
        initialColor: json["initial_color"] ?? Colors.white,
        endColor: json["end_color"] ?? Colors.white,
      );

  Map<String, dynamic> toJson() => {
        "subscription_period": subscriptionPeriod,
        "payment_amount": paymentAmount,
        "discount": discount,
        "trail_period": trailPeriod,
        "initial_color": initialColor,
        "end_color": endColor,
      };
}
