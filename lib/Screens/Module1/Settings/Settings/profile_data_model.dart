
import 'dart:convert';

ProfileDataModel profileDataModelFromJson(String str) => ProfileDataModel.fromJson(json.decode(str));

String profileDataModelToJson(ProfileDataModel data) => json.encode(data.toJson());

class ProfileDataModel {
  final bool status;
  final ResponseProfile response;
  final String message;

  ProfileDataModel({
    required this.status,
    required this.response,
    required this.message,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) => ProfileDataModel(
    status: json["status"]??false,
    response: ResponseProfile.fromJson(json["response"]??{}),
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
    "message": message,
  };
}

class ResponseProfile {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneCode;
  final String phoneNumber;
  final String referralCode;
  final String coverImage;
  final String about;
  final bool mobileVerified;
  final String avatar;
  final SocialLogins socialLogins;
  final bool notifications;
  final String countryCode;
  final int status;
  final int believersCount;
  final int believedCount;
  final int profileView;
  final bool verifyPassword;
  final String loginType;
  final String profileType;
  final bool coverChanged;
  final bool avatarChanged;
  final List<String> defaultAvatarsList;

  ResponseProfile({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneCode,
    required this.phoneNumber,
    required this.referralCode,
    required this.coverImage,
    required this.about,
    required this.mobileVerified,
    required this.avatar,
    required this.socialLogins,
    required this.notifications,
    required this.countryCode,
    required this.status,
    required this.believersCount,
    required this.believedCount,
    required this.profileView,
    required this.verifyPassword,
    required this.loginType,
    required this.profileType,
    required this.coverChanged,
    required this.avatarChanged,
    required this.defaultAvatarsList,
  });

  factory ResponseProfile.fromJson(Map<String, dynamic> json) => ResponseProfile(
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    username: json["username"]??"",
    email: json["email"]??"",
    phoneCode: json["phone_code"]??"",
    phoneNumber: json["phone_number"]??"",
    referralCode: json["referral_code"]??"",
    coverImage: json["cover_image"]??"",
    about: json["about"]??"Stay connected",
    mobileVerified: json["mobile_verified"]??false,
    avatar: json["avatar"]??"",
    socialLogins: SocialLogins.fromJson(json["social_logins"]??{}),
    notifications: json["notifications"]??false,
    countryCode: json["country_code"]??"",
    status: json["status"]??0,
    believersCount: json["believers_count"]??0,
    believedCount: json["believed_count"]??0,
    profileView: json["users_view"]??0,
    verifyPassword: json["verify_password"]??false,
    loginType: json["login_type"]??"",
    profileType: json["profile_type"]??"",
    coverChanged: json["cover_changed"]??false,
    avatarChanged: json["avatar_changed"]??false,
    defaultAvatarsList: json["default_avatars_list"]==null?[]:List<String>.from(json["default_avatars_list"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "email": email,
    "phone_code": phoneCode,
    "phone_number": phoneNumber,
    "referral_code": referralCode,
    "cover_image": coverImage,
    "about": about,
    "mobile_verified": mobileVerified,
    "avatar": avatar,
    "social_logins": socialLogins.toJson(),
    "notifications": notifications,
    "country_code": countryCode,
    "status": status,
    "believers_count": believersCount,
    "believed_count": believedCount,
    "users_view": profileView,
    "verify_password": verifyPassword,
    "login_type": loginType,
    "profile_type": profileType,
    "cover_changed": coverChanged,
    "avatar_changed": avatarChanged,
    "default_avatars_list": List<dynamic>.from(defaultAvatarsList.map((x) => x)),
  };
}

class SocialLogins {
  final bool google;
  final bool facebook;
  final bool twitter;
  final bool apple;

  SocialLogins({
    required this.google,
    required this.facebook,
    required this.twitter,
    required this.apple,
  });

  factory SocialLogins.fromJson(Map<String, dynamic> json) => SocialLogins(
    google: json["google"]??false,
    facebook: json["facebook"]??false,
    twitter: json["twitter"]??false,
    apple: json["apple"]??false,
  );

  Map<String, dynamic> toJson() => {
    "google": google,
    "facebook": facebook,
    "twitter": twitter,
    "apple": apple,
  };
}
