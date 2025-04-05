import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Edited_Packages/Carousel/carousel_slider.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/create_password_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_up_page.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/add_watch_list_page.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/watch_list.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/locker_skip_screen.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';
import 'package:tradewatchfinal/Screens/Module5/set_alert_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/Intermediary.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/main.dart';
import 'package:upgrader/upgrader.dart';
import 'package:web_socket_channel/io.dart';

import 'tape_ticker_model.dart';

class HomeScreen extends StatefulWidget {
  final bool isHomeFirstTime;
  final int newIndex;
  final int excIndex;
  final int countryIndex;
  final bool tType;

  const HomeScreen(
      {Key? key, required this.isHomeFirstTime, required this.tType, required this.countryIndex, required this.excIndex, required this.newIndex})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  String mainUserId = "";
  String mainUserToken = "";
  String avatar = "";
  int currentIndex = 0;
  String staticImage = "";
  String userName = "";
  List<int> newsViewList = [];
  List<String> newsImagesList = [];
  List<String> newsExchangeList = [];
  List<String> newsSentimentList = [];
  List<String> newsDescriptionList = [];
  List<String> newsSnippetList = [];
  List<bool> newsBookMarkList = [];
  List<String> newsSourceNameList = [];
  List<String> catNamesList = [
    "Stocks",
    "Crypto",
    "Commodity",
    "Forex",
  ];
  List<String> catNamesListSmall = [
    "stocks",
    "crypto",
    "commodity",
    "forex",
  ];
  List<String> catIdList = [];
  List<String> newsTitlesList = [];
  List<Widget> widgetList = [];
  List<String> timeList = [];
  List<String> newsLinkList = [];
  List<String> searchNewsTimeList = [];
  String categoryValue = "";
  TabController? _tabController;
  TabController? _tabController1;
  int newsInt = 0;
  int videosInt = 0;
  int forumInt = 0;
  int surveyInt = 0;
  late Uri newLink;
  List<String> searchNewsSourceNameList = [];
  List<String> newsIdList = [];
  List<int> newsLikeList = [];
  List<int> newsDislikeList = [];
  List<String> newsUserLikesList = [];
  List<String> newsUserDislikesList = [];
  List<bool> newsUseList = [];
  List<bool> newsUseDisList = [];
  List<String> searchVideosLinkList = [];
  List<String> searchVideosImagesList = [];
  List<String> searchVideosSourceNameList = [];
  List<String> searchVideosIdList = [];
  List<String> searchVideosTitlesList = [];
  List<String> searchVideosTimeList = [];
  List<String> newsLikedImagesList = [];
  List<String> newsLikedIdList = [];
  List<String> newsLikedSourceNameList = [];
  List<String> newsViewedImagesList = [];
  List<String> newsViewedIdList = [];
  List<String> newsViewedSourceNameList = [];
  bool loading = false;
  bool loading2 = false;
  bool likeBool = false;
  bool disLikeBool = false;
  bool trending = true;
  bool _toggle = true;
  bool showNoVideoDataFound = false;
  bool showNoDataFound = false;
  bool exitApp = false;
  String activeStatus = "";
  int answeredQuestion = 0;
  bool answerStatus = false;
  String time = '';
  Map<String, dynamic> responseData = {};
  Map<String, dynamic> responseData1 = {};
  String newId = "";
  List<dynamic> responseList = [];
  List<dynamic> responseDataNewList = [];
  Map<String, dynamic> response1 = {};
  String forumCategory = "";
  /* List<AssetImage> assetList = [
    AssetImage(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_stocks_dark.png"
        : "lib/Constants/Assets/NewAssets/HomeScreen/home_stocks.png"),
    AssetImage(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_crypto_dark.png"
        : "lib/Constants/Assets/NewAssets/HomeScreen/home_crypto.png"),
    AssetImage(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_commodity_dark.png"
        : "lib/Constants/Assets/NewAssets/HomeScreen/home_commodity.png"),
    AssetImage(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_forex.dark.png"
        : "lib/Constants/Assets/NewAssets/HomeScreen/home_forex.png"),
  ];
  */
  List<String> assetsList = [
    "lib/Constants/Assets/NewAssets/HomeScreen/home_stocks.png",
    "lib/Constants/Assets/NewAssets/HomeScreen/home_crypto.png",
    "lib/Constants/Assets/NewAssets/HomeScreen/home_commodity.png",
    "lib/Constants/Assets/NewAssets/HomeScreen/home_forex.png"
  ];
  List<String> darkAssetList = [
    "lib/Constants/Assets/NewAssets/HomeScreen/home_stocks_dark.png",
    "lib/Constants/Assets/NewAssets/HomeScreen/home_crypto_dark.png",
    "lib/Constants/Assets/NewAssets/HomeScreen/home_commodity_dark.png",
    "lib/Constants/Assets/NewAssets/HomeScreen/home_forex.dark.png",
  ];
  List<Tab> tabs1 = [
    const Tab(
      text: "News",
    ),
    const Tab(
      text: "Videos",
    ),
    const Tab(
      text: "Forum",
    ),
    const Tab(
      text: "Survey",
    ),
  ];
  List<String> mainExchangeIdList = [];
  late AnimationController _animationController;
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  List<Uri> uriList = [];
  List<Map<String, dynamic>> searchList = [];
  ScrollController scrollControl = ScrollController();
  bool carLoader = false;
  late TapeTickerModel tapeTickerResponse;
  final List<bool> tapeWatchList = [];
  List<String> tickerTapeExchange = [];
  List<bool> tradeWatchList = [];
  BannerAd? _bannerAd;
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getIdData({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          forumCategory = responseData["response"]["category"];
        });
      }
    }
  }

  getIdDataSearch({required String id, required String type, required String searchText}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    data = {"id": id, "type": type, "search_key": searchText};
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: data);
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          forumCategory = responseData["response"]["category"];
        });
      }
    }
  }

  getSelectedValue({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    finalisedCategory = value;
    var url = Uri.parse(baseurl + versionLocker + saveKey);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'locker': value.toLowerCase()});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      prefs.setString('finalisedCategory1', value.toLowerCase());
    }
  }

  statusFunc({required String surveyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionSurvey + surveyStatusCheck);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'survey_id': surveyId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      setState(() {
        activeStatus = responseData["response"]["status"];
      });
      if (activeStatus == "active") {
        var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
        var response = await http.post(url, headers: {
          'Authorization': mainUserToken
        }, body: {
          'survey_id': surveyId,
        });
        var responseData = json.decode(response.body);
        if (responseData["status"]) {
          answerStatus = responseData["response"][0]["final_question"];
          answeredQuestion = responseData["response"][0]["question_number"];
        } else {
          answerStatus = false;
          answeredQuestion = 0;
        }
      }
    }
  }

  getLiveStatus() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
    }
  }

/*  Future<bool> addWatchList(
      {required int categoryIndex,
      required String tickerId,
      required int exchangeIndex}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAdd;
    if (categoryIndex == 0) {
      data = {
        "category_id": mainCatIdList[categoryIndex],
        "exchange_id": finalExchangeIdList[exchangeIndex],
        "ticker_id": tickerId,
      };
    } else {
      data = {
        "category_id": mainCatIdList[categoryIndex],
        "ticker_id": tickerId,
      };
    }

    var response = await dioMain.post(url,
        options: Options(headers: {'Authorization': mainUserToken}),
        data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      Flushbar(
        message: responseData["message"],
        duration: Duration(seconds: 2),
      )..show(context);
    } else {
      Flushbar(
        message: responseData["message"],
        duration: Duration(seconds: 2),
      )..show(context);
    }
    return responseData["status"];
  }*/

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (mounted) {
      if (responseData["status"]) {
        Flushbar(
          message: responseData["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        Flushbar(
          message: responseData["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isIOS) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) => initPlugin());
    }
    // functionsMain.fireBaseCloudMessagingListeners();
    setState(() {
      _toggle = widget.tType;
    });
    streamController.stream.listen((event) {
      if (mounted) {
        setState(() {
          liveStatusActive = event;
        });
      }
    });
    getAllDataMain(name: mainSkipValue ? 'Skip_Screen' : 'Home_Screen');
    getAllData();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {});
      });
    _tabController = TabController(vsync: this, length: 4, initialIndex: 0);
    _tabController1 = TabController(vsync: this, length: 4, initialIndex: widget.newIndex);
    super.initState();
  }

  Future<void> initPlugin() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() {});
    if (status == TrackingStatus.notDetermined) {
      if (!mounted) {
        return;
      }
      await showCustomTrackingDialog(context);
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() {});
    }

    await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async => await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We might need to show ads in the future to keep this app free and manage our cost. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
            maxLines: 100,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink(context: navigatorKey.currentState!.context);
      cancelAllNotifications();
    }
  }

  _retrieveDynamicLink({required BuildContext context}) async {
    firebaseDynamic.onLink.listen((dynamicLinkData) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      mainSkipValue = prefs.getString('newUserToken') == null ? true : false;
      List<String> dynamics = [];
      dynamics = dynamicLinkData.link.pathSegments;
      if (!mounted) {
        return;
      }
      if (!mainSkipValue) {
        if (dynamics[0] == "DemoPage") {
          /* Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return DemoPage(
              image: '',
              text: '',
              id: dynamics[1],
              url: '',
              type: dynamics[2],
              activity: false,
              checkMain: true,
            );
          }));*/
          Get.to(const DemoView(), arguments: {"id": dynamics[1], "type": dynamics[2], "url": ""});
        } else if (dynamics[0] == "VideoDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return YoutubePlayerLandscapeScreen(
              id: dynamics[1],
              comeFrom: 'main',
            );
          }));
        } else if (dynamics[0] == "ForumPostDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPostDescriptionPage(
              forumId: dynamics[1],
              comeFrom: 'main',
              idList: const [],
            );
          }));
        } else if (dynamics[0] == "FeaturePostDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return FeaturePostDescriptionPage(
              navBool: 'main',
              sortValue: dynamics[3],
              featureId: dynamics[1],
              featureDetail: const {},
              idList: const [],
            );
          }));
        } else if (dynamics[0] == "AnalyticsPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return AnalyticsPage(
              surveyTitle: dynamics[3],
              activity: true,
              surveyId: dynamics[1],
            );
          }));
        } else if (dynamics[0] == "HomeScreen") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(tType: true, text: "", caseNo1: 0, newIndex: 0, excIndex: 1, countryIndex: 0, isHomeFirstTym: true);
          }));
        } else if (dynamics[0] == "LockerPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
              tType: true,
              text: dynamics[1],
              caseNo1: 1,
              newIndex: 0,
              excIndex: 1,
              countryIndex: 0,
              fromLink: true,
              isHomeFirstTym: false,
            );
          }));
        } else if (dynamics[0] == "FeatureRequestPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const FeatureRequestPage(
              fromWhere: "link",
            );
          }));
        } else if (dynamics[0] == "StocksAddFilterPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const StocksAddFilterPage(
              text: 'Stocks',
              page: 'locker',
            );
          }));
        } else if (dynamics[0] == "NewsMainPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return NewsMainPage(
              tickerId: '',
              tickerName: '',
              text: dynamics[1],
              fromCompare: false,
            );
          }));
        } else if (dynamics[0] == "VideosMainPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return VideosMainPage(
              tickerId: '',
              tickerName: '',
              text: dynamics[1],
              fromCompare: false,
            );
          }));
        } else if (dynamics[0] == "ForumPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(text: dynamics[1]);
          }));
        } else if (dynamics[0] == "SurveyPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SurveyPage(text: dynamics[1]);
          }));
        } else if (dynamics[0] == "FeaturePostPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const FeaturePostPage(
              fromLink: true,
            );
          }));
        } else if (dynamics[0] == "ForumPostPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPostPage(
              text: dynamics[1],
              fromLink: true,
            );
          }));
        } else if (dynamics[0] == "SurveyPostPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SurveyPostPage(
              text: dynamics[1],
              fromLink: true,
            );
          }));
        } else if (dynamics[0] == "WatchList") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const WatchList(
              excIndex: 1,
              countryIndex: 0,
              newIndex: 0,
            );
          }));
        } else if (dynamics[0] == "AddWatchlistPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return AddWatchlistPage(
                excIndex: int.parse(dynamics[2][1]),
                countryIndex: int.parse(dynamics[2][2]),
                newIndex: int.parse(dynamics[2][0]),
                tickerId: dynamics[1]);
          }));
        } else if (dynamics[0] == "TickersDetailsPage") {
          switch (dynamics[2]) {
            case "000":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'US',
                    country: 'USA',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
              }
              break;
            case "010":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "020":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'BSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
              }
              break;
            case "100":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'crypto',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "200":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'commodity',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
              }
              break;
            case "201":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'commodity',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'USA',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "300":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'forex',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'USA',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*  mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            default:
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
             */
              }
          }
        } else if (dynamics[0] == "SetAlertPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SetAlertPage(
              tickerId: dynamics[1],
              indexValue: dynamics[2],
            );
          }));
        } else if (dynamics[0] == "MyActivityPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MyActivityPage(
              fromLink: true,
            );
          }));
        } else if (dynamics[0] == "BlockListPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return mainSkipValue
                ? const MainBottomNavigationPage(
                    caseNo1: 0,
                    text: '',
                    excIndex: 1,
                    newIndex: 0,
                    countryIndex: 0,
                    tType: true,
                    isHomeFirstTym: true,
                  )
                : const BlockListPage(tabIndex: 0, blockBool: true, fromLink: true);
          }));
        } else if (dynamics[0] == "SettingsPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const SettingsView();
          }));
        } else if (dynamics[0] == "EditProfilePage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const EditProfilePage(
              comeFrom: true,
            );
          }));
        } else if (dynamics[0] == "FinalChartPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return FinalChartPage(
              tickerId: dynamics[1],
              category: dynamics[2],
              exchange: dynamics[3],
              chartType: dynamics[4],
              fromLink: true,
              index: 0,
            );
          }));
        } else if (dynamics[0] == "BillBoardHome") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
                caseNo1: 2,
                text: finalisedCategory.toString().capitalizeFirst ?? "Stocks",
                excIndex: 1,
                newIndex: 0,
                countryIndex: 0,
                isHomeFirstTym: false,
                tType: true);
          }));
        } else if (dynamics[0] == "BytesDescriptionPage") {
          mainVariables.selectedBillboardIdMain.value = dynamics[1];
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const BytesDescriptionPage(
              fromWhere: "main",
            );
          }));
        } else if (dynamics[0] == "BlogDescriptionPage") {
          mainVariables.selectedBillboardIdMain.value = dynamics[1];
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const BlogDescriptionPage(
              fromWhere: "main",
            );
          }));
        } else if (dynamics[0] == "UserProfilePage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return UserBillBoardProfilePage(
              userId: dynamics[1],
              fromLink: "main",
            );
          }));
        } else if (dynamics[0] == "IntermediaryPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return IntermediaryBillBoardProfilePage(
              userId: dynamics[1],
              fromLink: "main",
            );
          }));
        } else if (dynamics[0] == "BusinessProfilePage") {
          mainVariables.selectedTickerId.value = dynamics[1];
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const BusinessProfilePage(
              fromLink: "main",
            );
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
              caseNo1: 0,
              text: '',
              excIndex: 1,
              newIndex: 0,
              countryIndex: 0,
              tType: true,
              isHomeFirstTym: true,
            );
          }));
        }
      } else {
        if (dynamics[0] == "DemoPage") {
          /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return DemoPage(
              image: '',
              text: '',
              id: dynamics[1],
              url: '',
              type: dynamics[2],
              activity: false,
              checkMain: true,
            );
          }));*/
          Get.to(const DemoView(), arguments: {"id": dynamics[1], "type": dynamics[2], "url": ""});
        } else if (dynamics[0] == 'CreatePasswordPage') {
          setState(() {
            prefs.setString('userId', dynamics[1]);
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const CreatePasswordPage();
          }));
        } else if (dynamics[0] == 'SignUpPage') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignUpPage(
              socialId: '',
              devType: Platform.isIOS ? "ios" : "android",
              lastName: '',
              type: '',
              referralCode: '',
              phoneCode: '',
              phoneNumber: '',
              noPass: false,
              firstName: '',
              userName: '',
              socialAvatar: '',
              email: '',
            );
          }));
        } else if (dynamics[0] == 'SignInPage') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const SignInPage(
              fromWhere: "link",
            );
          }));
        } else if (dynamics[0] == "VideoDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return YoutubePlayerLandscapeScreen(
              id: dynamics[1],
              comeFrom: 'main',
            );
          }));
        } else if (dynamics[0] == "ForumPostDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              navBool: 'main',
              id: dynamics[1],
              category: dynamics[3],
              filterId: dynamics[4],
              toWhere: dynamics[0],
              fromWhere: 'link',
            );
            /*ForumPostDescriptionPage(
                  forumId:dynamics[1],
                  catIdList: mainCatIdList,
                  text:dynamics[3],
                  filterId: dynamics[4],
                  forumDetail:{},
                  navBool: 'main',)*/
          }));
        } else if (dynamics[0] == "FeaturePostDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              navBool: 'main',
              id: dynamics[1],
              category: dynamics[3],
              toWhere: dynamics[0],
              fromWhere: "link",
            );
            /*FeaturePostDescriptionPage(
                  navBool: 'main',
                  sortValue:dynamics[3],
                  featureId: dynamics[1],
                  featureDetail: {},
                );*/
          }));
        } else if (dynamics[0] == "AnalyticsPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              navBool: 'main',
              id: dynamics[1],
              category: dynamics[3],
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );

            /*AnalyticsPage(surveyTitle: dynamics[3], activity: true, surveyId: dynamics[1],);*/
          }));
        } else if (dynamics[0] == "HomeScreen") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(tType: true, text: "", caseNo1: 0, newIndex: 0, excIndex: 1, countryIndex: 0, isHomeFirstTym: true);
          }));
        } else if (dynamics[0] == "LockerPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const LockerSkipScreen();
            /*MainBottomNavigationPage(tType: true, text: dynamics[1], caseNo1: 1, newIndex: 0, excIndex: 1, countryIndex: 0,fromLink: true,isHomeFirstTym:false,);*/
          }));
        } else if (dynamics[0] == "FeatureRequestPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const FeatureRequestPage(
              fromWhere: "link",
            );
          }));
        } else if (dynamics[0] == "StocksAddFilterPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const SignInPage(
              category: 'Stocks',
              toWhere: "StocksAddFilterPage",
              fromWhere: "link",
            );
            /*StocksAddFilterPage(text: 'Stocks', page: 'locker',);*/
          }));
        } else if (dynamics[0] == "NewsMainPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return NewsMainPage(
              tickerId: '',
              tickerName: '',
              text: dynamics[1],
              fromCompare: false,
            );
          }));
        } else if (dynamics[0] == "VideosMainPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return VideosMainPage(
              tickerId: '',
              tickerName: '',
              text: dynamics[1],
              fromCompare: false,
            );
          }));
        } else if (dynamics[0] == "ForumPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              category: dynamics[3],
              toWhere: dynamics[0],
              fromWhere: "link",
            );
            /*ForumPage(text: dynamics[1]);*/
          }));
        } else if (dynamics[0] == "SurveyPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              category: dynamics[3],
              toWhere: dynamics[0],
              fromWhere: "link",
            );
            /*SurveyPage(text: dynamics[1]);*/
          }));
        } else if (dynamics[0] == "ComparePage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              category: dynamics[3],
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /* ComparePage(text: dynamics[3],fromLink: true,);*/
          }));
        } else if (dynamics[0] == "FeaturePostPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*FeaturePostPage(fromLink: true,);*/
          }));
        } else if (dynamics[0] == "ForumPostPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              category: dynamics[3],
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*ForumPostPage(text:dynamics[1],fromLink: true,);*/
          }));
        } else if (dynamics[0] == "SurveyPostPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              category: dynamics[3],
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*SurveyPostPage(text:dynamics[1],fromLink: true,);*/
          }));
        } else if (dynamics[0] == "WatchList") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const WatchList(
              excIndex: 1,
              countryIndex: 0,
              newIndex: 0,
            );
          }));
        } else if (dynamics[0] == "AddWatchlistPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return AddWatchlistPage(
                excIndex: int.parse(dynamics[2][1]),
                countryIndex: int.parse(dynamics[2][2]),
                newIndex: int.parse(dynamics[2][0]),
                tickerId: dynamics[1]);
          }));
        } else if (dynamics[0] == "TickersDetailsPage") {
          switch (dynamics[2]) {
            case "000":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'US',
                    country: 'USA',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
             */
              }
              break;
            case "010":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "020":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'BSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "100":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'crypto',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "200":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'commodity',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "201":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'commodity',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'USA',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /*mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            case "300":
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'forex',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'USA',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
              break;
            default:
              {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TickersDetailsPage(
                    category: 'stocks',
                    id: dynamics[1],
                    exchange: 'NSE',
                    country: 'India',
                    name: '',
                    fromWhere: 'main',
                  );
                }));
                /* mainVariables.selectedTickerId.value=dynamics[1];
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
              */
              }
          }
        } else if (dynamics[0] == "SetAlertPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SetAlertPage(
              tickerId: dynamics[1],
              indexValue: dynamics[2],
            );
          }));
        } else if (dynamics[0] == "MyActivityPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*MyActivityPage(fromLink: true,);*/
          }));
        } else if (dynamics[0] == "BlockListPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*BlockListPage(tabIndex: 0, blockBool: true,fromLink: true);*/
          }));
        } else if (dynamics[0] == "SettingsPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const SettingsSkipView();
          }));
        } else if (dynamics[0] == "EditProfilePage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*EditProfilePage(comeFrom: true,);*/
          }));
        } else if (dynamics[0] == "FinalChartPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return FinalChartPage(
              tickerId: dynamics[1],
              category: dynamics[2],
              exchange: dynamics[3],
              chartType: dynamics[4],
              fromLink: true,
              index: 0,
            );
          }));
        } else if (dynamics[0] == "BillBoardHome") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
          }));
        } else if (dynamics[0] == "BytesDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*MyActivityPage(fromLink: true,);*/
          }));
        } else if (dynamics[0] == "BlogDescriptionPage") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SignInPage(
              toWhere: dynamics[0],
              activity: true,
              fromWhere: "link",
            );
            /*MyActivityPage(fromLink: true,);*/
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
              caseNo1: 0,
              text: '',
              excIndex: 1,
              newIndex: 0,
              countryIndex: 0,
              tType: true,
              isHomeFirstTym: true,
            );
          }));
        }
      }
    }).onError((error) {});
  }

  getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    kToken = mainUserToken;
    pageVisitFunc(pageName: 'home');
    await getValues();
    await getEx();
    if (!mounted) {
      return;
    }
    mainSkipValue ? () {} : getReview(context: context);
    lockerCheckFiltersFunc();
    getLiveStatus();
    if (!mounted) {
      return;
    }
    functionsMain.getNotifyCount();
    getNewsValues();
    getTapeTickerValues();
    widget.isHomeFirstTime
        ? mainSkipValue
            ? () {}
            : getApiCount()
        : () {};
  }

  getTapeTickerValues() async {
    if (mounted) {
      setState(() {
        carLoader = false;
      });
    }
    tickerTapeExchange.clear();
    tapeWatchList.clear();
    var url = baseurl + versionHome + tickerTape;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var response = await dioMain.get(
      url,
      options: Options(headers: {'Authorization': mainUserToken}),
    );
    var responseData = response.data;
    tapeTickerResponse = TapeTickerModel.fromJson(responseData);
    for (int i = 0; i < tapeTickerResponse.response.length; i++) {
      if (tapeTickerResponse.response[i].category == 'stocks') {
        if (tapeTickerResponse.response[i].exchange == "NSE" ||
            tapeTickerResponse.response[i].exchange == "BSE" ||
            tapeTickerResponse.response[i].exchange == "INDX") {
          tickerTapeExchange.add(tapeTickerResponse.response[i].exchange.toLowerCase());
        } else if (responseData["response"][i]["exchange"] == "" || responseData["response"][i]["exchange"] == null) {
          tickerTapeExchange.add("");
        } else {
          tickerTapeExchange.add("usastocks");
        }
      } else if (tapeTickerResponse.response[i].category == 'crypto') {
        tickerTapeExchange
            .add(tapeTickerResponse.response[i].industry.isEmpty ? "coin" : tapeTickerResponse.response[i].industry[0].name.toLowerCase());
      } else if (tapeTickerResponse.response[i].category == 'commodity') {
        tickerTapeExchange.add(tapeTickerResponse.response[i].country.toLowerCase());
      } else {
        tickerTapeExchange.add("inrusd");
      }
      tapeWatchList.add(tapeTickerResponse.response[i].watchlist);
    }
    setState(() {
      carLoader = true;
    });
  }

  getApiCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionHome + pageView);
    var response = await http.post(url, headers: {
      "authorization": mainUserToken,
    }, body: {
      "app_version": appVersion
    });
    responseData = json.decode(response.body);
  }

  getNewsValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + newsZone;
    var response = await dioMain.post(url,
        options: Options(
          headers: {
            "authorization": mainUserToken,
          },
        ));
    responseData = response.data;
    if (responseData["status"]) {
      timeList.clear();
      newsImagesList.clear();
      newsExchangeList.clear();
      newsSentimentList.clear();
      newsDescriptionList.clear();
      newsSnippetList.clear();
      newsBookMarkList.clear();
      newsTitlesList.clear();
      newsSourceNameList.clear();
      newsLinkList.clear();
      newsIdList.clear();
      newsLikeList.clear();
      newsViewList.clear();
      newsUseList.clear();
      newsUseDisList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        newsImagesList.add(responseData["response"][i]["image_url"]);
        nativeAdIsLoadedList.add(false);
        nativeAdList.add(NativeAd(
          adUnitId: adVariables.nativeAdUnitId,
          request: const AdRequest(),
          nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: Theme.of(context).colorScheme.background,
          ),
          listener: NativeAdListener(
            onAdLoaded: (Ad ad) {
              setState(() {
                nativeAdIsLoadedList[i] = true;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) {},
            onAdClosed: (Ad ad) {},
          ),
        )..load());
        if (responseData["response"][i]["type"] == 'stocks') {
          if (responseData["response"][i]["exchange"] == "NSE" ||
              responseData["response"][i]["exchange"] == "BSE" ||
              responseData["response"][i]["exchange"] == "INDX") {
            newsExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
          } else if (responseData["response"][i]["exchange"] == "" || responseData["response"][i]["exchange"] == null) {
            newsExchangeList.add("");
          } else {
            newsExchangeList.add("usastocks");
          }
        } else if (responseData["response"][i]["type"] == 'crypto') {
          newsExchangeList
              .add(responseData["response"][i]["industry"].length == 0 ? "coin" : responseData["response"][i]["industry"][0]['name'].toLowerCase());
        } else if (responseData["response"][i]["type"] == 'commodity') {
          newsExchangeList.add(responseData["response"][i]["country"].toLowerCase());
        } else {
          newsExchangeList.add('inrusd');
        }
        newsSentimentList.add((responseData["response"][i]["sentiment"] ?? "").toLowerCase());
        newsDescriptionList.add(responseData["response"][i]["description"] ?? "");
        newsSnippetList.add(responseData["response"][i]["snippet"] ?? "");
        newsBookMarkList.add(responseData["response"][i]["bookmark"] /*??false*/);
        newsTitlesList.add(responseData["response"][i]["title"]);
        newsSourceNameList.add(responseData["response"][i]["source_name"]);
        newsLinkList.add(responseData["response"][i]["news_url"]);
        newsIdList.add(responseData["response"][i]["_id"]);
        newsLikeList.add(responseData["response"][i]["likes_count"]);
        newsViewList.add(responseData["response"][i]["views_count"]);
        newsDislikeList.add(responseData["response"][i]["dis_likes_count"]);
        DateTime dt = DateTime.parse(responseData["response"][i]["createdAt"]);
        final timestamp1 = dt.millisecondsSinceEpoch;
        readTimestamp(timestamp1);
        if (responseData["response"][i]["likes"].contains(mainUserId)) {
          if (mounted) {
            setState(() {
              newsUseList.add(true);
            });
          }
        } else {
          if (mounted) {
            setState(() {
              newsUseList.add(false);
            });
          }
        }
        if (responseData["response"][i]["dislikes"].contains(mainUserId)) {
          if (mounted) {
            setState(() {
              newsUseDisList.add(true);
            });
          }
        } else {
          if (mounted) {
            setState(() {
              newsUseDisList.add(false);
            });
          }
        }
      }
      if (mounted) {
        setState(() {
          loading2 = true;
        });
      }
    }
  }

  Future<bool> likeFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versionLocker + likes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      if (mounted) {
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    } else {
      if (mounted) {
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
    return responseData['status'];
  }

  Future<bool> disLikeFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versionLocker + dislikes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      if (mounted) {
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    } else {
      if (mounted) {
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
    return responseData['status'];
  }

  Future<bool> shareFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
      if (mounted) {
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
    return responseData['status'];
  }

  @override
  void didChangeDependencies() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adVariables.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              homeVariables.bannerAdIsLoadedMain.value = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          onAdOpened: (Ad ad) => {},
          onAdClosed: (Ad ad) => {},
        ),
        request: const AdRequest())
      ..load();
    super.didChangeDependencies();
    /*precacheImage(assetList[0], context);
    precacheImage(assetList[1], context);
    precacheImage(assetList[2], context);
    precacheImage(assetList[3], context);*/
  }

  Future<Uri> getLinK({
    required String id,
    required String type,
    required String imageUrl,
    required String title,
    required String description,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/DemoPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
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
    timeList.add(time);
    return time;
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    WidgetsBinding.instance.addObserver(this);
    homeVariables.searchControllerMain.value.clear();
    _animationController.dispose();
    _tabController!.dispose();
    _tabController1!.dispose();
    super.dispose();
  }

  getTickerValues({required String text}) async {
    var url = Uri.parse(baseurl + versionHome + homeTickers);
    var response = await http.post(url, body: {'search': text});
    var responseData123 = jsonDecode(response.body);
    if (responseData123["status"]) {
      searchList.clear();
      tradeWatchList.clear();
      for (int i = 0; i < responseData123["response"].length; i++) {
        setState(() {
          searchList.add(responseData123["response"][i]);
          tradeWatchList.add(responseData123["response"][i]['watchlist'] ?? false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () {
        setState(() {
          exitApp = true;
        });
        if (exitApp) {
          if (homeVariables.searchControllerMain.value.text.isNotEmpty) {
            setState(() {
              homeVariables.searchControllerMain.value.clear();
            });
          } else if (_toggle == false) {
            setState(() {
              _toggle = !_toggle;
            });
          } else {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    shadowColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                    surfaceTintColor: Theme.of(context).colorScheme.background,
                    elevation: 10.0,
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      height: height / 5.5,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text("Exit app",
                                  style: TextStyle(
                                      color: const Color(0XFF0EA102),
                                      fontWeight: FontWeight.bold,
                                      fontSize: text.scale(20), //text*20,
                                      fontFamily: "Poppins"))),
                          SizedBox(height: height / 173.2),
                          Center(
                              child: Text(
                            "Are you sure want to exit?",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(12), fontFamily: "Poppins"),
                          )),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('finalisedCategory1', finalisedCategory);
                                      prefs.setString('finalisedFilterId1', finalisedFilterId);
                                      prefs.setString('finalisedFilterName1', finalisedFilterName);
                                      if (Platform.isAndroid) {
                                        SystemNavigator.pop();
                                      } else if (Platform.isIOS) {
                                        exit(0);
                                      }
                                    },
                                    child: Text(
                                      "Exit",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(12)),
                                    ),
                                  ),
                                  SizedBox(width: width / 6.25),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFF0EA102),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (!mounted) {
                                          return;
                                        }
                                        exitApp = false;
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                });
          }
        }
        return false as Future<bool>;
      },
      child: Container(
        //color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            // backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: UpgradeAlert(
              upgrader: Upgrader(
                messages: MyUpGraderMessages(),
              ),
              dialogStyle: Platform.isAndroid ? UpgradeDialogStyle.material : UpgradeDialogStyle.cupertino,
              showReleaseNotes: false,
              showIgnore: false,
              shouldPopScope: () => true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 54.75,
                    ),
                    Obx(
                      () => AnimatedContainer(
                        curve: Curves.easeIn,
                        duration: _toggle == true ? const Duration(milliseconds: 300) : const Duration(milliseconds: 500),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: _toggle == true
                            ? homeVariables.searchControllerMain.value.text.isNotEmpty
                                ? height / 15.74
                                : height / 23.2
                            : 0,
                        child: _toggle == false
                            ? Container()
                            : Column(
                                children: [
                                  SizedBox(
                                    height: height / 23.2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return mainSkipValue ? const SettingsSkipView() : const SettingsView();
                                                    }));
                                                    if (response) {
                                                      initState();
                                                    }
                                                  },
                                                  child: widgetsMain.getProfileImage(context: context, isLogged: mainSkipValue)),
                                        ),
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 51.375,
                                                ),
                                        ),
                                        Expanded(
                                          child: Obx(
                                            () => TextFormField(
                                              cursorColor: Colors.green,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              // style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              controller: homeVariables.searchControllerMain.value,
                                              keyboardType: TextInputType.emailAddress,
                                              onChanged: (value) async {
                                                if (value.isNotEmpty) {
                                                  if (value.length < 3) {
                                                    homeVariables.searchControllerMain.refresh();
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    String previousValue = value;
                                                    Timer(const Duration(seconds: 1), () async {
                                                      if (previousValue == homeVariables.searchControllerMain.value.text) {
                                                        homeVariables.searchControllerMain.refresh();
                                                        await homeFunctions.getTickerValues();
                                                        await homeFunctions.getSearchValue(skipLimit: "0");
                                                        homeVariables.homeSearchResponseData.clear();
                                                        homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
                                                        homeVariables.tabSearchLoader.value = true;
                                                        homeVariables.tabSearchLoader.refresh();
                                                      }
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  homeVariables.searchControllerMain.refresh();
                                                }
                                              },
                                              decoration: InputDecoration(
                                                suffixIcon: homeVariables.searchControllerMain.value.text.isNotEmpty
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          homeVariables.searchControllerMain.value.clear();
                                                          homeVariables.searchControllerMain.refresh();
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          setState(() {});
                                                        },
                                                        child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                                                      )
                                                    : const SizedBox(),
                                                prefixIcon: homeVariables.searchControllerMain.value.text.isNotEmpty
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            homeVariables.searchControllerMain.value.clear();
                                                            homeVariables.searchControllerMain.refresh();
                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.arrow_back_rounded,
                                                          color: Theme.of(context).colorScheme.primary,
                                                          size: 22,
                                                        ))
                                                    : Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: SvgPicture.asset(
                                                          "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg",
                                                          colorFilter: ColorFilter.mode(
                                                            Theme.of(context).colorScheme.primary,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                      ),
                                                contentPadding: EdgeInsets.zero,
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: const Color(0XFFA5A5A5),
                                                    fontSize: text.scale(14),
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: "Poppins"),
                                                fillColor: Theme.of(context).colorScheme.tertiary,
                                                filled: true,
                                                hintText: 'Search here',
                                                //errorStyle: TextStyle(fontSize: text.scale(10)),
                                                errorStyle: Theme.of(context).textTheme.labelSmall,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 19.6,
                                                ),
                                        ),
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                                  ? const SizedBox()
                                                  : billboardWidgetsMain.getMessageBadge(context: context, initState: initState),
                                        ),
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 23.43,
                                                ),
                                        ),
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return const NotificationsPage();
                                                    }));
                                                    if (response) {
                                                      await functionsMain.getNotifyCount();
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: widgetsMain.getNotifyBadge(context: context),
                                                ),
                                        ),
                                        Obx(
                                          () => homeVariables.searchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 51.375,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  homeVariables.searchControllerMain.value.text.length < 3 && homeVariables.searchControllerMain.value.text.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Please enter at least 3 characters",
                                                style: TextStyle(fontSize: text.scale(11), color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                      ),
                    ),
                    loading
                        ? Obx(() => homeVariables.searchControllerMain.value.text.isNotEmpty
                            ? homeWidgets.getSearchPage(
                                context: context, bannerAd: _bannerAd, modelSetState: setState, tabController: _tabController!, initState: initState)
                            : NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (scroll) {
                                  scroll.disallowIndicator();
                                  return true;
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: _toggle == false ? 5 : height / 54.75,
                                    ),
                                    _toggle == false
                                        ? Container(
                                            margin: EdgeInsets.symmetric(horizontal: width / 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () async {
                                                              setState(() {
                                                                _toggle = !_toggle;
                                                                _toggle ? _animationController.reverse() : _animationController.forward();
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons.arrow_back,
                                                              size: 25,
                                                            )),
                                                        const SizedBox(width: 5),
                                                        Obx(() => Text(
                                                              topTrendSwitch.value ? "52 week Performance" : "Top Trending",
                                                              /*style: TextStyle(
                                                                  fontSize: text.scale(18),
                                                                  color: const Color(0XFF2C3335),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: "Poppins"),*/
                                                              style: Theme.of(context).textTheme.titleMedium,
                                                            )),
                                                      ],
                                                    ),
                                                    _tabController1!.index == 0
                                                        ? liveStatusActive
                                                            ? Container(
                                                                margin: const EdgeInsets.only(right: 15, left: 15),
                                                                height: 20,
                                                                width: 20,
                                                                child: Image.asset(isDarkTheme.value
                                                                    ? "assets/home_screen/live_dark.png"
                                                                    : "lib/Constants/Assets/SMLogos/live.png"))
                                                            : const SizedBox()
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                /*Switch(
                                                    activeColor: Colors.amber,
                                                    activeTrackColor: Colors.cyan,
                                                    inactiveThumbColor: Colors.blueGrey.shade600,
                                                    inactiveTrackColor: Colors.grey.shade400,
                                                    splashRadius: 50.0,
                                                    value: topTrendSwitch.value,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (topTrendSwitchDisable.isTrue) {
                                                          topTrendSwitch.value = value;
                                                          topTrendSwitchDisable.value = false;
                                                        } else {
                                                          Flushbar(
                                                            message: 'Please Wait',
                                                            duration: const Duration(seconds: 2),
                                                          ).show(context);
                                                        }
                                                      });
                                                    }),*/
                                                Transform.scale(
                                                  scale: 0.65,
                                                  child: Switch(
                                                      activeTrackColor: Theme.of(context).colorScheme.primary,
                                                      activeColor: isDarkTheme.value
                                                          ? Theme.of(context).colorScheme.onBackground
                                                          : Theme.of(context).colorScheme.background,
                                                      inactiveTrackColor:
                                                          isDarkTheme.value ? Theme.of(context).colorScheme.onBackground : Colors.grey,
                                                      inactiveThumbColor: Colors.white,
                                                      value: topTrendSwitch.value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (topTrendSwitchDisable.isTrue) {
                                                            topTrendSwitch.value = value;
                                                            topTrendSwitchDisable.value = false;
                                                          } else {
                                                            Flushbar(
                                                              message: 'Please Wait',
                                                              duration: const Duration(seconds: 2),
                                                            ).show(context);
                                                          }
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.symmetric(horizontal: width / 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Obx(() => Text(
                                                          topTrendSwitch.value ? "52 week Performance" : "Top Trending",
                                                          /*style: TextStyle(
                                                              fontSize: text.scale(20),
                                                              color: const Color(0XFF2C3335),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Poppins"),*/
                                                          style: Theme.of(context).textTheme.titleMedium,
                                                        )),
                                                    _tabController1!.index == 0
                                                        ? liveStatusActive
                                                            ? Container(
                                                                margin: const EdgeInsets.only(right: 15, left: 15),
                                                                height: 20,
                                                                width: 20,
                                                                child: Image.asset(isDarkTheme.value
                                                                    ? "assets/home_screen/live_dark.png"
                                                                    : "lib/Constants/Assets/SMLogos/live.png"))
                                                            : const SizedBox()
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                /*Switch(
                                                    activeColor: Colors.amber,
                                                    activeTrackColor: Colors.cyan,
                                                    inactiveThumbColor: Colors.blueGrey.shade600,
                                                    inactiveTrackColor: Colors.grey.shade400,
                                                    splashRadius: 50.0,
                                                    value: topTrendSwitch.value,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (topTrendSwitchDisable.isTrue) {
                                                          topTrendSwitch.value = value;
                                                          topTrendSwitchDisable.value = false;
                                                        } else {
                                                          Flushbar(
                                                            message: 'Please Wait',
                                                            duration: const Duration(seconds: 2),
                                                          ).show(context);
                                                        }
                                                      });
                                                    }),*/
                                                Transform.scale(
                                                  scale: 0.65,
                                                  child: Switch(
                                                      activeTrackColor: Theme.of(context).colorScheme.primary,
                                                      activeColor: isDarkTheme.value
                                                          ? Theme.of(context).colorScheme.onBackground
                                                          : Theme.of(context).colorScheme.background,
                                                      inactiveTrackColor:
                                                          isDarkTheme.value ? Theme.of(context).colorScheme.onBackground : Colors.grey,
                                                      inactiveThumbColor: Colors.white,
                                                      value: topTrendSwitch.value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (topTrendSwitchDisable.isTrue) {
                                                            topTrendSwitch.value = value;
                                                            topTrendSwitchDisable.value = false;
                                                          } else {
                                                            Flushbar(
                                                              message: 'Please Wait',
                                                              duration: const Duration(seconds: 2),
                                                            ).show(context);
                                                          }
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      height: height / 54.75,
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        AnimatedContainer(
                                          height: _toggle
                                              ? height / 3.12
                                              : Platform.isIOS
                                                  ? height / 1.32
                                                  : height / 1.29,
                                          width: width,
                                          margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: isDarkTheme.value
                                                    ? [const Color(0XFF0F0F0F), const Color(0XFF0F0F0F)]
                                                    : [Colors.white, Colors.white],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter),
                                            //color: const Color(0XFF0F0F0F).withOpacity(0.75),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.tertiary,
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          duration: const Duration(seconds: 1),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: height / 50.75,
                                              ),
                                              TabBar(
                                                indicatorWeight: 0.1,
                                                controller: _tabController1,
                                                labelPadding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                indicatorSize: TabBarIndicatorSize.label,
                                                isScrollable: true,
                                                tabAlignment: TabAlignment.start,
                                                dividerColor: Colors.transparent,
                                                dividerHeight: 0.0,
                                                indicatorColor: Colors.transparent,
                                                splashFactory: NoSplash.splashFactory,
                                                onTap: (value) {
                                                  homeVariables.homeCategoriesTabIndexMain.value = value;
                                                },
                                                tabs: [
                                                  Obx(() => Container(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                                                        decoration: BoxDecoration(
                                                            color: homeVariables.homeCategoriesTabIndexMain.value == 0
                                                                ? Theme.of(context).colorScheme.tertiary //const Color(0XFFEEEEEE)
                                                                : Colors.transparent,
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Text(
                                                          "Stocks",
                                                          /*style: TextStyle(
                                                              fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),*/
                                                          style: Theme.of(context).textTheme.bodySmall,
                                                        ),
                                                      )),
                                                  Obx(() => Container(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                                                        decoration: BoxDecoration(
                                                            color: homeVariables.homeCategoriesTabIndexMain.value == 1
                                                                ? Theme.of(context).colorScheme.tertiary //const Color(0XFFEEEEEE)
                                                                : Colors.transparent,
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Text(
                                                          "Crypto",
                                                          /*style: TextStyle(
                                                              fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),*/
                                                          style: Theme.of(context).textTheme.bodySmall,
                                                        ),
                                                      )),
                                                  Obx(() => Container(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                                                        decoration: BoxDecoration(
                                                            color: homeVariables.homeCategoriesTabIndexMain.value == 2
                                                                ? Theme.of(context).colorScheme.tertiary //const Color(0XFFEEEEEE)
                                                                : Colors.transparent,
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Text(
                                                          "Commodity",
                                                          /*style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(12),
                                                                color: const Color(0xff000000))*/
                                                          style: Theme.of(context).textTheme.bodySmall,
                                                        ),
                                                      )),
                                                  Obx(() => Container(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                                                        decoration: BoxDecoration(
                                                            color: homeVariables.homeCategoriesTabIndexMain.value == 3
                                                                ? Theme.of(context).colorScheme.tertiary // const Color(0XFFEEEEEE)
                                                                : Colors.transparent,
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Text(
                                                          "Forex",
                                                          /*style: TextStyle(
                                                              fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),*/
                                                          style: Theme.of(context).textTheme.bodySmall,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height / 50.75,
                                              ),
                                              Expanded(
                                                  child: TabBarView(
                                                controller: _tabController1,
                                                physics: const ScrollPhysics(),
                                                children: [
                                                  StockTabPage(toggleNew: _toggle, excIndex: widget.excIndex),
                                                  CryptoTabPage(
                                                    toggleNew: _toggle,
                                                  ),
                                                  CommodityTabPage(toggleNew: _toggle, countryIndex: widget.countryIndex),
                                                  ForexPage(
                                                    toggleNew: _toggle,
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            logEventFunc(name: 'Top_Trending_Viewed', type: 'HomePage');
                                            setState(() {
                                              _toggle = !_toggle;
                                            });
                                          },
                                          child: Container(
                                              height: 50,
                                              width: width,
                                              margin: const EdgeInsets.symmetric(horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background.withOpacity(0.1),
                                                borderRadius:
                                                    const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                              ),
                                              child: Image.asset(
                                                _toggle == true
                                                    ? isDarkTheme.value
                                                        ? "assets/home_screen/arrow_down_dark.png"
                                                        : "assets/home_screen/arrow_down.png"
                                                    : isDarkTheme.value
                                                        ? "assets/home_screen/arrow_up_dark.png"
                                                        : "assets/home_screen/arrow_up.png",
                                                scale: 3,
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 54.75,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 25),
                                          child: Text("Categories",
                                              /*style: TextStyle(
                                                fontSize: text.scale(18),
                                                color: const Color(0XFF2C3335),
                                                fontWeight: FontWeight.w900,
                                                fontFamily: "Poppins"),*/
                                              style: Theme.of(context).textTheme.titleMedium),
                                        ),
                                        SizedBox(
                                          height: height / 54.75,
                                        ),
                                        Container(
                                          height: height / 10.18,
                                          width: width,
                                          margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: List.generate(
                                                assetsList.length,
                                                (index) => GestureDetector(
                                                      onTap: () async {
                                                        if (mainSkipValue == false) {
                                                          await getSelectedValue(value: catNamesList[index]);
                                                        }
                                                        finalisedCategory = catNamesList[index];
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return MainBottomNavigationPage(
                                                            tType: true,
                                                            text: catNamesList[index],
                                                            caseNo1: 1,
                                                            newIndex: 0,
                                                            excIndex: 0,
                                                            countryIndex: 0,
                                                            isHomeFirstTym: false,
                                                          );
                                                        }));
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: height / 14.43,
                                                            width: width / 6.85,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                image: DecorationImage(
                                                                    image: AssetImage(isDarkTheme.value ? darkAssetList[index] : assetsList[index]),
                                                                    fit: BoxFit.fill)),
                                                          ),
                                                          Center(
                                                            child: Text(catNamesList[index],
                                                                /*style: TextStyle(
                                                                  color: const Color(0XFF2A2727),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: text.scale(12)),*/
                                                                style: Theme.of(context).textTheme.bodySmall),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                          ),
                                          /*ListView.builder(
                                            itemCount: 4,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (mainSkipValue) {
                                                    finalisedCategory =
                                                        catNamesList[index];
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return MainBottomNavigationPage(
                                                        tType: true,
                                                        text:
                                                            catNamesList[index],
                                                        caseNo1: 1,
                                                        newIndex: 0,
                                                        excIndex: 0,
                                                        countryIndex: 0,
                                                        isHomeFirstTym: false,
                                                      );
                                                    }));
                                                  } else {
                                                    await getSelectedValue(
                                                        value: catNamesList[
                                                            index]);
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return MainBottomNavigationPage(
                                                        tType: true,
                                                        text:
                                                            catNamesList[index],
                                                        caseNo1: 1,
                                                        newIndex: 0,
                                                        excIndex: 0,
                                                        countryIndex: 0,
                                                        isHomeFirstTym: false,
                                                      );
                                                    }));
                                                  }
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: _height / 10,
                                                      width: _width / 4.69,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15),
                                                          image: DecorationImage(
                                                              image: assetList[index],
                                                              fit: BoxFit
                                                                  .fill)),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        catNamesList[index],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0XFF332F2F),
                                                            fontSize:
                                                                _text * 10),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )*/
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 27.375,
                                    ),
                                    Container(
                                      height: height / 13.47,
                                      width: width * 2,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: carLoader
                                          ? slider()
                                          : Center(
                                              child: Lottie.asset('lib/Constants/Assets/SMLogos/LockerScreen/Loading Dots.json',
                                                  height: 100, width: 100),
                                            ),
                                    ),
                                    SizedBox(
                                      height: height / 32.44,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: width / 25),
                                      child: Text("Trending news",
                                          /*style: TextStyle(
                                            fontSize: text.scale(18),
                                            color: const Color(0XFF2C3335),
                                            fontWeight: FontWeight.w900,
                                            fontFamily: "Poppins"),*/
                                          style: Theme.of(context).textTheme.titleMedium),
                                    ),
                                    SizedBox(
                                      height: height / 40,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: newsIdList.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                            return Column(
                                              children: [
                                                Container(
                                                    height: height / 2.5,
                                                    margin: const EdgeInsets.symmetric(horizontal: 15),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          spreadRadius: 0,
                                                          blurRadius: 4,
                                                          color: Theme.of(context).colorScheme.tertiary,
                                                        )
                                                      ],
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    foregroundDecoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: AdWidget(ad: nativeAdList[index])),
                                                SizedBox(height: height / 57.73),
                                                Container(
                                                  height: height / 3.2,
                                                  margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: 8),
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          /*if(newsDescriptionList[index]==""&& newsSnippetList[index]==""){
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (context) {
                                                                return DemoPage(
                                                                  url: newsLinkList[index],
                                                                  text: newsTitlesList[index],
                                                                  image: "",
                                                                  id: newsIdList[index],
                                                                  type: 'news', activity: true,checkMain: false,
                                                                );
                                                              }));
                                                    }
                                                    else{
                                                      bool response=await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                          NewsDescriptionPage(
                                                            id: newsIdList[index], idList: newsIdList, descriptionList: newsDescriptionList, snippetList: newsSnippetList, comeFrom: 'main',
                                                          )));
                                                      if(response){
                                                        getNewsValues();
                                                      }
                                                    }*/

                                                          ///need to change it soon
                                                          /* bool refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return DemoPage(
                                                        url: newsLinkList[index],
                                                        text: newsTitlesList[index],
                                                        image: "",
                                                        activity: false,
                                                        id: newsIdList[index],
                                                        type: 'news',
                                                      );
                                                    }));
                                                    if (refresh) {
                                                      await getNewsValues();
                                                    }*/
                                                          Get.to(const DemoView(),
                                                              arguments: {"id": newsIdList[index], "type": 'news', "url": newsLinkList[index]});
                                                        },
                                                        child: Stack(
                                                          alignment: Alignment.bottomLeft,
                                                          children: [
                                                            Container(
                                                              height: height / 4.79,
                                                              decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    spreadRadius: 2,
                                                                    blurRadius: 1,
                                                                    offset: const Offset(0, -1),
                                                                    color: Theme.of(context).colorScheme.tertiary,
                                                                  )
                                                                ],
                                                                image: DecorationImage(
                                                                  image: NetworkImage(newsImagesList[index]),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                color: Theme.of(context).colorScheme.background,
                                                                borderRadius: const BorderRadius.only(
                                                                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: height / 13.53,
                                                              width: width,
                                                              decoration: BoxDecoration(
                                                                color: Colors.black12.withOpacity(0.3),
                                                              ),
                                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                                                              child: Text(newsTitlesList[index],
                                                                  /*style: TextStyle(
                                                              fontSize: text.scale(14),
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: "Poppins"),*/
                                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: height / 20,
                                                                width: width,
                                                                padding: const EdgeInsets.all(10),
                                                                decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    sentimentButton(
                                                                      context: context,
                                                                      text: newsSentimentList[index],
                                                                    ),
                                                                    excLabelButton(text: newsExchangeList[index], context: context)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.background,
                                                            borderRadius: const BorderRadius.only(
                                                              bottomLeft: Radius.circular(15),
                                                              bottomRight: Radius.circular(15),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                spreadRadius: 2,
                                                                blurRadius: 1,
                                                                offset: const Offset(0, 1),
                                                                color: Theme.of(context).colorScheme.tertiary,
                                                              )
                                                            ]),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(left: 15.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          newsSourceNameList[index].toString().capitalizeFirst!,
                                                                          style: TextStyle(
                                                                              fontSize: text.scale(12),
                                                                              color: const Color(0XFFF7931A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "Poppins",
                                                                              overflow: TextOverflow.ellipsis),
                                                                          maxLines: 1,
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Text(
                                                                          timeList[index],
                                                                          /*style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: const Color(0XFFB0B0B0),
                                                                        fontWeight: FontWeight.w500,
                                                                        fontFamily: "Poppins"),*/
                                                                          style: Theme.of(context).textTheme.labelSmall,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: const EdgeInsets.only(left: 8),
                                                                    width: width / 2.6,
                                                                    child: Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap: mainSkipValue
                                                                                ? () {
                                                                                    commonFlushBar(context: context, initFunction: getAllData);
                                                                                  }
                                                                                : () async {
                                                                                    bool response1 =
                                                                                        await likeFunction(id: newsIdList[index], type: "news");
                                                                                    if (response1) {
                                                                                      logEventFunc(name: "Likes", type: "News");
                                                                                      setState(() {
                                                                                        if (newsUseList[index] == true) {
                                                                                          if (newsUseDisList[index] == true) {
                                                                                          } else {
                                                                                            newsLikeList[index] -= 1;
                                                                                          }
                                                                                        } else {
                                                                                          if (newsUseDisList[index] == true) {
                                                                                            newsDislikeList[index] -= 1;
                                                                                            newsLikeList[index] += 1;
                                                                                          } else {
                                                                                            newsLikeList[index] += 1;
                                                                                          }
                                                                                        }
                                                                                        newsUseList[index] = !newsUseList[index];
                                                                                        newsUseDisList[index] = false;
                                                                                      });
                                                                                    } else {}
                                                                                  },
                                                                            child: Container(
                                                                              child: newsUseList[index]
                                                                                  ? SvgPicture.asset(
                                                                                      isDarkTheme.value
                                                                                          ? "assets/home_screen/like_filled_dark.svg"
                                                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                      height: 20,
                                                                                      width: 20)
                                                                                  : SvgPicture.asset(
                                                                                      isDarkTheme.value
                                                                                          ? "assets/home_screen/like_dark.svg"
                                                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    ),
                                                                            )),
                                                                        SizedBox(width: width / 20),
                                                                        GestureDetector(
                                                                            onTap: () async {
                                                                              logEventFunc(name: 'Share', type: 'News');
                                                                              newLink = await getLinK(
                                                                                  id: newsIdList[index],
                                                                                  type: "news",
                                                                                  description: '',
                                                                                  imageUrl: newsImagesList[index],
                                                                                  title: newsTitlesList[index]);
                                                                              ShareResult result = await Share.share(
                                                                                "Look what I was able to find on Tradewatch: ${newsTitlesList[index]} ${newLink.toString()}",
                                                                              );
                                                                              if (result.status == ShareResultStatus.success) {
                                                                                await shareFunction(id: newsIdList[index], type: "news");
                                                                              }
                                                                            },
                                                                            child: SvgPicture.asset(
                                                                              isDarkTheme.value
                                                                                  ? "assets/home_screen/share_dark.svg"
                                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                            )),
                                                                        SizedBox(width: width / 20),
                                                                        GestureDetector(
                                                                          onTap: mainSkipValue
                                                                              ? () {
                                                                                  commonFlushBar(context: context, initFunction: getAllData);
                                                                                }
                                                                              : () async {
                                                                                  bool response3 =
                                                                                      await disLikeFunction(id: newsIdList[index], type: "news");
                                                                                  if (response3) {
                                                                                    logEventFunc(name: "Dislikes", type: "News");
                                                                                    setState(() {
                                                                                      if (newsUseDisList[index] == true) {
                                                                                        if (newsUseList[index] == true) {
                                                                                        } else {
                                                                                          newsDislikeList[index] -= 1;
                                                                                        }
                                                                                      } else {
                                                                                        if (newsUseList[index] == true) {
                                                                                          newsLikeList[index] -= 1;
                                                                                          newsDislikeList[index] += 1;
                                                                                        } else {
                                                                                          newsDislikeList[index] += 1;
                                                                                        }
                                                                                      }
                                                                                      newsUseDisList[index] = !newsUseDisList[index];
                                                                                      newsUseList[index] = false;
                                                                                    });
                                                                                  } else {}
                                                                                },
                                                                          child: newsUseDisList[index]
                                                                              ? SvgPicture.asset(
                                                                                  isDarkTheme.value
                                                                                      ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                  height: 20,
                                                                                  width: 20)
                                                                              : SvgPicture.asset(
                                                                                  isDarkTheme.value
                                                                                      ? "assets/home_screen/dislike_dark.svg"
                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                  height: 20,
                                                                                  width: 20),
                                                                        ),
                                                                        SizedBox(width: width / 20),
                                                                        bookMarkWidget(
                                                                            bookMark: newsBookMarkList,
                                                                            context: context,
                                                                            scale: 3.2,
                                                                            id: newsIdList[index],
                                                                            type: 'news',
                                                                            modelSetState: setState,
                                                                            index: index,
                                                                            initFunction: getAllData,
                                                                            notUse: false),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  /*Text(
                                                                  timeList[index],
                                                                  style: TextStyle(
                                                                      fontSize: _text*10,
                                                                      color: Color(0XFFB0B0B0),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),*/
                                                                  InkWell(
                                                                    onTap: mainSkipValue
                                                                        ? () {
                                                                            commonFlushBar(context: context, initFunction: getAllData);
                                                                          }
                                                                        : () async {
                                                                            setState(() {
                                                                              kUserSearchController.clear();
                                                                              onTapType = "Views";
                                                                              onTapId = newsIdList[index];
                                                                              onLike = false;
                                                                              onDislike = false;
                                                                              onViews = true;
                                                                              idKeyMain = "news_id";
                                                                              apiMain = "";
                                                                              onTapIdMain = newsIdList[index];
                                                                              onTapTypeMain = "Views";
                                                                              haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                              haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                              haveViewsMain = newsViewList[index] > 0 ? true : false;
                                                                              likesCountMain = newsLikeList[index];
                                                                              dislikesCountMain = newsDislikeList[index];
                                                                              viewCountMain = newsViewList[index];
                                                                              kToken = mainUserToken;
                                                                              loaderMain = false;
                                                                            });
                                                                            await customShowSheetNew2(
                                                                              context: context,
                                                                            );
                                                                          },
                                                                    child: Text("${newsViewList[index]} Views",
                                                                        /*style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w900,
                                                                    fontFamily: "Poppins"),*/
                                                                        style: Theme.of(context).textTheme.labelMedium),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: mainSkipValue
                                                                        ? () {
                                                                            commonFlushBar(context: context, initFunction: getAllData);
                                                                          }
                                                                        : () async {
                                                                            /*setState(() {
                                                              kUserSearchController.clear();
                                                              onTapType="liked";
                                                              onTapId=newsIdList[index];
                                                              onLike=true;
                                                              onDislike=false;
                                                              idKeyMain="news_id";
                                                              apiMain=baseurl + versionLocker + newsLikeDislikeCount;
                                                              onTapIdMain=newsIdList[index];
                                                              onTapTypeMain="liked";
                                                              haveLikesMain=newsLikeList[index]>0?true:false;
                                                              haveDisLikesMain=newsDislikeList[index]>0?true:false;
                                                              likesCountMain=newsLikeList[index];
                                                              dislikesCountMain=newsDislikeList[index];
                                                              kToken=mainUserToken;
                                                              loaderMain=false;
                                                            });
                                                            await customShowSheetNew3(context: context, responseCheck: 'feature',);*/
                                                                            setState(() {
                                                                              kUserSearchController.clear();
                                                                              onTapType = "liked";
                                                                              onTapId = newsIdList[index];
                                                                              onLike = true;
                                                                              onDislike = false;
                                                                              onViews = false;
                                                                              idKeyMain = "news_id";
                                                                              apiMain = "";
                                                                              onTapIdMain = newsIdList[index];
                                                                              onTapTypeMain = "liked";
                                                                              haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                              haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                              haveViewsMain = newsViewList[index] > 0 ? true : false;
                                                                              likesCountMain = newsLikeList[index];
                                                                              dislikesCountMain = newsDislikeList[index];
                                                                              viewCountMain = newsViewList[index];
                                                                              kToken = mainUserToken;
                                                                              loaderMain = false;
                                                                            });
                                                                            await customShowSheetNew2(
                                                                              context: context,
                                                                            );
                                                                          },
                                                                    child: Text("${newsLikeList[index]} Likes",
                                                                        /*style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w900,
                                                                    fontFamily: "Poppins"),*/
                                                                        style: Theme.of(context).textTheme.labelMedium),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: mainSkipValue
                                                                        ? () {
                                                                            commonFlushBar(context: context, initFunction: getAllData);
                                                                          }
                                                                        : () async {
                                                                            setState(() {
                                                                              kUserSearchController.clear();
                                                                              onTapType = "disliked";
                                                                              onTapId = newsIdList[index];
                                                                              onLike = false;
                                                                              onDislike = true;
                                                                              onViews = false;
                                                                              idKeyMain = "forum_id";
                                                                              apiMain = "";
                                                                              onTapIdMain = newsIdList[index];
                                                                              onTapTypeMain = "disliked";
                                                                              haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                              haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                              haveViewsMain = newsViewList[index] > 0 ? true : false;
                                                                              likesCountMain = newsLikeList[index];
                                                                              dislikesCountMain = newsDislikeList[index];
                                                                              viewCountMain = newsViewList[index];
                                                                              kToken = mainUserToken;
                                                                              loaderMain = false;
                                                                            });
                                                                            await customShowSheetNew2(
                                                                              context: context,
                                                                            );
                                                                            /*setState(() {
                                                              kUserSearchController.clear();
                                                              onTapType="disliked";
                                                              onTapId=newsIdList[index];
                                                              onLike=false;
                                                              onDislike=true;
                                                              idKeyMain="news_id";
                                                              apiMain=baseurl + versionLocker + newsLikeDislikeCount;
                                                              onTapIdMain=newsIdList[index];
                                                              onTapTypeMain="disliked";
                                                              haveLikesMain=newsLikeList[index]>0?true:false;
                                                              haveDisLikesMain=newsDislikeList[index]>0?true:false;
                                                              likesCountMain=newsLikeList[index];
                                                              dislikesCountMain=newsDislikeList[index];
                                                              kToken=mainUserToken;
                                                              loaderMain=false;
                                                            });
                                                            await customShowSheetNew3(context: context,responseCheck: 'feature',);*/
                                                                          },
                                                                    child: Text("${newsDislikeList[index]} Dislikes",
                                                                        /* style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w900,
                                                                    fontFamily: "Poppins"),*/
                                                                        style: Theme.of(context).textTheme.labelMedium),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                          return Container(
                                            height: height / 3.2,
                                            margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: 8),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    /*if(newsDescriptionList[index]==""&& newsSnippetList[index]==""){
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (context) {
                                                                return DemoPage(
                                                                  url: newsLinkList[index],
                                                                  text: newsTitlesList[index],
                                                                  image: "",
                                                                  id: newsIdList[index],
                                                                  type: 'news', activity: true,checkMain: false,
                                                                );
                                                              }));
                                                    }
                                                    else{
                                                      bool response=await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                          NewsDescriptionPage(
                                                            id: newsIdList[index], idList: newsIdList, descriptionList: newsDescriptionList, snippetList: newsSnippetList, comeFrom: 'main',
                                                          )));
                                                      if(response){
                                                        getNewsValues();
                                                      }
                                                    }*/

                                                    ///need to change it soon
                                                    /* bool refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return DemoPage(
                                                        url: newsLinkList[index],
                                                        text: newsTitlesList[index],
                                                        image: "",
                                                        activity: false,
                                                        id: newsIdList[index],
                                                        type: 'news',
                                                      );
                                                    }));
                                                    if (refresh) {
                                                      await getNewsValues();
                                                    }*/
                                                    Get.to(const DemoView(),
                                                        arguments: {"id": newsIdList[index], "type": 'news', "url": newsLinkList[index]});
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.bottomLeft,
                                                    children: [
                                                      Container(
                                                        height: height / 4.79,
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              spreadRadius: 2,
                                                              blurRadius: 1,
                                                              offset: const Offset(0, -1),
                                                              color: Theme.of(context).colorScheme.tertiary,
                                                            )
                                                          ],
                                                          image: DecorationImage(
                                                            image: NetworkImage(newsImagesList[index]),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius:
                                                              const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: height / 13.53,
                                                        width: width,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                        ),
                                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                                                        child: Text(newsTitlesList[index],
                                                            /*style: TextStyle(
                                                              fontSize: text.scale(14),
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: "Poppins"),*/
                                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: height / 20,
                                                          width: width,
                                                          padding: const EdgeInsets.all(10),
                                                          decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              sentimentButton(
                                                                context: context,
                                                                text: newsSentimentList[index],
                                                              ),
                                                              excLabelButton(text: newsExchangeList[index], context: context)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(15),
                                                        bottomRight: Radius.circular(15),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          spreadRadius: 2,
                                                          blurRadius: 1,
                                                          offset: const Offset(0, 1),
                                                          color: Theme.of(context).colorScheme.tertiary,
                                                        )
                                                      ]),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left: 15.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    newsSourceNameList[index].toString().capitalizeFirst!,
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(12),
                                                                        color: const Color(0XFFF7931A),
                                                                        fontWeight: FontWeight.w500,
                                                                        fontFamily: "Poppins",
                                                                        overflow: TextOverflow.ellipsis),
                                                                    maxLines: 1,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    timeList[index],
                                                                    /*style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: const Color(0XFFB0B0B0),
                                                                        fontWeight: FontWeight.w500,
                                                                        fontFamily: "Poppins"),*/
                                                                    style: Theme.of(context).textTheme.labelSmall,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets.only(left: 8),
                                                              width: width / 2.6,
                                                              child: Row(
                                                                children: [
                                                                  GestureDetector(
                                                                      onTap: mainSkipValue
                                                                          ? () {
                                                                              commonFlushBar(context: context, initFunction: getAllData);
                                                                            }
                                                                          : () async {
                                                                              bool response1 =
                                                                                  await likeFunction(id: newsIdList[index], type: "news");
                                                                              if (response1) {
                                                                                logEventFunc(name: "Likes", type: "News");
                                                                                setState(() {
                                                                                  if (newsUseList[index] == true) {
                                                                                    if (newsUseDisList[index] == true) {
                                                                                    } else {
                                                                                      newsLikeList[index] -= 1;
                                                                                    }
                                                                                  } else {
                                                                                    if (newsUseDisList[index] == true) {
                                                                                      newsDislikeList[index] -= 1;
                                                                                      newsLikeList[index] += 1;
                                                                                    } else {
                                                                                      newsLikeList[index] += 1;
                                                                                    }
                                                                                  }
                                                                                  newsUseList[index] = !newsUseList[index];
                                                                                  newsUseDisList[index] = false;
                                                                                });
                                                                              } else {}
                                                                            },
                                                                      child: Container(
                                                                        child: newsUseList[index]
                                                                            ? SvgPicture.asset(
                                                                                isDarkTheme.value
                                                                                    ? "assets/home_screen/like_filled_dark.svg"
                                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                height: 20,
                                                                                width: 20)
                                                                            : SvgPicture.asset(
                                                                                isDarkTheme.value
                                                                                    ? "assets/home_screen/like_dark.svg"
                                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                height: 20,
                                                                                width: 20,
                                                                              ),
                                                                      )),
                                                                  SizedBox(width: width / 20),
                                                                  GestureDetector(
                                                                      onTap: () async {
                                                                        logEventFunc(name: 'Share', type: 'News');
                                                                        newLink = await getLinK(
                                                                            id: newsIdList[index],
                                                                            type: "news",
                                                                            description: '',
                                                                            imageUrl: newsImagesList[index],
                                                                            title: newsTitlesList[index]);
                                                                        ShareResult result = await Share.share(
                                                                          "Look what I was able to find on Tradewatch: ${newsTitlesList[index]} ${newLink.toString()}",
                                                                        );
                                                                        if (result.status == ShareResultStatus.success) {
                                                                          await shareFunction(id: newsIdList[index], type: "news");
                                                                        }
                                                                      },
                                                                      child: SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/share_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                      )),
                                                                  SizedBox(width: width / 20),
                                                                  GestureDetector(
                                                                    onTap: mainSkipValue
                                                                        ? () {
                                                                            commonFlushBar(context: context, initFunction: getAllData);
                                                                          }
                                                                        : () async {
                                                                            bool response3 =
                                                                                await disLikeFunction(id: newsIdList[index], type: "news");
                                                                            if (response3) {
                                                                              logEventFunc(name: "Dislikes", type: "News");
                                                                              setState(() {
                                                                                if (newsUseDisList[index] == true) {
                                                                                  if (newsUseList[index] == true) {
                                                                                  } else {
                                                                                    newsDislikeList[index] -= 1;
                                                                                  }
                                                                                } else {
                                                                                  if (newsUseList[index] == true) {
                                                                                    newsLikeList[index] -= 1;
                                                                                    newsDislikeList[index] += 1;
                                                                                  } else {
                                                                                    newsDislikeList[index] += 1;
                                                                                  }
                                                                                }
                                                                                newsUseDisList[index] = !newsUseDisList[index];
                                                                                newsUseList[index] = false;
                                                                              });
                                                                            } else {}
                                                                          },
                                                                    child: newsUseDisList[index]
                                                                        ? SvgPicture.asset(
                                                                            isDarkTheme.value
                                                                                ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                            height: 20,
                                                                            width: 20)
                                                                        : SvgPicture.asset(
                                                                            isDarkTheme.value
                                                                                ? "assets/home_screen/dislike_dark.svg"
                                                                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                            height: 20,
                                                                            width: 20),
                                                                  ),
                                                                  SizedBox(width: width / 20),
                                                                  bookMarkWidget(
                                                                      bookMark: newsBookMarkList,
                                                                      context: context,
                                                                      scale: 3.2,
                                                                      id: newsIdList[index],
                                                                      type: 'news',
                                                                      modelSetState: setState,
                                                                      index: index,
                                                                      initFunction: getAllData,
                                                                      notUse: false),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            /*Text(
                                                                  timeList[index],
                                                                  style: TextStyle(
                                                                      fontSize: _text*10,
                                                                      color: Color(0XFFB0B0B0),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),*/
                                                            InkWell(
                                                              onTap: mainSkipValue
                                                                  ? () {
                                                                      commonFlushBar(context: context, initFunction: getAllData);
                                                                    }
                                                                  : () async {
                                                                      setState(() {
                                                                        kUserSearchController.clear();
                                                                        onTapType = "Views";
                                                                        onTapId = newsIdList[index];
                                                                        onLike = false;
                                                                        onDislike = false;
                                                                        onViews = true;
                                                                        idKeyMain = "news_id";
                                                                        apiMain = "";
                                                                        onTapIdMain = newsIdList[index];
                                                                        onTapTypeMain = "Views";
                                                                        haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                        haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                        haveViewsMain = newsViewList[index] > 0 ? true : false;
                                                                        likesCountMain = newsLikeList[index];
                                                                        dislikesCountMain = newsDislikeList[index];
                                                                        viewCountMain = newsViewList[index];
                                                                        kToken = mainUserToken;
                                                                        loaderMain = false;
                                                                      });
                                                                      await customShowSheetNew2(
                                                                        context: context,
                                                                      );
                                                                    },
                                                              child: Text("${newsViewList[index]} Views",
                                                                  /*style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w900,
                                                                    fontFamily: "Poppins"),*/
                                                                  style: Theme.of(context).textTheme.labelMedium),
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            InkWell(
                                                              onTap: mainSkipValue
                                                                  ? () {
                                                                      commonFlushBar(context: context, initFunction: getAllData);
                                                                    }
                                                                  : () async {
                                                                      /*setState(() {
                                                              kUserSearchController.clear();
                                                              onTapType="liked";
                                                              onTapId=newsIdList[index];
                                                              onLike=true;
                                                              onDislike=false;
                                                              idKeyMain="news_id";
                                                              apiMain=baseurl + versionLocker + newsLikeDislikeCount;
                                                              onTapIdMain=newsIdList[index];
                                                              onTapTypeMain="liked";
                                                              haveLikesMain=newsLikeList[index]>0?true:false;
                                                              haveDisLikesMain=newsDislikeList[index]>0?true:false;
                                                              likesCountMain=newsLikeList[index];
                                                              dislikesCountMain=newsDislikeList[index];
                                                              kToken=mainUserToken;
                                                              loaderMain=false;
                                                            });
                                                            await customShowSheetNew3(context: context, responseCheck: 'feature',);*/
                                                                      setState(() {
                                                                        kUserSearchController.clear();
                                                                        onTapType = "liked";
                                                                        onTapId = newsIdList[index];
                                                                        onLike = true;
                                                                        onDislike = false;
                                                                        onViews = false;
                                                                        idKeyMain = "news_id";
                                                                        apiMain = "";
                                                                        onTapIdMain = newsIdList[index];
                                                                        onTapTypeMain = "liked";
                                                                        haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                        haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                        haveViewsMain = newsViewList[index] > 0 ? true : false;
                                                                        likesCountMain = newsLikeList[index];
                                                                        dislikesCountMain = newsDislikeList[index];
                                                                        viewCountMain = newsViewList[index];
                                                                        kToken = mainUserToken;
                                                                        loaderMain = false;
                                                                      });
                                                                      await customShowSheetNew2(
                                                                        context: context,
                                                                      );
                                                                    },
                                                              child: Text("${newsLikeList[index]} Likes",
                                                                  /*style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w900,
                                                                    fontFamily: "Poppins"),*/
                                                                  style: Theme.of(context).textTheme.labelMedium),
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            InkWell(
                                                              onTap: mainSkipValue
                                                                  ? () {
                                                                      commonFlushBar(context: context, initFunction: getAllData);
                                                                    }
                                                                  : () async {
                                                                      setState(() {
                                                                        kUserSearchController.clear();
                                                                        onTapType = "disliked";
                                                                        onTapId = newsIdList[index];
                                                                        onLike = false;
                                                                        onDislike = true;
                                                                        onViews = false;
                                                                        idKeyMain = "forum_id";
                                                                        apiMain = "";
                                                                        onTapIdMain = newsIdList[index];
                                                                        onTapTypeMain = "disliked";
                                                                        haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                        haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                        haveViewsMain = newsViewList[index] > 0 ? true : false;
                                                                        likesCountMain = newsLikeList[index];
                                                                        dislikesCountMain = newsDislikeList[index];
                                                                        viewCountMain = newsViewList[index];
                                                                        kToken = mainUserToken;
                                                                        loaderMain = false;
                                                                      });
                                                                      await customShowSheetNew2(
                                                                        context: context,
                                                                      );
                                                                      /*setState(() {
                                                              kUserSearchController.clear();
                                                              onTapType="disliked";
                                                              onTapId=newsIdList[index];
                                                              onLike=false;
                                                              onDislike=true;
                                                              idKeyMain="news_id";
                                                              apiMain=baseurl + versionLocker + newsLikeDislikeCount;
                                                              onTapIdMain=newsIdList[index];
                                                              onTapTypeMain="disliked";
                                                              haveLikesMain=newsLikeList[index]>0?true:false;
                                                              haveDisLikesMain=newsDislikeList[index]>0?true:false;
                                                              likesCountMain=newsLikeList[index];
                                                              dislikesCountMain=newsDislikeList[index];
                                                              kToken=mainUserToken;
                                                              loaderMain=false;
                                                            });
                                                            await customShowSheetNew3(context: context,responseCheck: 'feature',);*/
                                                                    },
                                                              child: Text("${newsDislikeList[index]} Dislikes",
                                                                  /* style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w900,
                                                                    fontFamily: "Poppins"),*/
                                                                  style: Theme.of(context).textTheme.labelMedium),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ))
                        : SizedBox(
                            height: height / 1.3,
                            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
                  itemCount: newsLikedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(uId: newsLikedIdList[index], uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                            /*Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return UserProfilePage(
                                        id: newsLikedIdList[index],
                                        type: 'survey',
                                        index: 1);
                                  }));*/
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(newsLikedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            newsLikedSourceNameList[index],
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
                  itemCount: newsViewedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(uId: newsViewedIdList[index], uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(newsViewedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            newsViewedSourceNameList[index],
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

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double? y;

  ChartData.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  @override
  String toString() {
    return "ChartData(x:$x,y:$y)";
  }
}

class StockTabPage extends StatefulWidget {
  final bool toggleNew;
  final int excIndex;

  const StockTabPage({Key? key, required this.toggleNew, required this.excIndex}) : super(key: key);

  @override
  State<StockTabPage> createState() => _StockTabPageState();
}

class _StockTabPageState extends State<StockTabPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  String mainUserToken = "";

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        liveStatusActive = responseData["response"];
      });
    }
  }

  @override
  void initState() {
    homeVariables.homeCategoriesTabIndexMain = 0.obs;
    _tabController = TabController(vsync: this, length: 5, initialIndex: widget.excIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        PreferredSize(
          preferredSize: Size.fromWidth(width / 13.7),
          child: SizedBox(
              width: width,
              child: TabBar(
                  isScrollable: true,
                  indicatorWeight: 0.1,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.only(left: width / 41.1, right: width / 27.4),
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  dividerHeight: 0.0,
                  indicatorColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                          decoration: BoxDecoration(
                              color: homeVariables.homeExchangesTabIndexMain.value == 0
                                  ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Indian Indexes",
                            //    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000))
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )),
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                          decoration: BoxDecoration(
                              color: homeVariables.homeExchangesTabIndexMain.value == 1
                                  ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "NSE India",
                            // style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000))
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )),
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                          decoration: BoxDecoration(
                              color: homeVariables.homeExchangesTabIndexMain.value == 2
                                  ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "BSE India",
                            // style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )),
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                          decoration: BoxDecoration(
                              color: homeVariables.homeExchangesTabIndexMain.value == 3
                                  ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "USA Indexes",
                            //style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )),
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                          decoration: BoxDecoration(
                              color: homeVariables.homeExchangesTabIndexMain.value == 4
                                  ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "USA Stocks",
                            // style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )),
                  ])),
        ),
        SizedBox(
          height: height / 50.75,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const ScrollPhysics(),
            children: [
              IndiaIndexesTabPage(
                toggleNew: widget.toggleNew,
              ),
              NSETabPage(
                toggleNew: widget.toggleNew,
              ),
              BSETabPage(
                toggleNew: widget.toggleNew,
              ),
              USAIndexesTabPage(
                toggleNew: widget.toggleNew,
              ),
              USATabPage(
                toggleNew: widget.toggleNew,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IndiaIndexesTabPage extends StatefulWidget {
  final bool toggleNew;

  const IndiaIndexesTabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<IndiaIndexesTabPage> createState() => _IndiaIndexesTabPageState();
}

class _IndiaIndexesTabPageState extends State<IndiaIndexesTabPage> {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    var url = baseurl + versionHome + tradeStocks;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {
          "category_id": mainCatIdList[0],
          "exchange_id": "625e59ec49d900f6585bc694",
          "type": "India",
          "limit": 20,
          "week": topTrendSwitch.value
        });
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
              setState(() {
                nativeAdIsLoadedList[i] = true;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => {},
            onAdClosed: (Ad ad) => {},
          ),
        )..load());
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      await getChartData();
    } else {}
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'INDX',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    if (mounted) {
      setState(() {
        shimmerControl = true;
        topTrendSwitchDisable.value = true;
      });
    }
  }

  Future<List<ChartData>> getChartValues({
    required String token,
    required String type,
    required String id,
    required String apiUrl,
  }) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    kToken = mainUserToken;
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
    }
  }

  @override
  void initState() {
    homeVariables.homeExchangesTabIndexMain = 0.obs;
    getLiveStatus();
    getTradeValues();
    onTabListen.value = "nse";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "nse") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(
                      height: height / 9.10,
                      child: AdWidget(
                        ad: nativeAdList[index],
                      ),
                    ),
                    Container(
                      height: height / 16.24,
                      //  margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background /*Colors.white*/,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.tertiary,
                              blurRadius: 4,
                              spreadRadius: 0,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'NSE',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                        */
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'NSE',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(
                                          tradeNameList[index],
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\u{20B9}",
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Robonto",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          /*style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ),
                                  )
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                //margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.tertiary,
                      blurRadius: 4,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'NSE',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                        */
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'NSE',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(
                                    tradeNameList[index],
                                    /* style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background /*Colors.white*/,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text(
                                  "\u{20B9}",
                                  /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Robonto",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  "${tradeRateList[index].toStringAsFixed(2)}",
                                  //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class NSETabPage extends StatefulWidget {
  final bool toggleNew;

  const NSETabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<NSETabPage> createState() => _NSETabPageState();
}

class _NSETabPageState extends State<NSETabPage> with WidgetsBindingObserver {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    var url = baseurl + versionHome + tradeStocks;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[0], "exchange_id": finalExchangeIdList[1], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
              setState(() {
                nativeAdIsLoadedList[i] = true;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) {},
            onAdClosed: (Ad ad) {},
          ),
        )..load());
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      setState(() {
        loader = true;
      });
      await getChartData();
    } else {}
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'NSE',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    if (mounted) {
      setState(() {
        shimmerControl = true;
        topTrendSwitchDisable.value = true;
      });
    }
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    kToken = mainUserToken;
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
    }
  }

  @override
  void initState() {
    homeVariables.homeExchangesTabIndexMain = 1.obs;
    getLiveStatus();
    getTradeValues();
    onTabListen.value = "nse";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "nse") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      //margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'NSE',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                        */
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'NSE',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\u{20B9}",
                                          /* style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Robonto",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'NSE',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                        */
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'NSE',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\u{20B9}",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Robonto",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class BSETabPage extends StatefulWidget {
  final bool toggleNew;

  const BSETabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<BSETabPage> createState() => _BSETabPageState();
}

class _BSETabPageState extends State<BSETabPage> with WidgetsBindingObserver {
  String mainUserToken = "";

  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    var url = baseurl + versionHome + tradeStocks;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[0], "exchange_id": finalExchangeIdList[2], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      await getChartData();
    }
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'BSE',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "BSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
    }
  }

  @override
  void initState() {
    homeVariables.homeExchangesTabIndexMain = 2.obs;
    getLiveStatus();
    getTradeValues();
    onTabListen.value = "bse";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "bse") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                        */
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'BSE',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'BSE',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\u{20B9}",
                                          /* style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Robonto",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                //margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 1,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 1),
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                        */
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'BSE',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'BSE',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\u{20B9}",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Robonto",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class USAIndexesTabPage extends StatefulWidget {
  final bool toggleNew;

  const USAIndexesTabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<USAIndexesTabPage> createState() => _USAIndexesTabPageState();
}

class _USAIndexesTabPageState extends State<USAIndexesTabPage> {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  final _channel = IOWebSocketChannel.connect('wss://ws.eodhistoricaldata.com/ws/us?api_token=60d6350f4d63f9.52101936');
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    var url = baseurl + versionHome + tradeStocks;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[0], "exchange_id": "625e59ec49d900f6585bc694", "type": "US", "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      await getChartData();
      // getStreamData();
    } else {}
  }

  getStreamData() async {
    String response = tradeCodeList.join(", ");
    _channel.sink.add('{"action": "subscribe", "symbols": "$response"}');
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'INDX',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "US",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
    }
  }

  @override
  void initState() {
    homeVariables.homeExchangesTabIndexMain = 3.obs;
    getLiveStatus();
    getTradeValues();
    onTabListen.value = "usa";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "usa") {
        getTradeValues();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    _channel.sink.close();
    super.dispose();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      //  margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'US',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'US',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\$",
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'US',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'US',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\$",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class USATabPage extends StatefulWidget {
  final bool toggleNew;

  const USATabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<USATabPage> createState() => _USATabPageState();
}

class _USATabPageState extends State<USATabPage> {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  final _channel = IOWebSocketChannel.connect('wss://ws.eodhistoricaldata.com/ws/us?api_token=60d6350f4d63f9.52101936');
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    var url = baseurl + versionHome + tradeStocks;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[0], "exchange_id": finalExchangeIdList[0], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      await getChartData();
      // getStreamData();
    } else {}
  }

  getStreamData() async {
    String response = tradeCodeList.join(", ");
    _channel.sink.add('{"action": "subscribe", "symbols": "$response"}');
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'US',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "US",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
    }
  }

  @override
  void initState() {
    homeVariables.homeExchangesTabIndexMain = 4.obs;
    getLiveStatus();
    getTradeValues();
    onTabListen.value = "usa";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "usa") {
        getTradeValues();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    _channel.sink.close();
    super.dispose();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      //margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'US',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'stocks',
                                  id: tradeIdList[index],
                                  exchange: 'US',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\$",
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'US',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'stocks',
                            id: tradeIdList[index],
                            exchange: 'US',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\$",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        /*StreamBuilder(
            stream: _channel.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data);
                for (int i = 0; i < tradeCodeList.length; i++) {
                  if (tradeCodeList[i] == data['s']) {
                    tradeRateList[i] = data['p'];
                    tradePercentageList[i] = double.parse(data['dc']??"0.0");
                  }
                }
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: tradeLogoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: _width / 2.8,
                        height: _height / 16.24,
                        margin: EdgeInsets.only(
                            left: _width / 50, right: _width / 25, bottom: 8.0),
                        padding: EdgeInsets.only(left: _width / 50),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 1,
                                spreadRadius: 1.0,
                                offset: Offset(0, 1),
                              )
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return TickersDetailsPage(
                                      category: 'stocks',
                                      id: tradeIdList[index],
                                      exchange: 'US',
                                      country: "USA",
                                      name: tradeNameList[index], fromWhere: 'main',);
                                }));
                              },
                              onDoubleTap: () async {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return TickersDetailsPage(
                                      category: 'stocks',
                                      id: tradeIdList[index],
                                      exchange: 'US',
                                      country: "USA",
                                      name: tradeNameList[index], fromWhere: 'main',);
                                }));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      height: _height / 33.83,
                                      width: _width / 15.625,
                                      child: tradeLogoList[index].contains("svg")
                                          ? SvgPicture.network(
                                          tradeLogoList[index],
                                          fit: BoxFit.fill)
                                          : Image.network(tradeLogoList[index],
                                          fit: BoxFit.fill)),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: _width / 4.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: _height / 49.2,
                                          child: Text(
                                            tradeNameList[index],
                                            style: TextStyle(
                                                fontSize: _text * 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff000000),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Container(
                                          width: _width / 6.25,
                                          height: _height / 49.2,
                                          child: Text(
                                            tradeCodeList[index],
                                            style: TextStyle(
                                                fontSize: _text * 10,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFA5A5A5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: _width / 3.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: shimmerControl
                                        ? tradeChangeList[index] == 'Increse'
                                            ? SfCartesianChart(
                                                plotAreaBackgroundColor:
                                                    Colors.transparent,
                                                primaryXAxis: CategoryAxis(
                                                  majorGridLines:
                                                      MajorGridLines(width: 0),
                                                  isVisible: false,
                                                  placeLabelsNearAxisLine:
                                                      false,
                                                ),
                                                primaryYAxis: CategoryAxis(
                                                  majorGridLines:
                                                      MajorGridLines(width: 0),
                                                  isVisible: false,
                                                  placeLabelsNearAxisLine:
                                                      false,
                                                ),
                                                plotAreaBorderColor:
                                                    Colors.transparent,
                                                series: <ChartSeries>[
                                                  AreaSeries<ChartData, String>(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0XFFEDFFC6),
                                                        Color(0XFF0EA102),
                                                      ],
                                                      end: Alignment.topRight,
                                                      begin:
                                                          Alignment.bottomLeft,
                                                    ),
                                                    borderColor:
                                                        Color(0XFF0EA102),
                                                    borderWidth: 1.5,
                                                    dataSource:
                                                        finalChartData[index],
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.y,
                                                  ),
                                                ],
                                              )
                                            : SfCartesianChart(
                                                plotAreaBackgroundColor:
                                                    Colors.transparent,
                                                primaryXAxis: CategoryAxis(
                                                  majorGridLines:
                                                      MajorGridLines(width: 0),
                                                  isVisible: false,
                                                  placeLabelsNearAxisLine:
                                                      false,
                                                ),
                                                primaryYAxis: NumericAxis(
                                                  majorGridLines:
                                                      MajorGridLines(width: 0),
                                                  isVisible: false,
                                                  placeLabelsNearAxisLine:
                                                      false,
                                                ),
                                                plotAreaBorderColor:
                                                    Colors.transparent,
                                                series: <ChartSeries>[
                                                  AreaSeries<ChartData, String>(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0XFFFB9E12)
                                                            .withOpacity(0),
                                                        Color(0XFFFB1212)
                                                            .withOpacity(1),
                                                      ],
                                                      end: Alignment.topRight,
                                                      begin:
                                                          Alignment.bottomLeft,
                                                    ),
                                                    borderColor:
                                                        Color(0XFFFF0707),
                                                    borderWidth: 1.5,
                                                    dataSource:
                                                        finalChartData[index],
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.y,
                                                  ),
                                                ],
                                              )
                                        : Shimmer.fromColors(
                                            enabled: true,
                                            child:
                                                Container(color: Colors.white),
                                            baseColor: Colors.white,
                                            highlightColor:
                                                Colors.grey.shade200,
                                            direction: ShimmerDirection.ltr,
                                          ),
                                  ),
                                ),
                                Container(
                                  width: _width / 6.5,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("\$",
                                                style: TextStyle(
                                                    fontSize: _text * 12,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff000000))),
                                            Text(
                                                "${tradeRateList[index].toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: _text * 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff000000))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: tradeChangeList[index] ==
                                                        'Increse'
                                                    ? Image.asset(
                                                        "lib/Constants/Assets/SMLogos/Up Arrow.png")
                                                    : Image.asset(
                                                        "lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            tradeChangeList[index] == 'Increse'
                                                ? Text(
                                                    "${tradePercentageList[index].toStringAsFixed(2)}%",
                                                    style: TextStyle(
                                                        fontSize: _text * 8,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff0EA102)))
                                                : Text(
                                                    "-${tradePercentageList[index].toStringAsFixed(2)}%",
                                                    style: TextStyle(
                                                        fontSize: _text * 8,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xffE3507A)))
                                          ],
                                        )
                                      ]),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap:() async {
                                if (mainSkipValue) {
                                  commonFlushBar(context:context,initFunction: initState);
                                }
                                else {
                                  if(tradeWatchList[index]){
                                    logEventFunc(
                                        name:
                                        'Removed_Watchlist',
                                        type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                    await removeWatchList(tickerId:tradeIdList[index]);
                                  }else{
                                    bool added = await addWatchList(tickerId: tradeIdList[index]);
                                    if (added) {
                                      logEventFunc(
                                          name:
                                          'Added_Watchlist',
                                          type: 'WatchList');
                                      setState(() {
                                        tradeWatchList[index] =
                                        !tradeWatchList[index];
                                      });
                                    }
                                  }
                                }
                              },
                              child: tradeWatchList[index]
                                  ? Container(
                                  height: _height / 35.03,
                                  width: _width / 16.30,
                                  margin: EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",))
                                  : Container(
                                  height: _height / 35.03,
                                  width: _width / 16.30,
                                  margin: EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",)),
                            ),
                          ],
                        ),
                      );
                    });
              }
              else {
                return Center(
                  child: Lottie.asset(
                      'lib/Constants/Assets/SMLogos/loading.json',
                      height: 100,
                      width: 100),
                );
              }
            },
          )*/
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class CryptoTabPage extends StatefulWidget {
  final bool toggleNew;

  const CryptoTabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<CryptoTabPage> createState() => _CryptoTabPageState();
}

class _CryptoTabPageState extends State<CryptoTabPage> with WidgetsBindingObserver {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeCryptoCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  final _channel = IOWebSocketChannel.connect('wss://ws.eodhistoricaldata.com/ws/crypto?api_token=60d6350f4d63f9.52101936');
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    _channel.sink.close();
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + tradeCrypto;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[1], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeCryptoCodeList.add(responseData["response"][i]["crypto_code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      // getStreamData();
      await getChartData();
    } else {}
  }

  getStreamData() async {
    String response = tradeCryptoCodeList.join(", ");
    _channel.sink.add('{"action": "subscribe", "symbols": "$response"}');
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'CRYPTO',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  @override
  void initState() {
    homeVariables.homeCategoriesTabIndexMain = 1.obs;
    streamController.add(true);
    getTradeValues();
    onTabListen.value = "crypto";
    topTrendSwitch.listen((value) async {
      if (onTabListen.value == "crypto") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'crypto',
                                  id: tradeIdList[index],
                                  exchange: 'US',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'crypto',
                                  id: tradeIdList[index],
                                  exchange: 'US',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\$",
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'crypto',
                            id: tradeIdList[index],
                            exchange: 'US',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'crypto',
                            id: tradeIdList[index],
                            exchange: 'US',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\$",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class CommodityTabPage extends StatefulWidget {
  final bool toggleNew;
  final int? countryIndex;

  const CommodityTabPage({Key? key, required this.toggleNew, this.countryIndex}) : super(key: key);

  @override
  State<CommodityTabPage> createState() => _CommodityTabPageState();
}

class _CommodityTabPageState extends State<CommodityTabPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;

  @override
  void initState() {
    homeVariables.homeCategoriesTabIndexMain = 2.obs;
    _tabController = TabController(vsync: this, length: 2, initialIndex: (widget.countryIndex ?? 0));
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        TabBar(
            isScrollable: true,
            indicatorWeight: 0.1,
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: width / 8),
            indicatorSize: TabBarIndicatorSize.label,
            tabAlignment: TabAlignment.center,
            dividerColor: Colors.transparent,
            dividerHeight: 0.0,
            indicatorColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: (int newIndex) async {
              homeVariables.homeCountriesTabIndexMain.value = newIndex;
            },
            tabs: [
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                    decoration: BoxDecoration(
                        color: homeVariables.homeCountriesTabIndexMain.value == 0
                            ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "India",
                      //style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000)),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )),
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 288.6),
                    decoration: BoxDecoration(
                        color: homeVariables.homeCountriesTabIndexMain.value == 1
                            ? Theme.of(context).colorScheme.tertiary /*const Color(0XFFEEEEEE)*/
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "USA",
                      //style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0xff000000))
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )),
            ]),
        SizedBox(
          height: height / 50.75,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const ScrollPhysics(),
            children: [
              IndiaTabPage(
                toggleNew: widget.toggleNew,
              ),
              CommodityUSATabPage(
                toggleNew: widget.toggleNew,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IndiaTabPage extends StatefulWidget {
  final bool toggleNew;

  const IndiaTabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<IndiaTabPage> createState() => _IndiaTabPageState();
}

class _IndiaTabPageState extends State<IndiaTabPage> with WidgetsBindingObserver {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<String> countryList = ["India", "USA"];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + tradeCommodity;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[2], "country": countryList[0], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      await getChartData();
    } else {}
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'COMMODITY',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  @override
  void initState() {
    homeVariables.homeCountriesTabIndexMain = 0.obs;
    streamController.add(true);
    getTradeValues();
    onTabListen.value = "india";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "india") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      //margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'commodity',
                                  id: tradeIdList[index],
                                  exchange: 'India',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'commodity',
                                  id: tradeIdList[index],
                                  exchange: 'India',
                                  country: "India",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\u{20B9}",
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Robonto",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'commodity',
                            id: tradeIdList[index],
                            exchange: 'India',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'commodity',
                            id: tradeIdList[index],
                            exchange: 'India',
                            country: "India",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 4,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\u{20B9}",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Robonto",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class CommodityUSATabPage extends StatefulWidget {
  final bool toggleNew;

  const CommodityUSATabPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<CommodityUSATabPage> createState() => _CommodityUSATabPageState();
}

class _CommodityUSATabPageState extends State<CommodityUSATabPage> with WidgetsBindingObserver {
  String mainUserToken = "";
  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  bool loader = false;
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  List<String> countryList = ["India", "USA"];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + tradeCommodity;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[2], "exchange_id": countryList[1], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeWatchList.clear();
      tradeDescriptionList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      await getChartData();
    } else {}
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'COMMODITY',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  @override
  void initState() {
    homeVariables.homeCountriesTabIndexMain = 1.obs;
    streamController.add(true);
    getTradeValues();
    onTabListen.value = "usaCom";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "usaCom") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'commodity',
                                  id: tradeIdList[index],
                                  exchange: 'USA',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'commodity',
                                  id: tradeIdList[index],
                                  exchange: 'USA',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("\$",
                                          /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000))*/
                                          style: Theme.of(context).textTheme.labelLarge),
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'commodity',
                            id: tradeIdList[index],
                            exchange: 'USA',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'commodity',
                            id: tradeIdList[index],
                            exchange: 'USA',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("\$",
                                    /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff000000))*/
                                    style: Theme.of(context).textTheme.labelLarge),
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class ForexPage extends StatefulWidget {
  final bool toggleNew;

  const ForexPage({Key? key, required this.toggleNew}) : super(key: key);

  @override
  State<ForexPage> createState() => _ForexPageState();
}

class _ForexPageState extends State<ForexPage> with WidgetsBindingObserver {
  String mainUserToken = "";

  bool shimmerControl = false;
  List tradeLogoList = [];
  List tradeIdList = [];
  List tradeNameList = [];
  List tradeCodeList = [];
  List tradeRateList = [];
  List tradePercentageList = [];
  List tradeChangeList = [];
  List<bool> tradeWatchList = [];
  List<List<ChartData>> finalChartData = [];
  List<ChartData> responseChartData = [];
  List tradeWebUrlList = [];
  List tradeDescriptionList = [];
  bool loader = false;
  final _channel = IOWebSocketChannel.connect('wss://ws.eodhistoricaldata.com/ws/forex?api_token=60d6350f4d63f9.52101936');
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    _channel.sink.close();
    super.dispose();
  }

  getTradeValues() async {
    setState(() {
      loader = false;
      shimmerControl = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + tradeForex;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': kToken},
        ),
        data: {"category_id": mainCatIdList[3], "limit": 20, "week": topTrendSwitch.value});
    var responseData = response.data;
    if (responseData["status"]) {
      tradeLogoList.clear();
      tradeIdList.clear();
      tradeNameList.clear();
      tradeCodeList.clear();
      tradeRateList.clear();
      tradePercentageList.clear();
      tradeChangeList.clear();
      tradeWebUrlList.clear();
      tradeDescriptionList.clear();
      tradeWatchList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        tradeLogoList.add(responseData["response"][i]["logo_url"]);
        tradeIdList.add(responseData["response"][i]["_id"]);
        tradeNameList.add(responseData["response"][i]["name"]);
        tradeCodeList.add(responseData["response"][i]["code"]);
        tradeRateList.add(responseData["response"][i]["close"]);
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
        tradePercentageList.add(topTrendSwitch.value ? responseData["response"][i]["week_change_per"] : responseData["response"][i]["change_p"]);
        tradeChangeList.add(responseData["response"][i]["state"]);
        tradeWatchList.add(responseData["response"][i]["watchlist"] ?? false);
        if (responseData["response"][i].containsKey("web_url")) {
          tradeWebUrlList.add(responseData["response"][i]["web_url"]);
        } else {
          tradeWebUrlList.add("");
        }
        if (responseData["response"][i].containsKey("description")) {
          tradeDescriptionList.add(responseData["response"][i]["description"]);
        } else {
          tradeDescriptionList.add("");
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loader = true;
        });
      });
      //getStreamData();
      await getChartData();
    }
  }

  getStreamData() async {
    String response = tradeCodeList.join(", ");
    response = response.replaceAll('-', "");
    _channel.sink.add('{"action": "subscribe", "symbols": "$response"}');
  }

  getChartData() async {
    finalChartData.clear();
    var url = baseurl + versionHome + tradeGraph;
    for (int i = 0; i < tradeIdList.length; i++) {
      responseChartData = await getChartValues(
        type: 'FOREX',
        id: tradeIdList[i],
        apiUrl: url,
        token: mainUserToken,
      );
      finalChartData.add(responseChartData);
    }
    setState(() {
      shimmerControl = true;
      topTrendSwitchDisable.value = true;
    });
  }

  Future<List<ChartData>> getChartValues({required String token, required String type, required String id, required String apiUrl}) async {
    List<ChartData> chartData = [];
    var response = await dioMain.post(apiUrl, data: {"ticker_id": id, "type": type});
    var responseData = response.data;
    if (responseData["status"]) {
      var length1 = responseData["response"].length;
      if (length1 != 0) {
        for (int j = 0; j < length1; j++) {
          var dataOne = responseData["response"][j]["trading_date_time"].toString().substring(0, 10);
          var dataTwo = responseData["response"][j]["close"].toDouble();
          chartData.add(ChartData(dataOne, dataTwo));
        }
      }
    }
    return chartData;
  }

  @override
  void initState() {
    homeVariables.homeCategoriesTabIndexMain = 3.obs;
    streamController.add(true);
    getTradeValues();
    onTabListen.value = "forex";
    topTrendSwitch.listen((value) {
      if (onTabListen.value == "forex") {
        getTradeValues();
      }
    });
    super.initState();
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: tradeLogoList.length,
            itemBuilder: (BuildContext context, int index) {
              if ((index == 2 || index == 7 || index == 12 || index == 17) && nativeAdIsLoadedList[index]) {
                return Column(
                  children: [
                    SizedBox(height: height / 9.10, child: AdWidget(ad: nativeAdList[index])),
                    Container(
                      height: height / 16.24,
                      // margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                      padding: EdgeInsets.only(left: width / 50),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(5), boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary,
                          blurRadius: 4,
                          spreadRadius: 0,
                        )
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'forex',
                                  id: tradeIdList[index],
                                  exchange: 'USA',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                            },
                            onDoubleTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: 'forex',
                                  id: tradeIdList[index],
                                  exchange: 'USA',
                                  country: "USA",
                                  name: tradeNameList[index],
                                  fromWhere: 'main',
                                );
                              }));
                              /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: height / 33.83,
                                    width: width / 15.625,
                                    child: tradeLogoList[index].contains("svg")
                                        ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                        : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: width / 4.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 49.2,
                                        child: Text(tradeNameList[index],
                                            /*style: TextStyle(
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff000000),
                                              overflow: TextOverflow.ellipsis),*/
                                            style: Theme.of(context).textTheme.bodySmall),
                                      ),
                                      SizedBox(
                                        width: width / 6.25,
                                        height: height / 49.2,
                                        child: Text(
                                          tradeCodeList[index],
                                          style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: shimmerControl
                                      ? tradeChangeList[index] == 'Increse'
                                          ? SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0XFFEDFFC6),
                                                      Color(0XFF0EA102),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFF0EA102),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                          : SfCartesianChart(
                                              plotAreaBackgroundColor: Colors.transparent,
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                isVisible: false,
                                                placeLabelsNearAxisLine: false,
                                              ),
                                              plotAreaBorderColor: Colors.transparent,
                                              series: <ChartSeries>[
                                                AreaSeries<ChartData, String>(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0XFFFB9E12).withOpacity(0),
                                                      const Color(0XFFFB1212).withOpacity(1),
                                                    ],
                                                    end: Alignment.topRight,
                                                    begin: Alignment.bottomLeft,
                                                  ),
                                                  borderColor: const Color(0XFFFF0707),
                                                  borderWidth: 1.5,
                                                  dataSource: finalChartData[index],
                                                  xValueMapper: (ChartData data, _) => data.x,
                                                  yValueMapper: (ChartData data, _) => data.y,
                                                ),
                                              ],
                                            )
                                      : Shimmer.fromColors(
                                          enabled: true,
                                          baseColor: Theme.of(context).colorScheme.background,
                                          highlightColor: Theme.of(context).colorScheme.tertiary,
                                          direction: ShimmerDirection.ltr,
                                          child: Container(color: Theme.of(context).colorScheme.background),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: width / 6.5,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text("${tradeRateList[index].toStringAsFixed(2)}",
                                          //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                          style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: tradeChangeList[index] == 'Increse'
                                              ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                              : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      tradeChangeList[index] == 'Increse'
                                          ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                          : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                                    ],
                                  )
                                ]),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initState);
                              } else {
                                if (tradeWatchList[index]) {
                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                  setState(() {
                                    tradeWatchList[index] = !tradeWatchList[index];
                                  });
                                  await removeWatchList(tickerId: tradeIdList[index]);
                                } else {
                                  bool added =
                                      await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                                  if (added) {
                                    logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                    setState(() {
                                      tradeWatchList[index] = !tradeWatchList[index];
                                    });
                                  }
                                }
                              }
                            },
                            child: tradeWatchList[index]
                                ? Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                                    ))
                                : Container(
                                    height: height / 35.03,
                                    width: width / 16.30,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container(
                width: width / 2.8,
                height: height / 16.24,
                //margin: EdgeInsets.only(left: width / 50, right: width / 25, bottom: 8.0),
                padding: EdgeInsets.only(left: width / 50),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.tertiary,
                      blurRadius: 4,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'forex',
                            id: tradeIdList[index],
                            exchange: 'USA',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /*mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                      },
                      onDoubleTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return TickersDetailsPage(
                            category: 'forex',
                            id: tradeIdList[index],
                            exchange: 'USA',
                            country: "USA",
                            name: tradeNameList[index],
                            fromWhere: 'main',
                          );
                        }));
                        /* mainVariables.selectedTickerId.value=tradeIdList[index];
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                      */
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 33.83,
                              width: width / 15.625,
                              child: tradeLogoList[index].contains("svg")
                                  ? SvgPicture.network(tradeLogoList[index], fit: BoxFit.fill)
                                  : Image.network(tradeLogoList[index], fit: BoxFit.fill)),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 49.2,
                                  child: Text(tradeNameList[index],
                                      /*style: TextStyle(
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff000000),
                                        overflow: TextOverflow.ellipsis),*/
                                      style: Theme.of(context).textTheme.bodySmall),
                                ),
                                SizedBox(
                                  width: width / 6.25,
                                  height: height / 49.2,
                                  child: Text(
                                    tradeCodeList[index],
                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0xFFA5A5A5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: shimmerControl
                                ? tradeChangeList[index] == 'Increse'
                                    ? SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0XFFEDFFC6),
                                                Color(0XFF0EA102),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFF0EA102),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                    : SfCartesianChart(
                                        plotAreaBackgroundColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          isVisible: false,
                                          placeLabelsNearAxisLine: false,
                                        ),
                                        plotAreaBorderColor: Colors.transparent,
                                        series: <ChartSeries>[
                                          AreaSeries<ChartData, String>(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0XFFFB9E12).withOpacity(0),
                                                const Color(0XFFFB1212).withOpacity(1),
                                              ],
                                              end: Alignment.topRight,
                                              begin: Alignment.bottomLeft,
                                            ),
                                            borderColor: const Color(0XFFFF0707),
                                            borderWidth: 1.5,
                                            dataSource: finalChartData[index],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                          ),
                                        ],
                                      )
                                : Shimmer.fromColors(
                                    enabled: true,
                                    baseColor: Theme.of(context).colorScheme.background,
                                    highlightColor: Theme.of(context).colorScheme.tertiary,
                                    direction: ShimmerDirection.ltr,
                                    child: Container(color: Theme.of(context).colorScheme.background),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6.5,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Text("${tradeRateList[index].toStringAsFixed(2)}",
                                    //    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0xff000000))
                                    style: Theme.of(context).textTheme.labelLarge),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: tradeChangeList[index] == 'Increse'
                                        ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                        : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                const SizedBox(
                                  width: 5,
                                ),
                                tradeChangeList[index] == 'Increse'
                                    ? Text("${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xff0EA102)))
                                    : Text("-${tradePercentageList[index].toStringAsFixed(2)}%",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400, color: const Color(0xffE3507A)))
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (mainSkipValue) {
                          commonFlushBar(context: context, initFunction: initState);
                        } else {
                          if (tradeWatchList[index]) {
                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                            setState(() {
                              tradeWatchList[index] = !tradeWatchList[index];
                            });
                            await removeWatchList(tickerId: tradeIdList[index]);
                          } else {
                            bool added =
                                await apiFunctionsMain.getAddWatchList(tickerId: tradeIdList[index], context: context, modelSetState: setState);
                            if (added) {
                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                              setState(() {
                                tradeWatchList[index] = !tradeWatchList[index];
                              });
                            }
                          }
                        }
                      },
                      child: tradeWatchList[index]
                          ? Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/filled_star_dark.svg" : "lib/Constants/Assets/SMLogos/Star.svg",
                              ))
                          : Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                isDarkTheme.value ? "assets/home_screen/empty_star_dark.svg" : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                              )),
                    ),
                  ],
                ),
              );
            })
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class MyUpGraderMessages extends UpgraderMessages {
  @override
  String get body => 'A new version of {{appName}} is available';
}

Widget slider() {
  return CarouselSlider.builder(
    disableGesture: false,
    options: CarouselOptions(
      autoPlay: true,
      autoPlayInterval: const Duration(milliseconds: 100),
      autoPlayAnimationDuration: const Duration(milliseconds: 1000),
      pauseAutoPlayInFiniteScroll: true,
      viewportFraction: 0.57,
      initialPage: 0,
    ),
  );
}
