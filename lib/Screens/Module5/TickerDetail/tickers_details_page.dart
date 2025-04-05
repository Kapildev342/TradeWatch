import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/detailed_forum_image_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/detailed_survey_image_page.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TickersDetailsPage extends StatefulWidget {
  final String category;
  final String id;
  final String exchange;
  final String country;
  final String name;
  final String fromWhere;

  const TickersDetailsPage(
      {Key? key,
      required this.category,
      required this.id,
      required this.exchange,
      required this.country,
      required this.name,
      required this.fromWhere})
      : super(key: key);

  @override
  State<TickersDetailsPage> createState() => _TickersDetailsPageState();
}

class _TickersDetailsPageState extends State<TickersDetailsPage> with TickerProviderStateMixin {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  late ContextMenu contextMenu;
  String finalUrl = "";
  PullToRefreshController? pullToRefreshController;
  Timer? timer;
  String url = "";
  double progress = 0;
  TextEditingController urlController = TextEditingController();
  late AnimationController _animationController;
  String tickerDetailAddress = "";
  String tickerDetailCode = "";
  bool watchListStatus = false;
  String tickerDetailLogo = "";
  String tickerDetailIndustry = "";
  String tickerDetailSymbol = "";
  String tickerDetailCategory = "";
  String tickerDetailType = "";
  String tickerDetailExchange = "";
  String mainUserToken = "";
  bool loader = false;
  String timeValue = "1 Year";
  List leftYList = [];
  RxInt progressPercentage = 0.obs;
  RxString progressValue = "".obs;
  List<String> dropDownWidgetList = [
    "lib/Constants/Assets/ChartPage/growth.png",
    "lib/Constants/Assets/ChartPage/candlestick-chart.png",
  ];
  int selectedType = 0;
  dynamic chartValueData;
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  int _numInterstitialLoadAttempts = 0;

  //late final WebViewController _controller;

  @override
  void initState() {
    // MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ["D5FADCD990EAE787E640852882FEDEE6"]));
    getAllDataMain(name: 'Profile_Plus_Screen');
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    finalUrl =
        "https://live.tradewatch.in/#/chart?id=${widget.id}&chart=Candle&category=${widget.category.toLowerCase()}&exchange=${widget.exchange}&full_screen=true&theme=${isDarkTheme.value ? "Dark" : "Light"}";
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
    if (widget.fromWhere == "search") {
      createInterstitialAd();
    }
    await getData();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: adVariables.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            mainVariables.interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            mainVariables.interstitialAd!.setImmersiveMode(true);
            setState(() {});
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            mainVariables.interstitialAd = null;
            if (_numInterstitialLoadAttempts < mainVariables.maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (mainVariables.interstitialAd == null) {
      return;
    }
    mainVariables.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    mainVariables.interstitialAd!.show();
    mainVariables.interstitialAd = null;
  }

  getData() async {
    flag.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    Map<String, dynamic> dataUpdate = {};
    var url = Uri.parse(baseurl + versionCompare + tickersChart);
    if (widget.category == "stocks") {
      dataUpdate = {
        'category': widget.category.toLowerCase(),
        'ticker_id': widget.id,
        'exchange': widget.exchange == "NSE"
            ? "NSE"
            : widget.exchange == "BSE"
                ? "BSE"
                : "US",
        'last_activity': timeValue
      };
    } else if (widget.category == "crypto") {
      dataUpdate = {'category': widget.category.toLowerCase(), 'ticker_id': widget.id, 'last_activity': timeValue};
    } else if (widget.category == "commodity") {
      dataUpdate = {'category': widget.category.toLowerCase(), 'ticker_id': widget.id, 'last_activity': timeValue};
    } else if (widget.category == "forex") {
      dataUpdate = {'category': widget.category.toLowerCase(), 'ticker_id': widget.id, 'last_activity': timeValue};
    } else {
      dataUpdate = {'category': widget.category.toLowerCase(), 'ticker_id': widget.id, 'last_activity': timeValue};
    }
    var response = await http.post(url, body: dataUpdate);
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      tickerDetailCode = responseData["response"]["code"];
      tickerDetailPageName.value = responseData["response"]["name"];
      tickerDetailType = responseData["response"]["category"];
      watchListStatus = responseData["response"]["watchlist"] ?? false;
      if (responseData["response"]["category"] == "stocks") {
        tickerDetailCategory = responseData["response"]["exchange"] == "INDX"
            ? "${responseData["response"]["type"]} Stocks"
            : responseData["response"]["exchange"] == "NSE"
                ? "NSE Stocks"
                : responseData["response"]["exchange"] == "BSE"
                    ? "BSE Stocks"
                    : "USA Stocks";
        tickerDetailExchange = responseData["response"]["exchange"] == "INDX"
            ? "${responseData["response"]["type"]}"
            : responseData["response"]["exchange"] == "NSE"
                ? "NSE"
                : responseData["response"]["exchange"] == "BSE"
                    ? "BSE"
                    : "USA";
      } else if (responseData["response"]["category"] == "crypto") {
        tickerDetailCategory = "Crypto";
      } else if (responseData["response"]["category"] == "commodity") {
        tickerDetailCategory = "Commodity";
      } else if (responseData["response"]["category"] == "forex") {
        tickerDetailCategory = "Forex";
      } else {
        tickerDetailCategory = "";
      }
      tickerDetailLogo = responseData["response"]["logo_url"];
      if (responseData["response"].containsKey("industry")) {
        tickerDetailIndustry = responseData["response"]["industry"];
      } else {
        tickerDetailIndustry = "";
      }
      if (responseData["response"].containsKey("tv_symbol")) {
        tickerDetailSymbol = responseData["response"]["tv_symbol"];
      } else {
        tickerDetailSymbol = "";
      }
      if (responseData["response"].containsKey("full_address")) {
        tickerDetailAddress = responseData["response"]["full_address"];
      } else {
        tickerDetailAddress = "";
      }
      if (responseData["response"].containsKey("description")) {
        tickerDetailPageDescription.value = responseData["response"]["description"];
        if (tickerDetailPageDescription.value.length > 150) {
          firstHalf.value = tickerDetailPageDescription.value.substring(0, 150);
          secondHalf.value = tickerDetailPageDescription.value.substring(150, tickerDetailPageDescription.value.length);
        } else {
          firstHalf.value = tickerDetailPageDescription.value;
          secondHalf.value = "";
        }
      } else {
        tickerDetailPageDescription.value = "";
      }
      tickerDetailPageWebUrl.value = responseData["response"]["web_url"];
      if (responseData["response"]["trading"].isNotEmpty) {
        int tradeLength = responseData["response"]["trading"].length;
        priTickerDetailPageCurrentPrice.value = responseData["response"]["trading"][tradeLength - 1]["close"].toStringAsFixed(2);
        priTickerDetailPageHighestPrice.value = responseData["response"]["trading"][tradeLength - 1]["high"].toStringAsFixed(2);
        priTickerDetailPageLowestPrice.value = responseData["response"]["trading"][tradeLength - 1]["low"].toStringAsFixed(2);
        priTickerDetailPageChangeValue.value = responseData["response"]["trading"][tradeLength - 1]["change"].toStringAsFixed(2);
        priTickerDetailPageChangePercentage.value = "${responseData["response"]["trading"][tradeLength - 1]["change_p"].toStringAsFixed(2)} %";
        if (responseData["response"].containsKey("epse")) {
          priTickerDetailPageEpse.value = responseData["response"]["epse"].toString();
        } else {
          priTickerDetailPageEpse.value = "-";
        }
        if (responseData["response"].containsKey("shares_mln")) {
          priTickerDetailPageShares.value = responseData["response"]["shares_mln"].toString();
        } else {
          priTickerDetailPageShares.value = "-";
        }
        if (responseData["response"].containsKey("ebit_da")) {
          priTickerDetailPageEBit.value = responseData["response"]["ebit_da"].toString();
        } else {
          priTickerDetailPageEBit.value = "-";
        }
        if (responseData["response"].containsKey("pe_ratio")) {
          priTickerDetailPagePeRatio.value = responseData["response"]["pe_ratio"].toString();
        } else {
          priTickerDetailPagePeRatio.value = "-";
        }
        if (responseData["response"].containsKey("peg_ratio")) {
          priTickerDetailPagePegRatio.value = responseData["response"]["peg_ratio"].toString();
        } else {
          priTickerDetailPagePegRatio.value = "-";
        }
        if (responseData["response"].containsKey("revenue_ttm")) {
          priTickerDetailPageRevenue.value = responseData["response"]["revenue_ttm"].toString();
        } else {
          priTickerDetailPageRevenue.value = "-";
        }
        if (responseData["response"].containsKey("forward_annual_dividend_yield")) {
          priTickerDetailPageForward.value = responseData["response"]["forward_annual_dividend_yield"].toString();
        } else {
          priTickerDetailPageForward.value = "-";
        }
        if (responseData["response"].containsKey("market_capitalization_mln")) {
          priTickerDetailPageMarketCapValue.value = responseData["response"]["market_capitalization_mln"].toStringAsFixed(2);
        } else {
          priTickerDetailPageMarketCapValue.value = "-";
        }
        if (responseData["response"].containsKey("circulating_supply")) {
          priTickerDetailPageCirculationSupplyValue.value = responseData["response"]["circulating_supply"].toStringAsFixed(2);
        } else {
          priTickerDetailPageCirculationSupplyValue.value = "-";
        }
        if (responseData["response"].containsKey("dividend")) {
          priTickerDetailPageDividendValue.value = responseData["response"]["dividend"].length > 10
              ? responseData["response"]["dividend"].toString().substring(0, 10)
              : responseData["response"]["dividend"];
        } else {
          priTickerDetailPageDividendValue.value = "-";
        }
        if (responseData["response"].containsKey("exdividend_date")) {
          priTickerDetailPageLastDividendDateValue.value = responseData["response"]["exdividend_date"].length > 10
              ? responseData["response"]["exdividend_date"].toString().substring(0, 10)
              : responseData["response"]["exdividend_date"];
        } else {
          priTickerDetailPageLastDividendDateValue.value = "-";
        }
        if (responseData["response"].containsKey("dividend_date")) {
          priTickerDetailPageDividendProviderValue.value = responseData["response"]["dividend_date"].length > 10
              ? responseData["response"]["dividend_date"].toString().substring(0, 10)
              : responseData["response"]["dividend_date"];
        } else {
          priTickerDetailPageDividendProviderValue.value = "-";
        }
        if (responseData["response"].containsKey("week_low")) {
          priTickerDetailPageWeekLow.value = responseData["response"]["week_low"].round().toString();
        } else {
          priTickerDetailPageWeekLow.value = "-";
        }
        if (responseData["response"].containsKey("week_high")) {
          priTickerDetailPageWeekHigh.value = responseData["response"]["week_high"].round().toString();
        } else {
          priTickerDetailPageWeekHigh.value = "-";
        }
        if (responseData["response"]["trading"][tradeLength - 1].containsKey("state")) {
          priTickerDetailPageState.value = responseData["response"]["trading"][tradeLength - 1]["state"];
        } else {
          priTickerDetailPageState.value = "Increse";
        }
        priTickerDetailPageCurrentTime.value = responseData["response"]['trading'][tradeLength - 1]['trading_date_time'].toString().substring(0, 10);
      }
      leftYList.clear();
      leftYList.sort();
      leftMinDetailPage.value = leftYList.isNotEmpty ? leftYList.first : 0.0;
      leftMaxDetailPage.value = leftYList.isNotEmpty ? leftYList.last : 0.0;
      double divValue = leftMinDetailPage.value / 10.00;
      double divValueMax = leftMaxDetailPage.value / 10.00;
      leftMinDetailPage.value = leftMinDetailPage.value - divValue;
      leftMaxDetailPage.value = leftMaxDetailPage.value + divValueMax;
    }
    setState(() {
      loader = true;
    });
    if (widget.fromWhere == "search") {
      showInterstitialAd();
    }
  }

  userInsightFunc({required String typeData, required String aliasData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString("newUserToken")!;
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    await http.post(url,
        body: {"alias": aliasData, "type": typeData}, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': mainUserToken});
  }

  @override
  void dispose() {
    mainVariables.interstitialAd?.dispose();
    _animationController.dispose();
    // webViewController!.stopLoading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWhere == 'main') {
          // webViewController!.stopLoading();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainBottomNavigationPage(
                      caseNo1: 0, text: "Stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
        } else {
          //webViewController!.stopLoading();
          Navigator.pop(context, true);
        }
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: loader
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: height / 4,
                        width: width,
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          height: height / 5,
                          width: width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                            image: DecorationImage(image: AssetImage("lib/Constants/Assets/Settings/coverImage_default.png"), fit: BoxFit.fill),
                            color: Color(0XFF48B83F),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 4,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (widget.fromWhere == 'main') {
                                        // webViewController!.stopLoading();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const MainBottomNavigationPage(
                                                    caseNo1: 0,
                                                    text: "Stocks",
                                                    excIndex: 1,
                                                    newIndex: 0,
                                                    countryIndex: 0,
                                                    isHomeFirstTym: false,
                                                    tType: true)));
                                      } else {
                                        //  webViewController!.stopLoading();
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    icon: Image.asset(
                                      "lib/Constants/Assets/SMLogos/LockerScreen/x-circle.png",
                                      color: Colors.white,
                                      height: 30,
                                      width: 30,
                                    ))
                              ],
                            ),
                            Center(
                              child: Container(
                                height: height / 6.25,
                                width: width / 2.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(tickerDetailLogo),
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: Text(
                          tickerDetailCategory,
                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF48B83F)),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: tickerDetailPageName.value.length > 40 ? height / 168.8 : height / 50.75, horizontal: width / 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Obx(() => Text(
                                        tickerDetailPageName.value,
                                        style: TextStyle(
                                          fontSize: text.scale(22),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ))),
                              GestureDetector(
                                onTap: () async {
                                  if (mainSkipValue) {
                                    commonFlushBar(context: context, initFunction: initState);
                                  } else {
                                    if (watchListStatus) {
                                      logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                      setState(() {
                                        watchListStatus = !watchListStatus;
                                      });
                                      await apiFunctionsMain.getRemoveWatchList(tickerId: widget.id, context: context);
                                    } else {
                                      bool added =
                                          await apiFunctionsMain.getAddWatchList(tickerId: widget.id, context: context, modelSetState: setState);
                                      if (added) {
                                        logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                        setState(() {
                                          watchListStatus = !watchListStatus;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: watchListStatus
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
                        ),
                        SizedBox(
                          height: height / 101.5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tickerDetailCode,
                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: width / 75,
                                  ),
                                  Container(
                                    height: height / 162.4,
                                    width: width / 75,
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                  ),
                                  SizedBox(
                                    width: width / 75,
                                  ),
                                  Text(
                                    tickerDetailIndustry,
                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (mainSkipValue) {
                                        commonFlushBar(context: context, initFunction: initState);
                                      } else {
                                        mainVariables.selectedTickerId.value = widget.id;
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BusinessProfilePage()));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0XFF0EA102),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            "Visit Profile",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30),
                                            ),
                                          ),
                                          context: context,
                                          backgroundColor: Theme.of(context).colorScheme.background,
                                          builder: (BuildContext context) {
                                            return CustomTickerDetailsBottomSheet(
                                                category: widget.category,
                                                id: widget.id,
                                                exchange: widget.exchange,
                                                country: widget.country,
                                                name: widget.name);
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5), //Colors.black.withOpacity(0.1),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            "Insights",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width: width / 1.25,
                                  child: Text(
                                    tickerDetailAddress == "" ? "Address not available" : tickerDetailAddress,
                                    style: TextStyle(
                                      fontSize: text.scale(14),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0XFF48B83F),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: height / 35.03,
                              width: width / 16.30,
                              margin: const EdgeInsets.only(right: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 8, color: const Color(0xffA5A5A5).withOpacity(0.5)),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("CandleStick Chart", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Container(
                        height: 42,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FadeTransition(
                          opacity: _animationController,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.green.shade200,
                            onPressed: () async {
                              setState(() {
                                finalisedCategory = widget.category.toLowerCase();
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => FinalChartPage(
                                            tickerId: widget.id,
                                            category: widget.category,
                                            exchange: widget.exchange,
                                            chartType: "1",
                                            index: 0,
                                          )));
                            },
                            child: SvgPicture.asset("lib/Constants/Assets/ChartPage/Landscape.svg",
                                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn), height: 10, width: 10),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        height: height / 2.7,
                        width: width,
                      ),
                      Container(
                          height: height / 2.7,
                          width: width,
                          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.landscape ? 0 : 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 1),
                          ),
                          child: /*WebViewWidget(
                              controller:
                                  _controller)*/
                              InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: URLRequest(url: Uri.parse(finalUrl)),
                            initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                preferredContentMode: UserPreferredContentMode.MOBILE,
                                supportZoom: false,
                              ),
                            ),
                            //  initialUserScripts: UnmodifiableListView<UserScript>([]),
                            contextMenu: contextMenu,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (controller) async {
                              webViewController = controller;
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
                                  await launchUrl(
                                    uri,
                                  );
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
                          )),
                      Positioned(
                        left: width / 22.83,
                        bottom: height / 21.9,
                        child: Container(
                          height: height / 17.52,
                          width: width / 8.22,
                          color: Colors.transparent,
                        ),
                      )
                    ],
                  )
                ],
              )
            : Center(
                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
              ),
      )),
    );
  }
}

RxString firstHalf = "".obs;
RxString secondHalf = "".obs;
RxBool flag = true.obs;
RxString tickerDetailPageDescription = "".obs;
RxString tickerDetailPageWebUrl = "".obs;

RxDouble leftMinDetailPage = 0.0.obs;
RxDouble leftMaxDetailPage = 0.0.obs;
RxString priTickerDetailPageCurrentPrice = "".obs;
RxString priTickerDetailPageCurrentTime = "".obs;
RxString priTickerDetailPageHighestPrice = "".obs;
RxString priTickerDetailPageLowestPrice = "".obs;
RxString priTickerDetailPageTradingId = "".obs;
RxString priTickerDetailPageCreatedTime = "".obs;
RxString priTickerDetailPageWeekLow = "".obs;
RxString priTickerDetailPageWeekHigh = "".obs;
RxString priTickerDetailPageMarketCapValue = "".obs;
RxString priTickerDetailPageCirculationSupplyValue = "".obs;
RxString priTickerDetailPageDividendValue = "".obs;
RxString priTickerDetailPageLastDividendDateValue = "".obs;
RxString priTickerDetailPageDividendProviderValue = "".obs;
RxString priTickerDetailPageChangeValue = "".obs;
RxString priTickerDetailPageChangePercentage = "".obs;
RxString priTickerDetailPageState = "Increse".obs;
RxString priTickerDetailPageEpse = "".obs;
RxString priTickerDetailPageShares = "".obs;
RxString priTickerDetailPageEBit = "".obs;
RxString priTickerDetailPagePeRatio = "".obs;
RxString priTickerDetailPagePegRatio = "".obs;
RxString priTickerDetailPageRevenue = "".obs;
RxString priTickerDetailPageForward = "".obs;
RxString tickerDetailPageName = "".obs;

class CustomTickerDetailsBottomSheet extends StatefulWidget {
  final String category;
  final String id;
  final String exchange;
  final String country;
  final String name;

  const CustomTickerDetailsBottomSheet(
      {Key? key, required this.category, required this.id, required this.exchange, required this.country, required this.name})
      : super(key: key);

  @override
  State<CustomTickerDetailsBottomSheet> createState() => _CustomTickerDetailsBottomSheetState();
}

class _CustomTickerDetailsBottomSheetState extends State<CustomTickerDetailsBottomSheet> {
  final _recipientController = TextEditingController(
    text: 'support@tradewatch.in',
  );
  List<String> attachments = [];
  bool isHTML = false;
  String mainUserToken = "";
  List<String> compareRelatedStocks = [
    "lib/Constants/Assets/ComparePageNew/Stock_news.png",
    "lib/Constants/Assets/ComparePageNew/Stocks_Videos.png",
    "lib/Constants/Assets/ComparePageNew/Stocks_Forums.png",
    "lib/Constants/Assets/ComparePageNew/Stock_surveys.png"
  ];
  List<String> compareRelatedCrypto = [
    "lib/Constants/Assets/ComparePageNew/Crypto_News.jpg",
    "lib/Constants/Assets/ComparePageNew/Crypto_Videos.png",
    "lib/Constants/Assets/ComparePageNew/Crypto_Forums.png",
    "lib/Constants/Assets/ComparePageNew/Crypto_Surveys.png"
  ];
  List<String> compareRelatedCommodity = [
    "lib/Constants/Assets/ComparePageNew/Commodity_News.png",
    "lib/Constants/Assets/ComparePageNew/Commodity_Video.png",
    "lib/Constants/Assets/ComparePageNew/Commodity_forum.png",
    "lib/Constants/Assets/ComparePageNew/Commodity_Survey.png"
  ];
  List<String> compareRelatedForex = [
    "lib/Constants/Assets/ComparePageNew/Forex_News.png",
    "lib/Constants/Assets/ComparePageNew/Forex_Videos.png",
    "lib/Constants/Assets/ComparePageNew/Forex_Forums.png",
    "lib/Constants/Assets/ComparePageNew/Forex_Survey.png"
  ];
  List<String> compareRelatedCatName = ["News", "Videos", "Forum", "Survey"];

  Future<void> _launchUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  userInsightFunc({required String typeData, required String aliasData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString("newUserToken")!;
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    await http.post(url,
        body: {"alias": aliasData, "type": typeData}, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': mainUserToken});
  }

  Future<void> send() async {
    final Email email = Email(
      body: "",
      subject: "",
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = "you don't have a mail app to contact";
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      height: 600,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            spreadRadius: 0.0,
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w700),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: const Icon(Icons.cancel_outlined))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width,
                    margin: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Description",
                                style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w700),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (mainSkipValue) {
                                  commonFlushBar(context: context, initFunction: initState);
                                } else {
                                  mainVariables.selectedTickerId.value = widget.id;
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BusinessProfilePage()));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0XFF0EA102),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      "Visit Profile",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 50.75),
                        tickerDetailPageDescription.value == ""
                            ? Text(
                                "Description not available",
                                style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                              )
                            : Obx(
                                () => secondHalf.isEmpty
                                    ? Text(
                                        firstHalf.value,
                                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                      )
                                    : Column(
                                        children: <Widget>[
                                          Text(
                                            flag.value ? ("${firstHalf.value}...") : (firstHalf.value + secondHalf.value),
                                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                            maxLines: 500,
                                          ),
                                          InkWell(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  flag.value ? "show more" : "show less",
                                                  style: const TextStyle(color: Color(0XFF48B83F)),
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
                        SizedBox(height: height / 50.75),
                      ],
                    ),
                  ),
                  Obx(
                    () => flag.value
                        ? secondHalf.value.isEmpty
                            ? InkWell(
                                onTap: tickerDetailPageWebUrl.value == ""
                                    ? () {}
                                    : () {
                                        _launchUrl(url: tickerDetailPageWebUrl.value);
                                      },
                                child: Container(
                                  height: height / 13.53,
                                  margin: EdgeInsets.symmetric(horizontal: width / 25),
                                  color: const Color(0XFF48B83F),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                                        child: Image.asset("lib/Constants/Assets/SMLogos/click_net.png"),
                                      ),
                                      Text(
                                        tickerDetailPageWebUrl.value == "" ? "Website url not available" : tickerDetailPageWebUrl.value,
                                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox()
                        : InkWell(
                            onTap: tickerDetailPageWebUrl.value == ""
                                ? () {}
                                : () {
                                    _launchUrl(url: tickerDetailPageWebUrl.value);
                                  },
                            child: Container(
                              height: height / 13.53,
                              margin: EdgeInsets.symmetric(horizontal: width / 25),
                              color: const Color(0XFF48B83F),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                                    child: Image.asset("lib/Constants/Assets/SMLogos/click_net.png"),
                                  ),
                                  Text(
                                    tickerDetailPageWebUrl.value == "" ? "Website url not available" : tickerDetailPageWebUrl.value,
                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  Obx(
                    () => flag.value
                        ? secondHalf.value.isEmpty
                            ? SizedBox(
                                height: height / 50.75,
                              )
                            : const SizedBox()
                        : SizedBox(
                            height: height / 50.75,
                          ),
                  ),
                  SizedBox(
                    height: height / 33.83,
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 15.3,
                      width: width / 1.23,
                      child: Center(
                        child: Text(
                          "The price shown here is indicative and may not be accurate. The past price does not always guarantee future price.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400, color: const Color(0xffA5A5A5)),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 50.75,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                    child: Text(
                      "Summary",
                      style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: height / 50.75),
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
                      margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(
                                      tickerDetailPageName.value,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: text.scale(10), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Current Price ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600)),
                                widget.category == "stocks"
                                    ? widget.exchange == "NSE" || widget.exchange == "BSE"
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("\u{20B9}",
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, fontFamily: "Robonto")),
                                              Text(priTickerDetailPageCurrentPrice.value,
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600)),
                                            ],
                                          )
                                        : Text("\$ ${priTickerDetailPageCurrentPrice.value}",
                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600))
                                    : widget.category == "commodity"
                                        ? widget.exchange == "India"
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("\u{20B9}",
                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, fontFamily: "Robonto")),
                                                  Text(priTickerDetailPageCurrentPrice.value,
                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600)),
                                                ],
                                              )
                                            : Text("\$ ${priTickerDetailPageCurrentPrice.value}",
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600))
                                        : widget.category == "forex"
                                            ? Text(priTickerDetailPageCurrentPrice.value,
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600))
                                            : Text("\$ ${priTickerDetailPageCurrentPrice.value}",
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Highest Price ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                widget.category == "stocks"
                                    ? widget.exchange == "NSE" || widget.exchange == "BSE"
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("\u{20B9}",
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Robonto")),
                                              Text(leftMaxDetailPage.value.toStringAsFixed(2),
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                            ],
                                          )
                                        : Text("\$ ${leftMaxDetailPage.value.toStringAsFixed(2)}",
                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))
                                    : widget.category == "commodity"
                                        ? widget.exchange == "India"
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("\u{20B9}",
                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Robonto")),
                                                  Text(leftMaxDetailPage.value.toStringAsFixed(2),
                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                                ],
                                              )
                                            : Text("\$ ${leftMaxDetailPage.value.toStringAsFixed(2)}",
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))
                                        : widget.category == "forex"
                                            ? Text(leftMaxDetailPage.value.toStringAsFixed(2),
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))
                                            : Text("\$ ${leftMaxDetailPage.value.toStringAsFixed(2)}",
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Lowest Price ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                widget.category == "stocks"
                                    ? widget.exchange == "NSE" || widget.exchange == "BSE"
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("\u{20B9}",
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Robonto")),
                                              Text(leftMinDetailPage.value.toStringAsFixed(2),
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                            ],
                                          )
                                        : Text("\$ ${leftMinDetailPage.value.toStringAsFixed(2)}",
                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))
                                    : widget.category == "commodity"
                                        ? widget.exchange == "India"
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("\u{20B9}",
                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Robonto")),
                                                  Text(leftMinDetailPage.value.toStringAsFixed(2),
                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                                ],
                                              )
                                            : Text("\$ ${leftMinDetailPage.value.toStringAsFixed(2)}",
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))
                                        : widget.category == "forex"
                                            ? Text(leftMinDetailPage.value.toStringAsFixed(2),
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))
                                            : Text("\$ ${leftMinDetailPage.value.toStringAsFixed(2)}",
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("52 wk Range",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text("${priTickerDetailPageWeekLow.value} - ${priTickerDetailPageWeekHigh.value}",
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("24h Trading Volume (M)",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child:
                                        Text("_", textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Market Cap (M)",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageMarketCapValue.value.split('.')[0].trim().toString(),
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Circulation Supply ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageCirculationSupplyValue.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("shares (M)",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageShares.value.split('.')[0].trim().toString(),
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("EPS", textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageEpse.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("EBITDA (M)",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageEBit.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("PE Ratio ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPagePeRatio.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("PEG Ratio",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPagePegRatio.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Revenue (M)",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageRevenue.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Dividends (Yield)",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageForward.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Dividend ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageDividendValue.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Last Dividend Announced ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageLastDividendDateValue.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Last Dividend Provided ",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child: Text(priTickerDetailPageDividendProviderValue.value,
                                        textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Next Dividend Date",
                                    textAlign: TextAlign.start, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400)),
                                SizedBox(
                                    width: width / 4.91,
                                    child:
                                        Text("_", textAlign: TextAlign.end, style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height / 32.48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Something wrong?  ",
                          style: TextStyle(
                            fontSize: text.scale(12),
                            fontWeight: FontWeight.w700,
                          )),
                      InkWell(
                        onTap: () {
                          showSheet();
                        },
                        child: Text("Contact support",
                            style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w700, color: const Color(0XFF0EA102))),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 25.45),
                  Obx(() => Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Other $tickerDetailPageName Related Information",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: height / 54.13,
                            ),
                            SizedBox(
                              height: height / 4.5,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: index == 0 ? 0 : width / 62.5, right: index == 8 ? width / 31.25 : width / 62.5, bottom: 15),
                                      child: InkWell(
                                        onTap: () {
                                          if (mainSkipValue) {
                                            index == 0
                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return NewsMainPage(
                                                      fromCompare: true,
                                                      text: widget.category,
                                                      tickerId: widget.id,
                                                      tickerName: tickerDetailPageName.value,
                                                      homeSearch: true,
                                                    );
                                                  }))
                                                : index == 1
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return VideosMainPage(
                                                          fromCompare: true,
                                                          text: widget.category,
                                                          tickerId: widget.id,
                                                          tickerName: tickerDetailPageName.value,
                                                          homeSearch: true,
                                                        );
                                                      }))
                                                    : index == 2
                                                        ? commonFlushBar(context: context, initFunction: initState)
                                                        : index == 3
                                                            ? commonFlushBar(context: context, initFunction: initState)
                                                            : debugPrint("nothing");
                                          } else {
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return index == 0
                                                  ? NewsMainPage(
                                                      fromCompare: true,
                                                      text: widget.category,
                                                      tickerId: widget.id,
                                                      tickerName: tickerDetailPageName.value,
                                                      homeSearch: true,
                                                    )
                                                  : index == 1
                                                      ? VideosMainPage(
                                                          fromCompare: true,
                                                          text: widget.category,
                                                          tickerId: widget.id,
                                                          tickerName: tickerDetailPageName.value,
                                                          homeSearch: true,
                                                        )
                                                      : index == 2
                                                          ? DetailedForumImagePage(
                                                              text: widget.category,
                                                              fromCompare: true,
                                                              forumDetail: "",
                                                              filterId: "",
                                                              catIdList: mainCatIdList,
                                                              topic: "",
                                                              tickerId: widget.id,
                                                              tickerName: tickerDetailPageName.value,
                                                              navBool: false,
                                                              sendUserId: "",
                                                              homeSearch: true,
                                                            )
                                                          : index == 3
                                                              ? DetailedSurveyImagePage(
                                                                  surveyDetail: "",
                                                                  topic: '',
                                                                  catIdList: mainCatIdList,
                                                                  text: widget.category,
                                                                  filterId: '',
                                                                  fromCompare: true,
                                                                  tickerId: widget.id,
                                                                  tickerName: tickerDetailPageName.value,
                                                                  homeSearch: true,
                                                                )
                                                              : const MainBottomNavigationPage(
                                                                  tType: true,
                                                                  countryIndex: 0,
                                                                  text: '',
                                                                  caseNo1: 0,
                                                                  excIndex: 0,
                                                                  newIndex: 0,
                                                                  isHomeFirstTym: true,
                                                                );
                                            }));
                                          }
                                        },
                                        child: Card(
                                          elevation: 10.0,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white)),
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              widget.category == "stocks"
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                          left: index == 0 ? width / 18.75 : width / 37.5,
                                                          right: index == 8 ? width / 18.75 : width / 37.5),
                                                      width: width / 2.7,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(compareRelatedStocks[index]),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    )
                                                  : widget.category == "crypto"
                                                      ? Container(
                                                          padding: EdgeInsets.only(
                                                              left: index == 0 ? width / 18.75 : width / 37.5,
                                                              right: index == 8 ? width / 18.75 : width / 37.5),
                                                          width: width / 2.7,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage(compareRelatedCrypto[index]),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                        )
                                                      : widget.category == "commodity"
                                                          ? Container(
                                                              padding: EdgeInsets.only(
                                                                  left: index == 0 ? width / 18.75 : width / 37.5,
                                                                  right: index == 8 ? width / 18.75 : width / 37.5),
                                                              width: width / 2.7,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage(compareRelatedCommodity[index]),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                            )
                                                          : widget.category == "forex"
                                                              ? Container(
                                                                  padding: EdgeInsets.only(
                                                                      left: index == 0 ? width / 18.75 : width / 37.5,
                                                                      right: index == 8 ? width / 18.75 : width / 37.5),
                                                                  width: width / 2.7,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                      image: AssetImage(compareRelatedForex[index]),
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  padding: EdgeInsets.only(
                                                                      left: index == 0 ? width / 18.75 : width / 37.5,
                                                                      right: index == 8 ? width / 18.75 : width / 37.5),
                                                                  width: width / 2.7,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                      image: AssetImage(compareRelatedStocks[index]),
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                    color: Colors.white,
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
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                                                  color: Colors.black12.withOpacity(0.3),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    compareRelatedCatName[index],
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
                            SizedBox(height: height / 40.6)
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showSheet() {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      userInsightFunc(aliasData: 'settings', typeData: 'contact_support');
                      ZohoSalesIQ.startChat("Hello there!!");
                      ZohoSalesIQ.enableInAppNotification();
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/message-circle (1).png",
                        )),
                    title: Text(
                      "Contact via Chat",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      send();
                      userInsightFunc(aliasData: 'settings', typeData: 'contact_support');
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/mail.png",
                        )),
                    title: Text(
                      "Contact via Email",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
