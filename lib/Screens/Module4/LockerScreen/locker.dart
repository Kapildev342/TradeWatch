import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
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

class LockerPage extends StatefulWidget {
  final String text;
  final bool fromLink;
  final bool chartsBool;

  const LockerPage({Key? key, required this.text, required this.fromLink, required this.chartsBool}) : super(key: key);

  @override
  State<LockerPage> createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPage> {
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
  String selectedValue = "Crypto";
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
  bool chartsEnabled = false;
  List<AssetImage> assetList = [
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/News.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/charts.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Videos.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/ForumNew.jpg"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/SurveyNew.jpg"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Brokers.png"),
  ];
  final TextEditingController _searchController = TextEditingController();
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
            page: 'locker',
          );
        }));
      } else if (selectedValue == "Crypto") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CryptoAddFilterPage(
            text: selectedValue,
            page: 'locker',
          );
        }));
      } else if (selectedValue == "Commodity") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CommodityAddFilterPage(
            text: selectedValue,
            page: 'locker',
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForexAddFilterPage(
            text: selectedValue,
            page: 'locker',
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
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
    getAllDataMain(name: 'Locker_Page');
    getAllData();
    super.initState();
  }

  getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
    lockerVariables.lockerBuzzListMain = (lockerVariables.lockerScreenContents.response[0].responseList).obs;
    lockerVariables.lockerEssentialsListMain = (lockerVariables.lockerScreenContents.response[1].responseList).obs;
    lockerVariables.lockerCommunityListMain = (lockerVariables.lockerScreenContents.response[2].responseList).obs;
    lockerVariables.lockerServicesListMain = (lockerVariables.lockerScreenContents.response[3].responseList).obs;
    await lockerFunctions.filterSearchResults(query: "");
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
      //getConstantTicker();
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
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
      // await getConstantTicker();
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
        // await getConstantTicker();
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
            //  await getConstantTicker();
            setState(() {});
          } else {
            selectedWidget = enteredFilteredList[0];
            selectedIdWidget = enteredFilteredIdList[0];
            finalisedFilterName = enteredFilteredList[0];
            finalisedFilterId = enteredFilteredIdList[0];
            prefs.setString('finalisedFilterId1', finalisedFilterId);
            prefs.setString('finalisedFilterName1', finalisedFilterName);
            //  await getConstantTicker();
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
    setState(() {});
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
        if (chartsEnabled) {
          setState(() {
            chartsEnabled = false;
            getAllDataMain(name: 'All_Charts_Screen');
            _searchController.clear();
          });
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
              tType: true,
              text: "",
              caseNo1: 0,
              newIndex: 0,
              excIndex: 0,
              countryIndex: 0,
              isHomeFirstTym: false,
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
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
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
                                      Text("Locker",
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
                              margin: EdgeInsets.only(top: height / 57.73, left: 1, right: 1),
                              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
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
                                          lockerWidgets.getBodyWidget(
                                              context: context, bannerAdIsLoaded: _bannerAdIsLoaded, bannerAd: _bannerAd, filterEnabled: true),
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
                                                              setState(() {
                                                                extraContainMain.value = false;
                                                              });
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
                                    : lockerWidgets.getBodyWidget(
                                        context: context, bannerAdIsLoaded: _bannerAdIsLoaded, bannerAd: _bannerAd, filterEnabled: true),
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
