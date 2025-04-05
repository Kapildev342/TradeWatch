import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chart_set_alert_page.dart';
import 'chart_top_trending_model.dart';
import 'over_view_model.dart';
import 'single_ticker_news_model.dart';

class FinalChartPage extends StatefulWidget {
  final String tickerId;
  final String? secTickerId;
  final String category;
  final String exchange;
  final String chartType;
  final int index;
  final bool? fromLink;
  final String? fromWhere;

  const FinalChartPage({
    Key? key,
    required this.tickerId,
    this.secTickerId,
    required this.category,
    required this.exchange,
    required this.chartType,
    required this.index,
    this.fromLink,
    this.fromWhere,
  }) : super(key: key);

  @override
  FinalChartPageState createState() => FinalChartPageState();
}

class FinalChartPageState extends State<FinalChartPage> with TickerProviderStateMixin {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  List<String> chartList = [
    "Bar",
    "Candle",
    "Line",
    "Area",
    "Column",
    "Baseline",
    "HiLo",
    "Renko",
    "Kagi",
    "PnF",
    "LineBreak",
    "HeikinAshi",
    "HollowCandle",
    "Line",
  ];
  String chartIndex = "";
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool openSpace = true;
  bool fullScreenFlag = false;
  late final TabController _tabController;
  late AnimationController _animationController;
  PullToRefreshController? pullToRefreshController;
  String finalUrl = "";
  Timer? timer;
  OverViewModel? _overView;
  bool loader = false;
  late Uri newLink;
  List mainExchangeIdList = [];
  bool watchStarList = false;
  String referenceValue = "";
  String primaryTickerId = "";
  String secondaryTickerId = "";
  bool compareChart = false;
  /* List<BannerAd> bannerAdList = <BannerAd>[];
  List<bool> bannerAdIsLoadedList = <bool>[];*/
  int currentModification = 0;
  bool adLoadingStarted = false;

  @override
  void initState() {
    getEx();
    getAllDataMain(name: 'Charts_Screen');
    compareChart = widget.chartType == "-1";
    finalChartMain.value = chartList[int.parse(widget.chartType == "-1" ? "13" : widget.chartType)];
    finalChartExchange.value = widget.exchange;
    primaryTickerId = widget.tickerId;
    finalChartTickerId = primaryTickerId.obs;
    secondaryTickerId = widget.secTickerId ?? "";
    finalUrl =
        "https://live.tradewatch.in/#/chart?id=${finalChartTickerId.value}&secondary=$secondaryTickerId&chart=${finalChartMain.value}&category=${finalisedCategory.toLowerCase()}&exchange=${finalChartExchange.value}&compare=$compareChart&user_id=$userIdMain&theme=${isDarkTheme.value ? "Dark" : ""}";
    debugPrint("finalUrl");
    debugPrint(finalUrl);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    _tabController = TabController(length: finalisedCategory.toLowerCase() == 'stocks' ? 8 : 7, vsync: this, initialIndex: widget.index);
    pullToRefreshController = kIsWeb || ![TargetPlatform.iOS, TargetPlatform.android].contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
    super.initState();
    contextMenu = ContextMenu(menuItems: [
      ContextMenuItem(
          iosId: "1",
          title: "Special",
          action: () async {
            await webViewController?.clearFocus();
          })
    ], onCreateContextMenu: (hitTestResult) async {}, onHideContextMenu: () {}, onContextMenuActionItemClicked: (contextMenuItemClicked) async {});
    getAllData();
  }

  getAllData() async {
    _overView = await getOverViewData(tickerId: finalChartTickerId.value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    watchVariables.chartModificationCountTotalMain.value = prefs.getInt("ModificationSearchCount") ?? 0;
    /*bannerAdList.clear();
    bannerAdIsLoadedList.clear();
    bannerAdIsLoadedList.add(false);
    bannerAdList.add(BannerAd(
        size: AdSize.banner,
        adUnitId: adVariables.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('$BannerAd loaded.');
            setState(() {
              bannerAdIsLoadedList[0] = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load());*/
    logEventFunc(name: '${finalChartMain.value}chart_id_${finalChartTickerId.value}', type: 'ChartScreen');
    setState(() {
      watchStarList = _overView!.response.watchlist;
      watchBellList.value = _overView!.response.watchlistNotification.isNotEmpty;
      headerLoader.value = true;
      loader = true;
    });
    newsModelMain = await getNewsValues(tickerId: primaryTickerId);
    if (secondaryTickerId != "") {
      newsModelMain2 = await getNewsValues(tickerId: secondaryTickerId);
    }
  }

  getEx() async {
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          mainExchangeIdList.add(responseData["response"][i]["_id"]);
        }
      });
    } else {}
  }

  Future<bool> shareFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
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

  Future<Uri> getLinK({
    required String id,
    required String type,
    required String exc,
    required String chartTypeLink,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: domainLink,
      link: Uri.parse('$domainLink/FinalChartPage/$id/$type/$exc/$chartTypeLink'),
      androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
      iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
      /*socialMetaTagParameters: SocialMetaTagParameters(
            title: title, description: '', imageUrl: Uri.parse(imageUrl))*/
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  Future<bool> removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData["status"];
  }

  @override
  void dispose() {
    extraContainMain.value = false;
    timer!.cancel();
    /*for (int i = 0; i < bannerAdList.length; i++) {
      bannerAdList[i].dispose();
    }*/
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        headerLoader.value = true;
        finalChartTickerId.value = "";
        checkIndexExchange.value = false;
        fullScreen.value = "false";
        finalChartExchange.value = "";
        finalChartMain.value = "";
        defaultTvSymbol.value = "";
        defaultTvSymbol2.value = "";
        watchBellList.value = false;
        toggleIndex.value = 0;
        prefs.setInt('ModificationSearchCount', watchVariables.chartModificationCountTotalMain.value);
        if (widget.fromLink == true) {
          if (!mounted) {
            return false;
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainBottomNavigationPage(
                      caseNo1: 0,
                      text: finalisedCategory.toLowerCase(),
                      excIndex: 1,
                      newIndex: 0,
                      countryIndex: 0,
                      isHomeFirstTym: false,
                      tType: true)));
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        } else {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            body: loader
                ? Stack(
                    children: [
                      Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(color: Colors.black26, width: 0.5),
                        ),
                        foregroundDecoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InAppWebView(
                                key: webViewKey,
                                initialUrlRequest: URLRequest(url: Uri.parse(finalUrl)),
                                initialOptions: InAppWebViewGroupOptions(
                                    crossPlatform: InAppWebViewOptions(
                                      supportZoom: false,
                                      preferredContentMode: UserPreferredContentMode.MOBILE,
                                    ),
                                    android: AndroidInAppWebViewOptions(
                                      builtInZoomControls: false,
                                      useWideViewPort: false,
                                      initialScale: 0,
                                    )),
                                initialUserScripts: UnmodifiableListView<UserScript>([]),
                                contextMenu: contextMenu,
                                pullToRefreshController: pullToRefreshController,
                                onWebViewCreated: (controller) async {
                                  webViewController = controller;
                                  webViewController!.setOptions(
                                      options: InAppWebViewGroupOptions(
                                          crossPlatform: InAppWebViewOptions(
                                            preferredContentMode: UserPreferredContentMode.MOBILE,
                                            supportZoom: false,
                                          ),
                                          android: AndroidInAppWebViewOptions(
                                            builtInZoomControls: false,
                                            useWideViewPort: false,
                                            initialScale: 0,
                                          )));
                                  timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
                                    webViewController!.webStorage.localStorage.getItem(key: "ticker_id").then((value) async {
                                      if (toggleIndex.value == 0) {
                                        if (value != null) {
                                          if (finalChartTickerId.value != value) {
                                            headerLoader.value = false;
                                            finalChartTickerId.value = value;
                                            primaryTickerId = value;
                                            await getAllData();
                                            headerLoader.value = true;
                                            setState(() {});
                                          } else {}
                                        }
                                      }
                                    });
                                    webViewController!.webStorage.localStorage.getItem(key: "modification_counts").then((value) async {
                                      if (value != null) {
                                        if (currentModification != value.toInt()) {
                                          currentModification = value == null ? 0 : value.toInt();
                                          watchVariables.chartModificationCountTotalMain.value =
                                              watchVariables.chartModificationCountTotalMain.value + currentModification;
                                          adLoadingStarted = watchVariables.chartModificationCountTotalMain.value % 5 == 0 ? false : true;
                                        }
                                        if (watchVariables.chartModificationCountTotalMain.value % 5 == 0) {
                                          if (adLoadingStarted == false) {
                                            setState(() {
                                              adLoadingStarted = true;
                                            });
                                            functionsMain.createInterstitialAd(modelSetState: setState);
                                          }
                                        }
                                      }
                                    });
                                    webViewController!.webStorage.localStorage.getItem(key: "secondary_ticker_id").then((value) async {
                                      if (toggleIndex.value == 1) {
                                        if (value != null) {
                                          if (finalChartTickerId.value != value) {
                                            headerLoader.value = false;
                                            finalChartTickerId.value = value;
                                            secondaryTickerId = value;
                                            await getAllData();
                                            headerLoader.value = true;
                                            setState(() {});
                                          } else {}
                                        }
                                      }
                                    });
                                    webViewController!.webStorage.localStorage.getItem(key: "tv_symbol").then((value) async {
                                      if (toggleIndex.value == 0) {
                                        if (value != null) {
                                          if (defaultTvSymbol.value != value) {
                                            if (value != "undefined") {
                                              setState(() {
                                                defaultTvSymbol.value = value;
                                              });
                                            } else {
                                              setState(() {
                                                defaultTvSymbol.value = "";
                                              });
                                            }
                                          }
                                        } else {
                                          defaultTvSymbol.value = "";
                                        }
                                      }

                                      setState(() {});
                                    });
                                    webViewController!.webStorage.localStorage.getItem(key: "secondary_tv_symbol").then((value) async {
                                      if (toggleIndex.value == 1) {
                                        if (value != null) {
                                          if (defaultTvSymbol2.value != value) {
                                            if (value != "undefined") {
                                              setState(() {
                                                defaultTvSymbol2.value = value;
                                              });
                                            } else {
                                              setState(() {
                                                defaultTvSymbol2.value = "";
                                              });
                                            }
                                          }
                                        } else {
                                          defaultTvSymbol2.value = "";
                                        }
                                      }
                                      setState(() {});
                                    });
                                    webViewController!.webStorage.localStorage.getItem(key: "full_screen").then((value) async {
                                      if (value != null) {
                                        if (fullScreen.value != value.toString()) {
                                          setState(() {
                                            fullScreen.value = value.toString();
                                            if (openSpace) {
                                              openSpace = false;
                                            }
                                            fullScreenFlag = !fullScreenFlag;
                                          });
                                        }
                                      }
                                      setState(() {});
                                    });
                                    webViewController!.webStorage.localStorage.getItem(key: "chart").then((value) async {
                                      if (value != null) {
                                        if (finalChartMain.value != value) {
                                          finalChartMain.value = value;
                                          chartIndex = chartList.indexOf(finalChartMain.value).toString();
                                          logEventFunc(name: '${finalChartMain.value}chart_id_${finalChartTickerId.value}', type: 'ChartScreen');
                                        }
                                      }
                                      setState(() {});
                                    });
                                    if (finalisedCategory.toLowerCase() == 'stocks') {
                                      webViewController!.webStorage.localStorage.getItem(key: "exchange").then((value) async {
                                        if (value != null) {
                                          if (finalChartExchange.value != value) {
                                            setState(() {
                                              finalChartExchange.value = value;
                                            });
                                          }
                                        }
                                      });
                                      setState(() {});
                                    } else {
                                      setState(() {
                                        finalChartExchange.value = "";
                                      });
                                    }
                                  });
                                },
                                onLoadStart: (controller, url) async {
                                  setState(() {
                                    this.url = url.toString();
                                    urlController.text = this.url;
                                  });
                                },
                                shouldOverrideUrlLoading: (controller, navigationAction) async {
                                  var uri = navigationAction.request.url!;
                                  if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                                    if (await canLaunchUrl(uri)) {
                                      // Launch the App
                                      await launchUrl(
                                        uri,
                                      );
                                      // and cancel the request
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  }

                                  return NavigationActionPolicy.ALLOW;
                                },
                                onLoadStop: (controller, url) async {
                                  pullToRefreshController?.endRefreshing();
                                  setState(() {
                                    this.url = url.toString();
                                    urlController.text = this.url;
                                  });
                                },
                                onProgressChanged: (controller, progress) {
                                  if (progress == 100) {
                                    pullToRefreshController?.endRefreshing();
                                  }
                                  setState(() {
                                    this.progress = progress / 100;
                                    urlController.text = url;
                                  });
                                },
                                onUpdateVisitedHistory: (controller, url, isReload) {
                                  setState(() {
                                    this.url = url.toString();
                                    urlController.text = this.url;
                                  });
                                },
                                onConsoleMessage: (controller, consoleMessage) {},
                              ),
                            ),
                            openSpace
                                ? Card(
                                    elevation: 10,
                                    clipBehavior: Clip.hardEdge,
                                    shape: OutlineInputBorder(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3))),
                                    child: AnimatedContainer(
                                      width: openSpace ? width / 3.504 : 0,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
                                      foregroundDecoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      duration: const Duration(milliseconds: 1000),
                                      child: Container(
                                        width: width,
                                        margin: EdgeInsets.symmetric(horizontal: width / 87.6, vertical: height / 82.2),
                                        child: Column(
                                          children: [
                                            widget.chartType == "-1"
                                                ? ToggleSwitch(
                                                    minWidth: width / 8.34,
                                                    minHeight: height / 27.4,
                                                    cornerRadius: 5.0,
                                                    activeBgColors: const [
                                                      [Color(0XFF0EA102)],
                                                      [Color(0XFF0EA102)]
                                                    ],
                                                    activeFgColor: Colors.white,
                                                    inactiveBgColor: Colors.grey.shade300,
                                                    inactiveFgColor: Colors.black,
                                                    initialLabelIndex: toggleIndex.value,
                                                    totalSwitches: 2,
                                                    fontSize: 8,
                                                    labels: const ['Primary', 'Secondary'],
                                                    radiusStyle: true,
                                                    onToggle: (index) async {
                                                      setState(() {
                                                        toggleIndex.value = index!;
                                                      });
                                                      if (index == 1) {
                                                        if (finalChartTickerId.value != secondaryTickerId) {
                                                          headerLoader.value = false;
                                                          //  finalChartTickerId.value=secondaryTickerId;
                                                          finalChartTickerId.value = secondaryTickerId;
                                                          await getAllData();
                                                          headerLoader.value = true;
                                                        } else {}
                                                      } else {
                                                        if (finalChartTickerId.value != primaryTickerId) {
                                                          headerLoader.value = false;
                                                          //primaryTickerId=finalChartTickerId.value;
                                                          finalChartTickerId.value = primaryTickerId;
                                                          await getAllData();
                                                          headerLoader.value = true;
                                                        } else {}
                                                      }
                                                    },
                                                  )
                                                : const SizedBox(),
                                            widget.chartType == "-1"
                                                ? SizedBox(
                                                    height: height / 82.2,
                                                  )
                                                : const SizedBox(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Obx(() => headerLoader.value
                                                    ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor: Colors.transparent,
                                                            backgroundImage: NetworkImage(_overView!.response.logoUrl),
                                                          ),
                                                          SizedBox(
                                                            width: width / 109.5,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                  width: width / 6.25,
                                                                  child: Text(
                                                                    _overView!.response.name,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: text.scale(10),
                                                                        overflow: TextOverflow.ellipsis),
                                                                  )),
                                                              SizedBox(
                                                                width: width / 6.25,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Image.asset(
                                                                      (_overView!.response.category == 'stocks' &&
                                                                                  _overView!.response.exchange == 'NSE') ||
                                                                              (_overView!.response.category == 'stocks' &&
                                                                                  _overView!.response.exchange == 'BSE') ||
                                                                              (_overView!.response.category == 'commodity' &&
                                                                                  _overView!.response.country == 'India')
                                                                          ? "lib/Constants/Assets/FinalChartImages/image 4.png"
                                                                          : "lib/Constants/Assets/FinalChartImages/united-states.png",
                                                                      scale: (_overView!.response.category == 'stocks' &&
                                                                                  _overView!.response.exchange == 'NSE') ||
                                                                              (_overView!.response.category == 'stocks' &&
                                                                                  _overView!.response.exchange == 'BSE') ||
                                                                              (_overView!.response.category == 'commodity' &&
                                                                                  _overView!.response.country == 'India')
                                                                          ? 3
                                                                          : 60,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                      child: Text(
                                                                        _overView!.response.category == 'stocks'
                                                                            ? _overView!.response.exchange
                                                                            : _overView!.response.category == 'commodity'
                                                                                ? _overView!.response.country
                                                                                : "",
                                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(6)),
                                                                      ),
                                                                    ),
                                                                    const Padding(
                                                                        padding: EdgeInsets.only(right: 4.0),
                                                                        child: CircleAvatar(
                                                                          backgroundColor: Color(0XFF911249),
                                                                          radius: 2,
                                                                        )),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 5.0),
                                                                      child: Text(
                                                                        _overView!.response.code,
                                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(6)),
                                                                      ),
                                                                    ),
                                                                    const Padding(
                                                                        padding: EdgeInsets.only(right: 5.0),
                                                                        child: CircleAvatar(
                                                                          backgroundColor: Color(0XFF11AA04),
                                                                          radius: 2,
                                                                        )),
                                                                    Text(
                                                                      finalisedCategory.toLowerCase() == 'stocks'
                                                                          ? _overView!.response.marketAvailable
                                                                              ? "Market Open"
                                                                              : "Market Closed"
                                                                          : "Market Open",
                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(6)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    : /* SizedBox()*/ Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                        height: height / 8.22, width: width / 17.52)),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        openSpace = false;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 15,
                                                    ))
                                              ],
                                            ),
                                            Obx(() => headerLoader.value
                                                ? SizedBox(
                                                    height: height / 13.7,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            newLink = await getLinK(
                                                                id: finalChartTickerId.value,
                                                                type: finalisedCategory.toLowerCase(),
                                                                exc: finalChartExchange.value,
                                                                chartTypeLink: chartIndex == "" ? widget.chartType : chartIndex);
                                                            await Share.share(
                                                              "Look what I was able to find on Tradewatch: ${newLink.toString()}",
                                                            );
                                                          },
                                                          child: Container(
                                                              margin: EdgeInsets.only(right: width / 35),
                                                              child: SvgPicture.asset(
                                                                isDarkTheme.value
                                                                    ? "assets/home_screen/share_dark.svg"
                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                              )),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (mainSkipValue) {
                                                              commonPopUpBar(context: context);
                                                            } else {
                                                              if (watchStarList) {
                                                                bool removed = await removeWatchList(tickerId: finalChartTickerId.value);
                                                                if (removed) {
                                                                  logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                                                  setState(() {
                                                                    watchStarList = !watchStarList;
                                                                  });
                                                                }
                                                              } else {
                                                                bool added = await apiFunctionsMain.getAddWatchList(
                                                                    tickerId: finalChartTickerId.value, context: context, modelSetState: setState);
                                                                if (added) {
                                                                  logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                                                  setState(() {
                                                                    watchStarList = !watchStarList;
                                                                  });
                                                                }
                                                              }
                                                            }
                                                          },
                                                          child: watchStarList
                                                              ? Container(
                                                                  margin: EdgeInsets.only(right: width / 35),
                                                                  child: SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/filled_star_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/Star.svg",
                                                                  ))
                                                              : Container(
                                                                  margin: EdgeInsets.only(right: width / 35),
                                                                  child: SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/empty_star_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                                                  )),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (mainSkipValue) {
                                                              commonPopUpBar(context: context);
                                                            } else {
                                                              _tabController.animateTo(7);
                                                            }
                                                          },
                                                          child: watchBellList.value
                                                              ? SvgPicture.asset(
                                                                  isDarkTheme.value
                                                                      ? "assets/home_screen/ringing_bell_dark.svg"
                                                                      : "lib/Constants/Assets/SMLogos/ringing3.svg",
                                                                )
                                                              : SvgPicture.asset(
                                                                  isDarkTheme.value
                                                                      ? "assets/home_screen/empty_bell_dark.svg"
                                                                      : "lib/Constants/Assets/SMLogos/emptyBell.svg",
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox()),
                                            Divider(
                                              thickness: 3,
                                              color: Colors.grey.shade300,
                                            ),
                                            finalisedCategory.toLowerCase() == 'stocks'
                                                ? PreferredSize(
                                                    preferredSize: Size.fromWidth(width / 29.2),
                                                    child: SizedBox(
                                                      height: height / 20.55,
                                                      child: Center(
                                                        child: TabBar(
                                                            isScrollable: true,
                                                            controller: _tabController,
                                                            unselectedLabelColor: const Color(0xffA9A9A9), //const Color(0XFF303030),
                                                            labelColor: const Color(0XFF11AA04),
                                                            indicatorColor: Colors.green,
                                                            indicatorWeight: 0.1,
                                                            dividerColor: Colors.transparent,
                                                            dividerHeight: 0.0,
                                                            tabs: [
                                                              Tab(
                                                                child: Text(
                                                                  'Overview',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Trending',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Locker',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Financial',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Reports',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Forum',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Survey',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Alert',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ))
                                                : PreferredSize(
                                                    preferredSize: Size.fromWidth(width / 29.2),
                                                    child: SizedBox(
                                                      height: height / 20.55,
                                                      child: Center(
                                                        child: TabBar(
                                                            isScrollable: true,
                                                            controller: _tabController,
                                                            unselectedLabelColor: const Color(0XFF303030),
                                                            labelColor: const Color(0XFF11AA04),
                                                            indicatorColor: Colors.green,
                                                            indicatorWeight: 0.1,
                                                            dividerColor: Colors.transparent,
                                                            dividerHeight: 0.0,
                                                            tabs: [
                                                              Tab(
                                                                child: Text(
                                                                  'Overview',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Trending',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Locker',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Financial',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Forum',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Survey',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Tab(
                                                                child: Text(
                                                                  'Alert',
                                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    )),
                                            Obx(() => headerLoader.value
                                                ? Expanded(
                                                    child: Stack(alignment: Alignment.bottomCenter, children: [
                                                    TabBarView(
                                                      controller: _tabController,
                                                      physics: const ScrollPhysics(),
                                                      children: finalisedCategory.toLowerCase() == 'stocks'
                                                          ? [
                                                              const OverViewWidget(),
                                                              const HotListWidget(),
                                                              const LockerWidget(),
                                                              const Financial(fromWhere: false),
                                                              const ReportsWidget(fromWhere: false),
                                                              const ForumWidget(),
                                                              const SurveyWidget(),
                                                              const AlertWidget(),
                                                            ]
                                                          : [
                                                              const OverViewWidget(),
                                                              const HotListWidget(),
                                                              const LockerWidget(),
                                                              const Financial(
                                                                fromWhere: false,
                                                              ),
                                                              const ForumWidget(),
                                                              const SurveyWidget(),
                                                              const AlertWidget(),
                                                            ],
                                                    ),
                                                    /* bannerAdIsLoadedList[0]
                                                        ? SizedBox(height: 50, child: AdWidget(ad: bannerAdList[0]))
                                                        : const SizedBox(),*/
                                                  ]))
                                                : Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                    height: height / 8.22, width: width / 17.52))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Theme.of(context).colorScheme.background,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 27.4,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                openSpace = true;
                                              });
                                            },
                                            child: Container(
                                                width: width / 29.2,
                                                height: height / 8.22,
                                                decoration: BoxDecoration(
                                                    color: Colors.green.shade200,
                                                    // shape: BoxShape.circle,
                                                    borderRadius:
                                                        const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
                                                child: Center(
                                                    child: Shimmer.fromColors(
                                                        baseColor: Colors.black,
                                                        highlightColor: Colors.white,
                                                        direction: ShimmerDirection.rtl,
                                                        child: SvgPicture.asset(
                                                          "lib/Constants/Assets/SMLogos/arrow_left_main.svg",
                                                          height: 20,
                                                          width: 20,
                                                        )))))
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      fullScreenFlag
                          ? const SizedBox()
                          : Positioned(
                              left: width / 109.5,
                              top: height / 102.75,
                              child: GestureDetector(
                                  onTap: () async {
                                    print("back hello");
                                    extraContainMain.value = false;
                                    timer!.cancel();
                                    /* for (int i = 0; i < bannerAdList.length; i++) {
                                      bannerAdList[i].dispose();
                                    }*/
                                    _animationController.dispose();
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    headerLoader.value = true;
                                    finalChartTickerId.value = "";
                                    fullScreen.value = "false";
                                    checkIndexExchange.value = false;
                                    finalChartExchange.value = "";
                                    finalChartMain.value = "";
                                    defaultTvSymbol.value = "";
                                    defaultTvSymbol2.value = "";
                                    watchBellList.value = false;
                                    toggleIndex.value = 0;
                                    prefs.setInt('ModificationSearchCount', watchVariables.chartModificationCountTotalMain.value);
                                    if (widget.fromLink == true) {
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => MainBottomNavigationPage(
                                                  caseNo1: 0,
                                                  text: finalisedCategory.toLowerCase(),
                                                  excIndex: 1,
                                                  newIndex: 0,
                                                  countryIndex: 0,
                                                  isHomeFirstTym: false,
                                                  tType: true)));
                                    } else {
                                      Future.delayed(const Duration(seconds: 1), () {
                                        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                        if (!mounted) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: Colors.white)),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: width / 109.5, top: height / 82.2, bottom: height / 82.2),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                      ),
                                    ),
                                  ))),
                      Positioned(
                        left: fullScreenFlag ? 0 : width / 14.6,
                        bottom: fullScreenFlag ? height / 11 : height / 13,
                        child: Container(
                          height: height / 8.22,
                          width: width / 17.52,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: height,
                    width: width,
                    child: Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 4.11, width: width / 8.76)),
                  )),
      ),
    );
  }
}

class OverViewWidget extends StatefulWidget {
  const OverViewWidget({Key? key}) : super(key: key);

  @override
  State<OverViewWidget> createState() => _OverViewWidgetState();
}

class _OverViewWidgetState extends State<OverViewWidget> {
  RxString firstHalf = "".obs;
  RxString secondHalf = "".obs;
  RxBool flag = true.obs;
  bool summaryValue = true;
  OverViewModel? _overView;
  bool overViewLoader = false;

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Over_View');
    getAllData();
    super.initState();
  }

  getAllData() async {
    _overView = await getOverViewData(tickerId: finalChartTickerId.value);
    if (_overView!.response.description == "undefined" || _overView!.response.description.length < 2) {
      firstHalf.value = "    Description not available";
      secondHalf.value = "";
    } else if (_overView!.response.description.length > 150) {
      firstHalf.value = _overView!.response.description.substring(0, 150);
      secondHalf.value = _overView!.response.description.substring(150, _overView!.response.description.length);
    } else {
      firstHalf.value = _overView!.response.description;
      secondHalf.value = "";
    }
    setState(() {
      overViewLoader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SingleChildScrollView(
      child: overViewLoader
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 51.375,
                ),
                Text(
                  "Description",
                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: height / 51.375,
                ),
                Obx(
                  () => secondHalf.isEmpty
                      ? Text(
                          firstHalf.value,
                          style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w300),
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              flag.value ? ("${firstHalf.value}...") : (firstHalf.value + secondHalf.value),
                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w300),
                            ),
                            InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  flag.value
                                      ? const Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 15,
                                        )
                                      : const Icon(
                                          Icons.keyboard_arrow_up_outlined,
                                          size: 15,
                                        ),
                                ],
                              ),
                              onTap: () {
                                flag.toggle();
                              },
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: height / 68.5,
                ),
                Text(
                  "Summary",
                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                              width: width / 8,
                              child: Text(
                                _overView!.response.name,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: text.scale(8), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Current Price ", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600)),
                          _overView!.response.category == "stocks" || _overView!.response.category == "commodity"
                              ? _overView!.response.exchange == "NSE" ||
                                      _overView!.response.exchange == "BSE" ||
                                      _overView!.response.country == "India"
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("\u{20B9}",
                                            style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600, fontFamily: "Robonto")),
                                        Text(_overView!.response.close, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600)),
                                      ],
                                    )
                                  : Text("\$ ${_overView!.response.close}", style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600))
                              : _overView!.response.category == "forex"
                                  ? Text(_overView!.response.close, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600))
                                  : Text("\$ ${_overView!.response.close}", style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600)),

                          /*  _overView!.response.category == "stocks"
                              ? _overView!.response.exchange == "NSE" ||
                                      _overView!.response.exchange == "BSE"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("\u{20B9}",
                                            style: TextStyle(
                                                fontSize: _text.scale(10)8,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Robonto")),
                                        Text("${_overView!.response.close}",
                                            style: TextStyle(
                                                fontSize: _text.scale(10)8,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    )
                                  : Text("\$" + "${_overView!.response.close}",
                                      style: TextStyle(
                                          fontSize: _text.scale(10)8,
                                          fontWeight: FontWeight.w600))
                              : _overView!.response.category == "commodity"
                                  ? _overView!.response.exchange == "India"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("\u{20B9}",
                                                style: TextStyle(
                                                    fontSize: _text.scale(10)8,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Robonto")),
                                            Text("${_overView!.response.close}",
                                                style: TextStyle(
                                                    fontSize: _text.scale(10)8,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        )
                                      : Text(
                                          "\$" + "${_overView!.response.close}",
                                          style: TextStyle(
                                              fontSize: _text.scale(10)8,
                                              fontWeight: FontWeight.w600))
                                  : _overView!.response.category == "forex"
                                      ? Text("${_overView!.response.close}",
                                          style: TextStyle(
                                              fontSize: _text.scale(10)8,
                                              fontWeight: FontWeight.w600))
                                      : Text(
                                          "\$" + "${_overView!.response.close}",
                                          style: TextStyle(
                                              fontSize: _text.scale(10)8,
                                              fontWeight: FontWeight.w600)),*/
                        ],
                      ),
                    ),
                    /*Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Highest Price ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: _text.scale(10)8,
                            fontWeight: FontWeight.w400)),
                    _overView!.response.category == "stocks"
                                ? _overView!.response.exchange == "NSE" ||
                        _overView!.response.exchange == "BSE"
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text("\u{20B9}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight.w400,
                                        fontFamily:
                                        "Robonto")),
                                Text(
                                    _overView!.response..toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight
                                            .w400)),
                              ],
                            )
                                : Text(
                                "\$" +
                                    "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400))
                                : _overView!.response.category == "commodity"
                                ? _overView!.response.exchange == "India"
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text("\u{20B9}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight
                                            .w400,
                                        fontFamily:
                                        "Robonto")),
                                Text(
                                    "${_overView!.response..toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight
                                            .w400)),
                              ],
                            )
                                : Text(
                                "\$" +
                                    "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400))
                                : _overView!.response.category == "forex"
                                ? Text(
                                "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400))
                                : Text(
                                "\$" +
                                    "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Lowest Price ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: _text.scale(10)8,
                            fontWeight: FontWeight.w400)),
                    _overView!.response.category == "stocks"
                                ? _overView!.response.exchange == "NSE" ||
                        _overView!.response.exchange == "BSE"
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text("\u{20B9}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight.w400,
                                        fontFamily:
                                        "Robonto")),
                                Text(
                                    "${_overView!.response..toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight
                                            .w400)),
                              ],
                            )
                                : Text(
                                "\$" +
                                    "${_overView!.response..value.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400))
                                : _overView!.response.category == "commodity"
                                ? _overView!.response.exchange == "India"
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text("\u{20B9}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight
                                            .w400,
                                        fontFamily:
                                        "Robonto")),
                                Text(
                                    "${_overView!.response..toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize:
                                        _text.scale(10)12,
                                        fontWeight:
                                        FontWeight
                                            .w400)),
                              ],
                            )
                                : Text(
                                "\$" +
                                    "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400))
                                : _overView!.response.category == "forex"
                                ? Text(
                                "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400))
                                : Text(
                                "\$" +
                                    "${_overView!.response..toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: _text.scale(10)12,
                                    fontWeight:
                                    FontWeight.w400)),
                  ],
                ),
              ),*/
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("52 wk Range", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text("${_overView!.response.weekLow} - ${_overView!.response.weekHigh}",
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("24h Trading Volume (M)",
                              textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text("_", textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Market Cap (M)", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.marketCapitalizationMln.toString().split('.')[0].trim(),
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Circulation Supply ",
                              textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.circulatingSupply,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shares (M)", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.sharesMln.toString().split('.')[0].trim().toString(),
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("EPS", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.epse,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("EBITDA (M)", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.ebitDa,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("PE Ratio ", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.peRatio,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("PEG Ratio", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.pegRatio,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Revenue (M)", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.revenueTtm,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dividends (Yield)",
                              textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.forwardAnnualDividendYield.toString(),
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dividend ", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(
                                  _overView!.response.dividend.length > 10
                                      ? _overView!.response.dividend.toString().substring(0, 10)
                                      : _overView!.response.dividend,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Last Dividend Announced ",
                                textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          ),
                          SizedBox(
                              width: width / 8,
                              child: Text(
                                  _overView!.response.exdividendDate.length > 10
                                      ? _overView!.response.exdividendDate.toString().substring(0, 10)
                                      : _overView!.response.exdividendDate,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Last Dividend Provided ",
                              textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text(_overView!.response.exdividendDate,
                                  textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Next Dividend Date",
                              textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                          SizedBox(
                              width: width / 8,
                              child: Text("_", textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
                SizedBox(height: height / 34.25),
              ],
            )
          : Center(
              child: Lottie.asset(
                'lib/Constants/Assets/SMLogos/loading.json',
                height: height / 8.22,
                width: width / 17.52,
              ),
            ),
    );
  }
}

class HotListWidget extends StatefulWidget {
  const HotListWidget({Key? key}) : super(key: key);

  @override
  State<HotListWidget> createState() => _HotListWidgetState();
}

class _HotListWidgetState extends State<HotListWidget> {
  List<String> excNames = [
    "NSE",
    "BSE",
    "USA",
  ];
  List<int> excIndex = [1, 2, 0];
  List<String> countryList = ["India", "USA"];
  List<ChartTopTrendingModel> responseList = [];
  bool loader = false;
  List mainExchangeIdList = [];
  List<bool> boolInitialList = List.generate(
      finalisedCategory.toLowerCase() == "stocks"
          ? 3
          : finalisedCategory.toLowerCase() == "commodity"
              ? 2
              : 1,
      (index) => true);
  List<bool> boolList = List.generate(
      finalisedCategory.toLowerCase() == "stocks"
          ? 3
          : finalisedCategory.toLowerCase() == "commodity"
              ? 2
              : 1,
      (index) => true);
  List<bool> flagMore = List.generate(
      finalisedCategory.toLowerCase() == "stocks"
          ? 3
          : finalisedCategory.toLowerCase() == "commodity"
              ? 2
              : 1,
      (index) => false);
  List<List<bool>> watchStarList = List.generate(
      finalisedCategory.toLowerCase() == "stocks"
          ? 3
          : finalisedCategory.toLowerCase() == "commodity"
              ? 2
              : 1,
      (index) => []);

  Future<ChartTopTrendingModel> getTradeValues({required String url, required Map<String, dynamic> data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var response = await dioMain.post(url, data: data, options: Options(headers: {'Authorization': mainUserToken}));
    var responseData = response.data;
    ChartTopTrendingModel topTrend = ChartTopTrendingModel.fromJson(responseData);
    return topTrend;
  }

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Hotlist');
    getData();
    super.initState();
  }

  getData() async {
    await getEx();
    responseList.clear();
    if (finalisedCategory.toLowerCase() == 'stocks') {
      var url = baseurl + versionHome + tradeStocks;
      for (int i = 0; i < excNames.length; i++) {
        Map<String, dynamic> dataNew = {"category_id": mainCatIdList[0], "exchange_id": finalExchangeIdList[excIndex[i]], "limit": 20};
        ChartTopTrendingModel topTrend = await getTradeValues(data: dataNew, url: url);
        for (int j = 0; j < topTrend.response.length; j++) {
          watchStarList[i].add(topTrend.response[j].watchList);
        }
        responseList.add(topTrend);
      }
      setState(() {
        loader = true;
      });
    } else if (finalisedCategory.toLowerCase() == 'crypto') {
      var url = baseurl + versionHome + tradeCrypto;
      Map<String, dynamic> dataNew = {"category_id": mainCatIdList[1], "limit": 20};
      ChartTopTrendingModel topTrend = await getTradeValues(data: dataNew, url: url);
      for (int j = 0; j < topTrend.response.length; j++) {
        watchStarList[0].add(topTrend.response[j].watchList);
      }
      responseList.add(topTrend);
      setState(() {
        loader = true;
      });
    } else if (finalisedCategory.toLowerCase() == 'commodity') {
      var url = baseurl + versionHome + tradeCommodity;
      for (int i = 0; i < countryList.length; i++) {
        Map<String, dynamic> dataNew = {"category_id": mainCatIdList[2], "country": countryList[i], "limit": 20};
        ChartTopTrendingModel topTrend = await getTradeValues(data: dataNew, url: url);
        for (int j = 0; j < topTrend.response.length; j++) {
          watchStarList[i].add(topTrend.response[j].watchList);
        }
        responseList.add(topTrend);
        setState(() {
          loader = true;
        });
      }
    } else if (finalisedCategory.toLowerCase() == 'forex') {
      var url = baseurl + versionHome + tradeForex;
      Map<String, dynamic> dataNew = {"category_id": mainCatIdList[3], "limit": 20};
      ChartTopTrendingModel topTrend = await getTradeValues(data: dataNew, url: url);
      for (int j = 0; j < topTrend.response.length; j++) {
        watchStarList[0].add(topTrend.response[j].watchList);
      }
      responseList.add(topTrend);
      setState(() {
        loader = true;
      });
    } else {
      setState(() {
        loader = true;
      });
    }
  }

  getEx() async {
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          mainExchangeIdList.add(responseData["response"][i]["_id"]);
        }
      });
    } else {}
  }

  /*Future<bool> addWatchList({required String tickerId}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAdd;
    if(finalisedCategory.toLowerCase()=="stocks"){
      data = {
        "category_id": mainCatIdList[0],
        "exchange_id": finalChartExchange.value=="NSE"?mainExchangeIdList[1]:
        finalChartExchange.value=="BSE"?mainExchangeIdList[2]:mainExchangeIdList[0],
        "ticker_id": tickerId,
      };
    }else if(finalisedCategory.toLowerCase()=="crypto"){
      data = {
        "category_id": mainCatIdList[1],
        "ticker_id":tickerId,
      };
    }else if(finalisedCategory.toLowerCase()=="commodity"){
      data = {
        "category_id": mainCatIdList[2],
        "ticker_id": tickerId,
      };
    }else if(finalisedCategory.toLowerCase()=="forex"){
      data = {
        "category_id": mainCatIdList[3],
        "ticker_id": tickerId,
      };
    }else{
      data = {
        "category_id": finalisedCategory.toLowerCase(),
        "exchange_id": mainExchangeIdList[0],
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

  Future<bool> removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData["status"];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: finalisedCategory.toLowerCase() == "stocks"
                ? 3
                : finalisedCategory.toLowerCase() == "commodity"
                    ? 2
                    : 1,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: boolList[index]
                        ? flagMore[index]
                            ? height / 0.472
                            : height / 2.28
                        : height / 6.85,
                    child: ExpansionTile(
                      title: Text(
                        finalisedCategory.toLowerCase() == "stocks"
                            ? "${excNames[index]} Exchanges"
                            : finalisedCategory.toLowerCase() == "crypto"
                                ? "Crypto"
                                : finalisedCategory.toLowerCase() == "commodity"
                                    ? "${countryList[index]} "
                                    : "Forex",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10)),
                      ),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: boolInitialList[index],
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolInitialList[index] = true;
                            boolList[index] = value;
                          });
                        } else {
                          setState(() {
                            boolInitialList[index] = false;
                            boolList[index] = value;
                            flagMore[index] = false;
                          });
                        }
                      },
                      children: [
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: SizedBox(
                            height: flagMore[index] ? height / 0.506 : height / 3.425,
                            child: Column(
                              children: [
                                /*Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:_width/9.73,
                                      child: Center(
                                        child: Text(
                                          "Symbol    ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: _text.scale(10)8),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width:_width/10.95,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Price    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: _text.scale(10)8),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width:_width/17.52,
                                      child: Center(
                                        child: Text(
                                          "Watchlist",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: _text.scale(10)8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0.2,
                                ),*/
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: 20,
                                    itemBuilder: (BuildContext context, int index1) {
                                      return Container(
                                        height: height / 11.74,
                                        width: width,
                                        margin: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width / 9.73,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  responseList[index].response[index1].logoUrl.contains("svg")
                                                      ? SvgPicture.network(responseList[index].response[index1].logoUrl,
                                                          height: height / 20.55, width: width / 43.8, fit: BoxFit.fill)
                                                      : Image.network(responseList[index].response[index1].logoUrl,
                                                          height: height / 20.55, width: width / 43.8, fit: BoxFit.fill),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    responseList[index].response[index1].code,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600, fontSize: text.scale(8), overflow: TextOverflow.ellipsis),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 10.95,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      finalisedCategory.toLowerCase() == 'stocks'
                                                          ? index == 0 || index == 1
                                                              ? Text("\u{20B9}",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: text.scale(8),
                                                                      color: Colors.black,
                                                                      fontFamily: "Robonto"))
                                                              : Text("\$ ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(8),
                                                                      fontFamily: "Poppins",
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff000000)))
                                                          : finalisedCategory.toLowerCase() == 'commodity'
                                                              ? index == 0
                                                                  ? Text("\u{20B9}",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: text.scale(8),
                                                                          color: Colors.black,
                                                                          fontFamily: "Robonto"))
                                                                  : Text("\$ ",
                                                                      style: TextStyle(
                                                                          fontSize: text.scale(8),
                                                                          fontFamily: "Poppins",
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff000000)))
                                                              : Text("\$ ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(8),
                                                                      fontFamily: "Poppins",
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff000000))),
                                                      Text(
                                                        responseList[index].response[index1].close,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600, fontSize: text.scale(8), color: const Color(0xff000000)),
                                                      ),
                                                    ],
                                                  ),
                                                  responseList[index].response[index1].state == "Increse"
                                                      ? Text(
                                                          "+${responseList[index].response[index1].changeP}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600, fontSize: text.scale(8), color: const Color(0xff0EA102)),
                                                        )
                                                      : Text(
                                                          "-${responseList[index].response[index1].changeP}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600, fontSize: text.scale(8), color: const Color(0xffE3507A)),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            watchStarList[index][index1] == true
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                                      setState(() {
                                                        watchStarList[index][index1] = !watchStarList[index][index1];
                                                      });
                                                      await removeWatchList(tickerId: responseList[index].response[index1].id);
                                                    },
                                                    child: Container(
                                                        height: height / 20.55,
                                                        width: width / 43.8,
                                                        margin: EdgeInsets.symmetric(horizontal: width / 58.4),
                                                        child: SvgPicture.asset(
                                                          isDarkTheme.value
                                                              ? "assets/home_screen/filled_star_dark.svg"
                                                              : "lib/Constants/Assets/SMLogos/Star.svg",
                                                        )),
                                                  )
                                                : GestureDetector(
                                                    onTap: () async {
                                                      if (mainSkipValue) {
                                                        commonPopUpBar(context: context);
                                                      } else {
                                                        bool added = await apiFunctionsMain.getAddWatchList(
                                                            tickerId: responseList[index].response[index1].id,
                                                            context: context,
                                                            modelSetState: setState);
                                                        if (added) {
                                                          logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                                          setState(() {
                                                            watchStarList[index][index1] = !watchStarList[index][index1];
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                        height: height / 20.55,
                                                        width: width / 43.8,
                                                        margin: EdgeInsets.symmetric(horizontal: width / 58.4),
                                                        child: SvgPicture.asset(
                                                          isDarkTheme.value
                                                              ? "assets/home_screen/empty_star_dark.svg"
                                                              : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                                        )),
                                                  )
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  boolList[index]
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              flagMore[index] = !flagMore[index];
                            });
                          },
                          child: Text(
                            flagMore[index] ? "less..." : "more...",
                            style: TextStyle(fontSize: text.scale(8), color: const Color(0XFF000000)),
                          ),
                        )
                      : const SizedBox(),
                  index == 2
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(),
                ],
              );
            })
        : Center(
            child: Lottie.asset(
              'lib/Constants/Assets/SMLogos/loading.json',
              height: height / 8.22,
              width: width / 17.52,
            ),
          );
  }
}

class LockerWidget extends StatefulWidget {
  const LockerWidget({Key? key}) : super(key: key);

  @override
  State<LockerWidget> createState() => _LockerWidgetState();
}

class _LockerWidgetState extends State<LockerWidget> with TickerProviderStateMixin {
  late final TabController _tabController1;

  @override
  void initState() {
    _tabController1 = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        SizedBox(
          height: height / 13.7,
          child: TabBar(
            padding: EdgeInsets.zero,
            isScrollable: true,
            controller: _tabController1,
            unselectedLabelColor: const Color(0xffA9A9A9), //const Color(0XFF303030),
            labelColor: const Color(0XFF11AA04),
            indicatorColor: Colors.green,
            indicatorWeight: 1,
            dividerColor: Colors.transparent,
            dividerHeight: 0.0,
            tabs: [
              Tab(
                child: Text(
                  'News',
                  style: TextStyle(fontSize: text.scale(10)),
                ),
              ),
              Tab(
                child: Text(
                  'Videos',
                  style: TextStyle(fontSize: text.scale(10)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController1,
            children: const [LockerNewsWidget(), LockerVideosWidget()],
          ),
        )
      ],
    );
  }
}

class LockerNewsWidget extends StatefulWidget {
  const LockerNewsWidget({Key? key}) : super(key: key);

  @override
  State<LockerNewsWidget> createState() => _LockerNewsWidgetState();
}

class _LockerNewsWidgetState extends State<LockerNewsWidget> {
  bool loading = false;
  bool emptyBool = false;
  int newsInt = 0;
  List<String> timeList = [];
  List<String> newsImagesList = [];
  List<String> newsDescriptionList = [];
  List<String> newsSnippetList = [];
  List<String> newsSourceNameList = [];
  List<String> newsTitlesList = [];
  List<String> newsLinkList = [];
  List<String> newsIdList = [];
  List<int> newsLikeList = [];
  List<int> newsDislikeList = [];
  List<bool> newsUseList = [];
  List<bool> newsUseDisList = [];
  List<int> newsViewList = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  late Uri newLink;

  refreshGetNewsValues() async {
    newsInt = newsInt + 20;
    SingleTickerNewsModel? newsModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getNewsZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': finalisedCategory.toLowerCase(), 'search': "", 'skip': newsInt, 'ticker_id': finalChartTickerId.value});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (newsModel!.response.isEmpty) {
        setState(() {});
      } else {
        for (int i = 0; i < newsModel.response.length; i++) {
          newsImagesList.add(newsModel.response[i].imageUrl);
          newsDescriptionList.add(newsModelMain!.response[i].description);
          newsSnippetList.add(newsModelMain!.response[i].snippet);
          newsTitlesList.add(newsModel.response[i].title);
          newsSourceNameList.add(newsModel.response[i].sourceName);
          newsLinkList.add(newsModel.response[i].newsUrl);
          newsIdList.add(newsModel.response[i].id);
          newsLikeList.add(newsModel.response[i].likesCount);
          newsViewList.add(newsModel.response[i].viewsCount);
          newsDislikeList.add(newsModel.response[i].disLikesCount);
          newsUseList.add(newsModel.response[i].likes);
          newsUseDisList.add(newsModel.response[i].dislikes);
          DateTime dt = DateTime.parse(newsModel.response[i].date);
          final timestamp1 = dt.millisecondsSinceEpoch;
          readTimestamp(timestamp: timestamp1);
        }
        setState(() {});
        _refreshController.loadComplete();
      }
    }
  }

  Future<String> readTimestamp({required int timestamp}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    String time = '';
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
      {required String id, required String type, required String imageUrl, required String title, required String description}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/DemoPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Locker_News');
    toggleIndex.value == 1 ? getData2() : getData();
    super.initState();
  }

  getData() async {
    if (newsModelMain != null) {
      newsImagesList.clear();
      newsDescriptionList.clear();
      newsSnippetList.clear();
      newsSourceNameList.clear();
      newsTitlesList.clear();
      timeList.clear();
      newsLinkList.clear();
      newsIdList.clear();
      newsLikeList.clear();
      newsDislikeList.clear();
      newsUseList.clear();
      newsUseDisList.clear();
      newsViewList.clear();
      if (newsModelMain!.response.isEmpty) {
        setState(() {
          emptyBool = true;
          loading = true;
        });
      } else {
        for (int i = 0; i < newsModelMain!.response.length; i++) {
          newsImagesList.add(newsModelMain!.response[i].imageUrl);
          newsDescriptionList.add(newsModelMain!.response[i].description);
          newsSnippetList.add(newsModelMain!.response[i].snippet);
          newsTitlesList.add(newsModelMain!.response[i].title);
          newsSourceNameList.add(newsModelMain!.response[i].sourceName);
          newsLinkList.add(newsModelMain!.response[i].newsUrl);
          newsIdList.add(newsModelMain!.response[i].id);
          newsLikeList.add(newsModelMain!.response[i].likesCount);
          newsViewList.add(newsModelMain!.response[i].viewsCount);
          newsDislikeList.add(newsModelMain!.response[i].disLikesCount);
          newsUseList.add(newsModelMain!.response[i].likes);
          newsUseDisList.add(newsModelMain!.response[i].dislikes);
          DateTime dt = DateTime.parse(newsModelMain!.response[i].date);
          final timestamp1 = dt.millisecondsSinceEpoch;
          await readTimestamp(timestamp: timestamp1);
        }
        setState(() {
          emptyBool = false;
          loading = true;
        });
      }
    }
  }

  getData2() async {
    if (newsModelMain2 != null) {
      newsImagesList.clear();
      newsDescriptionList.clear();
      newsSnippetList.clear();
      newsSourceNameList.clear();
      newsTitlesList.clear();
      timeList.clear();
      newsLinkList.clear();
      newsIdList.clear();
      newsLikeList.clear();
      newsDislikeList.clear();
      newsUseList.clear();
      newsUseDisList.clear();
      newsViewList.clear();
      if (newsModelMain2!.response.isEmpty) {
        setState(() {
          emptyBool = true;
          loading = true;
        });
      } else {
        for (int i = 0; i < newsModelMain2!.response.length; i++) {
          newsImagesList.add(newsModelMain2!.response[i].imageUrl);
          newsDescriptionList.add(newsModelMain!.response[i].description);
          newsSnippetList.add(newsModelMain!.response[i].snippet);
          newsTitlesList.add(newsModelMain2!.response[i].title);
          newsSourceNameList.add(newsModelMain2!.response[i].sourceName);
          newsLinkList.add(newsModelMain2!.response[i].newsUrl);
          newsIdList.add(newsModelMain2!.response[i].id);
          newsLikeList.add(newsModelMain2!.response[i].likesCount);
          newsViewList.add(newsModelMain2!.response[i].viewsCount);
          newsDislikeList.add(newsModelMain2!.response[i].disLikesCount);
          newsUseList.add(newsModelMain2!.response[i].likes);
          newsUseDisList.add(newsModelMain2!.response[i].dislikes);
          DateTime dt = DateTime.parse(newsModelMain2!.response[i].date);
          final timestamp1 = dt.millisecondsSinceEpoch;
          readTimestamp(timestamp: timestamp1);
        }
        setState(() {
          emptyBool = false;
          loading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        loading
            ? emptyBool
                ? Column(
                    children: [
                      SizedBox(
                        height: height / 20.55,
                      ),
                      SizedBox(height: height / 6, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                      SizedBox(height: height / 33.83),
                      Text(
                        "Unfortunately, the content for the specified ticker is not available.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: text.scale(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: height / 102.75,
                      ),
                      Text(
                        "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: height / 102.75,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "You can try adjusting your filters or submit a new request for this item to be added on the ",
                              style: TextStyle(
                                  fontSize: text.scale(8),
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins")),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return const FeatureRequestPage(
                                    fromWhere: "finalCharts",
                                  );
                                }));
                              },
                            text: "Feature request page.",
                            style: TextStyle(
                                fontSize: text.scale(8), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                          ),
                        ]),
                      ),
                    ],
                  )
                : SizedBox(
                    height: height / 1.9,
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
                      onLoading: refreshGetNewsValues,
                      child: ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: newsImagesList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: height / 3,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

                                      /// need to change it soon
                                      /*await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return DemoPage(
                                          url: newsLinkList[index],
                                          text: newsTitlesList[index],
                                          image: "",
                                          id: newsIdList[index],
                                          type: 'news',
                                          activity: true,
                                          checkMain: false,
                                          fromWhere: "finalCharts",
                                        );
                                      }));*/
                                      Get.to(const DemoView(), arguments: {"id": newsIdList[index], "type": "news", "url": ""});
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          height: height / 4.77,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 0, blurRadius: 4, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5))
                                            ],
                                            image: DecorationImage(
                                              image: NetworkImage(newsImagesList[index]),
                                              fit: BoxFit.fill,
                                            ),
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                          ),
                                        ),
                                        Container(
                                          height: height / 10.97,
                                          width: width,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.black12.withOpacity(0.3),
                                          ),
                                          child: Text(
                                            newsTitlesList[index],
                                            style: TextStyle(
                                                fontSize: text.scale(12), color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height / 9.2,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(spreadRadius: 0, blurRadius: 4, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5))
                                        ]),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
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
                                                  newsSourceNameList[index],
                                                  style: TextStyle(
                                                      fontSize: text.scale(10),
                                                      color: const Color(0XFFF7931A),
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: "Poppins"),
                                                ),
                                                SizedBox(
                                                  height: height / 82.2,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      timeList[index],
                                                      style: TextStyle(
                                                          fontSize: text.scale(7),
                                                          color: const Color(0XFFB0B0B0),
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "Poppins"),
                                                    ),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    InkWell(
                                                      onTap: mainSkipValue
                                                          ? () {
                                                              commonPopUpBar(context: context);
                                                            }
                                                          : () async {
                                                              setState(() {
                                                                kUserSearchController.clear();
                                                                onTapType = "liked";
                                                                onTapId = newsIdList[index];
                                                                onLike = true;
                                                                onDislike = false;
                                                                idKeyMain = "news_id";
                                                                apiMain = baseurl + versionLocker + newsLikeDislikeCount;
                                                                onTapIdMain = newsIdList[index];
                                                                onTapTypeMain = "liked";
                                                                haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                likesCountMain = newsLikeList[index];
                                                                dislikesCountMain = newsDislikeList[index];
                                                                kToken = mainUserToken;
                                                                loaderMain = false;
                                                              });
                                                              await customShowSheetNew3(
                                                                context: context,
                                                                responseCheck: 'feature',
                                                              );
                                                            },
                                                      child: Text(
                                                        "${newsLikeList[index]} Likes",
                                                        style: TextStyle(
                                                            fontSize: text.scale(7),
                                                            color: const Color(0XFFB0B0B0),
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: "Poppins"),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    InkWell(
                                                      onTap: mainSkipValue
                                                          ? () {
                                                              commonPopUpBar(context: context);
                                                            }
                                                          : () async {
                                                              setState(() {
                                                                kUserSearchController.clear();
                                                                onTapType = "disliked";
                                                                onTapId = newsIdList[index];
                                                                onLike = false;
                                                                onDislike = true;
                                                                idKeyMain = "news_id";
                                                                apiMain = baseurl + versionLocker + newsLikeDislikeCount;
                                                                onTapIdMain = newsIdList[index];
                                                                onTapTypeMain = "disliked";
                                                                haveLikesMain = newsLikeList[index] > 0 ? true : false;
                                                                haveDisLikesMain = newsDislikeList[index] > 0 ? true : false;
                                                                likesCountMain = newsLikeList[index];
                                                                dislikesCountMain = newsDislikeList[index];
                                                                kToken = mainUserToken;
                                                                loaderMain = false;
                                                              });
                                                              await customShowSheetNew3(
                                                                context: context,
                                                                responseCheck: 'feature',
                                                              );
                                                            },
                                                      child: Text(
                                                        "${newsDislikeList[index]} Dislikes",
                                                        style: TextStyle(
                                                            fontSize: text.scale(7),
                                                            color: const Color(0XFFB0B0B0),
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: "Poppins"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            width: width / 10.95,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: mainSkipValue
                                                        ? () {
                                                            commonPopUpBar(context: context);
                                                          }
                                                        : () async {
                                                            bool response1 = await likeFunction(id: newsIdList[index], type: "news");
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
                                                              height: height / 27.4,
                                                              width: width / 58.4)
                                                          : SvgPicture.asset(
                                                              isDarkTheme.value
                                                                  ? "assets/home_screen/like_dark.svg"
                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                              height: height / 27.4,
                                                              width: width / 58.4,
                                                            ),
                                                    )),
                                                SizedBox(width: width / 87.6),
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
                                                      height: height / 27.4,
                                                      width: width / 58.4,
                                                    )),
                                                SizedBox(width: width / 87.6),
                                                GestureDetector(
                                                  onTap: mainSkipValue
                                                      ? () {
                                                          commonPopUpBar(context: context);
                                                        }
                                                      : () async {
                                                          bool response3 = await disLikeFunction(id: newsIdList[index], type: "news");
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
                                                          height: height / 27.4,
                                                          width: width / 58.4,
                                                        )
                                                      : SvgPicture.asset(
                                                          isDarkTheme.value
                                                              ? "assets/home_screen/dislike_dark.svg"
                                                              : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                          height: height / 27.4,
                                                          width: width / 58.4,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  )
            : Expanded(
                child: Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.22, width: width / 17.52),
                ),
              ),
      ],
    );
  }
}

class LockerVideosWidget extends StatefulWidget {
  const LockerVideosWidget({Key? key}) : super(key: key);

  @override
  State<LockerVideosWidget> createState() => _LockerVideosWidgetState();
}

class _LockerVideosWidgetState extends State<LockerVideosWidget> {
  bool loading = false;
  bool emptyBool = false;
  String mainUserToken = "";
  List<String> videosIdList = [];
  List<int> videosLikeList = [];
  List<int> videosDislikeList = [];
  List<bool> videosUseDisList = [];
  List<bool> videosUseList = [];
  List<String> likeValue = [];
  List<String> disLikeValue = [];
  List<String> videosImagesList = [];
  List<String> videosSourceNameList = [];
  List<String> videosTitlesList = [];
  List<String> videosTimeList = [];
  List<String> videosLinkList = [];
  List<int> videosViewList = [];
  List<String> videosTickerIdList = [];
  int videosInt = 0;
  late Uri newLink;

  final RefreshController _refreshController1 = RefreshController(initialRefresh: false);

  getVideosValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getVideosZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': finalisedCategory.toLowerCase(), 'search': "", 'skip': '0', 'ticker_id': finalChartTickerId.value});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      videosIdList.clear();
      videosLikeList.clear();
      videosDislikeList.clear();
      videosUseDisList.clear();
      videosUseList.clear();
      likeValue.clear();
      disLikeValue.clear();
      videosImagesList.clear();
      videosSourceNameList.clear();
      videosTitlesList.clear();
      videosTimeList.clear();
      videosLinkList.clear();
      videosViewList.clear();
      videosTickerIdList.clear();
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool = true;
          loading = true;
        });
      } else {
        for (int i = 0; i < responseData["response"].length; i++) {
          videosImagesList.add(responseData["response"][i]["image_url"]);
          videosTitlesList.add(responseData["response"][i]["title"]);
          videosSourceNameList.add(responseData["response"][i]["source_name"]);
          videosViewList.add(responseData["response"][i]["views_count"]);
          videosLinkList.add(responseData["response"][i]["news_url"]);
          videosIdList.add(responseData["response"][i]["_id"]);
          videosTickerIdList.add(responseData["response"][i]["ticker_id"]);
          videosLikeList.add(responseData["response"][i]["likes_count"]);
          videosDislikeList.add(responseData["response"][i]["dis_likes_count"]);
          videosUseList.add(responseData["response"][i]["likes"]);
          videosUseDisList.add(responseData["response"][i]["dislikes"]);
          DateTime dt = DateTime.parse(responseData["response"][i]["date"]);
          final timestamp1 = dt.millisecondsSinceEpoch;
          readTimestamp(timestamp: timestamp1);
        }
        setState(() {
          emptyBool = false;
          loading = true;
        });
      }
    }
  }

  refreshGetVideosValues() async {
    videosInt = videosInt + 20;
    var url = Uri.parse(baseurl + versionLocker + getVideosZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': finalisedCategory.toLowerCase(), 'search': "", 'skip': videosInt, 'ticker_id': finalChartTickerId.value});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {});
      } else {
        for (int i = 0; i < responseData["response"].length; i++) {
          videosImagesList.add(responseData["response"][i]["image_url"]);
          videosTitlesList.add(responseData["response"][i]["title"]);
          videosSourceNameList.add(responseData["response"][i]["source_name"]);
          videosViewList.add(responseData["response"][i]["views_count"]);
          videosLinkList.add(responseData["response"][i]["news_url"]);
          videosIdList.add(responseData["response"][i]["_id"]);
          videosTickerIdList.add(responseData["response"][i]["ticker_id"]);
          videosLikeList.add(responseData["response"][i]["likes_count"]);
          videosDislikeList.add(responseData["response"][i]["dis_likes_count"]);
          videosUseList.add(responseData["response"][i]["likes"]);
          videosUseDisList.add(responseData["response"][i]["dislikes"]);
          DateTime dt = DateTime.parse(responseData["response"][i]["date"]);
          final timestamp1 = dt.millisecondsSinceEpoch;
          readTimestamp(timestamp: timestamp1);
        }
      }
    }
  }

  String readTimestamp({required int timestamp}) {
    String time = '';
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
      videosTimeList.add(time);
    });
    return time;
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
      {required String id, required String type, required String imageUrl, required String title, required String description}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/VideoDescriptionPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Locker_Videos');
    getData();
    super.initState();
  }

  getData() async {
    await getVideosValues();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        loading
            ? Column(
                children: [
                  SizedBox(height: height / 50.75),
                  emptyBool
                      ? Column(
                          children: [
                            SizedBox(
                              height: height / 20.55,
                            ),
                            SizedBox(height: height / 6, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                            SizedBox(height: height / 33.83),
                            Text(
                              "Unfortunately, the content for the specified ticker is not available.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: text.scale(10),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: height / 102.75,
                            ),
                            Text(
                              "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: height / 102.75,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                    style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600, fontFamily: "Poppins")),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return const FeatureRequestPage(
                                          fromWhere: "finalCharts",
                                        );
                                      }));
                                    },
                                  text: "Feature request page.",
                                  style: TextStyle(
                                      fontSize: text.scale(8), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                                ),
                              ]),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: height / 1.95,
                          child: SmartRefresher(
                            controller: _refreshController1,
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
                            onLoading: refreshGetVideosValues,
                            child: ListView.builder(
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: videosImagesList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: height / 3,
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return YoutubePlayerLandscapeScreen(
                                                    id: videosIdList[index],
                                                    comeFrom: "finalCharts",
                                                  );
                                                }));
                                              },
                                              child: Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  Container(
                                                    height: height / 4.77,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 0,
                                                            blurRadius: 4,
                                                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5))
                                                      ],
                                                      image: DecorationImage(
                                                        image: NetworkImage(videosImagesList[index]),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius:
                                                          const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: width / 7.5,
                                                            height: height / 16.24,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.black26.withOpacity(0.3),
                                                            ),
                                                            child: const Center(
                                                                child: Icon(
                                                              Icons.play_arrow,
                                                              color: Colors.white,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height / 82.2,
                                                      ),
                                                      Container(
                                                        height: height / 10.97,
                                                        width: width,
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                        ),
                                                        child: Text(
                                                          videosTitlesList[index],
                                                          style: TextStyle(
                                                              fontSize: text.scale(10),
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: "Poppins"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: height / 9,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 4,
                                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5))
                                                  ]),
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(vertical: 5),
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
                                                            videosSourceNameList[index],
                                                            style: TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0XFFF7931A),
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: "Poppins"),
                                                          ),
                                                          SizedBox(
                                                            height: height / 82.2,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                videosTimeList[index],
                                                                style: TextStyle(
                                                                    fontSize: text.scale(7),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: "Poppins"),
                                                              ),
                                                              SizedBox(
                                                                width: width / 438,
                                                              ),
                                                              InkWell(
                                                                onTap: mainSkipValue
                                                                    ? () {
                                                                        commonPopUpBar(context: context);
                                                                      }
                                                                    : () async {
                                                                        setState(() {
                                                                          kUserSearchController.clear();
                                                                          onTapType = "Views";
                                                                          onTapId = videosIdList[index];
                                                                          onLike = false;
                                                                          onDislike = false;
                                                                          onViews = true;
                                                                          idKeyMain = "video_id";
                                                                          apiMain = baseurl + versionLocker + videoViewCount;
                                                                          onTapIdMain = videosIdList[index];
                                                                          onTapTypeMain = "Views";
                                                                          haveLikesMain = videosLikeList[index] > 0 ? true : false;
                                                                          haveDisLikesMain = videosDislikeList[index] > 0 ? true : false;
                                                                          haveViewsMain = videosViewList[index] > 0 ? true : false;
                                                                          likesCountMain = videosLikeList[index];
                                                                          dislikesCountMain = videosDislikeList[index];
                                                                          viewCountMain = videosViewList[index];
                                                                          kToken = mainUserToken;
                                                                        });
                                                                        //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionLocker + videoViewCount, idKey: 'video_id', setState: setState);
                                                                        bool data = await likeCountFunc(context: context, newSetState: setState);
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
                                                                child: Text(
                                                                  "${videosViewList[index]} Views",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(7),
                                                                      color: const Color(0XFFB0B0B0),
                                                                      fontWeight: FontWeight.w600,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: width / 109.5),
                                                      width: width / 10.95,
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: mainSkipValue
                                                                  ? () {
                                                                      commonPopUpBar(context: context);
                                                                    }
                                                                  : () async {
                                                                      bool response1 = await likeFunction(id: videosIdList[index], type: "videos");
                                                                      if (response1) {
                                                                        logEventFunc(name: "Likes", type: "Videos");
                                                                        setState(() {
                                                                          if (videosUseList[index] == true) {
                                                                            if (videosUseDisList[index] == true) {
                                                                            } else {
                                                                              videosLikeList[index] -= 1;
                                                                            }
                                                                          } else {
                                                                            if (videosUseDisList[index] == true) {
                                                                              videosDislikeList[index] -= 1;
                                                                              videosLikeList[index] += 1;
                                                                            } else {
                                                                              videosLikeList[index] += 1;
                                                                            }
                                                                          }
                                                                          videosUseList[index] = !videosUseList[index];
                                                                          videosUseDisList[index] = false;
                                                                        });
                                                                      } else {}
                                                                    },
                                                              child: Container(
                                                                child: videosUseList[index]
                                                                    ? SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                        height: 15,
                                                                        width: 15)
                                                                    : SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                        height: height / 27.4,
                                                                        width: width / 58.4,
                                                                      ),
                                                              )),
                                                          SizedBox(width: width / 87.6),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                logEventFunc(name: 'Share', type: 'Videos');
                                                                newLink = await getLinK(
                                                                    id: videosIdList[index],
                                                                    type: "videos",
                                                                    description: '',
                                                                    imageUrl: videosImagesList[index],
                                                                    title: videosTitlesList[index]);
                                                                ShareResult result = await Share.share(
                                                                  "Look what I was able to find on Tradewatch: ${videosTitlesList[index]} ${newLink.toString()}",
                                                                );
                                                                if (result.status == ShareResultStatus.success) {
                                                                  await shareFunction(id: videosIdList[index], type: "videos");
                                                                }
                                                              },
                                                              child: SvgPicture.asset(
                                                                isDarkTheme.value
                                                                    ? "assets/home_screen/share_dark.svg"
                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                height: height / 27.4,
                                                                width: width / 58.4,
                                                              )),
                                                          SizedBox(width: width / 87.6),
                                                          GestureDetector(
                                                            onTap: mainSkipValue
                                                                ? () {
                                                                    commonPopUpBar(context: context);
                                                                  }
                                                                : () async {
                                                                    bool response3 = await disLikeFunction(id: videosIdList[index], type: "videos");
                                                                    if (response3) {
                                                                      logEventFunc(name: "Dislikes", type: "Videos");
                                                                      setState(() {
                                                                        if (videosUseDisList[index] == true) {
                                                                          if (videosUseList[index] == true) {
                                                                          } else {
                                                                            videosDislikeList[index] -= 1;
                                                                          }
                                                                        } else {
                                                                          if (videosUseList[index] == true) {
                                                                            videosLikeList[index] -= 1;
                                                                            videosDislikeList[index] += 1;
                                                                          } else {
                                                                            videosDislikeList[index] += 1;
                                                                          }
                                                                        }
                                                                        videosUseDisList[index] = !videosUseDisList[index];
                                                                        videosUseList[index] = false;
                                                                      });
                                                                    } else {}
                                                                  },
                                                            child: videosUseDisList[index]
                                                                ? SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/dislike_filled_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                    height: height / 27.4,
                                                                    width: width / 58.4,
                                                                  )
                                                                : SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/dislike_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                    height: height / 27.4,
                                                                    width: width / 58.4,
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 33.83,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        )
                ],
              )
            : Expanded(
                child: Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.22, width: width / 17.52),
                ),
              ),
      ],
    );
  }
}

class Financial extends StatefulWidget {
  final bool fromWhere;

  const Financial({Key? key, required this.fromWhere}) : super(key: key);

  @override
  State<Financial> createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {
  List<bool> boolList = List.generate(8, (index) => index == 0 ? true : false);
  bool loader = false;
  OverViewModel? _overView;

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Financial');
    super.initState();
    getAllData();
  }

  getAllData() async {
    if (widget.fromWhere) {
      Future.delayed(const Duration(milliseconds: 100), () {
        mainVariables.selectedControllerIndex.value = 4;
      });
    }
    _overView = await getOverViewData(tickerId: finalChartTickerId.value == "" ? mainVariables.selectedTickerId.value : finalChartTickerId.value);
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loader
        ? SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(widget.fromWhere ? 15 : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "General Information",
                            style: TextStyle(
                              fontSize: widget.fromWhere ? 16 : 10,
                              fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                            ),
                          ),
                          boolList[0]
                              ? Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      iconColor: const Color(0xFF6C6C6C),
                      collapsedIconColor: const Color(0xFF6C6C6C),
                      initiallyExpanded: boolList[0],
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolList[0] = value;
                          });
                        } else {
                          setState(() {
                            boolList[0] = value;
                          });
                        }
                      },
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Code",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.code,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.name,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Address",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.fullAddress,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Web URL",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.webUrl,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Phone",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.phone,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Exchange",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.exchange,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "currency",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "\$ ${_overView!.response.close}",
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "country information",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.country,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Sector/industry",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.industry,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  _overView!.response.highlights.status
                      ? Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Highlights",
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 16 : 10,
                                    fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                                  ),
                                ),
                                boolList[1]
                                    ? Divider(
                                        color: Colors.grey.shade100,
                                        thickness: 1,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            iconColor: const Color(0xFF6C6C6C),
                            collapsedIconColor: const Color(0xFF6C6C6C),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            initiallyExpanded: boolList[1],
                            onExpansionChanged: (value) {
                              if (value) {
                                setState(() {
                                  boolList[1] = value;
                                });
                              } else {
                                setState(() {
                                  boolList[1] = value;
                                });
                              }
                            },
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Market capitalization(M)",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.marketCapitalizationMln,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "EBITDA",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.ebitda,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "PERatio",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.peRatio,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "PEGRatio",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.pegRatio,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Wall street target price",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.wallStreetTargetPrice,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Book value",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.bookValue,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Dividend Share",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.dividendShare,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Dividend yield",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.dividendYield,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Earnings share",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.earningsShare,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "EPS estimate current year",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.epsEstimateCurrentYear,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "EPS estimate next year",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.epsEstimateNextYear,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "EPS estimate next quarter",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.epsEstimateNextQuarter,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "EPS estimate current quarter",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.epsEstimateCurrentQuarter,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Most recent quarter",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.mostRecentQuarter.toString().substring(0, 10),
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Profit margin",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.profitMargin,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Operating Margin TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.operatingMarginTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Return On Assets TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.country,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Return on equity TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.returnOnEquityTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Revenue TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.revenueTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Revenue per share TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.revenuePerShareTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Quarterly revenue growth",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.quarterlyRevenueGrowthYoy,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Gross profit TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.grossProfitTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Diluted Eps TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.dilutedEpsTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Quarterly earnings growth",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.highlights.quarterlyEarningsGrowthYoy,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  _overView!.response.valuation.status
                      ? Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Valuation",
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 16 : 10,
                                    fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                                  ),
                                ),
                                boolList[2]
                                    ? Divider(
                                        color: Colors.grey.shade100,
                                        thickness: 1,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            iconColor: const Color(0xFF6C6C6C),
                            collapsedIconColor: const Color(0xFF6C6C6C),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            initiallyExpanded: boolList[2],
                            onExpansionChanged: (value) {
                              if (value) {
                                setState(() {
                                  boolList[2] = value;
                                });
                              } else {
                                setState(() {
                                  boolList[2] = value;
                                });
                              }
                            },
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Trailing PE",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.trailingPe,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Forward PE",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.forwardPe,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Price sales TTM",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.priceSalesTtm,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Price Book MRQ",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.priceBookMrq,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Enterprise value",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.enterpriseValue,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Enterprise value revenue",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.enterpriseValueRevenue,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widget.fromWhere ? width / 4 : width / 8,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Enterprise value Ebitda",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 14 : 8,
                                            fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                          ),
                                        )),
                                        SizedBox(
                                            width: 1,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                fontSize: widget.fromWhere ? 14 : 8,
                                                fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        _overView!.response.valuation.enterpriseValueEbitda,
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Key Financial Ratios",
                            style: TextStyle(
                              fontSize: widget.fromWhere ? 16 : 10,
                              fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                            ),
                          ),
                          boolList[3]
                              ? Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      iconColor: const Color(0xFF6C6C6C),
                      collapsedIconColor: const Color(0xFF6C6C6C),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: boolList[3],
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolList[3] = value;
                          });
                        } else {
                          setState(() {
                            boolList[3] = value;
                          });
                        }
                      },
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "EPS",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.epse,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Dividend yield",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.forwardAnnualDividendYield,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Payout ratio",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.payoutRatio,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Share Statistics",
                            style: TextStyle(
                              fontSize: widget.fromWhere ? 16 : 10,
                              fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                            ),
                          ),
                          boolList[4]
                              ? Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      iconColor: const Color(0xFF6C6C6C),
                      collapsedIconColor: const Color(0xFF6C6C6C),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: boolList[4],
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolList[4] = value;
                          });
                        } else {
                          setState(() {
                            boolList[4] = value;
                          });
                        }
                      },
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Shares outstanding",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.sharesOutStanding,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Shares Float",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.sharesFloat,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Percent Held by Insiders",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.percentInsiders,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Percent Held by Institutions",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.percentInstitutions,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Technical Indicators",
                            style: TextStyle(
                              fontSize: widget.fromWhere ? 16 : 10,
                              fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                            ),
                          ),
                          boolList[5]
                              ? Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      iconColor: const Color(0xFF6C6C6C),
                      collapsedIconColor: const Color(0xFF6C6C6C),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: boolList[5],
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolList[5] = value;
                          });
                        } else {
                          setState(() {
                            boolList[5] = value;
                          });
                        }
                      },
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Beta",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.beta,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "52 Week high/low",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "${_overView!.response.weekHigh}/${_overView!.response.weekLow}",
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "50 day moving average",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.fiftyDayMa,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "200 day moving average",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.twoHundredDayMa,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Splits and Dividends",
                            style: TextStyle(
                              fontSize: widget.fromWhere ? 16 : 10,
                              fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                            ),
                          ),
                          boolList[6]
                              ? Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      iconColor: const Color(0xFF6C6C6C),
                      collapsedIconColor: const Color(0xFF6C6C6C),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: boolList[6],
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolList[6] = value;
                          });
                        } else {
                          setState(() {
                            boolList[6] = value;
                          });
                        }
                      },
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Dividend rate yield",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.forwardAnnualDividendRate,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Last split factor and split date",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "${_overView!.response.lastSplitFactor} / ${_overView!.response.lastSplitDate}",
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Earnings Reports (Quarterly and Annual)",
                            style: TextStyle(
                              fontSize: widget.fromWhere ? 16 : 10,
                              fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                            ),
                          ),
                          boolList[7]
                              ? Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      iconColor: const Color(0xFF6C6C6C),
                      collapsedIconColor: const Color(0xFF6C6C6C),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: boolList[7],
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            boolList[7] = value;
                          });
                        } else {
                          setState(() {
                            boolList[7] = value;
                          });
                        }
                      },
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.earnings.date.toString().substring(0, 10),
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.fromWhere ? width / 4 : width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Eps actual",
                                    style: TextStyle(
                                      fontSize: widget.fromWhere ? 14 : 8,
                                      fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                    ),
                                  )),
                                  SizedBox(
                                      width: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: widget.fromWhere ? 14 : 8,
                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  _overView!.response.earnings.epsActual,
                                  style: TextStyle(
                                    fontSize: widget.fromWhere ? 14 : 8,
                                    fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            height: height,
            width: width,
            child: Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                  height: widget.fromWhere ? 100 : height / 8.22, width: widget.fromWhere ? 100 : width / 17.52),
            ),
          );
  }
}

class ReportsWidget extends StatefulWidget {
  final bool fromWhere;

  const ReportsWidget({Key? key, required this.fromWhere}) : super(key: key);

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  List<bool> boolList = List.generate(3, (index) => index == 0 ? true : false);
  bool loader = false;
  OverViewModel? _overView;

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Repost');
    super.initState();
    getAllData();
  }

  getAllData() async {
    if (widget.fromWhere) {
      Future.delayed(const Duration(milliseconds: 100), () {
        mainVariables.selectedControllerIndex.value = 5;
        mainVariables.selectedUserControllerIndex.value = 3;
      });
    }
    _overView = await getOverViewData(tickerId: finalChartTickerId.value == "" ? mainVariables.selectedTickerId.value : finalChartTickerId.value);
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loader
        ? Obx(() => checkIndexExchange.value
            ? SizedBox(
                height: height,
                width: width,
                child: Center(
                  child: SizedBox(
                    width: widget.fromWhere ? 300 : 180,
                    child: Text(
                      "Currently financial reports are not available for this Ticker",
                      style: TextStyle(fontSize: widget.fromWhere ? 16 : 10, fontWeight: FontWeight.w400, color: const Color(0XFF0EA102)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(widget.fromWhere ? 15 : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _overView!.response.balanceSheet.status
                          ? Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Balance sheet",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 16 : 10,
                                            fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                                          ),
                                        ),
                                        Text(
                                          _overView!.response.balanceSheet.date.toString().substring(0, 10),
                                          style: TextStyle(
                                              fontSize: widget.fromWhere ? 14 : 8,
                                              fontWeight: FontWeight.w400,
                                              /*color: const Color(0XFF3B4143)*/
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                    boolList[0]
                                        ? Divider(
                                            color: Colors.grey.shade100,
                                            thickness: 1,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                iconColor: const Color(0xFF6C6C6C),
                                collapsedIconColor: const Color(0xFF6C6C6C),
                                initiallyExpanded: boolList[0],
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                onExpansionChanged: (value) {
                                  if (value) {
                                    setState(() {
                                      boolList[0] = value;
                                    });
                                  } else {
                                    setState(() {
                                      boolList[0] = value;
                                    });
                                  }
                                },
                                children: [
                                  _overView!.response.balanceSheet.assets.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Assets",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total assets",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.totalAssets,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Intangible assets",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.intangibleAssets,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Other current assets",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.otherCurrentAssets,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total current assets",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.totalCurrentAssets,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Short term investments",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.shortTermInvestments,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net receivables",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.netReceivables,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Inventory",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.inventory,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Non current assets other",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.nonCurrentAssetsOther,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Property plant and equipment net",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.propertyPlantAndEquipmentNet,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Cash and short term investments",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.assets.cashAndShortTermInvestments,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.balanceSheet.liabilities.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Liabilities",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total liabilities",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.totalLiab,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Other current liabilities",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.otherCurrentLiab,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total current liabilities",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.totalCurrentLiabilities,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net debt",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.netDebt,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Short term debt",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.shortTermDebt,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Short long term debt total",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.shortLongTermDebtTotal,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Long term debt",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.longTermDebt,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Accounts payable",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.accountsPayable,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Capital lease obligations",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.capitalLeaseObligations,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Non current liabilities total",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.liabilities.nonCurrentLiabilitiesTotal,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.balanceSheet.equity.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Equity",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total stockholder equity",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.equity.totalStockholderEquity,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Common stock",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.equity.commonStock,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Other stockholder equity",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.equity.otherStockholderEquity,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Liabilities & Stockholders equity",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.equity.liabilitiesAndStockholdersEquity,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.balanceSheet.others.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Others",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Networking capital",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.others.netWorkingCapital,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net invested capital",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.others.netInvestedCapital,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Common stock shares outstanding",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.balanceSheet.others.commonStockSharesOutstanding,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      _overView!.response.cashFlow.status
                          ? Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Cash flow",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 16 : 10,
                                            fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                                          ),
                                        ),
                                        Text(
                                          _overView!.response.cashFlow.date.toString().substring(0, 10),
                                          style: TextStyle(
                                              fontSize: widget.fromWhere ? 14 : 8,
                                              fontWeight: FontWeight.w400,
                                              /*color: const Color(0XFF3B4143)*/
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                    boolList[1]
                                        ? Divider(
                                            color: Colors.grey.shade100,
                                            thickness: 1,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                iconColor: const Color(0xFF6C6C6C),
                                collapsedIconColor: const Color(0xFF6C6C6C),
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                initiallyExpanded: boolList[1],
                                onExpansionChanged: (value) {
                                  if (value) {
                                    setState(() {
                                      boolList[1] = value;
                                    });
                                  } else {
                                    setState(() {
                                      boolList[1] = value;
                                    });
                                  }
                                },
                                children: [
                                  _overView!.response.cashFlow.operating.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Operating",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net income",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.operating.netIncome,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Depreciation",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.operating.depreciation,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Change in working capital",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.operating.changeInWorkingCapital,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total cash from operating activities",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.operating.totalCashFromOperatingActivities,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.cashFlow.investing.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Investing",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Investments",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.investing.investments,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Capital Expenditures",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.investing.capitalExpenditures,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total cash Flows from investing activities",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.investing.totalCashFlowsFromInvestingActivities,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.cashFlow.financing.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Financing",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Dividends paid",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.financing.dividendsPaid,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Issuance of capital stock",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.financing.issuanceOfCapitalStock,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Sale purchase of stock",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.financing.salePurchaseOfStock,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net borrowings",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.financing.netBorrowings,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total cash from financing activities",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.financing.totalCashFromFinancingActivities,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.cashFlow.othersCashFlow.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Others",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Change in cash",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.othersCashFlow.changeInCash,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Begin period cash flow",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.othersCashFlow.beginPeriodCashFlow,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "End period cash flow",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.othersCashFlow.endPeriodCashFlow,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Free cash flow",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.cashFlow.othersCashFlow.freeCashFlow,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      _overView!.response.incomeStatement.status
                          ? Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Income Statement",
                                          style: TextStyle(
                                            fontSize: widget.fromWhere ? 16 : 10,
                                            fontWeight: FontWeight.w600, /*color: const Color(0XFF3B4143)*/
                                          ),
                                        ),
                                        Text(
                                          _overView!.response.incomeStatement.date.toString().substring(0, 10),
                                          style: TextStyle(
                                              fontSize: widget.fromWhere ? 14 : 8,
                                              fontWeight: FontWeight.w400,
                                              /*color: const Color(0XFF3B4143)*/
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                    boolList[2]
                                        ? Divider(
                                            color: Colors.grey.shade100,
                                            thickness: 1,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                iconColor: const Color(0xFF6C6C6C),
                                collapsedIconColor: const Color(0xFF6C6C6C),
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                initiallyExpanded: boolList[2],
                                onExpansionChanged: (value) {
                                  if (value) {
                                    setState(() {
                                      boolList[2] = value;
                                    });
                                  } else {
                                    setState(() {
                                      boolList[2] = value;
                                    });
                                  }
                                },
                                children: [
                                  _overView!.response.incomeStatement.revenueCostOfRevenue.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Revenue cost of revenue",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total revenue",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.revenueCostOfRevenue.totalRevenue,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Cost of revenue",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.revenueCostOfRevenue.costOfRevenue,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Gross profit",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.revenueCostOfRevenue.grossProfit,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.incomeStatement.operatingExpenses.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Operating expenses",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Selling general administrative",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.operatingExpenses.sellingGeneralAdministrative,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total operating expenses",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.operatingExpenses.totalOperatingExpenses,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Operating income",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.operatingExpenses.operatingIncome,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.incomeStatement.nonOperatingExpenses.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Non operating expenses",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Interest expense",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.nonOperatingExpenses.interestExpense,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total other income expense net",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.nonOperatingExpenses.totalOtherIncomeExpenseNet,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  _overView!.response.incomeStatement.profitability.status
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Profitability",
                                                  style: TextStyle(
                                                    fontSize: widget.fromWhere ? 16 : 10,
                                                    fontWeight: FontWeight.w600, /*color: const Color(0xFF353737)*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Ebit",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.profitability.ebit,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Ebitda",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.profitability.ebitda,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Income before tax",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.profitability.incomeBeforeTax,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Income tax expense",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.profitability.incomeTaxExpense,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net income from continuing ops",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.profitability.netIncomeFromContinuingOps,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: widget.fromWhere ? width / 4 : width / 8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Net income",
                                                        style: TextStyle(
                                                          fontSize: widget.fromWhere ? 14 : 8,
                                                          fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: 1,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: widget.fromWhere ? 14 : 8,
                                                              fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text(
                                                      _overView!.response.incomeStatement.profitability.netIncome,
                                                      style: TextStyle(
                                                        fontSize: widget.fromWhere ? 14 : 8,
                                                        fontWeight: FontWeight.w500, /*color: const Color(0xFF353737)*/
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ))
        : SizedBox(
            height: height,
            width: width,
            child: Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                  height: widget.fromWhere ? 100 : height / 8.22, width: widget.fromWhere ? 100 : width / 17.52),
            ),
          );
  }
}

class ForumWidget extends StatefulWidget {
  const ForumWidget({Key? key}) : super(key: key);

  @override
  State<ForumWidget> createState() => _ForumWidgetState();
}

class _ForumWidgetState extends State<ForumWidget> {
  bool loading = false;
  bool emptyBool = false;
  String mainUserToken = "";
  String mainUserId = "";
  String mainTopic = "";
  final RefreshController _refreshController2 = RefreshController(initialRefresh: false);
  List<String> forumImagesList = [];
  List<String> forumSourceNameList = [];
  List<String> forumTitlesList = [];
  List<String> forumCategoryList = [];
  List<String> forumIdList = [];
  List<int> forumLikeList = [];
  List<int> forumDislikeList = [];
  List<bool> forumUseList = [];
  List<bool> forumUseDisList = [];
  List<bool> forumMyList = [];
  List<int> forumViewsList = [];
  List<int> forumResponseList = [];
  List<String> forumUserIdList = [];
  List<dynamic> forumObjectList = [];
  List<String> forumCompanyList = [];
  late Uri newLink;
  int newsInt = 0;
  int selectedIndex = 0;
  String selectedValue = "Latest Topics";
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

  getForumValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    mainUserId = prefs.getString('newUserId') ?? "";
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': finalisedCategory.toLowerCase(), 'search': "", 'skip': '0', 'type': selectedValue, 'ticker_id': finalChartTickerId.value});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      forumImagesList.clear();
      forumSourceNameList.clear();
      forumTitlesList.clear();
      forumCategoryList.clear();
      forumIdList.clear();
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
      mainTopic = responseData["type"];
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            emptyBool = true;
            loading = true;
          });
        } else {
          setState(() {
            emptyBool = false;
          });
          for (int i = 0; i < responseData["response"].length; i++) {
            if (responseData["response"][i]["user"].containsKey("avatar")) {
              forumImagesList.add(responseData["response"][i]["user"]["avatar"]);
            } else {
              forumImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
            forumTitlesList.add(responseData["response"][i]["title"]);
            forumCompanyList.add((responseData["response"][i]["company_name"]) ?? "");
            forumObjectList.add(responseData["response"][i]);
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
        }
        setState(() {
          loading = true;
        });
      });
    }
  }

  void _onForumLoading() async {
    setState(() {
      newsInt = newsInt + 20;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': finalisedCategory.toLowerCase(),
      'search': "",
      'skip': newsInt,
      'type': selectedValue,
      'ticker_id': finalChartTickerId.value
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {});
        } else {
          setState(() {});
          for (int i = 0; i < responseData["response"].length; i++) {
            forumImagesList.add(responseData["response"][i]["user"]["avatar"]);
            forumTitlesList.add(responseData["response"][i]["title"]);
            forumCompanyList.add((responseData["response"][i]["company_name"]) ?? "");
            forumObjectList.add(responseData["response"][i]);
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
        }
      });
    }

    if (mounted) setState(() {});
    _refreshController2.loadComplete();
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

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Forum');
    mainSkipValue ? debugPrint("nothing") : getAllData();
    super.initState();
  }

  getAllData() async {
    await getForumValues();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return mainSkipValue
        ? Container(
            color: const Color(0XFFFFFFFF),
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: const Color(0XFFFFFFFF),
                  body: Container(
                    margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 102.75),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 219),
                          child: Image.asset(
                            "lib/Constants/Assets/SMLogos/SkipPage/skipPopImage.png",
                          ),
                        ),
                        SizedBox(height: height / 102.75),
                        const Center(
                            child: Text(
                          "Trade communication made easy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, fontFamily: "Poppins"),
                        )),
                        SizedBox(height: height / 102.75),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 219),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Powerful alone. Even better together. ",
                                  style: TextStyle(
                                      fontSize: text.scale(7), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                              TextSpan(
                                text:
                                    "Join one of the fastest-growing social trading community and engage with other traders and get access to exclusive member-only features like news, videos, forums, and surveys published by other traders.",
                                style: TextStyle(fontSize: text.scale(7), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                            child: Text(
                          "Join the community today and never miss an insight.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.w400, fontSize: 7, fontFamily: "Poppins"),
                        )),
                        SizedBox(height: height / 102.75),
                        InkWell(
                          onTap: () {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return const SignInPage(
                                fromWhere: "finalCharts",
                              );
                            }));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Color(0XFF0EA102),
                            ),
                            width: width,
                            height: height / 14.5,
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(8), fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height / 102.75),
                      ],
                    ),
                  )),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: height / 51.375,
              ),
              SizedBox(
                height: height / 20.55,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: extraContainMain.value
                          ? () {
                              extraContainMain.value = false;
                            }
                          : () {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return ForumPostPage(
                                  text: finalisedCategory.toLowerCase(),
                                  fromWhere: "finalCharts",
                                );
                              }));
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        width: width / 5.84,
                        child: Center(
                            child: Text(
                          "Create Forum",
                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF11AA04)),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          extraContainMain.toggle();
                        });
                      },
                      child: Row(
                        children: [
                          GestureDetector(
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/Frame 162.svg",
                              height: height / 41.1,
                              width: width / 87.6,
                              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                            ),
                          ),
                          SizedBox(
                            width: width / 292,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sort",
                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 2),
                              Container(
                                height: 2,
                                width: 2,
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
              loading
                  ? Obx(() => extraContainMain.value
                      ? Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                extraContainMain.value = false;
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: height / 50.75),
                                  emptyBool
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: height / 20.55,
                                            ),
                                            SizedBox(
                                                height: height / 6, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                            SizedBox(height: height / 33.83),
                                            Text(
                                              "Unfortunately, the content for the specified ticker is not available.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: text.scale(10),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 102.75,
                                            ),
                                            Text(
                                              "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height / 102.75,
                                            ),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                                    style: TextStyle(
                                                        fontSize: text.scale(8),
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        color: Theme.of(context).colorScheme.onPrimary)),
                                                TextSpan(
                                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                                  text: "Feature request page.",
                                                  style: TextStyle(
                                                      fontSize: text.scale(8),
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        )
                                      : SizedBox(
                                          height: height / 1.91,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemCount: forumTitlesList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: height / 35, left: 2, top: 2, right: 2),
                                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.background,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                          blurRadius: 4,
                                                          spreadRadius: 0)
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 51.375,
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
                                                                height: height / 13.7,
                                                                width: width / 29.2,
                                                                margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.grey,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(
                                                                          forumImagesList[index],
                                                                        ),
                                                                        fit: BoxFit.fill)),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                      width: width / 4.89,
                                                                      child: Text(
                                                                        forumTitlesList[index],
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600),
                                                                      )),
                                                                  Text(
                                                                    forumSourceNameList[index],
                                                                    style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                  ),
                                                                  SizedBox(height: height / 51.375),
                                                                  SizedBox(
                                                                    width: width * 0.21,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: width / 35,
                                                                                child: Text(forumCompanyList[index],
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(6),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.blue,
                                                                                        overflow: TextOverflow.ellipsis))),
                                                                            SizedBox(width: width / 175.2),
                                                                            Row(
                                                                              children: [
                                                                                Text(forumViewsList[index].toString(),
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                                Text(" views",
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                              ],
                                                                            ),
                                                                            SizedBox(width: width / 175.2),
                                                                            Text(forumResponseList[index].toString(),
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                            Text(" Response",
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            forumUseList[index]
                                                                                ? SvgPicture.asset(
                                                                                    isDarkTheme.value
                                                                                        ? "assets/home_screen/like_filled_dark.svg"
                                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                    height: height / 27.4,
                                                                                    width: width / 58.4)
                                                                                : SvgPicture.asset(
                                                                                    isDarkTheme.value
                                                                                        ? "assets/home_screen/like_dark.svg"
                                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                    height: height / 27.4,
                                                                                    width: width / 58.4),
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            SvgPicture.asset(
                                                                                isDarkTheme.value
                                                                                    ? "assets/home_screen/share_dark.svg"
                                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                height: height / 27.4,
                                                                                width: width / 58.4),
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            forumUseDisList[index]
                                                                                ? SvgPicture.asset(
                                                                                    isDarkTheme.value
                                                                                        ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                    height: height / 27.4,
                                                                                    width: width / 58.4)
                                                                                : SvgPicture.asset(
                                                                                    isDarkTheme.value
                                                                                        ? "assets/home_screen/dislike_dark.svg"
                                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                    height: height / 27.4,
                                                                                    width: width / 58.4),
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            SvgPicture.asset("lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                colorFilter: ColorFilter.mode(
                                                                                    isDarkTheme.value
                                                                                        ? const Color(0XFFD6D6D6)
                                                                                        : const Color(0XFF0EA102),
                                                                                    BlendMode.srcIn),
                                                                                height: height / 27.4,
                                                                                width: width / 58.4),
                                                                          ],
                                                                        ),
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
                                                      height: height / 51.375,
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
                              right: width / 219,
                              child: Container(
                                height: height / 2.5,
                                width: width * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context).colorScheme.background,
                                    boxShadow: [
                                      BoxShadow(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2), blurRadius: 4, spreadRadius: 0)
                                    ]),
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: designTopics.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              selectedIndex = index;
                                              selectedValue = designTopics[index];
                                              extraContainMain.value = false;
                                            });
                                            await getForumValues();
                                          },
                                          child: Container(
                                            height: height / 16.44,
                                            margin: EdgeInsets.only(
                                                top: index == 0 ? height / 27.4 : 2,
                                                left: 2,
                                                right: 2,
                                                bottom: index == (designTopics.length - 1) ? height / 27.4 : 2),
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(designTopics[index], style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w400)),
                                                Icon(
                                                  Icons.check,
                                                  color: selectedIndex == index ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
                                                  size: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: height / 50.75),
                            emptyBool
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: height / 20.55,
                                      ),
                                      SizedBox(height: height / 6, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                      SizedBox(height: height / 33.83),
                                      Text(
                                        "Unfortunately, the content for the specified ticker is not available.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: text.scale(10),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 102.75,
                                      ),
                                      Text(
                                        "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: height / 102.75,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                              style: TextStyle(
                                                  fontSize: text.scale(8),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).colorScheme.onPrimary)),
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const FeatureRequestPage(
                                                    fromWhere: "finalCharts",
                                                  );
                                                }));
                                              },
                                            text: "Feature request page.",
                                            style: TextStyle(
                                                fontSize: text.scale(8),
                                                color: const Color(0XFF0EA102),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins"),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: height / 1.91,
                                    child: SmartRefresher(
                                      controller: _refreshController2,
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
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemCount: forumTitlesList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () async {
                                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                bool refresh = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return ForumPostDescriptionPage(
                                                    forumId: forumIdList[index],
                                                    comeFrom: "finalCharts",
                                                    idList: forumIdList,
                                                  );
                                                }));
                                                if (refresh) {
                                                  initState();
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(bottom: height / 35, left: 2, right: 2, top: 2),
                                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.background,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                          blurRadius: 4,
                                                          spreadRadius: 0)
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 51.375,
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
                                                                  /* SystemChrome.setEnabledSystemUIMode(
                                                            SystemUiMode
                                                                .manual,
                                                            overlays:
                                                                SystemUiOverlay
                                                                    .values);*/
                                                                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                                  bool refresh = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(userId: forumUserIdList[index])
                                                                        /*UserProfilePage(
                                                              fromWhere: "finalCharts",
                                                              id: forumUserIdList[
                                                                  index],
                                                              type:
                                                                  'forums',
                                                              index: 0)*/
                                                                        ;
                                                                  }));
                                                                  if (refresh) {
                                                                    initState();
                                                                  }
                                                                },
                                                                child: Container(
                                                                  height: height / 13.7,
                                                                  width: width / 29.2,
                                                                  margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Colors.grey,
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
                                                                      width: width / 4.89,
                                                                      child: Text(
                                                                        forumTitlesList[index],
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600),
                                                                      )),
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      /* SystemChrome.setEnabledSystemUIMode(
                                                                SystemUiMode
                                                                    .manual,
                                                                overlays:
                                                                    SystemUiOverlay.values);*/
                                                                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                                      bool refresh = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return UserBillBoardProfilePage(
                                                                          userId: forumUserIdList[index],
                                                                        )
                                                                            /*UserProfilePage(
                                                                fromWhere: "finalCharts",
                                                                  id: forumUserIdList[index],
                                                                  type:
                                                                      'forums',
                                                                  index:
                                                                      0)*/
                                                                            ;
                                                                      }));
                                                                      if (refresh) {
                                                                        initState();
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      forumSourceNameList[index],
                                                                      style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height / 51.375),
                                                                  SizedBox(
                                                                    width: width * 0.21,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: width / 35,
                                                                                child: Text(forumCompanyList[index],
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(6),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.blue,
                                                                                        overflow: TextOverflow.ellipsis))),
                                                                            SizedBox(width: width / 175.2),
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
                                                                                          fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                                  Text(" views",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: width / 175.2),
                                                                            Text(forumResponseList[index].toString(),
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                            Text(" Response",
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                bool response1 =
                                                                                    await likeFunction(id: forumIdList[index], type: "forums");
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
                                                                              child: forumUseList[index]
                                                                                  ? SvgPicture.asset(
                                                                                      isDarkTheme.value
                                                                                          ? "assets/home_screen/like_filled_dark.svg"
                                                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                                      height: height / 27.4,
                                                                                      width: width / 58.4)
                                                                                  : SvgPicture.asset(
                                                                                      isDarkTheme.value
                                                                                          ? "assets/home_screen/like_dark.svg"
                                                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                                      height: height / 27.4,
                                                                                      width: width / 58.4),
                                                                            ),
                                                                            SizedBox(
                                                                              width: width / 175.2,
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
                                                                                    category: finalisedCategory.toLowerCase(),
                                                                                    filterId: finalisedFilterId);
                                                                                ShareResult result = await Share.share(
                                                                                  "Look what I was able to find on Tradewatch: ${forumTitlesList[index]} ${newLink.toString()}",
                                                                                );
                                                                                if (result.status == ShareResultStatus.success) {
                                                                                  await shareFunction(id: forumIdList[index], type: "forums");
                                                                                }
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                  isDarkTheme.value
                                                                                      ? "assets/home_screen/share_dark.svg"
                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                  height: height / 27.4,
                                                                                  width: width / 58.4),
                                                                            ),
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                bool response3 =
                                                                                    await disLikeFunction(id: forumIdList[index], type: "forums");
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
                                                                              child: forumUseDisList[index]
                                                                                  ? SvgPicture.asset(
                                                                                      isDarkTheme.value
                                                                                          ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                                      height: height / 27.4,
                                                                                      width: width / 58.4)
                                                                                  : SvgPicture.asset(
                                                                                      isDarkTheme.value
                                                                                          ? "assets/home_screen/dislike_dark.svg"
                                                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                                      height: height / 27.4,
                                                                                      width: width / 58.4),
                                                                            ),
                                                                            SizedBox(
                                                                              width: width / 175.2,
                                                                            ),
                                                                            SvgPicture.asset("lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                colorFilter: ColorFilter.mode(
                                                                                    isDarkTheme.value
                                                                                        ? const Color(0XFFD6D6D6)
                                                                                        : const Color(0XFF0EA102),
                                                                                    BlendMode.srcIn),
                                                                                height: height / 27.4,
                                                                                width: width / 58.4),
                                                                          ],
                                                                        ),
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
                                                      height: height / 51.375,
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        ))
                  : Expanded(
                      child: Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: width / 8.22, width: width / 17.52),
                      ),
                    ),
            ],
          );
  }
}

class SurveyWidget extends StatefulWidget {
  const SurveyWidget({Key? key}) : super(key: key);

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  bool loading = false;
  bool emptyBool = false;

  String mainUserToken = "";
  String mainUserId = "";
  String mainTopic = "";
  List<String> surveyImagesList = [];
  List<String> surveySourceNameList = [];
  List<String> surveyTitlesList = [];
  List<String> surveyCompanyList = [];
  List<String> surveyIdList = [];
  List<bool> surveyMyList = [];
  List<int> surveyViewsList = [];
  List<int> surveyResponseList = [];
  List<String> surveyUserIdList = [];
  List<dynamic> surveyObjectList = [];
  List<int> surveyQuestionsList = [];
  List designTopics = [
    "Latest Topics",
    "Popular Topics",
    "Unanswered",
    "Added this month",
    "Added this quarter",
    "Added this semester",
    "6 + older",
    "My Poll",
    "My Answers",
  ];
  int selectedIndex = 0;
  String selectedValue = "Latest Topics";
  late Uri newLink;
  int newsInt = 0;
  String activeStatus = "";
  bool answerStatus = false;
  int answeredQuestion = 0;
  final RefreshController _refreshController2 = RefreshController(initialRefresh: false);

  getSurveyValues() async {
    surveyImagesList.clear();
    surveySourceNameList.clear();
    surveyTitlesList.clear();
    surveyCompanyList.clear();
    surveyIdList.clear();
    surveyMyList.clear();
    surveyViewsList.clear();
    surveyResponseList.clear();
    surveyUserIdList.clear();
    surveyObjectList.clear();
    surveyQuestionsList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': finalisedCategory.toLowerCase(), 'search': "", 'skip': '0', 'type': selectedValue, 'ticker_id': finalChartTickerId.value});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            emptyBool = true;
            loading = true;
          });
        } else {
          setState(() {
            emptyBool = false;
          });
          for (int i = 0; i < responseData["response"].length; i++) {
            surveyImagesList.add(responseData["response"][i]["user"]["avatar"]);
            surveyTitlesList.add(responseData["response"][i]["title"]);
            surveyObjectList.add(responseData["response"][i]);
            surveySourceNameList.add(responseData["response"][i]["user"]["username"]);
            surveyCompanyList.add(responseData["response"][i]["company_name"]);
            surveyIdList.add(responseData["response"][i]["_id"]);
            surveyViewsList.add(responseData["response"][i]["views_count"]);
            surveyResponseList.add(responseData["response"][i]["answers_count"]);
            surveyQuestionsList.add(responseData["response"][i]["questions_count"]);
            surveyUserIdList.add(responseData["response"][i]["user"]["_id"]);
            if (mainUserId == surveyUserIdList[i]) {
              surveyMyList.add(true);
            } else {
              surveyMyList.add(false);
            }
          }
        }
        setState(() {
          loading = true;
        });
      });
    }
  }

  _onSurveyLoading() async {
    setState(() {
      newsInt = newsInt + 20;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': finalisedCategory.toLowerCase(),
      'search': "",
      'skip': newsInt,
      'type': selectedValue,
      'ticker_id': finalChartTickerId.value
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
      if (responseData["response"].length == 0) {
      } else {
        for (int i = 0; i < responseData["response"].length; i++) {
          surveyImagesList.add(responseData["response"][i]["user"]["avatar"]);
          surveyTitlesList.add(responseData["response"][i]["title"]);
          surveyObjectList.add(responseData["response"][i]);
          surveySourceNameList.add(responseData["response"][i]["user"]["username"]);
          surveyCompanyList.add(responseData["response"][i]["company_name"]);
          surveyIdList.add(responseData["response"][i]["_id"]);
          surveyViewsList.add(responseData["response"][i]["views_count"]);
          surveyResponseList.add(responseData["response"][i]["answers_count"]);
          surveyQuestionsList.add(responseData["response"][i]["questions_count"]);
          surveyUserIdList.add(responseData["response"][i]["user"]["_id"]);
          if (mainUserId == surveyUserIdList[i]) {
            surveyMyList.add(true);
          } else {
            surveyMyList.add(false);
          }
        }
      }
    }
    if (mounted) setState(() {});
    _refreshController2.loadComplete();
  }

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Survey');
    mainSkipValue ? debugPrint("nothing") : getAllData();
    super.initState();
  }

  getAllData() async {
    await getSurveyValues();
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return mainSkipValue
        ? Container(
            color: const Color(0XFFFFFFFF),
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: const Color(0XFFFFFFFF),
                  body: Container(
                    margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 102.75),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 219),
                          child: Image.asset(
                            "lib/Constants/Assets/SMLogos/SkipPage/skipPopImage.png",
                          ),
                        ),
                        SizedBox(height: height / 102.75),
                        Center(
                            child: Text(
                          "Trade communication made easy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: text.scale(10), fontFamily: "Poppins"),
                        )),
                        SizedBox(height: height / 102.75),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 219),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Powerful alone. Even better together. ",
                                  style: TextStyle(
                                      fontSize: text.scale(7), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                              TextSpan(
                                text:
                                    "Join one of the fastest-growing social trading community and engage with other traders and get access to exclusive member-only features like news, videos, forums, and surveys published by other traders.",
                                style: TextStyle(fontSize: text.scale(7), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(height: height / 102.75),
                        Center(
                            child: Text(
                          "Join the community today and never miss an insight.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontSize: text.scale(7), fontFamily: "Poppins"),
                        )),
                        SizedBox(height: height / 102.75),
                        InkWell(
                          onTap: () {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return const SignInPage(
                                fromWhere: "finalCharts",
                              );
                            }));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Color(0XFF0EA102),
                            ),
                            width: width,
                            height: height / 14.5,
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(8), fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height / 102.75),
                      ],
                    ),
                  )),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: height / 51.375,
              ),
              SizedBox(
                height: height / 20.55,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: extraContainMain.value
                          ? () {
                              extraContainMain.value = false;
                            }
                          : () {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return SurveyPostPage(
                                  text: finalisedCategory.toLowerCase(),
                                  fromWhere: "finalCharts",
                                );
                              }));
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        width: width / 5.84,
                        child: Center(
                            child: Text(
                          "Create Survey",
                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF11AA04)),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          extraContainMain.toggle();
                        });
                      },
                      child: Row(
                        children: [
                          GestureDetector(
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/Frame 162.svg",
                              height: height / 41.1,
                              width: width / 87.6,
                              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                            ),
                          ),
                          SizedBox(
                            width: width / 292,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sort",
                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 2),
                              Container(
                                height: 2,
                                width: 2,
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
              loading
                  ? Obx(() => extraContainMain.value
                      ? Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                extraContainMain.value = false;
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: height / 50.75),
                                  emptyBool
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: height / 20.55,
                                            ),
                                            SizedBox(
                                                height: height / 6, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                            SizedBox(height: height / 33.83),
                                            Text(
                                              "Unfortunately, the content for the specified ticker is not available.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: text.scale(10),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 102.75,
                                            ),
                                            Text(
                                              "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height / 102.75,
                                            ),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                                    style: TextStyle(
                                                        fontSize: text.scale(8),
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        color: Theme.of(context).colorScheme.onPrimary)),
                                                TextSpan(
                                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                                  text: "Feature request page.",
                                                  style: TextStyle(
                                                      fontSize: text.scale(8),
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        )
                                      : SizedBox(
                                          height: height / 1.91,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: surveyTitlesList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: height / 35, left: 2, top: 2, right: 2),
                                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.background,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                          blurRadius: 4,
                                                          spreadRadius: 0)
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 51.375,
                                                    ),
                                                    Container(
                                                      color: Theme.of(context).colorScheme.background,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: height / 51.375,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                height: height / 13.7,
                                                                width: width / 29.2,
                                                                margin: const EdgeInsets.fromLTRB(
                                                                  2,
                                                                  2,
                                                                  2,
                                                                  2,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.grey,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(surveyImagesList[index]), fit: BoxFit.fill)),
                                                              ),
                                                              SizedBox(
                                                                width: width / 109.5,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                      width: width / 4.89,
                                                                      child: Text(
                                                                        surveyTitlesList[index],
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600),
                                                                      )),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        surveySourceNameList[index],
                                                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                      ),
                                                                      SizedBox(
                                                                        width: width / 109.5,
                                                                      ),
                                                                      Container(
                                                                        height: height / 82.2,
                                                                        width: width / 109.5,
                                                                        decoration:
                                                                            const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                      ),
                                                                      SizedBox(
                                                                        width: width / 109.5,
                                                                      ),
                                                                      Text(
                                                                        surveyQuestionsList[index].toString(),
                                                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Text(
                                                                        " Questions",
                                                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 41.1,
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 54.13,
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                            width: width / 35,
                                                                            child: Text(surveyCompanyList[index],
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(6),
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.blue,
                                                                                    overflow: TextOverflow.ellipsis))),
                                                                        SizedBox(width: width / 22.05),
                                                                        Row(
                                                                          children: [
                                                                            Text(surveyViewsList[index].toString(),
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                            Text(" Views",
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                          ],
                                                                        ),
                                                                        SizedBox(width: width / 22.05),
                                                                        Row(
                                                                          children: [
                                                                            Text(surveyResponseList[index].toString(),
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                            Text(" Responses",
                                                                                style:
                                                                                    TextStyle(fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: height / 51.375,
                                                          ),
                                                        ],
                                                      ),
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
                              right: width / 219,
                              child: Container(
                                height: height / 2.5,
                                width: width * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context).colorScheme.background,
                                    boxShadow: [
                                      BoxShadow(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2), blurRadius: 4, spreadRadius: 0)
                                    ]),
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: designTopics.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              selectedIndex = index;
                                              selectedValue = designTopics[index];
                                              extraContainMain.value = false;
                                            });
                                            await getSurveyValues();
                                          },
                                          child: Container(
                                            height: height / 16.44,
                                            margin: EdgeInsets.only(
                                                top: index == 0 ? height / 27.4 : 2,
                                                left: 2,
                                                right: 2,
                                                bottom: index == (designTopics.length - 1) ? height / 27.4 : 2),
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(designTopics[index], style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w400)),
                                                Icon(
                                                  Icons.check,
                                                  color: selectedIndex == index ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
                                                  size: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: height / 50.75),
                            emptyBool
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: height / 20.55,
                                      ),
                                      SizedBox(height: height / 6, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                      SizedBox(height: height / 33.83),
                                      Text(
                                        "Unfortunately, the content for the specified ticker is not available.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: text.scale(10),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 102.75,
                                      ),
                                      Text(
                                        "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: height / 102.75,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                              style: TextStyle(
                                                  fontSize: text.scale(8),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).colorScheme.onPrimary)),
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const FeatureRequestPage(
                                                    fromWhere: "finalCharts",
                                                  );
                                                }));
                                              },
                                            text: "Feature request page.",
                                            style: TextStyle(
                                                fontSize: text.scale(8),
                                                color: const Color(0XFF0EA102),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins"),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: height / 1.91,
                                    child: SmartRefresher(
                                      controller: _refreshController2,
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
                                      onLoading: _onSurveyLoading,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: surveyTitlesList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () async {
                                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                await statusFunc(surveyId: surveyIdList[index]);
                                                if (!mounted) {
                                                  return;
                                                }
                                                surveyMyList[index]
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                            surveyId: surveyIdList[index],
                                                            fromWhere: "finalCharts",
                                                            activity: false,
                                                            surveyTitle: surveyTitlesList[index]);
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: surveyIdList[index],
                                                                  fromWhere: "finalCharts",
                                                                  activity: false,
                                                                  surveyTitle: surveyTitlesList[index],
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: surveyIdList[index],
                                                                  defaultIndex: answeredQuestion,
                                                                  fromWhere: "finalCharts",
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: surveyIdList[index],
                                                                fromWhere: "finalCharts",
                                                                activity: false,
                                                                surveyTitle: surveyTitlesList[index]);
                                                          }));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(bottom: height / 35, top: 2, right: 2, left: 2),
                                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.background,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                          blurRadius: 4,
                                                          spreadRadius: 0)
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 51.375,
                                                    ),
                                                    Container(
                                                      color: Theme.of(context).colorScheme.background,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: height / 51.375,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  /* SystemChrome.setEnabledSystemUIMode(
                                                SystemUiMode
                                                    .manual,
                                                overlays:
                                                SystemUiOverlay
                                                    .values);*/
                                                                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(userId: surveyUserIdList[index])
                                                                        /*UserProfilePage(
                                                      id:surveyUserIdList[index],
                                                      type:'survey',
                                                      fromWhere: "finalCharts",
                                                      index:1)*/
                                                                        ;
                                                                  }));
                                                                },
                                                                child: Container(
                                                                  height: height / 13.7,
                                                                  width: width / 29.2,
                                                                  margin: const EdgeInsets.fromLTRB(
                                                                    2,
                                                                    2,
                                                                    2,
                                                                    2,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Colors.grey,
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(surveyImagesList[index]), fit: BoxFit.fill)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width / 109.5,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                      width: width / 4.89,
                                                                      child: Text(
                                                                        surveyTitlesList[index],
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600),
                                                                      )),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      GestureDetector(
                                                                          onTap: () {
                                                                            /*SystemChrome.setEnabledSystemUIMode(
                                                          SystemUiMode
                                                              .manual,
                                                          overlays:
                                                          SystemUiOverlay.values);*/
                                                                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                              return UserBillBoardProfilePage(userId: surveyUserIdList[index])
                                                                                  /*UserProfilePage(
                                                                  id:surveyUserIdList[index],
                                                                  type:'survey',
                                                                  fromWhere: "finalCharts",
                                                                  index: 1,)*/
                                                                                  ;
                                                                            }));
                                                                          },
                                                                          child: Text(
                                                                            surveySourceNameList[index],
                                                                            style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                          )),
                                                                      SizedBox(
                                                                        width: width / 109.5,
                                                                      ),
                                                                      Container(
                                                                        height: height / 82.2,
                                                                        width: width / 109.5,
                                                                        decoration:
                                                                            const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                      ),
                                                                      SizedBox(
                                                                        width: width / 109.5,
                                                                      ),
                                                                      Text(
                                                                        surveyQuestionsList[index].toString(),
                                                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Text(
                                                                        " Questions",
                                                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 41.1,
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 54.13,
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                            width: width / 35,
                                                                            child: Text(surveyCompanyList[index],
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(6),
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.blue,
                                                                                    overflow: TextOverflow.ellipsis))),
                                                                        SizedBox(width: width / 22.05),
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              kUserSearchController.clear();
                                                                              onTapType = "Views";
                                                                              onTapId = surveyIdList[index];
                                                                              onLike = false;
                                                                              onDislike = false;
                                                                              onViews = true;
                                                                              idKeyMain = "survey_id";
                                                                              apiMain = baseurl + versionSurvey + viewsCount;
                                                                              onTapIdMain = surveyIdList[index];
                                                                              onTapTypeMain = "Views";
                                                                              haveViewsMain = surveyViewsList[index] > 0 ? true : false;
                                                                              viewCountMain = surveyViewsList[index];
                                                                              kToken = mainUserToken;
                                                                            });
                                                                            //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionSurvey + viewsCount, idKey: 'survey_id', setState: setState);
                                                                            bool data = await likeCountFunc(context: context, newSetState: setState);
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
                                                                              Text(surveyViewsList[index].toString(),
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                              Text(" Views",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: width / 22.05),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            Flushbar(
                                                                              message: "Analytics not visible due to privacy",
                                                                              duration: const Duration(seconds: 2),
                                                                            ).show(context);
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Text(surveyResponseList[index].toString(),
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(6), fontWeight: FontWeight.w700)),
                                                                              Text(" Responses",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(6), fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: height / 51.375,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        ))
                  : Expanded(
                      child: Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.22, width: width / 17.52),
                      ),
                    ),
            ],
          );
  }
}

class AlertWidget extends StatefulWidget {
  const AlertWidget({Key? key}) : super(key: key);

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  OverViewModel? _overView;
  int indexValue = 0;
  bool loader = false;
  List<WatchlistNotification> notifyList = [];
  bool moneyValue = false;

  @override
  void initState() {
    getAllDataMain(name: 'Charts_Screen_Alert');
    mainSkipValue ? getNonLoginData() : getData();
    super.initState();
  }

  getNonLoginData() async {
    notifyList = [];
    setState(() {
      loader = true;
    });
  }

  getData() async {
    _overView = await getOverViewData(tickerId: finalChartTickerId.value);
    if (_overView!.response.category == "stocks") {
      if (_overView!.response.exchange == "NSE" || _overView!.response.exchange == "BSE") {
        setState(() {
          moneyValue = true;
        });
      } else {
        setState(() {
          moneyValue = false;
        });
      }
    } else if (_overView!.response.category == "commodity") {
      if (_overView!.response.country == "India") {
        setState(() {
          moneyValue = true;
        });
      } else {
        setState(() {
          moneyValue = false;
        });
      }
    } else {
      setState(() {
        moneyValue = false;
      });
    }
    notifyList = _overView!.response.watchlistNotification;
    watchBellList.value = notifyList.isEmpty ? false : true;
    if (_overView!.response.category == 'stocks') {
      if (_overView!.response.exchange == 'NSE') {
        indexValue = 1;
      } else if (_overView!.response.exchange == 'BSE') {
        indexValue = 2;
      } else if (_overView!.response.exchange == 'INDX') {
        if (_overView!.response.type == 'NSE') {
          indexValue = 1;
        } else if (_overView!.response.type == 'BSE') {
          indexValue = 2;
        } else if (_overView!.response.type == 'US') {
          indexValue = 0;
        }
      } else {
        indexValue = 0;
      }
    } else if (_overView!.response.category == 'crypto') {
      indexValue = 3;
    } else if (_overView!.response.category == 'commodity') {
      if (_overView!.response.country == 'India') {
        indexValue = 4;
      } else if (_overView!.response.country == 'USA') {
        indexValue = 5;
      }
    } else if (_overView!.response.category == 'forex') {
      indexValue = 6;
    }
    setState(() {
      loader = true;
    });
  }

  removeNotifyListMain1({required BuildContext context, required String notifyId, required String tickerId}) async {
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      await getData();
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? notifyList.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView.builder(
                      itemCount: notifyList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? height / 20.55 : 0, bottom: height / 20.55),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(_overView!.response.logoUrl),
                                  ),
                                  SizedBox(
                                    width: width / 109.5,
                                  ),
                                  SizedBox(
                                      width: width / 14.6,
                                      child: Text(
                                        notifyList[index].notes,
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500),
                                      )),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        moneyValue ? "\u{20B9}" : "\$",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        notifyList[index].minValue.toString(),
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Min ${(((notifyList[index].minValue - double.parse(_overView!.response.close)) / double.parse(_overView!.response.close)) * 100).toStringAsFixed(2)}%",
                                    style: TextStyle(
                                        fontSize: text.scale(6),
                                        fontWeight: FontWeight.w600,
                                        color: ((notifyList[index].minValue - double.parse(_overView!.response.close)) /
                                                    double.parse(_overView!.response.close)) <
                                                0
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        moneyValue ? "\u{20B9} " : "\$ ",
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        notifyList[index].maxValue.toString(),
                                        style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Max ${(((notifyList[index].maxValue - double.parse(_overView!.response.close)) / double.parse(_overView!.response.close)) * 100).toStringAsFixed(2)}%",
                                    style: TextStyle(
                                        fontSize: text.scale(6),
                                        fontWeight: FontWeight.w600,
                                        color: ((notifyList[index].maxValue - double.parse(_overView!.response.close)) /
                                                    double.parse(_overView!.response.close)) <
                                                0
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        removeNotifyListMain1(context: context, notifyId: notifyList[index].id, tickerId: finalChartTickerId.value);
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 15,
                                      )),
                                  SizedBox(
                                    width: width / 87.6,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                          return ChartSetAlertPage(
                                              fromWhere: "finalCharts",
                                              currentIndex: indexValue,
                                              tickerId: finalChartTickerId.value,
                                              tickerName: _overView!.response.name,
                                              editValue: notifyList.isEmpty ? false : true,
                                              closeValue: _overView!.response.close);
                                        }));
                                        if (response) {
                                          getData();
                                          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                                        }
                                      },
                                      child: Image.asset(
                                        "lib/Constants/Assets/FinalChartImages/editPencil.png",
                                        scale: 2,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  notifyList.length < 5
                      ? Container(
                          height: height / 20.55,
                          margin: EdgeInsets.only(bottom: height / 16.44),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF0EA102)),
                              onPressed: () async {
                                bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return ChartSetAlertPage(
                                      fromWhere: "finalCharts",
                                      currentIndex: indexValue,
                                      tickerId: finalChartTickerId.value,
                                      tickerName: _overView!.response.name,
                                      editValue: notifyList.isEmpty ? false : true,
                                      closeValue: _overView!.response.close);
                                }));
                                if (response) {
                                  getData();
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                                }
                              },
                              child: Text(
                                "Set Alert",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(10)),
                              )),
                        )
                      : const SizedBox(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/Constants/Assets/FinalChartImages/add_notes.png",
                    height: 30,
                    width: 50,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Looks like you don't have any price alert for this asset yet, would you like to create one?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF0EA102)),
                        onPressed: mainSkipValue
                            ? () {
                                commonPopUpBar(context: context);
                              }
                            : () async {
                                bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return ChartSetAlertPage(
                                      fromWhere: "finalCharts",
                                      currentIndex: indexValue,
                                      tickerId: finalChartTickerId.value,
                                      tickerName: _overView!.response.name,
                                      editValue: notifyList.isEmpty ? false : true,
                                      closeValue: _overView!.response.close);
                                }));
                                if (response) {
                                  getData();
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                                }
                              },
                        child: Text(
                          "Set Alert",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(10)),
                        )),
                  ),
                ],
              )
        : Center(
            child: Lottie.asset(
              'lib/Constants/Assets/SMLogos/loading.json',
              height: 50,
              width: 50,
            ),
          );
  }
}

RxBool headerLoader = true.obs;
RxString finalChartTickerId = "".obs;
RxString fullScreen = "false".obs;
RxBool watchBellList = false.obs;
RxString finalChartExchange = "".obs;
RxString finalChartMain = "".obs;
RxString defaultTvSymbol = "".obs;
RxString defaultTvSymbol2 = "".obs;
SingleTickerNewsModel? newsModelMain;
SingleTickerNewsModel? newsModelMain2;
RxInt toggleIndex = 0.obs;
RxBool checkIndexExchange = false.obs;

Future<OverViewModel> getOverViewData({required String tickerId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mainUserToken = prefs.getString('newUserToken') ?? "";
  var url = Uri.parse(baseurl + versionCompare + overViewChart);
  var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"ticker_id": tickerId});
  var responseData = json.decode(response.body);
  OverViewModel overView = OverViewModel.fromJson(responseData);
  checkIndexExchange.value = overView.response.exchange == "INDX" ? true : false;
  return overView;
}

Future<SingleTickerNewsModel?> getNewsValues({required String tickerId}) async {
  SingleTickerNewsModel? newsModel;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mainUserToken = prefs.getString('newUserToken') ?? "";
  var url = Uri.parse(baseurl + versionLocker + getNewsZone);
  var response = await http.post(url,
      headers: {'Authorization': mainUserToken},
      body: {'category': finalisedCategory.toLowerCase(), 'search': "", 'skip': '0', 'ticker_id': tickerId});
  var responseData = json.decode(response.body);
  if (responseData["status"]) {
    newsModel = SingleTickerNewsModel.fromJson(responseData);
  }
  return newsModel;
}
