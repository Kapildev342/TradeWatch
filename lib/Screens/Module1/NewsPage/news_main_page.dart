import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:tradewatchfinal/Constants/Common/filter_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_edit_filter_page.dart';

import 'Demo/demo_view.dart';

class NewsMainPage extends StatefulWidget {
  final String text;
  final bool fromCompare;
  final bool? homeSearch;
  final String tickerId;
  final String tickerName;

  const NewsMainPage({Key? key, required this.fromCompare, this.homeSearch, required this.text, required this.tickerId, required this.tickerName})
      : super(key: key);

  @override
  State<NewsMainPage> createState() => _NewsMainPageState();
}

class _NewsMainPageState extends State<NewsMainPage> {
  List<String> categoriesList = ["Stocks", "Crypto", "Commodity", "Forex"];
  String selectedValue = "Stocks";
  String selectedWidget = "";
  String selectedIdWidget = "";
  List enteredNewList = [];
  List<int> newsViewList = [];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();
  final FilterFunction _filterFunction = FilterFunction();

  //bool listValue=false;
  String mainUserId = "";
  bool searchLoader = false;
  String mainUserToken = "";
  var time = '';
  List<String> newsImagesList = [];
  List<String> newsExchangeList = [];
  List<String> newsSentimentList = [];
  List<String> newsDescriptionList = [];
  List<String> newsSnippetList = [];
  List<bool> newsBookMarkList = [];
  List<String> newsSourceNameList = [];
  List<String> newsTitlesList = [];
  List<String> timeList = [];
  List<String> newsLinkList = [];
  int newsInt = 0;
  String categoryValue = "";
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool filterBool = false;
  String filterId = "";
  bool dropDownSelection = false;
  bool emptyBool = false;
  List<String> newsIdList = [];
  List<int> newsLikeList = [];
  List<int> newsDislikeList = [];
  List<bool> newsUseList = [];
  List<bool> newsUseDisList = [];
  late Uri newLink;
  bool loading = false;
  bool searchValue1 = false;
  List<String> newsLikedImagesList = [];
  List<String> newsLikedIdList = [];
  List<String> newsLikedSourceNameList = [];
  List<String> newsViewedImagesList = [];
  List<String> newsViewedIdList = [];
  List<String> newsViewedSourceNameList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  navigationPage1() async {
    var url = Uri.parse(baseurl + versionLocker + filterCount);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'type': selectedValue.toLowerCase()});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      if (selectedValue == "Stocks") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return StocksAddFilterPage(
            text: selectedValue,
            page: 'news',
          );
        }));
      } else if (selectedValue == "Crypto") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CryptoAddFilterPage(
            text: selectedValue,
            page: 'news',
          );
        }));
      } else if (selectedValue == "Commodity") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CommodityAddFilterPage(
            text: selectedValue,
            page: 'news',
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForexAddFilterPage(
            text: selectedValue,
            page: 'news',
          );
        }));
      }
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getNewsValues({required String text, required String? category, required String filterId}) async {
    setState(() {
      loading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getNewsZone);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: widget.fromCompare
            ? {
                'category': category!.toLowerCase(),
                'search': text.isEmpty ? "" : text,
                'skip': '0',
                'ticker_id': widget.tickerId.isEmpty ? "" : widget.tickerId
              }
            : {'category': category!.toLowerCase(), 'search': text.isEmpty ? "" : text, 'skip': '0', 'filter_id': filterId.isEmpty ? "" : filterId});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      newsImagesList.clear();
      newsExchangeList.clear();
      newsSentimentList.clear();
      newsDescriptionList.clear();
      newsSnippetList.clear();
      newsBookMarkList.clear();
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
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
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
            if (finalisedCategory.toLowerCase() == 'stocks') {
              if (responseData["response"][i]["exchange"] == "NSE" ||
                  responseData["response"][i]["exchange"] == "BSE" ||
                  responseData["response"][i]["exchange"] == "INDX") {
                newsExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
              } else if (responseData["response"][i]["exchange"] == "" || responseData["response"][i]["exchange"] == null) {
                newsExchangeList.add("");
              } else {
                newsExchangeList.add("usastocks");
              }
            } else if (finalisedCategory.toLowerCase() == 'crypto') {
              newsExchangeList.add(
                  responseData["response"][i]["industry"].length == 0 ? "coin" : responseData["response"][i]["industry"][0]['name'].toLowerCase());
            } else if (finalisedCategory.toLowerCase() == 'commodity') {
              newsExchangeList.add(responseData["response"][i]["country"].toLowerCase());
            } else {
              newsExchangeList.add('inrusd');
            }
            newsSentimentList.add((responseData["response"][i]["sentiment"] ?? '').toLowerCase());
            newsDescriptionList.add(responseData["response"][i]["description"] ?? "");
            newsSnippetList.add(responseData["response"][i]["snippet"] ?? "");
            newsBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
            newsTitlesList.add(responseData["response"][i]["title"]);
            newsSourceNameList.add(responseData["response"][i]["source_name"]);
            newsLinkList.add(responseData["response"][i]["news_url"]);
            newsIdList.add(responseData["response"][i]["_id"]);
            newsLikeList.add(responseData["response"][i]["likes_count"]);
            newsViewList.add(responseData["response"][i]["views_count"]);
            newsDislikeList.add(responseData["response"][i]["dis_likes_count"]);
            newsUseList.add(responseData["response"][i]["likes"]);
            newsUseDisList.add(responseData["response"][i]["dislikes"]);
            DateTime dt = DateTime.parse(responseData["response"][i]["date"]);
            final timestamp1 = dt.millisecondsSinceEpoch;
            readTimestamp(timestamp1);
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

  viewsCountFunc({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString("newUserId")!;
    mainUserToken = prefs.getString("newUserToken")!;
    var url = Uri.parse(baseurl + versionLocker + newsViewCount);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'news_id': id});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      newsViewedImagesList.clear();
      newsViewedIdList.clear();
      newsViewedSourceNameList.clear();
      if (responseData["response"].length == 0) {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: "Still no one has viewed this post",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        for (int i = 0; i < responseData["response"].length; i++) {
          setState(() {
            if (responseData["response"][i].containsKey("avatar")) {
              newsViewedImagesList.add(responseData["response"][i]["avatar"]);
            } else {
              newsViewedImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
            newsViewedIdList.add(responseData["response"][i]["user_id"]);
            newsViewedSourceNameList.add(responseData["response"][i]["username"]);
          });
        }
      }
    } else {
      newsViewedSourceNameList.clear();
      newsViewedIdList.clear();
      newsViewedImagesList.clear();
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Still no one has viewed this post",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
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
    setState(() {
      timeList.add(time);
    });
    return time;
  }

  getFil({required String type, required String filterId}) async {
    if (mainSkipValue) {
      categoryValue = type.toLowerCase();
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
    } else {
      enteredFilteredList.clear();
      enteredFilteredIdList.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      mainUserToken = prefs.getString('newUserToken') ?? "";
      var url = Uri.parse(baseurl + versionLocker + getFilter);
      var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"type": type.toLowerCase()});
      var responseData = json.decode(response.body);
      if (responseData["response"].length == 0) {
        enteredFilteredList.clear();
        enteredFilteredIdList.clear();
        setState(() {
          searchLoader = false;
          searchValue1 = false;
          emptyBool = true;
          selectedWidget = selectedWidget = "All $selectedValue";
          selectedIdWidget = "";
          finalisedFilterName = selectedWidget;
          finalisedFilterId = selectedIdWidget;
          prefs.setString('finalisedFilterId1', finalisedFilterId);
          prefs.setString('finalisedFilterName1', finalisedFilterName);
        });
      } else {
        enteredFilteredList.clear();
        enteredFilteredIdList.clear();
        setState(() {
          emptyBool = false;
          searchLoader = false;
          searchValue1 = false;
        });
        for (int i = 0; i < responseData["response"].length; i++) {
          enteredFilteredList.add(responseData["response"][i]["title"]);
          enteredFilteredIdList.add(responseData["response"][i]["_id"]);
        }
        if (filterId == "") {
          setState(() {
            selectedWidget = enteredFilteredList[0];
            selectedIdWidget = enteredFilteredIdList[0];
            finalisedFilterName = enteredFilteredList[0];
            finalisedFilterId = enteredFilteredIdList[0];
            prefs.setString('finalisedFilterId1', finalisedFilterId);
            prefs.setString('finalisedFilterName1', finalisedFilterName);
          });
        } else {
          for (int i = 0; i < enteredFilteredIdList.length; i++) {
            if (enteredFilteredIdList[i] == filterId) {
              selectedWidget = enteredFilteredList[i];
              selectedIdWidget = enteredFilteredIdList[i];
              finalisedFilterName = enteredFilteredList[i];
              finalisedFilterId = enteredFilteredIdList[i];
              prefs.setString('finalisedFilterId1', finalisedFilterId);
              prefs.setString('finalisedFilterName1', finalisedFilterName);
            }
          }
        }
      }
    }
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
    widget.fromCompare ? finalisedCategory = widget.text : debugPrint("nothing");
    getAllDataMain(name: 'News_Home_Page');
    pageVisitFunc(pageName: 'news');
    getAllData();
    super.initState();
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

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  getAllData() async {
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    getNotifyCountAndImage();
    if (mainSkipValue) {
      if (widget.text != "") {
        widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterId = "";
        widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterName = "";
        finalisedCategory = widget.text;
      }
      selectedValue = finalisedCategory;
      selectedIdWidget = finalisedFilterId;
      selectedWidget = finalisedFilterName;
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
      await getNewsValues(text: "", category: selectedValue, filterId: selectedIdWidget);
    } else {
      if (widget.text != "") {
        widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterId = "";
        widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("nothing") : finalisedFilterName = "";
        finalisedCategory = widget.text;
      }
      selectedValue = finalisedCategory;
      selectedIdWidget = finalisedFilterId;
      selectedWidget = finalisedFilterName;
      await getFil(type: selectedValue, filterId: selectedIdWidget);
      await getNewsValues(text: "", category: selectedValue, filterId: selectedIdWidget);
      if (!mounted) {
        return false;
      }
      widget.fromCompare
          ? lockerFilterResponse
              ? debugPrint("nothing")
              : filtersAlertDialogue(
                  selectedValue: widget.text,
                  cIdList: mainCatIdList,
                  title: filterAlertTitle,
                  context: context,
                  pageType: 'news',
                  tickerId: widget.tickerId)
          : debugPrint("nothing");
    }
  }

  getSelectedValue({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + saveKey);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'locker': value.toLowerCase()});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      finalisedCategory = selectedValue;
      prefs.setString('finalisedCategory1', finalisedCategory);
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        widget.fromCompare
            ? widget.homeSearch!
                ? Navigator.pop(context)
                : Navigator.pop(
                    context) /*Navigator.push(context,
            MaterialPageRoute(builder:
                (BuildContext context) {
              return ComparePage(text: finalisedCategory);
            }))*/
            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return MainBottomNavigationPage(
                  tType: true,
                  text: finalisedCategory,
                  caseNo1: 1,
                  newIndex: 0,
                  excIndex: 0,
                  countryIndex: 0,
                  isHomeFirstTym: false,
                );
              }));
        return false;
      },
      child: GestureDetector(
        onTap: () {
          extraContainMain.value = false;
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          //color: const Color(0XFFFFFFFF),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 41.1),
                  child: Column(
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
                                GestureDetector(
                                    onTap: () {
                                      widget.fromCompare
                                          ? widget.homeSearch!
                                              ? Navigator.pop(context)
                                              : Navigator.pop(
                                                  context) /*Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (BuildContext context) {
                                          return ComparePage(text: finalisedCategory);
                                        }))*/
                                          : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return MainBottomNavigationPage(
                                                tType: true,
                                                text: finalisedCategory,
                                                caseNo1: 1,
                                                newIndex: 0,
                                                excIndex: 0,
                                                countryIndex: 0,
                                                isHomeFirstTym: false,
                                              );
                                            }));
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Theme.of(context).colorScheme.onPrimary /*Colors.black*/,
                                      size: 30,
                                    )),
                                SizedBox(width: width / 41.1),
                                Text(
                                  "News",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge, /*TextStyle(fontSize: text.scale(26), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),*/
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
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 25.375,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.fromCompare
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      widget.text.toLowerCase() == "stocks"
                                          ? SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg", fit: BoxFit.fill),
                                            )
                                          : widget.text.toLowerCase() == "crypto"
                                              ? SizedBox(
                                                  height: height / 35.03,
                                                  width: width / 16.30,
                                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", fit: BoxFit.fill),
                                                )
                                              : widget.text.toLowerCase() == "commodity"
                                                  ? SizedBox(
                                                      height: height / 35.03,
                                                      width: width / 16.30,
                                                      child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png",
                                                          fit: BoxFit.fill),
                                                    )
                                                  : SizedBox(
                                                      height: height / 35.03,
                                                      width: width / 16.30,
                                                      child:
                                                          Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png", fit: BoxFit.fill),
                                                    ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.text,
                                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )
                                : Row(
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
                                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", fit: BoxFit.fill),
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
                                                      child:
                                                          Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png", fit: BoxFit.fill),
                                                    ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Obx(
                                        () => extraContainMain.value
                                            ? Text(selectedValue,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium /*TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),*/
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
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    setState(() {
                                                      loading = false;
                                                      newsImagesList.clear();
                                                      newsExchangeList.clear();
                                                      newsSentimentList.clear();
                                                      newsDescriptionList.clear();
                                                      newsSnippetList.clear();
                                                      newsBookMarkList.clear();
                                                      newsSourceNameList.clear();
                                                      newsTitlesList.clear();
                                                      newsLinkList.clear();
                                                      timeList.clear();
                                                      newsInt = 0;
                                                      selectedValue = value!;
                                                      finalisedCategory = selectedValue;
                                                      prefs.setString('finalisedCategory1', finalisedCategory);
                                                    });
                                                    mainSkipValue ? debugPrint("nothing") : getSelectedValue(value: finalisedCategory);
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                    await getFil(type: finalisedCategory, filterId: "");
                                                    await getNewsValues(
                                                        text: _searchController.text.isEmpty ? "" : _searchController.text,
                                                        category: finalisedCategory,
                                                        filterId: finalisedFilterId);
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
                                                ),
                                              ),
                                      ),
                                    ],
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
                                    child: SizedBox(
                                      width: width / 2.5,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: height / 35.03,
                                            width: width / 16.30,
                                            padding: const EdgeInsets.all(4),
                                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/downFilter.svg", fit: BoxFit.fill),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          SizedBox(
                                            width: width / 3.5,
                                            child: Text(widget.tickerName, style: Theme.of(context).textTheme.bodyLarge
                                                /*TextStyle(fontSize: text.scale(14), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600),*/
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
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
                      SizedBox(height: height / 50.75),
                      Obx(
                        () => extraContainMain.value
                            ? SizedBox(
                                height: height / 19.33,
                                child: TextFormField(
                                  cursorColor: Colors.green,
                                  readOnly: true,
                                  enabled: false,
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
                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                    hintText: 'Search here',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: height / 19.33,
                                child: TextFormField(
                                  cursorColor: Colors.green,
                                  onChanged: (value) async {
                                    if (value.isNotEmpty) {
                                      newsInt = 0;
                                      await getFil(type: selectedValue, filterId: selectedIdWidget);
                                      await getNewsValues(text: value, category: selectedValue, filterId: selectedIdWidget);
                                    } else {
                                      newsInt = 0;
                                      await getFil(type: selectedValue, filterId: selectedIdWidget);
                                      await getNewsValues(text: "", category: selectedValue, filterId: selectedIdWidget);
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
                                            onTap: () async {
                                              setState(() {
                                                _searchController.clear();
                                              });
                                              await getFil(type: selectedValue, filterId: selectedIdWidget);
                                              await getNewsValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                                              if (!mounted) {
                                                return;
                                              }
                                              FocusScope.of(context).unfocus();
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
                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                    hintText: 'Search here',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      loading
                          ? widget.fromCompare
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(height: height / 50.75),
                                      searchLoader
                                          ? SizedBox(
                                              height: height / 1.5,
                                              child: Column(
                                                children: [
                                                  Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                                ],
                                              ))
                                          : emptyBool
                                              ? SizedBox(
                                                  height: height / 1.2,
                                                  width: width,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: height / 14,
                                                      ),
                                                      SizedBox(
                                                          height: height / 3.2,
                                                          width: width,
                                                          child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                                      SizedBox(height: height / 33.83),
                                                      Text(
                                                        "Unfortunately, the content for the specified filters is not available.",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: text.scale(18),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 20.3,
                                                      ),
                                                      const Text(
                                                        "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                      ),
                                                      SizedBox(
                                                        height: height / 54.13,
                                                      ),
                                                      RichText(
                                                        textAlign: TextAlign.center,
                                                        text: TextSpan(children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(12),
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins")),
                                                          TextSpan(
                                                            recognizer: TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return const FeatureRequestPage();
                                                                }));
                                                              },
                                                            text: "Feature request page.",
                                                            style: TextStyle(
                                                                fontSize: text.scale(12),
                                                                color: const Color(0XFF0EA102),
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins"),
                                                          ),
                                                        ]),
                                                      ),
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
                                                    onLoading: () async {
                                                      setState(() {
                                                        newsInt = newsInt + 100;
                                                      });
                                                      context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                      var text = _searchController.text;
                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      mainUserId = prefs.getString('newUserId')!;
                                                      mainUserToken = prefs.getString('newUserToken')!;
                                                      var url = Uri.parse(baseurl + versionLocker + getNewsZone);
                                                      var response = await http.post(url, body: {
                                                        'category': widget.text == "Stocks"
                                                            ? "stocks"
                                                            : widget.text == "Crypto"
                                                                ? "crypto"
                                                                : widget.text == "Commodity"
                                                                    ? "commodity"
                                                                    : widget.text == "Forex"
                                                                        ? "forex"
                                                                        : "nothing",
                                                        'search': text.isEmpty ? "" : text,
                                                        'skip': newsInt.toString(),
                                                        'ticker_id': widget.tickerId.isEmpty ? "" : widget.tickerId
                                                      }, headers: {
                                                        'Authorization': mainUserToken
                                                      });
                                                      var responseData = json.decode(response.body);
                                                      if (responseData["status"]) {
                                                        if (responseData["response"].length == 0) {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Flushbar(
                                                            message: "List Completed,Can't Load more",
                                                            duration: const Duration(seconds: 2),
                                                          ).show(context);
                                                        } else {
                                                          for (int i = 0; i < responseData["response"].length; i++) {
                                                            setState(() {
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
                                                              if (finalisedCategory.toLowerCase() == 'stocks') {
                                                                if (responseData["response"][i]["exchange"] == "NSE" ||
                                                                    responseData["response"][i]["exchange"] == "BSE" ||
                                                                    responseData["response"][i]["exchange"] == "INDX") {
                                                                  newsExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
                                                                } else if (responseData["response"][i]["exchange"] == "" ||
                                                                    responseData["response"][i]["exchange"] == null) {
                                                                  newsExchangeList.add("");
                                                                } else {
                                                                  newsExchangeList.add("usastocks");
                                                                }
                                                              } else if (finalisedCategory.toLowerCase() == 'crypto') {
                                                                newsExchangeList.add(responseData["response"][i]["industry"].length == 0
                                                                    ? "coin"
                                                                    : responseData["response"][i]["industry"][0]['name'].toLowerCase());
                                                              } else if (finalisedCategory.toLowerCase() == 'commodity') {
                                                                newsExchangeList.add(responseData["response"][i]["country"].toLowerCase());
                                                              } else {
                                                                newsExchangeList.add('inrusd');
                                                              }
                                                              newsSentimentList.add((responseData["response"][i]["sentiment"] ?? "").toLowerCase());
                                                              newsDescriptionList.add(responseData["response"][i]["description"] ?? "");
                                                              newsSnippetList.add(responseData["response"][i]["snippet"] ?? "");
                                                              newsBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
                                                              newsTitlesList.add(responseData["response"][i]["title"]);
                                                              newsSourceNameList.add(responseData["response"][i]["source_name"]);
                                                              newsLinkList.add(responseData["response"][i]["news_url"]);
                                                              newsIdList.add(responseData["response"][i]["_id"]);
                                                              newsLikeList.add(responseData["response"][i]["likes_count"]);
                                                              newsDislikeList.add(responseData["response"][i]["dis_likes_count"]);
                                                              newsUseList.add(responseData["response"][i]["likes"]);
                                                              newsUseDisList.add(responseData["response"][i]["dislikes"]);
                                                              newsViewList.add(responseData["response"][i]["views_count"]);
                                                              DateTime dt = DateTime.parse(responseData["response"][i]["date"]);
                                                              final timestamp1 = dt.millisecondsSinceEpoch;
                                                              readTimestamp(timestamp1);
                                                            });
                                                          }
                                                        }
                                                      } else {}
                                                      if (mounted) setState(() {});
                                                      _refreshController.loadComplete();
                                                    },
                                                    child: ListView.builder(
                                                        physics: const ScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: newsImagesList.length,
                                                        itemBuilder: (context, index) {
                                                          if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                    height: height / 2.8,
                                                                    padding: const EdgeInsets.all(5),
                                                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                    decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            spreadRadius: 1,
                                                                            blurRadius: 1,
                                                                            offset: const Offset(1, 2),
                                                                            color: Colors.grey.shade300)
                                                                      ],
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    foregroundDecoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    clipBehavior: Clip.hardEdge,
                                                                    child: AdWidget(ad: nativeAdList[index])),
                                                                SizedBox(height: height / 57.73),
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      height: height / 3.23,
                                                                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                                }else{
                                                  bool response= await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                      NewsDescriptionPage(comeFrom: 'newsMain',
                                                        id: newsIdList[index],idList: newsIdList, descriptionList: newsDescriptionList, snippetList: newsSnippetList,
                                                      )));
                                                  if(response){
                                                    getNewsValues(text: '', category: finalisedCategory.toLowerCase(), filterId: finalisedFilterId);
                                                  }
                                                }*/

                                                                              /// need to change it soon
                                                                              // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                              //   return DemoPage(
                                                                              //     url: newsLinkList[index],
                                                                              //     text: newsTitlesList[index],
                                                                              //     image: "",
                                                                              //     id: newsIdList[index],
                                                                              //     type: 'news',
                                                                              //     activity: true,
                                                                              //     checkMain: false,
                                                                              //   );
                                                                              // }));
                                                                              Get.to(const DemoView(), arguments: {
                                                                                "id": newsIdList[index],
                                                                                "type": 'news',
                                                                                "url": '',
                                                                              });
                                                                            },
                                                                            child: Stack(
                                                                              alignment: Alignment.bottomLeft,
                                                                              children: [
                                                                                Container(
                                                                                  height: height / 4.77,
                                                                                  decoration: BoxDecoration(
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                          spreadRadius: 1,
                                                                                          blurRadius: 1,
                                                                                          offset: const Offset(1, 2),
                                                                                          color: Colors.grey.shade300)
                                                                                    ],
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(newsImagesList[index]),
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                    color: Colors.white,
                                                                                    borderRadius: const BorderRadius.only(
                                                                                        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                                                                        fontSize: text.scale(10),
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontFamily: "Poppins"),
                                                                                  ),
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
                                                                                      borderRadius: BorderRadius.only(
                                                                                          topLeft: Radius.circular(15),
                                                                                          topRight: Radius.circular(15)),
                                                                                      //  color: Colors.black12.withOpacity(0.3),
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        /* index%2==1?Container(
                                                                                                                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                          decoration: BoxDecoration(
                                                                                                                                            borderRadius: BorderRadius.circular(3),
                                                                                                                                            color: Color(0XFF39B12F),
                                                                                                                                          ),
                                                                                                                                          child: Text("Positive",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                        ): Container(
                                                                                                                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                          decoration: BoxDecoration(
                                                                                                                                            borderRadius: BorderRadius.circular(3),
                                                                                                                                            color: Color(0XFFFA3133),
                                                                                                                                          ),
                                                                                                                                          child: Text("Negative",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                        ),*/
                                                                                        /*Container(
                                                                                                                                          height: _height/35.04,
                                                                                                                                          width: _width/16.44,
                                                                                                                                          padding: EdgeInsets.all(3),
                                                                                                                                          decoration: BoxDecoration(
                                                                                                                                            shape: BoxShape.circle,
                                                                                                                                            color: Colors.white,
                                                                                                                                          ),
                                                                                                                                          child: Image.asset(
                                                                                                                                            index%2==1?
                                                                                                                                            "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png":
                                                                                                                                            "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png",
                                                                                                                                          ),
                                                                                                                                        ),*/
                                                                                        sentimentButton(
                                                                                            context: context, text: newsSentimentList[index]),
                                                                                        excLabelButton(
                                                                                            text: newsExchangeList[index], context: context)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: const BorderRadius.only(
                                                                                    bottomLeft: Radius.circular(15),
                                                                                    bottomRight: Radius.circular(15)),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(1, 2),
                                                                                      color: Colors.grey.shade300)
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
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  color: const Color(0XFFB0B0B0),
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontFamily: "Poppins"),
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
                                                                                                        commonFlushBar(
                                                                                                            context: context,
                                                                                                            initFunction: getAllData);
                                                                                                      }
                                                                                                    : () async {
                                                                                                        bool response1 = await likeFunction(
                                                                                                            id: newsIdList[index], type: "news");
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
                                                                                                    await shareFunction(
                                                                                                        id: newsIdList[index], type: "news");
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
                                                                                                      commonFlushBar(
                                                                                                          context: context, initFunction: getAllData);
                                                                                                    }
                                                                                                  : () async {
                                                                                                      bool response3 = await disLikeFunction(
                                                                                                          id: newsIdList[index], type: "news");
                                                                                                      if (response3) {
                                                                                                        logEventFunc(name: "Dislikes", type: "News");
                                                                                                        setState(() {
                                                                                                          if (newsUseDisList[index] == true) {
                                                                                                            if (newsUseList[index] == true) {
                                                                                                              /*newsLikeList[index] += 1;
                                                                                        newsDislikeList[index] -= 1;*/
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
                                                                                                          /* if (newsUseList[index] == false &&
                                                                                    newsUseDisList[index] == false) {
                                                                                  newsDislikeList[index] += 1;
                                                                                } else {
                                                                                  newsDislikeList[index] += 1;
                                                                                  newsLikeList[index] -= 1;
                                                                                }*/
                                                                                                          newsUseDisList[index] =
                                                                                                              !newsUseDisList[index];
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
                                                                                                commonFlushBar(
                                                                                                    context: context, initFunction: getAllData);
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
                                                                                                  haveLikesMain =
                                                                                                      newsLikeList[index] > 0 ? true : false;
                                                                                                  haveDisLikesMain =
                                                                                                      newsDislikeList[index] > 0 ? true : false;
                                                                                                  haveViewsMain =
                                                                                                      newsViewList[index] > 0 ? true : false;
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
                                                                                        child: Text(
                                                                                          "${newsViewList[index]} Views",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              color: const Color(0XFFB0B0B0),
                                                                                              fontWeight: FontWeight.w900,
                                                                                              fontFamily: "Poppins"),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: mainSkipValue
                                                                                            ? () {
                                                                                                commonFlushBar(
                                                                                                    context: context, initFunction: getAllData);
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
                                                                                                  haveLikesMain =
                                                                                                      newsLikeList[index] > 0 ? true : false;
                                                                                                  haveDisLikesMain =
                                                                                                      newsDislikeList[index] > 0 ? true : false;
                                                                                                  haveViewsMain =
                                                                                                      newsViewList[index] > 0 ? true : false;
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
                                                                                        child: Text(
                                                                                          "${newsLikeList[index]} Likes",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              color: const Color(0XFFB0B0B0),
                                                                                              fontWeight: FontWeight.w900,
                                                                                              fontFamily: "Poppins"),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: mainSkipValue
                                                                                            ? () {
                                                                                                commonFlushBar(
                                                                                                    context: context, initFunction: getAllData);
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
                                                                                                  haveLikesMain =
                                                                                                      newsLikeList[index] > 0 ? true : false;
                                                                                                  haveDisLikesMain =
                                                                                                      newsDislikeList[index] > 0 ? true : false;
                                                                                                  haveViewsMain =
                                                                                                      newsViewList[index] > 0 ? true : false;
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
                                                                                        child: Text(
                                                                                          "${newsDislikeList[index]} Dislikes",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              color: const Color(0XFFB0B0B0),
                                                                                              fontWeight: FontWeight.w900,
                                                                                              fontFamily: "Poppins"),
                                                                                        ),
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
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 33.83,
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                height: height / 3.23,
                                                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                child: Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        if (newsDescriptionList[index] == "" && newsSnippetList[index] == "") {
                                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                          //   return DemoPage(
                                                                          //     url: newsLinkList[index],
                                                                          //     text: newsTitlesList[index],
                                                                          //     image: "",
                                                                          //     id: newsIdList[index],
                                                                          //     type: 'news',
                                                                          //     activity: true,
                                                                          //     checkMain: false,
                                                                          //   );
                                                                          // }));
                                                                          Get.to(const DemoView(), arguments: {
                                                                            "id": newsIdList[index],
                                                                            "type": 'news',
                                                                            "url": '',
                                                                          });
                                                                        } else {
                                                                          ///need to change it soon
                                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                          //   return DemoPage(
                                                                          //     url: newsLinkList[index],
                                                                          //     text: newsTitlesList[index],
                                                                          //     image: "",
                                                                          //     id: newsIdList[index],
                                                                          //     type: 'news',
                                                                          //     activity: true,
                                                                          //     checkMain: false,
                                                                          //   );
                                                                          // }));
                                                                          Get.to(const DemoView(), arguments: {
                                                                            "id": newsIdList[index],
                                                                            "type": 'news',
                                                                            "url": '',
                                                                          });
                                                                          /*bool response=await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                        NewsDescriptionPage( comeFrom: 'newsMain',
                                                          id: newsIdList[index], idList: newsIdList, descriptionList:newsDescriptionList, snippetList: newsSnippetList,
                                                        )));
                                                    if(response){
                                                      getNewsValues(text: '', category: finalisedCategory.toLowerCase(), filterId: finalisedFilterId);
                                                    }*/
                                                                        }
                                                                      },
                                                                      child: Stack(
                                                                        alignment: Alignment.bottomLeft,
                                                                        children: [
                                                                          Container(
                                                                            height: height / 4.77,
                                                                            decoration: BoxDecoration(
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                    spreadRadius: 1,
                                                                                    blurRadius: 1,
                                                                                    offset: const Offset(1, 2),
                                                                                    color: Colors.grey.shade300)
                                                                              ],
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(newsImagesList[index]),
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                              color: Colors.white,
                                                                              borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                                                                  fontSize: text.scale(10),
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: "Poppins"),
                                                                            ),
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
                                                                                borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                                //  color: Colors.black12.withOpacity(0.3),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  /* index%2==1?Container(
                                                                                                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      borderRadius: BorderRadius.circular(3),
                                                                                                                                      color: Color(0XFF39B12F),
                                                                                                                                    ),
                                                                                                                                    child: Text("Positive",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                  ): Container(
                                                                                                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      borderRadius: BorderRadius.circular(3),
                                                                                                                                      color: Color(0XFFFA3133),
                                                                                                                                    ),
                                                                                                                                    child: Text("Negative",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                  ),*/
                                                                                  sentimentButton(
                                                                                    context: context,
                                                                                    text: newsSentimentList[index],
                                                                                  ),
                                                                                  /*Container(
                                                                                                                                      height: _height/35.04,
                                                                                                                                      width: _width/16.44,
                                                                                                                                      padding: EdgeInsets.all(3),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        shape: BoxShape.circle,
                                                                                                                                        color: Colors.white,
                                                                                                                                      ),
                                                                                                                                      child: Image.asset(
                                                                                                                                        index%2==1?
                                                                                                                                        "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png":
                                                                                                                                        "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png",
                                                                                                                                      ),
                                                                                                                                    ),*/
                                                                                  excLabelButton(text: newsExchangeList[index], context: context),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: const BorderRadius.only(
                                                                              bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(1, 2),
                                                                                color: Colors.grey.shade300)
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
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontFamily: "Poppins"),
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
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: getAllData);
                                                                                                }
                                                                                              : () async {
                                                                                                  bool response1 = await likeFunction(
                                                                                                      id: newsIdList[index], type: "news");
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
                                                                                              await shareFunction(
                                                                                                  id: newsIdList[index], type: "news");
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
                                                                                                commonFlushBar(
                                                                                                    context: context, initFunction: getAllData);
                                                                                              }
                                                                                            : () async {
                                                                                                bool response3 = await disLikeFunction(
                                                                                                    id: newsIdList[index], type: "news");
                                                                                                if (response3) {
                                                                                                  logEventFunc(name: "Dislikes", type: "News");
                                                                                                  setState(() {
                                                                                                    if (newsUseDisList[index] == true) {
                                                                                                      if (newsUseList[index] == true) {
                                                                                                        /*newsLikeList[index] += 1;
                                                                                        newsDislikeList[index] -= 1;*/
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
                                                                                                    /* if (newsUseList[index] == false &&
                                                                                    newsUseDisList[index] == false) {
                                                                                  newsDislikeList[index] += 1;
                                                                                } else {
                                                                                  newsDislikeList[index] += 1;
                                                                                  newsLikeList[index] -= 1;
                                                                                }*/
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
                                                                                            haveDisLikesMain =
                                                                                                newsDislikeList[index] > 0 ? true : false;
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
                                                                                  child: Text(
                                                                                    "${newsViewList[index]} Views",
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10),
                                                                                        color: const Color(0XFFB0B0B0),
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontFamily: "Poppins"),
                                                                                  ),
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
                                                                                            haveDisLikesMain =
                                                                                                newsDislikeList[index] > 0 ? true : false;
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
                                                                                  child: Text(
                                                                                    "${newsLikeList[index]} Likes",
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10),
                                                                                        color: const Color(0XFFB0B0B0),
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontFamily: "Poppins"),
                                                                                  ),
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
                                                                                            haveDisLikesMain =
                                                                                                newsDislikeList[index] > 0 ? true : false;
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
                                                                                  child: Text(
                                                                                    "${newsDislikeList[index]} Dislikes",
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10),
                                                                                        color: const Color(0XFFB0B0B0),
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontFamily: "Poppins"),
                                                                                  ),
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
                                  ),
                                )
                              : Obx(() => extraContainMain.value
                                  ? Stack(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: height / 50.75),
                                            emptyBool
                                                ? SizedBox(
                                                    // height: height / 1.2,
                                                    width: width,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: height / 14,
                                                        ),
                                                        SizedBox(
                                                            height: height / 3.2,
                                                            width: width,
                                                            child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                                        SizedBox(height: height / 33.83),
                                                        SizedBox(
                                                          width: width,
                                                          child: Text("Unfortunately, the content for the specified filters is not available.",
                                                              textAlign: TextAlign.center,
                                                              maxLines: 2,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium /*TextStyle(
                                                              fontSize: text.scale(18),
                                                              fontWeight: FontWeight.w600,
                                                            ),*/
                                                              ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 20.3,
                                                        ),
                                                        SizedBox(
                                                          width: width,
                                                          child: Text(
                                                            "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                                            textAlign: TextAlign.center,
                                                            maxLines: 3,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelLarge /*TextStyle(fontSize: 12, fontWeight: FontWeight.w600)*/,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 54.13,
                                                        ),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelLarge /*TextStyle(
                                                                    fontSize: text.scale(12),
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins")*/
                                                                ),
                                                            TextSpan(
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return const FeatureRequestPage();
                                                                    }));
                                                                  },
                                                                text: "Feature request page.",
                                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                                    color: const Color(
                                                                        0XFF0EA102)) /*TextStyle(
                                                                  fontSize: text.scale(12),
                                                                  color: const Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins"),*/
                                                                ),
                                                          ]),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: Platform.isIOS ? height / 1.5 : height / 1.4,
                                                    child: ListView.builder(
                                                        physics: const ScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: newsImagesList.length,
                                                        itemBuilder: (context, index) {
                                                          if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                    height: height / 2.8,
                                                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                    padding: const EdgeInsets.all(5),
                                                                    decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            spreadRadius: 1,
                                                                            blurRadius: 1,
                                                                            offset: const Offset(1, 2),
                                                                            color: Colors.grey.shade300)
                                                                      ],
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    foregroundDecoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    clipBehavior: Clip.hardEdge,
                                                                    child: AdWidget(ad: nativeAdList[index])),
                                                                SizedBox(height: height / 57.73),
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      height: height / 3.23,
                                                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                      child: Column(
                                                                        children: [
                                                                          Stack(
                                                                            alignment: Alignment.bottomLeft,
                                                                            children: [
                                                                              Container(
                                                                                height: height / 4.77,
                                                                                decoration: BoxDecoration(
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                        spreadRadius: 0,
                                                                                        blurRadius: 4,
                                                                                        color: Theme.of(context).colorScheme.tertiary)
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
                                                                                height: height / 10.97,
                                                                                width: width,
                                                                                padding: const EdgeInsets.all(10),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.black12.withOpacity(0.3),
                                                                                ),
                                                                                child: Text(
                                                                                  newsTitlesList[index],
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10),
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: "Poppins"),
                                                                                ),
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
                                                                                    borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                                    // color: Colors.black12.withOpacity(0.3),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      /* index%2==1?Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color(0XFF39B12F),
                                                        ),
                                                        child: Text("Positive",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                      ): Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color(0XFFFA3133),
                                                        ),
                                                        child: Text("Negative",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                      ),*/
                                                                                      /*Container(
                                                            height: _height/35.04,
                                                            width: _width/16.44,
                                                            padding: EdgeInsets.all(3),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                            ),
                                                            child: Image.asset(
                                                              index%2==1?
                                                              "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png":
                                                              "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png",
                                                            ),
                                                          ),*/
                                                                                      sentimentButton(
                                                                                        text: newsSentimentList[index],
                                                                                        context: context,
                                                                                      ),
                                                                                      excLabelButton(text: newsExchangeList[index], context: context)
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Theme.of(context).colorScheme.background,
                                                                                borderRadius: const BorderRadius.only(
                                                                                    bottomLeft: Radius.circular(15),
                                                                                    bottomRight: Radius.circular(15)),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                      spreadRadius: 0,
                                                                                      blurRadius: 4,
                                                                                      color: Theme.of(context).colorScheme.tertiary)
                                                                                ]),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: height / 86.6,
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
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  color: const Color(0XFFB0B0B0),
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontFamily: "Poppins"),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        margin: const EdgeInsets.only(left: 8),
                                                                                        width: width / 2.6,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Container(
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
                                                                                            ),
                                                                                            SizedBox(width: width / 20),
                                                                                            SvgPicture.asset(
                                                                                              isDarkTheme.value
                                                                                                  ? "assets/home_screen/share_dark.svg"
                                                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                            ),
                                                                                            SizedBox(width: width / 20),
                                                                                            newsUseDisList[index]
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
                                                                                SizedBox(
                                                                                  height: height / 86.6,
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
                                                                                      Text(
                                                                                        "${newsViewList[index]} Views",
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w900,
                                                                                            fontFamily: "Poppins"),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Text(
                                                                                        "${newsLikeList[index]} Likes",
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w900,
                                                                                            fontFamily: "Poppins"),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Text(
                                                                                        "${newsDislikeList[index]} Dislikes",
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w900,
                                                                                            fontFamily: "Poppins"),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: height / 86.6,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 33.83,
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                height: height / 3.23,
                                                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                child: Column(
                                                                  children: [
                                                                    Stack(
                                                                      alignment: Alignment.bottomLeft,
                                                                      children: [
                                                                        Container(
                                                                          height: height / 4.77,
                                                                          decoration: BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                  spreadRadius: 0,
                                                                                  blurRadius: 4,
                                                                                  color: Theme.of(context).colorScheme.tertiary)
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
                                                                          height: height / 10.97,
                                                                          width: width,
                                                                          padding: const EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.black12.withOpacity(0.3),
                                                                          ),
                                                                          child: Text(
                                                                            newsTitlesList[index],
                                                                            style: TextStyle(
                                                                                fontSize: text.scale(10),
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: "Poppins"),
                                                                          ),
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
                                                                              borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                              // color: Colors.black12.withOpacity(0.3),
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                /* index%2==1?Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color(0XFF39B12F),
                                                        ),
                                                        child: Text("Positive",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                      ): Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Color(0XFFFA3133),
                                                        ),
                                                        child: Text("Negative",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                      ),*/
                                                                                /*Container(
                                                            height: _height/35.04,
                                                            width: _width/16.44,
                                                            padding: EdgeInsets.all(3),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                            ),
                                                            child: Image.asset(
                                                              index%2==1?
                                                              "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png":
                                                              "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png",
                                                            ),
                                                          ),*/
                                                                                sentimentButton(
                                                                                  text: newsSentimentList[index],
                                                                                  context: context,
                                                                                ),
                                                                                excLabelButton(text: newsExchangeList[index], context: context)
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).colorScheme.background,
                                                                          borderRadius: const BorderRadius.only(
                                                                              bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                spreadRadius: 0,
                                                                                blurRadius: 4,
                                                                                color: Theme.of(context).colorScheme.tertiary)
                                                                          ]),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          SizedBox(
                                                                            height: height / 86.6,
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
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontFamily: "Poppins"),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: const EdgeInsets.only(left: 8),
                                                                                  width: width / 2.6,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
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
                                                                                      ),
                                                                                      SizedBox(width: width / 20),
                                                                                      SvgPicture.asset(
                                                                                        isDarkTheme.value
                                                                                            ? "assets/home_screen/share_dark.svg"
                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                      ),
                                                                                      SizedBox(width: width / 20),
                                                                                      newsUseDisList[index]
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
                                                                          SizedBox(
                                                                            height: height / 86.6,
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
                                                                                Text(
                                                                                  "${newsViewList[index]} Views",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10),
                                                                                      color: const Color(0XFFB0B0B0),
                                                                                      fontWeight: FontWeight.w900,
                                                                                      fontFamily: "Poppins"),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 3,
                                                                                ),
                                                                                Text(
                                                                                  "${newsLikeList[index]} Likes",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10),
                                                                                      color: const Color(0XFFB0B0B0),
                                                                                      fontWeight: FontWeight.w900,
                                                                                      fontFamily: "Poppins"),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 3,
                                                                                ),
                                                                                Text(
                                                                                  "${newsDislikeList[index]} Dislikes",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10),
                                                                                      color: const Color(0XFFB0B0B0),
                                                                                      fontWeight: FontWeight.w900,
                                                                                      fontFamily: "Poppins"),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: height / 86.6,
                                                                          ),
                                                                        ],
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
                                                  )
                                          ],
                                        ),
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
                                                            newsImagesList.clear();
                                                            newsExchangeList.clear();
                                                            newsSentimentList.clear();
                                                            newsDescriptionList.clear();
                                                            newsSnippetList.clear();
                                                            newsBookMarkList.clear();
                                                            newsSourceNameList.clear();
                                                            newsTitlesList.clear();
                                                            newsLinkList.clear();
                                                            timeList.clear();
                                                            newsInt = 0;
                                                            extraContainMain.value = false;
                                                            selectedWidget = enteredFilteredList[index];
                                                            finalisedFilterName = enteredFilteredList[index];
                                                            filterBool = true;
                                                            filterId = enteredFilteredIdList[index];
                                                            finalisedFilterId = enteredFilteredIdList[index];
                                                            prefs.setString('finalisedFilterId1', finalisedFilterId);
                                                            prefs.setString('finalisedFilterName1', finalisedFilterName);
                                                          });
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                          await getFil(type: finalisedCategory, filterId: finalisedFilterId);
                                                          await getNewsValues(
                                                              category: finalisedCategory,
                                                              filterId: finalisedFilterId,
                                                              text: _searchController.text.isEmpty ? "" : _searchController.text);
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
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return StocksEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'news',
                                                                        );
                                                                      }));
                                                                    } else if (selectedValue == "Crypto") {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return CryptoEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'news',
                                                                        );
                                                                      }));
                                                                    } else if (selectedValue == "Commodity") {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return CommodityEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'news',
                                                                        );
                                                                      }));
                                                                    } else {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return ForexEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'news',
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
                                                                      await getNewsValues(
                                                                          category: selectedValue,
                                                                          filterId: finalisedFilterId,
                                                                          text: _searchController.text.isEmpty ? "" : _searchController.text);
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
                                                          extraContainMain.value = false;
                                                          if (mainSkipValue) {
                                                            commonFlushBar(context: context, initFunction: getAllData);
                                                          } else {
                                                            navigationPage1();
                                                          }
                                                        },
                                                        title:
                                                            const Text("Add a New List", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
                                        /*Positioned(
                                          right: 15,
                                          child: Container(
                                            width: width * 0.6,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.white,
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
                                                            newsImagesList.clear();
                                                            newsExchangeList.clear();
                                                            newsSentimentList.clear();
                                                            newsDescriptionList.clear();
                                                            newsSnippetList.clear();
                                                            newsBookMarkList.clear();
                                                            newsSourceNameList.clear();
                                                            newsTitlesList.clear();
                                                            newsLinkList.clear();
                                                            timeList.clear();
                                                            newsInt = 0;
                                                            extraContainMain.value = false;
                                                            selectedWidget = enteredFilteredList[index];
                                                            finalisedFilterName = enteredFilteredList[index];
                                                            filterBool = true;
                                                            filterId = enteredFilteredIdList[index];
                                                            finalisedFilterId = enteredFilteredIdList[index];
                                                            prefs.setString('finalisedFilterId1', finalisedFilterId);
                                                            prefs.setString('finalisedFilterName1', finalisedFilterName);
                                                          });
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                          await getFil(type: finalisedCategory, filterId: finalisedFilterId);
                                                          await getNewsValues(
                                                              category: finalisedCategory,
                                                              filterId: finalisedFilterId,
                                                              text: _searchController.text.isEmpty ? "" : _searchController.text);
                                                        },
                                                        title: Text(
                                                          enteredFilteredList[index],
                                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                        ),
                                                        trailing: SizedBox(
                                                          width: 85,
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                splashRadius: 0.1,
                                                                onPressed: () async {
                                                                  var response =
                                                                      await _filterFunction.getEditFilter(filterId: enteredFilteredIdList[index]);
                                                                  extraContainMain.value = false;
                                                                  if (selectedValue == "Stocks") {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return StocksEditFilterPage(
                                                                        text: selectedValue,
                                                                        filterId: enteredFilteredIdList[index],
                                                                        response: response,
                                                                        page: 'news',
                                                                      );
                                                                    }));
                                                                  } else if (selectedValue == "Crypto") {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return CryptoEditFilterPage(
                                                                        text: selectedValue,
                                                                        filterId: enteredFilteredIdList[index],
                                                                        response: response,
                                                                        page: 'news',
                                                                      );
                                                                    }));
                                                                  } else if (selectedValue == "Commodity") {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return CommodityEditFilterPage(
                                                                        text: selectedValue,
                                                                        filterId: enteredFilteredIdList[index],
                                                                        response: response,
                                                                        page: 'news',
                                                                      );
                                                                    }));
                                                                  } else {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return ForexEditFilterPage(
                                                                        text: selectedValue,
                                                                        filterId: enteredFilteredIdList[index],
                                                                        response: response,
                                                                        page: 'news',
                                                                      );
                                                                    }));
                                                                  }
                                                                },
                                                                icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg"),
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              SizedBox(
                                                                height: height / 25.375,
                                                                width: width / 11.72,
                                                                child: IconButton(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                  splashRadius: 0.1,
                                                                  onPressed: () async {
                                                                    await _filterFunction.getDeleteFilter(filterId: enteredFilteredIdList[index]);
                                                                    await getFil(type: selectedValue, filterId: "");
                                                                    //setState(() {enteredFilteredList.removeAt(index);});
                                                                    await getNewsValues(
                                                                        category: selectedValue,
                                                                        filterId: finalisedFilterId,
                                                                        text: _searchController.text.isEmpty ? "" : _searchController.text);
                                                                  },
                                                                  icon: SizedBox(
                                                                    height: 18,
                                                                    width: 18,
                                                                    child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/x-circle.png"),
                                                                  ),
                                                                ),
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
                                                          extraContainMain.value = false;
                                                          if (mainSkipValue) {
                                                            commonFlushBar(context: context, initFunction: getAllData);
                                                          } else {
                                                            navigationPage1();
                                                          }
                                                        },
                                                        title:
                                                            const Text("Add a New List", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                        trailing: Container(
                                                          margin: const EdgeInsets.only(right: 10),
                                                          child: const Icon(
                                                            Icons.add_circle_outline_sharp,
                                                            size: 22,
                                                            color: Color(0XFF0EA102),
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ),
                                        )*/
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: height / 50.75),
                                        searchLoader
                                            ? SizedBox(
                                                height: height / 1.5,
                                                child: Column(
                                                  children: [
                                                    Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                                  ],
                                                ))
                                            : emptyBool
                                                ? SizedBox(
                                                    // height: height / 1.2,
                                                    width: width,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: height / 14,
                                                        ),
                                                        SizedBox(
                                                            height: height / 3.2,
                                                            width: width,
                                                            child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                                        SizedBox(height: height / 33.83),
                                                        SizedBox(
                                                          width: width,
                                                          child: Text("Unfortunately, the content for the specified filters is not available.",
                                                              textAlign: TextAlign.center,
                                                              maxLines: 2,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium /*TextStyle(
                                                              fontSize: text.scale(18),
                                                              fontWeight: FontWeight.w600,
                                                            ),*/
                                                              ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 20.3,
                                                        ),
                                                        SizedBox(
                                                          width: width,
                                                          child: Text(
                                                            "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                                            textAlign: TextAlign.center,
                                                            maxLines: 3,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelLarge /*TextStyle(fontSize: 12, fontWeight: FontWeight.w600)*/,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 54.13,
                                                        ),
                                                        RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelLarge /*TextStyle(
                                                                    fontSize: text.scale(12),
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins")*/
                                                                ),
                                                            TextSpan(
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return const FeatureRequestPage();
                                                                    }));
                                                                  },
                                                                text: "Feature request page.",
                                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                                    color: const Color(
                                                                        0XFF0EA102)) /*TextStyle(
                                                                  fontSize: text.scale(12),
                                                                  color: const Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins"),*/
                                                                ),
                                                          ]),
                                                        ),
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
                                                      onLoading: () async {
                                                        setState(() {
                                                          newsInt = newsInt + 100;
                                                        });
                                                        context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                        var text = _searchController.text;
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        mainUserId = prefs.getString('newUserId') ?? "";
                                                        mainUserToken = prefs.getString('newUserToken') ?? "";
                                                        var url = Uri.parse(baseurl + versionLocker + getNewsZone);
                                                        var response = await http.post(
                                                          url,
                                                          body: {
                                                            'category': finalisedCategory == "Stocks"
                                                                ? "stocks"
                                                                : finalisedCategory == "Crypto"
                                                                    ? "crypto"
                                                                    : finalisedCategory == "Commodity"
                                                                        ? "commodity"
                                                                        : finalisedCategory == "Forex"
                                                                            ? "forex"
                                                                            : "nothing",
                                                            'search': text.isEmpty ? "" : text,
                                                            'skip': newsInt.toString(),
                                                            'filter_id': selectedIdWidget
                                                          },
                                                          // headers: {'Authorization': mainUserToken}
                                                        );
                                                        var responseData = json.decode(response.body);
                                                        if (responseData["status"]) {
                                                          if (responseData["response"].length == 0) {
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Flushbar(
                                                              message: "List Completed,Can't Load more",
                                                              duration: const Duration(seconds: 2),
                                                            ).show(context);
                                                          } else {
                                                            for (int i = 0; i < responseData["response"].length; i++) {
                                                              setState(() {
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
                                                                if (finalisedCategory.toLowerCase() == 'stocks') {
                                                                  if (responseData["response"][i]["exchange"] == "NSE" ||
                                                                      responseData["response"][i]["exchange"] == "BSE" ||
                                                                      responseData["response"][i]["exchange"] == "INDX") {
                                                                    newsExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
                                                                  } else if (responseData["response"][i]["exchange"] == "" ||
                                                                      responseData["response"][i]["exchange"] == null) {
                                                                    newsExchangeList.add("");
                                                                  } else {
                                                                    newsExchangeList.add("usastocks");
                                                                  }
                                                                } else if (finalisedCategory.toLowerCase() == 'crypto') {
                                                                  newsExchangeList.add(responseData["response"][i]["industry"][0].length == 0
                                                                      ? "coin"
                                                                      : responseData["response"][i]["industry"][0]['name'].toLowerCase());
                                                                } else if (finalisedCategory.toLowerCase() == 'commodity') {
                                                                  newsExchangeList.add(responseData["response"][i]["country"].toLowerCase());
                                                                } else {
                                                                  newsExchangeList.add('inrusd');
                                                                }
                                                                newsSentimentList.add((responseData["response"][i]["sentiment"] ?? "").toLowerCase());
                                                                newsDescriptionList.add(responseData["response"][i]["description"] ?? "");
                                                                newsSnippetList.add(responseData["response"][i]["snippet"] ?? "");
                                                                newsBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
                                                                newsTitlesList.add(responseData["response"][i]["title"]);
                                                                newsSourceNameList.add(responseData["response"][i]["source_name"]);
                                                                newsLinkList.add(responseData["response"][i]["news_url"]);
                                                                newsIdList.add(responseData["response"][i]["_id"]);
                                                                newsLikeList.add(responseData["response"][i]["likes_count"]);
                                                                newsDislikeList.add(responseData["response"][i]["dis_likes_count"]);
                                                                newsUseList.add(responseData["response"][i]["likes"]);
                                                                newsUseDisList.add(responseData["response"][i]["dislikes"]);
                                                                newsViewList.add(responseData["response"][i]["views_count"]);
                                                                DateTime dt = DateTime.parse(responseData["response"][i]["date"]);
                                                                final timestamp1 = dt.millisecondsSinceEpoch;
                                                                readTimestamp(timestamp1);
                                                              });
                                                            }
                                                          }
                                                        } else {}
                                                        if (mounted) setState(() {});
                                                        _refreshController.loadComplete();
                                                      },
                                                      child: ListView.builder(
                                                          physics: const ScrollPhysics(),
                                                          scrollDirection: Axis.vertical,
                                                          itemCount: newsImagesList.length,
                                                          itemBuilder: (context, index) {
                                                            if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                              return Column(
                                                                children: [
                                                                  Container(
                                                                      height: height / 2.8,
                                                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                      padding: const EdgeInsets.all(5),
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
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        height: height / 3.23,
                                                                        margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                                }else{
                                                  bool response= await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                      NewsDescriptionPage(comeFrom: 'newsMain',
                                                        id: newsIdList[index],idList: newsIdList, descriptionList: newsDescriptionList, snippetList: newsSnippetList,
                                                      )));
                                                  if(response){
                                                    getNewsValues(text: '', category: finalisedCategory.toLowerCase(), filterId: finalisedFilterId);
                                                  }
                                                }*/

                                                                                /// need to change it soon
                                                                                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                //   return DemoPage(
                                                                                //     url: newsLinkList[index],
                                                                                //     text: newsTitlesList[index],
                                                                                //     image: "",
                                                                                //     id: newsIdList[index],
                                                                                //     type: 'news',
                                                                                //     activity: true,
                                                                                //     checkMain: false,
                                                                                //   );
                                                                                // }));
                                                                                Get.to(const DemoView(), arguments: {
                                                                                  "id": newsIdList[index],
                                                                                  "type": 'news',
                                                                                  "url": '',
                                                                                });
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
                                                                                            color: Theme.of(context).colorScheme.tertiary)
                                                                                      ],
                                                                                      image: DecorationImage(
                                                                                        image: NetworkImage(newsImagesList[index]),
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                      color: Colors.white,
                                                                                      borderRadius: const BorderRadius.only(
                                                                                          topLeft: Radius.circular(15),
                                                                                          topRight: Radius.circular(15)),
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
                                                                                          fontSize: text.scale(10),
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),
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
                                                                                        borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(15),
                                                                                            topRight: Radius.circular(15)),
                                                                                        //  color: Colors.black12.withOpacity(0.3),
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          /* index%2==1?Container(
                                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        borderRadius: BorderRadius.circular(3),
                                                                                                                                        color: Color(0XFF39B12F),
                                                                                                                                      ),
                                                                                                                                      child: Text("Positive",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                    ): Container(
                                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        borderRadius: BorderRadius.circular(3),
                                                                                                                                        color: Color(0XFFFA3133),
                                                                                                                                      ),
                                                                                                                                      child: Text("Negative",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                    ),*/
                                                                                          /*Container(
                                                                                                                                      height: _height/35.04,
                                                                                                                                      width: _width/16.44,
                                                                                                                                      padding: EdgeInsets.all(3),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        shape: BoxShape.circle,
                                                                                                                                        color: Colors.white,
                                                                                                                                      ),
                                                                                                                                      child: Image.asset(
                                                                                                                                        index%2==1?
                                                                                                                                        "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png":
                                                                                                                                        "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png",
                                                                                                                                      ),
                                                                                                                                    ),*/
                                                                                          sentimentButton(
                                                                                              context: context, text: newsSentimentList[index]),
                                                                                          excLabelButton(
                                                                                              text: newsExchangeList[index], context: context)
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: Theme.of(context).colorScheme.background /*Colors.white*/,
                                                                                  borderRadius: const BorderRadius.only(
                                                                                      bottomLeft: Radius.circular(15),
                                                                                      bottomRight: Radius.circular(15)),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                        spreadRadius: 0,
                                                                                        blurRadius: 4.0,
                                                                                        color: Theme.of(context).colorScheme.tertiary)
                                                                                  ]),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: height / 86.6,
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
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    color: const Color(0XFFB0B0B0),
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontFamily: "Poppins"),
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
                                                                                                          commonFlushBar(
                                                                                                              context: context,
                                                                                                              initFunction: getAllData);
                                                                                                        }
                                                                                                      : () async {
                                                                                                          bool response1 = await likeFunction(
                                                                                                              id: newsIdList[index], type: "news");
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
                                                                                                              newsUseList[index] =
                                                                                                                  !newsUseList[index];
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
                                                                                                      await shareFunction(
                                                                                                          id: newsIdList[index], type: "news");
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
                                                                                                        commonFlushBar(
                                                                                                            context: context,
                                                                                                            initFunction: getAllData);
                                                                                                      }
                                                                                                    : () async {
                                                                                                        bool response3 = await disLikeFunction(
                                                                                                            id: newsIdList[index], type: "news");
                                                                                                        if (response3) {
                                                                                                          logEventFunc(
                                                                                                              name: "Dislikes", type: "News");
                                                                                                          setState(() {
                                                                                                            if (newsUseDisList[index] == true) {
                                                                                                              if (newsUseList[index] == true) {
                                                                                                                /*newsLikeList[index] += 1;
                                                                                        newsDislikeList[index] -= 1;*/
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
                                                                                                            /* if (newsUseList[index] == false &&
                                                                                    newsUseDisList[index] == false) {
                                                                                  newsDislikeList[index] += 1;
                                                                                } else {
                                                                                  newsDislikeList[index] += 1;
                                                                                  newsLikeList[index] -= 1;
                                                                                }*/
                                                                                                            newsUseDisList[index] =
                                                                                                                !newsUseDisList[index];
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
                                                                                  SizedBox(
                                                                                    height: height / 86.6,
                                                                                  ),
                                                                                  Container(
                                                                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: mainSkipValue
                                                                                              ? () {
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: getAllData);
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
                                                                                                    haveLikesMain =
                                                                                                        newsLikeList[index] > 0 ? true : false;
                                                                                                    haveDisLikesMain =
                                                                                                        newsDislikeList[index] > 0 ? true : false;
                                                                                                    haveViewsMain =
                                                                                                        newsViewList[index] > 0 ? true : false;
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
                                                                                          child: Text(
                                                                                            "${newsViewList[index]} Views",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                color: const Color(0XFFB0B0B0),
                                                                                                fontWeight: FontWeight.w900,
                                                                                                fontFamily: "Poppins"),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 3,
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: mainSkipValue
                                                                                              ? () {
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: getAllData);
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
                                                                                                    haveLikesMain =
                                                                                                        newsLikeList[index] > 0 ? true : false;
                                                                                                    haveDisLikesMain =
                                                                                                        newsDislikeList[index] > 0 ? true : false;
                                                                                                    haveViewsMain =
                                                                                                        newsViewList[index] > 0 ? true : false;
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
                                                                                          child: Text(
                                                                                            "${newsLikeList[index]} Likes",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                color: const Color(0XFFB0B0B0),
                                                                                                fontWeight: FontWeight.w900,
                                                                                                fontFamily: "Poppins"),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 3,
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: mainSkipValue
                                                                                              ? () {
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: getAllData);
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
                                                                                                    haveLikesMain =
                                                                                                        newsLikeList[index] > 0 ? true : false;
                                                                                                    haveDisLikesMain =
                                                                                                        newsDislikeList[index] > 0 ? true : false;
                                                                                                    haveViewsMain =
                                                                                                        newsViewList[index] > 0 ? true : false;
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
                                                                                          child: Text(
                                                                                            "${newsDislikeList[index]} Dislikes",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                color: const Color(0XFFB0B0B0),
                                                                                                fontWeight: FontWeight.w900,
                                                                                                fontFamily: "Poppins"),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 86.6,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: height / 33.83,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  height: height / 3.23,
                                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                                }else{
                                                  bool response= await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                      NewsDescriptionPage(comeFrom: 'newsMain',
                                                        id: newsIdList[index],idList: newsIdList, descriptionList: newsDescriptionList, snippetList: newsSnippetList,
                                                      )));
                                                  if(response){
                                                    getNewsValues(text: '', category: finalisedCategory.toLowerCase(), filterId: finalisedFilterId);
                                                  }
                                                }*/

                                                                          /// need to change it soon
                                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                          //   return DemoPage(
                                                                          //     url: newsLinkList[index],
                                                                          //     text: newsTitlesList[index],
                                                                          //     image: "",
                                                                          //     id: newsIdList[index],
                                                                          //     type: 'news',
                                                                          //     activity: true,
                                                                          //     checkMain: false,
                                                                          //   );
                                                                          // }));
                                                                          Get.to(const DemoView(), arguments: {
                                                                            "id": newsIdList[index],
                                                                            "type": 'news',
                                                                            "url": '',
                                                                          });
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
                                                                                      color: Theme.of(context).colorScheme.tertiary)
                                                                                ],
                                                                                image: DecorationImage(
                                                                                  image: NetworkImage(newsImagesList[index]),
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                                color: Colors.white,
                                                                                borderRadius: const BorderRadius.only(
                                                                                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                                                                    fontSize: text.scale(10),
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: "Poppins"),
                                                                              ),
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
                                                                                  borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                                  //  color: Colors.black12.withOpacity(0.3),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    /* index%2==1?Container(
                                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        borderRadius: BorderRadius.circular(3),
                                                                                                                                        color: Color(0XFF39B12F),
                                                                                                                                      ),
                                                                                                                                      child: Text("Positive",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                    ): Container(
                                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        borderRadius: BorderRadius.circular(3),
                                                                                                                                        color: Color(0XFFFA3133),
                                                                                                                                      ),
                                                                                                                                      child: Text("Negative",style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Colors.white),),
                                                                                                                                    ),*/
                                                                                    /*Container(
                                                                                                                                      height: _height/35.04,
                                                                                                                                      width: _width/16.44,
                                                                                                                                      padding: EdgeInsets.all(3),
                                                                                                                                      decoration: BoxDecoration(
                                                                                                                                        shape: BoxShape.circle,
                                                                                                                                        color: Colors.white,
                                                                                                                                      ),
                                                                                                                                      child: Image.asset(
                                                                                                                                        index%2==1?
                                                                                                                                        "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png":
                                                                                                                                        "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png",
                                                                                                                                      ),
                                                                                                                                    ),*/
                                                                                    sentimentButton(context: context, text: newsSentimentList[index]),
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
                                                                            color: Theme.of(context).colorScheme.background /*Colors.white*/,
                                                                            borderRadius: const BorderRadius.only(
                                                                                bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                  spreadRadius: 0,
                                                                                  blurRadius: 4.0,
                                                                                  color: Theme.of(context).colorScheme.tertiary)
                                                                            ]),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height / 86.6,
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
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              color: const Color(0XFFB0B0B0),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontFamily: "Poppins"),
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
                                                                                                    commonFlushBar(
                                                                                                        context: context, initFunction: getAllData);
                                                                                                  }
                                                                                                : () async {
                                                                                                    bool response1 = await likeFunction(
                                                                                                        id: newsIdList[index], type: "news");
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
                                                                                                await shareFunction(
                                                                                                    id: newsIdList[index], type: "news");
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
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: getAllData);
                                                                                                }
                                                                                              : () async {
                                                                                                  bool response3 = await disLikeFunction(
                                                                                                      id: newsIdList[index], type: "news");
                                                                                                  if (response3) {
                                                                                                    logEventFunc(name: "Dislikes", type: "News");
                                                                                                    setState(() {
                                                                                                      if (newsUseDisList[index] == true) {
                                                                                                        if (newsUseList[index] == true) {
                                                                                                          /*newsLikeList[index] += 1;
                                                                                        newsDislikeList[index] -= 1;*/
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
                                                                                                      /* if (newsUseList[index] == false &&
                                                                                    newsUseDisList[index] == false) {
                                                                                  newsDislikeList[index] += 1;
                                                                                } else {
                                                                                  newsDislikeList[index] += 1;
                                                                                  newsLikeList[index] -= 1;
                                                                                }*/
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
                                                                            SizedBox(
                                                                              height: height / 86.6,
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: mainSkipValue
                                                                                        ? () {
                                                                                            commonFlushBar(
                                                                                                context: context, initFunction: getAllData);
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
                                                                                              haveDisLikesMain =
                                                                                                  newsDislikeList[index] > 0 ? true : false;
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
                                                                                    child: Text(
                                                                                      "${newsViewList[index]} Views",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          color: const Color(0XFFB0B0B0),
                                                                                          fontWeight: FontWeight.w900,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 3,
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: mainSkipValue
                                                                                        ? () {
                                                                                            commonFlushBar(
                                                                                                context: context, initFunction: getAllData);
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
                                                                                              haveDisLikesMain =
                                                                                                  newsDislikeList[index] > 0 ? true : false;
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
                                                                                    child: Text(
                                                                                      "${newsLikeList[index]} Likes",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          color: const Color(0XFFB0B0B0),
                                                                                          fontWeight: FontWeight.w900,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 3,
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: mainSkipValue
                                                                                        ? () {
                                                                                            commonFlushBar(
                                                                                                context: context, initFunction: getAllData);
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
                                                                                              haveDisLikesMain =
                                                                                                  newsDislikeList[index] > 0 ? true : false;
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
                                                                                    child: Text(
                                                                                      "${newsDislikeList[index]} Dislikes",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          color: const Color(0XFFB0B0B0),
                                                                                          fontWeight: FontWeight.w900,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 86.6,
                                                                            ),
                                                                          ],
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
                                    ))
                          : Expanded(
                              child: Center(
                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                              ),
                            )
                    ],
                  ),
                )),
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
                              child: const Icon(Icons.remove_red_eye_outlined)

                              // SvgPicture.asset(
                              //   isDarkTheme.value? "assets/home_screen/like_filled_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",,
                              // ),
                              ),
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
