import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:tradewatchfinal/Constants/Common/filter_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/commodity_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/crypto_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/forex_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_edit_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

import 'detailed_survey_image_page.dart';
import 'survey_post_page.dart';

class SurveyPage extends StatefulWidget {
  final String text;

  const SurveyPage({Key? key, required this.text}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<String> categoriesList = ["Stocks", "Crypto", "Commodity", "Forex"];
  String selectedValue = "Stocks";
  String selectedWidget = "";
  String selectedIdWidget = "";
  List enteredNewList = [];

  bool searchLoader = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FilterFunction _filterFunction = FilterFunction();
  String mainUserId = "";
  String mainUserToken = '';
  var time = '';
  List surveyImagesList = [];
  List<bool> surveyBookMarkList = [];
  List surveySourceNameList = [];
  List<String> surveyTitlesList = [];
  List<bool> surveyTranslationList = [];
  List<String> timeList = [];
  List<String> surveyCategoryList = [];
  List<String> surveyCompanyList = [];
  int newsInt = 0;
  String categoryValue = "";
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool filterBool = false;
  bool startSearch = false;
  String filterId = "";
  bool dropDownSelection = false;
  bool emptyBool = false;
  List<String> surveyIdList = [];
  List<int> surveyViewsList = [];
  List<int> surveyResponseList = [];
  List<int> surveyQuestionList = [];
  List<dynamic> surveyObjectList = [];
  List<String> surveyUserIdList = [];
  List<int> surveyLikeList = [];
  List<int> surveyDislikeList = [];
  List<bool> surveyUseList = [];
  List<bool> surveyUseDisList = [];
  List<bool> surveyMyList = [];
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String whyValue = "Scam";
  late Uri newLink;
  bool loading = false;
  bool completePopUp = false;
  String activeStatus = "";
  bool answerStatus = false;
  int answeredQuestion = 0;
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
  List eventNames = [
    "Viewed_Latest",
    "Viewed_Popular",
    "Viewed_Unanswered",
    "Viewed_Added_this_month",
    "Viewed_Added_this_quarter",
    "Viewed_Added_this_semester",
    "Viewed_6+_older",
    "Viewed_My_Poll",
    "Viewed_My_Answers",
  ];
  List designImages = [
    "lib/Constants/Assets/ForumPage/LatestTopics.png",
    "lib/Constants/Assets/ForumPage/PopularTopics.png",
    "lib/Constants/Assets/ForumPage/MostLiked.png",
    "lib/Constants/Assets/ForumPage/MostReplies.png",
    "lib/Constants/Assets/ForumPage/MostDisliked.png",
    "lib/Constants/Assets/ForumPage/MyShared.png",
    "lib/Constants/Assets/ForumPage/MyQuestions.png",
    "lib/Constants/Assets/ForumPage/Unanswered.png",
    "lib/Constants/Assets/ForumPage/myanswers.jpg"
  ];
  List<String> surveyViewedImagesList = [];
  List<String> surveyViewedIdList = [];
  List<String> surveyViewedSourceNameList = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

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
            page: 'survey',
          );
        }));
      } else if (selectedValue == "Crypto") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CryptoAddFilterPage(
            text: selectedValue,
            page: 'survey',
          );
        }));
      } else if (selectedValue == "Commodity") {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return CommodityAddFilterPage(
            text: selectedValue,
            page: 'survey',
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForexAddFilterPage(
            text: selectedValue,
            page: 'survey',
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

  getSurveyValues({required String text, required String? category, required String filterId}) async {
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    var response = await http.post(url,
        headers: {'Authorization': mainUserToken},
        body: {'category': category!.toLowerCase(), 'search': text.isEmpty ? "" : text, 'filter_id': filterId.isEmpty ? "" : filterId, 'skip': "0"});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      surveyImagesList.clear();
      surveyBookMarkList.clear();
      surveySourceNameList.clear();
      surveyTitlesList.clear();
      surveyTranslationList.clear();
      timeList.clear();
      surveyCategoryList.clear();
      surveyCompanyList.clear();
      surveyIdList.clear();
      surveyLikeList.clear();
      surveyDislikeList.clear();
      surveyUseList.clear();
      surveyResponseList.clear();
      surveyObjectList.clear();
      surveyQuestionList.clear();
      surveyUseDisList.clear();
      surveyMyList.clear();
      surveyViewsList.clear();
      surveyUserIdList.clear();
      nativeAdList.clear();
      nativeAdIsLoadedList.clear();
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool = true;
          searchLoader = false;
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
          surveyObjectList.add(responseData["response"][i]);
          surveyTitlesList.add(responseData["response"][i]["title"]);
          surveyTranslationList.add(false);
          surveyBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
          surveyResponseList.add(responseData["response"][i]["answers_count"]);
          surveyQuestionList.add(responseData["response"][i]["questions_count"]);
          surveySourceNameList.add(responseData["response"][i]["user"]["username"]);
          surveyCategoryList.add(responseData["response"][i]["category"]);
          surveyCompanyList.add(responseData["response"][i]["company_name"]);
          surveyIdList.add(responseData["response"][i]["_id"]);
          surveyViewsList.add(responseData["response"][i]["views_count"]);
          surveyUserIdList.add(responseData["response"][i]["user"]["_id"]);
          if (mainUserId == surveyUserIdList[i]) {
            surveyMyList.add(true);
          } else {
            surveyMyList.add(false);
          }
        }
        setState(() {
          searchLoader = false;
        });
      }
      setState(() {
        loading = true;
      });
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

  @override
  void initState() {
    getAllDataMain(name: 'Survey_Home_Page');
    getNotifyCountAndImage();
    pageVisitFunc(pageName: 'survey');
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

  getAllData() async {
    if (widget.text != "") {
      widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("do nothing") : finalisedFilterId = "";
      widget.text.toLowerCase() == finalisedCategory.toLowerCase() ? debugPrint("do nothing") : finalisedFilterName = "";
      finalisedCategory = widget.text;
    }
    selectedValue = finalisedCategory;
    selectedIdWidget = finalisedFilterId;
    selectedWidget = finalisedFilterName;
    await getFil(type: selectedValue, filterId: finalisedFilterId);
    await getSurveyValues(text: "", category: finalisedCategory, filterId: finalisedFilterId);
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

  _onSurveyLoading() async {
    setState(() {
      newsInt = newsInt + 20;
    });
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': selectedValue.toLowerCase(),
      'search': _searchController.text.isEmpty ? "" : _searchController.text,
      'filter_id': filterId.isEmpty ? "" : filterId,
      'skip': newsInt.toString(),
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          searchLoader = false;
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
          surveyObjectList.add(responseData["response"][i]);
          surveyTitlesList.add(responseData["response"][i]["title"]);
          surveyTranslationList.add(false);
          surveyBookMarkList.add(responseData["response"][i]["bookmark"] ?? false);
          surveyResponseList.add(responseData["response"][i]["answers_count"]);
          surveyQuestionList.add(responseData["response"][i]["questions_count"]);
          surveySourceNameList.add(responseData["response"][i]["user"]["username"]);
          surveyCategoryList.add(responseData["response"][i]["category"]);
          surveyCompanyList.add(responseData["response"][i]["company_name"]);
          surveyIdList.add(responseData["response"][i]["_id"]);
          surveyViewsList.add(responseData["response"][i]["views_count"]);
          surveyUserIdList.add(responseData["response"][i]["user"]["_id"]);
          if (mainUserId == surveyUserIdList[i]) {
            surveyMyList.add(true);
          } else {
            surveyMyList.add(false);
          }
        }
        setState(() {
          searchLoader = false;
        });
      }
      setState(() {
        loading = true;
      });
    }
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
      getSurveyValues(text: "", category: selectedValue, filterId: filterId);
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

  reportPost(
      {required String action, required String why, required String description, required String surveyId, required String surveyUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!mounted) {
          return false;
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
          getSurveyValues(text: "", category: selectedValue, filterId: filterId);
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
        getSurveyValues(text: "", category: selectedValue, filterId: filterId);
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
  }

  @override
  void dispose() {
    extraContainMain.value = false;
    // context.read<BookMarkWidgetBloc>().add(LoadingEvent());
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
        if (startSearch) {
          setState(() {
            startSearch = false;
          });
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return MainBottomNavigationPage(
              tType: true,
              text: finalisedCategory,
              caseNo1: 1,
              newIndex: 0,
              excIndex: 0,
              isHomeFirstTym: false,
              countryIndex: 0,
            );
          }));
        }
        return false;
      },
      child: Container(
        // color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              extraContainMain.value = false;
            },
            child: Scaffold(
              // backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: height / 5.71,
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
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
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
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    size: 30,
                                  )),
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
                    SizedBox(height: height / 50.75),
                    SizedBox(
                      height: height / 25.375,
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
                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", fit: BoxFit.fill),
                                        )
                                      : selectedValue == "Commodity"
                                          ? SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child:
                                                  Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png", fit: BoxFit.fill),
                                            )
                                          : SizedBox(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              child: Image.asset("lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png", fit: BoxFit.fill),
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
                                              surveyImagesList.clear();
                                              surveyBookMarkList.clear();
                                              surveySourceNameList.clear();
                                              surveyTitlesList.clear();
                                              surveyTranslationList.clear();
                                              surveyCategoryList.clear();
                                              surveyCompanyList.clear();
                                              timeList.clear();
                                              newsInt = 0;
                                              selectedValue = value!;
                                              finalisedCategory = selectedValue;
                                              prefs.setString('finalisedCategory1', finalisedCategory);
                                            });
                                            getSelectedValue(value: finalisedCategory);
                                            if (!mounted) {
                                              return;
                                            }
                                            context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
                                            await getFil(type: finalisedCategory, filterId: "");
                                            await getSurveyValues(
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
                    SizedBox(height: height / 50.75),
                  ],
                ),
                elevation: 0.0,
              ),
              body: loading
                  ? Obx(() => extraContainMain.value
                      ? NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (scroll) {
                            scroll.disallowIndicator();
                            return true;
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: width,
                                    //need to do same here
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        startSearch
                                            ? const SizedBox()
                                            : Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                                child: const Text("Topics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                                        startSearch
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: height / 50.75,
                                              ),
                                        startSearch
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: height / 3.8,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: 9,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            left: index == 0 ? width / 31.25 : width / 62.5,
                                                            right: index == 8 ? width / 31.25 : width / 62.5,
                                                            bottom: 15),
                                                        child: Card(
                                                          elevation: 10.0,
                                                          shape: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                              borderSide: const BorderSide(color: Colors.white)),
                                                          child: Stack(
                                                            alignment: Alignment.bottomLeft,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.only(
                                                                    left: index == 0 ? width / 18.75 : width / 37.5,
                                                                    right: index == 8 ? width / 18.75 : width / 37.5),
                                                                width: width / 2.7,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: AssetImage(designImages[index]),
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  /* boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(0,4),
                                                  color: Color(0XFF000000).withOpacity(0.25)
                                                ),
                                              ]*/
                                                                ),
                                                              ),
                                                              Container(
                                                                height: height / 16.24,
                                                                width: width / 2.7,
                                                                padding: EdgeInsets.only(
                                                                    left: index == 0 ? width / 18.75 : width / 37.5,
                                                                    right: index == 8 ? width / 18.75 : width / 37.5),
                                                                //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius.only(
                                                                      bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                                                                  color: Colors.black12.withOpacity(0.3),
                                                                  /*boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                      offset: Offset(0,4),
                                                      color: Color(0XFF000000).withOpacity(0.25)
                                                  ),
                                                ]*/
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    designTopics[index],
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
                                                      );
                                                    }),
                                              ),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          height: height / 19.33,
                                          child: TextFormField(
                                            readOnly: true,
                                            enabled: false,
                                            cursorColor: Colors.green,
                                            onTap: () {
                                              setState(() {
                                                startSearch = true;
                                              });
                                            },
                                            onChanged: (value) async {
                                              setState(() {
                                                searchLoader = true;
                                              });
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  startSearch = true;
                                                });
                                                newsInt = 0;
                                                await getFil(type: selectedValue, filterId: "");
                                                await getSurveyValues(text: value, category: selectedValue, filterId: selectedIdWidget);
                                              } else {
                                                setState(() {
                                                  startSearch = false;
                                                });
                                                newsInt = 0;
                                                await getFil(type: selectedValue, filterId: "");
                                                await getSurveyValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                                              }
                                            },
                                            style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                            controller: _searchController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              fillColor: const Color(0XFFF9F9F9),
                                              filled: true,
                                              prefixIcon: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
                                              suffixIcon: _searchController.text.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _searchController.clear();
                                                        });
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
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: const Color(0XFFA5A5A5),
                                                  fontSize: text.scale(14),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins"),
                                              hintText: 'Search here',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 50.75,
                                        ),
                                        searchLoader
                                            ? SizedBox(
                                                height: height / 2.37,
                                                child: const Center(child: CircularProgressIndicator(color: Color(0XFF0EA102))),
                                              )
                                            : emptyBool
                                                ? Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                            height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                        RichText(
                                                          text: const TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      '😟 Looks like there is no Forum created under this topic, Would you like to a add ',
                                                                  style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 10)),
                                                              TextSpan(
                                                                text: ' Add here',
                                                                style: TextStyle(
                                                                    fontFamily: "Poppins",
                                                                    color: Color(0XFF0EA102),
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                    height: startSearch ? height / 1.2 : height / 2.54,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      // physics: NeverScrollableScrollPhysics(),
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
                                                              Container(
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
                                                                                    height: height / 87.6,
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
                                                                                            surveyQuestionList[index].toString(),
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
                                                                                    height: height / 87.6,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            width: width / 7.5,
                                                                                            child: Text(surveyCompanyList[index],
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
                                                                          SizedBox(
                                                                            height: height / 13.53,
                                                                            child: Column(
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
                                                                                  padding: EdgeInsets.only(right: width / 23.4375),
                                                                                  child: bookMarkWidget(
                                                                                      bookMark: surveyBookMarkList,
                                                                                      enabled: false,
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
                                                          );
                                                        }
                                                        return Container(
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
                                                                              height: height / 87.6,
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
                                                                                      surveyQuestionList[index].toString(),
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
                                                                              height: height / 87.6,
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 54.13,
                                                                              child: Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                      width: width / 7.5,
                                                                                      child: Text(surveyCompanyList[index],
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
                                                                    SizedBox(
                                                                      height: height / 13.53,
                                                                      child: Column(
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
                                                                            padding: EdgeInsets.only(right: width / 23.4375),
                                                                            child: bookMarkWidget(
                                                                                bookMark: surveyBookMarkList,
                                                                                enabled: false,
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
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
                                                    await getSurveyValues(
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
                                                                  page: 'survey',
                                                                );
                                                              }));
                                                            } else if (selectedValue == "Crypto") {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return CryptoEditFilterPage(
                                                                  text: selectedValue,
                                                                  filterId: enteredFilteredIdList[index],
                                                                  response: response,
                                                                  page: 'survey',
                                                                );
                                                              }));
                                                            } else if (selectedValue == "Commodity") {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return CommodityEditFilterPage(
                                                                  text: selectedValue,
                                                                  filterId: enteredFilteredIdList[index],
                                                                  response: response,
                                                                  page: 'survey',
                                                                );
                                                              }));
                                                            } else {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return ForexEditFilterPage(
                                                                  text: selectedValue,
                                                                  filterId: enteredFilteredIdList[index],
                                                                  response: response,
                                                                  page: 'survey',
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
                                                              getSurveyValues(
                                                                  text: _searchController.text,
                                                                  category: finalisedCategory,
                                                                  filterId: finalisedFilterId);
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
                                                    navigationPage1();
                                                  },
                                                  title:
                                                      Text("Add a New List", style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600)),
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
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      : NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (scroll) {
                            scroll.disallowIndicator();
                            return true;
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    startSearch
                                        ? const SizedBox()
                                        : Container(
                                            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                            child: const Text("Topics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                                    startSearch
                                        ? const SizedBox()
                                        : SizedBox(
                                            height: height / 50.75,
                                          ),
                                    startSearch
                                        ? const SizedBox()
                                        : SizedBox(
                                            height: height / 3.8,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: 9,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                        left: index == 0 ? width / 31.25 : width / 62.5,
                                                        right: index == 8 ? width / 31.25 : width / 62.5,
                                                        bottom: 15),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        logEventFunc(name: eventNames[index], type: 'Survey');
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return DetailedSurveyImagePage(
                                                            text: selectedValue,
                                                            tickerId: '',
                                                            tickerName: "",
                                                            fromCompare: false,
                                                            catIdList: mainCatIdList,
                                                            filterId: selectedIdWidget,
                                                            topic: designTopics[index],
                                                            surveyDetail: "",
                                                          );
                                                        }));
                                                      },
                                                      child: Card(
                                                        elevation: 10.0,
                                                        shape: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.background)),
                                                        child: Stack(
                                                          alignment: Alignment.bottomLeft,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.only(
                                                                  left: index == 0 ? width / 18.75 : width / 37.5,
                                                                  right: index == 8 ? width / 18.75 : width / 37.5),
                                                              width: width / 2.7,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage(designImages[index]),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                color: Theme.of(context).colorScheme.background,
                                                                borderRadius: BorderRadius.circular(20),
                                                                /* boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4,
                                                        spreadRadius: 0,
                                                        offset: Offset(0,4),
                                                        color: Color(0XFF000000).withOpacity(0.25)
                                                      ),
                                                    ]*/
                                                              ),
                                                            ),
                                                            Container(
                                                              height: height / 16.24,
                                                              width: width / 2.7,
                                                              padding: EdgeInsets.only(
                                                                  left: index == 0 ? width / 18.75 : width / 37.5,
                                                                  right: index == 8 ? width / 18.75 : width / 37.5),
                                                              //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                    bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                                                                color: Colors.black12.withOpacity(0.3),
                                                                /*boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 4,
                                                            spreadRadius: 0,
                                                            offset: Offset(0,4),
                                                            color: Color(0XFF000000).withOpacity(0.25)
                                                        ),
                                                      ]*/
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  designTopics[index],
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
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                      height: height / 19.33,
                                      child: TextFormField(
                                        cursorColor: Colors.green,
                                        onTap: () {
                                          setState(() {
                                            startSearch = true;
                                          });
                                        },
                                        onChanged: (value) async {
                                          context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                          setState(() {
                                            searchLoader = true;
                                          });
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              startSearch = true;
                                            });
                                            newsInt = 0;
                                            await getFil(type: selectedValue, filterId: "");
                                            await getSurveyValues(text: value, category: selectedValue, filterId: selectedIdWidget);
                                          } else {
                                            setState(() {
                                              startSearch = false;
                                            });
                                            newsInt = 0;
                                            await getFil(type: selectedValue, filterId: "");
                                            await getSurveyValues(text: "", category: selectedValue, filterId: selectedIdWidget);
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          }
                                        },
                                        onFieldSubmitted: (value) {
                                          if (_searchController.text.isEmpty) {
                                            setState(() {
                                              startSearch = false;
                                            });
                                          } else {
                                            setState(() {
                                              startSearch = false;
                                            });
                                          }
                                        },
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        controller: _searchController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            fillColor: Theme.of(context).colorScheme.tertiary,
                                            filled: true,
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                            ),
                                            suffixIcon: _searchController.text.isNotEmpty
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
                                                      setState(() {
                                                        startSearch = false;
                                                        _searchController.clear();
                                                      });
                                                      await getFil(type: selectedValue, filterId: "");
                                                      await getSurveyValues(text: "", category: finalisedCategory, filterId: finalisedFilterId);
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                    },
                                                    child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                                                  )
                                                : const SizedBox(),
                                            contentPadding: const EdgeInsets.only(left: 15),
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
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                            hintText: "Search here"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 50.75,
                                    ),
                                    searchLoader
                                        ? SizedBox(
                                            height: height / 2.37,
                                            child: Center(
                                              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                            ),
                                          )
                                        : emptyBool
                                            ? Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 10.71),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                                    RichText(
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
                                                                        text: "", category: finalisedCategory, filterId: finalisedFilterId);
                                                                  }
                                                                }),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                height: startSearch ? height / 1.2 : height / 2.54,
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
                                                                              activity: false,
                                                                              surveyTitle: surveyTitlesList[index]);
                                                                        }))
                                                                      : activeStatus == 'active'
                                                                          ? answerStatus
                                                                              ? Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                  return AnalyticsPage(
                                                                                    surveyId: surveyIdList[index],
                                                                                    activity: false,
                                                                                    surveyTitle: surveyTitlesList[index],
                                                                                  );
                                                                                }))
                                                                              : Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                  return QuestionnairePage(
                                                                                    surveyId: surveyIdList[index],
                                                                                    defaultIndex: answeredQuestion,
                                                                                  );
                                                                                }))
                                                                          : Navigator.push(context,
                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                              return AnalyticsPage(
                                                                                  surveyId: surveyIdList[index],
                                                                                  activity: false,
                                                                                  surveyTitle: surveyTitlesList[index]);
                                                                            }));
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(bottom: height / 35),
                                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                  decoration: BoxDecoration(
                                                                      color: Theme.of(context).colorScheme.background,
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Theme.of(context).colorScheme.tertiary,
                                                                            blurRadius: 4,
                                                                            spreadRadius: 0)
                                                                      ]),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            color: Theme.of(context).colorScheme.background,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return UserBillBoardProfilePage(
                                                                                          userId: surveyUserIdList[
                                                                                              index]) /*UserProfilePage(id:surveyUserIdList[index],type:'survey',index:1)*/;
                                                                                    }));
                                                                                  },
                                                                                  child: Container(
                                                                                    height: height / 13.53,
                                                                                    width: width / 5.95,
                                                                                    margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                                    decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Theme.of(context).colorScheme.tertiary,
                                                                                        image: DecorationImage(
                                                                                            image: NetworkImage(surveyImagesList[index]),
                                                                                            fit: BoxFit.fill)),
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: width / 1.6,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                              width: width / 1.95,
                                                                                              child: Text(
                                                                                                surveyTitlesList[index],
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(14),
                                                                                                    fontWeight: FontWeight.w600),
                                                                                              )),
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              showModalBottomSheet(
                                                                                                  shape: const RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.vertical(
                                                                                                      top: Radius.circular(30),
                                                                                                    ),
                                                                                                  ),
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return SingleChildScrollView(
                                                                                                      child: Container(
                                                                                                        margin: EdgeInsets.symmetric(
                                                                                                            horizontal: width / 18.75),
                                                                                                        padding: EdgeInsets.only(
                                                                                                            bottom: MediaQuery.of(context)
                                                                                                                .viewInsets
                                                                                                                .bottom),
                                                                                                        child: surveyMyList[index]
                                                                                                            ? ListTile(
                                                                                                                onTap: () {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  showDialog(
                                                                                                                      barrierDismissible: false,
                                                                                                                      context: context,
                                                                                                                      builder:
                                                                                                                          (BuildContext context) {
                                                                                                                        return Dialog(
                                                                                                                          shape:
                                                                                                                              RoundedRectangleBorder(
                                                                                                                                  borderRadius:
                                                                                                                                      BorderRadius
                                                                                                                                          .circular(
                                                                                                                                              20.0)),
                                                                                                                          //this right here
                                                                                                                          child: Container(
                                                                                                                            height: height / 6,
                                                                                                                            margin:
                                                                                                                                EdgeInsets.symmetric(
                                                                                                                                    vertical: height /
                                                                                                                                        54.13,
                                                                                                                                    horizontal:
                                                                                                                                        width / 25),
                                                                                                                            child: Column(
                                                                                                                              mainAxisAlignment:
                                                                                                                                  MainAxisAlignment
                                                                                                                                      .center,
                                                                                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                              children: [
                                                                                                                                const Center(
                                                                                                                                    child: Text(
                                                                                                                                        "Delete Post",
                                                                                                                                        style: TextStyle(
                                                                                                                                            color: Color(
                                                                                                                                                0XFF0EA102),
                                                                                                                                            fontWeight:
                                                                                                                                                FontWeight
                                                                                                                                                    .bold,
                                                                                                                                            fontSize:
                                                                                                                                                20,
                                                                                                                                            fontFamily:
                                                                                                                                                "Poppins"))),
                                                                                                                                const Divider(),
                                                                                                                                const Center(
                                                                                                                                    child: Text(
                                                                                                                                        "Are you sure to Delete this Post")),
                                                                                                                                const Spacer(),
                                                                                                                                Padding(
                                                                                                                                  padding: EdgeInsets
                                                                                                                                      .symmetric(
                                                                                                                                          horizontal:
                                                                                                                                              width /
                                                                                                                                                  25),
                                                                                                                                  child: Row(
                                                                                                                                    mainAxisAlignment:
                                                                                                                                        MainAxisAlignment
                                                                                                                                            .spaceBetween,
                                                                                                                                    children: [
                                                                                                                                      TextButton(
                                                                                                                                        onPressed:
                                                                                                                                            () {
                                                                                                                                          Navigator.pop(
                                                                                                                                              context);
                                                                                                                                        },
                                                                                                                                        child:
                                                                                                                                            const Text(
                                                                                                                                          "Cancel",
                                                                                                                                          style: TextStyle(
                                                                                                                                              color: Colors
                                                                                                                                                  .grey,
                                                                                                                                              fontWeight:
                                                                                                                                                  FontWeight
                                                                                                                                                      .w600,
                                                                                                                                              fontFamily:
                                                                                                                                                  "Poppins",
                                                                                                                                              fontSize:
                                                                                                                                                  15),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                      ElevatedButton(
                                                                                                                                        style: ElevatedButton
                                                                                                                                            .styleFrom(
                                                                                                                                          shape:
                                                                                                                                              RoundedRectangleBorder(
                                                                                                                                            borderRadius:
                                                                                                                                                BorderRadius.circular(
                                                                                                                                                    18.0),
                                                                                                                                          ),
                                                                                                                                          backgroundColor:
                                                                                                                                              const Color(
                                                                                                                                                  0XFF0EA102),
                                                                                                                                        ),
                                                                                                                                        onPressed:
                                                                                                                                            () async {
                                                                                                                                          deletePost(
                                                                                                                                              surveyId:
                                                                                                                                                  surveyIdList[index]);
                                                                                                                                          Navigator.pop(
                                                                                                                                              context);
                                                                                                                                        },
                                                                                                                                        child:
                                                                                                                                            const Text(
                                                                                                                                          "Continue",
                                                                                                                                          style: TextStyle(
                                                                                                                                              color: Colors
                                                                                                                                                  .white,
                                                                                                                                              fontWeight:
                                                                                                                                                  FontWeight
                                                                                                                                                      .w600,
                                                                                                                                              fontFamily:
                                                                                                                                                  "Poppins",
                                                                                                                                              fontSize:
                                                                                                                                                  15),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                                const Spacer(),
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        );
                                                                                                                      });
                                                                                                                },
                                                                                                                minLeadingWidth: width / 25,
                                                                                                                leading: const Icon(
                                                                                                                  Icons.delete,
                                                                                                                  size: 20,
                                                                                                                ),
                                                                                                                title: Text(
                                                                                                                  "Delete Post",
                                                                                                                  style: TextStyle(
                                                                                                                      fontWeight: FontWeight.w500,
                                                                                                                      fontSize: text.scale(14)),
                                                                                                                ),
                                                                                                              )
                                                                                                            : Column(
                                                                                                                mainAxisAlignment:
                                                                                                                    MainAxisAlignment.start,
                                                                                                                crossAxisAlignment:
                                                                                                                    CrossAxisAlignment.start,
                                                                                                                children: [
                                                                                                                  ListTile(
                                                                                                                    onTap: () {
                                                                                                                      if (!mounted) {
                                                                                                                        return;
                                                                                                                      }
                                                                                                                      Navigator.pop(context);
                                                                                                                      _controller.clear();
                                                                                                                      setState(() {
                                                                                                                        actionValue = "Report";
                                                                                                                      });
                                                                                                                      showAlertDialog(
                                                                                                                          context: context,
                                                                                                                          surveyId:
                                                                                                                              surveyIdList[index],
                                                                                                                          surveyUserId:
                                                                                                                              surveyUserIdList[
                                                                                                                                  index]);
                                                                                                                    },
                                                                                                                    minLeadingWidth: width / 25,
                                                                                                                    leading: const Icon(
                                                                                                                      Icons.shield,
                                                                                                                      size: 20,
                                                                                                                    ),
                                                                                                                    title: Text(
                                                                                                                      "Report Post",
                                                                                                                      style: TextStyle(
                                                                                                                          fontWeight: FontWeight.w500,
                                                                                                                          fontSize: text.scale(14)),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Divider(
                                                                                                                    color: Theme.of(context)
                                                                                                                        .colorScheme
                                                                                                                        .tertiary,
                                                                                                                    thickness: 0.8,
                                                                                                                  ),
                                                                                                                  ListTile(
                                                                                                                    onTap: () {
                                                                                                                      _controller.clear();
                                                                                                                      setState(() {
                                                                                                                        actionValue = "Block";
                                                                                                                      });
                                                                                                                      if (!mounted) {
                                                                                                                        return;
                                                                                                                      }
                                                                                                                      Navigator.pop(context);
                                                                                                                      showAlertDialog(
                                                                                                                          context: context,
                                                                                                                          surveyId:
                                                                                                                              surveyIdList[index],
                                                                                                                          surveyUserId:
                                                                                                                              surveyUserIdList[
                                                                                                                                  index]);
                                                                                                                    },
                                                                                                                    minLeadingWidth: width / 25,
                                                                                                                    leading: const Icon(
                                                                                                                      Icons.flag,
                                                                                                                      size: 20,
                                                                                                                    ),
                                                                                                                    title: Text(
                                                                                                                      "Block Post",
                                                                                                                      style: TextStyle(
                                                                                                                          fontWeight: FontWeight.w500,
                                                                                                                          fontSize: text.scale(14)),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                      ),
                                                                                                    );
                                                                                                  });
                                                                                            },
                                                                                            child: const Padding(
                                                                                              padding: EdgeInsets.only(right: 8.0),
                                                                                              child: Icon(
                                                                                                Icons.more_horiz,
                                                                                                size: 20,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: height / 87.6,
                                                                                    ),
                                                                                    SizedBox(
                                                                                        width: width / 1.6,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: width / 1.95,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.push(context, MaterialPageRoute(
                                                                                                            builder: (BuildContext context) {
                                                                                                          return UserBillBoardProfilePage(
                                                                                                              userId: surveyUserIdList[
                                                                                                                  index]) /*UserProfilePage(id:surveyUserIdList[index],type:'survey',index: 1,)*/;
                                                                                                        }));
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        surveySourceNameList[index]
                                                                                                            .toString()
                                                                                                            .capitalizeFirst!,
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w500),
                                                                                                      )),
                                                                                                  const SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    height: 5,
                                                                                                    width: 5,
                                                                                                    decoration: const BoxDecoration(
                                                                                                        shape: BoxShape.circle,
                                                                                                        color: Color(0xffA5A5A5)),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    surveyQuestionList[index].toString(),
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
                                                                                              ),
                                                                                            ),
                                                                                            widgetsMain.translationWidget(
                                                                                                translationList: surveyTranslationList,
                                                                                                id: surveyIdList[index],
                                                                                                type: 'survey',
                                                                                                index: index,
                                                                                                initFunction: getAllData,
                                                                                                context: context,
                                                                                                modelSetState: setState,
                                                                                                notUse: false,
                                                                                                titleList: surveyTitlesList),
                                                                                          ],
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: height / 87.6,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width / 1.6,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: width / 1.95,
                                                                                            child: Row(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                    width: width / 7.5,
                                                                                                    child: Text(surveyCompanyList[index],
                                                                                                        style: TextStyle(
                                                                                                            fontSize: text.scale(10),
                                                                                                            fontWeight: FontWeight.w700,
                                                                                                            color: Colors.blue))),
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
                                                                                                      haveViewsMain =
                                                                                                          surveyViewsList[index] > 0 ? true : false;
                                                                                                      viewCountMain = surveyViewsList[index];
                                                                                                      kToken = mainUserToken;
                                                                                                    });
                                                                                                    //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionSurvey + viewsCount, idKey: 'survey_id', setState: setState);
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
                                                                                                  child: Row(
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
                                                                                                              fontSize: text.scale(10),
                                                                                                              fontWeight: FontWeight.w700)),
                                                                                                      Text(" Responses",
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(10),
                                                                                                              fontWeight: FontWeight.w500)),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(right: 8.0),
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
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
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
                                                                        activity: false,
                                                                        surveyTitle: surveyTitlesList[index]);
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                              surveyId: surveyIdList[index],
                                                                              activity: false,
                                                                              surveyTitle: surveyTitlesList[index],
                                                                            );
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
                                                                            activity: false,
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
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      color: Theme.of(context).colorScheme.background,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                return UserBillBoardProfilePage(
                                                                                    userId: surveyUserIdList[
                                                                                        index]) /*UserProfilePage(id:surveyUserIdList[index],type:'survey',index:1)*/;
                                                                              }));
                                                                            },
                                                                            child: Container(
                                                                              height: height / 13.53,
                                                                              width: width / 5.95,
                                                                              margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                              decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Theme.of(context).colorScheme.tertiary,
                                                                                  image: DecorationImage(
                                                                                      image: NetworkImage(surveyImagesList[index]),
                                                                                      fit: BoxFit.fill)),
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: width / 1.6,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        width: width / 1.95,
                                                                                        child: Text(
                                                                                          surveyTitlesList[index],
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                        )),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        showModalBottomSheet(
                                                                                            shape: const RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.vertical(
                                                                                                top: Radius.circular(30),
                                                                                              ),
                                                                                            ),
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return SingleChildScrollView(
                                                                                                child: Container(
                                                                                                  margin:
                                                                                                      EdgeInsets.symmetric(horizontal: width / 18.75),
                                                                                                  padding: EdgeInsets.only(
                                                                                                      bottom:
                                                                                                          MediaQuery.of(context).viewInsets.bottom),
                                                                                                  child: surveyMyList[index]
                                                                                                      ? ListTile(
                                                                                                          onTap: () {
                                                                                                            if (!mounted) {
                                                                                                              return;
                                                                                                            }
                                                                                                            Navigator.pop(context);
                                                                                                            showDialog(
                                                                                                                barrierDismissible: false,
                                                                                                                context: context,
                                                                                                                builder: (BuildContext context) {
                                                                                                                  return Dialog(
                                                                                                                    shape: RoundedRectangleBorder(
                                                                                                                        borderRadius:
                                                                                                                            BorderRadius.circular(
                                                                                                                                20.0)),
                                                                                                                    //this right here
                                                                                                                    child: Container(
                                                                                                                      height: height / 6,
                                                                                                                      margin: EdgeInsets.symmetric(
                                                                                                                          vertical: height / 54.13,
                                                                                                                          horizontal: width / 25),
                                                                                                                      child: Column(
                                                                                                                        mainAxisAlignment:
                                                                                                                            MainAxisAlignment.center,
                                                                                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          const Center(
                                                                                                                              child: Text(
                                                                                                                                  "Delete Post",
                                                                                                                                  style: TextStyle(
                                                                                                                                      color: Color(
                                                                                                                                          0XFF0EA102),
                                                                                                                                      fontWeight:
                                                                                                                                          FontWeight
                                                                                                                                              .bold,
                                                                                                                                      fontSize: 20,
                                                                                                                                      fontFamily:
                                                                                                                                          "Poppins"))),
                                                                                                                          const Divider(),
                                                                                                                          const Center(
                                                                                                                              child: Text(
                                                                                                                                  "Are you sure to Delete this Post")),
                                                                                                                          const Spacer(),
                                                                                                                          Padding(
                                                                                                                            padding:
                                                                                                                                EdgeInsets.symmetric(
                                                                                                                                    horizontal:
                                                                                                                                        width / 25),
                                                                                                                            child: Row(
                                                                                                                              mainAxisAlignment:
                                                                                                                                  MainAxisAlignment
                                                                                                                                      .spaceBetween,
                                                                                                                              children: [
                                                                                                                                TextButton(
                                                                                                                                  onPressed: () {
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);
                                                                                                                                  },
                                                                                                                                  child: const Text(
                                                                                                                                    "Cancel",
                                                                                                                                    style: TextStyle(
                                                                                                                                        color: Colors
                                                                                                                                            .grey,
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight
                                                                                                                                                .w600,
                                                                                                                                        fontFamily:
                                                                                                                                            "Poppins",
                                                                                                                                        fontSize: 15),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                                ElevatedButton(
                                                                                                                                  style:
                                                                                                                                      ElevatedButton
                                                                                                                                          .styleFrom(
                                                                                                                                    shape:
                                                                                                                                        RoundedRectangleBorder(
                                                                                                                                      borderRadius:
                                                                                                                                          BorderRadius
                                                                                                                                              .circular(
                                                                                                                                                  18.0),
                                                                                                                                    ),
                                                                                                                                    backgroundColor:
                                                                                                                                        const Color(
                                                                                                                                            0XFF0EA102),
                                                                                                                                  ),
                                                                                                                                  onPressed:
                                                                                                                                      () async {
                                                                                                                                    deletePost(
                                                                                                                                        surveyId:
                                                                                                                                            surveyIdList[
                                                                                                                                                index]);
                                                                                                                                    Navigator.pop(
                                                                                                                                        context);
                                                                                                                                  },
                                                                                                                                  child: const Text(
                                                                                                                                    "Continue",
                                                                                                                                    style: TextStyle(
                                                                                                                                        color: Colors
                                                                                                                                            .white,
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight
                                                                                                                                                .w600,
                                                                                                                                        fontFamily:
                                                                                                                                            "Poppins",
                                                                                                                                        fontSize: 15),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          const Spacer(),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                });
                                                                                                          },
                                                                                                          minLeadingWidth: width / 25,
                                                                                                          leading: const Icon(
                                                                                                            Icons.delete,
                                                                                                            size: 20,
                                                                                                          ),
                                                                                                          title: Text(
                                                                                                            "Delete Post",
                                                                                                            style: TextStyle(
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: text.scale(14)),
                                                                                                          ),
                                                                                                        )
                                                                                                      : Column(
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          crossAxisAlignment:
                                                                                                              CrossAxisAlignment.start,
                                                                                                          children: [
                                                                                                            ListTile(
                                                                                                              onTap: () {
                                                                                                                if (!mounted) {
                                                                                                                  return;
                                                                                                                }
                                                                                                                Navigator.pop(context);
                                                                                                                _controller.clear();
                                                                                                                setState(() {
                                                                                                                  actionValue = "Report";
                                                                                                                });
                                                                                                                showAlertDialog(
                                                                                                                    context: context,
                                                                                                                    surveyId: surveyIdList[index],
                                                                                                                    surveyUserId:
                                                                                                                        surveyUserIdList[index]);
                                                                                                              },
                                                                                                              minLeadingWidth: width / 25,
                                                                                                              leading: const Icon(
                                                                                                                Icons.shield,
                                                                                                                size: 20,
                                                                                                              ),
                                                                                                              title: Text(
                                                                                                                "Report Post",
                                                                                                                style: TextStyle(
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    fontSize: text.scale(14)),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Divider(
                                                                                                              color: Theme.of(context)
                                                                                                                  .colorScheme
                                                                                                                  .tertiary,
                                                                                                              thickness: 0.8,
                                                                                                            ),
                                                                                                            ListTile(
                                                                                                              onTap: () {
                                                                                                                _controller.clear();
                                                                                                                setState(() {
                                                                                                                  actionValue = "Block";
                                                                                                                });
                                                                                                                if (!mounted) {
                                                                                                                  return;
                                                                                                                }
                                                                                                                Navigator.pop(context);
                                                                                                                showAlertDialog(
                                                                                                                    context: context,
                                                                                                                    surveyId: surveyIdList[index],
                                                                                                                    surveyUserId:
                                                                                                                        surveyUserIdList[index]);
                                                                                                              },
                                                                                                              minLeadingWidth: width / 25,
                                                                                                              leading: const Icon(
                                                                                                                Icons.flag,
                                                                                                                size: 20,
                                                                                                              ),
                                                                                                              title: Text(
                                                                                                                "Block Post",
                                                                                                                style: TextStyle(
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    fontSize: text.scale(14)),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                ),
                                                                                              );
                                                                                            });
                                                                                      },
                                                                                      child: const Padding(
                                                                                        padding: EdgeInsets.only(right: 8.0),
                                                                                        child: Icon(
                                                                                          Icons.more_horiz,
                                                                                          size: 20,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: height / 87.6,
                                                                              ),
                                                                              SizedBox(
                                                                                  width: width / 1.6,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: width / 1.95,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                                onTap: () {
                                                                                                  Navigator.push(context, MaterialPageRoute(
                                                                                                      builder: (BuildContext context) {
                                                                                                    return UserBillBoardProfilePage(
                                                                                                        userId: surveyUserIdList[
                                                                                                            index]) /*UserProfilePage(id:surveyUserIdList[index],type:'survey',index: 1,)*/;
                                                                                                  }));
                                                                                                },
                                                                                                child: Text(
                                                                                                  surveySourceNameList[index]
                                                                                                      .toString()
                                                                                                      .capitalizeFirst!,
                                                                                                  style: TextStyle(
                                                                                                      fontSize: text.scale(10),
                                                                                                      fontWeight: FontWeight.w500),
                                                                                                )),
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
                                                                                              surveyQuestionList[index].toString(),
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
                                                                                        ),
                                                                                      ),
                                                                                      widgetsMain.translationWidget(
                                                                                          translationList: surveyTranslationList,
                                                                                          id: surveyIdList[index],
                                                                                          type: 'survey',
                                                                                          index: index,
                                                                                          initFunction: getAllData,
                                                                                          context: context,
                                                                                          modelSetState: setState,
                                                                                          notUse: false,
                                                                                          titleList: surveyTitlesList),
                                                                                    ],
                                                                                  )),
                                                                              SizedBox(
                                                                                height: height / 87.6,
                                                                              ),
                                                                              SizedBox(
                                                                                width: width / 1.6,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: width / 1.95,
                                                                                      child: Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                              width: width / 7.5,
                                                                                              child: Text(surveyCompanyList[index],
                                                                                                  style: TextStyle(
                                                                                                      fontSize: text.scale(10),
                                                                                                      fontWeight: FontWeight.w700,
                                                                                                      color: Colors.blue))),
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
                                                                                                haveViewsMain =
                                                                                                    surveyViewsList[index] > 0 ? true : false;
                                                                                                viewCountMain = surveyViewsList[index];
                                                                                                kToken = mainUserToken;
                                                                                              });
                                                                                              //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionSurvey + viewsCount, idKey: 'survey_id', setState: setState);
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
                                                                                            child: Row(
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
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w700)),
                                                                                                Text(" Responses",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(10),
                                                                                                        fontWeight: FontWeight.w500)),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 8.0),
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
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    /*Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: (){
                                                        showModalBottomSheet(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.vertical(
                                                                top: Radius.circular(30),
                                                              ),
                                                            ),
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return SingleChildScrollView(
                                                                child: Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: _width/18.75),
                                                                  padding: EdgeInsets.only(
                                                                      bottom: MediaQuery.of(context)
                                                                          .viewInsets
                                                                          .bottom),
                                                                  child:surveyMyList[index]?
                                                                  ListTile(
                                                                    onTap: (){
                                                                      if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                                      showDialog(
                                                                          barrierDismissible: false,
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return Dialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      20.0)), //this right here
                                                                              child: Container(
                                                                                height:_height/6,
                                                                                margin: EdgeInsets.symmetric(vertical: _height/54.13,horizontal:_width/25 ),
                                                                                child: Column(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Center(
                                                                                        child: Text(
                                                                                            "Delete Post",
                                                                                            style: TextStyle(
                                                                                                color: Color(
                                                                                                    0XFF0EA102),
                                                                                                fontWeight:
                                                                                                FontWeight.bold,
                                                                                                fontSize: 20,
                                                                                                fontFamily:
                                                                                                "Poppins"))),
                                                                                    Divider(),
                                                                                    Container(
                                                                                        child: Center(child: Text("Are you sure to Delete this Post"))),
                                                                                    Spacer(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets
                                                                                          .symmetric(
                                                                                          horizontal: _width/25),
                                                                                      child: Row(
                                                                                        mainAxisAlignment:
                                                                                        MainAxisAlignment
                                                                                            .spaceBetween,
                                                                                        children: [
                                                                                          TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(
                                                                                                  context);
                                                                                            },
                                                                                            child: Text(
                                                                                              "Cancel",
                                                                                              style: TextStyle(
                                                                                                  color:
                                                                                                  Colors.grey,
                                                                                                  fontWeight:
                                                                                                  FontWeight
                                                                                                      .w600,
                                                                                                  fontFamily:
                                                                                                  "Poppins",
                                                                                                  fontSize: 15),
                                                                                            ),
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              shape:
                                                                                              RoundedRectangleBorder(
                                                                                                borderRadius:
                                                                                                BorderRadius
                                                                                                    .circular(
                                                                                                    18.0),
                                                                                              ),
                                                                                              backgroundColor: Color(0XFF0EA102),
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              deletePost(surveyId: surveyIdList[index]);
                                                                                              if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                                                            },
                                                                                            child: Text(
                                                                                              "Continue",
                                                                                              style: TextStyle(
                                                                                                  color: Colors
                                                                                                      .white,
                                                                                                  fontWeight:
                                                                                                  FontWeight
                                                                                                      .w600,
                                                                                                  fontFamily:
                                                                                                  "Poppins",
                                                                                                  fontSize:
                                                                                                  15),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Spacer(),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                    },
                                                                    minLeadingWidth: _width/25,
                                                                    leading: Icon(Icons.delete,size: 20,),
                                                                    title: Text("Delete Post",style: TextStyle(fontWeight: FontWeight.w500,fontSize: _text*14),),
                                                                  ):
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.start,
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      ListTile(
                                                                        onTap: (){
                                                                          if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                                          _controller.clear();
                                                                          setState(() {
                                                                            actionValue="Report";
                                                                          });
                                                                          showAlertDialog(context:context,surveyId: surveyIdList[index],surveyUserId: surveyUserIdList[index]);
                                                                        },
                                                                        minLeadingWidth: _width/25,
                                                                        leading: Icon(Icons.shield,size: 20,),
                                                                        title: Text("Report Post",style: TextStyle(fontWeight: FontWeight.w500,fontSize: _text*14),),
                                                                      ),
                                                                      Divider(thickness: 0.0,height: 0.0,),
                                                                      ListTile(
                                                                        onTap: (){
                                                                          _controller.clear();
                                                                          setState(() {
                                                                            actionValue="Block";
                                                                          });
                                                                          if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                                          showAlertDialog(context:context,surveyId: surveyIdList[index],surveyUserId:surveyUserIdList[index]);
                                                                        },
                                                                        minLeadingWidth: _width/25,
                                                                        leading: Icon(Icons.flag,size: 20,),
                                                                        title: Text("Block Post",style: TextStyle(fontWeight: FontWeight.w500,fontSize: _text*14),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets.only(right:_width/23.4375 ),
                                                          child: Icon(Icons.more_horiz,size: 20,)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right:_width/35,top:10 ),
                                                      child: widgetsMain.translationWidget(translationList: surveyTranslationList, id: surveyIdList[index],type: 'survey', index: index, initFunction: getAllData, context: context, modelSetState: setState, notUse: false, titleList: surveyTitlesList),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right:_width/23.4375,top:10 ),
                                                      child: bookMarkWidget(bookMark: surveyBookMarkList, context: context,scale: 3.2, id: surveyIdList[index], type: 'survey', modelSetState: setState, index: index, initFunction: getAllData, notUse: false),
                                                    ),
                                                  ],
                                                ),*/
                                                                  ],
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
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  logEventFunc(name: 'Survey_Start', type: 'Survey');
                  bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return SurveyPostPage(
                      text: selectedValue,
                    );
                  }));
                  if (response) {
                    await getSurveyValues(text: "", category: finalisedCategory, filterId: finalisedFilterId);
                  }
                },
                backgroundColor: const Color(0XFF0EA102),
                child: const Icon(Icons.add),
              ),
            ),
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
                            /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return UserProfilePage(id:surveyViewedIdList[index] , type:'survey', index:1);}));*/
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
