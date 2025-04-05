import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';

import 'analytics_page.dart';
import 'questionnaire_page.dart';
import 'survey_post_page.dart';

class DetailedSurveyImagePage extends StatefulWidget {
  final String text;
  final String filterId;
  final String topic;
  final List catIdList;
  final bool fromCompare;
  final dynamic surveyDetail;
  final String tickerId;
  final String tickerName;
  final bool? homeSearch;

  const DetailedSurveyImagePage(
      {Key? key,
      required this.text,
      required this.surveyDetail,
      required this.filterId,
      required this.catIdList,
      required this.topic,
      required this.tickerId,
      required this.tickerName,
      this.homeSearch,
      required this.fromCompare})
      : super(key: key);

  @override
  State<DetailedSurveyImagePage> createState() => _DetailedSurveyImagePageState();
}

class _DetailedSurveyImagePageState extends State<DetailedSurveyImagePage> {
  bool searchLoader = false;
  bool searchValue1 = false;
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _controller = TextEditingController();
  String mainUserId = "";
  String mainUserToken = "";
  List surveyImagesList = [];
  List<bool> surveyBookMarkList = [];
  List surveySourceNameList = [];
  List<String> surveyTitlesList = [];
  List<bool> surveyTranslationList = [];
  List<String> surveyCategoryList = [];
  int newsInt = 0;
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool filterBool = false;
  String userNameThanks = "";
  String userAvatarThanks = "";
  String filterId = "";
  String mainTopic = "";
  bool dropDownSelection = false;
  bool emptyBool = false;
  bool sayThanks = false;
  int respondedCount = 0;
  List<dynamic> postIds = [];
  List<String> surveyIdList = [];
  List<int> surveyViewsList = [];
  List<int> surveyResponseList = [];
  List<int> surveyQuestionsList = [];
  List<String> surveyUserIdList = [];
  List<dynamic> surveyObjectList = [];
  List<bool> surveyMyList = [];
  late Uri newLink;
  bool loading = false;
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String whyValue = "Scam";
  String activeStatus = "";
  bool answerStatus = false;
  int answeredQuestion = 0;
  List<String> surveyViewedImagesList = [];
  List<String> surveyViewedIdList = [];
  List<String> surveyViewedSourceNameList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  @override
  void initState() {
    widget.topic == "My Poll" ? getThanksFunc() : debugPrint("Nothing to do");
    getNotifyCountAndImage();
    getAllData();
    getAllDataMain(name: 'Survey_Categories_Page(${widget.topic})');
    super.initState();
  }

  getAllData() async {
    await getSurveyValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
    if (!mounted) {
      return;
    }
    widget.fromCompare
        ? lockerFilterResponse
            ? debugPrint("Filters Found")
            : filtersAlertDialogue(
                selectedValue: widget.text,
                cIdList: widget.catIdList,
                title: filterAlertTitle,
                context: context,
                pageType: 'survey',
                tickerId: widget.tickerId)
        : debugPrint("alertFalse");
  }

  getThanksFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + checkNotification);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'type': "survey"});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      setState(() {
        sayThanks = responseData["response"];
        postIds = responseData["post_ids"];
        respondedCount = responseData["count"];
      });
    }
  }

  sendThanksFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    //   var url = Uri.parse(baseurl + versions + sendNotification);
    var url = baseurl + versions + sendNotification;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ),
        data: {'type': "survey", 'post_ids': postIds});
    //var responseData = json.decode(response.body);
    if (response.data["status"]) {}
  }

  reportPost(
      {required String action, required String why, required String description, required String surveyId, required String surveyUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!mounted) {
          return;
        }
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versionSurvey + surveyAddReport);
        var responseNew = await http.post(url,
            body: {"action": action, "why": why, "description": description, "survey_id": surveyId, "survey_user": surveyUserId},
            headers: {'Authorization': mainUserToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          getSurveyValues(text: "", category: widget.text, filterId: filterId, topic: widget.topic);
        } else {
          if (!mounted) {
            return;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      var url = Uri.parse(baseurl + versionSurvey + surveyAddReport);
      var responseNew = await http.post(url,
          body: {"action": action, "why": why, "description": description, "survey_id": surveyId, "survey_user": surveyUserId},
          headers: {'Authorization': mainUserToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        getSurveyValues(text: "", category: widget.text, filterId: filterId, topic: widget.topic);
      } else {
        if (!mounted) {
          return;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  getSurveyValues({required String text, required String? category, required String filterId, required String topic}) async {
    surveyImagesList.clear();
    surveyBookMarkList.clear();
    surveySourceNameList.clear();
    surveyTitlesList.clear();
    surveyTranslationList.clear();
    surveyCategoryList.clear();
    surveyIdList.clear();
    surveyMyList.clear();
    surveyViewsList.clear();
    surveyResponseList.clear();
    surveyUserIdList.clear();
    surveyObjectList.clear();
    surveyQuestionsList.clear();
    nativeAdList.clear();
    nativeAdIsLoadedList.clear();
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: widget.fromCompare
            ? {
                'category': category!.toLowerCase(),
                'search': text.isEmpty ? "" : text,
                'skip': '0',
                'type': "",
                'ticker_id': widget.tickerId.isEmpty ? "" : widget.tickerId
              }
            : {
                'category': category!.toLowerCase(),
                'search': text.isEmpty ? "" : text,
                'filter_id': filterId.isEmpty ? "" : filterId,
                'type': topic,
                'skip': "0"
              });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
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
                  ad.dispose();
                },
                onAdOpened: (Ad ad) {},
                onAdClosed: (Ad ad) {},
              ),
            )..load());
            surveyImagesList.add(responseData["response"][i]["user"]["avatar"]);
            surveyTitlesList.add(responseData["response"][i]["title"]);
            surveyTranslationList.add(false);
            surveyBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
            surveyObjectList.add(responseData["response"][i]);
            surveySourceNameList.add(responseData["response"][i]["user"]["username"]);
            surveyCategoryList.add(responseData["response"][i]["company_name"]);
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

  _onSurveyLoading() async {
    setState(() {
      newsInt = newsInt + 20;
    });
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: widget.fromCompare
            ? {
                'category': widget.text == "Stocks"
                    ? "stocks"
                    : widget.text == "Crypto"
                        ? "crypto"
                        : widget.text == "Commodity"
                            ? "commodity"
                            : widget.text == "Forex"
                                ? "forex"
                                : "nothing",
                'search': _searchController.text.isEmpty ? "" : _searchController.text,
                'skip': '0',
                'type': "",
                'ticker_id': widget.tickerId.isEmpty ? "" : widget.tickerId
              }
            : {
                'category': widget.text.toLowerCase(),
                'search': _searchController.text.isEmpty ? "" : _searchController.text,
                'filter_id': filterId.isEmpty ? "" : filterId,
                'type': widget.topic,
                'skip': newsInt.toString(),
              });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainTopic = responseData["type"];
      setState(() {
        if (responseData["response"].length == 0) {
          setState(() {
            //emptyBool=true;
            searchLoader = false;
            searchValue1 = false;
          });
        } else {
          setState(() {});
          for (int i = 0; i < responseData["response"].length; i++) {
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
            surveyImagesList.add(responseData["response"][i]["user"]["avatar"]);
            surveyTitlesList.add(responseData["response"][i]["title"]);
            surveyTranslationList.add(false);
            surveyBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
            surveyObjectList.add(responseData["response"][i]);
            surveySourceNameList.add(responseData["response"][i]["user"]["username"]);
            surveyCategoryList.add(responseData["response"][i]["company_name"]);
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

  deletePost({required String surveyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + deleteSurvey);
    var responseNew = await http.post(url, body: {"survey_id": surveyId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      getSurveyValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  statusFunc({required String surveyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    // context.read<BookMarkWidgetBloc>().add(LoadingEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      // color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: sayThanks
            ? widget.topic == "My Poll"
                ? Scaffold(
                    backgroundColor: const Color(0XFF48B83F),
                    body: Center(
                      child: Column(
                        children: [
                          SizedBox(height: height / 11.94),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    sayThanks = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: height / 2.15, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Ornament.png", fit: BoxFit.fill)),
                          const Text(
                            'Say "Thank You"',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${respondedCount.toString()} users supported you by responding on your post in last 2 weeks, send them a "thank you" for their contribution and support.',
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: height / 20.3),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sayThanks = false;
                              });
                              sendThanksFunc();
                            },
                            child: Center(
                              child: Container(
                                height: height / 20.3,
                                width: width / 3.02,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                                child: const Center(
                                    child: Text(
                                  'send',
                                  style: TextStyle(color: Color(0xff0EA102), fontSize: 14, fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Scaffold(
                    // backgroundColor: const Color(0XFFFFFFFF),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    appBar: AppBar(
                      //backgroundColor: const Color(0XFFFFFFFF),
                      backgroundColor: Theme.of(context).colorScheme.background,
                      toolbarHeight: height / 8.63,
                      automaticallyImplyLeading: false,
                      title: Column(
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
                                    Text(
                                      "Survey",
                                      style: TextStyle(
                                          fontSize: text.scale(26), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
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
                        ],
                      ),
                      elevation: 0.0,
                    ),
                    body: loading
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        widget.homeSearch != null
                                            ? Navigator.pop(context)
                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return SurveyPage(text: widget.text);
                                              }));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: width / 23.43),
                                        child: const Icon(Icons.arrow_back),
                                      )),
                                  SizedBox(
                                    width: width / 31.25,
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
                                          child: Text(
                                            widget.tickerName,
                                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                          ))
                                      : Text(
                                          mainTopic,
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                        )
                                ],
                              ),
                              SizedBox(
                                height: height / 49.21,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                height: height / 19.33,
                                child: TextFormField(
                                  onSaved: (value) {},
                                  textInputAction: TextInputAction.search,
                                  onChanged: (value) async {
                                    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                    setState(() {
                                      searchLoader = true;
                                    });
                                    if (value.isNotEmpty) {
                                      newsInt = 0;
                                      await getSurveyValues(text: value, category: widget.text, filterId: widget.filterId, topic: widget.topic);
                                    } else {
                                      newsInt = 0;
                                      await getSurveyValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
                                    }
                                  },
                                  style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                  controller: _searchController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    fillColor: const Color(0XFFF9F9F9),
                                    filled: true,
                                    prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                              setState(() {
                                                _searchController.clear();
                                              });
                                              getSurveyValues(
                                                  text: "", category: finalisedCategory, filterId: finalisedFilterId, topic: widget.topic);
                                            },
                                            child: const Icon(Icons.cancel, size: 22, color: Colors.black),
                                          )
                                        : const SizedBox(),
                                    contentPadding: const EdgeInsets.only(left: 15),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintStyle: TextStyle(
                                        color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                    hintText: 'Search here',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height / 58),
                              searchLoader
                                  ? SizedBox(
                                      height: height / 1.45,
                                      child: Column(
                                        children: [
                                          Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                        ],
                                      ))
                                  : NotificationListener<OverscrollIndicatorNotification>(
                                      onNotification: (overflow) {
                                        overflow.disallowIndicator();
                                        return true;
                                      },
                                      child: emptyBool
                                          ? mainTopic == "My Questions"
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                  height: height / 1.5,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                            height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                        RichText(
                                                          textAlign: TextAlign.justify,
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                  text:
                                                                      'Looks like you have not created any content yet, Do you want to add one now? ',
                                                                  style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)),
                                                              TextSpan(
                                                                  text: ' Add here',
                                                                  style: const TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      color: Color(0XFF0EA102),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12),
                                                                  recognizer: TapGestureRecognizer()
                                                                    ..onTap = () async {
                                                                      bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return SurveyPostPage(text: widget.text);
                                                                      }));
                                                                      if (response) {
                                                                        await getSurveyValues(
                                                                            text: "",
                                                                            category: widget.text,
                                                                            filterId: widget.filterId,
                                                                            topic: widget.topic);
                                                                      }
                                                                    }),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : mainTopic == "My Answers"
                                                  ? Container(
                                                      margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                      height: height / 1.5,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                              height: 150,
                                                              width: 150,
                                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                                          RichText(
                                                            textAlign: TextAlign.justify,
                                                            text: const TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        'Unfortunately, you have not added any response yet. Do you want to help others by answering a few questions? ',
                                                                    style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50.75,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: const Color(0XFF0EA102),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                ),
                                                                onPressed: () {
                                                                  getSurveyValues(
                                                                      text: "",
                                                                      category: widget.text,
                                                                      filterId: widget.filterId,
                                                                      topic: "Unanswered");
                                                                },
                                                                child: const Text(
                                                                  "Yes",
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontFamily: "Poppins",
                                                                      fontSize: 12),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: height / 5,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                              height: 150,
                                                              width: 150,
                                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                    text:
                                                                        '😟 Looks like there is no Survey created under this topic, Would you like to a add ',
                                                                    style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 10)),
                                                                TextSpan(
                                                                    text: ' Add here',
                                                                    style: const TextStyle(
                                                                        color: Color(0XFF0EA102), fontWeight: FontWeight.w700, fontSize: 12),
                                                                    recognizer: TapGestureRecognizer()
                                                                      ..onTap = () async {
                                                                        bool response = await Navigator.push(context,
                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                          return SurveyPostPage(text: widget.text);
                                                                        }));
                                                                        if (response) {
                                                                          await getSurveyValues(
                                                                              text: "",
                                                                              category: widget.text,
                                                                              filterId: widget.filterId,
                                                                              topic: widget.topic);
                                                                        }
                                                                      }),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                          : Container(
                                              height: height / 1.45,
                                              margin: EdgeInsets.symmetric(horizontal: width / 23.43),
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
                                                onLoading: _onSurveyLoading,
                                                child: ListView.builder(
                                                  itemCount: surveyTitlesList.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                      return Column(
                                                        children: [
                                                          Container(
                                                              height: height / 9.10,
                                                              margin: const EdgeInsets.symmetric(horizontal: 15),
                                                              child: AdWidget(ad: nativeAdList[index])),
                                                          SizedBox(height: height / 57.73),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                await statusFunc(surveyId: surveyIdList[index]);
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                surveyMyList[index]
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: surveyIdList[index],
                                                                          activity: true,
                                                                          surveyTitle: surveyTitlesList[index],
                                                                        );
                                                                      }))
                                                                    : activeStatus == 'active'
                                                                        ? answerStatus
                                                                            ? Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                    surveyId: surveyIdList[index],
                                                                                    activity: true,
                                                                                    surveyTitle: surveyTitlesList[index]);
                                                                              }))
                                                                            : Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return QuestionnairePage(
                                                                                  surveyId: surveyIdList[index],
                                                                                  defaultIndex: answeredQuestion,
                                                                                );
                                                                              }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: surveyIdList[index],
                                                                                activity: true,
                                                                                surveyTitle: surveyTitlesList[index]);
                                                                          }));
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.only(bottom: height / 35),
                                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.grey.withOpacity(0.1),
                                                                          offset: const Offset(0, 2),
                                                                          blurRadius: 1,
                                                                          spreadRadius: 1)
                                                                    ]),
                                                                child: Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Container(
                                                                      color: Colors.white,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                height: height / 13.53,
                                                                                width: width / 5.95,
                                                                                margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                                decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: Colors.grey,
                                                                                    image: DecorationImage(
                                                                                        image: NetworkImage(surveyImagesList[index]),
                                                                                        fit: BoxFit.fill)),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                      width: width / 1.95,
                                                                                      child: Text(
                                                                                        surveyTitlesList[index],
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                      )),
                                                                                  SizedBox(
                                                                                    height: height / 56,
                                                                                  ),
                                                                                  SizedBox(
                                                                                      height: height / 54.13,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            surveySourceNameList[index].toString().capitalizeFirst!,
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            width: 5,
                                                                                          ),
                                                                                          Container(
                                                                                            height: 5,
                                                                                            width: 5,
                                                                                            decoration: const BoxDecoration(
                                                                                                shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            width: 5,
                                                                                          ),
                                                                                          Text(
                                                                                            surveyQuestionsList[index].toString(),
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                          Text(
                                                                                            " Questions",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                        ],
                                                                                      )),
                                                                                  SizedBox(
                                                                                    height: height / 56,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            width: width / 7.5,
                                                                                            child: Text(surveyCategoryList[index],
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.blue))),
                                                                                        /*Container(
                                                                  height:_height/162,width: _width/75,decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xffC4C4C4),)),*/
                                                                                        SizedBox(width: width / 22.05),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(surveyViewsList[index].toString(),
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700)),
                                                                                            Text(" Views",
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w500)),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(width: width / 22.05),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(surveyResponseList[index].toString(),
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w700)),
                                                                                            Text(" Responses",
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    fontWeight: FontWeight.w500)),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                  padding: EdgeInsets.only(right: width / 23.4375),
                                                                                  child: const Icon(
                                                                                    Icons.more_horiz,
                                                                                    size: 20,
                                                                                  )),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: width / 35, top: 10),
                                                                                child: widgetsMain.translationWidget(
                                                                                    translationList: surveyTranslationList,
                                                                                    id: surveyIdList[index],
                                                                                    type: 'survey',
                                                                                    index: index,
                                                                                    initFunction: getAllData,
                                                                                    context: context,
                                                                                    modelSetState: setState,
                                                                                    notUse: false,
                                                                                    titleList: surveyTitlesList),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: width / 23.4375, top: 10),
                                                                                child: bookMarkWidget(
                                                                                    bookMark: surveyBookMarkList,
                                                                                    context: context,
                                                                                    scale: 3.2,
                                                                                    id: surveyIdList[index],
                                                                                    type: 'survey',
                                                                                    modelSetState: setState,
                                                                                    index: index,
                                                                                    initFunction: getAllData,
                                                                                    notUse: false),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                        ],
                                                      );
                                                    }
                                                    return GestureDetector(
                                                        onTap: () async {
                                                          await statusFunc(surveyId: surveyIdList[index]);
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          surveyMyList[index]
                                                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return AnalyticsPage(
                                                                    surveyId: surveyIdList[index],
                                                                    activity: true,
                                                                    surveyTitle: surveyTitlesList[index],
                                                                  );
                                                                }))
                                                              : activeStatus == 'active'
                                                                  ? answerStatus
                                                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return AnalyticsPage(
                                                                              surveyId: surveyIdList[index],
                                                                              activity: true,
                                                                              surveyTitle: surveyTitlesList[index]);
                                                                        }))
                                                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return QuestionnairePage(
                                                                            surveyId: surveyIdList[index],
                                                                            defaultIndex: answeredQuestion,
                                                                          );
                                                                        }))
                                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                          surveyId: surveyIdList[index],
                                                                          activity: true,
                                                                          surveyTitle: surveyTitlesList[index]);
                                                                    }));
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(bottom: height / 35),
                                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.1),
                                                                    offset: const Offset(0, 2),
                                                                    blurRadius: 1,
                                                                    spreadRadius: 1)
                                                              ]),
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                color: Colors.white,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: height / 13.53,
                                                                          width: width / 5.95,
                                                                          margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.grey,
                                                                              image: DecorationImage(
                                                                                  image: NetworkImage(surveyImagesList[index]), fit: BoxFit.fill)),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                                width: width / 1.95,
                                                                                child: Text(
                                                                                  surveyTitlesList[index],
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                )),
                                                                            SizedBox(
                                                                              height: height / 56,
                                                                            ),
                                                                            SizedBox(
                                                                                height: height / 54.13,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      surveySourceNameList[index].toString().capitalizeFirst!,
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 5,
                                                                                      width: 5,
                                                                                      decoration: const BoxDecoration(
                                                                                          shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      surveyQuestionsList[index].toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    Text(
                                                                                      " Questions",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                            SizedBox(
                                                                              height: height / 56,
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 54.13,
                                                                              child: Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                      width: width / 7.5,
                                                                                      child: Text(surveyCategoryList[index],
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10),
                                                                                              fontWeight: FontWeight.w700,
                                                                                              color: Colors.blue))),
                                                                                  /*Container(
                                                                  height:_height/162,width: _width/75,decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xffC4C4C4),)),*/
                                                                                  SizedBox(width: width / 22.05),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(surveyViewsList[index].toString(),
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                      Text(" Views",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: width / 22.05),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(surveyResponseList[index].toString(),
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                      Text(" Responses",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                            padding: EdgeInsets.only(right: width / 23.4375),
                                                                            child: const Icon(
                                                                              Icons.more_horiz,
                                                                              size: 20,
                                                                            )),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(right: width / 35, top: 10),
                                                                          child: widgetsMain.translationWidget(
                                                                              translationList: surveyTranslationList,
                                                                              id: surveyIdList[index],
                                                                              type: 'survey',
                                                                              index: index,
                                                                              initFunction: getAllData,
                                                                              context: context,
                                                                              modelSetState: setState,
                                                                              notUse: false,
                                                                              titleList: surveyTitlesList),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(right: width / 23.4375, top: 10),
                                                                          child: bookMarkWidget(
                                                                              bookMark: surveyBookMarkList,
                                                                              context: context,
                                                                              scale: 3.2,
                                                                              id: surveyIdList[index],
                                                                              type: 'survey',
                                                                              modelSetState: setState,
                                                                              index: index,
                                                                              initFunction: getAllData,
                                                                              notUse: false),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                                  },
                                                ),
                                              ),
                                            ),
                                    ),
                            ],
                          )
                        : Center(
                            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                          ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        logEventFunc(name: 'Survey_Start', type: 'Survey');
                        bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return SurveyPostPage(text: widget.text);
                        }));
                        if (response) {
                          await getSurveyValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
                        }
                      },
                      tooltip: 'Increment',
                      backgroundColor: const Color(0XFF0EA102),
                      child: const Icon(Icons.add),
                    ),
                  )
            : Scaffold(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  //backgroundColor: const Color(0XFFFFFFFF),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  toolbarHeight: height / 8.63,
                  automaticallyImplyLeading: false,
                  title: Column(
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
                                Text(
                                  "Survey",
                                  style: TextStyle(fontSize: text.scale(26), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
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
                    ],
                  ),
                  elevation: 0.0,
                ),
                body: loading
                    ? Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    widget.homeSearch != null
                                        ? Navigator.pop(context)
                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return SurveyPage(text: widget.text);
                                          }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: width / 23.43),
                                    child: const Icon(Icons.arrow_back),
                                  )),
                              SizedBox(
                                width: width / 31.25,
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
                                      child: Text(
                                        widget.tickerName,
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                      ))
                                  : Text(
                                      mainTopic,
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                    )
                            ],
                          ),
                          SizedBox(
                            height: height / 49.21,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                            height: height / 19.33,
                            child: TextFormField(
                              onSaved: (value) {},
                              textInputAction: TextInputAction.search,
                              onChanged: (value) async {
                                context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                setState(() {
                                  searchLoader = true;
                                });
                                if (value.isNotEmpty) {
                                  newsInt = 0;
                                  await getSurveyValues(text: value, category: widget.text, filterId: widget.filterId, topic: widget.topic);
                                } else {
                                  newsInt = 0;
                                  await getSurveyValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
                                }
                              },
                              style: Theme.of(context).textTheme.bodyMedium,
                              controller: _searchController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).colorScheme.tertiary,
                                filled: true,
                                contentPadding: const EdgeInsets.only(left: 15),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                          setState(() {
                                            _searchController.clear();
                                          });
                                          getSurveyValues(text: "", category: finalisedCategory, filterId: finalisedFilterId, topic: widget.topic);
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
                                disabledBorder: OutlineInputBorder(
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
                          ),
                          SizedBox(height: height / 58),
                          searchLoader
                              ? SizedBox(
                                  height: height / 1.45,
                                  child: Column(
                                    children: [
                                      Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                    ],
                                  ))
                              : NotificationListener<OverscrollIndicatorNotification>(
                                  onNotification: (overflow) {
                                    overflow.disallowIndicator();
                                    return true;
                                  },
                                  child: emptyBool
                                      ? mainTopic == "My Questions"
                                          ? Container(
                                              margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                              height: height / 1.5,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                    SizedBox(
                                                      height: height / 86.6,
                                                    ),
                                                    RichText(
                                                      textAlign: TextAlign.justify,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: 'Looks like you have not created any content yet, Do you want to add one now? ',
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .labelSmall /*TextStyle(fontFamily: "Poppins", fontSize: 12)*/),
                                                          TextSpan(
                                                              text: ' Add here',
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .labelSmall!
                                                                  .copyWith(color: const Color(0XFF0EA102), fontWeight: FontWeight.w700),
                                                              /*const TextStyle(
                                                                  fontFamily: "Poppins",
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12),*/
                                                              recognizer: TapGestureRecognizer()
                                                                ..onTap = () async {
                                                                  bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return SurveyPostPage(text: widget.text);
                                                                  }));
                                                                  if (response) {
                                                                    await getSurveyValues(
                                                                        text: "",
                                                                        category: widget.text,
                                                                        filterId: widget.filterId,
                                                                        topic: widget.topic);
                                                                  }
                                                                }),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : mainTopic == "My Answers"
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                  height: height / 1.5,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          height: 150,
                                                          width: 150,
                                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                                      SizedBox(
                                                        height: height / 86.6,
                                                      ),
                                                      RichText(
                                                        textAlign: TextAlign.justify,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    'Unfortunately, you have not added any response yet. Do you want to help others by answering a few questions? ',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelSmall /* TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 12)*/),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0XFF0EA102),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                            ),
                                                            onPressed: () {
                                                              getSurveyValues(
                                                                  text: "", category: widget.text, filterId: widget.filterId, topic: "Unanswered");
                                                            },
                                                            child: const Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height / 5,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                      SizedBox(
                                                        height: height / 86.6,
                                                      ),
                                                      RichText(
                                                        textAlign: TextAlign.center,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    '😟 Looks like there is no Survey created under this topic, Would you like to a add ',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelSmall /*TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 10)*/),
                                                            TextSpan(
                                                                text: ' Add here',
                                                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                    color: const Color(0XFF0EA102),
                                                                    fontWeight: FontWeight
                                                                        .w700) /*const TextStyle(
                                                                    fontFamily: "Poppins",
                                                                    color: Color(0XFF0EA102),
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 12)*/
                                                                ,
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () async {
                                                                    bool response = await Navigator.push(context,
                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                      return SurveyPostPage(text: widget.text);
                                                                    }));
                                                                    if (response) {
                                                                      await getSurveyValues(
                                                                          text: "",
                                                                          category: widget.text,
                                                                          filterId: widget.filterId,
                                                                          topic: widget.topic);
                                                                    }
                                                                  }),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                      : Container(
                                          height: height / 1.4,
                                          margin: EdgeInsets.symmetric(horizontal: width / 23.43),
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
                                            onLoading: _onSurveyLoading,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: surveyTitlesList.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                          height: height / 9.10,
                                                          margin: const EdgeInsets.symmetric(horizontal: 15),
                                                          child: AdWidget(ad: nativeAdList[index])),
                                                      SizedBox(height: height / 57.73),
                                                      GestureDetector(
                                                          onTap: () async {
                                                            await statusFunc(surveyId: surveyIdList[index]);
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            surveyMyList[index]
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: surveyIdList[index],
                                                                      activity: true,
                                                                      surveyTitle: surveyTitlesList[index],
                                                                    );
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: surveyIdList[index],
                                                                                activity: true,
                                                                                surveyTitle: surveyTitlesList[index]);
                                                                          }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return QuestionnairePage(
                                                                              surveyId: surveyIdList[index],
                                                                              defaultIndex: answeredQuestion,
                                                                            );
                                                                          }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                            surveyId: surveyIdList[index],
                                                                            activity: true,
                                                                            surveyTitle: surveyTitlesList[index]);
                                                                      }));
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(bottom: height / 35, top: 2, left: 2, right: 2),
                                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(context).colorScheme.background,
                                                                borderRadius: BorderRadius.circular(20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                ]),
                                                            child: Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height: height / 13.53,
                                                                            width: width / 5.95,
                                                                            margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: Theme.of(context).colorScheme.tertiary,
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(surveyImagesList[index]), fit: BoxFit.fill)),
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                  width: width / 1.95,
                                                                                  child: Text(
                                                                                    surveyTitlesList[index],
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                  )),
                                                                              SizedBox(
                                                                                height: height / 56,
                                                                              ),
                                                                              SizedBox(
                                                                                  height: height / 54.13,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        surveySourceNameList[index].toString().capitalizeFirst!,
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Container(
                                                                                        height: 5,
                                                                                        width: 5,
                                                                                        decoration: const BoxDecoration(
                                                                                            shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        surveyQuestionsList[index].toString(),
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                      Text(
                                                                                        " Questions",
                                                                                        style: TextStyle(
                                                                                            fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                    ],
                                                                                  )),
                                                                              SizedBox(
                                                                                height: height / 56,
                                                                              ),
                                                                              SizedBox(
                                                                                height: height / 54.13,
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        width: width / 7.5,
                                                                                        child: Text(surveyCategoryList[index],
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.blue))),
                                                                                    /*Container(
                                                                  height:_height/162,width: _width/75,decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xffC4C4C4),)),*/
                                                                                    SizedBox(width: width / 22.05),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text(surveyViewsList[index].toString(),
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w700)),
                                                                                        Text(" Views",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500)),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(width: width / 22.05),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text(surveyResponseList[index].toString(),
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w700)),
                                                                                        Text(" Responses",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(10),
                                                                                                fontWeight: FontWeight.w500)),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                              padding: EdgeInsets.only(right: width / 23.4375),
                                                                              child: const Icon(
                                                                                Icons.more_horiz,
                                                                                size: 20,
                                                                              )),
                                                                          Padding(
                                                                            padding: EdgeInsets.only(right: width / 35, top: 10),
                                                                            child: widgetsMain.translationWidget(
                                                                                translationList: surveyTranslationList,
                                                                                id: surveyIdList[index],
                                                                                type: 'survey',
                                                                                index: index,
                                                                                initFunction: getAllData,
                                                                                context: context,
                                                                                modelSetState: setState,
                                                                                notUse: false,
                                                                                titleList: surveyTitlesList),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsets.only(right: width / 23.4375, top: 10),
                                                                            child: bookMarkWidget(
                                                                                bookMark: surveyBookMarkList,
                                                                                context: context,
                                                                                scale: 3.2,
                                                                                id: surveyIdList[index],
                                                                                type: 'survey',
                                                                                modelSetState: setState,
                                                                                index: index,
                                                                                initFunction: getAllData,
                                                                                notUse: false),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                    ],
                                                  );
                                                }
                                                return GestureDetector(
                                                    onTap: () async {
                                                      await statusFunc(surveyId: surveyIdList[index]);
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      surveyMyList[index]
                                                          ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return AnalyticsPage(
                                                                surveyId: surveyIdList[index],
                                                                activity: true,
                                                                surveyTitle: surveyTitlesList[index],
                                                              );
                                                            }))
                                                          : activeStatus == 'active'
                                                              ? answerStatus
                                                                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                          surveyId: surveyIdList[index],
                                                                          activity: true,
                                                                          surveyTitle: surveyTitlesList[index]);
                                                                    }))
                                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return QuestionnairePage(
                                                                        surveyId: surveyIdList[index],
                                                                        defaultIndex: answeredQuestion,
                                                                      );
                                                                    }))
                                                              : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return AnalyticsPage(
                                                                      surveyId: surveyIdList[index],
                                                                      activity: true,
                                                                      surveyTitle: surveyTitlesList[index]);
                                                                }));
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(bottom: height / 35, top: 2, left: 2, right: 2),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                          ]),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            color: Theme.of(context).colorScheme.background,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: height / 13.53,
                                                                      width: width / 5.95,
                                                                      margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: Theme.of(context).colorScheme.tertiary,
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(surveyImagesList[index]), fit: BoxFit.fill)),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                            width: width / 1.95,
                                                                            child: Text(
                                                                              surveyTitlesList[index],
                                                                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                            )),
                                                                        SizedBox(
                                                                          height: height / 56,
                                                                        ),
                                                                        SizedBox(
                                                                            height: height / 54.13,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  surveySourceNameList[index].toString().capitalizeFirst!,
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Container(
                                                                                  height: 5,
                                                                                  width: 5,
                                                                                  decoration: const BoxDecoration(
                                                                                      shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  surveyQuestionsList[index].toString(),
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                ),
                                                                                Text(
                                                                                  " Questions",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                        SizedBox(
                                                                          height: height / 56,
                                                                        ),
                                                                        SizedBox(
                                                                          height: height / 54.13,
                                                                          child: Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                  width: width / 7.5,
                                                                                  child: Text(surveyCategoryList[index],
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.blue))),
                                                                              /*Container(
                                                                  height:_height/162,width: _width/75,decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xffC4C4C4),)),*/
                                                                              SizedBox(width: width / 22.05),
                                                                              Row(
                                                                                children: [
                                                                                  Text(surveyViewsList[index].toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                  Text(" Views",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: width / 22.05),
                                                                              Row(
                                                                                children: [
                                                                                  Text(surveyResponseList[index].toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                  Text(" Responses",
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                        padding: EdgeInsets.only(right: width / 23.4375),
                                                                        child: const Icon(
                                                                          Icons.more_horiz,
                                                                          size: 20,
                                                                        )),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(right: width / 35, top: 10),
                                                                      child: widgetsMain.translationWidget(
                                                                          translationList: surveyTranslationList,
                                                                          id: surveyIdList[index],
                                                                          type: 'survey',
                                                                          index: index,
                                                                          initFunction: getAllData,
                                                                          context: context,
                                                                          modelSetState: setState,
                                                                          notUse: false,
                                                                          titleList: surveyTitlesList),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(right: width / 23.4375, top: 10),
                                                                      child: bookMarkWidget(
                                                                          bookMark: surveyBookMarkList,
                                                                          context: context,
                                                                          scale: 3.2,
                                                                          id: surveyIdList[index],
                                                                          type: 'survey',
                                                                          modelSetState: setState,
                                                                          index: index,
                                                                          initFunction: getAllData,
                                                                          notUse: false),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ),
                                        ),
                                ),
                        ],
                      )
                    : Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    logEventFunc(name: 'Survey_Start', type: 'Survey');
                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return SurveyPostPage(text: widget.text);
                    }));
                    if (response) {
                      await getSurveyValues(text: "", category: widget.text, filterId: widget.filterId, topic: widget.topic);
                    }
                  },
                  tooltip: 'Increment',
                  backgroundColor: const Color(0XFF0EA102),
                  child: const Icon(Icons.add),
                ),
              ),
      ),
    );
  }

  void showAlertDialog({required BuildContext context, required String surveyId, required String surveyUserId}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          reverse: true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: height / 1.18,
              width: width / 1.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 3.67,
                      width: width / 1.96,
                      child: Image.asset(
                        actionValue == "Report"
                            ? isDarkTheme.value
                                ? "assets/settings/report_dark.png"
                                : "assets/settings/report_light.png"
                            : isDarkTheme.value
                                ? "assets/settings/block_dark.png"
                                : "assets/settings/block_light.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20.3,
                  ),
                  Center(
                    child: Text(
                      'Help us understand why?',
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Action:",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                alignment: AlignmentDirectional.center,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: actionList
                                    .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                        )))
                                    .toList(),
                                value: actionValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    actionValue = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Why?",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: whyList
                                    .map((label) => DropdownMenuItem<String>(
                                          value: label,
                                          child: Text(
                                            label,
                                            style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                          ),
                                        ))
                                    .toList(),
                                value: whyValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    whyValue = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  TextFormField(
                    controller: _controller,
                    minLines: 4,
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: width / 26.78, vertical: height / 50.75),
                      hintText: "Enter a description...",
                      hintStyle: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  GestureDetector(
                    onTap: () {
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Survey');
                      reportPost(action: actionValue, why: whyValue, description: _controller.text, surveyId: surveyId, surveyUserId: surveyUserId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isDarkTheme.value
                            ? const Color(0xff464646)
                            : actionValue == "Report"
                                ? const Color(0XFF0EA102)
                                : const Color(0xffFF0000),
                      ),
                      height: height / 18.45,
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(14), fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                  itemCount: surveyViewedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(
                                uId: surveyViewedIdList[index], uType: 'survey', mainUserToken: mainUserToken, context: context, index: 1);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(surveyViewedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            surveyViewedSourceNameList[index].toString().capitalizeFirst!,
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
