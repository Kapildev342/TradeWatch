import 'dart:convert';

LtiTickerDataChartValuesModel ltiTickerDataChartValuesModelFromJson(String str) =>
    LtiTickerDataChartValuesModel.fromJson(json.decode(str));

String ltiTickerDataChartValuesModelToJson(LtiTickerDataChartValuesModel data) => json.encode(data.toJson());

class LtiTickerDataChartValuesModel {
  final bool status;
  final String message;
  final List<Response> response;

  LtiTickerDataChartValuesModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LtiTickerDataChartValuesModel.fromJson(Map<String, dynamic> json) => LtiTickerDataChartValuesModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: List<Response>.from((json["response"] ?? []).map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  final DateTime createdTime;
  final int close;
  final String id;

  Response({
    required this.createdTime,
    required this.close,
    required this.id,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        createdTime: DateTime.parse(json["created_time"]),
        close: (json["close"] ?? 0).toInt(),
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "created_time": createdTime,
        "close": close,
        "_id": id,
      };
}
