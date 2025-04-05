import 'dart:convert';

OnBoardingScreenInitialData onBoardingScreenInitialDataFromJson(String str) =>
    OnBoardingScreenInitialData.fromJson(json.decode(str));

String onBoardingScreenInitialDataToJson(OnBoardingScreenInitialData data) => json.encode(data.toJson());

class OnBoardingScreenInitialData {
  final List<Response> response;

  OnBoardingScreenInitialData({
    required this.response,
  });

  factory OnBoardingScreenInitialData.fromJson(Map<String, dynamic> json) => OnBoardingScreenInitialData(
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  final String topic;
  final String description;
  final String imageUrl;

  Response({
    required this.topic,
    required this.description,
    required this.imageUrl,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        topic: json["topic"] ?? "",
        description: json["description"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "description": description,
        "imageUrl": imageUrl,
      };
}
