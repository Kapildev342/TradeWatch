// To parse this JSON data, do
//
//     final modelSample = modelSampleFromJson(jsonString);

import 'dart:convert';

ModelSample modelSampleFromJson(String str) => ModelSample.fromJson(json.decode(str));

String modelSampleToJson(ModelSample data) => json.encode(data.toJson());

class ModelSample {
  final List<bool> news;
  final List<bool> videos;
  final List<bool> forums;
  final List<bool> surveys;
  final List<bool> users;

  ModelSample({
    required this.news,
    required this.videos,
    required this.forums,
    required this.surveys,
    required this.users,
  });

  factory ModelSample.fromJson(Map<String, dynamic> json) => ModelSample(
    news:json["news"]==null?[]: List<bool>.from(json["news"].map((x) => x)),
    videos: json["videos"]==null?[]:List<bool>.from(json["videos"].map((x) => x)),
    forums: json["forums"]==null?[]:List<bool>.from(json["forums"].map((x) => x)),
    surveys: json["surveys"]==null?[]:List<bool>.from(json["surveys"].map((x) => x)),
    users: json["users"]==null?[]:List<bool>.from(json["users"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "news": List<dynamic>.from(news.map((x) => x)),
    "videos": List<dynamic>.from(videos.map((x) => x)),
    "forums": List<dynamic>.from(forums.map((x) => x)),
    "surveys": List<dynamic>.from(surveys.map((x) => x)),
    "users": List<dynamic>.from(users.map((x) => x)),
  };
}
