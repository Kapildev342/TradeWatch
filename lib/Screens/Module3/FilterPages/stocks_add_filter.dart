import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Constants/Common/filter_function.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';

class StocksAddFilterPage extends StatefulWidget {
  final String text;
  final String page;

  const StocksAddFilterPage({
    Key? key,
    required this.text,
    required this.page,
  }) : super(key: key);

  @override
  State<StocksAddFilterPage> createState() => _StocksAddFilterPageState();
}

class _StocksAddFilterPageState extends State<StocksAddFilterPage> {
  final FilterFunction _filterFunction = FilterFunction();
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _exchangeController = TextEditingController();
  final TextEditingController _industriesController = TextEditingController();
  final TextEditingController _stockTickersController = TextEditingController();
  final TextEditingController _industrySearchController = TextEditingController();
  final TextEditingController _tickerSearchController = TextEditingController();

  final RefreshController _refreshController = RefreshController();
  final RefreshController _controller = RefreshController();

  int stocksInt = 0;
  int stocksInt1 = 0;

  bool stateBool = false;
  bool selectAll = false;
  bool tickAll = false;
  bool tickerTickAll = false;
  bool tickerSelectAll = false;
  bool stateButtonBool = false;
  bool searchIndustry = false;

  String mainUserToken = "";
  String categoryValue = "";
  String textValue = "";
  String tickersTextValue = "";

  String _selectedExchange = "";
  String selectedIdItem = "";

  List exchangeNameList = [];
  List exchangeCodeList = [];
  List exchangeIdList = [];

  List industriesNameList = [];
  List industriesIdList = [];
  List searchIndustriesNameList = [];
  List searchIndustriesIdList = [];
  List sendIndustriesList = [];
  List sendIndustriesNameList = [];
  List searchSendIndustriesList = [];
  List searchSendIndustriesNameList = [];
  List finalSendIndustriesList = [];
  List finalSendIndustriesNameList = [];
  List<bool> indusBool = [];
  List<bool> searchIndusBool = [];

  List tickersNameList = [];
  List tickersLogoList = [];
  List tickersCatIdList = [];
  List tickersCodeList = [];
  List sendTickersList = [];
  List sendTickersNameList = [];
  List<bool> isCheckedNew = [];

  bool excSelect = false;
  bool indusSelect = false;
  bool loading2 = false;

  String selectedExchangeName = "";
  bool excLoader = false;
  bool indusLoader = false;
  int _numInterstitialLoadAttempts = 0;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  int maxFailedLoadAttempts = 3;
  bool _bannerAdIsLoaded = false;
  bool adShown = true;
  Timer? timer;
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    getAllDataMain(name: 'Filter_Creation_Page');
    categoryValue = widget.text;
    getAllData();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
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
  }

  getAllData() async {
    await getEx();
  }

  getRefreshIndus({required StateSetter newSetState}) async {
    newSetState(() {
      stocksInt += 100;
    });
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': categoryValue.toLowerCase(),
          'search': _industrySearchController.text.isEmpty ? "" : _industrySearchController.text,
          'skip': stocksInt,
          'exchange': selectedIdItem,
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      newSetState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          industriesNameList.add(responseData["response"][i]["name"]);
          industriesIdList.add(responseData["response"][i]["_id"]);
          if (selectAll) {
            sendIndustriesList.addAll(industriesIdList);
            if (sendIndustriesList.isNotEmpty) {
              if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                newSetState(() {
                  indusBool.add(true);
                });
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            } else {
              newSetState(() {
                indusBool.add(false);
              });
            }
          } else {
            //sendIndustriesList.clear();
            if (sendIndustriesList.isNotEmpty) {
              if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                newSetState(() {
                  indusBool.add(true);
                });
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            } else {
              newSetState(() {
                indusBool.add(false);
              });
            }
          }
        }
      });
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            exchangeNameList.add(responseData["response"][i]["name"]);
            exchangeCodeList.add(responseData["response"][i]["code"]);
            exchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
    setState(() {
      stateBool = true;
    });
  }

  getIndustries({required StateSetter newSetState}) async {
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': categoryValue.toLowerCase(),
          'search': _industrySearchController.text.isEmpty ? "" : _industrySearchController.text,
          'skip': 0,
          'exchange': selectedIdItem,
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        newSetState(() {
          industriesNameList.clear();
          industriesIdList.clear();
          indusBool.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
            if (selectAll) {
              sendIndustriesList.addAll(industriesIdList);
              if (sendIndustriesList.isNotEmpty) {
                if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                  newSetState(() {
                    indusBool.add(true);
                  });
                } else {
                  newSetState(() {
                    indusBool.add(false);
                  });
                }
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            } else {
              //sendIndustriesList.clear();
              if (sendIndustriesList.isNotEmpty) {
                if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                  newSetState(() {
                    indusBool.add(true);
                  });
                } else {
                  newSetState(() {
                    indusBool.add(false);
                  });
                }
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            }
          }
        });
      }
      newSetState(() {
        excLoader = false;
      });
    } else {
      newSetState(() {
        excLoader = false;
      });
    }
    newSetState(() {
      excLoader = false;
    });
  }

  getRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 100;
    });
    selectAll
        ? tickAll
            ? debugPrint("nothing")
            : sendIndustriesList.clear()
        : debugPrint("nothing");
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': stocksInt,
          'exchange': selectedIdItem,
          'industries': sendIndustriesList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickerSetState1(() {});
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getTickersFunc({required StateSetter tickerSetState}) async {
    selectAll
        ? tickAll
            ? debugPrint("nothing")
            : sendIndustriesList.clear()
        : debugPrint("nothing");
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'exchange': selectedIdItem,
          'industries': sendIndustriesList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    debugPrint(mainUserToken);
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
          tickersNameList.clear();
          tickersLogoList.clear();
          tickersCatIdList.clear();
          tickersCodeList.clear();
          isCheckedNew.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
      tickerSetState(() {
        indusLoader = false;
      });
    } else {
      tickerSetState(() {
        indusLoader = false;
      });
    }
    tickerSetState(() {
      indusLoader = false;
    });
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      //color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          body: stateBool
              ? SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 45.11,
                        ),
                        //heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  /*if (widget.page == 'locker') {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return MainBottomNavigationPage(
                                            tType: true,
                                            text: widget.text,
                                            caseNo1: 1,
                                            newIndex: 0,
                                            excIndex: 0,
                                            countryIndex: 0,
                                              isHomeFirstTym:false
                                          );
                                        }));
                                  }
                                  if (widget.page == 'charts') {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return MainBottomNavigationPage(
                                              tType: true,
                                              text: widget.text,
                                              caseNo1: 4,
                                              newIndex: 0,
                                              excIndex: 0,
                                              countryIndex: 0,
                                              isHomeFirstTym:false
                                          );
                                        }));
                                  }
                                  else if (widget.page == 'news') {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return NewsMainPage(
                                              text: finalisedCategory,
                                              tickerId: '',
                                              tickerName: "",
                                              fromCompare: false,
                                              );
                                        }));
                                  }
                                  else if (widget.page == 'videos') {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return VideosMainPage(
                                              text: finalisedCategory,
                                              tickerId: '',
                                              tickerName: "",
                                              fromCompare: false,);
                                        }));
                                  }
                                  else if (widget.page == 'forums') {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return ForumPage(
                                            text: finalisedCategory,
                                          );
                                        }));
                                  }
                                  else if (widget.page == 'survey') {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return SurveyPage(
                                            text: finalisedCategory,
                                          );
                                        }));
                                  }
                                  else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return MainBottomNavigationPage(
                                            tType: true,
                                            text: widget.text,
                                            caseNo1: 1,
                                            newIndex: 0,
                                            excIndex: 0,
                                            countryIndex: 0,
                                              isHomeFirstTym:false
                                          );
                                        }));
                                  }*/
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 24,
                                )),
                            const Text(
                              "Filter",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height / 58,
                        ),
                        //subheading
                        Container(
                          height: height / 14.5,
                          width: double.infinity,
                          color: const Color(0XFFA5A5A5).withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text("Filter list",
                                    style: TextStyle(
                                        color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0xFF4A4A4A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //main filters
                        Column(
                          children: [
                            ListTile(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    enableDrag: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context, StateSetter modelSetState) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              margin: const EdgeInsets.all(15.0),
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Text(
                                                        "Exchanges",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height / 50.75,
                                                  ),
                                                  Stack(
                                                    alignment: AlignmentDirectional.bottomCenter,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: height / 2.37,
                                                            child: ListView.builder(
                                                                itemCount: exchangeNameList.length,
                                                                itemBuilder: (BuildContext context, index) {
                                                                  return RadioListTile(
                                                                    activeColor: Colors.green,
                                                                    controlAffinity: ListTileControlAffinity.trailing,
                                                                    value: index.toString(),
                                                                    groupValue: _selectedExchange,
                                                                    onChanged: (value) {
                                                                      modelSetState(() {
                                                                        _selectedExchange = value.toString();
                                                                        selectedIdItem = exchangeIdList[index];
                                                                        selectedExchangeName = exchangeNameList[index];
                                                                      });
                                                                    },
                                                                    title: Text(
                                                                      exchangeNameList[index],
                                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                    ),
                                                                    subtitle: Text(
                                                                      exchangeCodeList[index],
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight.w500, fontSize: 12.0, color: Color(0XFFA5A5A5)),
                                                                    ),
                                                                  );
                                                                }),
                                                          ),
                                                          SizedBox(
                                                            height: height / 20.3,
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: height / 14.24,
                                                        color: Theme.of(context).colorScheme.background,
                                                        child: excLoader
                                                            ? Center(
                                                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                    height: 100, width: 100),
                                                              )
                                                            : Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.grey.shade400),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: Colors.white,
                                                                        ),
                                                                        child: const Center(
                                                                            child: Text("Cancel",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 7,
                                                                  ),
                                                                  Expanded(
                                                                    child: GestureDetector(
                                                                      onTap: () async {
                                                                        setState(() {
                                                                          _exchangeController.text = selectedExchangeName;
                                                                          excSelect = true;
                                                                        });
                                                                        modelSetState(() {
                                                                          excLoader = true;
                                                                        });
                                                                        await getIndustries(newSetState: modelSetState);
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.lightGreenAccent),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: const Color(0XFF0EA102),
                                                                        ),
                                                                        child: const Center(
                                                                            child: Text("Save",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              },
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Exchange:',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    controller: _exchangeController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).colorScheme.tertiary,
                                      filled: true,
                                      contentPadding: const EdgeInsets.all(20),
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                                      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                      labelText: 'Exchange',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: excSelect
                                  ? () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30),
                                            ),
                                          ),
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          enableDrag: false,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter modelSetState) {
                                                return SingleChildScrollView(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(15.0),
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Text(
                                                              "Industries",
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        TextFormField(
                                                          onChanged: (value) async {
                                                            if (value.isNotEmpty) {
                                                              textValue = value;
                                                              await getIndustries(newSetState: modelSetState);
                                                            } else if (value.isEmpty) {
                                                              textValue = "";
                                                              await getIndustries(newSetState: modelSetState);
                                                            } else {
                                                              textValue = "";
                                                              await getIndustries(newSetState: modelSetState);
                                                            }
                                                          },
                                                          style: Theme.of(context).textTheme.bodyMedium,
                                                          controller: _industrySearchController,
                                                          keyboardType: TextInputType.emailAddress,
                                                          decoration: InputDecoration(
                                                            fillColor: Theme.of(context).colorScheme.tertiary,
                                                            filled: true,
                                                            prefixIcon: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                            ),
                                                            contentPadding: EdgeInsets.all(height / 35.6),
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
                                                            hintStyle:
                                                                Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                                            hintText: 'Search here',
                                                            border: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        const Text(
                                                          "Name of Industries",
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        Stack(
                                                          alignment: AlignmentDirectional.bottomCenter,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: width / 2.5,
                                                                      child: CheckboxListTile(
                                                                        title: const Text(
                                                                          "Select All",
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                        ),
                                                                        autofocus: false,
                                                                        activeColor: Colors.green,
                                                                        value: selectAll,
                                                                        checkboxShape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                        onChanged: (bool? value) async {
                                                                          if (value!) {
                                                                            sendIndustriesList.clear();
                                                                            modelSetState(() {
                                                                              selectAll = value;
                                                                              _industrySearchController.text.isEmpty
                                                                                  ? tickAll = false
                                                                                  : tickAll = true;
                                                                            });
                                                                          } else {
                                                                            modelSetState(() {
                                                                              selectAll = value;
                                                                              tickAll = value;
                                                                              sendIndustriesList.clear();
                                                                            });
                                                                          }
                                                                          await getIndustries(newSetState: modelSetState);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: height / 2.37,
                                                                  child: SmartRefresher(
                                                                    controller: _controller,
                                                                    enablePullDown: false,
                                                                    enablePullUp: true,
                                                                    footer: CustomFooter(
                                                                      builder: (BuildContext context, LoadStatus? mode) {
                                                                        Widget body;
                                                                        if (mode == LoadStatus.idle) {
                                                                          body = const Text("pull up load");
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
                                                                          height: 55.0,
                                                                          child: Center(child: body),
                                                                        );
                                                                      },
                                                                    ),
                                                                    onLoading: () async {
                                                                      await getRefreshIndus(newSetState: modelSetState);
                                                                      if (mounted) {
                                                                        modelSetState(() {});
                                                                      }
                                                                      _controller.loadComplete();
                                                                    },
                                                                    child: ListView.builder(
                                                                        itemCount: industriesNameList.length,
                                                                        itemBuilder: (BuildContext context, index) {
                                                                          return CheckboxListTile(
                                                                            title: Text(
                                                                              industriesNameList[index],
                                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                            ),
                                                                            autofocus: false,
                                                                            activeColor: Colors.green,
                                                                            //selected: _value,
                                                                            value: indusBool[index],
                                                                            checkboxShape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            onChanged: (bool? value) {
                                                                              if (value!) {
                                                                                modelSetState(() {
                                                                                  indusBool[index] = value;
                                                                                  sendIndustriesList.add(industriesIdList[index]);
                                                                                  sendIndustriesNameList.add(industriesNameList[index]);
                                                                                });
                                                                              } else {
                                                                                modelSetState(() {
                                                                                  indusBool[index] = value;
                                                                                  for (int i = 0; i < sendIndustriesList.length; i++) {
                                                                                    if (sendIndustriesList[i] == industriesIdList[index]) {
                                                                                      modelSetState(() {
                                                                                        sendIndustriesList.removeAt(i);
                                                                                        sendIndustriesNameList.removeAt(i);
                                                                                        selectAll = false;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                });
                                                                              }
                                                                            },
                                                                          );
                                                                        }),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: height / 20.3,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: height / 14.24,
                                                              color: Theme.of(context).colorScheme.background,
                                                              child: indusLoader
                                                                  ? Center(
                                                                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                          height: 100, width: 100),
                                                                    )
                                                                  : Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              if (!mounted) {
                                                                                return;
                                                                              }
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.grey.shade400),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.white,
                                                                              ),
                                                                              child: const Center(
                                                                                  child: Text("Cancel",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold, color: Colors.black))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 7,
                                                                        ),
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              setState(() {
                                                                                indusSelect = true;
                                                                                if (selectAll) {
                                                                                  _industriesController.text = "Multiple";
                                                                                } else {
                                                                                  if (sendIndustriesList.length == 1) {
                                                                                    _industriesController.text = sendIndustriesNameList[0];
                                                                                  } else if (sendIndustriesList.isEmpty) {
                                                                                    _industriesController.text = "Nothing";
                                                                                  } else {
                                                                                    _industriesController.text = "Multiple";
                                                                                  }
                                                                                }
                                                                              });
                                                                              modelSetState(() {
                                                                                indusLoader = true;
                                                                              });
                                                                              await getTickersFunc(tickerSetState: modelSetState);
                                                                              if (!mounted) {
                                                                                return;
                                                                              }
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.lightGreenAccent),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: const Color(0XFF0EA102),
                                                                              ),
                                                                              child: const Center(
                                                                                  child: Text("Save",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold, color: Colors.white))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                    }
                                  : () {
                                      Flushbar(
                                        message: "Please select anyone of Exchanges",
                                        duration: const Duration(seconds: 2),
                                      ).show(context);
                                    },
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Industries:',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    controller: _industriesController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).colorScheme.tertiary,
                                      filled: true,
                                      contentPadding: const EdgeInsets.all(20),
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                                      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                      labelText: 'Industries',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: excSelect && indusSelect
                                  ? () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30),
                                            ),
                                          ),
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          enableDrag: false,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter modelSetState) {
                                                return SingleChildScrollView(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(15.0),
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: height / 54.13,
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Text(
                                                              "Stocks",
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        TextFormField(
                                                          onChanged: (value) async {
                                                            if (value.isNotEmpty) {
                                                              tickersTextValue = value;
                                                              await getTickersFunc(tickerSetState: modelSetState);
                                                            } else if (value.isEmpty) {
                                                              tickersTextValue = "";
                                                              await getTickersFunc(tickerSetState: modelSetState);
                                                            } else {
                                                              tickersTextValue = "";
                                                              await getTickersFunc(tickerSetState: modelSetState);
                                                            }
                                                          },
                                                          style: Theme.of(context).textTheme.bodyMedium,
                                                          controller: _tickerSearchController,
                                                          keyboardType: TextInputType.emailAddress,
                                                          decoration: InputDecoration(
                                                            fillColor: Theme.of(context).colorScheme.tertiary,
                                                            filled: true,
                                                            prefixIcon: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                            ),
                                                            contentPadding: EdgeInsets.all(height / 35.6),
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
                                                            hintStyle:
                                                                Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                                            hintText: 'Search here',
                                                            border: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        const Text(
                                                          "Name of Stocks",
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                        ),
                                                        SizedBox(
                                                          height: height / 50.75,
                                                        ),
                                                        Stack(
                                                          alignment: AlignmentDirectional.bottomCenter,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: width / 2.5,
                                                                      child: CheckboxListTile(
                                                                        title: const Text(
                                                                          "Select All",
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                        ),
                                                                        autofocus: false,
                                                                        activeColor: Colors.green,
                                                                        //selected: _value,
                                                                        value: tickerSelectAll,
                                                                        checkboxShape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                        onChanged: (bool? value) async {
                                                                          if (value!) {
                                                                            sendTickersList.clear();
                                                                            modelSetState(() {
                                                                              tickerSelectAll = value;
                                                                              _tickerSearchController.text.isEmpty
                                                                                  ? tickerTickAll = false
                                                                                  : tickerTickAll = true;
                                                                            });
                                                                          } else {
                                                                            modelSetState(() {
                                                                              tickerSelectAll = value;
                                                                              tickerTickAll = value;
                                                                              sendTickersList.clear();
                                                                            });
                                                                          }
                                                                          await getTickersFunc(tickerSetState: modelSetState);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: height / 2.37,
                                                                  child: SmartRefresher(
                                                                    controller: _refreshController,
                                                                    enablePullDown: false,
                                                                    enablePullUp: true,
                                                                    footer: CustomFooter(
                                                                      builder: (BuildContext context, LoadStatus? mode) {
                                                                        Widget body;
                                                                        if (mode == LoadStatus.idle) {
                                                                          body = const Text("pull up load");
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
                                                                          height: 55.0,
                                                                          child: Center(child: body),
                                                                        );
                                                                      },
                                                                    ),
                                                                    onLoading: () async {
                                                                      await getRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                      if (mounted) {
                                                                        modelSetState(() {});
                                                                      }
                                                                      _refreshController.loadComplete();
                                                                    },
                                                                    child: ListView.builder(
                                                                        itemCount: tickersNameList.length,
                                                                        itemBuilder: (BuildContext context, index) {
                                                                          return CheckboxListTile(
                                                                            title: Text(
                                                                              tickersNameList[index],
                                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                            ),
                                                                            subtitle: Text(
                                                                              tickersCodeList[index],
                                                                              style: const TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 12.0,
                                                                                  color: Color(0XFFA5A5A5)),
                                                                            ),
                                                                            //subtitle: const Text('A computer science portal for geeks.'),
                                                                            secondary: SizedBox(
                                                                                height: height / 33.83,
                                                                                width: width / 15.625,
                                                                                child: tickersLogoList[index].contains("svg")
                                                                                    ? SvgPicture.network(tickersLogoList[index], fit: BoxFit.fill)
                                                                                    : Image.network(tickersLogoList[index], fit: BoxFit.fill)),
                                                                            autofocus: false,
                                                                            activeColor: Colors.green,
                                                                            value: isCheckedNew[index],
                                                                            checkboxShape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            onChanged: (bool? value) {
                                                                              if (value!) {
                                                                                modelSetState(() {
                                                                                  isCheckedNew[index] = value;
                                                                                  sendTickersList.add(tickersCatIdList[index]);
                                                                                  sendTickersNameList.add(tickersNameList[index]);
                                                                                });
                                                                              } else {
                                                                                modelSetState(() {
                                                                                  isCheckedNew[index] = value;
                                                                                  for (int i = 0; i < sendTickersList.length; i++) {
                                                                                    if (sendTickersList[i] == tickersCatIdList[index]) {
                                                                                      sendTickersList.removeAt(i);
                                                                                      sendTickersNameList.removeAt(i);
                                                                                      tickerSelectAll = false;
                                                                                    }
                                                                                  }
                                                                                });
                                                                              }
                                                                            },
                                                                          );
                                                                        }),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: height / 20.3,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: height / 14.24,
                                                              color: Theme.of(context).colorScheme.background,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: GestureDetector(
                                                                      onTap: () async {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.grey.shade400),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: Colors.white,
                                                                        ),
                                                                        child: const Center(
                                                                            child: Text("Cancel",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 7,
                                                                  ),
                                                                  Expanded(
                                                                    child: GestureDetector(
                                                                      onTap: () async {
                                                                        if (tickerSelectAll) {
                                                                          _stockTickersController.text = "Multiple";
                                                                        } else {
                                                                          if (sendTickersList.length == 1) {
                                                                            _stockTickersController.text = sendTickersNameList[0];
                                                                          } else if (sendTickersList.isEmpty) {
                                                                            _stockTickersController.text = "Nothing";
                                                                          } else {
                                                                            _stockTickersController.text = "Multiple";
                                                                          }
                                                                        }
                                                                        modelSetState(() {});
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.lightGreenAccent),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: const Color(0XFF0EA102),
                                                                        ),
                                                                        child: const Center(
                                                                            child: Text("Save",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                    }
                                  : () {
                                      Flushbar(
                                        message: "You missed to select exchange/industries",
                                        duration: const Duration(seconds: 2),
                                      ).show(context);
                                    },
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Stocks(optional):',
                                    style: TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    controller: _stockTickersController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                      fillColor: Theme.of(context).colorScheme.tertiary,
                                      filled: true,
                                      contentPadding: const EdgeInsets.all(20),
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
                                      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                      labelText: 'Stocks',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 40.6,
                        ),
                        //main Text Form
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: _listNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              contentPadding: const EdgeInsets.all(20),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                              labelText: 'List Name',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        //Text
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text(
                            "Note: Avoid duplicate list names within the same category.",
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          height: height / 33.83,
                        ),
                        _bannerAdIsLoaded && _bannerAd != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: /*AdmobBanner(
                            adUnitId: AdHelper.bannerAdUnitId,
                            adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: _width.toInt()-30),
                            listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
                              AdHelper().handleEvent(event, args, 'Banner');
                            },
                            onBannerCreated: (AdmobBannerController controller) {},
                          )*/
                                    SizedBox(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: height / 33.83,
                        ),
                        //Final Buttons
                        loading2
                            ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                            : Container(
                                height: height / 16.24,
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          /*if (widget.page == 'locker') {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  return MainBottomNavigationPage(
                                                    tType: true,
                                                    text: widget.text,
                                                    caseNo1: 1,
                                                    newIndex: 0,
                                                    excIndex: 0,
                                                    countryIndex: 0,
                                                      isHomeFirstTym:false
                                                  );
                                                }));
                                          }
                                          else{
                                            if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                          }*/
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child:
                                              const Center(child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          logEventFunc(name: 'Filter_Created', type: 'Locker');
                                          if (_listNameController.text.isEmpty) {
                                            Flushbar(
                                              message: "List Name is Mandatory, Please provide List Name to Continue",
                                              duration: const Duration(seconds: 2),
                                            ).show(context);
                                          } else {
                                            setState(() {
                                              loading2 = true;
                                            });
                                            selectAll
                                                ? tickAll
                                                    ? debugPrint("nothing")
                                                    : sendIndustriesList.clear()
                                                : debugPrint("nothing");
                                            tickerSelectAll
                                                ? tickerTickAll
                                                    ? debugPrint("nothing")
                                                    : sendTickersList.clear()
                                                : debugPrint("nothing");
                                            var responseValue = await _filterFunction.getAddFilter(
                                                type: categoryValue.toLowerCase(),
                                                title: _listNameController.text,
                                                cid: mainCatIdList[0],
                                                exc: selectedIdItem,
                                                indus: sendIndustriesList,
                                                tickers: sendTickersList,
                                                allIndus: selectAll
                                                    ? tickAll
                                                        ? false
                                                        : true
                                                    : false,
                                                allTickers: tickerSelectAll
                                                    ? tickerTickAll
                                                        ? false
                                                        : true
                                                    : false);
                                            if (responseValue["status"]) {
                                              createInterstitialAd();
                                              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                                                debugPrint("timer");
                                                if (_interstitialAd != null) {
                                                  if (adShown) {
                                                    debugPrint("ad shown");
                                                    showInterstitialAd();
                                                  } else {
                                                    timer.cancel();
                                                  }
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                loading2 = false;
                                              });
                                              if (!mounted) {
                                                return;
                                              }
                                              Flushbar(
                                                message: responseValue["message"],
                                                duration: const Duration(seconds: 2),
                                              ).show(context);
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.lightGreenAccent),
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0XFF0EA102),
                                          ),
                                          child:
                                              const Center(child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                )
              : Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100)),
        ),
      ),
    );
  }

  void createInterstitialAd() {
    debugPrint("createInterstitialAd");
    InterstitialAd.load(
        adUnitId: adVariables.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            setState(() {
              debugPrint(_interstitialAd!.adUnitId);
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    debugPrint("showInterstitialAd");
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        timer!.cancel();
        finalisedCategory = "Stocks";
        finalisedFilterId = "";
        finalisedFilterName = "All Stocks";
        if (widget.page == 'locker') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
                tType: true, text: widget.text, caseNo1: 1, newIndex: 0, excIndex: 0, countryIndex: 0, isHomeFirstTym: false);
          }));
        } else if (widget.page == 'charts') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
                tType: true, text: widget.text, caseNo1: 4, newIndex: 0, excIndex: 0, countryIndex: 0, isHomeFirstTym: false);
          }));
        } else if (widget.page == 'news') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return NewsMainPage(
              text: finalisedCategory,
              tickerId: '',
              tickerName: "",
              fromCompare: false,
            );
          }));
        } else if (widget.page == 'videos') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return VideosMainPage(
              text: finalisedCategory,
              tickerId: '',
              tickerName: "",
              fromCompare: false,
            );
          }));
        } else if (widget.page == 'forums') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(
              text: finalisedFilterId,
            );
          }));
        } else if (widget.page == 'survey') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SurveyPage(
              text: finalisedCategory,
            );
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
                tType: true, text: widget.text, caseNo1: 1, newIndex: 0, excIndex: 0, countryIndex: 0, isHomeFirstTym: false);
          }));
        }
        setState(() {
          loading2 = false;
        });
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    adShown = false;
    _interstitialAd = null;
  }
}
