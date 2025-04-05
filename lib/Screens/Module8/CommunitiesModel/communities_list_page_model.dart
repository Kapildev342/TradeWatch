import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

CommunitiesListInitialPage communitiesListInitialPageFromJson(String str) => CommunitiesListInitialPage.fromJson(json.decode(str));

String communitiesListInitialPageToJson(CommunitiesListInitialPage data) => json.encode(data.toJson());

class CommunitiesListInitialPage {
  RxList<TrendingDatum> trendingData;
  RxList<CommunityListDatum> communityListData;

  CommunitiesListInitialPage({
    required this.trendingData,
    required this.communityListData,
  });

  factory CommunitiesListInitialPage.fromJson(Map<String, dynamic> json) => CommunitiesListInitialPage(
        trendingData: RxList<TrendingDatum>.from((json["trending_data"] ?? []).map((x) => TrendingDatum.fromJson(x))),
        communityListData: RxList<CommunityListDatum>.from((json["community_list_data"] ?? []).map((x) => CommunityListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trending_data": List<dynamic>.from(trendingData.map((x) => x.toJson())),
        "community_list_data": List<dynamic>.from(communityListData.map((x) => x.toJson())),
      };
}

class CommunityListDatum {
  RxString id;
  RxString communityId;
  RxString name;
  RxList<CommunityFileElement> file;
  RxString userId;
  RxString about;
  RxString lastPosted;
  Rx<int> newPost;

  CommunityListDatum({
    required this.id,
    required this.communityId,
    required this.name,
    required this.file,
    required this.userId,
    required this.about,
    required this.lastPosted,
    required this.newPost,
  });

  factory CommunityListDatum.fromJson(Map<String, dynamic> json) => CommunityListDatum(
        id: (json["_id"] ?? "").toString().obs,
        communityId: (json["community_id"] ?? "").toString().obs,
        name: (json["name"] ?? "").toString().obs,
        file: RxList<CommunityFileElement>.from((json["file"] ?? []).map((x) => CommunityFileElement.fromJson(x))),
        userId: (json["user_id"] ?? userIdMain).toString().obs,
        about: (json["about"] ?? "").toString().obs,
        lastPosted: (DateFormat('yyyy-MM-dd hh:mm a', 'en_US')
                .format((json["last_posted"] != null ? DateTime.parse(json["last_posted"]) : DateTime.now()).toLocal().toLocal()))
            .obs,
        newPost: int.parse("${json["new_post"] ?? 0}").obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "community_id": communityId,
        "name": name,
        "file": List<dynamic>.from(file.map((x) => x.toJson())),
        "user_id": userId,
        "about": about,
        "last_posted": lastPosted,
        "new_post": newPost,
      };
}

class CommunityFileElement {
  RxString file;
  RxString fileType;

  CommunityFileElement({
    required this.file,
    required this.fileType,
  });

  factory CommunityFileElement.fromJson(Map<String, dynamic> json) => CommunityFileElement(
        file: (json["file"] ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png").toString().obs,
        fileType: (json["file_type"] ?? "image").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "file_type": fileType,
      };
}

class TrendingDatum {
  RxString id;
  RxString name;
  RxString code;
  RxList<CommunityFileElement> file;
  RxString about;
  Rx<bool> isJoined;
  Rx<bool> isPaidSubscription;
  Rx<int> membersCount;
  RxString userId;
  RxList<Member> members;

  TrendingDatum({
    required this.id,
    required this.name,
    required this.code,
    required this.file,
    required this.about,
    required this.isJoined,
    required this.isPaidSubscription,
    required this.membersCount,
    required this.userId,
    required this.members,
  });

  factory TrendingDatum.fromJson(Map<String, dynamic> json) => TrendingDatum(
        id: (json["_id"] ?? '').toString().obs,
        name: (json["name"] ?? "").toString().obs,
        code: (json["code"] ?? 'code').toString().obs,
        file: RxList<CommunityFileElement>.from((json["file"] ?? []).map((x) => CommunityFileElement.fromJson(x))),
        about: (json["about"] ?? '').toString().obs,
        isJoined: ((json["is_joined"] ?? false) as bool).obs,
        isPaidSubscription: (((json["subscription"] ?? "Free") == "Paid")).obs,
        membersCount: int.parse("${json["members_count"] ?? 0}").obs,
        userId: (json["user_id"] ?? '').toString().obs,
        members: RxList<Member>.from((json["members"] ?? []).map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "code": code,
        "file": List<dynamic>.from(file.map((x) => x.toJson())),
        "about": about,
        "is_joined": isJoined,
        "subscription": isPaidSubscription,
        "members_count": membersCount,
        "user_id": userId,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}

class Member {
  RxString id;
  RxString username;
  RxString avatar;

  Member({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: (json["_id"] ?? "").toString().obs,
        username: (json["username"] ?? "").toString().obs,
        avatar: (json["avatar"] ?? "").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar": avatar,
      };
}
