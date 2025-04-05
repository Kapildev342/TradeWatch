import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

class FeatureRequestPage extends StatefulWidget {
  final String? fromWhere;

  const FeatureRequestPage({Key? key, this.fromWhere = ""}) : super(key: key);

  @override
  State<FeatureRequestPage> createState() => _FeatureRequestPageState();
}

class _FeatureRequestPageState extends State<FeatureRequestPage> with WidgetsBindingObserver {
  String mainUserToken = "";
  String mainUserId = "";
  bool emptyBool = false;
  int selectedIndex = 0;
  List<String> featureImagesList = [];
  List<String> featureReleasedDate = [];
  List<String> featureAndroidVersion = [];
  List<String> featureIosVersion = [];
  List<int> featureStatusList = [];
  List<String> featureLikedImagesList = [];
  List<String> featureIdList = [];
  List<String> featureLikedIdList = [];
  List<String> featureTitlesList = [];
  List<bool> featureTranslationList = [];
  List<String> featureCategoryList = [];
  List<int> featureDislikeList = [];
  List<int> featureLikeList = [];
  List<bool> featureUseList = [];
  List<bool> featureDisuseList = [];
  List<int> featureResponseList = [];
  List<String> featureUserIdList = [];
  List<String> featureSourceNameList = [];
  List<String> featureLikedSourceNameList = [];
  List<dynamic> featureObjectList = [];
  List<bool> featureMyList = [];
  String searchValue = "";
  int newsInt = 0;
  bool startSearch = false;
  bool searchValue1 = false;
  bool searchLoader = false;
  bool loading = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List categoriesList = [
    "Recent",
    "Most Liked",
    "Most Response",
    "Most Disliked",
    "Most Shared",
    "Completed",
  ];
  String selectedValue = "Recent";
  late Uri newLink;
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";

  String whyValue = "Scam";
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  @override
  void initState() {
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    getAllDataMain(name: 'Feature_Request_Page');
    getNotifyCountAndImage();
    pageVisitFunc(pageName: 'feature');
    getFeatureData();
    super.initState();
  }

  getFeatureData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(baseurl + versionFeature + featureList);
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'sort_type': selectedValue, 'search': _searchController.text == "" ? "" : _searchController.text, 'skip': "0"});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      featureImagesList.clear();
      featureReleasedDate.clear();
      featureAndroidVersion.clear();
      featureIosVersion.clear();
      featureStatusList.clear();
      featureIdList.clear();
      featureTitlesList.clear();
      featureTranslationList.clear();
      featureCategoryList.clear();
      featureDislikeList.clear();
      featureLikeList.clear();
      featureUseList.clear();
      featureDisuseList.clear();
      featureResponseList.clear();
      featureUserIdList.clear();
      featureSourceNameList.clear();
      featureObjectList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            startSearch = false;
            emptyBool = true;
            searchLoader = false;
            searchValue1 = false;
          });
        } else {
          setState(() {
            emptyBool = false;
            startSearch = false;
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
              featureImagesList.add(responseData["response"][i]["user"]["avatar"]);
            } else {
              featureImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
            //featureImagesList.add(responseData["response"][i]["user"]["avatar"]);
            featureIdList.add(responseData["response"][i]["_id"]);
            featureStatusList.add(responseData["response"][i]["status"]);
            featureObjectList.add(responseData["response"][i]);
            featureTitlesList.add(responseData["response"][i]["title"]);
            featureTranslationList.add(false);
            featureCategoryList.add(responseData["response"][i]["category"]);
            featureDislikeList.add(responseData["response"][i]["dis_likes_count"]);
            featureLikeList.add(responseData["response"][i]["likes_count"]);
            featureUseList.add(responseData["response"][i]["likes"]);
            featureDisuseList.add(responseData["response"][i]["dislikes"]);
            featureResponseList.add(responseData["response"][i]["response_count"]);
            featureUserIdList.add(responseData["response"][i]["user"]["_id"]);
            featureSourceNameList.add(responseData["response"][i]["user"]["username"]);
            if (responseData["response"][i].containsKey("app_release_date")) {
              featureReleasedDate.add(responseData["response"][i]["app_release_date"]);
            } else {
              featureReleasedDate.add("");
            }
            if (responseData["response"][i].containsKey("android_version")) {
              featureAndroidVersion.add(responseData["response"][i]["android_version"]);
            } else {
              featureAndroidVersion.add("");
            }
            if (responseData["response"][i].containsKey("ios_version")) {
              featureIosVersion.add(responseData["response"][i]["ios_version"]);
            } else {
              featureIosVersion.add("");
            }
            if (mainUserId == featureUserIdList[i]) {
              featureMyList.add(true);
            } else {
              featureMyList.add(false);
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
    } else {}
  }

  void _onFeatureLoading() async {
    setState(() {
      newsInt = newsInt + 20;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(baseurl + versionFeature + featureList);
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'sort_type': selectedValue, 'search': _searchController.text == "" ? "" : _searchController.text, 'skip': newsInt.toString()});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            startSearch = false;
            //emptyBool=true;
            searchLoader = false;
            searchValue1 = false;
          });
        } else {
          setState(() {
            startSearch = false;
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
            featureImagesList.add(responseData["response"][i]["user"]["avatar"]);
            featureIdList.add(responseData["response"][i]["_id"]);
            featureStatusList.add(responseData["response"][i]["status"]);
            featureObjectList.add(responseData["response"][i]);
            featureTitlesList.add(responseData["response"][i]["title"]);
            featureTranslationList.add(false);
            featureCategoryList.add(responseData["response"][i]["category"]);
            featureDislikeList.add(responseData["response"][i]["dis_likes_count"]);
            featureLikeList.add(responseData["response"][i]["likes_count"]);
            featureUseList.add(responseData["response"][i]["likes"]);
            featureDisuseList.add(responseData["response"][i]["dislikes"]);
            featureResponseList.add(responseData["response"][i]["response_count"]);
            featureUserIdList.add(responseData["response"][i]["user"]["_id"]);
            featureSourceNameList.add(responseData["response"][i]["user"]["username"]);
            if (responseData["response"][i].containsKey("app_release_date")) {
              featureReleasedDate.add(responseData["response"][i]["app_release_date"]);
            } else {
              featureReleasedDate.add("");
            }
            if (responseData["response"][i].containsKey("android_version")) {
              featureAndroidVersion.add(responseData["response"][i]["android_version"]);
            } else {
              featureAndroidVersion.add("");
            }
            if (responseData["response"][i].containsKey("ios_version")) {
              featureIosVersion.add(responseData["response"][i]["ios_version"]);
            } else {
              featureIosVersion.add("");
            }
            if (mainUserId == featureUserIdList[i]) {
              featureMyList.add(true);
            } else {
              featureMyList.add(false);
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
    } else {}
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
      required String text,
      required String description}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/FeaturePostDescriptionPage/$id/$type/$text'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  deletePost({required String featureId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionFeature + featureDelete);
    var responseNew = await http.post(url, body: {"feature_id": featureId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      getFeatureData();
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

  reportPost(
      {required String action, required String why, required String description, required String featureId, required String featureUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
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
        var url = Uri.parse(baseurl + versionFeature + addReport);
        var responseNew = await http.post(url, body: {
          "action": action,
          "why": why,
          "description": description,
          "feature_id": featureId,
          "feature_user": featureUserId,
        }, headers: {
          'Authorization': mainUserToken
        });
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
          getFeatureData();
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
      var url = Uri.parse(baseurl + versionFeature + addReport);
      var responseNew = await http.post(url, body: {
        "action": action,
        "why": why,
        "description": description,
        "feature_id": featureId,
        "feature_user": featureUserId,
      }, headers: {
        'Authorization': mainUserToken
      });
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
        getFeatureData();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWhere == "finalCharts") {
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
          Navigator.of(context).pop();
        } else {
          widget.fromWhere == "" || widget.fromWhere == "link" ? debugPrint("nothing") : Navigator.of(context, rootNavigator: true).pop();
          widget.fromWhere == "link"
              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return const MainBottomNavigationPage(
                    caseNo1: 0,
                    text: '',
                    excIndex: 1,
                    newIndex: 0,
                    countryIndex: 0,
                    tType: true,
                    isHomeFirstTym: false,
                  );
                }))
              : widget.fromWhere == "FeaturePostDescription"
                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const MainBottomNavigationPage(
                        caseNo1: 1,
                        text: '',
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        tType: true,
                        isHomeFirstTym: false,
                      );
                    }))
                  : Navigator.of(context).pop();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          extraContainMain.value = false;
        },
        child: Container(
          //color: const Color(0XFFFFFFFF),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
              //backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                toolbarHeight: height / 10.15,
                leadingWidth: width / 10.71,
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                leading: IconButton(
                  onPressed: () {
                    if (widget.fromWhere == "finalCharts") {
                      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                      Navigator.of(context).pop();
                    } else {
                      widget.fromWhere == "" || widget.fromWhere == "link" ? debugPrint("nothing") : Navigator.of(context, rootNavigator: true).pop();
                      widget.fromWhere == "link"
                          ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return const MainBottomNavigationPage(
                                caseNo1: 0,
                                text: '',
                                excIndex: 1,
                                newIndex: 0,
                                countryIndex: 0,
                                tType: true,
                                isHomeFirstTym: false,
                              );
                            }))
                          : widget.fromWhere == "FeaturePostDescription"
                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return const MainBottomNavigationPage(
                                    caseNo1: 1,
                                    text: '',
                                    excIndex: 1,
                                    newIndex: 0,
                                    countryIndex: 0,
                                    tType: true,
                                    isHomeFirstTym: false,
                                  );
                                }))
                              : Navigator.of(context).pop();
                    }
                    /* widget.fromWhere == "" || widget.fromWhere == "link"
                          ? debugPrint("nothing")
                          : Navigator.of(context, rootNavigator: true).pop();
                      widget.fromWhere == "link"
                          ? Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                              return MainBottomNavigationPage(
                                caseNo1: 0,
                                text: '',
                                excIndex: 1,
                                newIndex: 0,
                                countryIndex: 0,
                                tType: true,
                                isHomeFirstTym: false,
                              );
                            }))
                          : widget.fromWhere == "FeaturePostDescription"
                              ? Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                  return MainBottomNavigationPage(
                                    caseNo1: 1,
                                    text: '',
                                    excIndex: 1,
                                    newIndex: 0,
                                    countryIndex: 0,
                                    tType: true,
                                    isHomeFirstTym: false,
                                  );
                                }))
                              : Navigator.of(context).pop();*/
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    //color: Colors.black,
                    size: 30,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Feature Request",
                      //style: TextStyle(fontSize: text.scale(24), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: width / 23.43),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return mainSkipValue ? const SettingsSkipView() : const SettingsView();
                            }));
                          },
                          child: widgetsMain.getProfileImage(
                            context: context,
                            isLogged: mainSkipValue,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
                elevation: 0.0,
              ),
              body: loading
                  ? Container(
                      color: Theme.of(context).colorScheme.background, //const Color(0XFFFFFFFF),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height / 20.3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => extraContainMain.value
                                        ? TextFormField(
                                            cursorColor: Theme.of(context).colorScheme.primary,
                                            //Colors.green,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            readOnly: true,
                                            enabled: true,
                                            controller: _searchController,
                                            decoration: InputDecoration(
                                                fillColor: Theme.of(context).colorScheme.tertiary,
                                                filled: true,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                contentPadding: const EdgeInsets.all(0),
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
                                                        child: Icon(Icons.cancel,
                                                            size: 22, color: Theme.of(context).colorScheme.onPrimary /*Colors.black*/),
                                                      )
                                                    : const SizedBox(),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                hintText: ("Search here"),
                                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                    color: const Color(
                                                        0XFFA5A5A5)) /*TextStyle(
                                                  color: const Color(0XFFA5A5A5),
                                                  fontSize: text.scale(14),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins")*/
                                                ),
                                          )
                                        : TextFormField(
                                            cursorColor: Theme.of(context).colorScheme.primary,
                                            onChanged: (value) async {
                                              if (value.isNotEmpty) {
                                                context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                                setState(() {
                                                  startSearch = true;
                                                  searchValue = value;
                                                });
                                                newsInt = 0;
                                                await getFeatureData();
                                              } else {
                                                setState(() {
                                                  startSearch = false;
                                                  searchValue = value;
                                                });
                                                newsInt = 0;
                                                await getFeatureData();
                                              }
                                            },
                                            controller: _searchController,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            decoration: InputDecoration(
                                                fillColor: Theme.of(context).colorScheme.tertiary,
                                                filled: true,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                contentPadding: const EdgeInsets.all(0),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                ),
                                                suffixIcon: _searchController.text.isNotEmpty
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                                          setState(() {
                                                            _searchController.clear();
                                                          });
                                                          await getFeatureData();
                                                        },
                                                        child: Icon(Icons.cancel,
                                                            size: 22, color: Theme.of(context).colorScheme.onPrimary /*Colors.black*/),
                                                      )
                                                    : const SizedBox(),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                hintText: ("Search here"),
                                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                    color: const Color(
                                                        0XFFA5A5A5)) /*TextStyle(
                                                  color: const Color(0XFFA5A5A5),
                                                  fontSize: text.scale(14),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins")*/
                                                ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    extraContainMain.toggle();
                                  },
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Frame 162.svg",
                                          height: height / 54.13,
                                          width: width / 18.25,
                                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Sort",
                                              //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000)),
                                              style: Theme.of(context).textTheme.labelLarge),
                                          const SizedBox(width: 2),
                                          Container(
                                            height: 5,
                                            width: 5,
                                            decoration: const BoxDecoration(
                                              color: Color(0XFF0EA102),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => extraContainMain.value
                                ? Stack(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: height / 50.75),
                                          Container(
                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                            height: height / 23.88,
                                            child: Center(
                                                child: Text(
                                              'Post a Request',
                                              style: TextStyle(color: Colors.white, fontSize: text.scale(12), fontWeight: FontWeight.w600),
                                            )),
                                          ),
                                          SizedBox(height: height / 33.83),
                                          emptyBool
                                              ? SizedBox(
                                                  height: height / 1.5,
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                            height: 150,
                                                            width: 150,
                                                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                                        RichText(
                                                          text: const TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: 'Unfortunately, there is nothing to display!',
                                                                  style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : startSearch
                                                  ? const Center(child: CircularProgressIndicator(color: Color(0XFF0EA102)))
                                                  : SizedBox(
                                                      height: Platform.isIOS ? height / 1.5 : height / 1.4,
                                                      child: ListView.builder(
                                                        physics: const ScrollPhysics(),
                                                        itemCount: featureImagesList.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                              margin: EdgeInsets.only(bottom: height / 35, top: 3, right: 3, left: 3),
                                                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  color: featureStatusList[index] == 4
                                                                      ? isDarkTheme.value
                                                                          ? Theme.of(context).colorScheme.tertiary
                                                                          : Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                                                      : Theme.of(context).colorScheme.background /*Colors.white*/,
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
                                                                    color: featureStatusList[index] == 4
                                                                        ? isDarkTheme.value
                                                                            ? Theme.of(context).colorScheme.tertiary
                                                                            : Colors.transparent
                                                                        : Theme.of(context).colorScheme.background,
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
                                                                                  color: Colors.grey,
                                                                                  image: DecorationImage(
                                                                                      image: NetworkImage(featureImagesList[index]),
                                                                                      fit: BoxFit.fill)),
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                featureStatusList[index] == 4
                                                                                    ? Shimmer.fromColors(
                                                                                        baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                        highlightColor: Theme.of(context).colorScheme.background,
                                                                                        direction: ShimmerDirection.ltr,
                                                                                        child: Wrap(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: width / 1.6,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                      width: width / 1.8,
                                                                                                      child: Text(
                                                                                                        featureTitlesList[index],
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(14),
                                                                                                            fontWeight: FontWeight.w600),
                                                                                                      )),
                                                                                                  GestureDetector(
                                                                                                    onTap: () {
                                                                                                      if (mainSkipValue) {
                                                                                                        commonFlushBar(
                                                                                                            context: context,
                                                                                                            initFunction: initState);
                                                                                                      } else {
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
                                                                                                                  child: featureMyList[index]
                                                                                                                      ? ListTile(
                                                                                                                          onTap: mainSkipValue
                                                                                                                              ? () {
                                                                                                                                  commonFlushBar(
                                                                                                                                      context:
                                                                                                                                          context,
                                                                                                                                      initFunction:
                                                                                                                                          initState);
                                                                                                                                }
                                                                                                                              : () {
                                                                                                                                  Navigator.pop(
                                                                                                                                      context);
                                                                                                                                  showDialog(
                                                                                                                                      barrierDismissible:
                                                                                                                                          false,
                                                                                                                                      context:
                                                                                                                                          context,
                                                                                                                                      builder:
                                                                                                                                          (BuildContext
                                                                                                                                              context) {
                                                                                                                                        return Dialog(
                                                                                                                                          shape: RoundedRectangleBorder(
                                                                                                                                              borderRadius:
                                                                                                                                                  BorderRadius.circular(20.0)),
                                                                                                                                          //this right here
                                                                                                                                          child:
                                                                                                                                              Container(
                                                                                                                                            height:
                                                                                                                                                height /
                                                                                                                                                    6,
                                                                                                                                            margin: EdgeInsets.symmetric(
                                                                                                                                                vertical: height /
                                                                                                                                                    54.13,
                                                                                                                                                horizontal:
                                                                                                                                                    width / 25),
                                                                                                                                            child:
                                                                                                                                                Column(
                                                                                                                                              mainAxisAlignment:
                                                                                                                                                  MainAxisAlignment.center,
                                                                                                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                              children: [
                                                                                                                                                const Center(
                                                                                                                                                    child: Text("Delete Request", style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Poppins"))),
                                                                                                                                                const Divider(),
                                                                                                                                                const Center(
                                                                                                                                                    child: Text("Are you sure to Delete this Request")),
                                                                                                                                                const Spacer(),
                                                                                                                                                Padding(
                                                                                                                                                  padding:
                                                                                                                                                      EdgeInsets.symmetric(horizontal: width / 25),
                                                                                                                                                  child:
                                                                                                                                                      Row(
                                                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                                    children: [
                                                                                                                                                      TextButton(
                                                                                                                                                        onPressed: () {
                                                                                                                                                          if (!mounted) {
                                                                                                                                                            return;
                                                                                                                                                          }
                                                                                                                                                          Navigator.pop(context);
                                                                                                                                                        },
                                                                                                                                                        child: const Text(
                                                                                                                                                          "Cancel",
                                                                                                                                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                                                                                                                        ),
                                                                                                                                                      ),
                                                                                                                                                      ElevatedButton(
                                                                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                                                                          shape: RoundedRectangleBorder(
                                                                                                                                                            borderRadius: BorderRadius.circular(18.0),
                                                                                                                                                          ),
                                                                                                                                                          backgroundColor: Colors.green,
                                                                                                                                                        ),
                                                                                                                                                        onPressed: () async {
                                                                                                                                                          deletePost(featureId: featureIdList[index]);
                                                                                                                                                          if (!mounted) {
                                                                                                                                                            return;
                                                                                                                                                          }
                                                                                                                                                          Navigator.pop(context);
                                                                                                                                                        },
                                                                                                                                                        child: const Text(
                                                                                                                                                          "Continue",
                                                                                                                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
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
                                                                                                                        )
                                                                                                                      : Column(
                                                                                                                          mainAxisAlignment:
                                                                                                                              MainAxisAlignment.start,
                                                                                                                          crossAxisAlignment:
                                                                                                                              CrossAxisAlignment
                                                                                                                                  .start,
                                                                                                                          children: [
                                                                                                                            ListTile(
                                                                                                                              onTap: mainSkipValue
                                                                                                                                  ? () {
                                                                                                                                      commonFlushBar(
                                                                                                                                          context:
                                                                                                                                              context,
                                                                                                                                          initFunction:
                                                                                                                                              initState);
                                                                                                                                    }
                                                                                                                                  : () {
                                                                                                                                      Navigator.pop(
                                                                                                                                          context);
                                                                                                                                      _controller
                                                                                                                                          .clear();
                                                                                                                                      setState(() {
                                                                                                                                        actionValue =
                                                                                                                                            "Report";
                                                                                                                                      });
                                                                                                                                      showAlertDialog(
                                                                                                                                          context:
                                                                                                                                              context,
                                                                                                                                          featureId:
                                                                                                                                              featureIdList[
                                                                                                                                                  index],
                                                                                                                                          featureUserId:
                                                                                                                                              featureUserIdList[
                                                                                                                                                  index]);
                                                                                                                                    },
                                                                                                                              minLeadingWidth:
                                                                                                                                  width / 25,
                                                                                                                              leading: const Icon(
                                                                                                                                Icons.shield,
                                                                                                                                size: 20,
                                                                                                                              ),
                                                                                                                              title: Text(
                                                                                                                                "Report Post",
                                                                                                                                style: TextStyle(
                                                                                                                                    fontWeight:
                                                                                                                                        FontWeight
                                                                                                                                            .w500,
                                                                                                                                    fontSize: text
                                                                                                                                        .scale(14)),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            const Divider(
                                                                                                                              thickness: 0.0,
                                                                                                                              height: 0.0,
                                                                                                                            ),
                                                                                                                            ListTile(
                                                                                                                              onTap: mainSkipValue
                                                                                                                                  ? () {
                                                                                                                                      commonFlushBar(
                                                                                                                                          context:
                                                                                                                                              context,
                                                                                                                                          initFunction:
                                                                                                                                              initState);
                                                                                                                                    }
                                                                                                                                  : () {
                                                                                                                                      _controller
                                                                                                                                          .clear();
                                                                                                                                      setState(() {
                                                                                                                                        actionValue =
                                                                                                                                            "Block";
                                                                                                                                      });
                                                                                                                                      Navigator.pop(
                                                                                                                                          context);
                                                                                                                                      showAlertDialog(
                                                                                                                                          context:
                                                                                                                                              context,
                                                                                                                                          featureId:
                                                                                                                                              featureIdList[
                                                                                                                                                  index],
                                                                                                                                          featureUserId:
                                                                                                                                              featureUserIdList[
                                                                                                                                                  index]);
                                                                                                                                    },
                                                                                                                              minLeadingWidth:
                                                                                                                                  width / 25,
                                                                                                                              leading: const Icon(
                                                                                                                                Icons.flag,
                                                                                                                                size: 20,
                                                                                                                              ),
                                                                                                                              title: Text(
                                                                                                                                "Block Post",
                                                                                                                                style: TextStyle(
                                                                                                                                    fontWeight:
                                                                                                                                        FontWeight
                                                                                                                                            .w500,
                                                                                                                                    fontSize: text
                                                                                                                                        .scale(14)),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                ),
                                                                                                              );
                                                                                                            });
                                                                                                      }
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      padding: EdgeInsets.only(right: width / 50),
                                                                                                      child: const Icon(
                                                                                                        Icons.more_horiz,
                                                                                                        size: 20,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : SizedBox(
                                                                                        width: width / 1.6,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                                width: width / 1.8,
                                                                                                child: Text(
                                                                                                  featureTitlesList[index],
                                                                                                  style: TextStyle(
                                                                                                      fontSize: text.scale(14),
                                                                                                      fontWeight: FontWeight.w600),
                                                                                                )),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(right: width / 50),
                                                                                              child: const Icon(
                                                                                                Icons.more_horiz,
                                                                                                size: 20,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                featureStatusList[index] == 4
                                                                                    ? Shimmer.fromColors(
                                                                                        baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                        highlightColor: Theme.of(context).colorScheme.background,
                                                                                        direction: ShimmerDirection.ltr,
                                                                                        child: Wrap(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                if (mainSkipValue) {
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: initState);
                                                                                                } else {
                                                                                                  Navigator.push(context, MaterialPageRoute(
                                                                                                      builder: (BuildContext context) {
                                                                                                    return UserBillBoardProfilePage(
                                                                                                        userId: featureUserIdList[
                                                                                                            index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                                  }));
                                                                                                }
                                                                                              },
                                                                                              child: SizedBox(
                                                                                                  height: height / 54.13,
                                                                                                  width: width / 1.8,
                                                                                                  child: Text(
                                                                                                    featureSourceNameList[index]
                                                                                                        .toString()
                                                                                                        .capitalizeFirst!,
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w500),
                                                                                                  )),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : SizedBox(
                                                                                        height: height / 54.13,
                                                                                        width: width / 1.84,
                                                                                        child: Text(
                                                                                          featureSourceNameList[index].toString().capitalizeFirst!,
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                        )),
                                                                                SizedBox(
                                                                                  height: height / 54.13,
                                                                                ),
                                                                                featureStatusList[index] == 4
                                                                                    ? SizedBox(
                                                                                        width: width / 1.6,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Shimmer.fromColors(
                                                                                              baseColor: const Color(0XFF0EA102),
                                                                                              highlightColor:
                                                                                                  Theme.of(context).colorScheme.background,
                                                                                              direction: ShimmerDirection.ltr,
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  /*SizedBox(
                                                                                                width: width / 1.6,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      height: height / 45.11,
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    bool response1 = await likeFunction(
                                                                                                                        id: featureIdList[index],
                                                                                                                        type: "feature");
                                                                                                                    if (response1) {
                                                                                                                      logEventFunc(
                                                                                                                          name: "Likes",
                                                                                                                          type: "Feature");
                                                                                                                      setState(() {
                                                                                                                        if (featureUseList[index] ==
                                                                                                                            true) {
                                                                                                                          if (featureDisuseList[
                                                                                                                                  index] ==
                                                                                                                              true) {
                                                                                                                          } else {
                                                                                                                            featureLikeList[index] -= 1;
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          if (featureDisuseList[
                                                                                                                                  index] ==
                                                                                                                              true) {
                                                                                                                            featureDislikeList[index] -=
                                                                                                                                1;
                                                                                                                            featureLikeList[index] += 1;
                                                                                                                          } else {
                                                                                                                            featureLikeList[index] += 1;
                                                                                                                          }
                                                                                                                        }
                                                                                                                        featureUseList[index] =
                                                                                                                            !featureUseList[index];
                                                                                                                        featureDisuseList[index] =
                                                                                                                            false;
                                                                                                                      });
                                                                                                                    } else {}
                                                                                                                  },
                                                                                                            child: Container(
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              child: featureUseList[index]
                                                                                                                  ? SvgPicture.asset(
                                                                                                                      isDarkTheme.value? "assets/home_screen/like_filled_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",,
                                                                                                                    )
                                                                                                                  : SvgPicture.asset(
                                                                                                                      isDarkTheme.value? "assets/home_screen/like_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",,
                                                                                                                    ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          GestureDetector(
                                                                                                            onTap: () async {
                                                                                                              logEventFunc(
                                                                                                                  name: "Share", type: "Feature");
                                                                                                              newLink = await getLinK(
                                                                                                                  id: featureIdList[index],
                                                                                                                  type: "feature",
                                                                                                                  description: '',
                                                                                                                  imageUrl:
                                                                                                                      "" */
                                                                                                  /*featureImagesList[index]*/ /*,
                                                                                                                  title: featureTitlesList[index],
                                                                                                                  text: selectedValue);
                                                                                                              ShareResult result =
                                                                                                                  await Share.share(
                                                                                                                "Look what I was able to find on Tradewatch: ${featureTitlesList[index]} ${newLink.toString()}",
                                                                                                              );
                                                                                                              if (result.status ==
                                                                                                                  ShareResultStatus.success) {
                                                                                                                await shareFunction(
                                                                                                                    id: featureIdList[index],
                                                                                                                    type: "feature");
                                                                                                              }
                                                                                                            },
                                                                                                            child: Container(
                                                                                                                height: height / 40.6,
                                                                                                                width: width / 18.75,
                                                                                                                margin:
                                                                                                                    EdgeInsets.only(right: width / 25),
                                                                                                                child: SvgPicture.asset(
                                                                                                                    isDarkTheme.value? "assets/home_screen/share_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",)),
                                                                                                          ),
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    bool response3 =
                                                                                                                        await disLikeFunction(
                                                                                                                            id: featureIdList[index],
                                                                                                                            type: "feature");
                                                                                                                    if (response3) {
                                                                                                                      logEventFunc(
                                                                                                                          name: "Dislikes",
                                                                                                                          type: "Feature");
                                                                                                                      setState(() {
                                                                                                                        if (featureDisuseList[index] ==
                                                                                                                            true) {
                                                                                                                          if (featureUseList[index] ==
                                                                                                                              true) {
                                                                                                                          } else {
                                                                                                                            featureDislikeList[index] -=
                                                                                                                                1;
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          if (featureUseList[index] ==
                                                                                                                              true) {
                                                                                                                            featureLikeList[index] -= 1;
                                                                                                                            featureDislikeList[index] +=
                                                                                                                                1;
                                                                                                                          } else {
                                                                                                                            featureDislikeList[index] +=
                                                                                                                                1;
                                                                                                                          }
                                                                                                                        }
                                                                                                                        featureDisuseList[index] =
                                                                                                                            !featureDisuseList[index];
                                                                                                                        featureUseList[index] = false;
                                                                                                                      });
                                                                                                                    } else {}
                                                                                                                  },
                                                                                                            child: Container(
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: featureDisuseList[index]
                                                                                                                  ? SvgPicture.asset(
                                                                                                                      isDarkTheme.value? "assets/home_screen/dislike_filled_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",,
                                                                                                                    )
                                                                                                                  : SvgPicture.asset(
                                                                                                                      isDarkTheme.value? "assets/home_screen/dislike_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",,
                                                                                                                    ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: SvgPicture.asset(
                                                                                                                "lib/Constants/Assets/SMLogos/messageCircle.svg",colorFilter: ColorFilter.mode(isDarkTheme.value? const Color(0XFFD6D6D6): const Color(0XFF0EA102),BlendMode.srcIn),,
                                                                                                              )),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    widgetsMain.translationWidget(
                                                                                                        translationList: featureTranslationList,
                                                                                                        id: featureIdList[index],
                                                                                                        type: 'feature',
                                                                                                        index: index,
                                                                                                        initFunction: getFeatureData,
                                                                                                        context: context,
                                                                                                        modelSetState: setState,
                                                                                                        notUse: false,
                                                                                                        titleList: featureTitlesList)
                                                                                                  ],
                                                                                                ),
                                                                                              )*/
                                                                                                  SizedBox(
                                                                                                    height: height / 45.11,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        GestureDetector(
                                                                                                          onTap: mainSkipValue
                                                                                                              ? () {
                                                                                                                  commonFlushBar(
                                                                                                                      context: context,
                                                                                                                      initFunction: initState);
                                                                                                                }
                                                                                                              : () async {
                                                                                                                  bool response1 = await likeFunction(
                                                                                                                      id: featureIdList[index],
                                                                                                                      type: "feature");
                                                                                                                  if (response1) {
                                                                                                                    logEventFunc(
                                                                                                                        name: "Likes",
                                                                                                                        type: "Feature");
                                                                                                                    setState(() {
                                                                                                                      if (featureUseList[index] ==
                                                                                                                          true) {
                                                                                                                        if (featureDisuseList[
                                                                                                                                index] ==
                                                                                                                            true) {
                                                                                                                        } else {
                                                                                                                          featureLikeList[index] -= 1;
                                                                                                                        }
                                                                                                                      } else {
                                                                                                                        if (featureDisuseList[
                                                                                                                                index] ==
                                                                                                                            true) {
                                                                                                                          featureDislikeList[index] -=
                                                                                                                              1;
                                                                                                                          featureLikeList[index] += 1;
                                                                                                                        } else {
                                                                                                                          featureLikeList[index] += 1;
                                                                                                                        }
                                                                                                                      }
                                                                                                                      featureUseList[index] =
                                                                                                                          !featureUseList[index];
                                                                                                                      featureDisuseList[index] =
                                                                                                                          false;
                                                                                                                    });
                                                                                                                  } else {}
                                                                                                                },
                                                                                                          child: Container(
                                                                                                            margin:
                                                                                                                EdgeInsets.only(right: width / 25),
                                                                                                            height: height / 40.6,
                                                                                                            width: width / 18.75,
                                                                                                            child: featureUseList[index]
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
                                                                                                            logEventFunc(
                                                                                                                name: "Share", type: "Feature");
                                                                                                            newLink = await getLinK(
                                                                                                                id: featureIdList[index],
                                                                                                                type: "feature",
                                                                                                                description: '',
                                                                                                                imageUrl:
                                                                                                                    "" /*featureImagesList[index]*/,
                                                                                                                title: featureTitlesList[index],
                                                                                                                text: selectedValue);
                                                                                                            ShareResult result =
                                                                                                                await Share.share(
                                                                                                              "Look what I was able to find on Tradewatch: ${featureTitlesList[index]} ${newLink.toString()}",
                                                                                                            );
                                                                                                            if (result.status ==
                                                                                                                ShareResultStatus.success) {
                                                                                                              await shareFunction(
                                                                                                                  id: featureIdList[index],
                                                                                                                  type: "feature");
                                                                                                            }
                                                                                                          },
                                                                                                          child: Container(
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: SvgPicture.asset(
                                                                                                                isDarkTheme.value
                                                                                                                    ? "assets/home_screen/share_dark.svg"
                                                                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                                              )),
                                                                                                        ),
                                                                                                        GestureDetector(
                                                                                                          onTap: mainSkipValue
                                                                                                              ? () {
                                                                                                                  commonFlushBar(
                                                                                                                      context: context,
                                                                                                                      initFunction: initState);
                                                                                                                }
                                                                                                              : () async {
                                                                                                                  bool response3 =
                                                                                                                      await disLikeFunction(
                                                                                                                          id: featureIdList[index],
                                                                                                                          type: "feature");
                                                                                                                  if (response3) {
                                                                                                                    logEventFunc(
                                                                                                                        name: "Dislikes",
                                                                                                                        type: "Feature");
                                                                                                                    setState(() {
                                                                                                                      if (featureDisuseList[index] ==
                                                                                                                          true) {
                                                                                                                        if (featureUseList[index] ==
                                                                                                                            true) {
                                                                                                                        } else {
                                                                                                                          featureDislikeList[index] -=
                                                                                                                              1;
                                                                                                                        }
                                                                                                                      } else {
                                                                                                                        if (featureUseList[index] ==
                                                                                                                            true) {
                                                                                                                          featureLikeList[index] -= 1;
                                                                                                                          featureDislikeList[index] +=
                                                                                                                              1;
                                                                                                                        } else {
                                                                                                                          featureDislikeList[index] +=
                                                                                                                              1;
                                                                                                                        }
                                                                                                                      }
                                                                                                                      featureDisuseList[index] =
                                                                                                                          !featureDisuseList[index];
                                                                                                                      featureUseList[index] = false;
                                                                                                                    });
                                                                                                                  } else {}
                                                                                                                },
                                                                                                          child: Container(
                                                                                                            height: height / 40.6,
                                                                                                            width: width / 18.75,
                                                                                                            margin:
                                                                                                                EdgeInsets.only(right: width / 25),
                                                                                                            child: featureDisuseList[index]
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
                                                                                                            margin:
                                                                                                                EdgeInsets.only(right: width / 25),
                                                                                                            child: SvgPicture.asset(
                                                                                                              "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                                              colorFilter: ColorFilter.mode(
                                                                                                                  isDarkTheme.value
                                                                                                                      ? const Color(0XFFD6D6D6)
                                                                                                                      : const Color(0XFF0EA102),
                                                                                                                  BlendMode.srcIn),
                                                                                                            )),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            widgetsMain.translationWidget(
                                                                                                translationList: featureTranslationList,
                                                                                                id: featureIdList[index],
                                                                                                type: 'feature',
                                                                                                index: index,
                                                                                                initFunction: getFeatureData,
                                                                                                context: context,
                                                                                                modelSetState: setState,
                                                                                                notUse: false,
                                                                                                titleList: featureTitlesList)
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : SizedBox(
                                                                                        width: width / 1.6,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              height: height / 45.11,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    margin: EdgeInsets.only(right: width / 25),
                                                                                                    height: height / 40.6,
                                                                                                    width: width / 18.75,
                                                                                                    child: featureUseList[index]
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
                                                                                                    child: featureDisuseList[index]
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
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            widgetsMain.translationWidget(
                                                                                                translationList: featureTranslationList,
                                                                                                id: featureIdList[index],
                                                                                                type: 'feature',
                                                                                                index: index,
                                                                                                initFunction: getFeatureData,
                                                                                                context: context,
                                                                                                modelSetState: setState,
                                                                                                notUse: false,
                                                                                                titleList: featureTitlesList)
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                SizedBox(
                                                                                  height: height / 81.2,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: height / 54.13,
                                                                                  child: Row(
                                                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      featureStatusList[index] == 4
                                                                                          ? Shimmer.fromColors(
                                                                                              baseColor: Colors.blue,
                                                                                              highlightColor:
                                                                                                  Theme.of(context).colorScheme.background,
                                                                                              direction: ShimmerDirection.ltr,
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Text(
                                                                                                      featureCategoryList[index] == "general"
                                                                                                          ? "General"
                                                                                                          : featureCategoryList[index] == "stocks"
                                                                                                              ? "Stocks"
                                                                                                              : featureCategoryList[index] == "crypto"
                                                                                                                  ? "Crypto"
                                                                                                                  : featureCategoryList[index] ==
                                                                                                                          "commodity"
                                                                                                                      ? "Commodity"
                                                                                                                      : featureCategoryList[index] ==
                                                                                                                              "forex"
                                                                                                                          ? "Forex"
                                                                                                                          : "",
                                                                                                      style: TextStyle(
                                                                                                          fontSize: text.scale(10),
                                                                                                          fontWeight: FontWeight.w700,
                                                                                                          color: Colors.blue)),
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          : Text(
                                                                                              featureCategoryList[index] == "general"
                                                                                                  ? "General"
                                                                                                  : featureCategoryList[index] == "stocks"
                                                                                                      ? "Stocks"
                                                                                                      : featureCategoryList[index] == "crypto"
                                                                                                          ? "Crypto"
                                                                                                          : featureCategoryList[index] == "commodity"
                                                                                                              ? "Commodity"
                                                                                                              : featureCategoryList[index] == "forex"
                                                                                                                  ? "Forex"
                                                                                                                  : "",
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: Colors.blue)),
                                                                                      SizedBox(width: width / 45),
                                                                                      featureStatusList[index] == 4
                                                                                          ? Shimmer.fromColors(
                                                                                              baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                              highlightColor:
                                                                                                  Theme.of(context).colorScheme.background,
                                                                                              direction: ShimmerDirection.ltr,
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      Text(featureLikeList[index].toString(),
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(10),
                                                                                                              fontWeight: FontWeight.w700)),
                                                                                                      Text(" Likes",
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(10),
                                                                                                              fontWeight: FontWeight.w500)),
                                                                                                    ],
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          : Row(
                                                                                              children: [
                                                                                                Text(featureLikeList[index].toString(),
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w700)),
                                                                                                Text(" Likes",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w500)),
                                                                                              ],
                                                                                            ),
                                                                                      SizedBox(width: width / 45),
                                                                                      featureStatusList[index] == 4
                                                                                          ? Shimmer.fromColors(
                                                                                              baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                              highlightColor:
                                                                                                  Theme.of(context).colorScheme.background,
                                                                                              direction: ShimmerDirection.ltr,
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      Text(featureDislikeList[index].toString(),
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(10),
                                                                                                              fontWeight: FontWeight.w700)),
                                                                                                      Text(" DisLikes",
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(10),
                                                                                                              fontWeight: FontWeight.w500)),
                                                                                                    ],
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          : Row(
                                                                                              children: [
                                                                                                Text(featureDislikeList[index].toString(),
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w700)),
                                                                                                Text(" DisLikes",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w500)),
                                                                                              ],
                                                                                            ),
                                                                                      SizedBox(width: width / 45),
                                                                                      featureStatusList[index] == 4
                                                                                          ? Shimmer.fromColors(
                                                                                              baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                              highlightColor:
                                                                                                  Theme.of(context).colorScheme.background,
                                                                                              direction: ShimmerDirection.ltr,
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Text(featureResponseList[index].toString(),
                                                                                                      style: TextStyle(
                                                                                                          fontSize: text.scale(10),
                                                                                                          fontWeight: FontWeight.w700))
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          : Text(featureResponseList[index].toString(),
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  fontWeight: FontWeight.w700)),
                                                                                      featureStatusList[index] == 4
                                                                                          ? Shimmer.fromColors(
                                                                                              baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                              highlightColor:
                                                                                                  Theme.of(context).colorScheme.background,
                                                                                              direction: ShimmerDirection.ltr,
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Text(" Response",
                                                                                                      style: TextStyle(
                                                                                                          fontSize: text.scale(10),
                                                                                                          fontWeight: FontWeight.w500))
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          : Text(" Response",
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
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 15,
                                        child: Container(
                                          margin: const EdgeInsets.all(3),
                                          width: width * 0.6,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Theme.of(context).colorScheme.tertiary, //Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: categoriesList.length,
                                                  itemBuilder: (context, index) {
                                                    return RadioListTile<int>(
                                                      value: index,
                                                      groupValue: selectedIndex,
                                                      onChanged: (int? value) async {
                                                        context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                                        setState(() {
                                                          selectedIndex = index;
                                                          selectedValue = categoriesList[index];
                                                          extraContainMain.value = false;
                                                        });
                                                        await getFeatureData();
                                                      },
                                                      title: Text(categoriesList[index],
                                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                      controlAffinity: ListTileControlAffinity.trailing,
                                                      activeColor: Colors.green,
                                                    );

                                                    /*ListTile(
                                                      onTap: () async {
                                                        context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                                        setState(() {
                                                          selectedIndex = index;
                                                          selectedValue = categoriesList[index];
                                                          extraContainMain.value = false;
                                                        });
                                                        await getFeatureData();
                                                      },
                                                      title: Text(categoriesList[index],
                                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                      trailing: Icon(
                                                        Icons.check,
                                                        color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                                      ),
                                                    );*/
                                                  }),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(height: height / 50.75),
                                      GestureDetector(
                                        onTap: () {
                                          if (mainSkipValue) {
                                            commonFlushBar(context: context, initFunction: initState);
                                          } else {
                                            logEventFunc(name: 'Feature_Request_Start', type: 'Feature Request');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    maintainState: false,
                                                    builder: (BuildContext context) {
                                                      return const FeaturePostPage();
                                                    }));
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                          height: height / 23.88,
                                          child: Center(
                                              child: Text(
                                            'Post a Request',
                                            style: TextStyle(color: Colors.white, fontSize: text.scale(12), fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 33.83,
                                      ),
                                      emptyBool
                                          ? SizedBox(
                                              height: height / 1.5,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                                    RichText(
                                                      text: const TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: 'Unfortunately, there is nothing to display!',
                                                              style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : startSearch
                                              ? SizedBox(
                                                  height: height / 1.45,
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: Platform.isIOS ? height / 1.5 : height / 1.4,
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
                                                    onLoading: _onFeatureLoading,
                                                    child: ListView.builder(
                                                      physics: const ScrollPhysics(),
                                                      itemCount: featureImagesList.length,
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
                                                                  onTap: featureStatusList[index] == 4
                                                                      ? () {
                                                                          getCompletedPopUp(
                                                                              releaseDate: featureReleasedDate[index],
                                                                              androidVersion: featureAndroidVersion[index],
                                                                              iosVersion: featureIosVersion[index]);
                                                                        }
                                                                      : mainSkipValue
                                                                          ? () {
                                                                              commonFlushBar(context: context, initFunction: initState);
                                                                            }
                                                                          : () async {
                                                                              bool refresh = await Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                return FeaturePostDescriptionPage(
                                                                                  sortValue: selectedValue,
                                                                                  featureId: featureIdList[index],
                                                                                  featureDetail: featureObjectList[index],
                                                                                  navBool: 'feature',
                                                                                  idList: featureIdList,
                                                                                );
                                                                              }));
                                                                              if (refresh) {
                                                                                initState();
                                                                              }
                                                                            },
                                                                  child: Container(
                                                                      margin: EdgeInsets.only(bottom: height / 35, top: 3, right: 3, left: 3),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                                                                      decoration: BoxDecoration(
                                                                          color: featureStatusList[index] == 4
                                                                              ? isDarkTheme.value
                                                                                  ? Theme.of(context).colorScheme.tertiary
                                                                                  : Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                                                              : Theme.of(context).colorScheme.background /*Colors.white*/,
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
                                                                            color: featureStatusList[index] == 4
                                                                                ? isDarkTheme.value
                                                                                    ? Theme.of(context).colorScheme.tertiary
                                                                                    : Colors.transparent
                                                                                : Theme.of(context).colorScheme.background,
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
                                                                                        if (mainSkipValue) {
                                                                                          commonFlushBar(context: context, initFunction: initState);
                                                                                        } else {
                                                                                          Navigator.push(context,
                                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                                            return UserBillBoardProfilePage(
                                                                                                userId: featureUserIdList[
                                                                                                    index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                          }));
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        height: height / 13.53,
                                                                                        width: width / 5.95,
                                                                                        margin: EdgeInsets.fromLTRB(width / 23.43, height / 203,
                                                                                            width / 37.5, height / 27.06),
                                                                                        decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.grey,
                                                                                            image: DecorationImage(
                                                                                                image: NetworkImage(featureImagesList[index]),
                                                                                                fit: BoxFit.fill)),
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      width: width / 1.6,
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment:
                                                                                                            MainAxisAlignment.spaceBetween,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                              width: width / 1.8,
                                                                                                              child: Text(
                                                                                                                featureTitlesList[index],
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: text.scale(14),
                                                                                                                    fontWeight: FontWeight.w600),
                                                                                                              )),
                                                                                                          GestureDetector(
                                                                                                            onTap: () {
                                                                                                              if (mainSkipValue) {
                                                                                                                commonFlushBar(
                                                                                                                    context: context,
                                                                                                                    initFunction: initState);
                                                                                                              } else {
                                                                                                                showModalBottomSheet(
                                                                                                                    shape:
                                                                                                                        const RoundedRectangleBorder(
                                                                                                                      borderRadius:
                                                                                                                          BorderRadius.vertical(
                                                                                                                        top: Radius.circular(30),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    context: context,
                                                                                                                    builder: (BuildContext context) {
                                                                                                                      return SingleChildScrollView(
                                                                                                                        child: Container(
                                                                                                                          margin:
                                                                                                                              EdgeInsets.symmetric(
                                                                                                                                  horizontal:
                                                                                                                                      width / 18.75),
                                                                                                                          padding: EdgeInsets.only(
                                                                                                                              bottom: MediaQuery.of(
                                                                                                                                      context)
                                                                                                                                  .viewInsets
                                                                                                                                  .bottom),
                                                                                                                          child: featureMyList[index]
                                                                                                                              ? ListTile(
                                                                                                                                  onTap: mainSkipValue
                                                                                                                                      ? () {
                                                                                                                                          commonFlushBar(
                                                                                                                                              context:
                                                                                                                                                  context,
                                                                                                                                              initFunction:
                                                                                                                                                  initState);
                                                                                                                                        }
                                                                                                                                      : () {
                                                                                                                                          Navigator.pop(
                                                                                                                                              context);
                                                                                                                                          showDialog(
                                                                                                                                              barrierDismissible:
                                                                                                                                                  false,
                                                                                                                                              context:
                                                                                                                                                  context,
                                                                                                                                              builder:
                                                                                                                                                  (BuildContext
                                                                                                                                                      context) {
                                                                                                                                                return Dialog(
                                                                                                                                                  shape:
                                                                                                                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                                                                                                  //this right here
                                                                                                                                                  child:
                                                                                                                                                      Container(
                                                                                                                                                    height: height / 6,
                                                                                                                                                    margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                                                                                                                    child: Column(
                                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                                      children: [
                                                                                                                                                        const Center(child: Text("Delete Request", style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Poppins"))),
                                                                                                                                                        const Divider(),
                                                                                                                                                        const Center(child: Text("Are you sure to Delete this Request")),
                                                                                                                                                        const Spacer(),
                                                                                                                                                        Padding(
                                                                                                                                                          padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                                                                                                                          child: Row(
                                                                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                                            children: [
                                                                                                                                                              TextButton(
                                                                                                                                                                onPressed: () {
                                                                                                                                                                  if (!mounted) {
                                                                                                                                                                    return;
                                                                                                                                                                  }
                                                                                                                                                                  Navigator.pop(context);
                                                                                                                                                                },
                                                                                                                                                                child: const Text(
                                                                                                                                                                  "Cancel",
                                                                                                                                                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                                                                                                                                ),
                                                                                                                                                              ),
                                                                                                                                                              ElevatedButton(
                                                                                                                                                                style: ElevatedButton.styleFrom(
                                                                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                                                                    borderRadius: BorderRadius.circular(18.0),
                                                                                                                                                                  ),
                                                                                                                                                                  backgroundColor: Colors.green,
                                                                                                                                                                ),
                                                                                                                                                                onPressed: () async {
                                                                                                                                                                  deletePost(featureId: featureIdList[index]);
                                                                                                                                                                  if (!mounted) {
                                                                                                                                                                    return;
                                                                                                                                                                  }
                                                                                                                                                                  Navigator.pop(context);
                                                                                                                                                                },
                                                                                                                                                                child: const Text(
                                                                                                                                                                  "Continue",
                                                                                                                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
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
                                                                                                                                  minLeadingWidth:
                                                                                                                                      width / 25,
                                                                                                                                  leading: const Icon(
                                                                                                                                    Icons.delete,
                                                                                                                                    size: 20,
                                                                                                                                  ),
                                                                                                                                  title: Text(
                                                                                                                                    "Delete Post",
                                                                                                                                    style: TextStyle(
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight
                                                                                                                                                .w500,
                                                                                                                                        fontSize: text
                                                                                                                                            .scale(
                                                                                                                                                14)),
                                                                                                                                  ),
                                                                                                                                )
                                                                                                                              : Column(
                                                                                                                                  mainAxisAlignment:
                                                                                                                                      MainAxisAlignment
                                                                                                                                          .start,
                                                                                                                                  crossAxisAlignment:
                                                                                                                                      CrossAxisAlignment
                                                                                                                                          .start,
                                                                                                                                  children: [
                                                                                                                                    ListTile(
                                                                                                                                      onTap:
                                                                                                                                          mainSkipValue
                                                                                                                                              ? () {
                                                                                                                                                  commonFlushBar(
                                                                                                                                                      context: context,
                                                                                                                                                      initFunction: initState);
                                                                                                                                                }
                                                                                                                                              : () {
                                                                                                                                                  Navigator.pop(context);
                                                                                                                                                  _controller.clear();
                                                                                                                                                  setState(() {
                                                                                                                                                    actionValue = "Report";
                                                                                                                                                  });
                                                                                                                                                  showAlertDialog(
                                                                                                                                                      context: context,
                                                                                                                                                      featureId: featureIdList[index],
                                                                                                                                                      featureUserId: featureUserIdList[index]);
                                                                                                                                                },
                                                                                                                                      minLeadingWidth:
                                                                                                                                          width / 25,
                                                                                                                                      leading:
                                                                                                                                          const Icon(
                                                                                                                                        Icons.shield,
                                                                                                                                        size: 20,
                                                                                                                                      ),
                                                                                                                                      title: Text(
                                                                                                                                        "Report Post",
                                                                                                                                        style: TextStyle(
                                                                                                                                            fontWeight:
                                                                                                                                                FontWeight
                                                                                                                                                    .w500,
                                                                                                                                            fontSize:
                                                                                                                                                text.scale(
                                                                                                                                                    14)),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    const Divider(
                                                                                                                                      thickness: 0.0,
                                                                                                                                      height: 0.0,
                                                                                                                                    ),
                                                                                                                                    ListTile(
                                                                                                                                      onTap:
                                                                                                                                          mainSkipValue
                                                                                                                                              ? () {
                                                                                                                                                  commonFlushBar(
                                                                                                                                                      context: context,
                                                                                                                                                      initFunction: initState);
                                                                                                                                                }
                                                                                                                                              : () {
                                                                                                                                                  _controller.clear();
                                                                                                                                                  setState(() {
                                                                                                                                                    actionValue = "Block";
                                                                                                                                                  });
                                                                                                                                                  Navigator.pop(context);
                                                                                                                                                  showAlertDialog(
                                                                                                                                                      context: context,
                                                                                                                                                      featureId: featureIdList[index],
                                                                                                                                                      featureUserId: featureUserIdList[index]);
                                                                                                                                                },
                                                                                                                                      minLeadingWidth:
                                                                                                                                          width / 25,
                                                                                                                                      leading:
                                                                                                                                          const Icon(
                                                                                                                                        Icons.flag,
                                                                                                                                        size: 20,
                                                                                                                                      ),
                                                                                                                                      title: Text(
                                                                                                                                        "Block Post",
                                                                                                                                        style: TextStyle(
                                                                                                                                            fontWeight:
                                                                                                                                                FontWeight
                                                                                                                                                    .w500,
                                                                                                                                            fontSize:
                                                                                                                                                text.scale(
                                                                                                                                                    14)),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    });
                                                                                                              }
                                                                                                            },
                                                                                                            child: Container(
                                                                                                              padding:
                                                                                                                  EdgeInsets.only(right: width / 50),
                                                                                                              child: const Icon(
                                                                                                                Icons.more_horiz,
                                                                                                                size: 20,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : SizedBox(
                                                                                                width: width / 1.6,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                        width: width / 1.8,
                                                                                                        child: Text(
                                                                                                          featureTitlesList[index],
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(14),
                                                                                                              fontWeight: FontWeight.w600),
                                                                                                        )),
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        if (mainSkipValue) {
                                                                                                          commonFlushBar(
                                                                                                              context: context,
                                                                                                              initFunction: initState);
                                                                                                        } else {
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
                                                                                                                    child: featureMyList[index]
                                                                                                                        ? ListTile(
                                                                                                                            onTap: mainSkipValue
                                                                                                                                ? () {
                                                                                                                                    commonFlushBar(
                                                                                                                                        context:
                                                                                                                                            context,
                                                                                                                                        initFunction:
                                                                                                                                            initState);
                                                                                                                                  }
                                                                                                                                : () {
                                                                                                                                    if (!mounted) {
                                                                                                                                      return;
                                                                                                                                    }
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);
                                                                                                                                    showDialog(
                                                                                                                                        barrierDismissible:
                                                                                                                                            false,
                                                                                                                                        context:
                                                                                                                                            context,
                                                                                                                                        builder:
                                                                                                                                            (BuildContext
                                                                                                                                                context) {
                                                                                                                                          return Dialog(
                                                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                                                borderRadius:
                                                                                                                                                    BorderRadius.circular(20.0)),
                                                                                                                                            //this right here
                                                                                                                                            child:
                                                                                                                                                Container(
                                                                                                                                              height:
                                                                                                                                                  height /
                                                                                                                                                      6,
                                                                                                                                              margin: EdgeInsets.symmetric(
                                                                                                                                                  vertical: height /
                                                                                                                                                      54.13,
                                                                                                                                                  horizontal:
                                                                                                                                                      width / 25),
                                                                                                                                              child:
                                                                                                                                                  Column(
                                                                                                                                                mainAxisAlignment:
                                                                                                                                                    MainAxisAlignment.center,
                                                                                                                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                                children: [
                                                                                                                                                  const Center(child: Text("Delete Request", style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Poppins"))),
                                                                                                                                                  const Divider(),
                                                                                                                                                  const Center(child: Text("Are you sure to Delete this Request")),
                                                                                                                                                  const Spacer(),
                                                                                                                                                  Padding(
                                                                                                                                                    padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                                                                                                                    child: Row(
                                                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                                      children: [
                                                                                                                                                        TextButton(
                                                                                                                                                          onPressed: () {
                                                                                                                                                            if (!mounted) {
                                                                                                                                                              return;
                                                                                                                                                            }
                                                                                                                                                            Navigator.pop(context);
                                                                                                                                                          },
                                                                                                                                                          child: const Text(
                                                                                                                                                            "Cancel",
                                                                                                                                                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                                                                                                                          ),
                                                                                                                                                        ),
                                                                                                                                                        ElevatedButton(
                                                                                                                                                          style: ElevatedButton.styleFrom(
                                                                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                                                                                                            ),
                                                                                                                                                            backgroundColor: Colors.green,
                                                                                                                                                          ),
                                                                                                                                                          onPressed: () async {
                                                                                                                                                            deletePost(featureId: featureIdList[index]);
                                                                                                                                                            if (!mounted) {
                                                                                                                                                              return;
                                                                                                                                                            }
                                                                                                                                                            Navigator.pop(context);
                                                                                                                                                          },
                                                                                                                                                          child: const Text(
                                                                                                                                                            "Continue",
                                                                                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
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
                                                                                                                            minLeadingWidth:
                                                                                                                                width / 25,
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
                                                                                                                          )
                                                                                                                        : Column(
                                                                                                                            mainAxisAlignment:
                                                                                                                                MainAxisAlignment
                                                                                                                                    .start,
                                                                                                                            crossAxisAlignment:
                                                                                                                                CrossAxisAlignment
                                                                                                                                    .start,
                                                                                                                            children: [
                                                                                                                              ListTile(
                                                                                                                                onTap: mainSkipValue
                                                                                                                                    ? () {
                                                                                                                                        commonFlushBar(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            initFunction:
                                                                                                                                                initState);
                                                                                                                                      }
                                                                                                                                    : () {
                                                                                                                                        Navigator.pop(
                                                                                                                                            context);
                                                                                                                                        _controller
                                                                                                                                            .clear();
                                                                                                                                        setState(() {
                                                                                                                                          actionValue =
                                                                                                                                              "Report";
                                                                                                                                        });
                                                                                                                                        showAlertDialog(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            featureId:
                                                                                                                                                featureIdList[
                                                                                                                                                    index],
                                                                                                                                            featureUserId:
                                                                                                                                                featureUserIdList[
                                                                                                                                                    index]);
                                                                                                                                      },
                                                                                                                                minLeadingWidth:
                                                                                                                                    width / 25,
                                                                                                                                leading: const Icon(
                                                                                                                                  Icons.shield,
                                                                                                                                  size: 20,
                                                                                                                                ),
                                                                                                                                title: Text(
                                                                                                                                  "Report Post",
                                                                                                                                  style: TextStyle(
                                                                                                                                      fontWeight:
                                                                                                                                          FontWeight
                                                                                                                                              .w500,
                                                                                                                                      fontSize: text
                                                                                                                                          .scale(14)),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              const Divider(
                                                                                                                                thickness: 0.0,
                                                                                                                                height: 0.0,
                                                                                                                              ),
                                                                                                                              ListTile(
                                                                                                                                onTap: mainSkipValue
                                                                                                                                    ? () {
                                                                                                                                        commonFlushBar(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            initFunction:
                                                                                                                                                initState);
                                                                                                                                      }
                                                                                                                                    : () {
                                                                                                                                        _controller
                                                                                                                                            .clear();
                                                                                                                                        setState(() {
                                                                                                                                          actionValue =
                                                                                                                                              "Block";
                                                                                                                                        });
                                                                                                                                        Navigator.pop(
                                                                                                                                            context);
                                                                                                                                        showAlertDialog(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            featureId:
                                                                                                                                                featureIdList[
                                                                                                                                                    index],
                                                                                                                                            featureUserId:
                                                                                                                                                featureUserIdList[
                                                                                                                                                    index]);
                                                                                                                                      },
                                                                                                                                minLeadingWidth:
                                                                                                                                    width / 25,
                                                                                                                                leading: const Icon(
                                                                                                                                  Icons.flag,
                                                                                                                                  size: 20,
                                                                                                                                ),
                                                                                                                                title: Text(
                                                                                                                                  "Block Post",
                                                                                                                                  style: TextStyle(
                                                                                                                                      fontWeight:
                                                                                                                                          FontWeight
                                                                                                                                              .w500,
                                                                                                                                      fontSize: text
                                                                                                                                          .scale(14)),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              });
                                                                                                        }
                                                                                                      },
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsets.only(right: width / 50),
                                                                                                        child: const Icon(
                                                                                                          Icons.more_horiz,
                                                                                                          size: 20,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        if (mainSkipValue) {
                                                                                                          commonFlushBar(
                                                                                                              context: context,
                                                                                                              initFunction: initState);
                                                                                                        } else {
                                                                                                          Navigator.push(context, MaterialPageRoute(
                                                                                                              builder: (BuildContext context) {
                                                                                                            return UserBillBoardProfilePage(
                                                                                                                userId: featureUserIdList[
                                                                                                                    index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                                          }));
                                                                                                        }
                                                                                                      },
                                                                                                      child: SizedBox(
                                                                                                          height: height / 54.13,
                                                                                                          width: width / 1.8,
                                                                                                          child: Text(
                                                                                                            featureSourceNameList[index]
                                                                                                                .toString()
                                                                                                                .capitalizeFirst!,
                                                                                                            style: TextStyle(
                                                                                                                fontSize: text.scale(10),
                                                                                                                fontWeight: FontWeight.w500),
                                                                                                          )),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : GestureDetector(
                                                                                                onTap: () {
                                                                                                  if (mainSkipValue) {
                                                                                                    commonFlushBar(
                                                                                                        context: context, initFunction: initState);
                                                                                                  } else {
                                                                                                    Navigator.push(context, MaterialPageRoute(
                                                                                                        builder: (BuildContext context) {
                                                                                                      return UserBillBoardProfilePage(
                                                                                                          userId: featureUserIdList[
                                                                                                              index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                                    }));
                                                                                                  }
                                                                                                },
                                                                                                child: SizedBox(
                                                                                                    height: height / 54.13,
                                                                                                    width: width / 1.84,
                                                                                                    child: Text(
                                                                                                      featureSourceNameList[index]
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
                                                                                        featureStatusList[index] == 4
                                                                                            ? SizedBox(
                                                                                                width: width / 1.6,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Shimmer.fromColors(
                                                                                                      baseColor:
                                                                                                          Theme.of(context).colorScheme.primary,
                                                                                                      highlightColor:
                                                                                                          Theme.of(context).colorScheme.background,
                                                                                                      direction: ShimmerDirection.ltr,
                                                                                                      child: Wrap(
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            height: height / 45.11,
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment:
                                                                                                                  MainAxisAlignment.start,
                                                                                                              crossAxisAlignment:
                                                                                                                  CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                GestureDetector(
                                                                                                                  onTap: mainSkipValue
                                                                                                                      ? () {
                                                                                                                          commonFlushBar(
                                                                                                                              context: context,
                                                                                                                              initFunction:
                                                                                                                                  initState);
                                                                                                                        }
                                                                                                                      : () async {
                                                                                                                          bool response1 =
                                                                                                                              await likeFunction(
                                                                                                                                  id: featureIdList[
                                                                                                                                      index],
                                                                                                                                  type: "feature");
                                                                                                                          if (response1) {
                                                                                                                            logEventFunc(
                                                                                                                                name: "Likes",
                                                                                                                                type: "Feature");
                                                                                                                            setState(() {
                                                                                                                              if (featureUseList[
                                                                                                                                      index] ==
                                                                                                                                  true) {
                                                                                                                                if (featureDisuseList[
                                                                                                                                        index] ==
                                                                                                                                    true) {
                                                                                                                                } else {
                                                                                                                                  featureLikeList[
                                                                                                                                      index] -= 1;
                                                                                                                                }
                                                                                                                              } else {
                                                                                                                                if (featureDisuseList[
                                                                                                                                        index] ==
                                                                                                                                    true) {
                                                                                                                                  featureDislikeList[
                                                                                                                                      index] -= 1;
                                                                                                                                  featureLikeList[
                                                                                                                                      index] += 1;
                                                                                                                                } else {
                                                                                                                                  featureLikeList[
                                                                                                                                      index] += 1;
                                                                                                                                }
                                                                                                                              }
                                                                                                                              featureUseList[index] =
                                                                                                                                  !featureUseList[
                                                                                                                                      index];
                                                                                                                              featureDisuseList[
                                                                                                                                  index] = false;
                                                                                                                            });
                                                                                                                          } else {}
                                                                                                                        },
                                                                                                                  child: Container(
                                                                                                                    margin: EdgeInsets.only(
                                                                                                                        right: width / 25),
                                                                                                                    height: height / 40.6,
                                                                                                                    width: width / 18.75,
                                                                                                                    child: featureUseList[index]
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
                                                                                                                    logEventFunc(
                                                                                                                        name: "Share",
                                                                                                                        type: "Feature");
                                                                                                                    newLink = await getLinK(
                                                                                                                        id: featureIdList[index],
                                                                                                                        type: "feature",
                                                                                                                        description: '',
                                                                                                                        imageUrl:
                                                                                                                            "" /*featureImagesList[index]*/,
                                                                                                                        title:
                                                                                                                            featureTitlesList[index],
                                                                                                                        text: selectedValue);
                                                                                                                    ShareResult result =
                                                                                                                        await Share.share(
                                                                                                                      "Look what I was able to find on Tradewatch: ${featureTitlesList[index]} ${newLink.toString()}",
                                                                                                                    );
                                                                                                                    if (result.status ==
                                                                                                                        ShareResultStatus.success) {
                                                                                                                      await shareFunction(
                                                                                                                          id: featureIdList[index],
                                                                                                                          type: "feature");
                                                                                                                    }
                                                                                                                  },
                                                                                                                  child: Container(
                                                                                                                      height: height / 40.6,
                                                                                                                      width: width / 18.75,
                                                                                                                      margin: EdgeInsets.only(
                                                                                                                          right: width / 25),
                                                                                                                      child: SvgPicture.asset(
                                                                                                                        isDarkTheme.value
                                                                                                                            ? "assets/home_screen/share_dark.svg"
                                                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                                                      )),
                                                                                                                ),
                                                                                                                GestureDetector(
                                                                                                                  onTap: mainSkipValue
                                                                                                                      ? () {
                                                                                                                          commonFlushBar(
                                                                                                                              context: context,
                                                                                                                              initFunction:
                                                                                                                                  initState);
                                                                                                                        }
                                                                                                                      : () async {
                                                                                                                          bool response3 =
                                                                                                                              await disLikeFunction(
                                                                                                                                  id: featureIdList[
                                                                                                                                      index],
                                                                                                                                  type: "feature");
                                                                                                                          if (response3) {
                                                                                                                            logEventFunc(
                                                                                                                                name: "Dislikes",
                                                                                                                                type: "Feature");
                                                                                                                            setState(() {
                                                                                                                              if (featureDisuseList[
                                                                                                                                      index] ==
                                                                                                                                  true) {
                                                                                                                                if (featureUseList[
                                                                                                                                        index] ==
                                                                                                                                    true) {
                                                                                                                                } else {
                                                                                                                                  featureDislikeList[
                                                                                                                                      index] -= 1;
                                                                                                                                }
                                                                                                                              } else {
                                                                                                                                if (featureUseList[
                                                                                                                                        index] ==
                                                                                                                                    true) {
                                                                                                                                  featureLikeList[
                                                                                                                                      index] -= 1;
                                                                                                                                  featureDislikeList[
                                                                                                                                      index] += 1;
                                                                                                                                } else {
                                                                                                                                  featureDislikeList[
                                                                                                                                      index] += 1;
                                                                                                                                }
                                                                                                                              }
                                                                                                                              featureDisuseList[
                                                                                                                                      index] =
                                                                                                                                  !featureDisuseList[
                                                                                                                                      index];
                                                                                                                              featureUseList[index] =
                                                                                                                                  false;
                                                                                                                            });
                                                                                                                          } else {}
                                                                                                                        },
                                                                                                                  child: Container(
                                                                                                                    height: height / 40.6,
                                                                                                                    width: width / 18.75,
                                                                                                                    margin: EdgeInsets.only(
                                                                                                                        right: width / 25),
                                                                                                                    child: featureDisuseList[index]
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
                                                                                                                    margin: EdgeInsets.only(
                                                                                                                        right: width / 25),
                                                                                                                    child: SvgPicture.asset(
                                                                                                                      "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                                                      colorFilter: ColorFilter.mode(
                                                                                                                          isDarkTheme.value
                                                                                                                              ? const Color(
                                                                                                                                  0XFFD6D6D6)
                                                                                                                              : const Color(
                                                                                                                                  0XFF0EA102),
                                                                                                                          BlendMode.srcIn),
                                                                                                                    )),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    widgetsMain.translationWidget(
                                                                                                        translationList: featureTranslationList,
                                                                                                        id: featureIdList[index],
                                                                                                        type: 'feature',
                                                                                                        index: index,
                                                                                                        initFunction: getFeatureData,
                                                                                                        context: context,
                                                                                                        modelSetState: setState,
                                                                                                        notUse: false,
                                                                                                        titleList: featureTitlesList)
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : SizedBox(
                                                                                                width: width / 1.6,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      height: height / 45.11,
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    bool response1 =
                                                                                                                        await likeFunction(
                                                                                                                            id: featureIdList[index],
                                                                                                                            type: "feature");
                                                                                                                    if (response1) {
                                                                                                                      logEventFunc(
                                                                                                                          name: "Likes",
                                                                                                                          type: "Feature");
                                                                                                                      setState(() {
                                                                                                                        if (featureUseList[index] ==
                                                                                                                            true) {
                                                                                                                          if (featureDisuseList[
                                                                                                                                  index] ==
                                                                                                                              true) {
                                                                                                                          } else {
                                                                                                                            featureLikeList[index] -=
                                                                                                                                1;
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          if (featureDisuseList[
                                                                                                                                  index] ==
                                                                                                                              true) {
                                                                                                                            featureDislikeList[
                                                                                                                                index] -= 1;
                                                                                                                            featureLikeList[index] +=
                                                                                                                                1;
                                                                                                                          } else {
                                                                                                                            featureLikeList[index] +=
                                                                                                                                1;
                                                                                                                          }
                                                                                                                        }
                                                                                                                        featureUseList[index] =
                                                                                                                            !featureUseList[index];
                                                                                                                        featureDisuseList[index] =
                                                                                                                            false;
                                                                                                                      });
                                                                                                                    } else {}
                                                                                                                  },
                                                                                                            child: Container(
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              child: featureUseList[index]
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
                                                                                                              logEventFunc(
                                                                                                                  name: "Share", type: "Feature");
                                                                                                              newLink = await getLinK(
                                                                                                                  id: featureIdList[index],
                                                                                                                  type: "feature",
                                                                                                                  description: '',
                                                                                                                  imageUrl:
                                                                                                                      "" /*featureImagesList[index]*/,
                                                                                                                  title: featureTitlesList[index],
                                                                                                                  text: selectedValue);
                                                                                                              ShareResult result =
                                                                                                                  await Share.share(
                                                                                                                "Look what I was able to find on Tradewatch: ${featureTitlesList[index]} ${newLink.toString()}",
                                                                                                              );
                                                                                                              if (result.status ==
                                                                                                                  ShareResultStatus.success) {
                                                                                                                await shareFunction(
                                                                                                                    id: featureIdList[index],
                                                                                                                    type: "feature");
                                                                                                              }
                                                                                                            },
                                                                                                            child: Container(
                                                                                                                height: height / 40.6,
                                                                                                                width: width / 18.75,
                                                                                                                margin: EdgeInsets.only(
                                                                                                                    right: width / 25),
                                                                                                                child: SvgPicture.asset(
                                                                                                                  isDarkTheme.value
                                                                                                                      ? "assets/home_screen/share_dark.svg"
                                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                                                )),
                                                                                                          ),
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    bool response3 =
                                                                                                                        await disLikeFunction(
                                                                                                                            id: featureIdList[index],
                                                                                                                            type: "feature");
                                                                                                                    if (response3) {
                                                                                                                      logEventFunc(
                                                                                                                          name: "Dislikes",
                                                                                                                          type: "Feature");
                                                                                                                      setState(() {
                                                                                                                        if (featureDisuseList[
                                                                                                                                index] ==
                                                                                                                            true) {
                                                                                                                          if (featureUseList[index] ==
                                                                                                                              true) {
                                                                                                                          } else {
                                                                                                                            featureDislikeList[
                                                                                                                                index] -= 1;
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          if (featureUseList[index] ==
                                                                                                                              true) {
                                                                                                                            featureLikeList[index] -=
                                                                                                                                1;
                                                                                                                            featureDislikeList[
                                                                                                                                index] += 1;
                                                                                                                          } else {
                                                                                                                            featureDislikeList[
                                                                                                                                index] += 1;
                                                                                                                          }
                                                                                                                        }
                                                                                                                        featureDisuseList[index] =
                                                                                                                            !featureDisuseList[index];
                                                                                                                        featureUseList[index] = false;
                                                                                                                      });
                                                                                                                    } else {}
                                                                                                                  },
                                                                                                            child: Container(
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: featureDisuseList[index]
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
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: SvgPicture.asset(
                                                                                                                "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                                                colorFilter: ColorFilter.mode(
                                                                                                                    isDarkTheme.value
                                                                                                                        ? const Color(0XFFD6D6D6)
                                                                                                                        : const Color(0XFF0EA102),
                                                                                                                    BlendMode.srcIn),
                                                                                                              )),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    widgetsMain.translationWidget(
                                                                                                        translationList: featureTranslationList,
                                                                                                        id: featureIdList[index],
                                                                                                        type: 'feature',
                                                                                                        index: index,
                                                                                                        initFunction: getFeatureData,
                                                                                                        context: context,
                                                                                                        modelSetState: setState,
                                                                                                        notUse: false,
                                                                                                        titleList: featureTitlesList)
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                        SizedBox(
                                                                                          height: height / 81.2,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: height / 54.13,
                                                                                          child: Row(
                                                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              featureStatusList[index] == 4
                                                                                                  ? Shimmer.fromColors(
                                                                                                      baseColor: Colors.blue,
                                                                                                      highlightColor:
                                                                                                          Theme.of(context).colorScheme.background,
                                                                                                      direction: ShimmerDirection.ltr,
                                                                                                      child: Wrap(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                              featureCategoryList[index] == "general"
                                                                                                                  ? "General"
                                                                                                                  : featureCategoryList[index] ==
                                                                                                                          "stocks"
                                                                                                                      ? "Stocks"
                                                                                                                      : featureCategoryList[index] ==
                                                                                                                              "crypto"
                                                                                                                          ? "Crypto"
                                                                                                                          : featureCategoryList[
                                                                                                                                      index] ==
                                                                                                                                  "commodity"
                                                                                                                              ? "Commodity"
                                                                                                                              : featureCategoryList[
                                                                                                                                          index] ==
                                                                                                                                      "forex"
                                                                                                                                  ? "Forex"
                                                                                                                                  : "",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w700,
                                                                                                                  color: Colors.blue)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  : Text(
                                                                                                      featureCategoryList[index] == "general"
                                                                                                          ? "General"
                                                                                                          : featureCategoryList[index] == "stocks"
                                                                                                              ? "Stocks"
                                                                                                              : featureCategoryList[index] == "crypto"
                                                                                                                  ? "Crypto"
                                                                                                                  : featureCategoryList[index] ==
                                                                                                                          "commodity"
                                                                                                                      ? "Commodity"
                                                                                                                      : featureCategoryList[index] ==
                                                                                                                              "forex"
                                                                                                                          ? "Forex"
                                                                                                                          : "",
                                                                                                      style: TextStyle(
                                                                                                          fontSize: text.scale(10),
                                                                                                          fontWeight: FontWeight.w700,
                                                                                                          color: Colors.blue)),
                                                                                              SizedBox(width: width / 45),
                                                                                              featureStatusList[index] == 4
                                                                                                  ? Shimmer.fromColors(
                                                                                                      baseColor:
                                                                                                          Theme.of(context).colorScheme.onPrimary,
                                                                                                      highlightColor:
                                                                                                          Theme.of(context).colorScheme.background,
                                                                                                      direction: ShimmerDirection.ltr,
                                                                                                      child: Wrap(
                                                                                                        children: [
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    setState(() {
                                                                                                                      kUserSearchController.clear();
                                                                                                                      onTapType = "liked";
                                                                                                                      onTapId = featureIdList[index];
                                                                                                                      onLike = true;
                                                                                                                      onDislike = false;
                                                                                                                      idKeyMain = "feature_id";
                                                                                                                      apiMain = baseurl +
                                                                                                                          versionFeature +
                                                                                                                          likeDislikeUsers;
                                                                                                                      onTapIdMain =
                                                                                                                          featureIdList[index];
                                                                                                                      onTapTypeMain = "liked";
                                                                                                                      haveLikesMain =
                                                                                                                          featureLikeList[index] > 0
                                                                                                                              ? true
                                                                                                                              : false;
                                                                                                                      haveDisLikesMain =
                                                                                                                          featureDislikeList[index] >
                                                                                                                                  0
                                                                                                                              ? true
                                                                                                                              : false;
                                                                                                                      likesCountMain =
                                                                                                                          featureLikeList[index];
                                                                                                                      dislikesCountMain =
                                                                                                                          featureDislikeList[index];
                                                                                                                      kToken = mainUserToken;
                                                                                                                      loaderMain = false;
                                                                                                                    });
                                                                                                                    await customShowSheetNew3(
                                                                                                                      context: context,
                                                                                                                      responseCheck: 'feature',
                                                                                                                    );
                                                                                                                  },
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                    featureLikeList[index].toString(),
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: text.scale(10),
                                                                                                                        fontWeight: FontWeight.w700)),
                                                                                                                Text(" Likes",
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: text.scale(10),
                                                                                                                        fontWeight: FontWeight.w500)),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  : GestureDetector(
                                                                                                      onTap: mainSkipValue
                                                                                                          ? () {
                                                                                                              commonFlushBar(
                                                                                                                  context: context,
                                                                                                                  initFunction: initState);
                                                                                                            }
                                                                                                          : () async {
                                                                                                              setState(() {
                                                                                                                kUserSearchController.clear();
                                                                                                                onTapType = "liked";
                                                                                                                onTapId = featureIdList[index];
                                                                                                                onLike = true;
                                                                                                                onDislike = false;
                                                                                                                idKeyMain = "feature_id";
                                                                                                                apiMain = baseurl +
                                                                                                                    versionFeature +
                                                                                                                    likeDislikeUsers;
                                                                                                                onTapIdMain = featureIdList[index];
                                                                                                                onTapTypeMain = "liked";
                                                                                                                haveLikesMain =
                                                                                                                    featureLikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                haveDisLikesMain =
                                                                                                                    featureDislikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                likesCountMain =
                                                                                                                    featureLikeList[index];
                                                                                                                dislikesCountMain =
                                                                                                                    featureDislikeList[index];
                                                                                                                kToken = mainUserToken;
                                                                                                                loaderMain = false;
                                                                                                              });
                                                                                                              await customShowSheetNew3(
                                                                                                                context: context,
                                                                                                                responseCheck: 'feature',
                                                                                                              );
                                                                                                            },
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(featureLikeList[index].toString(),
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w700)),
                                                                                                          Text(" Likes",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w500)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                              SizedBox(width: width / 45),
                                                                                              featureStatusList[index] == 4
                                                                                                  ? Shimmer.fromColors(
                                                                                                      baseColor:
                                                                                                          Theme.of(context).colorScheme.onPrimary,
                                                                                                      highlightColor:
                                                                                                          Theme.of(context).colorScheme.background,
                                                                                                      direction: ShimmerDirection.ltr,
                                                                                                      child: Wrap(
                                                                                                        children: [
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    setState(() {
                                                                                                                      kUserSearchController.clear();
                                                                                                                      onTapType = "disliked";
                                                                                                                      onTapId = featureIdList[index];
                                                                                                                      onLike = false;
                                                                                                                      onDislike = true;
                                                                                                                      idKeyMain = "feature_id";
                                                                                                                      apiMain = baseurl +
                                                                                                                          versionFeature +
                                                                                                                          likeDislikeUsers;
                                                                                                                      onTapIdMain =
                                                                                                                          featureIdList[index];
                                                                                                                      onTapTypeMain = "disliked";
                                                                                                                      haveLikesMain =
                                                                                                                          featureLikeList[index] > 0
                                                                                                                              ? true
                                                                                                                              : false;
                                                                                                                      haveDisLikesMain =
                                                                                                                          featureDislikeList[index] >
                                                                                                                                  0
                                                                                                                              ? true
                                                                                                                              : false;
                                                                                                                      likesCountMain =
                                                                                                                          featureLikeList[index];
                                                                                                                      dislikesCountMain =
                                                                                                                          featureDislikeList[index];
                                                                                                                      kToken = mainUserToken;
                                                                                                                      loaderMain = false;
                                                                                                                    });
                                                                                                                    await customShowSheetNew3(
                                                                                                                      context: context,
                                                                                                                      responseCheck: 'feature',
                                                                                                                    );
                                                                                                                  },
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                    featureDislikeList[index]
                                                                                                                        .toString(),
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: text.scale(10),
                                                                                                                        fontWeight: FontWeight.w700)),
                                                                                                                Text(" DisLikes",
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: text.scale(10),
                                                                                                                        fontWeight: FontWeight.w500)),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  : GestureDetector(
                                                                                                      onTap: mainSkipValue
                                                                                                          ? () {
                                                                                                              commonFlushBar(
                                                                                                                  context: context,
                                                                                                                  initFunction: initState);
                                                                                                            }
                                                                                                          : () async {
                                                                                                              setState(() {
                                                                                                                kUserSearchController.clear();
                                                                                                                onTapType = "disliked";
                                                                                                                onTapId = featureIdList[index];
                                                                                                                onLike = false;
                                                                                                                onDislike = true;
                                                                                                                idKeyMain = "feature_id";
                                                                                                                apiMain = baseurl +
                                                                                                                    versionFeature +
                                                                                                                    likeDislikeUsers;
                                                                                                                onTapIdMain = featureIdList[index];
                                                                                                                onTapTypeMain = "disliked";
                                                                                                                haveLikesMain =
                                                                                                                    featureLikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                haveDisLikesMain =
                                                                                                                    featureDislikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                likesCountMain =
                                                                                                                    featureLikeList[index];
                                                                                                                dislikesCountMain =
                                                                                                                    featureDislikeList[index];
                                                                                                                kToken = mainUserToken;
                                                                                                                loaderMain = false;
                                                                                                              });
                                                                                                              await customShowSheetNew3(
                                                                                                                context: context,
                                                                                                                responseCheck: 'feature',
                                                                                                              );
                                                                                                            },
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(featureDislikeList[index].toString(),
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w700)),
                                                                                                          Text(" DisLikes",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w500)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                              SizedBox(width: width / 45),
                                                                                              featureStatusList[index] == 4
                                                                                                  ? Shimmer.fromColors(
                                                                                                      baseColor:
                                                                                                          Theme.of(context).colorScheme.onPrimary,
                                                                                                      highlightColor:
                                                                                                          Theme.of(context).colorScheme.background,
                                                                                                      direction: ShimmerDirection.ltr,
                                                                                                      child: Wrap(
                                                                                                        children: [
                                                                                                          Text(featureResponseList[index].toString(),
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w700))
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  : Text(featureResponseList[index].toString(),
                                                                                                      style: TextStyle(
                                                                                                          fontSize: text.scale(10),
                                                                                                          fontWeight: FontWeight.w700)),
                                                                                              featureStatusList[index] == 4
                                                                                                  ? Shimmer.fromColors(
                                                                                                      baseColor:
                                                                                                          Theme.of(context).colorScheme.onPrimary,
                                                                                                      highlightColor:
                                                                                                          Theme.of(context).colorScheme.background,
                                                                                                      direction: ShimmerDirection.ltr,
                                                                                                      child: Wrap(
                                                                                                        children: [
                                                                                                          Text(" Response",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w500))
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  : Text(" Response",
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
                                                                      )))
                                                            ],
                                                          );
                                                        }
                                                        return GestureDetector(
                                                            onTap: featureStatusList[index] == 4
                                                                ? () {
                                                                    getCompletedPopUp(
                                                                        releaseDate: featureReleasedDate[index],
                                                                        androidVersion: featureAndroidVersion[index],
                                                                        iosVersion: featureIosVersion[index]);
                                                                  }
                                                                : mainSkipValue
                                                                    ? () {
                                                                        commonFlushBar(context: context, initFunction: initState);
                                                                      }
                                                                    : () async {
                                                                        bool refresh = await Navigator.push(context,
                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                          return FeaturePostDescriptionPage(
                                                                            sortValue: selectedValue,
                                                                            featureId: featureIdList[index],
                                                                            featureDetail: featureObjectList[index],
                                                                            navBool: 'feature',
                                                                            idList: featureIdList,
                                                                          );
                                                                        }));
                                                                        if (refresh) {
                                                                          initState();
                                                                        }
                                                                      },
                                                            child: Container(
                                                                margin: EdgeInsets.only(bottom: height / 35, top: 3, right: 3, left: 3),
                                                                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                    color: featureStatusList[index] == 4
                                                                        ? isDarkTheme.value
                                                                            ? Theme.of(context).colorScheme.tertiary
                                                                            : Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                                                        : Theme.of(context).colorScheme.background /*Colors.white*/,
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
                                                                      color: featureStatusList[index] == 4
                                                                          ? isDarkTheme.value
                                                                              ? Theme.of(context).colorScheme.tertiary
                                                                              : Colors.transparent
                                                                          : Theme.of(context).colorScheme.background,
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
                                                                                  if (mainSkipValue) {
                                                                                    commonFlushBar(context: context, initFunction: initState);
                                                                                  } else {
                                                                                    Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return UserBillBoardProfilePage(
                                                                                          userId: featureUserIdList[
                                                                                              index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                    }));
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  height: height / 13.53,
                                                                                  width: width / 5.95,
                                                                                  margin: EdgeInsets.fromLTRB(
                                                                                      width / 23.43, height / 203, width / 37.5, height / 27.06),
                                                                                  decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      color: Colors.grey,
                                                                                      image: DecorationImage(
                                                                                          image: NetworkImage(featureImagesList[index]),
                                                                                          fit: BoxFit.fill)),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  featureStatusList[index] == 4
                                                                                      ? Shimmer.fromColors(
                                                                                          baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                          highlightColor: Theme.of(context).colorScheme.background,
                                                                                          direction: ShimmerDirection.ltr,
                                                                                          child: Wrap(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                width: width / 1.6,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                        width: width / 1.8,
                                                                                                        child: Text(
                                                                                                          featureTitlesList[index],
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(14),
                                                                                                              fontWeight: FontWeight.w600),
                                                                                                        )),
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        if (mainSkipValue) {
                                                                                                          commonFlushBar(
                                                                                                              context: context,
                                                                                                              initFunction: initState);
                                                                                                        } else {
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
                                                                                                                    child: featureMyList[index]
                                                                                                                        ? ListTile(
                                                                                                                            onTap: mainSkipValue
                                                                                                                                ? () {
                                                                                                                                    commonFlushBar(
                                                                                                                                        context:
                                                                                                                                            context,
                                                                                                                                        initFunction:
                                                                                                                                            initState);
                                                                                                                                  }
                                                                                                                                : () {
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);
                                                                                                                                    showDialog(
                                                                                                                                        barrierDismissible:
                                                                                                                                            false,
                                                                                                                                        context:
                                                                                                                                            context,
                                                                                                                                        builder:
                                                                                                                                            (BuildContext
                                                                                                                                                context) {
                                                                                                                                          return Dialog(
                                                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                                                borderRadius:
                                                                                                                                                    BorderRadius.circular(20.0)),
                                                                                                                                            //this right here
                                                                                                                                            child:
                                                                                                                                                Container(
                                                                                                                                              height:
                                                                                                                                                  height /
                                                                                                                                                      6,
                                                                                                                                              margin: EdgeInsets.symmetric(
                                                                                                                                                  vertical: height /
                                                                                                                                                      54.13,
                                                                                                                                                  horizontal:
                                                                                                                                                      width / 25),
                                                                                                                                              child:
                                                                                                                                                  Column(
                                                                                                                                                mainAxisAlignment:
                                                                                                                                                    MainAxisAlignment.center,
                                                                                                                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                                children: [
                                                                                                                                                  const Center(child: Text("Delete Request", style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Poppins"))),
                                                                                                                                                  const Divider(),
                                                                                                                                                  const Center(child: Text("Are you sure to Delete this Request")),
                                                                                                                                                  const Spacer(),
                                                                                                                                                  Padding(
                                                                                                                                                    padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                                                                                                                    child: Row(
                                                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                                      children: [
                                                                                                                                                        TextButton(
                                                                                                                                                          onPressed: () {
                                                                                                                                                            if (!mounted) {
                                                                                                                                                              return;
                                                                                                                                                            }
                                                                                                                                                            Navigator.pop(context);
                                                                                                                                                          },
                                                                                                                                                          child: const Text(
                                                                                                                                                            "Cancel",
                                                                                                                                                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                                                                                                                          ),
                                                                                                                                                        ),
                                                                                                                                                        ElevatedButton(
                                                                                                                                                          style: ElevatedButton.styleFrom(
                                                                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                                                                                                            ),
                                                                                                                                                            backgroundColor: Colors.green,
                                                                                                                                                          ),
                                                                                                                                                          onPressed: () async {
                                                                                                                                                            deletePost(featureId: featureIdList[index]);
                                                                                                                                                            if (!mounted) {
                                                                                                                                                              return;
                                                                                                                                                            }
                                                                                                                                                            Navigator.pop(context);
                                                                                                                                                          },
                                                                                                                                                          child: const Text(
                                                                                                                                                            "Continue",
                                                                                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
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
                                                                                                                            minLeadingWidth:
                                                                                                                                width / 25,
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
                                                                                                                          )
                                                                                                                        : Column(
                                                                                                                            mainAxisAlignment:
                                                                                                                                MainAxisAlignment
                                                                                                                                    .start,
                                                                                                                            crossAxisAlignment:
                                                                                                                                CrossAxisAlignment
                                                                                                                                    .start,
                                                                                                                            children: [
                                                                                                                              ListTile(
                                                                                                                                onTap: mainSkipValue
                                                                                                                                    ? () {
                                                                                                                                        commonFlushBar(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            initFunction:
                                                                                                                                                initState);
                                                                                                                                      }
                                                                                                                                    : () {
                                                                                                                                        Navigator.pop(
                                                                                                                                            context);
                                                                                                                                        _controller
                                                                                                                                            .clear();
                                                                                                                                        setState(() {
                                                                                                                                          actionValue =
                                                                                                                                              "Report";
                                                                                                                                        });
                                                                                                                                        showAlertDialog(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            featureId:
                                                                                                                                                featureIdList[
                                                                                                                                                    index],
                                                                                                                                            featureUserId:
                                                                                                                                                featureUserIdList[
                                                                                                                                                    index]);
                                                                                                                                      },
                                                                                                                                minLeadingWidth:
                                                                                                                                    width / 25,
                                                                                                                                leading: const Icon(
                                                                                                                                  Icons.shield,
                                                                                                                                  size: 20,
                                                                                                                                ),
                                                                                                                                title: Text(
                                                                                                                                  "Report Post",
                                                                                                                                  style: TextStyle(
                                                                                                                                      fontWeight:
                                                                                                                                          FontWeight
                                                                                                                                              .w500,
                                                                                                                                      fontSize: text
                                                                                                                                          .scale(14)),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              const Divider(
                                                                                                                                thickness: 0.0,
                                                                                                                                height: 0.0,
                                                                                                                              ),
                                                                                                                              ListTile(
                                                                                                                                onTap: mainSkipValue
                                                                                                                                    ? () {
                                                                                                                                        commonFlushBar(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            initFunction:
                                                                                                                                                initState);
                                                                                                                                      }
                                                                                                                                    : () {
                                                                                                                                        _controller
                                                                                                                                            .clear();
                                                                                                                                        setState(() {
                                                                                                                                          actionValue =
                                                                                                                                              "Block";
                                                                                                                                        });
                                                                                                                                        Navigator.pop(
                                                                                                                                            context);
                                                                                                                                        showAlertDialog(
                                                                                                                                            context:
                                                                                                                                                context,
                                                                                                                                            featureId:
                                                                                                                                                featureIdList[
                                                                                                                                                    index],
                                                                                                                                            featureUserId:
                                                                                                                                                featureUserIdList[
                                                                                                                                                    index]);
                                                                                                                                      },
                                                                                                                                minLeadingWidth:
                                                                                                                                    width / 25,
                                                                                                                                leading: const Icon(
                                                                                                                                  Icons.flag,
                                                                                                                                  size: 20,
                                                                                                                                ),
                                                                                                                                title: Text(
                                                                                                                                  "Block Post",
                                                                                                                                  style: TextStyle(
                                                                                                                                      fontWeight:
                                                                                                                                          FontWeight
                                                                                                                                              .w500,
                                                                                                                                      fontSize: text
                                                                                                                                          .scale(14)),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              });
                                                                                                        }
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        padding: EdgeInsets.only(right: width / 50),
                                                                                                        child: const Icon(
                                                                                                          Icons.more_horiz,
                                                                                                          size: 20,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox(
                                                                                          width: width / 1.6,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                  width: width / 1.8,
                                                                                                  child: Text(
                                                                                                    featureTitlesList[index],
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(14),
                                                                                                        fontWeight: FontWeight.w600),
                                                                                                  )),
                                                                                              GestureDetector(
                                                                                                onTap: () {
                                                                                                  if (mainSkipValue) {
                                                                                                    commonFlushBar(
                                                                                                        context: context, initFunction: initState);
                                                                                                  } else {
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
                                                                                                              child: featureMyList[index]
                                                                                                                  ? ListTile(
                                                                                                                      onTap: mainSkipValue
                                                                                                                          ? () {
                                                                                                                              commonFlushBar(
                                                                                                                                  context: context,
                                                                                                                                  initFunction:
                                                                                                                                      initState);
                                                                                                                            }
                                                                                                                          : () {
                                                                                                                              if (!mounted) {
                                                                                                                                return;
                                                                                                                              }
                                                                                                                              Navigator.pop(context);
                                                                                                                              showDialog(
                                                                                                                                  barrierDismissible:
                                                                                                                                      false,
                                                                                                                                  context: context,
                                                                                                                                  builder:
                                                                                                                                      (BuildContext
                                                                                                                                          context) {
                                                                                                                                    return Dialog(
                                                                                                                                      shape: RoundedRectangleBorder(
                                                                                                                                          borderRadius:
                                                                                                                                              BorderRadius.circular(
                                                                                                                                                  20.0)),
                                                                                                                                      //this right here
                                                                                                                                      child:
                                                                                                                                          Container(
                                                                                                                                        height:
                                                                                                                                            height /
                                                                                                                                                6,
                                                                                                                                        margin: EdgeInsets.symmetric(
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
                                                                                                                                                    "Delete Request",
                                                                                                                                                    style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Poppins"))),
                                                                                                                                            const Divider(),
                                                                                                                                            const Center(
                                                                                                                                                child:
                                                                                                                                                    Text("Are you sure to Delete this Request")),
                                                                                                                                            const Spacer(),
                                                                                                                                            Padding(
                                                                                                                                              padding:
                                                                                                                                                  EdgeInsets.symmetric(horizontal: width / 25),
                                                                                                                                              child:
                                                                                                                                                  Row(
                                                                                                                                                mainAxisAlignment:
                                                                                                                                                    MainAxisAlignment.spaceBetween,
                                                                                                                                                children: [
                                                                                                                                                  TextButton(
                                                                                                                                                    onPressed: () {
                                                                                                                                                      if (!mounted) {
                                                                                                                                                        return;
                                                                                                                                                      }
                                                                                                                                                      Navigator.pop(context);
                                                                                                                                                    },
                                                                                                                                                    child: const Text(
                                                                                                                                                      "Cancel",
                                                                                                                                                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                                                                                                                    ),
                                                                                                                                                  ),
                                                                                                                                                  ElevatedButton(
                                                                                                                                                    style: ElevatedButton.styleFrom(
                                                                                                                                                      shape: RoundedRectangleBorder(
                                                                                                                                                        borderRadius: BorderRadius.circular(18.0),
                                                                                                                                                      ),
                                                                                                                                                      backgroundColor: Colors.green,
                                                                                                                                                    ),
                                                                                                                                                    onPressed: () async {
                                                                                                                                                      deletePost(featureId: featureIdList[index]);
                                                                                                                                                      if (!mounted) {
                                                                                                                                                        return;
                                                                                                                                                      }
                                                                                                                                                      Navigator.pop(context);
                                                                                                                                                    },
                                                                                                                                                    child: const Text(
                                                                                                                                                      "Continue",
                                                                                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
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
                                                                                                                            fontSize: text.scale(14)),
                                                                                                                      ),
                                                                                                                    )
                                                                                                                  : Column(
                                                                                                                      mainAxisAlignment:
                                                                                                                          MainAxisAlignment.start,
                                                                                                                      crossAxisAlignment:
                                                                                                                          CrossAxisAlignment.start,
                                                                                                                      children: [
                                                                                                                        ListTile(
                                                                                                                          onTap: mainSkipValue
                                                                                                                              ? () {
                                                                                                                                  commonFlushBar(
                                                                                                                                      context:
                                                                                                                                          context,
                                                                                                                                      initFunction:
                                                                                                                                          initState);
                                                                                                                                }
                                                                                                                              : () {
                                                                                                                                  Navigator.pop(
                                                                                                                                      context);
                                                                                                                                  _controller.clear();
                                                                                                                                  setState(() {
                                                                                                                                    actionValue =
                                                                                                                                        "Report";
                                                                                                                                  });
                                                                                                                                  showAlertDialog(
                                                                                                                                      context:
                                                                                                                                          context,
                                                                                                                                      featureId:
                                                                                                                                          featureIdList[
                                                                                                                                              index],
                                                                                                                                      featureUserId:
                                                                                                                                          featureUserIdList[
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
                                                                                                                        const Divider(
                                                                                                                          thickness: 0.0,
                                                                                                                          height: 0.0,
                                                                                                                        ),
                                                                                                                        ListTile(
                                                                                                                          onTap: mainSkipValue
                                                                                                                              ? () {
                                                                                                                                  commonFlushBar(
                                                                                                                                      context:
                                                                                                                                          context,
                                                                                                                                      initFunction:
                                                                                                                                          initState);
                                                                                                                                }
                                                                                                                              : () {
                                                                                                                                  _controller.clear();
                                                                                                                                  setState(() {
                                                                                                                                    actionValue =
                                                                                                                                        "Block";
                                                                                                                                  });
                                                                                                                                  Navigator.pop(
                                                                                                                                      context);
                                                                                                                                  showAlertDialog(
                                                                                                                                      context:
                                                                                                                                          context,
                                                                                                                                      featureId:
                                                                                                                                          featureIdList[
                                                                                                                                              index],
                                                                                                                                      featureUserId:
                                                                                                                                          featureUserIdList[
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
                                                                                                  }
                                                                                                },
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.only(right: width / 50),
                                                                                                  child: const Icon(
                                                                                                    Icons.more_horiz,
                                                                                                    size: 20,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                  featureStatusList[index] == 4
                                                                                      ? Shimmer.fromColors(
                                                                                          baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                          highlightColor: Theme.of(context).colorScheme.background,
                                                                                          direction: ShimmerDirection.ltr,
                                                                                          child: Wrap(
                                                                                            children: [
                                                                                              GestureDetector(
                                                                                                onTap: () {
                                                                                                  if (mainSkipValue) {
                                                                                                    commonFlushBar(
                                                                                                        context: context, initFunction: initState);
                                                                                                  } else {
                                                                                                    Navigator.push(context, MaterialPageRoute(
                                                                                                        builder: (BuildContext context) {
                                                                                                      return UserBillBoardProfilePage(
                                                                                                          userId: featureUserIdList[
                                                                                                              index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                                    }));
                                                                                                  }
                                                                                                },
                                                                                                child: SizedBox(
                                                                                                    height: height / 54.13,
                                                                                                    width: width / 1.8,
                                                                                                    child: Text(
                                                                                                      featureSourceNameList[index]
                                                                                                          .toString()
                                                                                                          .capitalizeFirst!,
                                                                                                      style: TextStyle(
                                                                                                          fontSize: text.scale(10),
                                                                                                          fontWeight: FontWeight.w500),
                                                                                                    )),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      : GestureDetector(
                                                                                          onTap: () {
                                                                                            if (mainSkipValue) {
                                                                                              commonFlushBar(
                                                                                                  context: context, initFunction: initState);
                                                                                            } else {
                                                                                              Navigator.push(context,
                                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                                return UserBillBoardProfilePage(
                                                                                                    userId: featureUserIdList[
                                                                                                        index]) /*UserProfilePage(id: featureUserIdList[index], type: 'feature', index: 2)*/;
                                                                                              }));
                                                                                            }
                                                                                          },
                                                                                          child: SizedBox(
                                                                                              height: height / 54.13,
                                                                                              width: width / 1.84,
                                                                                              child: Text(
                                                                                                featureSourceNameList[index]
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
                                                                                  featureStatusList[index] == 4
                                                                                      ? SizedBox(
                                                                                          width: width / 1.6,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.primary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      height: height / 45.11,
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    bool response1 =
                                                                                                                        await likeFunction(
                                                                                                                            id: featureIdList[index],
                                                                                                                            type: "feature");
                                                                                                                    if (response1) {
                                                                                                                      logEventFunc(
                                                                                                                          name: "Likes",
                                                                                                                          type: "Feature");
                                                                                                                      setState(() {
                                                                                                                        if (featureUseList[index] ==
                                                                                                                            true) {
                                                                                                                          if (featureDisuseList[
                                                                                                                                  index] ==
                                                                                                                              true) {
                                                                                                                          } else {
                                                                                                                            featureLikeList[index] -=
                                                                                                                                1;
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          if (featureDisuseList[
                                                                                                                                  index] ==
                                                                                                                              true) {
                                                                                                                            featureDislikeList[
                                                                                                                                index] -= 1;
                                                                                                                            featureLikeList[index] +=
                                                                                                                                1;
                                                                                                                          } else {
                                                                                                                            featureLikeList[index] +=
                                                                                                                                1;
                                                                                                                          }
                                                                                                                        }
                                                                                                                        featureUseList[index] =
                                                                                                                            !featureUseList[index];
                                                                                                                        featureDisuseList[index] =
                                                                                                                            false;
                                                                                                                      });
                                                                                                                    } else {}
                                                                                                                  },
                                                                                                            child: Container(
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              child: featureUseList[index]
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
                                                                                                              logEventFunc(
                                                                                                                  name: "Share", type: "Feature");
                                                                                                              newLink = await getLinK(
                                                                                                                  id: featureIdList[index],
                                                                                                                  type: "feature",
                                                                                                                  description: '',
                                                                                                                  imageUrl:
                                                                                                                      "" /*featureImagesList[index]*/,
                                                                                                                  title: featureTitlesList[index],
                                                                                                                  text: selectedValue);
                                                                                                              ShareResult result =
                                                                                                                  await Share.share(
                                                                                                                "Look what I was able to find on Tradewatch: ${featureTitlesList[index]} ${newLink.toString()}",
                                                                                                              );
                                                                                                              if (result.status ==
                                                                                                                  ShareResultStatus.success) {
                                                                                                                await shareFunction(
                                                                                                                    id: featureIdList[index],
                                                                                                                    type: "feature");
                                                                                                              }
                                                                                                            },
                                                                                                            child: Container(
                                                                                                                height: height / 40.6,
                                                                                                                width: width / 18.75,
                                                                                                                margin: EdgeInsets.only(
                                                                                                                    right: width / 25),
                                                                                                                child: SvgPicture.asset(
                                                                                                                  isDarkTheme.value
                                                                                                                      ? "assets/home_screen/share_dark.svg"
                                                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                                                )),
                                                                                                          ),
                                                                                                          GestureDetector(
                                                                                                            onTap: mainSkipValue
                                                                                                                ? () {
                                                                                                                    commonFlushBar(
                                                                                                                        context: context,
                                                                                                                        initFunction: initState);
                                                                                                                  }
                                                                                                                : () async {
                                                                                                                    bool response3 =
                                                                                                                        await disLikeFunction(
                                                                                                                            id: featureIdList[index],
                                                                                                                            type: "feature");
                                                                                                                    if (response3) {
                                                                                                                      logEventFunc(
                                                                                                                          name: "Dislikes",
                                                                                                                          type: "Feature");
                                                                                                                      setState(() {
                                                                                                                        if (featureDisuseList[
                                                                                                                                index] ==
                                                                                                                            true) {
                                                                                                                          if (featureUseList[index] ==
                                                                                                                              true) {
                                                                                                                          } else {
                                                                                                                            featureDislikeList[
                                                                                                                                index] -= 1;
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          if (featureUseList[index] ==
                                                                                                                              true) {
                                                                                                                            featureLikeList[index] -=
                                                                                                                                1;
                                                                                                                            featureDislikeList[
                                                                                                                                index] += 1;
                                                                                                                          } else {
                                                                                                                            featureDislikeList[
                                                                                                                                index] += 1;
                                                                                                                          }
                                                                                                                        }
                                                                                                                        featureDisuseList[index] =
                                                                                                                            !featureDisuseList[index];
                                                                                                                        featureUseList[index] = false;
                                                                                                                      });
                                                                                                                    } else {}
                                                                                                                  },
                                                                                                            child: Container(
                                                                                                              height: height / 40.6,
                                                                                                              width: width / 18.75,
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: featureDisuseList[index]
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
                                                                                                              margin:
                                                                                                                  EdgeInsets.only(right: width / 25),
                                                                                                              child: SvgPicture.asset(
                                                                                                                "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                                                colorFilter: ColorFilter.mode(
                                                                                                                    isDarkTheme.value
                                                                                                                        ? const Color(0XFFD6D6D6)
                                                                                                                        : const Color(0XFF0EA102),
                                                                                                                    BlendMode.srcIn),
                                                                                                              )),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              widgetsMain.translationWidget(
                                                                                                  translationList: featureTranslationList,
                                                                                                  id: featureIdList[index],
                                                                                                  type: 'feature',
                                                                                                  index: index,
                                                                                                  initFunction: getFeatureData,
                                                                                                  context: context,
                                                                                                  modelSetState: setState,
                                                                                                  notUse: false,
                                                                                                  titleList: featureTitlesList)
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox(
                                                                                          width: width / 1.6,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height / 45.11,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: mainSkipValue
                                                                                                          ? () {
                                                                                                              commonFlushBar(
                                                                                                                  context: context,
                                                                                                                  initFunction: initState);
                                                                                                            }
                                                                                                          : () async {
                                                                                                              bool response1 = await likeFunction(
                                                                                                                  id: featureIdList[index],
                                                                                                                  type: "feature");
                                                                                                              if (response1) {
                                                                                                                logEventFunc(
                                                                                                                    name: "Likes", type: "Feature");
                                                                                                                setState(() {
                                                                                                                  if (featureUseList[index] == true) {
                                                                                                                    if (featureDisuseList[index] ==
                                                                                                                        true) {
                                                                                                                    } else {
                                                                                                                      featureLikeList[index] -= 1;
                                                                                                                    }
                                                                                                                  } else {
                                                                                                                    if (featureDisuseList[index] ==
                                                                                                                        true) {
                                                                                                                      featureDislikeList[index] -= 1;
                                                                                                                      featureLikeList[index] += 1;
                                                                                                                    } else {
                                                                                                                      featureLikeList[index] += 1;
                                                                                                                    }
                                                                                                                  }
                                                                                                                  featureUseList[index] =
                                                                                                                      !featureUseList[index];
                                                                                                                  featureDisuseList[index] = false;
                                                                                                                });
                                                                                                              } else {}
                                                                                                            },
                                                                                                      child: Container(
                                                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                                                        height: height / 40.6,
                                                                                                        width: width / 18.75,
                                                                                                        child: featureUseList[index]
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
                                                                                                        logEventFunc(name: "Share", type: "Feature");
                                                                                                        newLink = await getLinK(
                                                                                                            id: featureIdList[index],
                                                                                                            type: "feature",
                                                                                                            description: '',
                                                                                                            imageUrl: "" /*featureImagesList[index]*/,
                                                                                                            title: featureTitlesList[index],
                                                                                                            text: selectedValue);
                                                                                                        ShareResult result =
                                                                                                            await Share.share(
                                                                                                          "Look what I was able to find on Tradewatch: ${featureTitlesList[index]} ${newLink.toString()}",
                                                                                                        );
                                                                                                        if (result.status ==
                                                                                                            ShareResultStatus.success) {
                                                                                                          await shareFunction(
                                                                                                              id: featureIdList[index],
                                                                                                              type: "feature");
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
                                                                                                      onTap: mainSkipValue
                                                                                                          ? () {
                                                                                                              commonFlushBar(
                                                                                                                  context: context,
                                                                                                                  initFunction: initState);
                                                                                                            }
                                                                                                          : () async {
                                                                                                              bool response3 = await disLikeFunction(
                                                                                                                  id: featureIdList[index],
                                                                                                                  type: "feature");
                                                                                                              if (response3) {
                                                                                                                logEventFunc(
                                                                                                                    name: "Dislikes",
                                                                                                                    type: "Feature");
                                                                                                                setState(() {
                                                                                                                  if (featureDisuseList[index] ==
                                                                                                                      true) {
                                                                                                                    if (featureUseList[index] ==
                                                                                                                        true) {
                                                                                                                    } else {
                                                                                                                      featureDislikeList[index] -= 1;
                                                                                                                    }
                                                                                                                  } else {
                                                                                                                    if (featureUseList[index] ==
                                                                                                                        true) {
                                                                                                                      featureLikeList[index] -= 1;
                                                                                                                      featureDislikeList[index] += 1;
                                                                                                                    } else {
                                                                                                                      featureDislikeList[index] += 1;
                                                                                                                    }
                                                                                                                  }
                                                                                                                  featureDisuseList[index] =
                                                                                                                      !featureDisuseList[index];
                                                                                                                  featureUseList[index] = false;
                                                                                                                });
                                                                                                              } else {}
                                                                                                            },
                                                                                                      child: Container(
                                                                                                        height: height / 40.6,
                                                                                                        width: width / 18.75,
                                                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                                                        child: featureDisuseList[index]
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
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              widgetsMain.translationWidget(
                                                                                                  translationList: featureTranslationList,
                                                                                                  id: featureIdList[index],
                                                                                                  type: 'feature',
                                                                                                  index: index,
                                                                                                  initFunction: getFeatureData,
                                                                                                  context: context,
                                                                                                  modelSetState: setState,
                                                                                                  notUse: false,
                                                                                                  titleList: featureTitlesList)
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                  SizedBox(
                                                                                    height: height / 81.2,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                    child: Row(
                                                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Colors.blue,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    Text(
                                                                                                        featureCategoryList[index] == "general"
                                                                                                            ? "General"
                                                                                                            : featureCategoryList[index] == "stocks"
                                                                                                                ? "Stocks"
                                                                                                                : featureCategoryList[index] ==
                                                                                                                        "crypto"
                                                                                                                    ? "Crypto"
                                                                                                                    : featureCategoryList[index] ==
                                                                                                                            "commodity"
                                                                                                                        ? "Commodity"
                                                                                                                        : featureCategoryList[
                                                                                                                                    index] ==
                                                                                                                                "forex"
                                                                                                                            ? "Forex"
                                                                                                                            : "",
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w700,
                                                                                                            color: Colors.blue)),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : Text(
                                                                                                featureCategoryList[index] == "general"
                                                                                                    ? "General"
                                                                                                    : featureCategoryList[index] == "stocks"
                                                                                                        ? "Stocks"
                                                                                                        : featureCategoryList[index] == "crypto"
                                                                                                            ? "Crypto"
                                                                                                            : featureCategoryList[index] ==
                                                                                                                    "commodity"
                                                                                                                ? "Commodity"
                                                                                                                : featureCategoryList[index] ==
                                                                                                                        "forex"
                                                                                                                    ? "Forex"
                                                                                                                    : "",
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.blue)),
                                                                                        SizedBox(width: width / 45),
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: mainSkipValue
                                                                                                          ? () {
                                                                                                              commonFlushBar(
                                                                                                                  context: context,
                                                                                                                  initFunction: initState);
                                                                                                            }
                                                                                                          : () async {
                                                                                                              setState(() {
                                                                                                                kUserSearchController.clear();
                                                                                                                onTapType = "liked";
                                                                                                                onTapId = featureIdList[index];
                                                                                                                onLike = true;
                                                                                                                onDislike = false;
                                                                                                                idKeyMain = "feature_id";
                                                                                                                apiMain = baseurl +
                                                                                                                    versionFeature +
                                                                                                                    likeDislikeUsers;
                                                                                                                onTapIdMain = featureIdList[index];
                                                                                                                onTapTypeMain = "liked";
                                                                                                                haveLikesMain =
                                                                                                                    featureLikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                haveDisLikesMain =
                                                                                                                    featureDislikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                likesCountMain =
                                                                                                                    featureLikeList[index];
                                                                                                                dislikesCountMain =
                                                                                                                    featureDislikeList[index];
                                                                                                                kToken = mainUserToken;
                                                                                                                loaderMain = false;
                                                                                                              });
                                                                                                              await customShowSheetNew3(
                                                                                                                context: context,
                                                                                                                responseCheck: 'feature',
                                                                                                              );
                                                                                                            },
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(featureLikeList[index].toString(),
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w700)),
                                                                                                          Text(" Likes",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w500)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : GestureDetector(
                                                                                                onTap: mainSkipValue
                                                                                                    ? () {
                                                                                                        commonFlushBar(
                                                                                                            context: context,
                                                                                                            initFunction: initState);
                                                                                                      }
                                                                                                    : () async {
                                                                                                        setState(() {
                                                                                                          kUserSearchController.clear();
                                                                                                          onTapType = "liked";
                                                                                                          onTapId = featureIdList[index];
                                                                                                          onLike = true;
                                                                                                          onDislike = false;
                                                                                                          idKeyMain = "feature_id";
                                                                                                          apiMain = baseurl +
                                                                                                              versionFeature +
                                                                                                              likeDislikeUsers;
                                                                                                          onTapIdMain = featureIdList[index];
                                                                                                          onTapTypeMain = "liked";
                                                                                                          haveLikesMain = featureLikeList[index] > 0
                                                                                                              ? true
                                                                                                              : false;
                                                                                                          haveDisLikesMain =
                                                                                                              featureDislikeList[index] > 0
                                                                                                                  ? true
                                                                                                                  : false;
                                                                                                          likesCountMain = featureLikeList[index];
                                                                                                          dislikesCountMain =
                                                                                                              featureDislikeList[index];
                                                                                                          kToken = mainUserToken;
                                                                                                          loaderMain = false;
                                                                                                        });
                                                                                                        await customShowSheetNew3(
                                                                                                          context: context,
                                                                                                          responseCheck: 'feature',
                                                                                                        );
                                                                                                      },
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Text(featureLikeList[index].toString(),
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w700)),
                                                                                                    Text(" Likes",
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w500)),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                        SizedBox(width: width / 45),
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: mainSkipValue
                                                                                                          ? () {
                                                                                                              commonFlushBar(
                                                                                                                  context: context,
                                                                                                                  initFunction: initState);
                                                                                                            }
                                                                                                          : () async {
                                                                                                              setState(() {
                                                                                                                kUserSearchController.clear();
                                                                                                                onTapType = "disliked";
                                                                                                                onTapId = featureIdList[index];
                                                                                                                onLike = false;
                                                                                                                onDislike = true;
                                                                                                                idKeyMain = "feature_id";
                                                                                                                apiMain = baseurl +
                                                                                                                    versionFeature +
                                                                                                                    likeDislikeUsers;
                                                                                                                onTapIdMain = featureIdList[index];
                                                                                                                onTapTypeMain = "disliked";
                                                                                                                haveLikesMain =
                                                                                                                    featureLikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                haveDisLikesMain =
                                                                                                                    featureDislikeList[index] > 0
                                                                                                                        ? true
                                                                                                                        : false;
                                                                                                                likesCountMain =
                                                                                                                    featureLikeList[index];
                                                                                                                dislikesCountMain =
                                                                                                                    featureDislikeList[index];
                                                                                                                kToken = mainUserToken;
                                                                                                                loaderMain = false;
                                                                                                              });
                                                                                                              await customShowSheetNew3(
                                                                                                                context: context,
                                                                                                                responseCheck: 'feature',
                                                                                                              );
                                                                                                            },
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(featureDislikeList[index].toString(),
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w700)),
                                                                                                          Text(" DisLikes",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(10),
                                                                                                                  fontWeight: FontWeight.w500)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : GestureDetector(
                                                                                                onTap: mainSkipValue
                                                                                                    ? () {
                                                                                                        commonFlushBar(
                                                                                                            context: context,
                                                                                                            initFunction: initState);
                                                                                                      }
                                                                                                    : () async {
                                                                                                        setState(() {
                                                                                                          kUserSearchController.clear();
                                                                                                          onTapType = "disliked";
                                                                                                          onTapId = featureIdList[index];
                                                                                                          onLike = false;
                                                                                                          onDislike = true;
                                                                                                          idKeyMain = "feature_id";
                                                                                                          apiMain = baseurl +
                                                                                                              versionFeature +
                                                                                                              likeDislikeUsers;
                                                                                                          onTapIdMain = featureIdList[index];
                                                                                                          onTapTypeMain = "disliked";
                                                                                                          haveLikesMain = featureLikeList[index] > 0
                                                                                                              ? true
                                                                                                              : false;
                                                                                                          haveDisLikesMain =
                                                                                                              featureDislikeList[index] > 0
                                                                                                                  ? true
                                                                                                                  : false;
                                                                                                          likesCountMain = featureLikeList[index];
                                                                                                          dislikesCountMain =
                                                                                                              featureDislikeList[index];
                                                                                                          kToken = mainUserToken;
                                                                                                          loaderMain = false;
                                                                                                        });
                                                                                                        await customShowSheetNew3(
                                                                                                          context: context,
                                                                                                          responseCheck: 'feature',
                                                                                                        );
                                                                                                      },
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Text(featureDislikeList[index].toString(),
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w700)),
                                                                                                    Text(" DisLikes",
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w500)),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                        SizedBox(width: width / 45),
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    Text(featureResponseList[index].toString(),
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w700))
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : Text(featureResponseList[index].toString(),
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700)),
                                                                                        featureStatusList[index] == 4
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Theme.of(context).colorScheme.onPrimary,
                                                                                                highlightColor:
                                                                                                    Theme.of(context).colorScheme.background,
                                                                                                direction: ShimmerDirection.ltr,
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    Text(" Response",
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w500))
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            : Text(" Response",
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
                                                                )));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog({required BuildContext context, required String featureId, required String featureUserId}) {
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
                    child: Text('Help us understand why?', style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600)),
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
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Feature');
                      reportPost(
                          action: actionValue, why: whyValue, description: _controller.text, featureId: featureId, featureUserId: featureUserId);
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

  showSheetNew({required bool lik}) {
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
                  itemCount: featureLikedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(
                                uId: featureLikedIdList[index], uType: 'feature', mainUserToken: mainUserToken, context: context, index: 2);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(featureLikedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            featureLikedSourceNameList[index].toString().capitalizeFirst!,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                          ),
                          trailing: Container(
                              margin: EdgeInsets.only(right: width / 25),
                              height: height / 40.6,
                              width: width / 18.75,
                              child: lik
                                  ? SvgPicture.asset(
                                      isDarkTheme.value
                                          ? "assets/home_screen/like_filled_dark.svg"
                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                    )
                                  : SvgPicture.asset(
                                      isDarkTheme.value
                                          ? "assets/home_screen/dislike_filled_dark.svg"
                                          : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                    )),
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

  getCompletedPopUp({required String releaseDate, required String androidVersion, required String iosVersion}) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
            height: height / 4.33,
            padding: EdgeInsets.symmetric(horizontal: width / 27.04, vertical: height / 57.73),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/Constants/Assets/SMLogos/applause.png",
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(width: width / 41.1),
                    Center(
                      child: Text(
                        ' Congratulations!',
                        style: TextStyle(color: Colors.green, fontSize: text.scale(18), fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 5,
                ),
                SizedBox(
                  height: height / 57.73,
                ),
                Center(
                  child: Text(
                    "This feature was prioritized and released on '$releaseDate'",
                    style: TextStyle(
                      fontSize: text.scale(14),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height / 86.6,
                ),
                Center(
                  child: Text(
                    "Version : ${Platform.isIOS ? iosVersion : androidVersion}",
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, /*${Platform.isIOS?iosVersion:androidVersion} */
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
