import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class BillBoardCommonFunctions {
  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  commonShareFunc(
      {required BuildContext context,
      required String id,
      required String type,
      required String imageUrl,
      required String title,
      required String billBoardType,
      required String category,
      required String filterId,
      required String description}) async {
    logEventFunc(name: 'Share', type: type);
    if (billBoardType == "news") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/DemoPage/$id/$type'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: $title ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    } else if (billBoardType == "forums") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/ForumPostDescriptionPage/$id/$type/$category/$filterId'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: $title ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    } else if (billBoardType == "survey") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/AnalyticsPage/$id/$billBoardType/$title'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: $title ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    } else if (billBoardType == "billboard") {
      if (type == "byte") {
        final dynamicLinkParams = DynamicLinkParameters(
            uriPrefix: domainLink,
            link: Uri.parse('$domainLink/BytesDescriptionPage/$id'),
            androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
            iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
            socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
        ShortDynamicLink dynamicLink =
            await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
        ShareResult result = await Share.share(
          "Look what I was able to find on Tradewatch: $title ${{dynamicLink.shortUrl}.toString()}",
        );
        if (result.status == ShareResultStatus.success) {
          if (!context.mounted) {
            return;
          }
          await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
        }
      } else {
        final dynamicLinkParams = DynamicLinkParameters(
            uriPrefix: domainLink,
            link: Uri.parse('$domainLink/BlogDescriptionPage/$id'),
            androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
            iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
            socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
        ShortDynamicLink dynamicLink =
            await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
        ShareResult result = await Share.share(
          "Look what I was able to find on Tradewatch: $title ${{dynamicLink.shortUrl}.toString()}",
        );
        if (result.status == ShareResultStatus.success) {
          if (!context.mounted) {
            return;
          }
          await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
        }
      }
    } else {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/BillBoardHome'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: $title ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    }
  }

  commonShareProfileFunc({
    required BuildContext context,
    required String id,
    required String type,
  }) async {
    if (type == "user") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/UserProfilePage/$id'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: "", description: '', imageUrl: Uri.parse("")));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    } else if (type == "business") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/BusinessProfilePage/$id'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: "", description: '', imageUrl: Uri.parse("")));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    } else if (type == "intermediate") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/IntermediaryPage/$id'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: "", description: '', imageUrl: Uri.parse("")));
      ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      ShareResult result = await Share.share(
        "Look what I was able to find on Tradewatch: ${{dynamicLink.shortUrl}.toString()}",
      );
      if (result.status == ShareResultStatus.success) {
        if (!context.mounted) {
          return;
        }
        await billBoardApiMain.shareFunction(id: id, type: type.toLowerCase(), context: context);
      }
    }
  }

  linkGeneratingFunc(
      {required BuildContext context,
      required String id,
      required String type,
      required String imageUrl,
      required String title,
      required String billBoardType,
      required String category,
      required String filterId,
      required String description}) async {
    if (billBoardType == "news") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/DemoPage/$id/$type'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    } else if (billBoardType == "forums") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/ForumPostDescriptionPage/$id/$type/$category/$filterId'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    } else if (billBoardType == "survey") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/AnalyticsPage/$id/$billBoardType/$title'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    } else if (billBoardType == "billboard") {
      if (type == "byte") {
        final dynamicLinkParams = DynamicLinkParameters(
            uriPrefix: domainLink,
            link: Uri.parse('$domainLink/BytesDescriptionPage/$id'),
            androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
            iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
            socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
        mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      } else {
        final dynamicLinkParams = DynamicLinkParameters(
            uriPrefix: domainLink,
            link: Uri.parse('$domainLink/BlogDescriptionPage/$id'),
            androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
            iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
            socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
        mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
      }
    } else {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/BillBoardHome'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    }
  }

  linkGeneratingProfileFunc({
    required BuildContext context,
    required String id,
    required String type,
  }) async {
    if (type == "user") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/UserProfilePage/$id'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: "", description: '', imageUrl: Uri.parse('')));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    } else if (type == "business") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/BusinessProfilePage/$id'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: "", description: '', imageUrl: Uri.parse("")));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    } else if (type == "intermediate") {
      final dynamicLinkParams = DynamicLinkParameters(
          uriPrefix: domainLink,
          link: Uri.parse('$domainLink/IntermediaryPage/$id'),
          androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
          iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
          socialMetaTagParameters: SocialMetaTagParameters(title: "", description: '', imageUrl: Uri.parse("")));
      mainVariables.dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    }
  }

  String readTimestampMain(int timestamp) {
    String time = "";
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
      time = "few sec ago";
    } else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
      time = "${diff.inMinutes} min ago";
    } else if (diff.inHours >= 0 && diff.inHours <= 23) {
      time = time = "${diff.inHours} hrs ago";
    } else if (diff.inDays >= 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} day ago';
      } else {
        time = '${diff.inDays} days ago';
      }
    } else {
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

  getSearchCountFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    watchVariables.billBoardSearchCountCountTotalMain.value = prefs.getInt("BillBoardSearchCount") ?? 0;
    watchVariables.billBoardSearchCountCountTotalMain++;
    prefs.setInt('BillBoardSearchCount', watchVariables.billBoardSearchCountCountTotalMain.value);
  }
}
