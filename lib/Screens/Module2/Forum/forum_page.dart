import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Constants/Common/filter_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

import 'detailed_forum_image_page.dart';
import 'forum_post_description_page.dart';
import 'forum_post_edit_page.dart';
import 'forum_post_page.dart';

class ForumPage extends StatefulWidget {
  final String text;

  const ForumPage({Key? key, required this.text}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<String> categoriesList = ["Stocks", "Crypto", "Commodity", "Forex"];
  String selectedValue = "Stocks";
  String selectedWidget = "";
  String selectedIdWidget = "";
  List enteredNewList = [];

  bool searchLoader = false;
  bool searchValue1 = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FilterFunction _filterFunction = FilterFunction();
  String mainUserId = "";
  String mainUserToken = "";
  String time = '';
  List<String> forumImagesList = [];
  List<bool> forumBookMarkList = [];
  List<bool> translationList = [];
  List forumSourceNameList = [];
  List<String> forumTitlesList = [];
  List<String> timeList = [];
  List<String> forumCategoryList = [];
  int newsInt = 0;
  String categoryValue = "";
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool filterBool = false;
  bool startSearch = false;
  String filterId = "";
  bool dropDownSelection = false;
  bool emptyBool = false;
  List<String> forumIdList = [];
  List<String> forumCompanyList = [];
  List<int> forumViewsList = [];
  List<dynamic> forumObjectList = [];
  List<int> forumResponseList = [];
  List<String> forumUserIdList = [];
  List<int> forumLikeList = [];
  List<int> forumDislikeList = [];
  List<bool> forumUseList = [];
  List<bool> forumUseDisList = [];
  List<bool> forumMyList = [];
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String whyValue = "Scam";
  late Uri newLink;
  bool loading = false;
  bool completePopUp = false;
  List designTopics = [
    "Latest Topics",
    "Popular Topics",
    "Unanswered",
    "Most Liked",
    "Most Replies",
    "Most Disliked",
    "Most Shared",
    "My Questions",
    "My Answers",
  ];
  List eventNames = [
    "Viewed_Latest",
    "Viewed_Popular",
    "Viewed_Unanswered",
    "Viewed_Most_Liked",
    "Viewed_Most_Replies",
    "Viewed_Most_Disliked",
    "Viewed_Most_Shared",
    "Viewed_My_Questions",
    "Viewed_My_Answers",
  ];
  List designImages = [
    "lib/Constants/Assets/ForumPage/LatestTopics.png",
    "lib/Constants/Assets/ForumPage/PopularTopics.png",
    "lib/Constants/Assets/ForumPage/Unanswered.png",
    "lib/Constants/Assets/ForumPage/MostLiked.png",
    "lib/Constants/Assets/ForumPage/MostReplies.png",
    "lib/Constants/Assets/ForumPage/MostDisliked.png",
    "lib/Constants/Assets/ForumPage/MyShared.png",
    "lib/Constants/Assets/ForumPage/MyQuestions.png",
    "lib/Constants/Assets/ForumPage/myanswers.jpg"
  ];
  List<String> forumViewedImagesList = [];
  List<String> forumViewedIdList = [];
  List<String> forumViewedSourceNameList = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  navigationPage1() async {
    var url = Uri.parse(baseurl + versionLocker + filterCount);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'type': selectedValue.toLowerCase()});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      if (selectedValue == "Stocks") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return StocksAddFilterPage(
            text: selectedValue,
            page: 'forums',
          );
        }));
      } else if (selectedValue == "Crypto") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CryptoAddFilterPage(
            text: selectedValue,
            page: 'forums',
          );
        }));
      } else if (selectedValue == "Commodity") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CommodityAddFilterPage(
            text: selectedValue,
            page: 'forums',
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForexAddFilterPage(
            text: selectedValue,
            page: 'forums',
          );
        }));
      }
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getForumValues({required String text, required String? category, required String filterId}) async {
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': category!.toLowerCase(), 'search': text.isEmpty ? "" : text, 'filter_id': filterId.isEmpty ? "" : filterId, 'skip': "0"});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      forumImagesList.clear();
      forumBookMarkList.clear();
      translationList.clear();
      forumSourceNameList.clear();
      forumTitlesList.clear();
      timeList.clear();
      forumCategoryList.clear();
      forumIdList.clear();
      forumLikeList.clear();
      forumDislikeList.clear();
      forumUseList.clear();
      forumObjectList.clear();
      forumUseDisList.clear();
      forumMyList.clear();
      forumViewsList.clear();
      forumResponseList.clear();
      forumUserIdList.clear();
      forumCompanyList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool = true;
          searchLoader = false;
          searchValue1 = false;
        });
      } else {
        setState(() {
          emptyBool = false;
        });
        for (int i = 0; i < responseData["response"].length; i++) {
          //await getImage(url: responseData["response"][i]["user"]["avatar"], index: i);
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          if (responseData["response"][i]["user"].containsKey("avatar")) {
            forumImagesList.add(responseData["response"][i]["user"]["avatar"]);
          } else {
            forumImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
          }
          forumObjectList.add(responseData["response"][i]);
          forumBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
          translationList.add(responseData["response"][i]["translation"] ?? false);
          forumTitlesList.add(responseData["response"][i]["title"]);
          if (responseData["response"][i].containsKey("company_name")) {
            forumCompanyList.add(responseData["response"][i]["company_name"]);
          } else {
            forumCompanyList.add("");
          }
          // forumCompanyList.add(responseData["response"][i]["company_name"]);
          forumSourceNameList.add(responseData["response"][i]["user"]["username"]);
          forumCategoryList.add(responseData["response"][i]["category"]);
          forumIdList.add(responseData["response"][i]["_id"]);
          forumViewsList.add(responseData["response"][i]["views_count"]);
          forumResponseList.add(responseData["response"][i]["response_count"]);
          forumUserIdList.add(responseData["response"][i]["user"]["_id"]);
          forumUseList.add(responseData["response"][i]["likes"]);
          forumUseDisList.add(responseData["response"][i]["dislikes"]);
          forumLikeList.add(responseData["response"][i]["likes_count"]);
          forumDislikeList.add(responseData["response"][i]["dis_likes_count"]);
          if (mainUserId == forumUserIdList[i]) {
            forumMyList.add(true);
          } else {
            forumMyList.add(false);
          }
        }
        setState(() {
          searchLoader = false;
          searchValue1 = false;
        });
      }
    } else {
      forumImagesList.clear();
      forumBookMarkList.clear();
      translationList.clear();
      forumSourceNameList.clear();
      forumTitlesList.clear();
      timeList.clear();
      forumCategoryList.clear();
      forumIdList.clear();
      forumLikeList.clear();
      forumDislikeList.clear();
      forumUseList.clear();
      forumObjectList.clear();
      forumUseDisList.clear();
      forumMyList.clear();
      forumViewsList.clear();
      forumResponseList.clear();
      forumUserIdList.clear();
      forumCompanyList.clear();
      setState(() {
        searchLoader = false;
        searchValue1 = false;
      });
    }
    setState(() {
      loading = true;
      searchValue1 = false;
    });
  }

  void _onForumLoading() async {
    setState(() {
      newsInt = newsInt + 50;
    });
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': selectedValue.toLowerCase(),
      'search': _searchController.text.isEmpty ? "" : _searchController.text,
      'filter_id': finalisedFilterId.isEmpty ? "" : finalisedFilterId,
      'skip': newsInt.toString()
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          searchLoader = false;
          searchValue1 = false;
        });
      } else {
        setState(() {});
        for (int i = 0; i < responseData["response"].length; i++) {
          //await getImage(url: responseData["response"][i]["user"]["avatar"], index: i+newsInt);
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          forumImagesList.add(responseData["response"][i]["user"]["avatar"]);
          forumObjectList.add(responseData["response"][i]);
          forumTitlesList.add(responseData["response"][i]["title"]);
          forumBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
          translationList.add(responseData["response"][i]["translation"] ?? false);
          forumCompanyList.add(responseData["response"][i]["company_name"]);
          forumSourceNameList.add(responseData["response"][i]["user"]["username"]);
          forumCategoryList.add(responseData["response"][i]["category"]);
          forumIdList.add(responseData["response"][i]["_id"]);
          forumViewsList.add(responseData["response"][i]["views_count"]);
          forumResponseList.add(responseData["response"][i]["response_count"]);
          forumUserIdList.add(responseData["response"][i]["user"]["_id"]);
          forumUseList.add(responseData["response"][i]["likes"]);
          forumUseDisList.add(responseData["response"][i]["dislikes"]);
          forumLikeList.add(responseData["response"][i]["likes_count"]);
          forumDislikeList.add(responseData["response"][i]["dis_likes_count"]);
          if (mainUserId == forumUserIdList[i]) {
            forumMyList.add(true);
          } else {
            forumMyList.add(false);
          }
        }
        setState(() {
          searchLoader = false;
          searchValue1 = false;
        });
      }
    } else {
      setState(() {
        searchLoader = false;
        searchValue1 = false;
      });
    }
    setState(() {
      loading = true;
      searchValue1 = false;
    });

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  String readTimestamp(int timestamp) {
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
    setState(() {
      timeList.add(time);
    });
    return time;
  }

  getFil({required String type, required String filterId}) async {
    enteredFilteredList.clear();
    enteredFilteredIdList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getFilter);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"type": type.toLowerCase()});
    var responseData = json.decode(response.body);
    if (responseData["response"].length == 0) {
      enteredFilteredList.clear();
      enteredFilteredIdList.clear();
      setState(() {
        emptyBool = true;
        selectedWidget = selectedWidget = "All $selectedValue";
        selectedIdWidget = "";
        finalisedFilterName = selectedWidget;
        finalisedFilterId = selectedIdWidget;
        prefs.setString('finalisedFilterId1', finalisedFilterId);
        prefs.setString('finalisedFilterName1', finalisedFilterName);
      });
    } else {
      enteredFilteredList.clear();
      enteredFilteredIdList.clear();
      setState(() {
        emptyBool = false;
      });
      for (int i = 0; i < responseData["response"].length; i++) {
        enteredFilteredList.add(responseData["response"][i]["title"]);
        enteredFilteredIdList.add(responseData["response"][i]["_id"]);
      }
      if (filterId == "") {
        setState(() {
          selectedWidget = enteredFilteredList[0];
          selectedIdWidget = enteredFilteredIdList[0];
          finalisedFilterName = enteredFilteredList[0];
          finalisedFilterId = enteredFilteredIdList[0];
          prefs.setString('finalisedFilterId1', finalisedFilterId);
          prefs.setString('finalisedFilterName1', finalisedFilterName);
        });
      } else {
        for (int i = 0; i < enteredFilteredIdList.length; i++) {
          if (enteredFilteredIdList[i] == filterId) {
            selectedWidget = enteredFilteredList[i];
            selectedIdWidget = enteredFilteredIdList[i];
            finalisedFilterName = enteredFilteredList[i];
            finalisedFilterId = enteredFilteredIdList[i];
            prefs.setString('finalisedFilterId1', finalisedFilterId);
            prefs.setString('finalisedFilterName1', finalisedFilterName);
          }
        }
      }
    }
  }

  getSelectedValue({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + saveKey);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'locker': value.toLowerCase()});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      finalisedCategory = selectedValue;
      prefs.setString('finalisedCategory1', finalisedCategory);
    }
  }

  @override
  void initState() {
    getNotifyCountAndImage();
    getAllDataMain(name: 'Forums_Home_Page');
    pageVisitFunc(pageName: 'forums');
    getAllData();
    super.initState();
  }

  Future<bool> likeFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + likes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<bool> disLikeFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + dislikes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<bool> shareFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + share);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<Uri> getLinK(
      {required String id,
      required String type,
      required String imageUrl,
      required String title,
      required String description,
      required String category,
      required String filterId}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/ForumPostDescriptionPage/$id/$type/$category/$filterId'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  getAllData() async {
    if (widget.text != "") {
      widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterId = "";
      widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterName = "";
      finalisedCategory = widget.text;
    }
    selectedValue = finalisedCategory;
    selectedIdWidget = finalisedFilterId;
    selectedWidget = finalisedFilterName;
    await getFil(type: selectedValue, filterId: selectedIdWidget);
    await getForumValues(text: "", category: selectedValue, filterId: selectedIdWidget);
  }

  deletePost({required String forumId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + forumDelete);
    var responseNew = await http.post(url, body: {"forum_id": forumId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      getForumValues(text: "", category: selectedValue, filterId: filterId);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  reportPost({required String action, required String why, required String description, required String forumId, required String forumUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versionForum + addReport);
        var responseNew = await http.post(url,
            body: {"action": action, "why": why, "description": description, "forum_id": forumId, "forum_user": forumUserId},
            headers: {'Authorization': mainUserToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          getForumValues(text: "", category: selectedValue, filterId: filterId);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      var url = Uri.parse(baseurl + versionForum + addReport);
      var responseNew = await http.post(url,
          body: {"action": action, "why": why, "description": description, "forum_id": forumId, "forum_user": forumUserId},
          headers: {'Authorization': mainUserToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        getForumValues(text: "", category: selectedValue, filterId: filterId);
      } else {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  @override
  void dispose() {
    extraContainMain.value = false;
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    //  context.read<BookMarkWidgetBloc>().add(LoadingEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (startSearch) {
          setState(() {
            startSearch = false;
          });
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
              tType: true,
              text: finalisedCategory,
              caseNo1: 1,
              countryIndex: 0,
              newIndex: 0,
              isHomeFirstTym: false,
              excIndex: 0,
            );
          }));
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          extraContainMain.value = false;
        },
        child: Container(
          // color: const Color(0XFFFFFFFF),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
              //backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: height / 5.71,
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    SizedBox(height: height / 50.75),
                    SizedBox(
                      height: height / 15.03,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return MainBottomNavigationPage(
                                        tType: true,
                                        text: finalisedCategory,
                                        caseNo1: 1,
                                        countryIndex: 0,
                                        newIndex: 0,
                                        excIndex: 0,
                                        isHomeFirstTym: false,
                                      );
                                    }));
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    size: 30,
                                  )),
                              Text("Forum",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge /*TextStyle(fontSize: text.scale(26), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),*/
                                  ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return const NotificationsPage();
                                    }));
                                    if (response) {
                                      await functionsMain.getNotifyCount();
                                      setState(() {});
                                    }
                                  },
                                  child: widgetsMain.getNotifyBadge(context: context)),
                              SizedBox(
                                width: width / 23.43,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return mainSkipValue ? const SettingsSkipView() : const SettingsView();
                                    }));
                                  },
                                  child: widgetsMain.getProfileImage(context: context, isLogged: mainSkipValue)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 50.75),
                    SizedBox(
                      height: height / 25.375,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              selectedValue == "Stocks"
                                  ? SizedBox(
                                      height: height / 35.03,
                                      width: width / 16.30,
                                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg", fit: BoxFit.fill),
                                    )
                                  : selectedValue == "Crypto"
                                      ? SizedBox(
                                          height: height / 35.03,
                                          width: width / 16.30,
                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", fit: BoxFit.fill),
                                        )
                                      : selectedValue == "Commodity"
                                          ? SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child:
                                                  Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png", fit: BoxFit.fill),
                                            )
                                          : SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png", fit: BoxFit.fill),
                                            ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => extraContainMain.value
                                    ? Text(selectedValue,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium /*TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),*/
                                        )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          items: categoriesList
                                              .map((item) => DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      // style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue,
                                          onChanged: (String? value) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            setState(() {
                                              loading = false;
                                              forumImagesList.clear();
                                              forumBookMarkList.clear();
                                              translationList.clear();
                                              forumSourceNameList.clear();
                                              forumTitlesList.clear();
                                              forumCategoryList.clear();
                                              timeList.clear();
                                              newsInt = 0;
                                              selectedValue = value!;
                                              finalisedCategory = selectedValue;
                                              prefs.setString('finalisedCategory1', finalisedCategory);
                                            });
                                            getSelectedValue(value: finalisedCategory);
                                            await getFil(type: finalisedCategory, filterId: "");
                                            if (!mounted) {
                                              return;
                                            }
                                            context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                            await getForumValues(
                                                text: _searchController.text.isEmpty ? "" : _searchController.text,
                                                category: finalisedCategory,
                                                filterId: finalisedFilterId);
                                          },
                                          iconStyleData: IconStyleData(
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                              ),
                                              iconSize: 24,
                                              iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
                                              iconDisabledColor: Theme.of(context).colorScheme.onPrimary),
                                          buttonStyleData: const ButtonStyleData(height: 50, width: 125, elevation: 0),
                                          menuItemStyleData: const MenuItemStyleData(height: 40),
                                          dropdownStyleData: DropdownStyleData(
                                              maxHeight: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15), color: Theme.of(context).colorScheme.tertiary),
                                              elevation: 8,
                                              offset: const Offset(-20, 0)),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              selectedValue == "Stocks"
                                  ? SizedBox(
                                      height: height / 35.03,
                                      width: width / 16.30,
                                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg", fit: BoxFit.fill),
                                    )
                                  : selectedValue == "Crypto"
                                      ? SizedBox(
                                          height: height / 35.03,
                                          width: width / 16.30,
                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", fit: BoxFit.fill),
                                        )
                                      : selectedValue == "Commodity"
                                          ? SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child:
                                                  Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png", fit: BoxFit.fill),
                                            )
                                          : SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png", fit: BoxFit.fill),
                                            ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => extraContainMain.value
                                    ? Text(
                                        selectedValue,
                                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black),
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          isDense: true,
                                          items: categoriesList
                                              .map((item) => DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue,
                                          onChanged: (String? value) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            setState(() {
                                              loading = false;
                                              forumImagesList.clear();
                                              forumBookMarkList.clear();
                                              translationList.clear();
                                              forumSourceNameList.clear();
                                              forumTitlesList.clear();
                                              forumCategoryList.clear();
                                              timeList.clear();
                                              newsInt = 0;
                                              selectedValue = value!;
                                              finalisedCategory = selectedValue;
                                              prefs.setString('finalisedCategory1', finalisedCategory);
                                            });
                                            getSelectedValue(value: finalisedCategory);
                                            await getFil(type: finalisedCategory, filterId: "");
                                            if (!mounted) {
                                              return;
                                            }
                                            context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                            await getForumValues(
                                                text: _searchController.text.isEmpty ? "" : _searchController.text,
                                                category: finalisedCategory,
                                                filterId: finalisedFilterId);
                                          },
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                              ),
                                              iconSize: 24,
                                              iconEnabledColor: Colors.black,
                                              iconDisabledColor: Colors.black),
                                          buttonStyleData: const ButtonStyleData(height: 50, width: 125, elevation: 0),
                                          menuItemStyleData: const MenuItemStyleData(height: 40),
                                          dropdownStyleData: DropdownStyleData(
                                              maxHeight: 200,
                                              width: 200,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                              elevation: 8,
                                              offset: const Offset(-20, 0)),
                                          */
                          /*icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    iconSize: 24,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.black,
                                    buttonHeight: 50,
                                    buttonWidth: 125,
                                    //buttonPadding: const EdgeInsets.only(left: 14),
                                    buttonElevation: 0,
                                    itemHeight: 40,
                                    dropdownMaxHeight: 200,
                                    dropdownWidth: 200,
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    scrollbarThickness: 6,
                                    scrollbarAlwaysShow: true,
                                    offset: const Offset(-20, 0),*/
                          /*
                                        ),
                                      ),
                              ),
                            ],
                          ),*/
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: Colors.transparent,
                              splashFactory: NoSplash.splashFactory,
                            ),
                            onPressed: () {
                              setState(() {
                                extraContainMain.toggle();
                              });
                            },
                            child: SizedBox(
                              width: width / 3,
                              child: Row(
                                children: [
                                  Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    padding: const EdgeInsets.all(4),
                                    child: SvgPicture.asset(
                                      "lib/Constants/Assets/SMLogos/LockerScreen/downFilter.svg",
                                      fit: BoxFit.fill,
                                      colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    selectedWidget,
                                    //style: TextStyle(color: Colors.black, fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                            ),
                            onPressed: () {
                              setState(() {
                                extraContainMain.toggle();
                              });
                            },
                            child: SizedBox(
                              width: width / 3,
                              child: Row(
                                children: [
                                  Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    padding: const EdgeInsets.all(4),
                                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/downFilter.svg", fit: BoxFit.fill),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    selectedWidget,
                                    style: TextStyle(color: Colors.black, fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(height: height / 50.75),
                  ],
                ),
                elevation: 0.0,
              ),
              body: loading
                  ? Obx(() => extraContainMain.value
                      ? NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (scroll) {
                            scroll.disallowIndicator();
                            return true;
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        startSearch
                                            ? const SizedBox()
                                            : Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                                child: const Text("Topics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                                        startSearch
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: height / 50.75,
                                              ),
                                        startSearch
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: height / 3.8,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: 9,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            left: index == 0 ? width / 31.25 : width / 62.5,
                                                            right: index == 8 ? width / 31.25 : width / 62.5,
                                                            bottom: 15),
                                                        child: Card(
                                                          elevation: 10.0,
                                                          shape: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                              borderSide: BorderSide(color: Theme.of(context).colorScheme.background)),
                                                          child: Stack(
                                                            alignment: Alignment.bottomLeft,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.only(
                                                                    left: index == 0 ? width / 18.75 : width / 37.5,
                                                                    right: index == 8 ? width / 18.75 : width / 37.5),
                                                                width: width / 2.7,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: AssetImage(designImages[index]),
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: height / 16.24,
                                                                width: width / 2.7,
                                                                padding: EdgeInsets.only(
                                                                    left: index == 0 ? width / 18.75 : width / 37.5,
                                                                    right: index == 8 ? width / 18.75 : width / 37.5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius.only(
                                                                      bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                                                                  color: Colors.black12.withOpacity(0.3),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    designTopics[index],
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(12),
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          height: height / 19.33,
                                          child: TextFormField(
                                            readOnly: true,
                                            enabled: false,
                                            cursorColor: Colors.green,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            controller: _searchController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              fillColor: Theme.of(context).colorScheme.tertiary,
                                              filled: true,
                                              contentPadding: EdgeInsets.zero,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                              ),
                                              suffixIcon: _searchController.text.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _searchController.clear();
                                                        });
                                                      },
                                                      child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                                                    )
                                                  : const SizedBox(),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              disabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                                              hintText: 'Search here',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 50.75,
                                        ),
                                        searchLoader
                                            ? SizedBox(
                                                height: height / 2.37,
                                                child: const Center(child: CircularProgressIndicator(color: Color(0XFF0EA102))),
                                              )
                                            : emptyBool
                                                ? Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                            height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      '😟 Looks like there is no Forum created under this topic, Would you like to a add ',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 10)*/),
                                                              TextSpan(
                                                                  text: ' Add here',
                                                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                      color: const Color(0XFF0EA102),
                                                                      fontWeight: FontWeight
                                                                          .w700) /*const TextStyle(
                                                              fontFamily: "Poppins",
                                                              color: Color(0XFF0EA102),
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 12)*/
                                                                  ,
                                                                  recognizer: TapGestureRecognizer()
                                                                    ..onTap = () async {
                                                                      bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return ForumPostPage(
                                                                          text: widget.text,
                                                                        );
                                                                      }));
                                                                      if (response) {
                                                                        await getForumValues(
                                                                            text: "", category: selectedValue, filterId: selectedIdWidget);
                                                                      }
                                                                    }),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                    height: startSearch ? height / 1.2 : height / 2.54,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      // physics: NeverScrollableScrollPhysics(),
                                                      itemCount: forumTitlesList.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                  height: height / 9.10,
                                                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                                                  child: AdWidget(ad: nativeAdList[index])),
                                                              SizedBox(height: height / 57.73),
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
                                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(context).colorScheme.background,
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Theme.of(context).colorScheme.tertiary,
                                                                          blurRadius: 4,
                                                                          spreadRadius: 0)
                                                                    ]),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height: height / 86.6,
                                                                    ),
                                                                    Container(
                                                                      color: Theme.of(context).colorScheme.background,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                height: height / 13.53,
                                                                                width: width / 5.95,
                                                                                margin: EdgeInsets.fromLTRB(
                                                                                    width / 23.43, height / 203, width / 37.5, height / 27.06),
                                                                                decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: Theme.of(context).colorScheme.tertiary,
                                                                                    image: DecorationImage(
                                                                                        image: NetworkImage(forumImagesList[index]),
                                                                                        fit: BoxFit.fill)),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: width / 1.6,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            width: width / 1.95,
                                                                                            child: Text(
                                                                                              forumTitlesList[index],
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(14),
                                                                                                  fontWeight: FontWeight.w600),
                                                                                            )),
                                                                                        const Icon(
                                                                                          Icons.more_horiz,
                                                                                          size: 20,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                      height: height / 54.13,
                                                                                      child: Text(
                                                                                        forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                      )),
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: width / 1.6,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: height / 45.11,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                margin: EdgeInsets.only(right: width / 25),
                                                                                                height: height / 40.6,
                                                                                                width: width / 18.75,
                                                                                                child: forumUseList[index]
                                                                                                    ? SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                                      )
                                                                                                    : SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/like_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                                      ),
                                                                                              ),
                                                                                              Container(
                                                                                                  height: height / 40.6,
                                                                                                  width: width / 18.75,
                                                                                                  margin: EdgeInsets.only(right: width / 25),
                                                                                                  child: SvgPicture.asset(
                                                                                                    isDarkTheme.value
                                                                                                        ? "assets/home_screen/share_dark.svg"
                                                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                                  )),
                                                                                              Container(
                                                                                                height: height / 40.6,
                                                                                                width: width / 18.75,
                                                                                                margin: EdgeInsets.only(right: width / 25),
                                                                                                child: forumUseDisList[index]
                                                                                                    ? SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                                      )
                                                                                                    : SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/dislike_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                                      ),
                                                                                              ),
                                                                                              Container(
                                                                                                  height: height / 40.6,
                                                                                                  width: width / 18.75,
                                                                                                  margin: EdgeInsets.only(right: width / 25),
                                                                                                  child: SvgPicture.asset(
                                                                                                    "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                                    colorFilter: ColorFilter.mode(
                                                                                                        isDarkTheme.value
                                                                                                            ? const Color(0XFFD6D6D6)
                                                                                                            : const Color(0XFF0EA102),
                                                                                                        BlendMode.srcIn),
                                                                                                  )),
                                                                                              bookMarkWidget(
                                                                                                  bookMark: forumBookMarkList,
                                                                                                  context: context,
                                                                                                  scale: 3.4,
                                                                                                  enabled: false,
                                                                                                  id: forumIdList[index],
                                                                                                  type: 'forums',
                                                                                                  modelSetState: setState,
                                                                                                  index: index,
                                                                                                  initFunction: getAllData,
                                                                                                  notUse: false),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        widgetsMain.translationWidget(
                                                                                            translationList: translationList,
                                                                                            id: forumIdList[index],
                                                                                            type: 'forums',
                                                                                            index: index,
                                                                                            initFunction: getAllData,
                                                                                            context: context,
                                                                                            modelSetState: setState,
                                                                                            notUse: false,
                                                                                            titleList: forumTitlesList)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 81.2,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            width: width / 7.5,
                                                                                            child: Text(forumCompanyList[index],
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.blue))),
                                                                                        SizedBox(width: width / 22.05),
                                                                                        Text(forumViewsList[index].toString(),
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w700)),
                                                                                        Text(" views",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500)),
                                                                                        SizedBox(width: width / 22.05),
                                                                                        Text(forumResponseList[index].toString(),
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w700)),
                                                                                        Text(" Response",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500)),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                          /*Column(
                                                    children: [
                                                      Icon(Icons.more_horiz,size: 20,),
                                                      SizedBox(height: 20,),
                                                      widgetsMain.translationWidget(
                                                          translationList: translationList,
                                                          id: forumIdList[index],
                                                          type: 'forums',
                                                          index: index,
                                                          initFunction: getAllData,
                                                          context: context,
                                                          modelSetState: setState,
                                                          notUse: false,
                                                          titleList: forumTitlesList)
                                                    ],
                                                  ),*/
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 86.6,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                        return Container(
                                                          margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
                                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(context).colorScheme.background,
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                              ]),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height / 86.6,
                                                              ),
                                                              Container(
                                                                color: Theme.of(context).colorScheme.background,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          height: height / 13.53,
                                                                          width: width / 5.95,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              width / 23.43, height / 203, width / 37.5, height / 27.06),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Theme.of(context).colorScheme.tertiary,
                                                                              image: DecorationImage(
                                                                                  image: NetworkImage(forumImagesList[index]), fit: BoxFit.fill)),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: width / 1.6,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                      width: width / 1.95,
                                                                                      child: Text(
                                                                                        forumTitlesList[index],
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                      )),
                                                                                  const Icon(
                                                                                    Icons.more_horiz,
                                                                                    size: 20,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                                height: height / 54.13,
                                                                                child: Text(
                                                                                  forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                )),
                                                                            SizedBox(
                                                                              height: height / 54.13,
                                                                            ),
                                                                            SizedBox(
                                                                              width: width / 1.6,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: height / 45.11,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                                          height: height / 40.6,
                                                                                          width: width / 18.75,
                                                                                          child: forumUseList[index]
                                                                                              ? SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/like_filled_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                                )
                                                                                              : SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/like_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                                ),
                                                                                        ),
                                                                                        Container(
                                                                                            height: height / 40.6,
                                                                                            width: width / 18.75,
                                                                                            margin: EdgeInsets.only(right: width / 25),
                                                                                            child: SvgPicture.asset(
                                                                                              isDarkTheme.value
                                                                                                  ? "assets/home_screen/share_dark.svg"
                                                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                            )),
                                                                                        Container(
                                                                                          height: height / 40.6,
                                                                                          width: width / 18.75,
                                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                                          child: forumUseDisList[index]
                                                                                              ? SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                                )
                                                                                              : SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/dislike_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                                ),
                                                                                        ),
                                                                                        Container(
                                                                                            height: height / 40.6,
                                                                                            width: width / 18.75,
                                                                                            margin: EdgeInsets.only(right: width / 25),
                                                                                            child: SvgPicture.asset(
                                                                                              "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                              colorFilter: ColorFilter.mode(
                                                                                                  isDarkTheme.value
                                                                                                      ? const Color(0XFFD6D6D6)
                                                                                                      : const Color(0XFF0EA102),
                                                                                                  BlendMode.srcIn),
                                                                                            )),
                                                                                        bookMarkWidget(
                                                                                            bookMark: forumBookMarkList,
                                                                                            context: context,
                                                                                            scale: 3.4,
                                                                                            enabled: false,
                                                                                            id: forumIdList[index],
                                                                                            type: 'forums',
                                                                                            modelSetState: setState,
                                                                                            index: index,
                                                                                            initFunction: getAllData,
                                                                                            notUse: false),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  widgetsMain.translationWidget(
                                                                                      translationList: translationList,
                                                                                      id: forumIdList[index],
                                                                                      type: 'forums',
                                                                                      index: index,
                                                                                      initFunction: getAllData,
                                                                                      context: context,
                                                                                      modelSetState: setState,
                                                                                      notUse: false,
                                                                                      titleList: forumTitlesList)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 81.2,
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 54.13,
                                                                              child: Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                      width: width / 7.5,
                                                                                      child: Text(forumCompanyList[index],
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              fontWeight: FontWeight.w700,
                                                                                              color: Colors.blue))),
                                                                                  SizedBox(width: width / 22.05),
                                                                                  Text(forumViewsList[index].toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                  Text(" views",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                  SizedBox(width: width / 22.05),
                                                                                  Text(forumResponseList[index].toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                  Text(" Response",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    /*Column(
                                                    children: [
                                                      Icon(Icons.more_horiz,size: 20,),
                                                      SizedBox(height: 20,),
                                                      widgetsMain.translationWidget(
                                                          translationList: translationList,
                                                          id: forumIdList[index],
                                                          type: 'forums',
                                                          index: index,
                                                          initFunction: getAllData,
                                                          context: context,
                                                          modelSetState: setState,
                                                          notUse: false,
                                                          titleList: forumTitlesList)
                                                    ],
                                                  ),*/
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 86.6,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 15,
                                    child: Container(
                                      width: width * 0.6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).colorScheme.background,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: enteredFilteredList.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onTap: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    setState(() {
                                                      newsInt = 0;
                                                      extraContainMain.value = false;
                                                      selectedWidget = enteredFilteredList[index];
                                                      finalisedFilterName = enteredFilteredList[index];
                                                      filterBool = true;
                                                      filterId = enteredFilteredIdList[index];
                                                      finalisedFilterId = enteredFilteredIdList[index];
                                                      prefs.setString('finalisedFilterId1', finalisedFilterId);
                                                      prefs.setString('finalisedFilterName1', finalisedFilterName);
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                    await getFil(type: finalisedCategory, filterId: finalisedFilterId);
                                                    await getForumValues(
                                                        category: finalisedCategory,
                                                        filterId: finalisedFilterId,
                                                        text: _searchController.text.isEmpty ? "" : _searchController.text);
                                                  },
                                                  title: Text(
                                                    enteredFilteredList[index],
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                  ),
                                                  trailing: SizedBox(
                                                    width: 85,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                          splashRadius: 0.1,
                                                          onPressed: () async {
                                                            var response =
                                                                await _filterFunction.getEditFilter(filterId: enteredFilteredIdList[index]);
                                                            setState(() {
                                                              extraContainMain.value = false;
                                                              if (selectedValue == "Stocks") {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return StocksEditFilterPage(
                                                                    text: selectedValue,
                                                                    filterId: enteredFilteredIdList[index],
                                                                    response: response,
                                                                    page: 'forums',
                                                                  );
                                                                }));
                                                              } else if (selectedValue == "Crypto") {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return CryptoEditFilterPage(
                                                                    text: selectedValue,
                                                                    filterId: enteredFilteredIdList[index],
                                                                    response: response,
                                                                    page: 'forums',
                                                                  );
                                                                }));
                                                              } else if (selectedValue == "Commodity") {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return CommodityEditFilterPage(
                                                                    text: selectedValue,
                                                                    filterId: enteredFilteredIdList[index],
                                                                    response: response,
                                                                    page: 'forums',
                                                                  );
                                                                }));
                                                              } else {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return ForexEditFilterPage(
                                                                    text: selectedValue,
                                                                    filterId: enteredFilteredIdList[index],
                                                                    response: response,
                                                                    page: 'forums',
                                                                  );
                                                                }));
                                                              }
                                                            });
                                                          },
                                                          icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg"),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        SizedBox(
                                                          height: height / 25.375,
                                                          width: width / 11.72,
                                                          child: IconButton(
                                                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                            splashRadius: 0.1,
                                                            onPressed: () async {
                                                              await _filterFunction.getDeleteFilter(filterId: enteredFilteredIdList[index]);
                                                              await getFil(type: selectedValue, filterId: "");
                                                              getForumValues(
                                                                  text: _searchController.text,
                                                                  category: finalisedCategory,
                                                                  filterId: finalisedFilterId);
                                                            },
                                                            icon: SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/x-circle.png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                          enteredFilteredIdList.length == 4
                                              ? const SizedBox()
                                              : ListTile(
                                                  onTap: () {
                                                    extraContainMain.value = false;
                                                    navigationPage1();
                                                  },
                                                  title:
                                                      Text("Add a New List", style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600)),
                                                  trailing: Container(
                                                    margin: const EdgeInsets.only(right: 10),
                                                    child: const Icon(
                                                      Icons.add_circle_outline_sharp,
                                                      size: 22,
                                                      color: Color(0XFF0EA102),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      : NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (scroll) {
                            scroll.disallowIndicator();
                            return true;
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                startSearch
                                    ? const SizedBox()
                                    : Container(
                                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                        child: const Text("Topics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                                startSearch
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 50.75,
                                      ),
                                startSearch
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 3.8,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 9,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: index == 0 ? width / 31.25 : width / 62.5,
                                                    right: index == 8 ? width / 31.25 : width / 62.5,
                                                    bottom: 15),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    logEventFunc(name: eventNames[index], type: 'Forum');
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return DetailedForumImagePage(
                                                        text: selectedValue,
                                                        tickerId: '',
                                                        tickerName: "",
                                                        fromCompare: false,
                                                        catIdList: mainCatIdList,
                                                        filterId: selectedIdWidget,
                                                        topic: designTopics[index],
                                                        forumDetail: "",
                                                        navBool: false,
                                                        sendUserId: "",
                                                      );
                                                    }));
                                                  },
                                                  child: Card(
                                                    elevation: 10.0,
                                                    shape: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.background)),
                                                    child: Stack(
                                                      alignment: Alignment.bottomLeft,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(
                                                              left: index == 0 ? width / 18.75 : width / 37.5,
                                                              right: index == 8 ? width / 18.75 : width / 37.5),
                                                          width: width / 2.7,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(designImages[index]),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            color: Theme.of(context).colorScheme.background,
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: height / 16.24,
                                                          width: width / 2.7,
                                                          padding: EdgeInsets.only(
                                                              left: index == 0 ? width / 18.75 : width / 37.5,
                                                              right: index == 8 ? width / 18.75 : width / 37.5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.only(
                                                                  bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                                                              color: Colors.black12.withOpacity(0.3)),
                                                          child: Center(
                                                            child: Text(
                                                              designTopics[index],
                                                              style: TextStyle(
                                                                  fontSize: text.scale(12),
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins"),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                  height: height / 19.33,
                                  child: TextFormField(
                                    cursorColor: Colors.green,
                                    onTap: () {
                                      setState(() {
                                        startSearch = true;
                                      });
                                    },
                                    onChanged: (value) async {
                                      context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                      setState(() {
                                        searchLoader = true;
                                      });
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          startSearch = true;
                                        });
                                        newsInt = 0;
                                        await getFil(type: selectedValue, filterId: finalisedFilterId == "" ? "" : finalisedFilterId);
                                        await getForumValues(text: value, category: selectedValue, filterId: selectedIdWidget);
                                      } else {
                                        setState(() {
                                          startSearch = false;
                                        });
                                        newsInt = 0;
                                        await getFil(type: selectedValue, filterId: finalisedFilterId == "" ? "" : finalisedFilterId);
                                        await getForumValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (_searchController.text.isEmpty) {
                                        setState(() {
                                          startSearch = false;
                                        });
                                      } else {
                                        setState(() {
                                          startSearch = false;
                                        });
                                      }
                                    },
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    controller: _searchController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).colorScheme.tertiary,
                                      filled: true,
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                        child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                      ),
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () async {
                                                context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                                setState(() {
                                                  startSearch = false;
                                                  _searchController.clear();
                                                });
                                                await getFil(type: selectedValue, filterId: finalisedFilterId == "" ? "" : finalisedFilterId);
                                                await getForumValues(text: "", category: finalisedCategory, filterId: finalisedFilterId);
                                                FocusManager.instance.primaryFocus?.unfocus();
                                              },
                                              child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                                            )
                                          : const SizedBox(),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                                      hintText: 'Search here',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 50.75,
                                ),
                                searchLoader
                                    ? SizedBox(
                                        height: height / 2.37,
                                        child: Center(
                                          child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                        ),
                                      )
                                    : emptyBool
                                        ? Container(
                                            margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '😟 Looks like there is no Forum created under this topic, Would you like to a add ',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 10)*/),
                                                      TextSpan(
                                                          text: ' Add here',
                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              color: const Color(0XFF0EA102),
                                                              fontWeight: FontWeight
                                                                  .w700) /*const TextStyle(
                                                              fontFamily: "Poppins",
                                                              color: Color(0XFF0EA102),
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 12)*/
                                                          ,
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return ForumPostPage(
                                                                  text: widget.text,
                                                                );
                                                              }));
                                                              if (response) {
                                                                await getForumValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                                                              }
                                                            }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                            height: startSearch ? height / 1.2 : height / 2.54,
                                            child: SmartRefresher(
                                              controller: _refreshController,
                                              enablePullDown: false,
                                              enablePullUp: true,
                                              footer: CustomFooter(
                                                builder: (BuildContext context, LoadStatus? mode) {
                                                  Widget body;
                                                  if (mode == LoadStatus.idle) {
                                                    body = const Text("pull up to load");
                                                  } else if (mode == LoadStatus.loading) {
                                                    body = const CupertinoActivityIndicator();
                                                  } else if (mode == LoadStatus.failed) {
                                                    body = const Text("Load Failed!Click retry!");
                                                  } else if (mode == LoadStatus.canLoading) {
                                                    body = const Text("release to load more");
                                                  } else {
                                                    body = const Text("No more Data");
                                                  }
                                                  return SizedBox(
                                                    height: height / 14.76,
                                                    child: Center(child: body),
                                                  );
                                                },
                                              ),
                                              onLoading: _onForumLoading,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: forumTitlesList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                            height: height / 9.10,
                                                            margin: const EdgeInsets.symmetric(horizontal: 15),
                                                            child: AdWidget(ad: nativeAdList[index])),
                                                        SizedBox(height: height / 57.73),
                                                        GestureDetector(
                                                            onTap: () async {
                                                              bool refresh =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return ForumPostDescriptionPage(
                                                                  forumId: forumIdList[index],
                                                                  comeFrom: "forum",
                                                                  idList: forumIdList,
                                                                );
                                                              }));
                                                              if (refresh) {
                                                                initState();
                                                              }
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets.only(bottom: height / 35, right: 2, left: 2, top: 2),
                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                  ]),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: height / 86.6,
                                                                  ),
                                                                  Container(
                                                                    color: Theme.of(context).colorScheme.background,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                bool refresh = await Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                  return UserBillBoardProfilePage(
                                                                                      userId: forumUserIdList[
                                                                                          index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                }));
                                                                                if (refresh) {
                                                                                  initState();
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: height / 13.53,
                                                                                width: width / 5.95,
                                                                                margin: EdgeInsets.fromLTRB(
                                                                                    width / 23.43, height / 203, width / 37.5, height / 27.06),
                                                                                decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: Theme.of(context).colorScheme.tertiary,
                                                                                    image: DecorationImage(
                                                                                        image: NetworkImage(
                                                                                          forumImagesList[index],
                                                                                        ),
                                                                                        fit: BoxFit.fill)),
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: width / 1.6,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                          width: width / 1.95,
                                                                                          child: Text(
                                                                                            forumTitlesList[index],
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(14),
                                                                                                fontWeight: FontWeight.w600),
                                                                                          )),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          showModalBottomSheet(
                                                                                              shape: const RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.vertical(
                                                                                                  top: Radius.circular(30),
                                                                                                ),
                                                                                              ),
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                return SingleChildScrollView(
                                                                                                  child: Container(
                                                                                                    margin: EdgeInsets.symmetric(
                                                                                                        horizontal: width / 18.75),
                                                                                                    padding: EdgeInsets.only(
                                                                                                        bottom:
                                                                                                            MediaQuery.of(context).viewInsets.bottom),
                                                                                                    child: forumMyList[index]
                                                                                                        ? Column(
                                                                                                            mainAxisAlignment:
                                                                                                                MainAxisAlignment.start,
                                                                                                            crossAxisAlignment:
                                                                                                                CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              ListTile(
                                                                                                                onTap: () async {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  bool response =
                                                                                                                      await Navigator.push(context,
                                                                                                                          MaterialPageRoute(builder:
                                                                                                                              (BuildContext context) {
                                                                                                                    return ForumPostEditPage(
                                                                                                                      text: widget.text,
                                                                                                                      catIdList: mainCatIdList,
                                                                                                                      filterId: finalisedFilterId,
                                                                                                                      forumId: forumIdList[index],
                                                                                                                    );
                                                                                                                  }));
                                                                                                                  if (response) {
                                                                                                                    await getForumValues(
                                                                                                                        text: "",
                                                                                                                        category: selectedValue,
                                                                                                                        filterId: selectedIdWidget);
                                                                                                                  }
                                                                                                                },
                                                                                                                minLeadingWidth: width / 25,
                                                                                                                leading: const Icon(
                                                                                                                  Icons.edit,
                                                                                                                  size: 20,
                                                                                                                ),
                                                                                                                title: Text(
                                                                                                                  "Edit Post",
                                                                                                                  style: TextStyle(
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: text.scale(14)),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Divider(
                                                                                                                color: Theme.of(context)
                                                                                                                    .colorScheme
                                                                                                                    .tertiary,
                                                                                                                thickness: 0.8,
                                                                                                              ),
                                                                                                              ListTile(
                                                                                                                onTap: () {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  showDialog(
                                                                                                                      barrierDismissible: false,
                                                                                                                      context: context,
                                                                                                                      builder:
                                                                                                                          (BuildContext context) {
                                                                                                                        return Dialog(
                                                                                                                          shape:
                                                                                                                              RoundedRectangleBorder(
                                                                                                                                  borderRadius:
                                                                                                                                      BorderRadius
                                                                                                                                          .circular(
                                                                                                                                              20.0)),
                                                                                                                          //this right here
                                                                                                                          child: Container(
                                                                                                                            height: height / 6,
                                                                                                                            margin:
                                                                                                                                EdgeInsets.symmetric(
                                                                                                                                    vertical: height /
                                                                                                                                        54.13,
                                                                                                                                    horizontal:
                                                                                                                                        width / 25),
                                                                                                                            child: Column(
                                                                                                                              mainAxisAlignment:
                                                                                                                                  MainAxisAlignment
                                                                                                                                      .center,
                                                                                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                              children: [
                                                                                                                                const Center(
                                                                                                                                    child: Text(
                                                                                                                                        "Delete Post",
                                                                                                                                        style: TextStyle(
                                                                                                                                            color: Color(
                                                                                                                                                0XFF0EA102),
                                                                                                                                            fontWeight:
                                                                                                                                                FontWeight
                                                                                                                                                    .bold,
                                                                                                                                            fontSize:
                                                                                                                                                20,
                                                                                                                                            fontFamily:
                                                                                                                                                "Poppins"))),
                                                                                                                                const Divider(),
                                                                                                                                const Center(
                                                                                                                                    child: Text(
                                                                                                                                        "Are you sure to Delete this Post")),
                                                                                                                                const Spacer(),
                                                                                                                                Padding(
                                                                                                                                  padding: EdgeInsets
                                                                                                                                      .symmetric(
                                                                                                                                          horizontal:
                                                                                                                                              width /
                                                                                                                                                  25),
                                                                                                                                  child: Row(
                                                                                                                                    mainAxisAlignment:
                                                                                                                                        MainAxisAlignment
                                                                                                                                            .spaceBetween,
                                                                                                                                    children: [
                                                                                                                                      TextButton(
                                                                                                                                        onPressed:
                                                                                                                                            () {
                                                                                                                                          Navigator.pop(
                                                                                                                                              context);
                                                                                                                                        },
                                                                                                                                        child:
                                                                                                                                            const Text(
                                                                                                                                          "Cancel",
                                                                                                                                          style: TextStyle(
                                                                                                                                              color: Colors
                                                                                                                                                  .grey,
                                                                                                                                              fontWeight:
                                                                                                                                                  FontWeight
                                                                                                                                                      .w600,
                                                                                                                                              fontFamily:
                                                                                                                                                  "Poppins",
                                                                                                                                              fontSize:
                                                                                                                                                  15),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                      ElevatedButton(
                                                                                                                                        style: ElevatedButton
                                                                                                                                            .styleFrom(
                                                                                                                                          shape:
                                                                                                                                              RoundedRectangleBorder(
                                                                                                                                            borderRadius:
                                                                                                                                                BorderRadius.circular(
                                                                                                                                                    18.0),
                                                                                                                                          ),
                                                                                                                                          backgroundColor:
                                                                                                                                              const Color(
                                                                                                                                                  0XFF0EA102),
                                                                                                                                        ),
                                                                                                                                        onPressed:
                                                                                                                                            () async {
                                                                                                                                          deletePost(
                                                                                                                                              forumId:
                                                                                                                                                  forumIdList[index]);
                                                                                                                                          Navigator.pop(
                                                                                                                                              context);
                                                                                                                                        },
                                                                                                                                        child:
                                                                                                                                            const Text(
                                                                                                                                          "Continue",
                                                                                                                                          style: TextStyle(
                                                                                                                                              color: Colors
                                                                                                                                                  .white,
                                                                                                                                              fontWeight:
                                                                                                                                                  FontWeight
                                                                                                                                                      .w600,
                                                                                                                                              fontFamily:
                                                                                                                                                  "Poppins",
                                                                                                                                              fontSize:
                                                                                                                                                  15),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                                const Spacer(),
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        );
                                                                                                                      });
                                                                                                                },
                                                                                                                minLeadingWidth: width / 25,
                                                                                                                leading: const Icon(
                                                                                                                  Icons.delete,
                                                                                                                  size: 20,
                                                                                                                ),
                                                                                                                title: Text(
                                                                                                                  "Delete Post",
                                                                                                                  style: TextStyle(
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: text.scale(14)),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          )
                                                                                                        : Column(
                                                                                                            mainAxisAlignment:
                                                                                                                MainAxisAlignment.start,
                                                                                                            crossAxisAlignment:
                                                                                                                CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              ListTile(
                                                                                                                onTap: () {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  _controller.clear();
                                                                                                                  setState(() {
                                                                                                                    actionValue = "Report";
                                                                                                                  });
                                                                                                                  showAlertDialog(
                                                                                                                      context: context,
                                                                                                                      forumId: forumIdList[index],
                                                                                                                      forumUserId:
                                                                                                                          forumUserIdList[index]);
                                                                                                                },
                                                                                                                minLeadingWidth: width / 25,
                                                                                                                leading: const Icon(
                                                                                                                  Icons.shield,
                                                                                                                  size: 20,
                                                                                                                ),
                                                                                                                title: Text(
                                                                                                                  "Report Post",
                                                                                                                  style: TextStyle(
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: text.scale(14)),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Divider(
                                                                                                                color: Theme.of(context)
                                                                                                                    .colorScheme
                                                                                                                    .tertiary,
                                                                                                                thickness: 0.8,
                                                                                                              ),
                                                                                                              ListTile(
                                                                                                                onTap: () {
                                                                                                                  _controller.clear();
                                                                                                                  setState(() {
                                                                                                                    actionValue = "Block";
                                                                                                                  });
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  showAlertDialog(
                                                                                                                      context: context,
                                                                                                                      forumId: forumIdList[index],
                                                                                                                      forumUserId:
                                                                                                                          forumUserIdList[index]);
                                                                                                                },
                                                                                                                minLeadingWidth: width / 25,
                                                                                                                leading: const Icon(
                                                                                                                  Icons.flag,
                                                                                                                  size: 20,
                                                                                                                ),
                                                                                                                title: Text(
                                                                                                                  "Block Post",
                                                                                                                  style: TextStyle(
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: text.scale(14)),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                  ),
                                                                                                );
                                                                                              });
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.more_horiz,
                                                                                          size: 20,
                                                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    bool refresh = await Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return UserBillBoardProfilePage(
                                                                                          userId: forumUserIdList[
                                                                                              index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                    }));
                                                                                    if (refresh) {
                                                                                      initState();
                                                                                    }
                                                                                  },
                                                                                  child: SizedBox(
                                                                                      height: height / 54.13,
                                                                                      child: Text(
                                                                                        forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                      )),
                                                                                ),
                                                                                SizedBox(height: height / 54.13),
                                                                                SizedBox(
                                                                                  width: width / 1.6,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: height / 45.11,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                bool response1 = await likeFunction(
                                                                                                    id: forumIdList[index], type: "forums");
                                                                                                if (response1) {
                                                                                                  logEventFunc(name: "Likes", type: "Forum");
                                                                                                  setState(() {
                                                                                                    if (forumUseList[index] == true) {
                                                                                                      if (forumUseDisList[index] == true) {
                                                                                                      } else {
                                                                                                        forumLikeList[index] -= 1;
                                                                                                      }
                                                                                                    } else {
                                                                                                      if (forumUseDisList[index] == true) {
                                                                                                        forumDislikeList[index] -= 1;
                                                                                                        forumLikeList[index] += 1;
                                                                                                      } else {
                                                                                                        forumLikeList[index] += 1;
                                                                                                      }
                                                                                                    }
                                                                                                    forumUseList[index] = !forumUseList[index];
                                                                                                    forumUseDisList[index] = false;
                                                                                                  });
                                                                                                } else {}
                                                                                              },
                                                                                              child: Container(
                                                                                                margin: EdgeInsets.only(right: width / 25),
                                                                                                height: height / 40.6,
                                                                                                width: width / 18.75,
                                                                                                child: forumUseList[index]
                                                                                                    ? SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                                      )
                                                                                                    : SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/like_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                                      ),
                                                                                              ),
                                                                                            ),
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                logEventFunc(name: "Share", type: "Forum");
                                                                                                newLink = await getLinK(
                                                                                                    id: forumIdList[index],
                                                                                                    type: "forums",
                                                                                                    description: '',
                                                                                                    imageUrl: "",
                                                                                                    title: forumTitlesList[index],
                                                                                                    category: selectedValue,
                                                                                                    filterId: selectedIdWidget);
                                                                                                ShareResult result = await Share.share(
                                                                                                  "Look what I was able to find on Tradewatch: ${forumTitlesList[index]} ${newLink.toString()}",
                                                                                                );
                                                                                                if (result.status == ShareResultStatus.success) {
                                                                                                  await shareFunction(
                                                                                                      id: forumIdList[index], type: "forums");
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                  height: height / 40.6,
                                                                                                  width: width / 18.75,
                                                                                                  margin: EdgeInsets.only(right: width / 25),
                                                                                                  child: SvgPicture.asset(
                                                                                                    isDarkTheme.value
                                                                                                        ? "assets/home_screen/share_dark.svg"
                                                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                                  )),
                                                                                            ),
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                bool response3 = await disLikeFunction(
                                                                                                    id: forumIdList[index], type: "forums");
                                                                                                if (response3) {
                                                                                                  logEventFunc(name: "Dislikes", type: "Forum");
                                                                                                  setState(() {
                                                                                                    if (forumUseDisList[index] == true) {
                                                                                                      if (forumUseList[index] == true) {
                                                                                                      } else {
                                                                                                        forumDislikeList[index] -= 1;
                                                                                                      }
                                                                                                    } else {
                                                                                                      if (forumUseList[index] == true) {
                                                                                                        forumLikeList[index] -= 1;
                                                                                                        forumDislikeList[index] += 1;
                                                                                                      } else {
                                                                                                        forumDislikeList[index] += 1;
                                                                                                      }
                                                                                                    }
                                                                                                    forumUseDisList[index] = !forumUseDisList[index];
                                                                                                    forumUseList[index] = false;
                                                                                                  });
                                                                                                } else {}
                                                                                              },
                                                                                              child: Container(
                                                                                                height: height / 40.6,
                                                                                                width: width / 18.75,
                                                                                                margin: EdgeInsets.only(right: width / 25),
                                                                                                child: forumUseDisList[index]
                                                                                                    ? SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                                      )
                                                                                                    : SvgPicture.asset(
                                                                                                        isDarkTheme.value
                                                                                                            ? "assets/home_screen/dislike_dark.svg"
                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                                      ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                                height: height / 40.6,
                                                                                                width: width / 18.75,
                                                                                                margin: EdgeInsets.only(right: width / 25),
                                                                                                child: SvgPicture.asset(
                                                                                                  "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                                  colorFilter: ColorFilter.mode(
                                                                                                      isDarkTheme.value
                                                                                                          ? const Color(0XFFD6D6D6)
                                                                                                          : const Color(0XFF0EA102),
                                                                                                      BlendMode.srcIn),
                                                                                                )),
                                                                                            bookMarkWidget(
                                                                                                bookMark: forumBookMarkList,
                                                                                                context: context,
                                                                                                scale: 3.4,
                                                                                                id: forumIdList[index],
                                                                                                type: 'forums',
                                                                                                modelSetState: setState,
                                                                                                index: index,
                                                                                                initFunction: getAllData,
                                                                                                notUse: false),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      widgetsMain.translationWidget(
                                                                                          translationList: translationList,
                                                                                          id: forumIdList[index],
                                                                                          type: 'forums',
                                                                                          index: index,
                                                                                          initFunction: getAllData,
                                                                                          context: context,
                                                                                          modelSetState: setState,
                                                                                          notUse: false,
                                                                                          titleList: forumTitlesList)
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: height / 81.2),
                                                                                SizedBox(
                                                                                  height: height / 54.13,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                          width: width / 7.5,
                                                                                          child: Text(forumCompanyList[index],
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: Colors.blue))),
                                                                                      SizedBox(width: width / 22.05),
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          setState(() {
                                                                                            kUserSearchController.clear();
                                                                                            onTapType = "Views";
                                                                                            onTapId = forumIdList[index];
                                                                                            onLike = false;
                                                                                            onDislike = false;
                                                                                            onViews = true;
                                                                                            idKeyMain = "forum_id";
                                                                                            apiMain = baseurl + versionForum + viewsCount;
                                                                                            onTapIdMain = forumIdList[index];
                                                                                            onTapTypeMain = "Views";
                                                                                            haveViewsMain = forumViewsList[index] > 0 ? true : false;
                                                                                            viewCountMain = forumViewsList[index];
                                                                                            kToken = mainUserToken;
                                                                                          });
                                                                                          //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionForum + viewsCount, idKey: 'forum_id', setState: setState);
                                                                                          bool data = await likeCountFunc(
                                                                                              context: context, newSetState: setState);
                                                                                          if (data) {
                                                                                            if (!mounted) {
                                                                                              return;
                                                                                            }
                                                                                            customShowSheet1(context: context);
                                                                                            setState(() {
                                                                                              loaderMain = true;
                                                                                            });
                                                                                          } else {
                                                                                            if (!mounted) {
                                                                                              return;
                                                                                            }
                                                                                            Flushbar(
                                                                                              message: "Still no one has viewed this post",
                                                                                              duration: const Duration(seconds: 2),
                                                                                            ).show(context);
                                                                                          }
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(forumViewsList[index].toString(),
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700)),
                                                                                            Text(" views",
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w500)),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: width / 22.05),
                                                                                      Text(forumResponseList[index].toString(),
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                      Text(" Response",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 86.6,
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                      ],
                                                    );
                                                  }
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        bool refresh =
                                                            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return ForumPostDescriptionPage(
                                                            forumId: forumIdList[index],
                                                            comeFrom: "forum",
                                                            idList: forumIdList,
                                                          );
                                                        }));
                                                        if (refresh) {
                                                          initState();
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(bottom: height / 35, right: 2, left: 2, top: 2),
                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.background,
                                                            borderRadius: BorderRadius.circular(20),
                                                            boxShadow: [
                                                              BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                            ]),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: height / 86.6,
                                                            ),
                                                            Container(
                                                              color: Theme.of(context).colorScheme.background,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          bool refresh = await Navigator.push(context,
                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                            return UserBillBoardProfilePage(
                                                                                userId: forumUserIdList[
                                                                                    index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                          }));
                                                                          if (refresh) {
                                                                            initState();
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          height: height / 13.53,
                                                                          width: width / 5.95,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              width / 23.43, height / 203, width / 37.5, height / 27.06),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Theme.of(context).colorScheme.tertiary,
                                                                              image: DecorationImage(
                                                                                  image: NetworkImage(
                                                                                    forumImagesList[index],
                                                                                  ),
                                                                                  fit: BoxFit.fill)),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: width / 1.6,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                    width: width / 1.95,
                                                                                    child: Text(
                                                                                      forumTitlesList[index],
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                    )),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    showModalBottomSheet(
                                                                                        shape: const RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.vertical(
                                                                                            top: Radius.circular(30),
                                                                                          ),
                                                                                        ),
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return SingleChildScrollView(
                                                                                            child: Container(
                                                                                              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                                                                              padding: EdgeInsets.only(
                                                                                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                              child: forumMyList[index]
                                                                                                  ? Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        ListTile(
                                                                                                          onTap: () async {
                                                                                                            if (!mounted) {
                                                                                                              return;
                                                                                                            }
                                                                                                            Navigator.pop(context);
                                                                                                            bool response = await Navigator.push(
                                                                                                                context, MaterialPageRoute(
                                                                                                                    builder: (BuildContext context) {
                                                                                                              return ForumPostEditPage(
                                                                                                                text: widget.text,
                                                                                                                catIdList: mainCatIdList,
                                                                                                                filterId: finalisedFilterId,
                                                                                                                forumId: forumIdList[index],
                                                                                                              );
                                                                                                            }));
                                                                                                            if (response) {
                                                                                                              await getForumValues(
                                                                                                                  text: "",
                                                                                                                  category: selectedValue,
                                                                                                                  filterId: selectedIdWidget);
                                                                                                            }
                                                                                                          },
                                                                                                          minLeadingWidth: width / 25,
                                                                                                          leading: const Icon(
                                                                                                            Icons.edit,
                                                                                                            size: 20,
                                                                                                          ),
                                                                                                          title: Text(
                                                                                                            "Edit Post",
                                                                                                            style: TextStyle(
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: text.scale(14)),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color:
                                                                                                              Theme.of(context).colorScheme.tertiary,
                                                                                                          thickness: 0.8,
                                                                                                        ),
                                                                                                        ListTile(
                                                                                                          onTap: () {
                                                                                                            if (!mounted) {
                                                                                                              return;
                                                                                                            }
                                                                                                            Navigator.pop(context);
                                                                                                            showDialog(
                                                                                                                barrierDismissible: false,
                                                                                                                context: context,
                                                                                                                builder: (BuildContext context) {
                                                                                                                  return Dialog(
                                                                                                                    shape: RoundedRectangleBorder(
                                                                                                                        borderRadius:
                                                                                                                            BorderRadius.circular(
                                                                                                                                20.0)),
                                                                                                                    //this right here
                                                                                                                    child: Container(
                                                                                                                      height: height / 6,
                                                                                                                      margin: EdgeInsets.symmetric(
                                                                                                                          vertical: height / 54.13,
                                                                                                                          horizontal: width / 25),
                                                                                                                      child: Column(
                                                                                                                        mainAxisAlignment:
                                                                                                                            MainAxisAlignment.center,
                                                                                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          const Center(
                                                                                                                              child: Text(
                                                                                                                                  "Delete Post",
                                                                                                                                  style: TextStyle(
                                                                                                                                      color: Color(
                                                                                                                                          0XFF0EA102),
                                                                                                                                      fontWeight:
                                                                                                                                          FontWeight
                                                                                                                                              .bold,
                                                                                                                                      fontSize: 20,
                                                                                                                                      fontFamily:
                                                                                                                                          "Poppins"))),
                                                                                                                          const Divider(),
                                                                                                                          const Center(
                                                                                                                              child: Text(
                                                                                                                                  "Are you sure to Delete this Post")),
                                                                                                                          const Spacer(),
                                                                                                                          Padding(
                                                                                                                            padding:
                                                                                                                                EdgeInsets.symmetric(
                                                                                                                                    horizontal:
                                                                                                                                        width / 25),
                                                                                                                            child: Row(
                                                                                                                              mainAxisAlignment:
                                                                                                                                  MainAxisAlignment
                                                                                                                                      .spaceBetween,
                                                                                                                              children: [
                                                                                                                                TextButton(
                                                                                                                                  onPressed: () {
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);
                                                                                                                                  },
                                                                                                                                  child: const Text(
                                                                                                                                    "Cancel",
                                                                                                                                    style: TextStyle(
                                                                                                                                        color: Colors
                                                                                                                                            .grey,
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight
                                                                                                                                                .w600,
                                                                                                                                        fontFamily:
                                                                                                                                            "Poppins",
                                                                                                                                        fontSize: 15),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                                ElevatedButton(
                                                                                                                                  style:
                                                                                                                                      ElevatedButton
                                                                                                                                          .styleFrom(
                                                                                                                                    shape:
                                                                                                                                        RoundedRectangleBorder(
                                                                                                                                      borderRadius:
                                                                                                                                          BorderRadius
                                                                                                                                              .circular(
                                                                                                                                                  18.0),
                                                                                                                                    ),
                                                                                                                                    backgroundColor:
                                                                                                                                        const Color(
                                                                                                                                            0XFF0EA102),
                                                                                                                                  ),
                                                                                                                                  onPressed:
                                                                                                                                      () async {
                                                                                                                                    deletePost(
                                                                                                                                        forumId:
                                                                                                                                            forumIdList[
                                                                                                                                                index]);
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);
                                                                                                                                  },
                                                                                                                                  child: const Text(
                                                                                                                                    "Continue",
                                                                                                                                    style: TextStyle(
                                                                                                                                        color: Colors
                                                                                                                                            .white,
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight
                                                                                                                                                .w600,
                                                                                                                                        fontFamily:
                                                                                                                                            "Poppins",
                                                                                                                                        fontSize: 15),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          const Spacer(),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                });
                                                                                                          },
                                                                                                          minLeadingWidth: width / 25,
                                                                                                          leading: const Icon(
                                                                                                            Icons.delete,
                                                                                                            size: 20,
                                                                                                          ),
                                                                                                          title: Text(
                                                                                                            "Delete Post",
                                                                                                            style: TextStyle(
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: text.scale(14)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    )
                                                                                                  : Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        ListTile(
                                                                                                          onTap: () {
                                                                                                            if (!mounted) {
                                                                                                              return;
                                                                                                            }
                                                                                                            Navigator.pop(context);
                                                                                                            _controller.clear();
                                                                                                            setState(() {
                                                                                                              actionValue = "Report";
                                                                                                            });
                                                                                                            showAlertDialog(
                                                                                                                context: context,
                                                                                                                forumId: forumIdList[index],
                                                                                                                forumUserId: forumUserIdList[index]);
                                                                                                          },
                                                                                                          minLeadingWidth: width / 25,
                                                                                                          leading: const Icon(
                                                                                                            Icons.shield,
                                                                                                            size: 20,
                                                                                                          ),
                                                                                                          title: Text(
                                                                                                            "Report Post",
                                                                                                            style: TextStyle(
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: text.scale(14)),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color:
                                                                                                              Theme.of(context).colorScheme.tertiary,
                                                                                                          thickness: 0.8,
                                                                                                        ),
                                                                                                        ListTile(
                                                                                                          onTap: () {
                                                                                                            _controller.clear();
                                                                                                            setState(() {
                                                                                                              actionValue = "Block";
                                                                                                            });
                                                                                                            if (!mounted) {
                                                                                                              return;
                                                                                                            }
                                                                                                            Navigator.pop(context);
                                                                                                            showAlertDialog(
                                                                                                                context: context,
                                                                                                                forumId: forumIdList[index],
                                                                                                                forumUserId: forumUserIdList[index]);
                                                                                                          },
                                                                                                          minLeadingWidth: width / 25,
                                                                                                          leading: const Icon(
                                                                                                            Icons.flag,
                                                                                                            size: 20,
                                                                                                          ),
                                                                                                          title: Text(
                                                                                                            "Block Post",
                                                                                                            style: TextStyle(
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: text.scale(14)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                            ),
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.more_horiz,
                                                                                    size: 20,
                                                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              bool refresh = await Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                return UserBillBoardProfilePage(
                                                                                    userId: forumUserIdList[
                                                                                        index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                              }));
                                                                              if (refresh) {
                                                                                initState();
                                                                              }
                                                                            },
                                                                            child: SizedBox(
                                                                                height: height / 54.13,
                                                                                child: Text(
                                                                                  forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                )),
                                                                          ),
                                                                          SizedBox(height: height / 54.13),
                                                                          SizedBox(
                                                                            width: width / 1.6,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: height / 45.11,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          bool response1 = await likeFunction(
                                                                                              id: forumIdList[index], type: "forums");
                                                                                          if (response1) {
                                                                                            logEventFunc(name: "Likes", type: "Forum");
                                                                                            setState(() {
                                                                                              if (forumUseList[index] == true) {
                                                                                                if (forumUseDisList[index] == true) {
                                                                                                } else {
                                                                                                  forumLikeList[index] -= 1;
                                                                                                }
                                                                                              } else {
                                                                                                if (forumUseDisList[index] == true) {
                                                                                                  forumDislikeList[index] -= 1;
                                                                                                  forumLikeList[index] += 1;
                                                                                                } else {
                                                                                                  forumLikeList[index] += 1;
                                                                                                }
                                                                                              }
                                                                                              forumUseList[index] = !forumUseList[index];
                                                                                              forumUseDisList[index] = false;
                                                                                            });
                                                                                          } else {}
                                                                                        },
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                                          height: height / 40.6,
                                                                                          width: width / 18.75,
                                                                                          child: forumUseList[index]
                                                                                              ? SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/like_filled_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                                )
                                                                                              : SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/like_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                                ),
                                                                                        ),
                                                                                      ),
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          logEventFunc(name: "Share", type: "Forum");
                                                                                          newLink = await getLinK(
                                                                                              id: forumIdList[index],
                                                                                              type: "forums",
                                                                                              description: '',
                                                                                              imageUrl: "",
                                                                                              title: forumTitlesList[index],
                                                                                              category: selectedValue,
                                                                                              filterId: selectedIdWidget);
                                                                                          ShareResult result = await Share.share(
                                                                                            "Look what I was able to find on Tradewatch: ${forumTitlesList[index]} ${newLink.toString()}",
                                                                                          );
                                                                                          if (result.status == ShareResultStatus.success) {
                                                                                            await shareFunction(
                                                                                                id: forumIdList[index], type: "forums");
                                                                                          }
                                                                                        },
                                                                                        child: Container(
                                                                                            height: height / 40.6,
                                                                                            width: width / 18.75,
                                                                                            margin: EdgeInsets.only(right: width / 25),
                                                                                            child: SvgPicture.asset(
                                                                                              isDarkTheme.value
                                                                                                  ? "assets/home_screen/share_dark.svg"
                                                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                            )),
                                                                                      ),
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          bool response3 = await disLikeFunction(
                                                                                              id: forumIdList[index], type: "forums");
                                                                                          if (response3) {
                                                                                            logEventFunc(name: "Dislikes", type: "Forum");
                                                                                            setState(() {
                                                                                              if (forumUseDisList[index] == true) {
                                                                                                if (forumUseList[index] == true) {
                                                                                                } else {
                                                                                                  forumDislikeList[index] -= 1;
                                                                                                }
                                                                                              } else {
                                                                                                if (forumUseList[index] == true) {
                                                                                                  forumLikeList[index] -= 1;
                                                                                                  forumDislikeList[index] += 1;
                                                                                                } else {
                                                                                                  forumDislikeList[index] += 1;
                                                                                                }
                                                                                              }
                                                                                              forumUseDisList[index] = !forumUseDisList[index];
                                                                                              forumUseList[index] = false;
                                                                                            });
                                                                                          } else {}
                                                                                        },
                                                                                        child: Container(
                                                                                          height: height / 40.6,
                                                                                          width: width / 18.75,
                                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                                          child: forumUseDisList[index]
                                                                                              ? SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                                )
                                                                                              : SvgPicture.asset(
                                                                                                  isDarkTheme.value
                                                                                                      ? "assets/home_screen/dislike_dark.svg"
                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                                ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                          height: height / 40.6,
                                                                                          width: width / 18.75,
                                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                                          child: SvgPicture.asset(
                                                                                            "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                            colorFilter: ColorFilter.mode(
                                                                                                isDarkTheme.value
                                                                                                    ? const Color(0XFFD6D6D6)
                                                                                                    : const Color(0XFF0EA102),
                                                                                                BlendMode.srcIn),
                                                                                          )),
                                                                                      bookMarkWidget(
                                                                                          bookMark: forumBookMarkList,
                                                                                          context: context,
                                                                                          scale: 3.4,
                                                                                          id: forumIdList[index],
                                                                                          type: 'forums',
                                                                                          modelSetState: setState,
                                                                                          index: index,
                                                                                          initFunction: getAllData,
                                                                                          notUse: false),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                widgetsMain.translationWidget(
                                                                                    translationList: translationList,
                                                                                    id: forumIdList[index],
                                                                                    type: 'forums',
                                                                                    index: index,
                                                                                    initFunction: getAllData,
                                                                                    context: context,
                                                                                    modelSetState: setState,
                                                                                    notUse: false,
                                                                                    titleList: forumTitlesList)
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: height / 81.2),
                                                                          SizedBox(
                                                                            height: height / 54.13,
                                                                            child: Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                    width: width / 7.5,
                                                                                    child: Text(forumCompanyList[index],
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            fontWeight: FontWeight.w700,
                                                                                            color: Colors.blue))),
                                                                                SizedBox(width: width / 22.05),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    setState(() {
                                                                                      kUserSearchController.clear();
                                                                                      onTapType = "Views";
                                                                                      onTapId = forumIdList[index];
                                                                                      onLike = false;
                                                                                      onDislike = false;
                                                                                      onViews = true;
                                                                                      idKeyMain = "forum_id";
                                                                                      apiMain = baseurl + versionForum + viewsCount;
                                                                                      onTapIdMain = forumIdList[index];
                                                                                      onTapTypeMain = "Views";
                                                                                      haveViewsMain = forumViewsList[index] > 0 ? true : false;
                                                                                      viewCountMain = forumViewsList[index];
                                                                                      kToken = mainUserToken;
                                                                                    });
                                                                                    //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionForum + viewsCount, idKey: 'forum_id', setState: setState);
                                                                                    bool data =
                                                                                        await likeCountFunc(context: context, newSetState: setState);
                                                                                    if (data) {
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      customShowSheet1(context: context);
                                                                                      setState(() {
                                                                                        loaderMain = true;
                                                                                      });
                                                                                    } else {
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      Flushbar(
                                                                                        message: "Still no one has viewed this post",
                                                                                        duration: const Duration(seconds: 2),
                                                                                      ).show(context);
                                                                                    }
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(forumViewsList[index].toString(),
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                      Text(" views",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: width / 22.05),
                                                                                Text(forumResponseList[index].toString(),
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                Text(" Response",
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: height / 86.6,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        ))
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  logEventFunc(name: 'Forum_Start', type: 'Forum');
                  bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return ForumPostPage(
                      text: selectedValue,
                    );
                  }));
                  if (response) {
                    await getForumValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                  }
                },
                backgroundColor: const Color(0XFF0EA102),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog({required BuildContext context, required String forumId, required String forumUserId}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          reverse: true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: height / 1.18,
              width: width / 1.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 3.67,
                      width: width / 1.96,
                      child: Image.asset(
                        actionValue == "Report"
                            ? isDarkTheme.value
                                ? "assets/settings/report_dark.png"
                                : "assets/settings/report_light.png"
                            : isDarkTheme.value
                                ? "assets/settings/block_dark.png"
                                : "assets/settings/block_light.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20.3,
                  ),
                  Center(
                    child: Text(
                      'Help us understand why?',
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Action:",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                alignment: AlignmentDirectional.center,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: actionList
                                    .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                        )))
                                    .toList(),
                                value: actionValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    actionValue = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Why?",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: whyList
                                    .map((label) => DropdownMenuItem<String>(
                                          value: label,
                                          child: Text(
                                            label,
                                            style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                          ),
                                        ))
                                    .toList(),
                                value: whyValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    whyValue = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  TextFormField(
                    controller: _controller,
                    minLines: 4,
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: width / 26.78, vertical: height / 50.75),
                      hintText: "Enter a description...",
                      hintStyle: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  GestureDetector(
                    onTap: () {
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Forum');
                      reportPost(action: actionValue, why: whyValue, description: _controller.text, forumId: forumId, forumUserId: forumUserId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isDarkTheme.value
                            ? const Color(0xff464646)
                            : actionValue == "Report"
                                ? const Color(0XFF0EA102)
                                : const Color(0xffFF0000),
                      ),
                      height: height / 18.45,
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(14), fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  viewedShowSheet() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: forumViewedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(uId: forumViewedIdList[index], uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(forumViewedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            forumViewedSourceNameList[index].toString().capitalizeFirst!,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                          ),
                          trailing: Container(
                              margin: EdgeInsets.only(right: width / 25),
                              height: height / 40.6,
                              width: width / 18.75,
                              child: const Icon(Icons.remove_red_eye_outlined)),
                        ),
                        const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                      ],
                    );
                  }),
            ),
          );
        });
  }
}
