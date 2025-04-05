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

import 'you_tube_player_landscape_screen.dart';

class VideosMainPage extends StatefulWidget {
  final String text;
  final bool fromCompare;
  final bool? homeSearch;
  final String tickerId;
  final String tickerName;

  const VideosMainPage({
    Key? key,
    required this.text,
    required this.tickerId,
    required this.tickerName,
    required this.fromCompare,
    this.homeSearch,
  }) : super(key: key);

  @override
  State<VideosMainPage> createState() => _VideosMainPageState();
}

class _VideosMainPageState extends State<VideosMainPage> {
  List<String> categoriesList = ["Stocks", "Crypto", "Commodity", "Forex"];
  String selectedValue = "Stocks";
  String selectedWidget = "";
  String selectedIdWidget = "";
  List enteredNewList = [];
  List videosViewList = [];
  late Uri newLink;
  final FilterFunction _filterFunction = FilterFunction();

  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserId = "";
  String mainUserToken = '';
  var time = '';
  List videosImagesList = [];
  List videosSourceNameList = [];
  List videosTitlesList = [];
  List<String> videosTimeList = [];
  List<String> videosLinkList = [];
  int newsInt = 0;
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool filterBool = false;
  String filterId = "";
  bool emptyBool = false;
  bool loading = false;
  bool searchLoader = false;
  bool searchValue1 = false;
  List<String> videosIdList = [];
  List<String> videosExchangeList = [];
  List<String> videosSentimentList = [];
  List<String> videosDescriptionList = [];
  List<String> videosSnippetList = [];
  List<bool> videosBookMarkList = [];
  List<String> videosTickerIdList = [];
  List videosLikeList = [];
  List videosDislikeList = [];
  List videosUseDisList = [];
  List videosUseList = [];
  List<bool> likeValue = [];
  List<bool> disLikeValue = [];
  List<String> videoLikedImagesList = [];
  List<String> videoLikedIdList = [];
  List<String> videoLikedSourceNameList = [];
  List<String> videoViewedImagesList = [];
  List<String> videoViewedIdList = [];
  List<String> videoViewedSourceNameList = [];
  String categoryValue = "";

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

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
            page: 'videos',
          );
        }));
      } else if (selectedValue == "Crypto") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CryptoAddFilterPage(
            text: selectedValue,
            page: 'videos',
          );
        }));
      } else if (selectedValue == "Commodity") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CommodityAddFilterPage(
            text: selectedValue,
            page: 'videos',
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForexAddFilterPage(
            text: selectedValue,
            page: 'videos',
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

  getVideosValues({required String text, required String? category, required String filterId}) async {
    setState(() {
      loading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getVideosZone);
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
    setState(() {});
    if (responseData["status"]) {
      videosIdList.clear();
      videosExchangeList.clear();
      videosSentimentList.clear();
      videosDescriptionList.clear();
      videosSnippetList.clear();
      videosBookMarkList.clear();
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
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            searchLoader = false;
            emptyBool = true;
            searchValue1 = false;
          });
        } else {
          setState(() {
            emptyBool = false;
          });
          for (int i = 0; i < responseData["response"].length; i++) {
            videosImagesList.add(responseData["response"][i]["image_url"]);
            if (finalisedCategory.toLowerCase() == 'stocks') {
              if (responseData["response"][i]["exchange"] == "NSE" ||
                  responseData["response"][i]["exchange"] == "BSE" ||
                  responseData["response"][i]["exchange"] == "INDX") {
                videosExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
              } else if (responseData["response"][i]["exchange"] == "" || responseData["response"][i]["exchange"] == null) {
                videosExchangeList.add("");
              } else {
                videosExchangeList.add("usastocks");
              }
            } else if (finalisedCategory.toLowerCase() == 'crypto') {
              videosExchangeList.add(
                  responseData["response"][i]["industry"].length == 0 ? "coin" : responseData["response"][i]["industry"][0]['name'].toLowerCase());
            } else if (finalisedCategory.toLowerCase() == 'commodity') {
              videosExchangeList.add(responseData["response"][i]["country"].toLowerCase());
            } else {
              videosExchangeList.add('inrusd');
            }
            videosSentimentList.add((responseData["response"][i]["sentiment"] ?? '').toLowerCase());
            videosDescriptionList.add(responseData["response"][i]["description"] ?? "");
            videosSnippetList.add(responseData["response"][i]["snippet"] ?? "");
            videosBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
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
            readTimestamp(timestamp1);
          }
          setState(() {
            searchLoader = false;
            searchValue1 = false;
          });
        }
      });
    } else {
      videosIdList.clear();
      videosExchangeList.clear();
      videosSentimentList.clear();
      videosDescriptionList.clear();
      videosSnippetList.clear();
      videosBookMarkList.clear();
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
      videosTickerIdList.clear();
      setState(() {
        searchLoader = false;
        searchValue1 = false;
      });
    }
    setState(() {
      loading = true;
      searchValue1 = false;
    });
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
      videosTimeList.add(time);
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
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    getNotifyCountAndImage();
    getAllDataMain(name: 'Videos_Home_Page');
    pageVisitFunc(pageName: 'videos');
    getAllData();
    super.initState();
  }

  getAllData() async {
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
      await getVideosValues(text: "", category: selectedValue, filterId: selectedIdWidget);
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
      await getVideosValues(text: "", category: selectedValue, filterId: selectedIdWidget);
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
                  pageType: 'videos',
                  tickerId: widget.tickerId)
          : debugPrint("nothing");
    }
  }

  @override
  void dispose() {
    extraContainMain.value = false;
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
                : Navigator.pop(context)
            /*Navigator.push(context,
              MaterialPageRoute(builder:
                  (BuildContext context) {
                return ComparePage(
                    text: finalisedCategory);
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
        },
        child: Container(
          color: const Color(0XFFFFFFFF),
          child: SafeArea(
            child: Scaffold(
                // backgroundColor: const Color(0XFFFFFFFF),
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
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      widget.fromCompare
                                          ? widget.homeSearch!
                                              ? Navigator.pop(context)
                                              : Navigator.pop(context)
                                          /*Navigator.push(context,
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
                                Text("Videos",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge /*TextStyle(fontSize: text.scale(26), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),*/
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
                                                      videosImagesList.clear();
                                                      videosExchangeList.clear();
                                                      videosSentimentList.clear();
                                                      videosDescriptionList.clear();
                                                      videosSnippetList.clear();
                                                      videosBookMarkList.clear();
                                                      videosSourceNameList.clear();
                                                      videosTitlesList.clear();
                                                      videosLinkList.clear();
                                                      videosTimeList.clear();
                                                      newsInt = 0;
                                                      selectedValue = value!;
                                                      finalisedCategory = selectedValue;
                                                      prefs.setString('finalisedCategory1', finalisedCategory);
                                                    });
                                                    mainSkipValue ? debugPrint("nothing") : getSelectedValue(value: finalisedCategory);
                                                    await getFil(type: finalisedCategory, filterId: "");
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                    await getVideosValues(
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
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1), borderRadius: BorderRadius.circular(12)),
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
                                  onChanged: (value) async {
                                    setState(() {
                                      searchLoader = true;
                                    });
                                    if (value.isNotEmpty) {
                                      newsInt = 0;
                                      await getFil(type: selectedValue, filterId: selectedIdWidget);
                                      await getVideosValues(text: value, category: selectedValue, filterId: selectedIdWidget);
                                    } else {
                                      newsInt = 0;
                                      await getFil(type: selectedValue, filterId: selectedIdWidget);
                                      await getVideosValues(text: "", category: selectedValue, filterId: selectedIdWidget);
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
                                              await getVideosValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                                              if (!mounted) {
                                                return;
                                              }
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                                          )
                                        : const SizedBox(),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1), borderRadius: BorderRadius.circular(12)),
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
                              ? Column(
                                  children: [
                                    SizedBox(height: height / 50.75),
                                    searchLoader
                                        ? SizedBox(
                                            height: height / 1.45,
                                            child: Column(
                                              children: [
                                                Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                              ],
                                            ),
                                          )
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
                                                height: Platform.isIOS ? height / 1.5 : height / 1.38,
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
                                                      newsInt = newsInt + 20;
                                                    });
                                                    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                    var text = _searchController.text;
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    mainUserId = prefs.getString('newUserId')!;
                                                    mainUserToken = prefs.getString('newUserToken')!;
                                                    var url = Uri.parse(baseurl + versionLocker + getVideosZone);
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
                                                      'ticker_id': widget.tickerId
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
                                                            videosImagesList.add(responseData["response"][i]["image_url"]);
                                                            if (finalisedCategory.toLowerCase() == 'stocks') {
                                                              if (responseData["response"][i]["exchange"] == "NSE" ||
                                                                  responseData["response"][i]["exchange"] == "BSE" ||
                                                                  responseData["response"][i]["exchange"] == "INDX") {
                                                                videosExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
                                                              } else if (responseData["response"][i]["exchange"] == "" ||
                                                                  responseData["response"][i]["exchange"] == null) {
                                                                videosExchangeList.add("");
                                                              } else {
                                                                videosExchangeList.add("usastocks");
                                                              }
                                                            } else if (finalisedCategory.toLowerCase() == 'crypto') {
                                                              videosExchangeList.add(responseData["response"][i]["industry"].length == 0
                                                                  ? "coin"
                                                                  : responseData["response"][i]["industry"][0]['name'].toLowerCase());
                                                            } else if (finalisedCategory.toLowerCase() == 'commodity') {
                                                              videosExchangeList.add(responseData["response"][i]["country"].toLowerCase());
                                                            } else {
                                                              videosExchangeList.add('inrusd');
                                                            }
                                                            videosSentimentList.add((responseData["response"][i]["sentiment"] ?? '').toLowerCase());
                                                            videosDescriptionList.add(responseData["response"][i]["description"] ?? "");
                                                            videosSnippetList.add(responseData["response"][i]["snippet"] ?? "");
                                                            videosBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
                                                            videosTitlesList.add(responseData["response"][i]["title"]);
                                                            videosSourceNameList.add(responseData["response"][i]["source_name"]);
                                                            videosLinkList.add(responseData["response"][i]["news_url"]);
                                                            videosIdList.add(responseData["response"][i]["_id"]);
                                                            videosTickerIdList.add(responseData["response"][i]["ticker_id"]);
                                                            videosLikeList.add(responseData["response"][i]["likes_count"]);
                                                            videosDislikeList.add(responseData["response"][i]["dis_likes_count"]);
                                                            videosUseList.add(responseData["response"][i]["likes"]);
                                                            videosUseDisList.add(responseData["response"][i]["dislikes"]);
                                                            videosViewList.add(responseData["response"][i]["views_count"]);
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
                                                      itemCount: videosImagesList.length,
                                                      itemBuilder: (context, index) {
                                                        return Column(
                                                          children: [
                                                            Container(
                                                              height: height / 3.23,
                                                              margin: const EdgeInsets.symmetric(horizontal: 5),
                                                              child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return YoutubePlayerLandscapeScreen(
                                                                                id: videosIdList[index], comeFrom: 'videosPage')
                                                                            /*VideoDescriptionPage(
                                                            id: videosIdList[index],idList: videosIdList,
                                                          )*/
                                                                            ;
                                                                      }));
                                                                      if (response) {
                                                                        initState();
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
                                                                                  spreadRadius: 0,
                                                                                  blurRadius: 4,
                                                                                  color: Theme.of(context).colorScheme.tertiary)
                                                                            ],
                                                                            image: DecorationImage(
                                                                              image: NetworkImage(videosImagesList[index]),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                            color: Theme.of(context).colorScheme.background,
                                                                            borderRadius: const BorderRadius.only(
                                                                                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: Colors.black12.withOpacity(0.3),
                                                                                  ),
                                                                                  child: const Center(
                                                                                      child: Icon(
                                                                                    Icons.play_arrow,
                                                                                    color: Colors.white,
                                                                                  )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5,
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
                                                                                    fontSize: text.scale(14),
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: "Poppins"),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                                                  context: context,
                                                                                  text: videosSentimentList[index],
                                                                                ),
                                                                                excLabelButton(text: videosExchangeList[index], context: context)
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: height / 10.02,
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
                                                                                  videosSourceNameList[index].toString().capitalizeFirst!,
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(12),
                                                                                      color: const Color(0XFFF7931A),
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: "Poppins"),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      videosTimeList[index],
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          color: const Color(0XFFB0B0B0),
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 3,
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
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
                                                                                          haveDisLikesMain =
                                                                                              videosDislikeList[index] > 0 ? true : false;
                                                                                          haveViewsMain = videosViewList[index] > 0 ? true : false;
                                                                                          likesCountMain = videosLikeList[index];
                                                                                          dislikesCountMain = videosDislikeList[index];
                                                                                          viewCountMain = videosViewList[index];
                                                                                          kToken = mainUserToken;
                                                                                        });
                                                                                        //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionLocker + videoViewCount, idKey: 'video_id', setState: setState);
                                                                                        bool data = await likeCountFunc(
                                                                                            context: context, newSetState: setState);
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
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w900,
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
                                                                            width: width / 2.6,
                                                                            child: Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                    onTap: () async {
                                                                                      bool response1 =
                                                                                          await likeFunction(id: videosIdList[index], type: "videos");
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
                                                                                    )),
                                                                                SizedBox(width: width / 20),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    bool response3 = await disLikeFunction(
                                                                                        id: videosIdList[index], type: "videos");
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
                                                                                    bookMark: videosBookMarkList,
                                                                                    context: context,
                                                                                    scale: 3.2,
                                                                                    id: videosIdList[index],
                                                                                    type: 'videos',
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
                              : Obx(() => extraContainMain.value
                                  ? Stack(
                                      children: [
                                        Column(
                                          children: [
                                            /*Container(
                                            height: _height / 19.33,
                                            child: TextFormField(
                                              readOnly: true,
                                              enabled: false,
                                              style: TextStyle(fontSize: _text * 15, fontFamily: "Poppins"),
                                              controller: _searchController,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                fillColor: Color(0XFFF9F9F9),
                                                filled: true,
                                                contentPadding: EdgeInsets.only(left: 15),
                                                prefixIcon: Padding(padding: const EdgeInsets.all(10.0),
                                                    child: SvgPicture.asset(
                                                        "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
                                                suffixIcon: _searchController.text.isNotEmpty?GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _searchController.clear();
                                                    });
                                                  }, child:Icon(Icons.cancel,size: 22,color:Colors.black),
                                                ):SizedBox(),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Color(0xffD8D8D8),
                                                        width: 0.5),
                                                    borderRadius: BorderRadius.circular(20)),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD8D8D8),
                                                      width: 0.5),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD8D8D8),
                                                      width: 0.5),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Color(0XFFA5A5A5),
                                                    fontSize: _text * 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Poppins"),
                                                hintText: 'Search here',
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD8D8D8),
                                                      width: 0.5),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ),*/
                                            SizedBox(height: height / 69),
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
                                                    height: Platform.isIOS ? height / 1.5 : height / 1.38,
                                                    child: ListView.builder(
                                                        physics: const ScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: videosImagesList.length,
                                                        itemBuilder: (context, index) {
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
                                                                              image: NetworkImage(videosImagesList[index]),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                            color: Theme.of(context).colorScheme.background,
                                                                            borderRadius: const BorderRadius.only(
                                                                                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: Colors.black12.withOpacity(0.3),
                                                                                  ),
                                                                                  child: const Center(
                                                                                      child: Icon(
                                                                                    Icons.play_arrow,
                                                                                    color: Colors.white,
                                                                                  )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5,
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
                                                                                    fontSize: text.scale(14),
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: "Poppins"),
                                                                              ),
                                                                            ),
                                                                          ],
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
                                                                                sentimentButton(context: context, text: videosSentimentList[index]),
                                                                                excLabelButton(text: videosExchangeList[index], context: context)
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      height: height / 10.02,
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
                                                                                    videosSourceNameList[index].toString().capitalizeFirst!,
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(12),
                                                                                        color: const Color(0XFFF7931A),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontFamily: "Poppins"),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        videosTimeList[index],
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontFamily: "Poppins"),
                                                                                      ),
                                                                                      /* SizedBox(
                                                                                      width: 3,
                                                                                    ),
                                                                                    Text(
                                                                                      "${videosLikeList[index]} Likes",
                                                                                      style: TextStyle(
                                                                                          fontSize: _text*10,
                                                                                          color: Color(0XFFB0B0B0),
                                                                                          fontWeight:FontWeight.w900,
                                                                                          fontFamily:"Poppins"),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 3,
                                                                                    ),
                                                                                    Text(
                                                                                      "${videosDislikeList[index]} Dislikes",
                                                                                      style: TextStyle(
                                                                                          fontSize: _text*10,
                                                                                          color: Color(0XFFB0B0B0),
                                                                                          fontWeight: FontWeight.w900,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),*/
                                                                                      const SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Text(
                                                                                        "${videosViewList[index]} Views",
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10),
                                                                                            color: const Color(0XFFB0B0B0),
                                                                                            fontWeight: FontWeight.w900,
                                                                                            fontFamily: "Poppins"),
                                                                                      ),
                                                                                    ],
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
                                                                                      onTap: () {},
                                                                                      child: Container(
                                                                                        child: videosUseList[index]
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
                                                                                      onTap: () {},
                                                                                      child: SvgPicture.asset(
                                                                                        isDarkTheme.value
                                                                                            ? "assets/home_screen/share_dark.svg"
                                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                      )),
                                                                                  SizedBox(width: width / 20),
                                                                                  GestureDetector(
                                                                                    onTap: () {},
                                                                                    child: videosUseDisList[index]
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
                                                                                      bookMark: videosBookMarkList,
                                                                                      context: context,
                                                                                      scale: 3.2,
                                                                                      enabled: false,
                                                                                      id: videosIdList[index],
                                                                                      type: 'videos',
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
                                          right: 15,
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
                                                            videosImagesList.clear();
                                                            videosExchangeList.clear();
                                                            videosSentimentList.clear();
                                                            videosDescriptionList.clear();
                                                            videosSnippetList.clear();
                                                            videosBookMarkList.clear();
                                                            videosSourceNameList.clear();
                                                            videosTitlesList.clear();
                                                            videosLinkList.clear();
                                                            videosTimeList.clear();
                                                            newsInt = 0;
                                                            extraContainMain.value = false;
                                                            selectedWidget = enteredFilteredList[index];
                                                            finalisedFilterName = enteredFilteredList[index];
                                                            filterBool = true;
                                                            filterId = enteredFilteredIdList[index];
                                                            finalisedFilterId = enteredFilteredIdList[index];
                                                            selectedIdWidget = filterId;
                                                            prefs.setString('finalisedFilterId1', finalisedFilterId);
                                                            prefs.setString('finalisedFilterName1', finalisedFilterName);
                                                          });
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                          await getFil(type: finalisedCategory, filterId: finalisedFilterId);
                                                          await getVideosValues(
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
                                                                          page: 'videos',
                                                                        );
                                                                      }));
                                                                    } else if (selectedValue == "Crypto") {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return CryptoEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'videos',
                                                                        );
                                                                      }));
                                                                    } else if (selectedValue == "Commodity") {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return CommodityEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'videos',
                                                                        );
                                                                      }));
                                                                    } else {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return ForexEditFilterPage(
                                                                          text: selectedValue,
                                                                          filterId: enteredFilteredIdList[index],
                                                                          response: response,
                                                                          page: 'videos',
                                                                        );
                                                                      }));
                                                                    }
                                                                  },
                                                                  icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
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
                                                                    await getVideosValues(
                                                                        category: selectedValue,
                                                                        filterId: finalisedFilterId,
                                                                        text: _searchController.text.isEmpty ? "" : _searchController.text);
                                                                  },
                                                                  icon: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/x-circle.png"),
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
                                                            commonFlushBar(context: context, initFunction: initState);
                                                          } else {
                                                            navigationPage1();
                                                          }
                                                        },
                                                        title: const Text(
                                                          "Add a New List",
                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                        ),
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
                                        )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: height / 69),
                                        searchLoader
                                            ? SizedBox(
                                                height: height / 1.45,
                                                child: Column(
                                                  children: [
                                                    Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                                  ],
                                                ),
                                              )
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
                                                    height: Platform.isIOS ? height / 1.5 : height / 1.38,
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
                                                          newsInt = newsInt + 20;
                                                        });
                                                        context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                                        var text = _searchController.text;
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        mainUserId = prefs.getString('newUserId') ?? "";
                                                        mainUserToken = prefs.getString('newUserToken') ?? "";
                                                        var url = Uri.parse(baseurl + versionLocker + getVideosZone);
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
                                                                videosViewList.add(responseData["response"][i]["views_count"]);
                                                                videosImagesList.add(responseData["response"][i]["image_url"]);
                                                                if (finalisedCategory.toLowerCase() == 'stocks') {
                                                                  if (responseData["response"][i]["exchange"] == "NSE" ||
                                                                      responseData["response"][i]["exchange"] == "BSE" ||
                                                                      responseData["response"][i]["exchange"] == "INDX") {
                                                                    videosExchangeList.add(responseData["response"][i]["exchange"].toLowerCase());
                                                                  } else if (responseData["response"][i]["exchange"] == "" ||
                                                                      responseData["response"][i]["exchange"] == null) {
                                                                    videosExchangeList.add("");
                                                                  } else {
                                                                    videosExchangeList.add("usastocks");
                                                                  }
                                                                } else if (finalisedCategory.toLowerCase() == 'crypto') {
                                                                  videosExchangeList.add(responseData["response"][i]["industry"].length == 0
                                                                      ? "coin"
                                                                      : responseData["response"][i]["industry"][0]['name'].toLowerCase());
                                                                } else if (finalisedCategory.toLowerCase() == 'commodity') {
                                                                  videosExchangeList.add(responseData["response"][i]["country"].toLowerCase());
                                                                } else {
                                                                  videosExchangeList.add('inrusd');
                                                                }
                                                                videosSentimentList
                                                                    .add((responseData["response"][i]["sentiment"] ?? '').toLowerCase());
                                                                videosDescriptionList.add(responseData["response"][i]["description"] ?? "");
                                                                videosSnippetList.add(responseData["response"][i]["snippet"] ?? "");
                                                                videosBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
                                                                videosTitlesList.add(responseData["response"][i]["title"]);
                                                                videosSourceNameList.add(responseData["response"][i]["source_name"]);
                                                                videosLinkList.add(responseData["response"][i]["news_url"]);
                                                                videosIdList.add(responseData["response"][i]["_id"]);
                                                                videosTickerIdList.add(responseData["response"][i]["ticker_id"]);
                                                                videosLikeList.add(responseData["response"][i]["likes_count"]);
                                                                videosDislikeList.add(responseData["response"][i]["dis_likes_count"]);
                                                                videosUseList.add(responseData["response"][i]["likes"]);
                                                                videosUseDisList.add(responseData["response"][i]["dislikes"]);
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
                                                          itemCount: videosImagesList.length,
                                                          itemBuilder: (context, index) {
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  height: height / 3.23,
                                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                  child: Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return YoutubePlayerLandscapeScreen(
                                                                              id: videosIdList[index],
                                                                              comeFrom: 'videosPage',
                                                                            ) /*VideoDescriptionPage(
                                                                            id: videosIdList[index], idList: videosIdList,
                                                                          )*/
                                                                                ;
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
                                                                                      color: Theme.of(context).colorScheme.tertiary)
                                                                                ],
                                                                                image: DecorationImage(
                                                                                  image: NetworkImage(videosImagesList[index]),
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                                color: Theme.of(context).colorScheme.background,
                                                                                borderRadius: const BorderRadius.only(
                                                                                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Colors.black12.withOpacity(0.3),
                                                                                      ),
                                                                                      child: const Center(
                                                                                          child: Icon(
                                                                                        Icons.play_arrow,
                                                                                        color: Colors.white,
                                                                                      )),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
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
                                                                                        fontSize: text.scale(14),
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontFamily: "Poppins"),
                                                                                  ),
                                                                                ),
                                                                              ],
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
                                                                                    sentimentButton(
                                                                                        context: context, text: videosSentimentList[index]),
                                                                                    excLabelButton(text: videosExchangeList[index], context: context)
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: height / 10.02,
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
                                                                                      videosSourceNameList[index].toString().capitalizeFirst!,
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(12),
                                                                                          color: const Color(0XFFF7931A),
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontFamily: "Poppins"),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          videosTimeList[index],
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              color: const Color(0XFFB0B0B0),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontFamily: "Poppins"),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 3,
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: mainSkipValue
                                                                                              ? () {
                                                                                                  commonFlushBar(
                                                                                                      context: context, initFunction: initState);
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
                                                                                                    apiMain =
                                                                                                        baseurl + versionLocker + videoViewCount;
                                                                                                    onTapIdMain = videosIdList[index];
                                                                                                    onTapTypeMain = "Views";
                                                                                                    haveLikesMain =
                                                                                                        videosLikeList[index] > 0 ? true : false;
                                                                                                    haveDisLikesMain =
                                                                                                        videosDislikeList[index] > 0 ? true : false;
                                                                                                    haveViewsMain =
                                                                                                        videosViewList[index] > 0 ? true : false;
                                                                                                    likesCountMain = videosLikeList[index];
                                                                                                    dislikesCountMain = videosDislikeList[index];
                                                                                                    viewCountMain = videosViewList[index];
                                                                                                    kToken = mainUserToken;
                                                                                                  });
                                                                                                  //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionLocker + videoViewCount, idKey: 'video_id', setState: setState);
                                                                                                  bool data = await likeCountFunc(
                                                                                                      context: context, newSetState: setState);
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
                                                                                                fontSize: text.scale(10),
                                                                                                color: const Color(0XFFB0B0B0),
                                                                                                fontWeight: FontWeight.w900,
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
                                                                                width: width / 2.6,
                                                                                child: Row(
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                        onTap: mainSkipValue
                                                                                            ? () {
                                                                                                commonFlushBar(
                                                                                                    context: context, initFunction: initState);
                                                                                              }
                                                                                            : () async {
                                                                                                bool response1 = await likeFunction(
                                                                                                    id: videosIdList[index], type: "videos");
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
                                                                                          logEventFunc(name: "Share", type: "Videos");
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
                                                                                            await shareFunction(
                                                                                                id: videosIdList[index], type: "videos");
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
                                                                                                  context: context, initFunction: initState);
                                                                                            }
                                                                                          : () async {
                                                                                              bool response3 = await disLikeFunction(
                                                                                                  id: videosIdList[index], type: "videos");
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
                                                                                      bookMark: videosBookMarkList,
                                                                                      context: context,
                                                                                      scale: 3.2,
                                                                                      id: videosIdList[index],
                                                                                      type: 'videos',
                                                                                      modelSetState: setState,
                                                                                      index: index,
                                                                                      initFunction: getAllData,
                                                                                      notUse: false,
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
                                    ))
                          : Expanded(
                              child: Center(
                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                              ),
                            ),
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
                  itemCount: videoLikedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(uId: videoLikedIdList[index], uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(videoLikedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            videoLikedSourceNameList[index].toString().capitalizeFirst!,
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
                  itemCount: videoViewedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(uId: videoViewedIdList[index], uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(videoViewedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            videoViewedSourceNameList[index].toString().capitalizeFirst!,
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
