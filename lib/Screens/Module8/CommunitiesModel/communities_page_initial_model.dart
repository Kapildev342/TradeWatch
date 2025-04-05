import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'communities_list_page_model.dart';

communitiesPageInitialModelFromJson(String str) => CommunitiesPageInitialModel.fromJson(json.decode(str));

String communitiesPageInitialModelToJson(CommunitiesPageInitialModel data) => json.encode(data.toJson());

class CommunitiesPageInitialModel {
  final CommunityData communityData;

  CommunitiesPageInitialModel({
    required this.communityData,
  });

  factory CommunitiesPageInitialModel.fromJson(Map<String, dynamic> json) => CommunitiesPageInitialModel(
        communityData: CommunityData.fromJson(json["community_data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "community_data": communityData.toJson(),
      };
}

class CommunityData {
  final Rx<String> image;
  final Rx<bool> isDetailShown;
  final Rx<bool> isSearchEnabled;
  final Rx<bool> isJoined;
  final Rx<String> name;
  final Rx<String> code;
  final RxList<MembersList> totalMembers;
  final RxList<MembersList> adminsList;
  final RxList<MembersList> subAdminsList;
  final RxList<MembersList> moderatorsList;
  final RxList<MembersList> membersList;
  final RxList<MembersList> roles;
  final Rx<bool> isPaidSubscription;
  final Rx<String> userAuthority;
  final Rx<String> about;
  final Rx<String> creationDate;
  final Rx<String> averagePost;
  final Rx<String> category;
  final Rx<String> exchange;
  final Rx<String> country;
  final RxList<CommunityIndustryResponse> industry;
  final RxList<Ticker> tickers;
  final Rx<String> rules;
  final RxList<PostRequest> postRequests;
  RxList<PostContent> postContents;

  CommunityData({
    required this.image,
    required this.isDetailShown,
    required this.isSearchEnabled,
    required this.isJoined,
    required this.name,
    required this.code,
    required this.totalMembers,
    required this.adminsList,
    required this.subAdminsList,
    required this.moderatorsList,
    required this.membersList,
    required this.isPaidSubscription,
    required this.userAuthority,
    required this.about,
    required this.roles,
    required this.creationDate,
    required this.averagePost,
    required this.category,
    required this.exchange,
    required this.country,
    required this.industry,
    required this.tickers,
    required this.rules,
    required this.postRequests,
    required this.postContents,
  });

  factory CommunityData.fromJson(Map<String, dynamic> json) => CommunityData(
        image: (json["image"] ?? "").toString().obs,
        isDetailShown: ((json["is_detail_shown"] ?? false) as bool).obs,
        isSearchEnabled: ((json["is_search_enabled"] ?? false) as bool).obs,
        isJoined: ((json["is_joined"] ?? false) as bool).obs,
        name: (json["name"] ?? "").toString().obs,
        code: (json["code"] ?? "").toString().obs,
        totalMembers: RxList<MembersList>.from((json["total_members"] ?? []).map((x) => MembersList.fromJson(x))),
        adminsList: RxList<MembersList>.from((json["admins_list"] ?? []).map((x) => MembersList.fromJson(x))),
        subAdminsList: RxList<MembersList>.from((json["sub_admins_list"] ?? []).map((x) => MembersList.fromJson(x))),
        moderatorsList: RxList<MembersList>.from((json["moderators_list"] ?? []).map((x) => MembersList.fromJson(x))),
        membersList: RxList<MembersList>.from((json["members_list"] ?? []).map((x) => MembersList.fromJson(x))),
        isPaidSubscription: ((json["isPaidSubscription"] ?? false) as bool).obs,
        userAuthority: (json["user_authority"] ?? "").toString().obs,
        about: (json["about"] ?? "").toString().obs,
        roles: RxList<MembersList>.from((json["roles"] ?? []).map((x) => MembersList.fromJson(x))),
        creationDate: (json["creation_date"] ?? "").toString().obs,
        averagePost: (json["average_post"] ?? "").toString().obs,
        category: (json["category"] ?? "").toString().obs,
        exchange: (json["exchange"] ?? "").toString().obs,
        country: (json["country"] ?? "").toString().obs,
        industry: RxList<CommunityIndustryResponse>.from((json["industry"] ?? []).map((x) => CommunityIndustryResponse.fromJson(x))),
        tickers: RxList<Ticker>.from((json["tickers"] ?? []).map((x) => Ticker.fromJson(x))),
        rules: (json["rules"] ?? "").toString().obs,
        postRequests: RxList<PostRequest>.from((json["post_requests"] ?? []).map((x) => PostRequest.fromJson(x))),
        postContents: RxList<PostContent>.from((json["post_contents"] ?? []).map((x) => PostContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "is_detail_shown": isDetailShown,
        "is_search_enabled": isSearchEnabled,
        "is_joined": isJoined,
        "name": name,
        "code": code,
        "total_members": RxList<dynamic>.from(totalMembers.map((x) => x.toJson())),
        "admins_list": RxList<dynamic>.from(adminsList.map((x) => x.toJson())),
        "sub_admins_list": RxList<dynamic>.from(subAdminsList.map((x) => x.toJson())),
        "moderators_list": RxList<dynamic>.from(moderatorsList.map((x) => x.toJson())),
        "members_list": RxList<dynamic>.from(membersList.map((x) => x.toJson())),
        "isPaidSubscription": isPaidSubscription,
        "user_authority": userAuthority,
        "about": about,
        "roles": RxList<dynamic>.from(roles.map((x) => x.toJson())),
        "creation_date": creationDate,
        "average_post": averagePost,
        "category": category,
        "exchange": exchange,
        "country": country,
        "industry": RxList<dynamic>.from(industry.map((x) => x.toJson())),
        "tickers": RxList<dynamic>.from(tickers.map((x) => x.toJson())),
        "rules": rules,
        "post_requests": RxList<dynamic>.from(postRequests.map((x) => x.toJson())),
      };
}

class PostRequest {
  RxString id;
  RxString title;
  RxList<CommunityFileElement> files;
  RxString userId;
  RxString username;
  RxString firstName;
  RxString lastName;
  RxString avatar;
  Rx<int> believedCount;
  Rx<int> believersCount;
  Rx<bool> believed;

  PostRequest({
    required this.id,
    required this.title,
    required this.files,
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.believedCount,
    required this.believersCount,
    required this.believed,
  });

  factory PostRequest.fromJson(Map<String, dynamic> json) => PostRequest(
        id: (json["_id"] ?? "").toString().obs,
        title: (json["title"] ?? "").toString().obs,
        files: RxList<CommunityFileElement>.from((json["files"] ?? []).map((x) => CommunityFileElement.fromJson(x))),
        userId: (json["user_id"] ?? "").toString().obs,
        username: (json["username"] ?? "").toString().obs,
        firstName: (json["first_name"] ?? "").toString().obs,
        lastName: (json["last_name"] ?? "").toString().obs,
        avatar: (json["avatar"] ?? "").toString().obs,
        believedCount: int.parse("${json["believed_count"] ?? 0}").obs,
        believersCount: int.parse("${json["believers_count"] ?? 0}").obs,
        believed: ((json["believed"] ?? false) as bool).obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "user_id": userId,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "believed_count": believedCount,
        "believers_count": believersCount,
        "believed": believed,
      };
}

class Ticker {
  final Rx<String> id;
  final Rx<String> logo;
  final Rx<String> name;

  Ticker({
    required this.id,
    required this.logo,
    required this.name,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
        id: (json["_id"] ?? "").toString().obs,
        logo: (json["logo_url"] ?? "").toString().obs,
        name: (json["name"] ?? "").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
      };
}

class PostContent {
  final RxString id;
  final RxString communityId;
  final RxString title;
  final RxList<CommunityFileElement> files;
  final RxString userId;
  final Rx<int> likesCount;
  final Rx<int> dislikesCount;
  final Rx<int> shareCount;
  final Rx<int> responseCount;
  final RxString postDate;
  final RxString username;
  final RxString profileType;
  final RxString firstName;
  final RxString lastName;
  final RxString avatar;
  final Rx<int> believersCount;
  final Rx<int> believedCount;
  final Rx<bool> believed;
  final Rx<bool> isLiked;
  final Rx<bool> isDisliked;
  Rx<TextEditingController> responseController;
  Rx<FocusNode> responseFocus;
  Rx<File> pickedImage;
  Rx<File> pickedVideo;
  Rx<File> pickedFile;
  Rx<FilePickerResult> doc;
  RxList<File> docFiles;
  RxString urlType;

  PostContent({
    required this.id,
    required this.communityId,
    required this.title,
    required this.files,
    required this.userId,
    required this.likesCount,
    required this.dislikesCount,
    required this.shareCount,
    required this.responseCount,
    required this.postDate,
    required this.username,
    required this.profileType,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.believersCount,
    required this.believedCount,
    required this.believed,
    required this.isLiked,
    required this.isDisliked,
    required this.responseController,
    required this.responseFocus,
    required this.pickedImage,
    required this.pickedVideo,
    required this.pickedFile,
    required this.doc,
    required this.docFiles,
    required this.urlType,
  });

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
        id: (json["_id"] ?? "").toString().obs,
        communityId: (json["community_id"] ?? "").toString().obs,
        title: (json["title"] ?? "").toString().obs,
        files: RxList<CommunityFileElement>.from((json["files"] ?? []).map((x) => CommunityFileElement.fromJson(x))),
        userId: (json["user_id"] ?? "").toString().obs,
        likesCount: int.parse("${json["likes_count"] ?? 0}").obs,
        dislikesCount: int.parse("${json["dislikes_count"] ?? 0}").obs,
        shareCount: int.parse("${json["share_count"] ?? 0}").obs,
        responseCount: int.parse("${json["response_count"] ?? 0}").obs,
        postDate: (DateFormat('yyyy-MM-dd hh:mm a', 'en_US')
                .format((json["post_date"] != null ? DateTime.parse(json["post_date"]) : DateTime.now()).toLocal().toLocal()))
            .obs,
        username: (json["username"] ?? "").toString().obs,
        profileType: (json["profile_type"] ?? "").toString().obs,
        firstName: (json["first_name"] ?? "").toString().obs,
        lastName: (json["last_name"] ?? "").toString().obs,
        avatar: (json["avatar"] ?? "").toString().obs,
        believersCount: int.parse("${json["believers_count"] ?? 0}").obs,
        believedCount: int.parse("${json["believed_count"] ?? 0}").obs,
        believed: ((json["believed"] ?? false) as bool).obs,
        isLiked: ((json["likes"] ?? false) as bool).obs,
        isDisliked: ((json["dislikes"] ?? false) as bool).obs,
        responseController: ((json["response_controller"] ?? TextEditingController()) as TextEditingController).obs,
        responseFocus: ((json["response_focus"] ?? FocusNode()) as FocusNode).obs,
        pickedImage: ((json["picked_image"] ?? File("")) as File).obs,
        pickedVideo: ((json["picked_video"] ?? File("")) as File).obs,
        pickedFile: ((json["picked_file"] ?? File("")) as File).obs,
        doc: ((json["doc"] ?? const FilePickerResult([])) as FilePickerResult).obs,
        docFiles: RxList<File>.from((json["doc_files"] ?? []).map((x) => File(""))),
        urlType: (json["url_type"] ?? "").toString().obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "community_id": communityId,
        "title": title,
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "user_id": userId,
        "likes_count": likesCount,
        "dislikes_count": dislikesCount,
        "share_count": shareCount,
        "response_count": responseCount,
        "post_date": postDate,
        "username": username,
        "profile_type": profileType,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "believers_count": believersCount,
        "believed_count": believedCount,
        "believed": believed,
        "likes": isLiked,
        "dislikes": isDisliked,
        "response_controller": responseController,
        "response_focus": responseFocus,
        "picked_image": pickedImage,
        "picked_video": pickedVideo,
        "picked_file": pickedFile,
        "doc": doc,
        "doc_files": docFiles,
        "url_type": urlType,
      };
}

class PostUser {
  final RxString image;
  final RxString firstName;
  final RxString lastName;
  final RxString userName;
  final RxString id;
  final RxString believersCount;
  final Rx<bool> believed;

  PostUser({
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.id,
    required this.believersCount,
    required this.believed,
  });

  factory PostUser.fromJson(Map<String, dynamic> json) => PostUser(
        image: (json["image"] ?? "").toString().obs,
        firstName: (json["first_name"] ?? "").toString().obs,
        lastName: (json["last_name"] ?? "").toString().obs,
        userName: (json["user_name"] ?? "").toString().obs,
        id: (json["id"] ?? "").toString().obs,
        believersCount: (json["believers_count"] ?? "").toString().obs,
        believed: ((json["believed"] ?? false) as bool).obs,
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "first_name": firstName,
        "last_name": lastName,
        "user_name": userName,
        "id": id,
        "believers_count": believersCount,
        "believed": believed,
      };
}

class CommunityIndustryResponse {
  final String id;
  final String name;
  final String categoryId;

  CommunityIndustryResponse({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory CommunityIndustryResponse.fromJson(Map<String, dynamic> json) => CommunityIndustryResponse(
        id: json["_id"],
        name: json["name"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category_id": categoryId,
      };
}

class MembersList {
  RxString id;
  RxString communityId;
  RxString role;
  RxString userId;
  RxString firstName;
  RxString avatar;
  RxString lastName;
  RxString username;
  Rx<int> believedCount;
  Rx<int> believersCount;
  Rx<bool> believed;
  RxString about;
  Rx<int> sortVal;

  MembersList({
    required this.id,
    required this.communityId,
    required this.role,
    required this.userId,
    required this.firstName,
    required this.avatar,
    required this.lastName,
    required this.username,
    required this.believedCount,
    required this.believersCount,
    required this.believed,
    required this.about,
    required this.sortVal,
  });

  factory MembersList.fromJson(Map<String, dynamic> json) => MembersList(
        id: (json["_id"] ?? "").toString().obs,
        communityId: (json["community_id"] ?? "").toString().obs,
        role: (json["role"] ?? "").toString().obs,
        userId: (json["user_id"] ?? "").toString().obs,
        firstName: (json["first_name"] ?? "").toString().obs,
        avatar: (json["avatar"] ?? "").toString().obs,
        lastName: (json["last_name"] ?? "").toString().obs,
        username: (json["username"] ?? "").toString().obs,
        believedCount: int.parse("${json["believed_count"] ?? 0}").obs,
        believersCount: int.parse("${json["believers_count"] ?? 0}").obs,
        believed: ((json["believed"] ?? false) as bool).obs,
        about: (json["about"] ?? "").toString().obs,
        sortVal: int.parse("${json["sort_val"] ?? 0}").obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "community_id": communityId,
        "role": role,
        "user_id": userId,
        "first_name": firstName,
        "avatar": avatar,
        "last_name": lastName,
        "username": username,
        "believed_count": believedCount,
        "believers_count": believersCount,
        "believed": believed,
        "about": about,
        "sort_val": sortVal,
      };
}
