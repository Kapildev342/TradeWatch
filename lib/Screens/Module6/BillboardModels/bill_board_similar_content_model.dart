
import 'dart:convert';

BillBoardSimilarContentModel billBoardSimilarContentModelFromJson(String str) => BillBoardSimilarContentModel.fromJson(json.decode(str));

String billBoardSimilarContentModelToJson(BillBoardSimilarContentModel data) => json.encode(data.toJson());

class BillBoardSimilarContentModel {
  final bool status;
  final String message;
  final List<Response> response;

  BillBoardSimilarContentModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory BillBoardSimilarContentModel.fromJson(Map<String, dynamic> json) => BillBoardSimilarContentModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: json["response"]==null?[]:List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
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
  final String exchange;
  final int likesCount;
  final int disLikesCount;
  final int viewsCount;
  final int shareCount;
  final int responseCount;
  final int status;
  final String companyName;
  final String publicView;
  final String postType;
  final int repostedCount;
  final int repostStatus;
  final String createdAt;
  final bool like;
  final bool dislike;
  final String username;
  final String userId;
  final String avatar;
  final String profileType;
  final int believersCount;
  final bool bookmarks;
  final bool believed;
  final bool repostBelieved;
  final List<dynamic> industry;

  Response({
    required this.id,
    required this.title,
    required this.content,
    required this.billboardType,
    required this.type,
    required this.files,
    required this.category,
    required this.exchange,
    required this.likesCount,
    required this.disLikesCount,
    required this.viewsCount,
    required this.shareCount,
    required this.responseCount,
    required this.status,
    required this.companyName,
    required this.publicView,
    required this.postType,
    required this.repostedCount,
    required this.repostStatus,
    required this.createdAt,
    required this.like,
    required this.dislike,
    required this.username,
    required this.userId,
    required this.avatar,
    required this.profileType,
    required this.believersCount,
    required this.bookmarks,
    required this.believed,
    required this.repostBelieved,
    required this.industry,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??"",
    title: json["title"]??"",
    content: json["content"]??"",
    billboardType: json["billboard_type"]??"",
    type: json["type"]??"",
    files: json["files"]==null?[]:List<dynamic>.from(json["files"].map((x) => x)),
    category: json["category"]??"",
    exchange: json["exchange"]??"",
    likesCount: json["likes_count"]??0,
    disLikesCount: json["dis_likes_count"]??0,
    viewsCount: json["views_count"]??0,
    shareCount: json["share_count"]??0,
    responseCount: json["response_count"]??0,
    status: json["status"]??0,
    companyName: json["company_name"]??"",
    publicView: json["public_view"]??'',
    postType: json["post_type"]??"",
    repostedCount: json["reposted_count"]??0,
    repostStatus: json["repost_status"]??0,
    createdAt: json["createdAt"]??"",
    like: json["like"]??false,
    dislike: json["dislike"]??false,
    username: json["username"]??"",
    userId: json["user_id"]??"",
    avatar: json["avatar"]??"",
    profileType: json["profile_type"]??"",
    believersCount: json["believers_count"]??0,
    bookmarks: json["bookmarks"]??false,
    believed: json["believed"]??false,
    repostBelieved: json["repost_believed"]??false,
    industry: json["industry"]==null?[]:List<dynamic>.from(json["industry"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "content": content,
    "billboard_type": billboardType,
    "type": type,
    "files": List<dynamic>.from(files.map((x) => x)),
    "category": category,
    "exchange": exchange,
    "likes_count": likesCount,
    "dis_likes_count": disLikesCount,
    "views_count": viewsCount,
    "share_count": shareCount,
    "response_count": responseCount,
    "status": status,
    "company_name": companyName,
    "public_view": publicView,
    "post_type": postType,
    "reposted_count": repostedCount,
    "repost_status": repostStatus,
    "createdAt": createdAt,
    "like": like,
    "dislike": dislike,
    "username": username,
    "user_id": userId,
    "avatar": avatar,
    "profile_type": profileType,
    "believers_count": believersCount,
    "bookmarks": bookmarks,
    "believed": believed,
    "repost_believed": repostBelieved,
    "industry": List<dynamic>.from(industry.map((x) => x)),
  };
}
