import 'dart:async';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';

class LockerEssentialsPage extends StatefulWidget {
  final String title;

  const LockerEssentialsPage({Key? key, required this.title}) : super(key: key);

  @override
  State<LockerEssentialsPage> createState() => _LockerEssentialsPageState();
}

class _LockerEssentialsPageState extends State<LockerEssentialsPage> {
  final scrollController = ScrollController();
  bool isLoading = false;
  bool isLoadingTable = false;
  int skipCount = 0;
  String legendCell = 'Company';
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  List<String> ipoTypeNameList = ["Start Date", "Filing Date"];
  List<String> ipoTypeSlugList = ["start_date", "filing_date"];
  String selectedIPOType = "Start Date";
  int adCount = 0;
  String topic = "";

  @override
  void initState() {
    getAllDataMain(name: 'Locker_Essentials');
    lockerVariables.searchEssentialControllerMain.value.clear();
    lockerVariables.industriesListMain.clear();
    lockerVariables.selectedIndustriesListMain.clear();
    lockerVariables.selectedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()).obs;
    lockerVariables.selectedPeriod = 'quater'.obs;
    lockerVariables.selectedIPOSlugType = "start_date".obs;
    lockerVariables.selectedCategory = "nse".obs;
    topic = widget.title == "dividend"
        ? "Dividends"
        : widget.title == "split"
            ? "Splits"
            : widget.title == "ipo"
                ? "IPO"
                : "Earning";
    lockerVariables.titleColumnMain = (widget.title == "dividend"
            ? ['Year', 'Date', 'Industry', 'Dividends', 'Watchlist', 'Analyze']
            : widget.title == "split"
                ? ['Split Date', 'Industry', 'Optionable', 'Old Shares', 'New Shares']
                : widget.title == "ipo"
                    ? [
                        'Offer Price',
                        'Shares',
                        'Deal Type',
                        'Start Date',
                        'Filing',
                        'Amended',
                        'Price From',
                        'Price To',
                      ]
                    : ['Actual Date', 'Industry', 'Actual', 'Estimate', 'Difference', 'Percent %', 'Market', 'Watchlist'])
        .obs;
    lockerVariables.sortListMain = (widget.title == "dividend"
            ? [
                'date',
                'industry',
                'value',
              ]
            : widget.title == "split"
                ? ['split_date', 'industry', 'optionable', 'old_shares', 'new_shares']
                : widget.title == "ipo"
                    ? ['price_from', 'price_to', 'offer_price', 'shares', 'deal_type', 'start_date', 'filing_date', 'amended_date']
                    : [
                        'name',
                        'industry',
                        'report_date',
                        'actual',
                        'estimate',
                        'difference',
                        'percent',
                      ])
        .obs;
    lockerVariables.selectedSortValue = (widget.title == "dividend"
            ? {"field": "date", "value": -1}
            : widget.title == "split"
                ? {"field": "split_date", "value": -1}
                : widget.title == "ipo"
                    ? {"field": "split_date", "value": -1}
                    : {"field": "percent", "value": -1})
        .obs;
    debugPrint("hello5465");
    getData(skipCount: "0");
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
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
      ..load();
  }

  getData({required String skipCount}) async {
    setState(() {
      isLoadingTable = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adCount = prefs.getInt("AdCount") ?? 0;
    if (adCount % 5 == 4) {
      functionsMain.createInterstitialAd(modelSetState: setState);
    }
    adCount++;
    prefs.setInt("AdCount", adCount);
    if (!context.mounted) {
      return false;
    }
    await lockerEssentialApiFunctions.lockerEssentialData(context: context, skipCount: skipCount, title: widget.title);
    setState(() {
      isLoading = true;
      isLoadingTable = true;
    });
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
      child: Scaffold(
        //backgroundColor: const Color(0XFFFFFFFF),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          //backgroundColor: const Color(0XFFFFFFFF),
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 102.75),
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
              Text(
                widget.title == "dividend"
                    ? "Dividend Calender"
                    : widget.title == "split"
                        ? "Split Calender"
                        : widget.title == "ipo"
                            ? "IPO Calender"
                            : "Earning Calendar",
                style: TextStyle(fontSize: text.scale(20), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return const NotificationsPage();
                  }));
                  if (response) {
                    await functionsMain.getNotifyCount();
                    setState(() {});
                  }
                },
                icon: widgetsMain.getNotifyBadge(context: context)),
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return mainSkipValue ? const SettingsSkipView() : const SettingsView();
                  }));
                },
                icon: widgetsMain.getProfileImage(context: context, isLogged: mainSkipValue)),
            SizedBox(
              width: width / 27.4,
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: height / 173.2),
          padding: EdgeInsets.only(left: width / 27.4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                spreadRadius: 0.0,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
              ),
            ],
          ),
          child: isLoading
              ? Column(
                  children: [
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: width / 27.4),
                      height: height / 21.65,
                      width: width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            spreadRadius: 0.0,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Obx(
                              () => TextFormField(
                                cursorColor: Colors.green,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                onChanged: (value) {
                                  if (value.isEmpty || value.isEmpty) {
                                    getData(skipCount: '0');
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    lockerVariables.searchEssentialControllerMain.refresh();
                                    setState(() {});
                                  } else {
                                    String previousValue = value;
                                    debugPrint("previousValue");
                                    debugPrint(previousValue);
                                    Timer(const Duration(seconds: 1), () {
                                      if (previousValue == lockerVariables.searchEssentialControllerMain.value.text) {
                                        getData(skipCount: '0');
                                        lockerVariables.searchEssentialControllerMain.refresh();
                                        setState(() {});
                                      }
                                    });
                                  }
                                },
                                style: Theme.of(context).textTheme.bodyMedium,
                                controller: lockerVariables.searchEssentialControllerMain.value,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    suffixIcon: lockerVariables.searchEssentialControllerMain.value.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              lockerVariables.searchEssentialControllerMain.value.clear();
                                              lockerVariables.searchEssentialControllerMain.refresh();
                                              getData(skipCount: '0');
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              setState(() {});
                                            },
                                            child: Icon(Icons.cancel,
                                                size: 22,
                                                color: lockerVariables.searchEssentialControllerMain.value.text.isEmpty
                                                    ? Theme.of(context).colorScheme.tertiary
                                                    : Theme.of(context).colorScheme.onPrimary),
                                          )
                                        : const SizedBox(),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.background,
                                    hintText: 'Search here',
                                    errorStyle: TextStyle(fontSize: text.scale(10))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width / 51.375,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await lockerEssentialWidgets.showCalenderAlertDialog(context: context, title: widget.title, modelSetState: setState);
                            },
                            child: const Icon(
                              Icons.calendar_month,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: width / 51.375,
                          ),
                          GestureDetector(
                            onTap: () {
                              lockerEssentialWidgets.sortBottomSheet(context: context, title: widget.title, modelSetState: setState);
                            },
                            child: const Icon(
                              Icons.sort,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: width / 51.375,
                          ),
                          GestureDetector(
                              onTap: () async {
                                await lockerEssentialWidgets.filterBottomSheet(context: context, title: widget.title, modelSetState: setState);
                              },
                              child: const Icon(
                                Icons.filter_alt,
                                size: 30,
                              )),
                          Obx(
                            () => lockerVariables.selectedCategory.value == "general"
                                ? const SizedBox()
                                : SizedBox(
                                    width: width / 51.375,
                                  ),
                          ),
                          Obx(
                            () => excLabelButton(text: lockerVariables.selectedCategory.value, context: context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: width / 27.4),
                      height: height / 24.74,
                      width: width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            spreadRadius: 0.0,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => TextButton(
                                  onPressed: () {
                                    lockerVariables.selectedPeriod.value = 'week';
                                    getData(skipCount: '0');
                                  },
                                  child: Text(
                                    "Week",
                                    style: TextStyle(
                                        color: lockerVariables.selectedPeriod.value == 'week'
                                            ? const Color(0XFF0EA102)
                                            : Theme.of(context).colorScheme.onPrimary),
                                  )),
                            ),
                            const Text(" | "),
                            Obx(
                              () => TextButton(
                                  onPressed: () {
                                    lockerVariables.selectedPeriod.value = 'month';
                                    getData(skipCount: '0');
                                  },
                                  child: Text(
                                    "Month",
                                    style: TextStyle(
                                        color: lockerVariables.selectedPeriod.value == 'month'
                                            ? const Color(0XFF0EA102)
                                            : Theme.of(context).colorScheme.onPrimary),
                                  )),
                            ),
                            const Text(" | "),
                            Obx(
                              () => TextButton(
                                  onPressed: () {
                                    lockerVariables.selectedPeriod.value = 'quater';
                                    getData(skipCount: '0');
                                  },
                                  child: Text(
                                    "Quarter",
                                    style: TextStyle(
                                        color: lockerVariables.selectedPeriod.value == 'quater'
                                            ? const Color(0XFF0EA102)
                                            : Theme.of(context).colorScheme.onPrimary),
                                  )),
                            ),
                            const Text(" | "),
                            Obx(
                              () => TextButton(
                                  onPressed: () {
                                    lockerVariables.selectedPeriod.value = 'year';
                                    getData(skipCount: '0');
                                  },
                                  child: Text(
                                    "Year",
                                    style: TextStyle(
                                        color: lockerVariables.selectedPeriod.value == 'year'
                                            ? const Color(0XFF0EA102)
                                            : Theme.of(context).colorScheme.onPrimary),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: width / 27.4),
                      width: width,
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.grey.shade100),
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            spreadRadius: 0.0,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 16.44, vertical: height / 57.73),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: '${DateTime.parse(lockerVariables.selectedDateTime.value).year} $topic Scorecard Current',
                                        style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(14))),
                                    TextSpan(
                                        text: ' (${DateFormat('MMM dd, yyyy').format(DateTime.parse(lockerVariables.selectedDateTime.value))})',
                                        style: TextStyle(fontFamily: "Poppins", color: Colors.grey.shade500, fontSize: text.scale(14))),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.title == "dividend"
                                          ? "Month : ${lockerVariables.lockerDividendEssentials!.value.monthCounts}"
                                          : widget.title == "split"
                                              ? "Month : ${lockerVariables.lockerSplitEssentials!.value.monthCounts}"
                                              : widget.title == "ipo"
                                                  ? "Month : ${lockerVariables.lockerIPOEssentials!.value.monthCounts}"
                                                  : "Month : ${lockerVariables.lockerEssentials!.value.monthCounts}",
                                    ),
                                    const Text(" | "),
                                    Text(
                                      widget.title == "dividend"
                                          ? "Quarter : ${lockerVariables.lockerDividendEssentials!.value.quarterCounts}"
                                          : widget.title == "split"
                                              ? "Quarter : ${lockerVariables.lockerSplitEssentials!.value.quarterCounts}"
                                              : widget.title == "ipo"
                                                  ? "Quarter : ${lockerVariables.lockerIPOEssentials!.value.quarterCounts}"
                                                  : "Quarter : ${lockerVariables.lockerEssentials!.value.quarterCounts}",
                                    ),
                                    const Text(" | "),
                                    Text(
                                      widget.title == "dividend"
                                          ? "YTD : ${lockerVariables.lockerDividendEssentials!.value.yearCounts}"
                                          : widget.title == "split"
                                              ? "YTD : ${lockerVariables.lockerSplitEssentials!.value.yearCounts}"
                                              : widget.title == "ipo"
                                                  ? "YTD : ${lockerVariables.lockerIPOEssentials!.value.yearCounts}"
                                                  : "YTD : ${lockerVariables.lockerEssentials!.value.yearCounts}",
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 108.25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width / 27.4, top: height / 173.2, bottom: height / 173.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                skipCount > 7
                                    ? GestureDetector(
                                        onTap: () {
                                          if (skipCount > 7) {
                                            skipCount = skipCount - 8;
                                            getData(skipCount: skipCount.toString());
                                          }
                                        },
                                        child: Container(
                                          height: height / 34.64,
                                          width: width / 16.44,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                widget.title == "dividend"
                                    ? Obx(() => Text(
                                          "<<  <  Page ${skipCount ~/ 8 + 1} of ${((lockerVariables.lockerDividendEssentials!.value.totalCount) / 8).ceil()}  >  >>",
                                          style: TextStyle(fontSize: text.scale(14), color: const Color(0XFF0EA102)),
                                        ))
                                    : widget.title == "split"
                                        ? Obx(() => Text(
                                              "<<  <  Page ${skipCount ~/ 8 + 1} of ${((lockerVariables.lockerSplitEssentials!.value.totalCount) / 8).ceil()}  >  >>",
                                              style: TextStyle(fontSize: text.scale(14), color: const Color(0XFF0EA102)),
                                            ))
                                        : widget.title == "ipo"
                                            ? Obx(() => Text(
                                                  "<<  <  Page ${skipCount ~/ 8 + 1} of ${((lockerVariables.lockerIPOEssentials!.value.totalCount) / 8).ceil()}  >  >>",
                                                  style: TextStyle(fontSize: text.scale(14), color: const Color(0XFF0EA102)),
                                                ))
                                            : Obx(() => Text(
                                                  "<<  <  Page ${skipCount ~/ 8 + 1} of ${((lockerVariables.lockerEssentials!.value.totalCount) / 8).ceil()}  >  >>",
                                                  style: TextStyle(fontSize: text.scale(14), color: const Color(0XFF0EA102)),
                                                )),
                                Obx(() => widget.title == "dividend"
                                    ? skipCount >= 0 && skipCount < lockerVariables.lockerDividendEssentials!.value.totalCount - 8
                                        ? GestureDetector(
                                            onTap: () {
                                              if (skipCount >= 0 && skipCount < lockerVariables.lockerDividendEssentials!.value.totalCount - 8) {
                                                skipCount = skipCount + 8;
                                                getData(skipCount: skipCount.toString());
                                              }
                                            },
                                            child: Container(
                                              height: height / 34.64,
                                              width: width / 16.44,
                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                    : widget.title == "split"
                                        ? skipCount >= 0 && skipCount < lockerVariables.lockerSplitEssentials!.value.totalCount - 8
                                            ? GestureDetector(
                                                onTap: () {
                                                  if (skipCount >= 0 && skipCount < lockerVariables.lockerSplitEssentials!.value.totalCount - 8) {
                                                    skipCount = skipCount + 8;
                                                    getData(skipCount: skipCount.toString());
                                                  }
                                                },
                                                child: Container(
                                                  height: height / 34.64,
                                                  width: width / 16.44,
                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                        : widget.title == "ipo"
                                            ? skipCount >= 0 && skipCount < lockerVariables.lockerIPOEssentials!.value.totalCount - 8
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if (skipCount >= 0 && skipCount < lockerVariables.lockerIPOEssentials!.value.totalCount - 8) {
                                                        skipCount = skipCount + 8;
                                                        getData(skipCount: skipCount.toString());
                                                      }
                                                    },
                                                    child: Container(
                                                      height: height / 34.64,
                                                      width: width / 16.44,
                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()
                                            : skipCount >= 0 && skipCount < lockerVariables.lockerEssentials!.value.totalCount - 8
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if (skipCount >= 0 && skipCount < lockerVariables.lockerEssentials!.value.totalCount - 8) {
                                                        skipCount = skipCount + 8;
                                                        getData(skipCount: skipCount.toString());
                                                      }
                                                    },
                                                    child: Container(
                                                      height: height / 34.64,
                                                      width: width / 16.44,
                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()),
                              ],
                            ),
                          ),
                          widget.title == "ipo"
                              ? Container(
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                                  margin: EdgeInsets.only(left: width / 41.1),
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      items: ipoTypeNameList
                                          .map((item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: TextStyle(fontSize: text.scale(10), color: Colors.black, fontWeight: FontWeight.w500),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedIPOType,
                                      onChanged: (value) {
                                        debugPrint(value);
                                        selectedIPOType = value!.toString();
                                        if (selectedIPOType == "Start Date") {
                                          lockerVariables.selectedIPOSlugType.value = ipoTypeSlugList[0];
                                        } else {
                                          lockerVariables.selectedIPOSlugType.value = ipoTypeSlugList[1];
                                        }
                                        debugPrint("lockerVariables.selectedIPOSlugType.value");
                                        debugPrint(lockerVariables.selectedIPOSlugType.value);
                                        lockerEssentialApiFunctions.lockerEssentialData(
                                            context: context, skipCount: skipCount.toString(), title: widget.title, modelSetState: setState);
                                      },
                                      iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          iconSize: 15,
                                          iconEnabledColor: Colors.black54,
                                          iconDisabledColor: Colors.black54),
                                      buttonStyleData: ButtonStyleData(height: height / 34.64, width: width / 5.48, elevation: 0),
                                      menuItemStyleData: MenuItemStyleData(height: height / 34.64),
                                      dropdownStyleData: DropdownStyleData(
                                          maxHeight: height / 10.825,
                                          width: width / 4.11,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                          elevation: 8,
                                          offset: const Offset(-30, 0)),
                                      /*icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          iconSize: 15,
                                          iconEnabledColor: Colors.black54,
                                          iconDisabledColor: Colors.black54,
                                          buttonHeight: _height/34.64,
                                          buttonWidth: _width/5.48,
                                          buttonElevation: 0,
                                          itemHeight: _height/34.64,
                                          dropdownMaxHeight: _height/10.825,
                                          dropdownWidth: _width/4.11,
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          dropdownElevation: 8,
                                          scrollbarRadius:
                                              const Radius.circular(40),
                                          scrollbarThickness: 0,
                                          scrollbarAlwaysShow: true,
                                          offset: const Offset(-30, 0),*/
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 108.25,
                    ),
                    Expanded(
                      child: isLoadingTable
                          ? Obx(() => lockerVariables.lockerDividendEssentialResponseList.isNotEmpty ||
                                  lockerVariables.lockerSplitEssentialResponseList.isNotEmpty ||
                                  lockerVariables.lockerIpoEssentialResponseList.isNotEmpty ||
                                  lockerVariables.lockerEssentialResponseList.isNotEmpty
                              ? StickyHeadersTable(
                                  scrollControllers: ScrollControllers(verticalBodyController: scrollController),
                                  columnsLength: lockerVariables.titleColumnMain.length,
                                  rowsLength: lockerVariables.titleRowMain.length,
                                  columnsTitleBuilder: (i) => Container(
                                      height: height / 17.32,
                                      width: width / 2.49,
                                      margin: widget.title == "dividend"
                                          ? EdgeInsets.only(right: i == 5 ? width / 27.4 : 0)
                                          : widget.title == "split"
                                              ? EdgeInsets.only(right: i == 4 ? width / 27.4 : 0)
                                              : EdgeInsets.only(right: i == 7 ? width / 27.4 : 0),
                                      decoration: BoxDecoration(
                                          color: i.isEven ? const Color(0XFF0EA102).withOpacity(0.1) : const Color(0XFF0EA102).withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                              topRight: widget.title == "dividend"
                                                  ? i == 5
                                                      ? const Radius.circular(15)
                                                      : const Radius.circular(0)
                                                  : widget.title == "split"
                                                      ? i == 4
                                                          ? const Radius.circular(15)
                                                          : const Radius.circular(0)
                                                      : i == 7
                                                          ? const Radius.circular(15)
                                                          : const Radius.circular(0))),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                            child: Text(
                                              lockerVariables.titleColumnMain[i],
                                              maxLines: 2,
                                              style:
                                                  TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                                            ),
                                          ))),
                                  rowsTitleBuilder: (i) => Container(
                                      height: height / 17.32,
                                      width: width / 3.3,
                                      decoration: BoxDecoration(
                                          color: i.isEven ? const Color(0XFF0EA102).withOpacity(0.1) : const Color(0XFF0EA102).withOpacity(0.3),
                                          borderRadius: BorderRadius.only(bottomLeft: i == 7 ? const Radius.circular(15) : const Radius.circular(0))),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                            child: lockerVariables.titleRowMain[
                                                i], /* Text(
                                              lockerVariables.titleRowMain[i],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: _text.scale(10) 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),*/
                                          ))),
                                  contentCellBuilder: (i, j) => Obx(() => Container(
                                      height: height / 17.32,
                                      width: width / 3.3,
                                      margin: widget.title == "dividend"
                                          ? EdgeInsets.only(right: i == 5 ? width / 27.4 : 0)
                                          : widget.title == "split"
                                              ? EdgeInsets.only(right: i == 4 ? width / 27.4 : 0)
                                              : EdgeInsets.only(right: i == 7 ? width / 27.4 : 0),
                                      decoration: BoxDecoration(
                                          color: j.isEven ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: widget.title == "dividend"
                                                  ? i == 5 && j == 7
                                                      ? const Radius.circular(15)
                                                      : const Radius.circular(0)
                                                  : widget.title == "split"
                                                      ? i == 4 && j == 7
                                                          ? const Radius.circular(15)
                                                          : const Radius.circular(0)
                                                      : i == 7 && j == 7
                                                          ? const Radius.circular(15)
                                                          : const Radius.circular(0))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                        child: widget.title == "ipo"
                                            ? Center(
                                                child: Text(
                                                  lockerVariables.matrixDataMain[j][i],
                                                  maxLines: 2,
                                                  style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : widget.title == "split"
                                                ? Center(
                                                    child: Text(
                                                      lockerVariables.matrixDataMain[j][i],
                                                      maxLines: 2,
                                                      style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )
                                                : widget.title == "dividend"
                                                    ? i == 0
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              lockerEssentialWidgets.extensionTableBottomSheet(
                                                                  context: context,
                                                                  year: lockerVariables.matrixDataMain[j][i],
                                                                  industry: lockerVariables.lockerDividendEssentialResponseList[j].industry,
                                                                  modelSetState: setState,
                                                                  tickerId: lockerVariables.lockerDividendEssentialResponseList[j].tickerId,
                                                                  dividendId: lockerVariables.lockerDividendEssentialResponseList[j].dividendId,
                                                                  name: lockerVariables.lockerDividendEssentialResponseList[j].name,
                                                                  code: lockerVariables.lockerDividendEssentialResponseList[j].code,
                                                                  logoUrl: lockerVariables.lockerDividendEssentialResponseList[j].tickerId);
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                lockerVariables.matrixDataMain[j][i],
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ))
                                                        : i == 4
                                                            ? GestureDetector(
                                                                onTap: mainSkipValue
                                                                    ? () {
                                                                        commonFlushBar(context: context, initFunction: initState);
                                                                      }
                                                                    : () {
                                                                        if (lockerVariables.matrixDataMain[j][i] == "true") {
                                                                          lockerVariables.matrixDataMain[j][i] = "false";
                                                                          apiFunctionsMain.getRemoveWatchList(
                                                                              tickerId:
                                                                                  lockerVariables.lockerDividendEssentialResponseList[j].tickerId,
                                                                              context: context);
                                                                        } else {
                                                                          lockerVariables.matrixDataMain[j][i] = "true";
                                                                          apiFunctionsMain.getAddWatchList(
                                                                              tickerId:
                                                                                  lockerVariables.lockerDividendEssentialResponseList[j].tickerId,
                                                                              context: context,
                                                                              modelSetState: setState);
                                                                        }
                                                                        setState(() {});
                                                                      },
                                                                child: Center(
                                                                    child: SvgPicture.asset(
                                                                  lockerVariables.matrixDataMain[j][i] == "true"
                                                                      ? isDarkTheme.value
                                                                          ? "assets/home_screen/filled_star_dark.svg"
                                                                          : "lib/Constants/Assets/SMLogos/Star.svg"
                                                                      : isDarkTheme.value
                                                                          ? "assets/home_screen/empty_star_dark.svg"
                                                                          : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                                                )))
                                                            : i == 5
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => FinalChartPage(
                                                                                    tickerId: lockerVariables.matrixDataMain[j][i],
                                                                                    category: "",
                                                                                    exchange: "",
                                                                                    chartType: "1",
                                                                                    index: 0,
                                                                                  )));
                                                                    },
                                                                    child: Center(
                                                                        child: Container(
                                                                            height: height / 28.86,
                                                                            width: width / 13.7,
                                                                            decoration: const BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Color(0XFF0EA102),
                                                                            ),
                                                                            child: Center(
                                                                                child: Icon(
                                                                              Icons.arrow_forward.obs.value,
                                                                              color: Colors.white,
                                                                            )))))
                                                                : Center(
                                                                    child: Text(
                                                                      lockerVariables.matrixDataMain[j][i],
                                                                      maxLines: 2,
                                                                      style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  )
                                                    //else part Earning part
                                                    : i == 6
                                                        ? Center(
                                                            child: lockerVariables.matrixDataMain[j][i] == ""
                                                                ? const Text(
                                                                    "-",
                                                                    textAlign: TextAlign.center,
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                          duration: const Duration(seconds: 1),
                                                                          content: Text(lockerVariables.matrixDataMain[j][i] == "BeforeMarket"
                                                                              ? "Before Market"
                                                                              : "After Market")));
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      lockerVariables.matrixDataMain[j][i] == "BeforeMarket"
                                                                          ? "lib/Constants/Assets/NewAssets/LockerScreen/before_market.svg"
                                                                          : "lib/Constants/Assets/NewAssets/LockerScreen/after_market.svg",
                                                                      height: height / 24.74,
                                                                      width: width / 11.74,
                                                                    ),
                                                                  ))
                                                        : i == 7
                                                            ? GestureDetector(
                                                                onTap: mainSkipValue
                                                                    ? () {
                                                                        commonFlushBar(context: context, initFunction: initState);
                                                                      }
                                                                    : () {
                                                                        if (lockerVariables.matrixDataMain[j][i] == "true") {
                                                                          lockerVariables.matrixDataMain[j][i] = "false";
                                                                          apiFunctionsMain.getRemoveWatchList(
                                                                              tickerId: lockerVariables.lockerEssentialResponseList[j].tickerId,
                                                                              context: context);
                                                                        } else {
                                                                          lockerVariables.matrixDataMain[j][i] = "true";
                                                                          apiFunctionsMain.getAddWatchList(
                                                                              tickerId: lockerVariables.lockerEssentialResponseList[j].tickerId,
                                                                              context: context,
                                                                              modelSetState: setState);
                                                                        }
                                                                        setState(() {});
                                                                      },
                                                                child: Center(
                                                                    child: SvgPicture.asset(
                                                                  lockerVariables.matrixDataMain[j][i] == "true"
                                                                      ? isDarkTheme.value
                                                                          ? "assets/home_screen/filled_star_dark.svg"
                                                                          : "lib/Constants/Assets/SMLogos/Star.svg"
                                                                      : isDarkTheme.value
                                                                          ? "assets/home_screen/empty_star_dark.svg"
                                                                          : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                                                )))
                                                            : Center(
                                                                child: Text(
                                                                  lockerVariables.matrixDataMain[j][i],
                                                                  maxLines: 2,
                                                                  style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                      ))),
                                  legendCell: Container(
                                      height: height / 17.32,
                                      width: width / 3.3,
                                      decoration: BoxDecoration(
                                          color: const Color(0XFF0EA102).withOpacity(0.3),
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15))),
                                      child: Center(
                                          child: Text(legendCell,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(14), color: Colors.black)))),
                                  cellAlignments: const CellAlignments.fixed(
                                    contentCellAlignment: Alignment.centerLeft,
                                    stickyColumnAlignment: Alignment.centerLeft,
                                    stickyRowAlignment: Alignment.centerLeft,
                                    stickyLegendAlignment: Alignment.centerLeft,
                                  ),
                                  cellDimensions: CellDimensions.fixed(
                                    contentCellWidth: width / 3.3,
                                    contentCellHeight: height / 17.32,
                                    stickyLegendWidth: width / 3.3,
                                    stickyLegendHeight: height / 17.32,
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: height / 5.77,
                                          width: width / 2.74,
                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'No response to display...',
                                                style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          : Center(
                              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                            ),
                    ),
                    _bannerAdIsLoaded && _bannerAd != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                            child: SizedBox(
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                ),
        ),
      ),
    );
  }
}
