import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

class ForexEditFilterPage extends StatefulWidget {
  final String text;
  final String filterId;
  final String page;
  final dynamic response;

  const ForexEditFilterPage({Key? key, required this.text, required this.filterId, required this.page, required this.response}) : super(key: key);

  @override
  State<ForexEditFilterPage> createState() => _ForexEditFilterPageState();
}

class _ForexEditFilterPageState extends State<ForexEditFilterPage> {
  final FilterFunction _filterFunction = FilterFunction();
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _forexTickersController = TextEditingController();
  final TextEditingController _tickerSearchController = TextEditingController();

  final RefreshController _refreshController = RefreshController();

  String categoryValue = "";
  String mainUserToken = "";
  String tickersTextValue = "";
  bool tickerSelectAllButton = false;
  bool tickerTickAll = false;
  List tickersNameList = [];
  List tickersLogoList = [];
  List tickersCatIdList = [];
  List tickersCodeList = [];
  List isCheckedNew = [];
  List sendTickersList = [];
  List sendTickersNameList = [];
  bool tickerSelectAll = false;
  int stocksInt = 0;
  Map<String, dynamic> response = {};
  bool loading2 = false;
  BannerAd? _bannerAd;
  int _numInterstitialLoadAttempts = 0;
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
    getAllDataMain(name: 'Filter_Edit_Page');
    categoryValue = widget.text;
    getAllData();
    super.initState();
  }

  getAllData() async {
    response = widget.response;
    _listNameController.text = response["response"]["title"];
    sendTickersList = response["response"]["tickers"];
    tickerSelectAllButton = response["response"]["alltickers"];
    setState(() {
      tickerSelectAll = tickerSelectAllButton;
    });
    if (sendTickersList.length > 1 || tickerSelectAll == true) {
      _forexTickersController.text = "Multiple";
    } else if (sendTickersList.length == 1) {
      _forexTickersController.text = "Single";
    } else {
      _forexTickersController.text = "None";
    }
    await getTickersFunc1();
    await getTickersFunc(tickerSetState: setState);
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

  getTickersFunc1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'ticker_exist': true,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
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
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
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
              //sendTickersList.clear();
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
    } else {}
  }

  getRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 20;
    });
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': stocksInt,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
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

  @override
  void dispose() {
    _bannerAd!.dispose();
    timer!.cancel();
    super.dispose();
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
            return ForumPage(text: finalisedCategory);
          }));
        } else if (widget.page == 'survey') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SurveyPage(text: finalisedCategory);
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      // color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
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
                                            SizedBox(
                                              height: height / 54.13,
                                            ),
                                            const Row(
                                              children: [
                                                Text(
                                                  "Forex",
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
                                                  tickersNameList.clear();
                                                  tickersLogoList.clear();
                                                  tickersCatIdList.clear();
                                                  tickersCodeList.clear();
                                                  isCheckedNew.clear();
                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                } else if (value.isEmpty) {
                                                  tickersTextValue = "";
                                                  tickersNameList.clear();
                                                  tickersLogoList.clear();
                                                  tickersCatIdList.clear();
                                                  tickersCodeList.clear();
                                                  isCheckedNew.clear();
                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                } else {
                                                  tickersTextValue = "";
                                                  tickersNameList.clear();
                                                  tickersLogoList.clear();
                                                  tickersCatIdList.clear();
                                                  tickersCodeList.clear();
                                                  isCheckedNew.clear();
                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                }
                                              },
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              controller: _tickerSearchController,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                fillColor: Theme.of(context).colorScheme.tertiary,
                                                filled: true,
                                                contentPadding: const EdgeInsets.all(20),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                ),
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
                                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
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
                                              "Name of Forex",
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
                                                            onChanged: (bool? value) async {
                                                              if (value!) {
                                                                sendTickersList.clear();
                                                                tickersNameList.clear();
                                                                tickersLogoList.clear();
                                                                tickersCatIdList.clear();
                                                                tickersCodeList.clear();
                                                                isCheckedNew.clear();
                                                                modelSetState(() {
                                                                  tickerSelectAll = value;
                                                                  _tickerSearchController.text.isEmpty ? tickerTickAll = false : tickerTickAll = true;
                                                                  // getTickersFunc( tickerSetState:modelSetState);
                                                                });
                                                              } else {
                                                                tickersNameList.clear();
                                                                tickersLogoList.clear();
                                                                tickersCatIdList.clear();
                                                                tickersCodeList.clear();
                                                                isCheckedNew.clear();
                                                                modelSetState(() {
                                                                  tickerSelectAll = value;
                                                                  tickerTickAll = value;
                                                                  sendTickersList.clear();
                                                                });
                                                                //getTickersFunc( tickerSetState:modelSetState);
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
                                                                  style: const TextStyle(
                                                                      fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                                ),
                                                                subtitle: Text(
                                                                  tickersCodeList[index],
                                                                  style: const TextStyle(
                                                                      fontWeight: FontWeight.w500, fontSize: 12.0, color: Color(0XFFA5A5A5)),
                                                                ),
                                                                secondary: SizedBox(
                                                                    height: height / 33.83,
                                                                    width: width / 15.625,
                                                                    child: tickersLogoList[index].contains("svg")
                                                                        ? SvgPicture.network(tickersLogoList[index], fit: BoxFit.fill)
                                                                        : Image.network(tickersLogoList[index], fit: BoxFit.fill)),
                                                                autofocus: false,
                                                                activeColor: Colors.green,
                                                                //selected: _value,
                                                                value: isCheckedNew[index],
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
                                                              _forexTickersController.text = "Multiple";
                                                            } else {
                                                              if (sendTickersList.length == 1) {
                                                                _forexTickersController.text = "Single";
                                                              } else if (sendTickersList.isEmpty) {
                                                                _forexTickersController.text = "Nothing";
                                                              } else {
                                                                _forexTickersController.text = "Multiple";
                                                              }
                                                            }
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
                                                                child:
                                                                    Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
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
                              'Forex(optional):',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              readOnly: true,
                              enabled: false,
                              style: Theme.of(context).textTheme.bodyMedium,
                              controller: _forexTickersController,
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
                                    child: const Center(child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    logEventFunc(name: 'Filter_Edit_Complete', type: 'Locker');
                                    if (_listNameController.text.isEmpty) {
                                      Flushbar(
                                        message: "List Name is Mandatory, Please provide List Name to Continue",
                                        duration: const Duration(seconds: 2),
                                      ).show(context);
                                    } else {
                                      setState(() {
                                        loading2 = true;
                                      });
                                      tickerSelectAll
                                          ? tickerTickAll
                                              ? debugPrint("nothing to do")
                                              : sendTickersList.clear()
                                          : debugPrint("nothing to do");
                                      var responseValue = await _filterFunction.getUpdateFilter(
                                          type: categoryValue.toLowerCase(),
                                          title: _listNameController.text,
                                          cid: mainCatIdList[3],
                                          exc: "",
                                          indus: [],
                                          tickers: sendTickersList,
                                          allIndus: false,
                                          allTickers: tickerSelectAll
                                              ? tickerTickAll
                                                  ? false
                                                  : true
                                              : false,
                                          filterId: widget.filterId);
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
                                    child: const Center(child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
