import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
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
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

import 'forum_post_description_page.dart';
import 'forum_post_edit_page.dart';
import 'forum_post_page.dart';

class DetailedForumImagePage extends StatefulWidget {
  final String text;
  final String filterId;
  final String topic;
  final List catIdList;
  final dynamic forumDetail;
  final bool navBool;
  final String sendUserId;
  final bool fromCompare;
  final String tickerId;
  final String tickerName;
  final bool? homeSearch;

  const DetailedForumImagePage(
      {Key? key,
      required this.fromCompare,
      required this.text,
      required this.forumDetail,
      required this.filterId,
      required this.catIdList,
      required this.topic,
      required this.navBool,
      required this.tickerId,
      required this.tickerName,
      this.homeSearch,
      required this.sendUserId})
      : super(key: key);

  @override
  State<DetailedForumImagePage> createState() => _DetailedForumImagePageState();
}

class _DetailedForumImagePageState extends State<DetailedForumImagePage> {
  bool searchLoader = false;
  bool searchValue1 = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  String mainUserId = '';
  String mainUserToken = '';
  List forumImagesList = [];
  List<bool> forumBookMarkList = [];
  List forumSourceNameList = [];
  List<String> forumTitlesList = [];
  List<String> forumCategoryList = [];
  int newsInt = 0;
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool filterBool = false;
  String filterId = "";
  String mainTopic = "";
  String userNameThanks = "";
  String userAvatarThanks = "";
  bool dropDownSelection = false;
  bool emptyBool = false;
  bool sayThanks = false;
  int respondedCount = 0;
  List<dynamic> postIds = [];
  List<String> forumIdList = [];
  List<bool> translationList = [];
  List<int> forumViewsList = [];
  List<int> forumResponseList = [];
  List<String> forumUserIdList = [];
  List<dynamic> forumObjectList = [];
  List<int> forumLikeList = [];
  List<int> forumDislikeList = [];
  List<bool> forumUseList = [];
  List<bool> forumUseDisList = [];
  List<bool> forumMyList = [];
  late Uri newLink;
  bool loading = false;
  List<String> forumCompanyList = [];
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String whyValue = "Scam";
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

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionHome + categories);
    var response = await http.post(url, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': mainUserToken});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainCatIdList.clear();
      for (int i = 1; i <= responseData["response"].length; i++) {
        for (int j = 0; j < responseData["response"].length; j++) {
          if (i == responseData["response"][j]["position"]) {
            setState(() {
              mainCatIdList.add(responseData["response"][j]["_id"]);
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    getNotifyCountAndImage();
    widget.topic == "My Questions" ? getThanksFunc() : debugPrint("nothing");
    widget.navBool
        ? widget.topic == "My Answers"
            ? getUserDetails()
            : debugPrint("nothing")
        : debugPrint("nothing");
    getAllDataMain(name: 'Forum_Categories_Page(${widget.topic})');
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getValues();
    await getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
    if (!mounted) {
      return;
    }
    widget.fromCompare
        ? lockerFilterResponse
            ? debugPrint("nothing")
            : filtersAlertDialogue(
                selectedValue: widget.text,
                cIdList: mainCatIdList,
                title: filterAlertTitle,
                context: context,
                pageType: 'forum',
                tickerId: widget.tickerId)
        : debugPrint("nothing");
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    //   var url = Uri.parse(baseurl + versions + sendNotification);
    var url = baseurl + versions + thanksGetUser;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ),
        data: {
          'userId': widget.sendUserId,
        });
    if (response.data["status"]) {
      setState(() {
        sayThanks = response.data["status"];
        userNameThanks = response.data["data"]["username"];
        userAvatarThanks = response.data["data"]["avatar"];
      });
    }
  }

  getThanksFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + checkNotification);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'type': "forums"});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      setState(() {
        sayThanks = responseData["response"];
        postIds = responseData["post_ids"];
        respondedCount = responseData["count"];
      });
    }
  }

  sendThanksFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versions + sendNotification;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ),
        data: {'type': "forums", 'post_ids': postIds});
    if (response.data["status"]) {}
  }

  getForumValues({required String text, required String? category, required String filterId, required String topic}) async {
    forumImagesList.clear();
    forumBookMarkList.clear();
    forumSourceNameList.clear();
    forumTitlesList.clear();
    forumCategoryList.clear();
    forumIdList.clear();
    translationList.clear();
    forumLikeList.clear();
    forumDislikeList.clear();
    forumUseList.clear();
    forumUseDisList.clear();
    forumMyList.clear();
    forumViewsList.clear();
    forumResponseList.clear();
    forumUserIdList.clear();
    forumObjectList.clear();
    forumCompanyList.clear();
    nativeAdList.clear();
    nativeAdIsLoadedList.clear();
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: widget.fromCompare
            ? {
                'category': category!.toLowerCase(),
                'search': text.isEmpty ? "" : text,
                'skip': '0',
                'type': "",
                'ticker_id': widget.tickerId.isEmpty ? "" : widget.tickerId
              }
            : {
                'category': category!.toLowerCase(),
                'search': text.isEmpty ? "" : text,
                'filter_id': filterId.isEmpty ? "" : filterId,
                'type': topic,
                'skip': "0",
              });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
      setState(() {
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
            forumTitlesList.add(responseData["response"][i]["title"]);
            forumBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
            forumCompanyList.add((responseData["response"][i]["company_name"]) ?? "");
            forumObjectList.add(responseData["response"][i]);
            forumSourceNameList.add(responseData["response"][i]["user"]["username"]);
            forumCategoryList.add(responseData["response"][i]["category"]);
            forumIdList.add(responseData["response"][i]["_id"]);
            translationList.add(responseData["response"][i]["translation"] ?? false);
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
        setState(() {
          loading = true;
          searchValue1 = false;
        });
      });
    }
  }

  void _onForumLoading() async {
    setState(() {
      newsInt = newsInt + 20;
    });
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: widget.fromCompare
            ? {
                'category': widget.text == "Stocks"
                    ? "stocks"
                    : widget.text == "Crypto"
                        ? "crypto"
                        : widget.text == "Commodity"
                            ? "commodity"
                            : widget.text == "Forex"
                                ? "forex"
                                : "nothing",
                'search': _searchController.text.isEmpty ? "" : _searchController.text,
                'skip': '0',
                'type': "",
                'ticker_id': widget.tickerId.isEmpty ? "" : widget.tickerId
              }
            : {
                'category': widget.text.toLowerCase(),
                'search': _searchController.text.isEmpty ? "" : _searchController.text,
                'filter_id': widget.filterId.isEmpty ? "" : widget.filterId,
                'type': widget.topic,
                'skip': newsInt.toString(),
              });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            //emptyBool=true;
            searchLoader = false;
            searchValue1 = false;
          });
        } else {
          setState(() {});
          for (int i = 0; i < responseData["response"].length; i++) {
            forumImagesList.add(responseData["response"][i]["user"]["avatar"]);
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
            forumTitlesList.add(responseData["response"][i]["title"]);
            forumBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
            forumCompanyList.add((responseData["response"][i]["company_name"]) ?? "");
            forumObjectList.add(responseData["response"][i]);
            forumSourceNameList.add(responseData["response"][i]["user"]["username"]);
            forumCategoryList.add(responseData["response"][i]["category"]);
            forumIdList.add(responseData["response"][i]["_id"]);
            translationList.add(responseData["response"][i]["translation"] ?? false);
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
        setState(() {
          loading = true;
          searchValue1 = false;
        });
      });
    }

    if (mounted) setState(() {});
    _refreshController.loadComplete();
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
    var response = await http.post(uri,
        //headers: {"authorization": mainUserToken,},
        body: {"id": id, "type": type});
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

  deletePost({required String forumId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + forumDelete);
    var responseNew = await http.post(url, body: {"forum_id": forumId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockUser({required String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + blockUnblock);
    var responseNew = await http.post(url, body: {"block_user": userId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
    } else {
      if (!mounted) {
        return;
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
          return;
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
        } else {
          if (!mounted) {
            return;
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
      } else {
        if (!mounted) {
          return;
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
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    //  context.read<BookMarkWidgetBloc>().add(LoadingEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        widget.fromCompare
            ? widget.homeSearch!
                ? Navigator.pop(context)
                : Navigator.pop(context)
            /*Navigator.push(context,
            MaterialPageRoute(builder:
                (BuildContext context) {
              return ComparePage(text: finalisedCategory);
            }))*/
            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return ForumPage(text: widget.text);
              }));
        return false;
      },
      child: Container(
        // color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: sayThanks
              ? widget.topic == "My Answers"
                  ? Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: const Color(0XFF48B83F),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height / 16.24,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                    height: height / 2.15,
                                    width: width,
                                    child: Image.asset("lib/Constants/Assets/SMLogos/Ornament.png", fit: BoxFit.fill)),
                                SizedBox(
                                    height: height / 6.15,
                                    width: width / 2.84,
                                    child: SvgPicture.asset(
                                      "lib/Constants/Assets/SMLogos/profileBackground.svg",
                                      height: height / 6.15,
                                      width: width / 2.84,
                                    )),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(userAvatarThanks),
                                  radius: 50,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(children: [
                              Container(
                                  // margin: EdgeInsets.symmetric(horizontal: 15),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      '$userNameThanks thanked you for adding your response for '
                                      'their question and making Tradewatch a better and more engaging community.',
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                  child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.green, backgroundColor: Colors.white,
                                  // shadowColor: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                  minimumSize: Size(width / 1.87, height / 16.91),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return DetailedForumImagePage(
                                      text: widget.text,
                                      tickerId: '',
                                      tickerName: "",
                                      fromCompare: false,
                                      catIdList: mainCatIdList,
                                      filterId: "",
                                      topic: 'My Answers',
                                      forumDetail: "",
                                      navBool: false,
                                      sendUserId: "",
                                    );
                                  }));
                                },
                                child: const Text(
                                  'Great,I will help more!! ',
                                  style: TextStyle(color: Color(0xff0EA102), fontSize: 14),
                                ),
                              ))
                            ]),
                          ],
                        ),
                      ),
                    )
                  : widget.topic == "My Questions"
                      ? Scaffold(
                          backgroundColor: const Color(0XFF48B83F),
                          body: Center(
                            child: Column(
                              children: [
                                SizedBox(height: height / 11.94),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          sayThanks = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: height / 2.15,
                                    width: width,
                                    child: Image.asset("lib/Constants/Assets/SMLogos/Ornament.png", fit: BoxFit.fill)),
                                const Text(
                                  'Say "Thank You"',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '${respondedCount.toString()} users supported you by responding on your post in last 2 weeks, send them a "thank you" for their contribution and support.',
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: height / 20.3),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sayThanks = false;
                                    });
                                    sendThanksFunc();
                                  },
                                  child: Center(
                                    child: Container(
                                      height: height / 20.3,
                                      width: width / 3.02,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                                      child: const Center(
                                          child: Text(
                                        'send',
                                        style: TextStyle(color: Color(0xff0EA102), fontSize: 14, fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Scaffold(
                          //backgroundColor: const Color(0XFFFFFFFF),
                          backgroundColor: Theme.of(context).colorScheme.background,
                          appBar: AppBar(
                            //backgroundColor: const Color(0XFFFFFFFF),
                            backgroundColor: Theme.of(context).colorScheme.background,
                            toolbarHeight: height / 8.63,
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
                                          Text("Forum", style: Theme.of(context).textTheme.titleLarge
                                              /*TextStyle(fontSize: text.scale(26), fontWeight: FontWeight.w700, fontFamily: "Poppins"),*/
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
                              ],
                            ),
                            elevation: 0.0,
                          ),
                          body: loading
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              widget.fromCompare
                                                  ? widget.homeSearch!
                                                      ? Navigator.pop(context)
                                                      : Navigator.pop(context)
                                                  /*Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (BuildContext context) {
                                return ComparePage(text: finalisedCategory);
                              }))*/
                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return ForumPage(
                                                        text: widget.text,
                                                      );
                                                    }));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(left: width / 23.43),
                                              child: const Icon(Icons.arrow_back),
                                            )),
                                        SizedBox(
                                          width: width / 31.25,
                                        ),
                                        widget.fromCompare
                                            ? InkWell(
                                                onTap: () async {
                                                  await detailTickersFunc(tickerId: widget.tickerId, category: widget.text);
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  detailedShowSheet(
                                                      context: context,
                                                      indusValue: widget.text == "Stocks"
                                                          ? true
                                                          : widget.text == "Crypto"
                                                              ? false
                                                              : widget.text == "Commodity"
                                                                  ? false
                                                                  : false);
                                                },
                                                child: Text(
                                                  widget.tickerName,
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                                ))
                                            : Text(
                                                mainTopic,
                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 49.21,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                      height: height / 19.33,
                                      child: TextFormField(
                                        onChanged: (value) async {
                                          context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                          setState(() {
                                            searchLoader = true;
                                          });
                                          if (value.isNotEmpty) {
                                            newsInt = 0;
                                            await getForumValues(text: value, category: widget.text, filterId: widget.filterId, topic: widget.topic);
                                          } else {
                                            newsInt = 0;
                                            await getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
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
                                                  onTap: () {
                                                    setState(() {
                                                      _searchController.clear();
                                                    });
                                                    getForumValues(
                                                        text: "", category: finalisedCategory, filterId: finalisedFilterId, topic: widget.topic);
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
                                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                                          hintText: 'Search here',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height / 58),
                                    searchLoader
                                        ? SizedBox(
                                            height: height / 1.45,
                                            child: Column(
                                              children: [
                                                Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                              ],
                                            ))
                                        : NotificationListener<OverscrollIndicatorNotification>(
                                            onNotification: (overflow) {
                                              overflow.disallowIndicator();
                                              return true;
                                            },
                                            child: emptyBool
                                                ? mainTopic == "My Questions"
                                                    ? Container(
                                                        margin: EdgeInsets.symmetric(horizontal: width / 10.71, vertical: 2),
                                                        height: height / 1.5,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                  height: 150,
                                                                  width: 150,
                                                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                              RichText(
                                                                textAlign: TextAlign.justify,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            'Looks like you have not created any content yet, Do you want to add one now? ',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)*/),
                                                                    TextSpan(
                                                                        text: ' Add here',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .labelSmall!
                                                                            .copyWith(color: const Color(0XFF0EA102), fontWeight: FontWeight.w700),
                                                                        /*const TextStyle(
                                                                    fontFamily: "Poppins",
                                                                    color: Color(0XFF0EA102),
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 12),*/
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
                                                                                  text: "",
                                                                                  category: widget.text,
                                                                                  filterId: widget.filterId,
                                                                                  topic: widget.topic);
                                                                            }
                                                                          }),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : mainTopic == "My Answers"
                                                        ? Container(
                                                            margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                            height: height / 1.5,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 150,
                                                                    width: 150,
                                                                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                                                RichText(
                                                                  textAlign: TextAlign.justify,
                                                                  text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              'Unfortunately, you have not added any response yet. Do you want to help others by answering a few questions? ',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)*/),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: height / 50.75,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: const Color(0XFF0EA102),
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                      ),
                                                                      onPressed: () {
                                                                        getForumValues(
                                                                            text: "",
                                                                            category: widget.text,
                                                                            filterId: widget.filterId,
                                                                            topic: "Unanswered");
                                                                      },
                                                                      child: const Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: height / 5,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(
                                                            margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 150,
                                                                    width: 150,
                                                                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                                RichText(
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
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .labelSmall!
                                                                              .copyWith(color: const Color(0XFF0EA102), fontWeight: FontWeight.w700),
                                                                          /*const TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      color: Color(0XFF0EA102),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12),*/
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
                                                                                    text: "",
                                                                                    category: widget.text,
                                                                                    filterId: widget.filterId,
                                                                                    topic: widget.topic);
                                                                              }
                                                                            }),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                : Container(
                                                    height: height / 1.4,
                                                    margin: EdgeInsets.symmetric(horizontal: width / 23.43),
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
                                                                    onTap: () {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return ForumPostDescriptionPage(
                                                                          forumId: forumIdList[index],
                                                                          comeFrom: 'forumDetail',
                                                                          topic: widget.topic,
                                                                          idList: forumIdList,
                                                                        );
                                                                      }));
                                                                    },
                                                                    child: Container(
                                                                      margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
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
                                                                            height: height / 47.9,
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
                                                                                      onTap: () {
                                                                                        Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return UserBillBoardProfilePage(
                                                                                              userId: forumUserIdList[
                                                                                                  index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                        }));
                                                                                      },
                                                                                      child: Container(
                                                                                        height: height / 13.53,
                                                                                        width: width / 5.95,
                                                                                        margin: EdgeInsets.fromLTRB(width / 23.43, height / 203,
                                                                                            width / 37.5, height / 27.06),
                                                                                        decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Theme.of(context).colorScheme.tertiary,
                                                                                            image: DecorationImage(
                                                                                                image: NetworkImage(forumImagesList[index]),
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
                                                                                                                bottom: MediaQuery.of(context)
                                                                                                                    .viewInsets
                                                                                                                    .bottom),
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
                                                                                                                              await Navigator.push(
                                                                                                                                  context,
                                                                                                                                  MaterialPageRoute(
                                                                                                                                      builder:
                                                                                                                                          (BuildContext
                                                                                                                                              context) {
                                                                                                                            return ForumPostEditPage(
                                                                                                                                text: widget.text,
                                                                                                                                catIdList:
                                                                                                                                    mainCatIdList,
                                                                                                                                filterId:
                                                                                                                                    widget.filterId,
                                                                                                                                forumId: forumIdList[
                                                                                                                                    index]);
                                                                                                                          }));
                                                                                                                          if (response) {
                                                                                                                            await getForumValues(
                                                                                                                                text: "",
                                                                                                                                category: widget.text,
                                                                                                                                filterId:
                                                                                                                                    widget.filterId,
                                                                                                                                topic: widget.topic);
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
                                                                                                                              fontWeight:
                                                                                                                                  FontWeight.w500,
                                                                                                                              fontSize:
                                                                                                                                  text.scale(14)),
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
                                                                                                                              barrierDismissible:
                                                                                                                                  false,
                                                                                                                              context: context,
                                                                                                                              builder: (BuildContext
                                                                                                                                  context) {
                                                                                                                                return Dialog(
                                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                                      borderRadius:
                                                                                                                                          BorderRadius
                                                                                                                                              .circular(
                                                                                                                                                  20.0)),
                                                                                                                                  //this right here
                                                                                                                                  child: Container(
                                                                                                                                    height:
                                                                                                                                        height / 6,
                                                                                                                                    margin: EdgeInsets
                                                                                                                                        .symmetric(
                                                                                                                                            vertical:
                                                                                                                                                height /
                                                                                                                                                    54.13,
                                                                                                                                            horizontal:
                                                                                                                                                width /
                                                                                                                                                    25),
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
                                                                                                                                                    color: Color(0XFF0EA102),
                                                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                                                    fontSize: 20,
                                                                                                                                                    fontFamily: "Poppins"))),
                                                                                                                                        const Divider(),
                                                                                                                                        const Center(
                                                                                                                                            child: Text(
                                                                                                                                                "Are you sure to Delete this Post")),
                                                                                                                                        const Spacer(),
                                                                                                                                        Padding(
                                                                                                                                          padding: EdgeInsets.symmetric(
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
                                                                                                                                                  Navigator.pop(context);
                                                                                                                                                },
                                                                                                                                                child:
                                                                                                                                                    const Text(
                                                                                                                                                  "Cancel",
                                                                                                                                                  style: TextStyle(
                                                                                                                                                      color: Colors.grey,
                                                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                                                      fontFamily: "Poppins",
                                                                                                                                                      fontSize: 15),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                              ElevatedButton(
                                                                                                                                                style:
                                                                                                                                                    ElevatedButton.styleFrom(
                                                                                                                                                  shape:
                                                                                                                                                      RoundedRectangleBorder(
                                                                                                                                                    borderRadius: BorderRadius.circular(18.0),
                                                                                                                                                  ),
                                                                                                                                                  backgroundColor:
                                                                                                                                                      Colors.green,
                                                                                                                                                ),
                                                                                                                                                onPressed:
                                                                                                                                                    () async {
                                                                                                                                                  Navigator.pop(context);

                                                                                                                                                  await deletePost(forumId: forumIdList[index]);
                                                                                                                                                  await getForumValues(
                                                                                                                                                      text: _controller.text == '' ? '' : _controller.text,
                                                                                                                                                      category: widget.text.toLowerCase(),
                                                                                                                                                      filterId: widget.filterId,
                                                                                                                                                      topic: widget.topic);
                                                                                                                                                },
                                                                                                                                                child:
                                                                                                                                                    const Text(
                                                                                                                                                  "Continue",
                                                                                                                                                  style: TextStyle(
                                                                                                                                                      color: Colors.white,
                                                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                                                      fontFamily: "Poppins",
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
                                                                                                                              fontWeight:
                                                                                                                                  FontWeight.w500,
                                                                                                                              fontSize:
                                                                                                                                  text.scale(14)),
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
                                                                                                                              forumId:
                                                                                                                                  forumIdList[index],
                                                                                                                              forumUserId:
                                                                                                                                  forumUserIdList[
                                                                                                                                      index]);
                                                                                                                        },
                                                                                                                        minLeadingWidth: width / 25,
                                                                                                                        leading: const Icon(
                                                                                                                          Icons.shield,
                                                                                                                          size: 20,
                                                                                                                        ),
                                                                                                                        title: Text(
                                                                                                                          "Report Post",
                                                                                                                          style: TextStyle(
                                                                                                                              fontWeight:
                                                                                                                                  FontWeight.w500,
                                                                                                                              fontSize:
                                                                                                                                  text.scale(14)),
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
                                                                                                                          _controller.clear();
                                                                                                                          setState(() {
                                                                                                                            actionValue = "Block";
                                                                                                                          });
                                                                                                                          showAlertDialog(
                                                                                                                              context: context,
                                                                                                                              forumId:
                                                                                                                                  forumIdList[index],
                                                                                                                              forumUserId:
                                                                                                                                  forumUserIdList[
                                                                                                                                      index]);
                                                                                                                        },
                                                                                                                        minLeadingWidth: width / 25,
                                                                                                                        leading: const Icon(
                                                                                                                          Icons.flag,
                                                                                                                          size: 20,
                                                                                                                        ),
                                                                                                                        title: Text(
                                                                                                                          "Block Post",
                                                                                                                          style: TextStyle(
                                                                                                                              fontWeight:
                                                                                                                                  FontWeight.w500,
                                                                                                                              fontSize:
                                                                                                                                  text.scale(14)),
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
                                                                                          onTap: () {
                                                                                            Navigator.push(context,
                                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                              return UserBillBoardProfilePage(
                                                                                                  userId: forumUserIdList[
                                                                                                      index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                            }));
                                                                                          },
                                                                                          child: SizedBox(
                                                                                              height: height / 54.13,
                                                                                              child: Text(
                                                                                                forumSourceNameList[index]
                                                                                                    .toString()
                                                                                                    .capitalizeFirst!,
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w500),
                                                                                              )),
                                                                                        ),
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
                                                                                                            forumUseList[index] =
                                                                                                                !forumUseList[index];
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
                                                                                                            imageUrl: "" /*forumImagesList[index]*/,
                                                                                                            title: forumTitlesList[index],
                                                                                                            category: widget.text,
                                                                                                            filterId: widget.filterId);
                                                                                                        ShareResult result =
                                                                                                            await Share.share(
                                                                                                          "Look what I was able to find on Tradewatch: ${forumTitlesList[index]} ${newLink.toString()}",
                                                                                                        );
                                                                                                        if (result.status ==
                                                                                                            ShareResultStatus.success) {
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
                                                                                                          logEventFunc(
                                                                                                              name: "Dislikes", type: "Forum");
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
                                                                                                            forumUseDisList[index] =
                                                                                                                !forumUseDisList[index];
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
                                                                                                    haveViewsMain =
                                                                                                        forumViewsList[index] > 0 ? true : false;
                                                                                                    viewCountMain = forumViewsList[index];
                                                                                                    kToken = mainUserToken;
                                                                                                  });
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
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: height / 47.9,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ))
                                                              ],
                                                            );
                                                          }
                                                          return GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return ForumPostDescriptionPage(
                                                                    forumId: forumIdList[index],
                                                                    comeFrom: 'forumDetail',
                                                                    topic: widget.topic,
                                                                    idList: forumIdList,
                                                                  );
                                                                }));
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
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
                                                                      height: height / 47.9,
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
                                                                                onTap: () {
                                                                                  Navigator.push(context,
                                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return UserBillBoardProfilePage(
                                                                                        userId: forumUserIdList[
                                                                                            index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                  }));
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
                                                                                          image: NetworkImage(forumImagesList[index]),
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
                                                                                                          bottom: MediaQuery.of(context)
                                                                                                              .viewInsets
                                                                                                              .bottom),
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
                                                                                                                                (BuildContext
                                                                                                                                    context) {
                                                                                                                      return ForumPostEditPage(
                                                                                                                          text: widget.text,
                                                                                                                          catIdList: mainCatIdList,
                                                                                                                          filterId: widget.filterId,
                                                                                                                          forumId:
                                                                                                                              forumIdList[index]);
                                                                                                                    }));
                                                                                                                    if (response) {
                                                                                                                      await getForumValues(
                                                                                                                          text: "",
                                                                                                                          category: widget.text,
                                                                                                                          filterId: widget.filterId,
                                                                                                                          topic: widget.topic);
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
                                                                                                                              margin: EdgeInsets
                                                                                                                                  .symmetric(
                                                                                                                                      vertical:
                                                                                                                                          height /
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
                                                                                                                                                fontWeight: FontWeight
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
                                                                                                                                                  BorderRadius.circular(18.0),
                                                                                                                                            ),
                                                                                                                                            backgroundColor:
                                                                                                                                                Colors
                                                                                                                                                    .green,
                                                                                                                                          ),
                                                                                                                                          onPressed:
                                                                                                                                              () async {
                                                                                                                                            Navigator.pop(
                                                                                                                                                context);

                                                                                                                                            await deletePost(
                                                                                                                                                forumId:
                                                                                                                                                    forumIdList[index]);
                                                                                                                                            await getForumValues(
                                                                                                                                                text: _controller.text == ''
                                                                                                                                                    ? ''
                                                                                                                                                    : _controller
                                                                                                                                                        .text,
                                                                                                                                                category: widget
                                                                                                                                                    .text
                                                                                                                                                    .toLowerCase(),
                                                                                                                                                filterId: widget
                                                                                                                                                    .filterId,
                                                                                                                                                topic:
                                                                                                                                                    widget.topic);
                                                                                                                                          },
                                                                                                                                          child:
                                                                                                                                              const Text(
                                                                                                                                            "Continue",
                                                                                                                                            style: TextStyle(
                                                                                                                                                color: Colors
                                                                                                                                                    .white,
                                                                                                                                                fontWeight: FontWeight
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
                                                                                                                    if (!mounted) {
                                                                                                                      return;
                                                                                                                    }
                                                                                                                    Navigator.pop(context);
                                                                                                                    _controller.clear();
                                                                                                                    setState(() {
                                                                                                                      actionValue = "Block";
                                                                                                                    });
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
                                                                                    onTap: () {
                                                                                      Navigator.push(context,
                                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return UserBillBoardProfilePage(
                                                                                            userId: forumUserIdList[
                                                                                                index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                      }));
                                                                                    },
                                                                                    child: SizedBox(
                                                                                        height: height / 54.13,
                                                                                        child: Text(
                                                                                          forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                        )),
                                                                                  ),
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
                                                                                                      imageUrl: "" /*forumImagesList[index]*/,
                                                                                                      title: forumTitlesList[index],
                                                                                                      category: widget.text,
                                                                                                      filterId: widget.filterId);
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
                                                                                                      forumUseDisList[index] =
                                                                                                          !forumUseDisList[index];
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
                                                                                              haveViewsMain =
                                                                                                  forumViewsList[index] > 0 ? true : false;
                                                                                              viewCountMain = forumViewsList[index];
                                                                                              kToken = mainUserToken;
                                                                                            });
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
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 47.9,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                  ],
                                )
                              : Center(
                                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                ),
                          floatingActionButton: FloatingActionButton(
                            onPressed: () async {
                              logEventFunc(name: 'Forum_Start', type: 'Forum');
                              bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return ForumPostPage(
                                  text: widget.text,
                                );
                              }));
                              if (response) {
                                await getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
                              }
                            },
                            tooltip: 'Increment',
                            backgroundColor: const Color(0XFF0EA102),
                            child: const Icon(Icons.add),
                          ),
                        )
              : Scaffold(
                  //backgroundColor: const Color(0XFFFFFFFF),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: AppBar(
                    //backgroundColor: const Color(0XFFFFFFFF),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    toolbarHeight: height / 8.63,
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
                                  Text("Forum", style: Theme.of(context).textTheme.titleLarge
                                      /*TextStyle(fontSize: text.scale(26), fontWeight: FontWeight.w700, fontFamily: "Poppins"),*/
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
                      ],
                    ),
                    elevation: 0.0,
                  ),
                  body: loading
                      ? Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      widget.fromCompare
                                          ? widget.homeSearch!
                                              ? Navigator.pop(context)
                                              : Navigator.pop(context)
                                          /*Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (BuildContext context) {
                                return ComparePage(text: finalisedCategory);
                              }))*/
                                          : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return ForumPage(
                                                text: widget.text,
                                              );
                                            }));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: width / 23.43),
                                      child: const Icon(Icons.arrow_back),
                                    )),
                                SizedBox(
                                  width: width / 31.25,
                                ),
                                widget.fromCompare
                                    ? InkWell(
                                        onTap: () async {
                                          await detailTickersFunc(tickerId: widget.tickerId, category: widget.text);
                                          if (!mounted) {
                                            return;
                                          }
                                          detailedShowSheet(
                                              context: context,
                                              indusValue: widget.text == "Stocks"
                                                  ? true
                                                  : widget.text == "Crypto"
                                                      ? false
                                                      : widget.text == "Commodity"
                                                          ? false
                                                          : false);
                                        },
                                        child: Text(
                                          widget.tickerName,
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                        ))
                                    : Text(
                                        mainTopic,
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: height / 49.21,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                              height: height / 19.33,
                              child: TextFormField(
                                onChanged: (value) async {
                                  context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                  setState(() {
                                    searchLoader = true;
                                  });
                                  if (value.isNotEmpty) {
                                    newsInt = 0;
                                    await getForumValues(text: value, category: widget.text, filterId: widget.filterId, topic: widget.topic);
                                  } else {
                                    newsInt = 0;
                                    await getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
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
                                          onTap: () {
                                            setState(() {
                                              _searchController.clear();
                                            });
                                            getForumValues(text: "", category: finalisedCategory, filterId: finalisedFilterId, topic: widget.topic);
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
                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                  hintText: 'Search here',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height / 58),
                            searchLoader
                                ? SizedBox(
                                    height: height / 1.45,
                                    child: Column(
                                      children: [
                                        Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                      ],
                                    ))
                                : NotificationListener<OverscrollIndicatorNotification>(
                                    onNotification: (overflow) {
                                      overflow.disallowIndicator();
                                      return true;
                                    },
                                    child: emptyBool
                                        ? mainTopic == "My Questions"
                                            ? Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 10.71, vertical: 2),
                                                height: height / 1.5,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                      RichText(
                                                        textAlign: TextAlign.justify,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: 'Looks like you have not created any content yet, Do you want to add one now? ',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)*/),
                                                            TextSpan(
                                                                text: ' Add here',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelSmall!
                                                                    .copyWith(color: const Color(0XFF0EA102), fontWeight: FontWeight.w700),
                                                                /*const TextStyle(
                                                                    fontFamily: "Poppins",
                                                                    color: Color(0XFF0EA102),
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 12),*/
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
                                                                          text: "",
                                                                          category: widget.text,
                                                                          filterId: widget.filterId,
                                                                          topic: widget.topic);
                                                                    }
                                                                  }),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : mainTopic == "My Answers"
                                                ? Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                    height: height / 1.5,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                            height: 150,
                                                            width: 150,
                                                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                                        RichText(
                                                          textAlign: TextAlign.justify,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      'Unfortunately, you have not added any response yet. Do you want to help others by answering a few questions? ',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)*/),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: const Color(0XFF0EA102),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                              ),
                                                              onPressed: () {
                                                                getForumValues(
                                                                    text: "", category: widget.text, filterId: widget.filterId, topic: "Unanswered");
                                                              },
                                                              child: const Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height / 5,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                            height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                        RichText(
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
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .labelSmall!
                                                                      .copyWith(color: const Color(0XFF0EA102), fontWeight: FontWeight.w700),
                                                                  /*const TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      color: Color(0XFF0EA102),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12),*/
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
                                                                            text: "",
                                                                            category: widget.text,
                                                                            filterId: widget.filterId,
                                                                            topic: widget.topic);
                                                                      }
                                                                    }),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                        : Container(
                                            height: height / 1.4,
                                            margin: EdgeInsets.symmetric(horizontal: width / 23.43),
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
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return ForumPostDescriptionPage(
                                                                  forumId: forumIdList[index],
                                                                  comeFrom: 'forumDetail',
                                                                  topic: widget.topic,
                                                                  idList: forumIdList,
                                                                );
                                                              }));
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
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
                                                                    height: height / 47.9,
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
                                                                              onTap: () {
                                                                                Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                  return UserBillBoardProfilePage(
                                                                                      userId: forumUserIdList[
                                                                                          index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                }));
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
                                                                                        image: NetworkImage(forumImagesList[index]),
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
                                                                                                                        filterId: widget.filterId,
                                                                                                                        forumId: forumIdList[index]);
                                                                                                                  }));
                                                                                                                  if (response) {
                                                                                                                    await getForumValues(
                                                                                                                        text: "",
                                                                                                                        category: widget.text,
                                                                                                                        filterId: widget.filterId,
                                                                                                                        topic: widget.topic);
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
                                                                                                                                              Colors
                                                                                                                                                  .green,
                                                                                                                                        ),
                                                                                                                                        onPressed:
                                                                                                                                            () async {
                                                                                                                                          Navigator.pop(
                                                                                                                                              context);

                                                                                                                                          await deletePost(
                                                                                                                                              forumId:
                                                                                                                                                  forumIdList[index]);
                                                                                                                                          await getForumValues(
                                                                                                                                              text: _controller.text ==
                                                                                                                                                      ''
                                                                                                                                                  ? ''
                                                                                                                                                  : _controller
                                                                                                                                                      .text,
                                                                                                                                              category: widget
                                                                                                                                                  .text
                                                                                                                                                  .toLowerCase(),
                                                                                                                                              filterId:
                                                                                                                                                  widget
                                                                                                                                                      .filterId,
                                                                                                                                              topic: widget
                                                                                                                                                  .topic);
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
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  _controller.clear();
                                                                                                                  setState(() {
                                                                                                                    actionValue = "Block";
                                                                                                                  });
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
                                                                                  onTap: () {
                                                                                    Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return UserBillBoardProfilePage(
                                                                                          userId: forumUserIdList[
                                                                                              index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                                    }));
                                                                                  },
                                                                                  child: SizedBox(
                                                                                      height: height / 54.13,
                                                                                      child: Text(
                                                                                        forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                      )),
                                                                                ),
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
                                                                                                    imageUrl: "" /*forumImagesList[index]*/,
                                                                                                    title: forumTitlesList[index],
                                                                                                    category: widget.text,
                                                                                                    filterId: widget.filterId);
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
                                                                    height: height / 47.9,
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                      ],
                                                    );
                                                  }
                                                  return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return ForumPostDescriptionPage(
                                                            forumId: forumIdList[index],
                                                            comeFrom: 'forumDetail',
                                                            topic: widget.topic,
                                                            idList: forumIdList,
                                                          );
                                                        }));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.background,
                                                            borderRadius: BorderRadius.circular(20),
                                                            boxShadow: [
                                                              BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                            ]),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: height / 47.9,
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
                                                                        onTap: () {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return UserBillBoardProfilePage(
                                                                                userId: forumUserIdList[
                                                                                    index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                          }));
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
                                                                                  image: NetworkImage(forumImagesList[index]), fit: BoxFit.fill)),
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
                                                                                                                  filterId: widget.filterId,
                                                                                                                  forumId: forumIdList[index]);
                                                                                                            }));
                                                                                                            if (response) {
                                                                                                              await getForumValues(
                                                                                                                  text: "",
                                                                                                                  category: widget.text,
                                                                                                                  filterId: widget.filterId,
                                                                                                                  topic: widget.topic);
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
                                                                                                                                        Colors.green,
                                                                                                                                  ),
                                                                                                                                  onPressed:
                                                                                                                                      () async {
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);

                                                                                                                                    await deletePost(
                                                                                                                                        forumId:
                                                                                                                                            forumIdList[
                                                                                                                                                index]);
                                                                                                                                    await getForumValues(
                                                                                                                                        text: _controller.text ==
                                                                                                                                                ''
                                                                                                                                            ? ''
                                                                                                                                            : _controller
                                                                                                                                                .text,
                                                                                                                                        category: widget
                                                                                                                                            .text
                                                                                                                                            .toLowerCase(),
                                                                                                                                        filterId: widget
                                                                                                                                            .filterId,
                                                                                                                                        topic: widget
                                                                                                                                            .topic);
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
                                                                                                            if (!mounted) {
                                                                                                              return;
                                                                                                            }
                                                                                                            Navigator.pop(context);
                                                                                                            _controller.clear();
                                                                                                            setState(() {
                                                                                                              actionValue = "Block";
                                                                                                            });
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
                                                                            onTap: () {
                                                                              Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                return UserBillBoardProfilePage(
                                                                                    userId: forumUserIdList[
                                                                                        index]) /*UserProfilePage(id:forumUserIdList[index],type:'forums',index:0)*/;
                                                                              }));
                                                                            },
                                                                            child: SizedBox(
                                                                                height: height / 54.13,
                                                                                child: Text(
                                                                                  forumSourceNameList[index].toString().capitalizeFirst!,
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                )),
                                                                          ),
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
                                                                                              imageUrl: "" /*forumImagesList[index]*/,
                                                                                              title: forumTitlesList[index],
                                                                                              category: widget.text,
                                                                                              filterId: widget.filterId);
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
                                                              height: height / 47.9,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ),
                                          ),
                                  ),
                          ],
                        )
                      : Center(
                          child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                        ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      logEventFunc(name: 'Forum_Start', type: 'Forum');
                      bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return ForumPostPage(
                          text: widget.text,
                        );
                      }));
                      if (response) {
                        await getForumValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
                      }
                    },
                    tooltip: 'Increment',
                    backgroundColor: const Color(0XFF0EA102),
                    child: const Icon(Icons.add),
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
                    onTap: () async {
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Forum');
                      await reportPost(action: actionValue, why: whyValue, description: _controller.text, forumId: forumId, forumUserId: forumUserId);
                      await getForumValues(
                          text: _controller.text == '' ? '' : _controller.text,
                          category: widget.text.toLowerCase(),
                          filterId: widget.filterId,
                          topic: widget.topic);
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
