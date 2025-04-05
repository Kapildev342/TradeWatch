// To parse this JSON data, do
//
//     final responseForumsResponseModel = responseForumsResponseModelFromJson(jsonString);

import 'dart:convert';

ResponseForumsResponseModel responseForumsResponseModelFromJson(String str) => ResponseForumsResponseModel.fromJson(json.decode(str));

String responseForumsResponseModelToJson(ResponseForumsResponseModel data) => json.encode(data.toJson());

class ResponseForumsResponseModel {
  final bool status;
  final List<Response> response;
  final String message;

  ResponseForumsResponseModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory ResponseForumsResponseModel.fromJson(Map<String, dynamic> json) => ResponseForumsResponseModel(
    status: json["status"],
    response: json["response"]==null?[]:List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
    "message": message,
  };
}

class Response {
  final String id;
  final String message;
  final String category;
  final String url;
  final String urlType;
  final bool dislikes;
  final bool likes;
  final String userId;
  final String categoryId;
  final int likesCount;
  final int disLikesCount;
  final String createdAt;
  final User user;
  final TaggedUser taggedUser;

  Response({
    required this.id,
    required this.message,
    required this.category,
    required this.url,
    required this.urlType,
    required this.dislikes,
    required this.likes,
    required this.userId,
    required this.categoryId,
    required this.likesCount,
    required this.disLikesCount,
    required this.createdAt,
    required this.user,
    required this.taggedUser,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["_id"]??"",
    message: json["message"]??"",
    category: json["category"]??"",
    url: json["url"]??"",
    urlType: json["url_type"]??"",
    dislikes: json["dislikes"]??false,
    likes: json["likes"]??false,
    userId: json["user_id"]??"",
    categoryId: json["category_id"]??"",
    likesCount: json["likes_count"]??0,
    disLikesCount: json["dis_likes_count"]??0,
    createdAt: json["createdAt"]==null?"few seconds ago":readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
    user: User.fromJson(json["user"]??{}),
    taggedUser: TaggedUser.fromJson(json["tagged_user"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "message": message,
    "category": category,
    "url": url,
    "url_type": urlType,
    "dislikes": dislikes,
    "likes": likes,
    "user_id": userId,
    "category_id": categoryId,
    "likes_count": likesCount,
    "dis_likes_count": disLikesCount,
    "createdAt": createdAt,
    "user": user.toJson(),
    "tagged_user": taggedUser.toJson(),
  };
}

class User {
  final String id;
  final String username;
  final String avatar;

  User({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"]??"",
    username: json["username"]??"",
    avatar: json["avatar"]??"https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "avatar": avatar,
  };
}

class TaggedUser {
  final String id;
  final String username;
  final String avatar;

  TaggedUser({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory TaggedUser.fromJson(Map<String, dynamic> json) => TaggedUser(
    id: json["_id"]??"",
    username: json["username"]??"",
    avatar: json["avatar"]??"https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "avatar": avatar,
  };
}

String readTimestampMain(int timestamp) {
  String time="";
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
    time = "few sec ago";
  }
  else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
    time = "${diff.inMinutes} min ago";
  }
  else if (diff.inHours >= 0 && diff.inHours <= 23) {
    time = time="${diff.inHours} hrs ago";
  }
  else if (diff.inDays >= 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day ago';
    } else {
      time = '${diff.inDays} days ago';
    }
  }
  else {
    if (diff.inDays >= 7 && diff.inDays <= 13) {
      time = '${(diff.inDays / 7).floor()} week ago';
    } else if (diff.inDays > 13 && diff.inDays <= 29) {
      time = '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays > 29 && diff.inDays <= 59) {
      time = '${(diff.inDays / 30).floor()} month ago';
    } else if (diff.inDays > 59 && diff.inDays <= 360) {
      time = '${(diff.inDays / 30).floor()} months ago';
    } else {
      time = "a year ago";
    }
  }
  return time;
}
