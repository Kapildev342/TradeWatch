import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'communities_list_page_model.dart';
import 'communities_page_initial_model.dart';

CommunitiesDetailsApiModel communitiesDetailsApiModelFromJson(String str) => CommunitiesDetailsApiModel.fromJson(json.decode(str));

String communitiesDetailsApiModelToJson(CommunitiesDetailsApiModel data) => json.encode(data.toJson());

class CommunitiesDetailsApiModel {
  final bool status;
  final String message;
  final CommunitiesDetailsResponse response;

  CommunitiesDetailsApiModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory CommunitiesDetailsApiModel.fromJson(Map<String, dynamic> json) => CommunitiesDetailsApiModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        response: CommunitiesDetailsResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": response.toJson(),
      };
}

class CommunitiesDetailsResponse {
  final String id;
  final String name;
  final List<CommunityFileElement> file;
  final String about;
  final String rules;
  final String category;
  final String categoryId;
  final String exchange;
  final String country;
  final String exchangeId;
  final List<String> industry;
  final List<String> tickers;
  final String subscription;
  final List<SubscriptionType> subscriptionType;
  final String postType;
  final List<String> postAccess;
  final int postCounts;
  final int membersCount;
  final String userId;
  final String username;
  final String createdAt;
  final String updatedAt;
  final int status;
  final String lastPosted;
  final RxList<MembersList> admins;

  // final RxList<MembersList> subAdmins;
  // final RxList<MembersList> moderators;
  final int avgPost;
  final String code;
  final MemberDetails memberResponse;

  CommunitiesDetailsResponse({
    required this.id,
    required this.name,
    required this.file,
    required this.about,
    required this.rules,
    required this.category,
    required this.categoryId,
    required this.exchange,
    required this.country,
    required this.exchangeId,
    required this.industry,
    required this.tickers,
    required this.subscription,
    required this.subscriptionType,
    required this.postType,
    required this.postAccess,
    required this.postCounts,
    required this.membersCount,
    required this.userId,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.lastPosted,
    required this.admins,
    // required this.subAdmins,
    // required this.moderators,
    required this.avgPost,
    required this.code,
    required this.memberResponse,
  });

  factory CommunitiesDetailsResponse.fromJson(Map<String, dynamic> json) => CommunitiesDetailsResponse(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        file: List<CommunityFileElement>.from((json["file"] ?? []).map((x) => CommunityFileElement.fromJson(x))),
        about: json["about"] ?? "",
        rules: json["rules"] ?? "",
        category: json["category"] ?? "",
        categoryId: json["category_id"] ?? "",
        exchange: json["exchange"] ?? "",
        country: json["country"] ?? "",
        exchangeId: json["exchange_id"] ?? "",
        industry: List<String>.from((json["industry"] ?? []).map((x) => x)),
        tickers: List<String>.from((json["tickers"] ?? []).map((x) => x)),
        subscription: json["subscription"] ?? "",
        subscriptionType: List<SubscriptionType>.from((json["subscription_type"] ?? []).map((x) => SubscriptionType.fromJson(x))),
        postType: json["post_type"] ?? "",
        postAccess: List<String>.from((json["post_access"] ?? []).map((x) => x)),
        postCounts: json["post_counts"] ?? 0,
        membersCount: json["members_count"] ?? 0,
        userId: json["user_id"] ?? "",
        username: json["username"] ?? "",
        createdAt: DateFormat("MMM dd, yyyy").format(DateTime.parse(json["createdAt"] ?? "2024-01-30T07:12:09.946Z")),
        updatedAt: json["updatedAt"] ?? "",
        status: json["status"] ?? 0,
        lastPosted: json["last_posted"] ?? "",
        admins: RxList<MembersList>.from((json["admins"] ?? []).map((x) => MembersList.fromJson(x))),
        // subAdmins: RxList<MembersList>.from((json["sub_admins"] ?? []).map((x) => MembersList.fromJson(x))),
        // moderators: RxList<MembersList>.from((json["moderators"] ?? []).map((x) => MembersList.fromJson(x))),
        avgPost: json["avg_post"] ?? 0,
        code: json["code"] ?? "code",
        memberResponse: MemberDetails.fromJson(json["memberDetails"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "file": List<dynamic>.from(file.map((x) => x)),
        "about": about,
        "rules": rules,
        "category": category,
        "category_id": categoryId,
        "exchange": exchange,
        "country": country,
        "exchange_id": exchangeId,
        "industry": List<String>.from(industry.map((x) => x)),
        "tickers": List<String>.from(tickers.map((x) => x)),
        "subscription": subscription,
        "subscription_type": List<dynamic>.from(subscriptionType.map((x) => x.toJson())),
        "post_type": postType,
        "post_access": List<dynamic>.from(postAccess.map((x) => x)),
        "post_counts": postCounts,
        "members_count": membersCount,
        "user_id": userId,
        "username": username,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "status": status,
        "last_posted": lastPosted,
        "admins": List<dynamic>.from(admins.map((x) => x.toJson())),
        "avg_post": avgPost,
        "code": code,
        "memberDetails": memberResponse,
      };
}

class SubscriptionType {
  final String type;
  final int trailPeriod;
  final int amount;
  final double discountPer;
  final String id;

  SubscriptionType({
    required this.type,
    required this.trailPeriod,
    required this.amount,
    required this.discountPer,
    required this.id,
  });

  factory SubscriptionType.fromJson(Map<String, dynamic> json) => SubscriptionType(
        type: json["type"] ?? "",
        trailPeriod: json["trail_period"] ?? 0,
        amount: json["amount"] ?? 0,
        discountPer: json["discount_per"].toDouble() ?? 0.0,
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "trail_period": trailPeriod,
        "amount": amount,
        "discount_per": discountPer,
        "_id": id,
      };
}

class MemberDetails {
  final bool superAccess;
  final String id;
  final String communityId;
  final String userId;
  final String username;
  final String avatar;
  final String role;
  final String createdAt;
  final String updatedAt;
  final int status;

  MemberDetails({
    required this.superAccess,
    required this.id,
    required this.communityId,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory MemberDetails.fromJson(Map<String, dynamic> json) => MemberDetails(
        superAccess: json["super_access"] ?? false,
        id: json["_id"] ?? "",
        communityId: json["community_id"] ?? "",
        userId: json["user_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
        role: json["role"] ?? "",
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        status: json["status"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "super_access": superAccess,
        "_id": id,
        "community_id": communityId,
        "user_id": userId,
        "username": username,
        "avatar": avatar,
        "role": role,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "status": status,
      };
}
