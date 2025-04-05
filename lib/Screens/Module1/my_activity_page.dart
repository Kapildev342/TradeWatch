import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'Settings/EditProfilePage/edit_profile_page.dart';
import 'WatchList/add_watch_list_page.dart';
import 'bottom_navigation.dart';
import 'notifications_page.dart';

class MyActivityPage extends StatefulWidget {
  final bool fromLink;

  const MyActivityPage({Key? key, this.fromLink = false}) : super(key: key);

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  late Future<ActivityList> futureNotificationList;
  bool loading = false;
  String mainUserToken = "";
  String mainUserId = "";
  String categoryTitle = "";
  Map<String, dynamic> notify = {};
  var time = '';
  List<String> timeList = [];
  late ActivityList fetchMaterial;
  String activeStatus = "";
  bool answerStatus = false;
  int answeredQuestion = 0;
  Map<String, dynamic> activityResponse = {};
  bool activityResponseStatus = false;
  String activityResponseCategory = "";
  String activityResponseExchange = "";
  int newIndex = 0;
  int excIndex = 0;
  int countryIndex = 0;
  List<String> countryList = ["India", "USA"];
  List<String> mainExchangeIdList = [];
  bool disableMultipleTap = false;
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  Future<ActivityList> activityList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    mainUserToken = preferences.getString('newUserToken') ?? "";
    mainUserId = preferences.getString('newUserId') ?? "";
    nativeAdList.clear();
    nativeAdIsLoadedList.clear();
    var url = Uri.parse(baseurl + versions + activity);
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"userId": userIdMain});
    notify = jsonDecode(response.body);
    if (notify["response"].length == 0) {
    } else {
      for (int i = 0; i < notify["response"].length; i++) {
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
        DateTime dt = DateTime.parse(notify["response"][i]["createdAt"]);
        final timestamp1 = dt.millisecondsSinceEpoch;
        readTimestamp(timestamp1);
      }
    }
    return ActivityList.fromJson(notify);
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

  Future getIdData({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"id": id, "type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          categoryTitle = responseData["response"]["category"];
        });
      }
    } else {}
    return responseData;
  }

  Future getNotify({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionWatch + watchListNotifyCheck);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"notification_id": id});
    var responseData = json.decode(response.body);
    return responseData;
  }

  Future getWatch({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionWatch + watchListGetCheck);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"watch_id": id});
    var responseData = json.decode(response.body);
    return responseData;
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            mainExchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  statusFunc({required String surveyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
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
  void initState() {
    getAllDataMain(name: 'My_Activity');
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getEx();
    getNotifyCountAndImage();
    fetchMaterial = await activityList();
    setState(() {
      loading = true;
    });
  }

  @override
  void dispose() {
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
        if (widget.fromLink) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                        text: '',
                        caseNo1: 4,
                        tType: true,
                        newIndex: 0,
                        excIndex: 1,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                      )));
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Container(
        // color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            //backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              //backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              toolbarHeight: height / 9.44,
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
                                onTap: () async {
                                  if (widget.fromLink) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => const MainBottomNavigationPage(
                                                  text: '',
                                                  caseNo1: 4,
                                                  tType: true,
                                                  newIndex: 0,
                                                  excIndex: 1,
                                                  countryIndex: 0,
                                                  isHomeFirstTym: false,
                                                )));
                                  } else {
                                    if (!mounted) {
                                      return;
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 30,
                                )),
                            Text(
                              "My Activity",
                              style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
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
                ],
              ),
              elevation: 0.0,
            ),
            body: loading
                ? SingleChildScrollView(
                    child: fetchMaterial.response.isEmpty
                        ? Container(
                            height: height / 1.4,
                            width: width,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                                child: Text(
                              'No Activities Available',
                              style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(18)),
                            )))
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: height / 54.13),
                            physics: const ScrollPhysics(),
                            itemCount: fetchMaterial.response.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                                return Column(
                                  children: [
                                    Container(
                                        height: height / 9.10,
                                        margin: const EdgeInsets.symmetric(horizontal: 15),
                                        child: AdWidget(ad: nativeAdList[index])),
                                    SizedBox(height: height / 57.73),
                                    Column(
                                      children: [
                                        index == 0
                                            ? Container(
                                                margin: EdgeInsets.only(bottom: height / 54.13),
                                                alignment: Alignment.centerLeft,
                                                height: height / 20.3,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    //  color: Colors.white
                                                    color: const Color(0xffB0B0B0).withOpacity(0.1)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: width / 23.43),
                                                  child: Text(
                                                    fetchMaterial.response[index].day,
                                                    style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                                  ),
                                                ))
                                            : fetchMaterial.response[index].day == fetchMaterial.response[index - 1].day
                                                ? const SizedBox()
                                                : Container(
                                                    margin: EdgeInsets.only(bottom: height / 54.13),
                                                    alignment: Alignment.centerLeft,
                                                    height: height / 20.3,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        //  color: Colors.white
                                                        color: const Color(0xffB0B0B0).withOpacity(0.1)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: width / 23.43),
                                                      child: Text(
                                                        fetchMaterial.response[index].day,
                                                        style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                                      ),
                                                    )),
                                        Container(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: ListTile(
                                            onTap: () async {
                                              if (disableMultipleTap) {
                                              } else {
                                                setState(() {
                                                  disableMultipleTap = true;
                                                });
                                                if (fetchMaterial.response[index].type == 'forums' ||
                                                    fetchMaterial.response[index].type == 'survey' ||
                                                    fetchMaterial.response[index].type == 'feature') {
                                                  activityResponse = await getIdData(
                                                      type: fetchMaterial.response[index].type, id: fetchMaterial.response[index].typeId);
                                                  activityResponseStatus = activityResponse["status"];
                                                } else if (fetchMaterial.response[index].type == 'watch_notification') {
                                                  activityResponse = await getNotify(id: fetchMaterial.response[index].typeId);
                                                  activityResponseStatus = activityResponse["status"];
                                                  if (activityResponseStatus) {
                                                    activityResponse["response"]["category"] == "stocks"
                                                        ? newIndex = 0
                                                        : activityResponse["response"]["category"] == "crypto"
                                                            ? newIndex = 1
                                                            : activityResponse["response"]["category"] == "commodity"
                                                                ? newIndex = 2
                                                                : activityResponse["response"]["category"] == "forex"
                                                                    ? newIndex = 3
                                                                    : newIndex = 0;
                                                    if (activityResponse["response"]["category"] == "stocks") {
                                                      for (int i = 0; i < mainExchangeIdList.length; i++) {
                                                        if (mainExchangeIdList[i] == activityResponse["response"]["exchange_id"]) {
                                                          setState(() {
                                                            excIndex = i;
                                                          });
                                                        }
                                                      }
                                                    } else if (activityResponse["response"]["category"] == "commodity") {
                                                      for (int i = 0; i < countryList.length; i++) {
                                                        if (countryList[i] == activityResponse["response"]["country"]) {
                                                          setState(() {
                                                            countryIndex = i;
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      excIndex = 0;
                                                    }
                                                  }
                                                } else if (fetchMaterial.response[index].type == 'watch') {
                                                  activityResponse = await getWatch(id: fetchMaterial.response[index].typeId);
                                                  activityResponseStatus = activityResponse["status"];
                                                  if (activityResponseStatus) {
                                                    activityResponse["response"]["category"] == "stocks"
                                                        ? newIndex = 0
                                                        : activityResponse["response"]["category"] == "crypto"
                                                            ? newIndex = 1
                                                            : activityResponse["response"]["category"] == "commodity"
                                                                ? newIndex = 2
                                                                : activityResponse["response"]["category"] == "forex"
                                                                    ? newIndex = 3
                                                                    : newIndex = 0;
                                                    if (activityResponse["response"]["category"] == "stocks") {
                                                      for (int i = 0; i < mainExchangeIdList.length; i++) {
                                                        if (mainExchangeIdList[i] == activityResponse["response"]["exchange_id"]) {
                                                          setState(() {
                                                            excIndex = i;
                                                          });
                                                        }
                                                      }
                                                    } else if (activityResponse["response"]["category"] == "commodity") {
                                                      for (int i = 0; i < countryList.length; i++) {
                                                        if (countryList[i] == activityResponse["response"]["country"]) {
                                                          setState(() {
                                                            countryIndex = i;
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      excIndex = 0;
                                                    }
                                                  }
                                                } else {
                                                  activityResponseStatus = true;
                                                }
                                                if (activityResponseStatus) {
                                                  fetchMaterial.response[index].type == 'survey'
                                                      ? await statusFunc(surveyId: fetchMaterial.response[index].typeId)
                                                      : debugPrint("nothing");
                                                  if (fetchMaterial.response[index].type == 'news') {
                                                    /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return DemoPage(
                                                        url: "",
                                                        text: "",
                                                        image: "",
                                                        id: fetchMaterial.response[index].typeId,
                                                        type: 'news',
                                                        activity: true,
                                                      );
                                                    }));*/
                                                    Get.to(const DemoView(),
                                                        arguments: {"id": fetchMaterial.response[index].typeId, "type": "news", "url": ""});
                                                  } else if (fetchMaterial.response[index].type == 'videos') {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return YoutubePlayerLandscapeScreen(
                                                        comeFrom: "activity",
                                                        id: fetchMaterial.response[index].typeId,
                                                      );
                                                    }));
                                                  } else if (fetchMaterial.response[index].type == 'forums') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          blockBool: false,
                                                          tabIndex: 0,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return ForumPostDescriptionPage(
                                                          forumId: fetchMaterial.response[index].typeId,
                                                          comeFrom: 'activity',
                                                          idList: const [],
                                                        );
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return ForumPostDescriptionPage(
                                                          forumId: fetchMaterial.response[index].typeId,
                                                          comeFrom: 'activity',
                                                          idList: const [],
                                                        );
                                                      }));
                                                    }
                                                  } else if (fetchMaterial.response[index].type == 'feature') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          tabIndex: 2,
                                                          blockBool: false,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return FeaturePostDescriptionPage(
                                                          sortValue: 'Recent',
                                                          featureDetail: '',
                                                          featureId: fetchMaterial.response[index].typeId,
                                                          navBool: 'activity',
                                                          idList: const [],
                                                        );
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return FeaturePostDescriptionPage(
                                                          sortValue: 'Recent',
                                                          featureDetail: '',
                                                          featureId: fetchMaterial.response[index].typeId,
                                                          navBool: 'activity',
                                                          idList: const [],
                                                        );
                                                      }));
                                                    }
                                                  } else if (fetchMaterial.response[index].type == 'survey') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          blockBool: false,
                                                          tabIndex: 1,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      fetchMaterial.response[index].user.id == mainUserId
                                                          ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].typeId,
                                                                surveyTitle: fetchMaterial.response[index].name,
                                                                activity: true,
                                                              );
                                                            }))
                                                          : activeStatus == 'active'
                                                              ? answerStatus
                                                                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                        surveyId: fetchMaterial.response[index].typeId,
                                                                        activity: true,
                                                                        surveyTitle: fetchMaterial.response[index].name,
                                                                      );
                                                                    }))
                                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return QuestionnairePage(
                                                                        surveyId: fetchMaterial.response[index].typeId,
                                                                        defaultIndex: answeredQuestion,
                                                                      );
                                                                    }))
                                                              : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return AnalyticsPage(
                                                                      surveyId: fetchMaterial.response[index].typeId,
                                                                      activity: true,
                                                                      surveyTitle: fetchMaterial.response[index].name);
                                                                }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      fetchMaterial.response[index].user.id == mainUserId
                                                          ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].typeId,
                                                                surveyTitle: fetchMaterial.response[index].name,
                                                                activity: true,
                                                              );
                                                            }))
                                                          : activeStatus == 'active'
                                                              ? answerStatus
                                                                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                        surveyId: fetchMaterial.response[index].typeId,
                                                                        activity: true,
                                                                        surveyTitle: fetchMaterial.response[index].name,
                                                                      );
                                                                    }))
                                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return QuestionnairePage(
                                                                        surveyId: fetchMaterial.response[index].typeId,
                                                                        defaultIndex: answeredQuestion,
                                                                      );
                                                                    }))
                                                              : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return AnalyticsPage(
                                                                      surveyId: fetchMaterial.response[index].typeId,
                                                                      activity: true,
                                                                      surveyTitle: fetchMaterial.response[index].name);
                                                                }));
                                                    }
                                                  } else if (fetchMaterial.response[index].type == 'watch') {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return MainBottomNavigationPage(
                                                        tType: true,
                                                        text: "",
                                                        caseNo1: 3,
                                                        newIndex: newIndex,
                                                        excIndex: excIndex,
                                                        countryIndex: countryIndex,
                                                        isHomeFirstTym: false,
                                                      );
                                                    }));
                                                  } else if (fetchMaterial.response[index].type == 'watch_notification') {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    activityResponse["message"] == "Watchlist found."
                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return MainBottomNavigationPage(
                                                              tType: true,
                                                              text: "",
                                                              caseNo1: 3,
                                                              newIndex: newIndex,
                                                              excIndex: excIndex,
                                                              countryIndex: countryIndex,
                                                              isHomeFirstTym: false,
                                                            );
                                                          }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AddWatchlistPage(
                                                              newIndex: newIndex,
                                                              excIndex: excIndex,
                                                              countryIndex: countryIndex,
                                                            );
                                                          }));
                                                  } else if (fetchMaterial.response[index].type == 'user') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          tabIndex: 0,
                                                          blockBool: true,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      //await checkUser(uId: fetchMaterial.response[index].typeId, uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(
                                                            userId: fetchMaterial
                                                                .response[index].user.id) /*UserProfilePage(id: uId, type: uType, index: index)*/;
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'believed') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: fetchMaterial.response[index].user.id);
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const EditProfilePage(
                                                          comeFrom: true,
                                                        );
                                                      }));
                                                    }
                                                  } else if (fetchMaterial.response[index].type == 'billboard') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          tabIndex: 0,
                                                          blockBool: true,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                      if (fetchMaterial.response[index].name.contains("a byte")) {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BytesDescriptionPage();
                                                        }));
                                                      } else {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BlogDescriptionPage();
                                                        }));
                                                      }
                                                    } else if (fetchMaterial.response[index].activity == 'Create') {
                                                      mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                      if (fetchMaterial.response[index].name.contains("a byte")) {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BytesDescriptionPage();
                                                        }));
                                                      } else {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BlogDescriptionPage();
                                                        }));
                                                      }
                                                    } else {
                                                      mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                      if (fetchMaterial.response[index].name.contains("a byte")) {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BytesDescriptionPage();
                                                        }));
                                                      } else {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BlogDescriptionPage();
                                                        }));
                                                      }
                                                    }
                                                  } else {
                                                    if (!mounted) {
                                                      return;
                                                    }
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
                                                } else {
                                                  if (activityResponse["type"] == 'forums') {
                                                    if (activityResponse["activity"] == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          blockBool: false,
                                                          tabIndex: 0,
                                                        );
                                                      }));
                                                    } else if (activityResponse["activity"] == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return ForumPostDescriptionPage(
                                                          forumId: fetchMaterial.response[index].typeId,
                                                          comeFrom: 'activity',
                                                          idList: const [],
                                                        );
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
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
                                                  } else if (activityResponse["type"] == 'feature') {
                                                    if (activityResponse["activity"] == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          tabIndex: 2,
                                                          blockBool: false,
                                                        );
                                                      }));
                                                    } else if (activityResponse["activity"] == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return FeaturePostDescriptionPage(
                                                          sortValue: 'Recent',
                                                          featureDetail: '',
                                                          featureId: fetchMaterial.response[index].typeId,
                                                          navBool: 'activity',
                                                          idList: const [],
                                                        );
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
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
                                                  } else if (activityResponse["type"] == 'survey') {
                                                    if (activityResponse["activity"] == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          blockBool: false,
                                                          tabIndex: 1,
                                                        );
                                                      }));
                                                    } else if (activityResponse["activity"] == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      fetchMaterial.response[index].user.id == mainUserId
                                                          ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].typeId,
                                                                surveyTitle: fetchMaterial.response[index].name,
                                                                activity: true,
                                                              );
                                                            }))
                                                          : activeStatus == 'active'
                                                              ? answerStatus
                                                                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                        surveyId: fetchMaterial.response[index].typeId,
                                                                        activity: true,
                                                                        surveyTitle: fetchMaterial.response[index].name,
                                                                      );
                                                                    }))
                                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return QuestionnairePage(
                                                                        surveyId: fetchMaterial.response[index].typeId,
                                                                        defaultIndex: answeredQuestion,
                                                                      );
                                                                    }))
                                                              : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return AnalyticsPage(
                                                                      surveyId: fetchMaterial.response[index].typeId,
                                                                      activity: true,
                                                                      surveyTitle: fetchMaterial.response[index].name);
                                                                }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
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
                                                  } else if (fetchMaterial.response[index].type == 'watch_notification') {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Flushbar(
                                                      message: "Notification alert removed by you",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                  } else if (fetchMaterial.response[index].type == 'watch') {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return const MainBottomNavigationPage(
                                                        tType: true,
                                                        newIndex: 0,
                                                        countryIndex: 0,
                                                        excIndex: 1,
                                                        text: '',
                                                        caseNo1: 3,
                                                        isHomeFirstTym: false,
                                                      );
                                                    }));
                                                    Flushbar(
                                                      message: "Ticker got removed from watchlist ",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                  } else if (fetchMaterial.response[index].type == 'user') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          tabIndex: 0,
                                                          blockBool: true,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      await checkUser(
                                                          uId: fetchMaterial.response[index].typeId,
                                                          uType: 'forums',
                                                          mainUserToken: mainUserToken,
                                                          context: context,
                                                          index: 0);
                                                    } else if (fetchMaterial.response[index].activity == 'believed') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: fetchMaterial.response[index].user.id);
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const EditProfilePage(
                                                          comeFrom: true,
                                                        );
                                                      }));
                                                    }
                                                  } else if (fetchMaterial.response[index].type == 'billboard') {
                                                    if (fetchMaterial.response[index].activity == 'blocked') {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return const BlockListPage(
                                                          tabIndex: 0,
                                                          blockBool: true,
                                                        );
                                                      }));
                                                    } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                      mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                      if (fetchMaterial.response[index].name.contains("a byte")) {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BytesDescriptionPage();
                                                        }));
                                                      } else {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BlogDescriptionPage();
                                                        }));
                                                      }
                                                    } else if (fetchMaterial.response[index].activity == 'Create') {
                                                      mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                      if (fetchMaterial.response[index].name.contains("a byte")) {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BytesDescriptionPage();
                                                        }));
                                                      } else {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BlogDescriptionPage();
                                                        }));
                                                      }
                                                    } else {
                                                      mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                      if (fetchMaterial.response[index].name.contains("a byte")) {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BytesDescriptionPage();
                                                        }));
                                                      } else {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const BlogDescriptionPage();
                                                        }));
                                                      }
                                                    }
                                                  } else {}
                                                }
                                                setState(() {
                                                  disableMultipleTap = false;
                                                });
                                              }
                                            },
                                            leading: Stack(
                                              children: [
                                                SizedBox(
                                                  height: height / 16,
                                                  width: width / 6.2,
                                                ),
                                                Positioned(
                                                  left: 0,
                                                  bottom: 0,
                                                  child: Container(
                                                    height: height / 17.84,
                                                    width: width / 6.62,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(fetchMaterial.response[index].user.avatar), fit: BoxFit.fill)),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            image: functionsMain.badgeImage(
                                                                activity: fetchMaterial.response[index].activity,
                                                                type: fetchMaterial.response[index].type),
                                                            fit: BoxFit.fill)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            title: Text(
                                              fetchMaterial.response[index].name,
                                              style: TextStyle(
                                                  fontSize: text.scale(12), fontWeight: FontWeight.w500, fontFamily: "Poppins", color: Colors.black),
                                            )
                                            /*RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: fetchMaterial.response[index].activity=="update"||
                                                fetchMaterial.response[index].activity=="change password"||
                                                fetchMaterial.response[index].activity=="blocked"||
                                                fetchMaterial.response[index].activity=="unblocked"||
                                                fetchMaterial.response[index].type=="watch_notification"||
                                                fetchMaterial.response[index].type=="watch"
                                                ?"":'You ',
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                            fetchMaterial.response[index].activity=="liked"?"liked":
                                            fetchMaterial.response[index].activity=="disliked"?"disliked":
                                            fetchMaterial.response[index].activity=="shared"?"shared":
                                            fetchMaterial.response[index].activity=="viewed"?"viewed":
                                            fetchMaterial.response[index].activity=="dislike removed"?"removed the dislike":
                                            fetchMaterial.response[index].activity=="like removed"?"removed the like":
                                            fetchMaterial.response[index].activity=="Create"?
                                            fetchMaterial.response[index].type=="watch_notification"||fetchMaterial.response[index].type=="watch"?"":"created":
                                            fetchMaterial.response[index].activity=="update"?"":
                                            fetchMaterial.response[index].activity=="answered"?"answered":
                                            fetchMaterial.response[index].activity=="Delete"?fetchMaterial.response[index].type=="watch_notification"||fetchMaterial.response[index].type=="watch"?"":"deleted":
                                            fetchMaterial.response[index].activity=="responded"?"responded":
                                            fetchMaterial.response[index].activity=="change password"?"":
                                            fetchMaterial.response[index].activity=="unblocked"?"":
                                            fetchMaterial.response[index].type=="forum response"||fetchMaterial.response[index].type=="feature response"?
                                            fetchMaterial.response[index].activity=="blocked"?"blocked":
                                            fetchMaterial.response[index].activity=="reported"?"reported":
                                            fetchMaterial.response[index].activity=="response removed"?"removed":"":
                                            fetchMaterial.response[index].activity=="blocked"?"": "",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:fetchMaterial.response[index].activity=="update"||
                                                fetchMaterial.response[index].activity=="change password"||
                                                fetchMaterial.response[index].activity=="blocked"||
                                                fetchMaterial.response[index].activity=="unblocked"||
                                                fetchMaterial.response[index].type=="watch_notification"||
                                                fetchMaterial.response[index].type=="watch"
                                            ?"":" ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          fetchMaterial.response[index].type=="news"?
                                          TextSpan(
                                            text: " ${fetchMaterial.response[index].type} ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ):
                                          fetchMaterial.response[index].type=="videos"?
                                          TextSpan(
                                            text:"video ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ):
                                          fetchMaterial.response[index].activity=="update"||
                                              fetchMaterial.response[index].activity=="change password"||
                                              fetchMaterial.response[index].activity=="blocked"||
                                              fetchMaterial.response[index].activity=="unblocked"||
                                              fetchMaterial.response[index].type=="watch_notification"||
                                              fetchMaterial.response[index].type=="watch"
                                              ?
                                          TextSpan(
                                            text:"",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ):
                                          TextSpan(
                                         text:fetchMaterial.response[index].user.id==mainUserId?
                                         "your ":
                                         "${fetchMaterial.response[index].user.username}'s ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${
                                              fetchMaterial.response[index].name
                                            } ',
                                            style:fetchMaterial.response[index].activity=="update"||
                                                fetchMaterial.response[index].activity=="change password"||
                                                fetchMaterial.response[index].activity=="blocked"||
                                                fetchMaterial.response[index].activity=="unblocked"?
                                            TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black):
                                            TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          fetchMaterial.response[index].type == 'news' ||
                                              fetchMaterial.response[index].type == 'videos'||
                                              fetchMaterial.response[index].type=="watch_notification"||
                                              fetchMaterial.response[index].type=="watch" ?
                                          TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                      fontSize: _text.scale(8)12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Poppins",
                                                      color: Colors.black),
                                                ) :
                                          TextSpan(
                                            text: fetchMaterial.response[index].type == 'forums'?'Forum':
                                            fetchMaterial.response[index].type == 'survey'?"Survey":
                                            fetchMaterial.response[index].type == 'feature'?"Feature Request":
                                            fetchMaterial.response[index].type == 'forum response'?"forum's response":
                                            fetchMaterial.response[index].type == 'feature response'?"feature's response":
                                            '',
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight:
                                                FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                        ]),
                                      )*/
                                            ,
                                            subtitle: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  timeList[index],
                                                  style: TextStyle(
                                                      fontSize: text.scale(10),
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w400,
                                                      color: const Color(0xffA9A9A9)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider()
                                      ],
                                    )
                                  ],
                                );
                              }
                              return Column(
                                children: [
                                  index == 0
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: height / 54.13),
                                          alignment: Alignment.centerLeft,
                                          height: height / 20.3,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              //  color: Colors.white
                                              color: const Color(0xffB0B0B0).withOpacity(0.1)),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: width / 23.43),
                                            child: Text(
                                              fetchMaterial.response[index].day,
                                              style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                            ),
                                          ))
                                      : fetchMaterial.response[index].day == fetchMaterial.response[index - 1].day
                                          ? const SizedBox()
                                          : Container(
                                              margin: EdgeInsets.only(bottom: height / 54.13),
                                              alignment: Alignment.centerLeft,
                                              height: height / 20.3,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  //  color: Colors.white
                                                  color: const Color(0xffB0B0B0).withOpacity(0.1)),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: width / 23.43),
                                                child: Text(
                                                  fetchMaterial.response[index].day,
                                                  style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                                ),
                                              )),
                                  Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: ListTile(
                                      onTap: () async {
                                        if (disableMultipleTap) {
                                        } else {
                                          setState(() {
                                            disableMultipleTap = true;
                                          });
                                          if (fetchMaterial.response[index].type == 'forums' ||
                                              fetchMaterial.response[index].type == 'survey' ||
                                              fetchMaterial.response[index].type == 'feature') {
                                            activityResponse =
                                                await getIdData(type: fetchMaterial.response[index].type, id: fetchMaterial.response[index].typeId);
                                            activityResponseStatus = activityResponse["status"];
                                          } else if (fetchMaterial.response[index].type == 'watch_notification') {
                                            activityResponse = await getNotify(id: fetchMaterial.response[index].typeId);
                                            activityResponseStatus = activityResponse["status"];
                                            if (activityResponseStatus) {
                                              activityResponse["response"]["category"] == "stocks"
                                                  ? newIndex = 0
                                                  : activityResponse["response"]["category"] == "crypto"
                                                      ? newIndex = 1
                                                      : activityResponse["response"]["category"] == "commodity"
                                                          ? newIndex = 2
                                                          : activityResponse["response"]["category"] == "forex"
                                                              ? newIndex = 3
                                                              : newIndex = 0;
                                              if (activityResponse["response"]["category"] == "stocks") {
                                                for (int i = 0; i < mainExchangeIdList.length; i++) {
                                                  if (mainExchangeIdList[i] == activityResponse["response"]["exchange_id"]) {
                                                    setState(() {
                                                      excIndex = i;
                                                    });
                                                  }
                                                }
                                              } else if (activityResponse["response"]["category"] == "commodity") {
                                                for (int i = 0; i < countryList.length; i++) {
                                                  if (countryList[i] == activityResponse["response"]["country"]) {
                                                    setState(() {
                                                      countryIndex = i;
                                                    });
                                                  }
                                                }
                                              } else {
                                                excIndex = 0;
                                              }
                                            }
                                          } else if (fetchMaterial.response[index].type == 'watch') {
                                            activityResponse = await getWatch(id: fetchMaterial.response[index].typeId);
                                            activityResponseStatus = activityResponse["status"];
                                            if (activityResponseStatus) {
                                              activityResponse["response"]["category"] == "stocks"
                                                  ? newIndex = 0
                                                  : activityResponse["response"]["category"] == "crypto"
                                                      ? newIndex = 1
                                                      : activityResponse["response"]["category"] == "commodity"
                                                          ? newIndex = 2
                                                          : activityResponse["response"]["category"] == "forex"
                                                              ? newIndex = 3
                                                              : newIndex = 0;
                                              if (activityResponse["response"]["category"] == "stocks") {
                                                for (int i = 0; i < mainExchangeIdList.length; i++) {
                                                  if (mainExchangeIdList[i] == activityResponse["response"]["exchange_id"]) {
                                                    setState(() {
                                                      excIndex = i;
                                                    });
                                                  }
                                                }
                                              } else if (activityResponse["response"]["category"] == "commodity") {
                                                for (int i = 0; i < countryList.length; i++) {
                                                  if (countryList[i] == activityResponse["response"]["country"]) {
                                                    setState(() {
                                                      countryIndex = i;
                                                    });
                                                  }
                                                }
                                              } else {
                                                excIndex = 0;
                                              }
                                            }
                                          } else {
                                            activityResponseStatus = true;
                                          }
                                          if (activityResponseStatus) {
                                            fetchMaterial.response[index].type == 'survey'
                                                ? await statusFunc(surveyId: fetchMaterial.response[index].typeId)
                                                : debugPrint("nothing");
                                            if (fetchMaterial.response[index].type == 'news') {
                                              if (!mounted) {
                                                return;
                                              }
                                              /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return DemoPage(
                                                  url: "",
                                                  text: "",
                                                  image: "",
                                                  id: fetchMaterial.response[index].typeId,
                                                  type: 'news',
                                                  activity: true,
                                                );
                                              }));*/
                                              Get.to(const DemoView(),
                                                  arguments: {"id": fetchMaterial.response[index].typeId, "type": "news", "url": ""});
                                            } else if (fetchMaterial.response[index].type == 'videos') {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return YoutubePlayerLandscapeScreen(
                                                  comeFrom: "activity",
                                                  id: fetchMaterial.response[index].typeId,
                                                );
                                              }));
                                            } else if (fetchMaterial.response[index].type == 'forums') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    blockBool: false,
                                                    tabIndex: 0,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return ForumPostDescriptionPage(
                                                    forumId: fetchMaterial.response[index].typeId,
                                                    comeFrom: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return ForumPostDescriptionPage(
                                                    forumId: fetchMaterial.response[index].typeId,
                                                    comeFrom: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              }
                                            } else if (fetchMaterial.response[index].type == 'feature') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 2,
                                                    blockBool: false,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FeaturePostDescriptionPage(
                                                    sortValue: 'Recent',
                                                    featureDetail: '',
                                                    featureId: fetchMaterial.response[index].typeId,
                                                    navBool: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FeaturePostDescriptionPage(
                                                    sortValue: 'Recent',
                                                    featureDetail: '',
                                                    featureId: fetchMaterial.response[index].typeId,
                                                    navBool: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              }
                                            } else if (fetchMaterial.response[index].type == 'survey') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    blockBool: false,
                                                    tabIndex: 1,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                fetchMaterial.response[index].user.id == mainUserId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: fetchMaterial.response[index].typeId,
                                                          surveyTitle: fetchMaterial.response[index].name,
                                                          activity: true,
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: fetchMaterial.response[index].typeId,
                                                                  activity: true,
                                                                  surveyTitle: fetchMaterial.response[index].name,
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: fetchMaterial.response[index].typeId,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].typeId,
                                                                activity: true,
                                                                surveyTitle: fetchMaterial.response[index].name);
                                                          }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
                                                fetchMaterial.response[index].user.id == mainUserId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: fetchMaterial.response[index].typeId,
                                                          surveyTitle: fetchMaterial.response[index].name,
                                                          activity: true,
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: fetchMaterial.response[index].typeId,
                                                                  activity: true,
                                                                  surveyTitle: fetchMaterial.response[index].name,
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: fetchMaterial.response[index].typeId,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].typeId,
                                                                activity: true,
                                                                surveyTitle: fetchMaterial.response[index].name);
                                                          }));
                                              }
                                            } else if (fetchMaterial.response[index].type == 'watch') {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return MainBottomNavigationPage(
                                                  tType: true,
                                                  text: "",
                                                  caseNo1: 3,
                                                  newIndex: newIndex,
                                                  excIndex: excIndex,
                                                  countryIndex: countryIndex,
                                                  isHomeFirstTym: false,
                                                );
                                              }));
                                            } else if (fetchMaterial.response[index].type == 'watch_notification') {
                                              if (!mounted) {
                                                return;
                                              }
                                              activityResponse["message"] == "Watchlist found."
                                                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return MainBottomNavigationPage(
                                                        tType: true,
                                                        text: "",
                                                        caseNo1: 3,
                                                        newIndex: newIndex,
                                                        excIndex: excIndex,
                                                        countryIndex: countryIndex,
                                                        isHomeFirstTym: false,
                                                      );
                                                    }))
                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return AddWatchlistPage(
                                                        newIndex: newIndex,
                                                        excIndex: excIndex,
                                                        countryIndex: countryIndex,
                                                      );
                                                    }));
                                            } else if (fetchMaterial.response[index].type == 'user') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                //await checkUser(uId: fetchMaterial.response[index].typeId, uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(
                                                      userId: fetchMaterial
                                                          .response[index].user.id) /*UserProfilePage(id: uId, type: uType, index: index)*/;
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'believed') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(userId: fetchMaterial.response[index].user.id);
                                                }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const EditProfilePage(
                                                    comeFrom: true,
                                                  );
                                                }));
                                              }
                                            } else if (fetchMaterial.response[index].type == 'billboard') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                if (fetchMaterial.response[index].name.contains("a byte")) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              } else if (fetchMaterial.response[index].activity == 'Create') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                if (fetchMaterial.response[index].name.contains("a byte")) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              } else {
                                                mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                if (fetchMaterial.response[index].name.contains("a byte")) {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              }
                                            } else {
                                              if (!mounted) {
                                                return;
                                              }
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
                                          } else {
                                            if (activityResponse["type"] == 'forums') {
                                              if (activityResponse["activity"] == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    blockBool: false,
                                                    tabIndex: 0,
                                                  );
                                                }));
                                              } else if (activityResponse["activity"] == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return ForumPostDescriptionPage(
                                                    forumId: fetchMaterial.response[index].typeId,
                                                    comeFrom: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
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
                                            } else if (activityResponse["type"] == 'feature') {
                                              if (activityResponse["activity"] == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 2,
                                                    blockBool: false,
                                                  );
                                                }));
                                              } else if (activityResponse["activity"] == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FeaturePostDescriptionPage(
                                                    sortValue: 'Recent',
                                                    featureDetail: '',
                                                    featureId: fetchMaterial.response[index].typeId,
                                                    navBool: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
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
                                            } else if (activityResponse["type"] == 'survey') {
                                              if (activityResponse["activity"] == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    blockBool: false,
                                                    tabIndex: 1,
                                                  );
                                                }));
                                              } else if (activityResponse["activity"] == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                fetchMaterial.response[index].user.id == mainUserId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: fetchMaterial.response[index].typeId,
                                                          surveyTitle: fetchMaterial.response[index].name,
                                                          activity: true,
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: fetchMaterial.response[index].typeId,
                                                                  activity: true,
                                                                  surveyTitle: fetchMaterial.response[index].name,
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: fetchMaterial.response[index].typeId,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].typeId,
                                                                activity: true,
                                                                surveyTitle: fetchMaterial.response[index].name);
                                                          }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
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
                                            } else if (fetchMaterial.response[index].type == 'watch_notification') {
                                              if (!mounted) {
                                                return;
                                              }
                                              Flushbar(
                                                message: "Notification alert removed by you",
                                                duration: const Duration(seconds: 2),
                                              ).show(context);
                                            } else if (fetchMaterial.response[index].type == 'watch') {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return const MainBottomNavigationPage(
                                                  tType: true,
                                                  newIndex: 0,
                                                  countryIndex: 0,
                                                  excIndex: 1,
                                                  text: '',
                                                  caseNo1: 3,
                                                  isHomeFirstTym: false,
                                                );
                                              }));
                                              Flushbar(
                                                message: "Ticker got removed from watchlist ",
                                                duration: const Duration(seconds: 2),
                                              ).show(context);
                                            } else if (fetchMaterial.response[index].type == 'user') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                await checkUser(
                                                    uId: fetchMaterial.response[index].typeId,
                                                    uType: 'forums',
                                                    mainUserToken: mainUserToken,
                                                    context: context,
                                                    index: 0);
                                              } else if (fetchMaterial.response[index].activity == 'believed') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(userId: fetchMaterial.response[index].user.id);
                                                }));
                                              } else {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const EditProfilePage(
                                                    comeFrom: true,
                                                  );
                                                }));
                                              }
                                            } else if (fetchMaterial.response[index].type == 'billboard') {
                                              if (fetchMaterial.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (fetchMaterial.response[index].activity == 'unblocked') {
                                                mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                if (fetchMaterial.response[index].name.contains("a byte")) {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              } else if (fetchMaterial.response[index].activity == 'Create') {
                                                mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                if (fetchMaterial.response[index].name.contains("a byte")) {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              } else {
                                                mainVariables.selectedBillboardIdMain.value = fetchMaterial.response[index].typeId;
                                                if (fetchMaterial.response[index].name.contains("a byte")) {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              }
                                            } else {}
                                          }
                                          setState(() {
                                            disableMultipleTap = false;
                                          });
                                        }
                                      },
                                      leading: Stack(
                                        children: [
                                          SizedBox(
                                            height: height / 16,
                                            width: width / 6.2,
                                          ),
                                          Positioned(
                                            left: 0,
                                            bottom: 0,
                                            child: Container(
                                              height: height / 17.84,
                                              width: width / 6.62,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(fetchMaterial.response[index].user.avatar), fit: BoxFit.fill)),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: functionsMain.badgeImage(
                                                          activity: fetchMaterial.response[index].activity, type: fetchMaterial.response[index].type),
                                                      fit: BoxFit.fill)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        fetchMaterial.response[index].name,
                                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                      )
                                      /*RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: fetchMaterial.response[index].activity=="update"||
                                                fetchMaterial.response[index].activity=="change password"||
                                                fetchMaterial.response[index].activity=="blocked"||
                                                fetchMaterial.response[index].activity=="unblocked"||
                                                fetchMaterial.response[index].type=="watch_notification"||
                                                fetchMaterial.response[index].type=="watch"
                                                ?"":'You ',
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                            fetchMaterial.response[index].activity=="liked"?"liked":
                                            fetchMaterial.response[index].activity=="disliked"?"disliked":
                                            fetchMaterial.response[index].activity=="shared"?"shared":
                                            fetchMaterial.response[index].activity=="viewed"?"viewed":
                                            fetchMaterial.response[index].activity=="dislike removed"?"removed the dislike":
                                            fetchMaterial.response[index].activity=="like removed"?"removed the like":
                                            fetchMaterial.response[index].activity=="Create"?
                                            fetchMaterial.response[index].type=="watch_notification"||fetchMaterial.response[index].type=="watch"?"":"created":
                                            fetchMaterial.response[index].activity=="update"?"":
                                            fetchMaterial.response[index].activity=="answered"?"answered":
                                            fetchMaterial.response[index].activity=="Delete"?fetchMaterial.response[index].type=="watch_notification"||fetchMaterial.response[index].type=="watch"?"":"deleted":
                                            fetchMaterial.response[index].activity=="responded"?"responded":
                                            fetchMaterial.response[index].activity=="change password"?"":
                                            fetchMaterial.response[index].activity=="unblocked"?"":
                                            fetchMaterial.response[index].type=="forum response"||fetchMaterial.response[index].type=="feature response"?
                                            fetchMaterial.response[index].activity=="blocked"?"blocked":
                                            fetchMaterial.response[index].activity=="reported"?"reported":
                                            fetchMaterial.response[index].activity=="response removed"?"removed":"":
                                            fetchMaterial.response[index].activity=="blocked"?"": "",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:fetchMaterial.response[index].activity=="update"||
                                                fetchMaterial.response[index].activity=="change password"||
                                                fetchMaterial.response[index].activity=="blocked"||
                                                fetchMaterial.response[index].activity=="unblocked"||
                                                fetchMaterial.response[index].type=="watch_notification"||
                                                fetchMaterial.response[index].type=="watch"
                                            ?"":" ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          fetchMaterial.response[index].type=="news"?
                                          TextSpan(
                                            text: " ${fetchMaterial.response[index].type} ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ):
                                          fetchMaterial.response[index].type=="videos"?
                                          TextSpan(
                                            text:"video ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ):
                                          fetchMaterial.response[index].activity=="update"||
                                              fetchMaterial.response[index].activity=="change password"||
                                              fetchMaterial.response[index].activity=="blocked"||
                                              fetchMaterial.response[index].activity=="unblocked"||
                                              fetchMaterial.response[index].type=="watch_notification"||
                                              fetchMaterial.response[index].type=="watch"
                                              ?
                                          TextSpan(
                                            text:"",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ):
                                          TextSpan(
                                         text:fetchMaterial.response[index].user.id==mainUserId?
                                         "your ":
                                         "${fetchMaterial.response[index].user.username}'s ",
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${
                                              fetchMaterial.response[index].name
                                            } ',
                                            style:fetchMaterial.response[index].activity=="update"||
                                                fetchMaterial.response[index].activity=="change password"||
                                                fetchMaterial.response[index].activity=="blocked"||
                                                fetchMaterial.response[index].activity=="unblocked"?
                                            TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black):
                                            TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                          fetchMaterial.response[index].type == 'news' ||
                                              fetchMaterial.response[index].type == 'videos'||
                                              fetchMaterial.response[index].type=="watch_notification"||
                                              fetchMaterial.response[index].type=="watch" ?
                                          TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                      fontSize: _text.scale(8)12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Poppins",
                                                      color: Colors.black),
                                                ) :
                                          TextSpan(
                                            text: fetchMaterial.response[index].type == 'forums'?'Forum':
                                            fetchMaterial.response[index].type == 'survey'?"Survey":
                                            fetchMaterial.response[index].type == 'feature'?"Feature Request":
                                            fetchMaterial.response[index].type == 'forum response'?"forum's response":
                                            fetchMaterial.response[index].type == 'feature response'?"feature's response":
                                            '',
                                            style: TextStyle(
                                                fontSize: _text.scale(8)12,
                                                fontWeight:
                                                FontWeight.w500,
                                                fontFamily: "Poppins",
                                                color: Colors.black),
                                          ),
                                        ]),
                                      )*/
                                      ,
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            timeList[index],
                                            style: TextStyle(
                                                fontSize: text.scale(10),
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xffA9A9A9)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  )
                                ],
                              );
                            }),
                  )
                : SizedBox(
                    height: height / 1.4,
                    width: width,
                    child: Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    )),
          ),
        ),
      ),
    );
  }
}

ActivityList activityListFromJson(String str) => ActivityList.fromJson(json.decode(str));

String activityListToJson(ActivityList data) => json.encode(data.toJson());

class ActivityList {
  ActivityList({
    required this.status,
    required this.response,
    required this.message,
    required this.believed,
  });

  bool status;
  List<Response> response;
  String message;
  bool believed;

  factory ActivityList.fromJson(Map<String, dynamic> json) => ActivityList(
        status: json["status"] ?? false,
        response: json["response"] == null ? [] : List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
        message: json["message"] ?? "",
        believed: json["believed"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "message": message,
        "believed": believed,
      };
}

class Response {
  Response({
    required this.id,
    required this.name,
    required this.type,
    required this.activity,
    required this.typeId,
    required this.createdAt,
    required this.day,
    required this.user,
  });

  String id;
  String name;
  String type;
  String activity;
  String typeId;
  String createdAt;
  String day;
  User user;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        type: json["type"] ?? "",
        activity: json["activity"] ?? "",
        typeId: json["type_id"] ?? "",
        createdAt: json["createdAt"] == null
            ? "few seconds ago"
            : billBoardFunctionsMain.readTimestampMain(DateTime.parse(json["createdAt"]).millisecondsSinceEpoch),
        day: json["day"] ?? "",
        user: User.fromJson(json["user"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "activity": activity,
        "type_id": typeId,
        "createdAt": createdAt,
        "day": day,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.avatar,
  });

  String id;
  String username;
  String avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] ?? "",
        username: json["username"] ?? "",
        avatar: json["avatar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar": avatar,
      };
}
