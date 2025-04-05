
import 'dart:convert';

GeneralDataModel generalDataModelFromJson(String str) => GeneralDataModel.fromJson(json.decode(str));

String generalDataModelToJson(GeneralDataModel data) => json.encode(data.toJson());

class GeneralDataModel {
  final bool status;
  final String message;
  final GeneralDataResponse response;

  GeneralDataModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory GeneralDataModel.fromJson(Map<String, dynamic> json) => GeneralDataModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: GeneralDataResponse.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
  };
}

class GeneralDataResponse {
  final List<Category> category;
  final List<Exchange> exchange;
  final General general;
  final List<String> avatars;

  GeneralDataResponse({
    required this.category,
    required this.exchange,
    required this.general,
    required this.avatars,
  });

  factory GeneralDataResponse.fromJson(Map<String, dynamic> json) => GeneralDataResponse(
    category: json["category"]==null?[]:List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    exchange:  json["exchange"]==null?[]:List<Exchange>.from(json["exchange"].map((x) => Exchange.fromJson(x))),
    general: General.fromJson(json["general"]??{}),
    avatars:  json["avatars"]==null?[]:List<String>.from(json["avatars"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
    "exchange": List<dynamic>.from(exchange.map((x) => x.toJson())),
    "general": general.toJson(),
    "avatars": List<dynamic>.from(avatars.map((x) => x)),
  };
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String image;
  final int status;
  final int position;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.status,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"]??"",
    name: json["name"]??"",
    slug: json["slug"]??"",
    image: json["image"]??"",
    status: json["status"]??0,
    position: json["position"]??0,
    createdAt: json["createdAt"]??"",
    updatedAt: json["updatedAt"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "slug": slug,
    "image": image,
    "status": status,
    "position": position,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Exchange {
  final String id;
  final String name;
  final String code;
  final String operatingMic;
  final String country;
  final String currency;
  final int status;
  final String createdAt;
  final String updatedAt;

  Exchange({
    required this.id,
    required this.name,
    required this.code,
    required this.operatingMic,
    required this.country,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) => Exchange(
    id: json["_id"]??"",
    name: json["name"]??"",
    code: json["code"]??"",
    operatingMic: json["OperatingMIC"]??"",
    country: json["Country"]??'',
    currency: json["Currency"]??"",
    status: json["status"]??0,
    createdAt: json["createdAt"]??"",
    updatedAt: json["updatedAt"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "code": code,
    "OperatingMIC": operatingMic,
    "Country": country,
    "Currency": currency,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class General {
  final String siteTitle;
  final String siteUrl;
  final String siteEmail;
  final String facebookPageLink;
  final String linkedinPageLink;
  final String instagramPageLink;
  final String twitterPageLink;
  final String profile;
  final String favicon;
  final String logo;
  final List<String> about;
  final int generalNewsSkip;
  final String notification;

  General({
    required this.siteTitle,
    required this.siteUrl,
    required this.siteEmail,
    required this.facebookPageLink,
    required this.linkedinPageLink,
    required this.instagramPageLink,
    required this.twitterPageLink,
    required this.profile,
    required this.favicon,
    required this.logo,
    required this.about,
    required this.generalNewsSkip,
    required this.notification,
  });

  factory General.fromJson(Map<String, dynamic> json) => General(
    siteTitle: json["site_title"]??'',
    siteUrl: json["site_url"]??"",
    siteEmail: json["site_email"]??"",
    facebookPageLink: json["facebook_page_link"]??"",
    linkedinPageLink: json["linkedin_page_link"]??"",
    instagramPageLink: json["instagram_page_link"]??"",
    twitterPageLink: json["twitter_page_link"]??"",
    profile: json["profile"]??"",
    favicon: json["favicon"]??"",
    logo: json["logo"]??"",
    about: json["about"]==null?[]:List<String>.from(json["about"].map((x) => x)),
    generalNewsSkip: json["general_news_skip"]??0,
    notification: json["notification"]??"",
  );

  Map<String, dynamic> toJson() => {
    "site_title": siteTitle,
    "site_url": siteUrl,
    "site_email": siteEmail,
    "facebook_page_link": facebookPageLink,
    "linkedin_page_link": linkedinPageLink,
    "instagram_page_link": instagramPageLink,
    "twitter_page_link": twitterPageLink,
    "profile": profile,
    "favicon": favicon,
    "logo": logo,
    "about": List<dynamic>.from(about.map((x) => x)),
    "general_news_skip": generalNewsSkip,
    "notification": notification,
  };
}
