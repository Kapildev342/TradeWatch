import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Constants/Common/filter_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_edit_filter_page.dart';

class LockerChartPage extends StatefulWidget {
  final String text;
  final bool fromLink;
  final bool chartsBool;

  const LockerChartPage({Key? key, required this.text, required this.fromLink, required this.chartsBool}) : super(key: key);

  @override
  State<LockerChartPage> createState() => _LockerChartPageState();
}

class _LockerChartPageState extends State<LockerChartPage> {
  final FilterFunction _filterFunction = FilterFunction();
  List titleList = [
    "News",
    "Charts",
    "Videos",
    "Forum",
    "Survey",
    "Brokers",
  ];
  List<String> categoriesList = ["Stocks", "Crypto", "Commodity", "Forex"];
  String selectedValue = "Stocks";
  String selectedWidget = "";
  String selectedIdWidget = "";
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];

  String categoryValue = "";
  String mainUserToken = "";
  String categoryNewValue = "";
  bool loading = false;
  bool loading2 = false;
  bool ddChanges = false;
  bool forEdit = false;
  bool filterBool = false;
  String filterId = "";
  String finalFilterId = "";
  Map<String, dynamic> responseData = {};
  bool waitingLoader = false;
  bool chartsEnabled = true;
  List<AssetImage> assetList = [
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/News.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/charts.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Videos.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/ForumNew.jpg"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/SurveyNew.jpg"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Brokers.png"),
  ];
  List<Map<String, dynamic>> gridChartList = [
    {
      "image": "lib/Constants/Assets/chartImages/Line Charts.png",
      "title": "Line Charts",
      "id": "2",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Compare_new.png",
      "title": "Compare",
      "id": "-1",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Candle.png",
      "title": "Candle",
      "id": "1",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Bar.png",
      "title": "Bar Chart",
      "id": "0",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Renko.png",
      "title": "Renko",
      "id": "7",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Area.png",
      "title": "Area",
      "id": "3",
    },
    {
      "image": "lib/Constants/Assets/chartImages/column.jpg",
      "title": "Column",
      "id": "4",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Baseline.png",
      "title": "Baseline Chart",
      "id": "5",
    },
    {
      "image": "lib/Constants/Assets/chartImages/High_low.png",
      "title": "High_Low",
      "id": "6",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Kagi.png",
      "title": "Kagi",
      "id": "8",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Point _ Figure.png",
      "title": "Point & Figure",
      "id": "9",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Line break.png",
      "title": "Line Break",
      "id": "10",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Heikin Ashi.png",
      "title": "Heikin Ashi",
      "id": "11",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Hollow candle.png",
      "title": "Hollow Candles",
      "id": "12",
    },
    {
      "image": "lib/Constants/Assets/chartImages/Request for a  new chart.png",
      "title": "Request for a new chart",
      "id": "14",
    }
  ];
  List<Map<String, dynamic>> gridSearchList = [];
  List<String> countryList = ["India", "USA"];
  List industriesIdList = [];
  List industriesNameList = [];
  String defaultUSA = "";
  String defaultNSE = "";
  String defaultBSE = "";
  String defaultCrypto = "";
  String defaultCommodity = "";
  String defaultForex = "";
  String editExchange = "";
  String exchangeName = "";
  String defaultFilterId = "";
  String secondaryFilterId = "";
  String defaultFilterId1 = "";
  String secondaryFilterId1 = "";
  String defaultTvSymbol = "";
  String tvSym1 = "";
  String tvSym2 = "";
  List sendTickersList = [];
  bool tickerTickAll = false;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  Future<void> filterSearchResults({required String query}) async {
    List<Map<String, dynamic>> dummySearchList = [];
    dummySearchList.addAll(gridChartList);
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      for (var item in dummySearchList) {
        if (item["title"].toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        gridSearchList.clear();
        gridSearchList.addAll(dummyListData);
        loading2 = true;
      });
      return;
    } else {
      setState(() {
        gridSearchList.clear();
        gridSearchList.addAll(gridChartList);
        loading2 = true;
      });
    }
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
            page: 'charts',
          );
        }));
      } else if (selectedValue == "Crypto") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CryptoAddFilterPage(
            text: selectedValue,
            page: 'charts',
          );
        }));
      } else if (selectedValue == "Commodity") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CommodityAddFilterPage(
            text: selectedValue,
            page: 'charts',
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForexAddFilterPage(
            text: selectedValue,
            page: 'charts',
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

  getSelectedNewValue() async {
    setState(() {
      loading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + getLocker);
    var response = await http.post(url, headers: {'Authorization': mainUserToken});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      setState(() {
        categoryValue = responseData["response"]["locker"];
        if (categoryValue == "stocks") {
          setState(() {
            selectedValue = "Stocks";
            loading = true;
            selectedWidget = "All $selectedValue";
            finalisedCategory = selectedValue;
            prefs.setString('finalisedCategory1', finalisedCategory);
          });
        } else if (categoryValue == "crypto") {
          setState(() {
            selectedValue = "Crypto";
            loading = true;
            selectedWidget = "All $selectedValue";
            finalisedCategory = selectedValue;
            prefs.setString('finalisedCategory1', finalisedCategory);
          });
        } else if (categoryValue == "commodity") {
          setState(() {
            selectedValue = "Commodity";
            loading = true;
            selectedWidget = "All $selectedValue";
            finalisedCategory = selectedValue;
            prefs.setString('finalisedCategory1', finalisedCategory);
          });
        } else if (categoryValue == "forex") {
          setState(() {
            selectedValue = "Forex";
            loading = true;
            selectedWidget = "All $selectedValue";
            finalisedCategory = selectedValue;
            prefs.setString('finalisedCategory1', finalisedCategory);
          });
        } else {
          setState(() {
            selectedValue = categoryValue;
            loading = true;
            selectedWidget = "All $selectedValue";
            selectedIdWidget = "";
            finalisedCategory = selectedValue;
            prefs.setString('finalisedCategory1', finalisedCategory);
          });
        }
      });
      getFil(type: categoryValue, filterId: finalisedFilterId);
    }
  }

  getSelectedValue({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + saveKey);
    await http.post(url, headers: {'Authorization': mainUserToken}, body: {'locker': value.toLowerCase()});
  }

  @override
  void initState() {
    chartsEnabled = widget.chartsBool;
    getAllDataMain(name: 'Chart_Main_Page');
    getAllData();
    super.initState();
  }

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  getAllData() async {
    getNotifyCountAndImage();
    await getEx();
    await getIndustries(newSetState: setState);
    lockerVariables.chartsTrendListMain = (lockerVariables.chartScreenContents.response[0].responseList).obs;
    lockerVariables.chartsVolatilityListMain = (lockerVariables.chartScreenContents.response[1].responseList).obs;
    lockerVariables.chartsBasicListMain = (lockerVariables.chartScreenContents.response[2].responseList).obs;
    lockerVariables.chartsPatternListMain = (lockerVariables.chartScreenContents.response[3].responseList).obs;
    lockerVariables.chartsComparisonListMain = (lockerVariables.chartScreenContents.response[4].responseList).obs;
    lockerVariables.chartsRequestListMain = (lockerVariables.chartScreenContents.response[5].responseList).obs;
    await lockerFunctions.filterChartSearchResults(query: "");
    if (mainSkipValue) {
      finalisedCategory = widget.text;
      finalisedFilterId = "";
      finalisedFilterName = "";
      selectedValue = finalisedCategory;
      selectedWidget = finalisedFilterName;
      selectedIdWidget = finalisedFilterId;
      categoryValue = widget.text.toLowerCase();
      if (categoryValue == "stocks") {
        setState(() {
          selectedValue = "Stocks";
          loading = true;
          selectedWidget = "All $selectedValue";
          finalisedCategory = selectedValue;
        });
      } else if (categoryValue == "crypto") {
        setState(() {
          selectedValue = "Crypto";
          loading = true;
          selectedWidget = "All $selectedValue";
          finalisedCategory = selectedValue;
        });
      } else if (categoryValue == "commodity") {
        setState(() {
          selectedValue = "Commodity";
          loading = true;
          selectedWidget = "All $selectedValue";
          finalisedCategory = selectedValue;
        });
      } else if (categoryValue == "forex") {
        setState(() {
          selectedValue = "Forex";
          loading = true;
          selectedWidget = "All $selectedValue";
          finalisedCategory = selectedValue;
        });
      } else {
        setState(() {
          selectedValue = categoryValue;
          loading = true;
          selectedWidget = "All $selectedValue";
          selectedIdWidget = "";
          finalisedCategory = selectedValue;
        });
      }
      getConstantTicker();
      setState(() {
        loading = true;
      });
    } else {
      if (widget.text != "") {
        widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterId = "";
        widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterName = "";
        finalisedCategory = widget.text;
      }
      selectedValue = finalisedCategory;
      selectedWidget = finalisedFilterName;
      selectedIdWidget = finalisedFilterId;
      getAllDataMain(name: 'Locker_Screen');
      if (widget.fromLink) {
        await getSelectedValue(value: widget.text);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          categoryValue = widget.text.toLowerCase();
          if (categoryValue == "stocks") {
            setState(() {
              selectedValue = "Stocks";
              loading = true;
              selectedWidget = "All $selectedValue";
              finalisedCategory = selectedValue;
              prefs.setString('finalisedCategory1', finalisedCategory);
            });
          } else if (categoryValue == "crypto") {
            setState(() {
              selectedValue = "Crypto";
              loading = true;
              selectedWidget = "All $selectedValue";
              finalisedCategory = selectedValue;
              prefs.setString('finalisedCategory1', finalisedCategory);
            });
          } else if (categoryValue == "commodity") {
            setState(() {
              selectedValue = "Commodity";
              loading = true;
              selectedWidget = "All $selectedValue";
              finalisedCategory = selectedValue;
              prefs.setString('finalisedCategory1', finalisedCategory);
            });
          } else if (categoryValue == "forex") {
            setState(() {
              selectedValue = "Forex";
              loading = true;
              selectedWidget = "All $selectedValue";
              finalisedCategory = selectedValue;
              prefs.setString('finalisedCategory1', finalisedCategory);
            });
          } else {
            setState(() {
              selectedValue = categoryValue;
              loading = true;
              selectedWidget = "All $selectedValue";
              selectedIdWidget = "";
              finalisedCategory = selectedValue;
              prefs.setString('finalisedCategory1', finalisedCategory);
            });
          }
        });
        await getFil(type: categoryValue, filterId: finalisedFilterId);
      } else {
        await getSelectedValue(value: selectedValue);
        await getSelectedNewValue();
      }
    }
  }

  getFil({required String type, required String filterId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + getFilter);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"type": type.toLowerCase()});
    var responseData = json.decode(response.body);
    enteredFilteredList.clear();
    enteredFilteredIdList.clear();
    if (responseData["response"].length == 0) {
      selectedWidget = "All $selectedValue";
      selectedIdWidget = "";
      finalisedFilterName = selectedWidget;
      finalisedFilterId = "";
      prefs.setString('finalisedFilterId1', finalisedFilterId);
      prefs.setString('finalisedFilterName1', finalisedFilterName);
      await getConstantTicker();
      setState(() {
        loading = true;
      });
    } else {
      for (int i = 0; i < responseData["response"].length; i++) {
        enteredFilteredList.add(responseData["response"][i]["title"]);
        enteredFilteredIdList.add(responseData["response"][i]["_id"]);
      }
      if (filterId == "") {
        selectedWidget = enteredFilteredList[0];
        selectedIdWidget = enteredFilteredIdList[0];
        finalisedFilterName = enteredFilteredList[0];
        finalisedFilterId = enteredFilteredIdList[0];
        prefs.setString('finalisedFilterId1', finalisedFilterId);
        prefs.setString('finalisedFilterName1', finalisedFilterName);
        await getConstantTicker();
        setState(() {});
      } else {
        for (int i = 0; i < enteredFilteredIdList.length; i++) {
          if (enteredFilteredIdList[i] == filterId) {
            selectedWidget = enteredFilteredList[i];
            selectedIdWidget = enteredFilteredIdList[i];
            finalisedFilterName = enteredFilteredList[i];
            finalisedFilterId = enteredFilteredIdList[i];
            prefs.setString('finalisedFilterId1', finalisedFilterId);
            prefs.setString('finalisedFilterName1', finalisedFilterName);
            await getConstantTicker();
            setState(() {});
          }
        }
      }
    }
  }

  getFilNonLogin({required String type, required String filterId}) async {
    selectedWidget = "All $selectedValue";
    selectedIdWidget = "";
    finalisedFilterName = selectedWidget;
    finalisedFilterId = "";
    await getConstantTicker();
    setState(() {});
  }

  getIndustries({required StateSetter newSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    industriesNameList.clear();
    industriesIdList.clear();
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': 'crypto',
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        newSetState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    }
  }

  getCompareValues1(
      {required int newIndex1,
      required int excIndex1,
      required int indusIndex1,
      required int countryIndex1,
      required StateSetter newSetState1,
      required String text1}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionLocker + tvTickersList;
    if (newIndex1 == 0) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[newIndex1],
        "exchange_id": finalExchangeIdList[excIndex1],
        "skip": 0,
        "search": text1,
        'compare_type': "primary"
      };
    } else if (newIndex1 == 1) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[newIndex1],
        "industry_id": industriesIdList[indusIndex1],
        "skip": 0,
        "search": text1,
        'compare_type': "primary"
      };
    } else if (newIndex1 == 2) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[newIndex1],
        "country": countryList[countryIndex1],
        "skip": 0,
        "search": text1,
        'compare_type': "primary"
      };
    } else {
      data = {"category": "forex", "category_id": mainCatIdList[newIndex1], "skip": 0, "search": text1, 'compare_type': "primary"};
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (newIndex1 == 0) {
        if (excIndex1 == 0) {
          defaultFilterId = responseData["response"][0]["_id"];
          secondaryFilterId = responseData["response"][1]["_id"];
        } else if (excIndex1 == 1) {
          defaultFilterId = responseData["response"][0]["_id"];
          secondaryFilterId = responseData["response"][1]["_id"];
        } else if (excIndex1 == 2) {
          defaultFilterId1 = responseData["response"][0]["_id"];
          secondaryFilterId1 = responseData["response"][1]["_id"];
        }
      } else if (newIndex1 == 1) {
        defaultFilterId = responseData["response"][0]["_id"];
        secondaryFilterId = responseData["response"][1]["_id"];
        defaultFilterId1 = "";
        secondaryFilterId1 = "";
      } else if (newIndex1 == 2) {
        defaultFilterId = responseData["response"][0]["_id"];
        secondaryFilterId = responseData["response"][1]["_id"];
        defaultTvSymbol = responseData["response"][0]["tv_symbol"];
        if (defaultTvSymbol == "") {
          tvSym1 = "MCX";
          tvSym2 = "MENTHAOIL1%21";
        } else {
          List parts = defaultTvSymbol.split(":");
          tvSym1 = parts[0].trim();
          tvSym2 = parts[1].trim();
        }
        defaultFilterId1 = "";
        secondaryFilterId1 = "";
      } else if (newIndex1 == 3) {
        defaultFilterId = responseData["response"][0]["_id"];
        secondaryFilterId = responseData["response"][1]["_id"];
        defaultFilterId1 = "";
        secondaryFilterId1 = "";
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  getConstantTicker() async {
    if (finalisedFilterId == "") {
      if (finalisedCategory.toLowerCase() == 'stocks') {
        await getCompareValues1(newIndex1: 0, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
        await getCompareValues1(newIndex1: 0, excIndex1: 2, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
        setState(() {
          exchangeName = "NSE";
        });
      } else if (finalisedCategory.toLowerCase() == 'crypto') {
        await getCompareValues1(newIndex1: 1, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
        setState(() {
          exchangeName = "";
        });
      } else if (finalisedCategory.toLowerCase() == 'commodity') {
        await getCompareValues1(newIndex1: 2, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
        setState(() {
          exchangeName = "";
        });
      } else if (finalisedCategory.toLowerCase() == 'forex') {
        await getCompareValues1(newIndex1: 3, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
        setState(() {
          exchangeName = "";
        });
      } else {}
      setState(() {});
    } else {
      var editResponse = await _filterFunction.getEditFilter(filterId: finalisedFilterId);
      tickerTickAll = editResponse["response"]["alltickers"];
      if (tickerTickAll == false) {
        sendTickersList = editResponse["response"]["tickers_list"];
        defaultFilterId = sendTickersList[0]["_id"];
        editExchange = sendTickersList[0]['exchange'];
        for (int i = 0; i < sendTickersList.length; i++) {
          if (sendTickersList[i].containsKey("tv_symbol")) {
            defaultTvSymbol = sendTickersList[i]["tv_symbol"];
            break;
          } else {
            defaultTvSymbol = "";
          }
        }
        if (finalisedCategory.toLowerCase() == "stocks") {
          setState(() {
            exchangeName = editExchange == "NSE" || editExchange == "BSE" || editExchange == "INDX" ? editExchange : "US";
          });
        } else {
          setState(() {
            exchangeName = editExchange != "INDX" ? "" : editExchange;
          });
        }
        if (defaultTvSymbol == "") {
          tvSym1 = "MCX";
          tvSym2 = "MENTHAOIL1%21";
        } else {
          List parts = defaultTvSymbol.split(":");
          tvSym1 = parts[0].trim();
          tvSym2 = parts[1].trim();
        }
        setState(() {});
      } else {
        if (finalisedCategory.toLowerCase() == 'stocks') {
          await getCompareValues1(newIndex1: 0, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
          await getCompareValues1(newIndex1: 0, excIndex1: 2, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
          setState(() {
            exchangeName = "NSE";
          });
        } else if (finalisedCategory.toLowerCase() == 'crypto') {
          await getCompareValues1(newIndex1: 1, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
          setState(() {
            exchangeName = "";
          });
        } else if (finalisedCategory.toLowerCase() == 'commodity') {
          await getCompareValues1(newIndex1: 2, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
          setState(() {
            exchangeName = "";
          });
        } else if (finalisedCategory.toLowerCase() == 'forex') {
          await getCompareValues1(newIndex1: 3, excIndex1: 1, indusIndex1: 0, countryIndex1: 0, newSetState1: setState, text1: '');
          setState(() {
            exchangeName = "";
          });
        } else {}
        editExchange = editResponse["response"]["exchange"];
        if (finalisedCategory.toLowerCase() == "stocks") {
          setState(() {
            exchangeName = editExchange == "NSE" || editExchange == "BSE" || editExchange == "INDX" ? editExchange : "US";
          });
        } else {
          setState(() {
            exchangeName = editExchange != "INDX" ? "" : editExchange;
          });
        }
        setState(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adVariables.bannerAdUnitId,
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
    super.didChangeDependencies();
    precacheImage(assetList[0], context);
    precacheImage(assetList[1], context);
    precacheImage(assetList[2], context);
    precacheImage(assetList[3], context);
    precacheImage(assetList[4], context);
    precacheImage(assetList[5], context);
  }

  @override
  void dispose() {
    extraContainMain.value = false;
    _bannerAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return const MainBottomNavigationPage(
            tType: true,
            text: "",
            caseNo1: 0,
            newIndex: 0,
            excIndex: 1,
            countryIndex: 0,
            isHomeFirstTym: false,
          );
        }));
        lockerVariables.searchChartControllerMain.value.clear();
        await lockerFunctions.filterChartSearchResults(query: "");
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
                body: loading
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            height: height / 6.928,
                            child: Column(
                              children: [
                                SizedBox(height: height / 57.73),
                                SizedBox(
                                  height: height / 14.93,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Charts",
                                          /*style: TextStyle(
                                          fontSize: text.scale(26),
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: "Poppins",
                                        ),*/
                                          style: Theme.of(context).textTheme.titleLarge),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                          const SizedBox(
                                            width: 8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height / 57.73),
                                SizedBox(
                                  height: height / 24.74,
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
                                                      child:
                                                          SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", fit: BoxFit.fill),
                                                    )
                                                  : selectedValue == "Commodity"
                                                      ? SizedBox(
                                                          height: height / 35.03,
                                                          width: width / 16.30,
                                                          child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png",
                                                              fit: BoxFit.fill),
                                                        )
                                                      : SizedBox(
                                                          height: height / 35.03,
                                                          width: width / 16.30,
                                                          child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png",
                                                              fit: BoxFit.fill),
                                                        ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Obx(
                                            () => extraContainMain.value
                                                ? Text(
                                                    selectedValue,
                                                    //style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                                    style: Theme.of(context).textTheme.bodyMedium,
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
                                                        if (mainSkipValue) {
                                                          setState(() {
                                                            extraContainMain.value = false;
                                                            filterBool = false;
                                                            selectedValue = value!;
                                                            finalisedCategory = selectedValue;
                                                          });
                                                          await getFilNonLogin(type: selectedValue, filterId: "");
                                                        } else {
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          setState(() {
                                                            extraContainMain.value = false;
                                                            filterBool = false;
                                                            selectedValue = value!;
                                                            finalisedCategory = selectedValue;
                                                          });
                                                          prefs.setString('finalisedCategory1', finalisedCategory);
                                                          await getFil(type: finalisedCategory, filterId: "");
                                                          await getSelectedValue(value: finalisedCategory);
                                                        }
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
                                                      /*icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                            ),
                                            iconSize: 24,
                                            iconEnabledColor: Colors.black54,
                                            iconDisabledColor: Colors.black54,
                                            buttonHeight: 50,
                                            buttonWidth: 125,
                                            buttonElevation: 0,
                                            itemHeight: 40,
                                            dropdownMaxHeight: 200,
                                            dropdownWidth: 200,
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              color: Colors.white,
                                            ),
                                            dropdownElevation: 8,
                                            scrollbarRadius: const Radius.circular(40),
                                            scrollbarThickness: 6,
                                            scrollbarAlwaysShow: true,
                                            offset: const Offset(-20, 0),*/
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                  color: Theme.of(context).colorScheme.background,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: const Offset(0.0, -1.0),
                                    )
                                  ]),
                              child: Obx(
                                () => extraContainMain.value
                                    ? Stack(
                                        children: [
                                          lockerWidgets.getBodyChartsWidget(
                                              context: context,
                                              bannerAdIsLoaded: _bannerAdIsLoaded,
                                              bannerAd: _bannerAd,
                                              exchangeName: exchangeName,
                                              defaultTvSymbol: defaultTvSymbol,
                                              defaultFilterId: defaultFilterId,
                                              defaultFilterId1: defaultFilterId1,
                                              secondaryFilterId: secondaryFilterId,
                                              secondaryFilterId1: secondaryFilterId1,
                                              tvSym2: tvSym2,
                                              tvSym1: tvSym1,
                                              filterEnabled: true),
                                          Positioned(
                                            right: width / 27.4,
                                            child: Container(
                                              width: width * 0.6,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Theme.of(context).colorScheme.background,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                    blurRadius: 1,
                                                    spreadRadius: 1,
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
                                                              extraContainMain.value = false;
                                                              selectedWidget = enteredFilteredList[index];
                                                              filterBool = true;
                                                              filterId = enteredFilteredIdList[index];
                                                              finalFilterId = filterId;
                                                              finalisedFilterId = enteredFilteredIdList[index];
                                                              finalisedFilterName = enteredFilteredList[index];
                                                              prefs.setString('finalisedFilterId1', finalisedFilterId);
                                                              prefs.setString('finalisedFilterName1', finalisedFilterName);
                                                            });
                                                            await getFil(type: finalisedCategory.toLowerCase(), filterId: finalisedFilterId);
                                                          },
                                                          title: Text(enteredFilteredList[index],
                                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                          trailing: SizedBox(
                                                            width: 85,
                                                            child: Row(
                                                              children: [
                                                                IconButton(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                    onPressed: () async {
                                                                      var response =
                                                                          await _filterFunction.getEditFilter(filterId: enteredFilteredIdList[index]);
                                                                      extraContainMain.value = false;
                                                                      if (selectedValue == "Stocks") {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return StocksEditFilterPage(
                                                                            text: selectedValue,
                                                                            filterId: enteredFilteredIdList[index],
                                                                            response: response,
                                                                            page: 'locker',
                                                                          );
                                                                        }));
                                                                      } else if (selectedValue == "Crypto") {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return CryptoEditFilterPage(
                                                                            text: selectedValue,
                                                                            filterId: enteredFilteredIdList[index],
                                                                            response: response,
                                                                            page: 'locker',
                                                                          );
                                                                        }));
                                                                      } else if (selectedValue == "Commodity") {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return CommodityEditFilterPage(
                                                                            text: selectedValue,
                                                                            filterId: enteredFilteredIdList[index],
                                                                            response: response,
                                                                            page: 'locker',
                                                                          );
                                                                        }));
                                                                      } else {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return ForexEditFilterPage(
                                                                            text: selectedValue,
                                                                            filterId: enteredFilteredIdList[index],
                                                                            response: response,
                                                                            page: 'locker',
                                                                          );
                                                                        }));
                                                                      }
                                                                    },
                                                                    splashRadius: 0.1,
                                                                    icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                SizedBox(
                                                                  height: height / 25.375,
                                                                  width: width / 11.72,
                                                                  child: IconButton(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                      onPressed: () async {
                                                                        await _filterFunction.getDeleteFilter(filterId: enteredFilteredIdList[index]);
                                                                        await getFil(type: selectedValue, filterId: "");
                                                                      },
                                                                      splashRadius: 0.1,
                                                                      icon: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/x-circle.png")),
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
                                                            if (mainSkipValue) {
                                                              commonFlushBar(context: context, initFunction: initState);
                                                            } else {
                                                              extraContainMain.value = false;
                                                              navigationPage1();
                                                            }
                                                          },
                                                          title: const Text("Add a New List",
                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                          trailing: Container(
                                                            margin: const EdgeInsets.only(right: 10),
                                                            child: const Icon(
                                                              Icons.add_circle_outline_sharp,
                                                              color: Color(0XFF0EA102),
                                                              size: 22,
                                                            ),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : lockerWidgets.getBodyChartsWidget(
                                        context: context,
                                        bannerAdIsLoaded: _bannerAdIsLoaded,
                                        bannerAd: _bannerAd,
                                        exchangeName: exchangeName,
                                        defaultTvSymbol: defaultTvSymbol,
                                        defaultFilterId: defaultFilterId,
                                        defaultFilterId1: defaultFilterId1,
                                        secondaryFilterId: secondaryFilterId,
                                        secondaryFilterId1: secondaryFilterId1,
                                        tvSym2: tvSym2,
                                        tvSym1: tvSym1,
                                        filterEnabled: false),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      )),
          ),
        ),
      ),
    );
  }
}
