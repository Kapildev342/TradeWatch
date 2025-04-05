import 'dart:convert';

import '../../Module2/FeatureRequest/feature_response_model.dart';

BillBoardDescriptionModel billBoardDescriptionModelFromJson(String str) =>
    BillBoardDescriptionModel.fromJson(json.decode(str));

String billBoardDescriptionModelToJson(BillBoardDescriptionModel data) => json.encode(data.toJson());

class BillBoardDescriptionModel {
  final bool status;
  final String message;
  final Response response;
  final int postViewCounts;

  BillBoardDescriptionModel({
    required this.status,
    required this.message,
    required this.response,
    required this.postViewCounts,
  });

  factory BillBoardDescriptionModel.fromJson(Map<String, dynamic> json) => BillBoardDescriptionModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        postViewCounts: json["post_view_counts"] ?? "",
        response: Response.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "post_view_counts": postViewCounts,
        "response": response.toJson(),
      };
}

class Response {
  final String id;
  final String title;
  final String content;
  final String billboardType;
  final String type;
  final List<dynamic> files;
  final String category;
  final String categoryId;
  final String exchangeId;
  final List<dynamic> industries;
  final List<String> tickers;
  final bool allIndustries;
  final bool allTickers;
  final int likesCount;
  final int disLikesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final int reported;
  final int blocked;
  final int totalCount;
  final int reportCount;
  final int status;
  final bool typeGeneral;
  final String companyName;
  final String country;
  final PostUser postUserId;
  final List<dynamic> taggedUser;
  final String profileType;
  final String createdAt;
  final String updatedAt;
  final bool likes;
  final bool dislikes;
  final bool believed;
  final bool bookmark;
  final String publicView;
  final List<Industry> industry;
  final String postType;
  final String repostUser;
  final String repostId;
  final String repostAvatar;
  final String repostUsername;
  final String repostProfileType;
  final int repostedCount;
  final int repostStatus;
  final String repostType;

  Response({
    required this.id,
    required this.title,
    required this.content,
    required this.billboardType,
    required this.type,
    required this.files,
    required this.category,
    required this.categoryId,
    required this.exchangeId,
    required this.industries,
    required this.tickers,
    required this.allIndustries,
    required this.allTickers,
    required this.likesCount,
    required this.disLikesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.reported,
    required this.blocked,
    required this.totalCount,
    required this.reportCount,
    required this.status,
    required this.typeGeneral,
    required this.companyName,
    required this.country,
    required this.postUserId,
    required this.taggedUser,
    required this.profileType,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.dislikes,
    required this.believed,
    required this.bookmark,
    required this.publicView,
    required this.industry,
    required this.postType,
    required this.repostUser,
    required this.repostId,
    required this.repostAvatar,
    required this.repostUsername,
    required this.repostProfileType,
    required this.repostedCount,
    required this.repostStatus,
    required this.repostType,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        content: json["content"] ?? "",
        billboardType: json["billboard_type"] ?? "",
        type: json["type"] ?? "",
        files: json["files"] == null ? [] : List<dynamic>.from(json["files"].map((x) => x)),
        category: json["category"] ?? "",
        categoryId: json["category_id"] ?? "",
        exchangeId: json["exchange"] ?? "",
        industries: json["industries"] == null ? [] : List<dynamic>.from(json["industries"].map((x) => x)),
        tickers: json["tickers"] == null ? [] : List<String>.from(json["tickers"].map((x) => x)),
        allIndustries: json["allindustries"] ?? false,
        allTickers: json["alltickers"] ?? false,
        likesCount: json["likes_count"] ?? 0,
        disLikesCount: json["dis_likes_count"] ?? 0,
        viewsCount: json["views_count"] ?? 0,
        shareCount: json["share_count"] ?? 0,
        responseCount: json["response_count"] ?? 0,
        reported: json["reported"] ?? 0,
        blocked: json["blocked"] ?? 0,
        totalCount: json["total_count"] ?? 0,
        reportCount: json["report_count"] ?? 0,
        status: json["status"] ?? 0,
        typeGeneral: json["type_general"] ?? false,
        companyName: json["company_name"] ?? "",
        country: json["country"] ?? "",
        postUserId: PostUser.fromJson(json["user_id"] ?? {}),
        likes: json["likes"] ?? false,
        dislikes: json["dislikes"] ?? false,
        believed: json["believed"] ?? false,
        bookmark: json["bookmark"] ?? false,
        publicView: json["public_view"] ?? "",
        taggedUser: json["tagged_user"] == null ? [] : List<dynamic>.from(json["tagged_user"].map((x) => x)),
        profileType: json["profile_type"] ?? "",
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        updatedAt: json["updatedAt"] == null
            ? "few seconds ago"
            : readTimestampMain(DateTime.parse(json["updatedAt"]).millisecondsSinceEpoch),
        industry: json["industry"] == null ? [] : List<Industry>.from(json["industry"].map((x) => Industry.fromJson(x))),
        postType: json["post_type"] ?? "",
        repostUser: json["repost_user"] ?? "",
        repostId: json["repost_id"] ?? "",
        repostAvatar: json["repost_avatar"] ?? "",
        repostUsername: json["repost_username"] ?? "",
        repostProfileType: json["repost_profile_type"] ?? "",
        repostedCount: json["reposted_count"] ?? 0,
        repostStatus: json["repost_status"] ?? 0,
        repostType: json["repost_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "billboard_type": billboardType,
        "type": type,
        "files": List<dynamic>.from(files.map((x) => x)),
        "category": category,
        "category_id": categoryId,
        "exchange": exchangeId,
        "industries": List<dynamic>.from(industries.map((x) => x)),
        "tickers": List<dynamic>.from(tickers.map((x) => x)),
        "allindustries": allIndustries,
        "alltickers": allTickers,
        "likes_count": likesCount,
        "dis_likes_count": disLikesCount,
        "views_count": viewsCount,
        "share_count": shareCount,
        "response_count": responseCount,
        "reported": reported,
        "blocked": blocked,
        "total_count": totalCount,
        "report_count": reportCount,
        "status": status,
        "type_general": typeGeneral,
        "company_name": companyName,
        "country": country,
        "user_id": postUserId.toJson(),
        "likes": likes,
        "dislikes": dislikes,
        "believed": believed,
        "bookmark": bookmark,
        "public_view": publicView,
        "tagged_user": List<dynamic>.from(taggedUser.map((x) => x)),
        "profile_type": profileType,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "industry": industry,
        "post_type": postType,
        "repost_user": repostUser,
        "repost_id": repostId,
        "repost_avatar": repostAvatar,
        "repost_username": repostUsername,
        "repost_profile_type": repostProfileType,
        "reposted_count": repostedCount,
        "repost_status": repostStatus,
        "repost_type": repostType,
      };
}

class PostUser {
  final String id;
  final String tickerId;
  final String userName;
  final String userAvatar;
  final String profileType;
  final int believersCount;

  PostUser({
    required this.id,
    required this.tickerId,
    required this.userName,
    required this.userAvatar,
    required this.profileType,
    required this.believersCount,
  });

  factory PostUser.fromJson(Map<String, dynamic> json) => PostUser(
        id: json["_id"] ?? "",
        tickerId: json["ticker_id"] ?? "",
        userName: json["username"] ?? "",
        userAvatar: json["thumbnail"] ?? "",
        profileType: json["profile_type"] ?? "",
        believersCount: json["believers_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "ticker_id": tickerId,
        "username": userName,
        "thumbnail": userAvatar,
        "profile_type": profileType,
        "believers_count": believersCount,
      };
}

class Industry {
  final String id;
  final String name;
  final String categoryId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String category;

  Industry({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory Industry.fromJson(Map<String, dynamic> json) => Industry(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        categoryId: json["category_id"] ?? "",
        status: json["status"] ?? 0,
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        category: json["category"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category_id": categoryId,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "category": category,
      };
}
