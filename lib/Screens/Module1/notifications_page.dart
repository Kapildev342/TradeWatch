import 'dart:convert';
import 'dart:ffi';

import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

import '../../Constants/API/api.dart';
import '../Module2/FeatureRequest/feature_post_description_page.dart';
import '../Module2/FeatureRequest/feature_request_page.dart';
import '../Module2/Forum/detailed_forum_image_page.dart';
import '../Module2/Survey/analytics_page.dart';
import '../Module2/no_response_page.dart';
import '../Module4/response_page.dart';
import '../Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'Login/sign_in_page.dart';
import 'Settings/Notifications/notification_categories_model.dart';
import 'Settings/Theme/theme_page.dart';
import 'bottom_navigation.dart';

class NotificationsPage extends StatefulWidget {
  final String? fromWhere;

  const NotificationsPage({Key? key, this.fromWhere}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List daysList = [];
  List notificationImageList = [];
  List notificationsTitle = [];
  late Future<NotificationList> futureNotificationList;
  String mainUserToken = "";
  Map<String, dynamic> notify = {};
  String time = '';
  bool loader = false;
  bool noResponse = false;
  bool noFalseResponse = false;
  List<String> timeList = [];
  late NotificationList fetchMaterial;
  String selectedValue = "";
  String selectedSlug = "";
  late NotificationCategoriesModel notifyCategories;
  List<String> notificationDropDownList = [];
  List<bool> notificationBoolList = [];
  List<String> notificationSlugList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  loadNotification() async {
    setState(() {
      loader = false;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    mainUserToken = preferences.getString('newUserToken') ?? "";
    nativeAdList.clear();
    nativeAdIsLoadedList.clear();
    if (mainUserToken != "") {
      var url = Uri.parse(baseurl + versionHome + notifications);
      var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"notification_category": selectedSlug});
      notify = jsonDecode(response.body);
      fetchMaterial = NotificationList.fromJson(notify);
      if (notify["response"].length != 0) {
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
    }
    setState(() {
      loader = true;
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
      timeList.add(time);
    });
    return time;
  }

  @override
  void initState() {
    getAllDataMain(name: 'Notification_Page');
    pageVisitFunc(pageName: 'notification');
    getNotificationCategories();
    super.initState();
  }

  getNotificationCategories() async {
    notifyCategories = await settingsMain.notificationCategories();
    for (int i = 0; i < notifyCategories.response.length + 1; i++) {
      notificationDropDownList.add(i == 0 ? "Overall" : notifyCategories.response[i - 1].name);
      notificationBoolList.add(false);
      notificationSlugList.add(i == 0 ? "" : notifyCategories.response[i - 1].slug);
    }
    selectedValue = notificationDropDownList.first;
    selectedSlug = notificationSlugList.first;
    loadNotification();
  }

  Future<bool> getIdData({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"id": id, "type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      setState(() {
        noResponse = false;
      });
    } else {
      if (response.statusCode == 200) {
        setState(() {
          noResponse = responseData["status"];
        });
      } else {
        setState(() {
          noFalseResponse = true;
        });
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
    return noResponse;
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
        if (widget.fromWhere == 'signIn') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                      caseNo1: 0, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
        } else {
          Navigator.pop(context, true);
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
              centerTitle: false,
              titleSpacing: 0,
              leading: GestureDetector(
                  onTap: () {
                    if (widget.fromWhere == 'signIn') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const MainBottomNavigationPage(
                                  caseNo1: 0, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
                    } else {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary)),
              toolbarHeight: height / 10.97,
              elevation: 0,
              title: Text("Notifications",
                  //style: TextStyle(fontSize: text.scale(24), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                  style: Theme.of(context).textTheme.titleLarge),
              actions: [
                GestureDetector(
                  onTap: () {
                    bottomSheet(context: context);
                  },
                  child: SizedBox(
                      height: height / 30,
                      width: width / 11,
                      child: Image.asset(
                        isDarkTheme.value ? "assets/home_screen/filter_notify_dark.png" : "assets/home_screen/filter_notify_light.png",
                      )),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const FeatureRequestPage();
                    }));
                  },
                  child: SizedBox(
                      height: height / 33.83,
                      width: width / 11.76,
                      child: SvgPicture.asset(
                        isDarkTheme.value ? "assets/home_screen/Request.svg" : "lib/Constants/Assets/SMLogos/HomeScreen/Request.svg",
                      )),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (scroll) {
                scroll.disallowIndicator();
                return true;
              },
              child: loader
                  ? mainUserToken == ""
                      ? SizedBox(
                          height: height / 1.4,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*   Icon(Icons.login_rounded,size: 300,color:Colors.grey.shade300 ,),*/
                              const Text(
                                "Please login to access this feature.",
                                style: TextStyle(color: Color(0XFF0EA102), fontSize: 14),
                              ),
                              SizedBox(
                                height: height / 57.73,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return const SignInPage(
                                        fromWhere: 'notification',
                                      );
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Sign in",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                                      ),
                                      SizedBox(width: width / 27.4),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ],
                                  ))
                            ],
                          ))
                      : fetchMaterial.response.isEmpty
                          ? SizedBox(
                              height: height / 1.4,
                              width: width,
                              child: Center(
                                  child: Text(
                                'No Notifications Available',
                                //style: TextStyle(color: Color(0XFF0EA102), fontSize: 14),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
                              )))
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const ScrollPhysics(),
                                  itemCount: fetchMaterial.response.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
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
                                                      margin: EdgeInsets.only(bottom: height / 50.75),
                                                      alignment: Alignment.centerLeft,
                                                      height: height / 20.3,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          //  color: Colors.white
                                                          borderRadius:
                                                              const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                          color:
                                                              isDarkTheme.value ? const Color(0xff1D1D1E) : const Color(0xffB0B0B0).withOpacity(0.1)),
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
                                                          margin: EdgeInsets.only(bottom: height / 50.75),
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 20.3,
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                              //  color: Colors.white
                                                              borderRadius: const BorderRadius.only(
                                                                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                              color: isDarkTheme.value
                                                                  ? const Color(0xff1D1D1E)
                                                                  : const Color(0xffB0B0B0).withOpacity(0.1)),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: width / 23.43),
                                                            child: Text(
                                                              fetchMaterial.response[index].day,
                                                              style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                                            ),
                                                          )),
                                              ListTile(
                                                onTap: () async {
                                                  bool responseBool = await getIdData(
                                                      id: fetchMaterial.response[index].rawData.videoId,
                                                      type: fetchMaterial.response[index].type == "feature request"
                                                          ? "feature"
                                                          : fetchMaterial.response[index].type);
                                                  if (responseBool) {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return const NoResponsePage();
                                                    }));
                                                  } else {
                                                    if (noFalseResponse) {
                                                    } else {
                                                      if (fetchMaterial.response[index].type == 'news') {
                                                        if (!mounted) {
                                                          return;
                                                        }

                                                        ///need to change it soon
                                                        /*Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) => */ /*NewsDescriptionPage(comeFrom: 'notification',
                                                          id: fetchMaterial.response[index].rawData.videoId, idList: [], descriptionList: [], snippetList: [],)*/ /*
                                                                    DemoPage(
                                                                      url: fetchMaterial.response[index].link,
                                                                      image: fetchMaterial.response[index].imageUrl,
                                                                      text: fetchMaterial.response[index].name,
                                                                      id: fetchMaterial.response[index].rawData.videoId,
                                                                      type: 'news',
                                                                      activity: false,
                                                                    )));*/
                                                        Get.to(const DemoView(), arguments: {
                                                          "id": fetchMaterial.response[index].rawData.videoId,
                                                          "type": "news",
                                                          "url": fetchMaterial.response[index].link
                                                        });
                                                      } else if (fetchMaterial.response[index].type == 'forums') {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => ForumPostDescriptionPage(
                                                                      comeFrom: 'notification',
                                                                      forumId: fetchMaterial.response[index].rawData.videoId,
                                                                      idList: const [],
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == 'feature' ||
                                                          fetchMaterial.response[index].type == 'feature request') {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FeaturePostDescriptionPage(
                                                                      featureDetail: "",
                                                                      featureId: fetchMaterial.response[index].rawData.videoId,
                                                                      sortValue: "Recent",
                                                                      navBool: 'notification',
                                                                      idList: const [],
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == 'survey') {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => AnalyticsPage(
                                                                      surveyId: fetchMaterial.response[index].rawData.videoId,
                                                                      activity: false,
                                                                      surveyTitle: '',
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == 'videos') {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => YoutubePlayerLandscapeScreen(
                                                                      id: fetchMaterial.response[index].rawData.videoId,
                                                                      comeFrom: 'notifications',
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == "watch-list") {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FinalChartPage(
                                                                      tickerId: fetchMaterial.response[index].rawData.videoId,
                                                                      category: fetchMaterial.response[index].rawData.category,
                                                                      exchange: fetchMaterial.response[index].rawData.link,
                                                                      chartType: "1",
                                                                      index: 0,
                                                                      fromLink: false,
                                                                    )));
                                                      } else if (fetchMaterial.response[index].link == "max" ||
                                                          fetchMaterial.response[index].link == "min") {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            navigatorKey.currentState!.context,
                                                            MaterialPageRoute(
                                                                builder: (context) => ResponsePage(
                                                                      notes: fetchMaterial.response[index].rawData.notes,
                                                                      link: fetchMaterial.response[index].link,
                                                                      title: fetchMaterial.response[index].name,
                                                                      logo: fetchMaterial.response[index].imageUrl,
                                                                      cat: fetchMaterial.response[index].rawData.category == "stocks"
                                                                          ? 0
                                                                          : fetchMaterial.response[index].rawData.category == "crypto"
                                                                              ? 1
                                                                              : fetchMaterial.response[index].rawData.category == "commodity"
                                                                                  ? 2
                                                                                  : fetchMaterial.response[index].rawData.category == "commodity"
                                                                                      ? 3
                                                                                      : 0,
                                                                      type: fetchMaterial.response[index].type == "US"
                                                                          ? 0
                                                                          : fetchMaterial.response[index].type == "NSE"
                                                                              ? 1
                                                                              : fetchMaterial.response[index].type == "BSE"
                                                                                  ? 2
                                                                                  : 0,
                                                                      countryInd: fetchMaterial.response[index].type == "India"
                                                                          ? 0
                                                                          : fetchMaterial.response[index].type == "USA"
                                                                              ? 1
                                                                              : 0,
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == 'top-trending') {
                                                        int newIndex = fetchMaterial.response[index].rawData.category == "stocks"
                                                            ? 0
                                                            : fetchMaterial.response[index].rawData.category == "crypto"
                                                                ? 1
                                                                : fetchMaterial.response[index].rawData.category == "commodity"
                                                                    ? 2
                                                                    : fetchMaterial.response[index].rawData.category == "forex"
                                                                        ? 3
                                                                        : 0;
                                                        int excIndex = fetchMaterial.response[index].rawData.link == "NSE"
                                                            ? 1
                                                            : fetchMaterial.response[index].rawData.link == "BSE"
                                                                ? 2
                                                                : 0;
                                                        int countryIndex = fetchMaterial.response[index].rawData.link == "India"
                                                            ? 0
                                                            : fetchMaterial.response[index].rawData.link == "USA"
                                                                ? 1
                                                                : 0;
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => MainBottomNavigationPage(
                                                                      newIndex: newIndex,
                                                                      excIndex: excIndex,
                                                                      text: '',
                                                                      countryIndex: countryIndex,
                                                                      caseNo1: 0,
                                                                      tType: false,
                                                                      isHomeFirstTym: false,
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == "thanks") {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            navigatorKey.currentState!.context,
                                                            MaterialPageRoute(
                                                              builder: (context) => DetailedForumImagePage(
                                                                filterId: '',
                                                                tickerId: '',
                                                                tickerName: "",
                                                                forumDetail: "",
                                                                text: 'Stocks',
                                                                topic: 'My Answers',
                                                                catIdList: mainCatIdList,
                                                                navBool: true,
                                                                sendUserId: fetchMaterial.response[index].rawData.sendUserId!,
                                                                fromCompare: false,
                                                              ),
                                                            ));
                                                      } else if (fetchMaterial.response[index].type == "say-thanks") {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            navigatorKey.currentState!.context,
                                                            MaterialPageRoute(
                                                                builder: (context) => DetailedForumImagePage(
                                                                    filterId: '',
                                                                    tickerId: '',
                                                                    tickerName: "",
                                                                    forumDetail: "",
                                                                    text: 'Stocks',
                                                                    topic: 'My Questions',
                                                                    catIdList: mainCatIdList,
                                                                    navBool: true,
                                                                    sendUserId: fetchMaterial.response[index].rawData.sendUserId!,
                                                                    fromCompare: false)));
                                                      } else if (fetchMaterial.response[index].type == "Add-watch-list") {
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FinalChartPage(
                                                                      tickerId: fetchMaterial.response[index].rawData.videoId,
                                                                      category: fetchMaterial.response[index].rawData.category,
                                                                      exchange: fetchMaterial.response[index].rawData.link,
                                                                      chartType: "1",
                                                                      index: 0,
                                                                      fromLink: false,
                                                                    )));
                                                      } else if (fetchMaterial.response[index].type == "profile") {
                                                        if (fetchMaterial.response[index].rawData.category == "business") {
                                                          mainVariables.selectedTickerId.value = fetchMaterial.response[index].rawData.link;
                                                        }
                                                        if (!mounted) {
                                                          return;
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) =>
                                                                    fetchMaterial.response[index].rawData.category == "user"
                                                                        ? UserBillBoardProfilePage(
                                                                            userId: fetchMaterial.response[index].rawData.sendUserId ?? "")
                                                                        : fetchMaterial.response[index].rawData.category == "business"
                                                                            ? const BusinessProfilePage()
                                                                            : fetchMaterial.response[index].rawData.category == "intermediate"
                                                                                ? IntermediaryBillBoardProfilePage(
                                                                                    userId: fetchMaterial.response[index].rawData.sendUserId ?? "")
                                                                                : Container()));
                                                      } else {}
                                                    }
                                                  }
                                                },
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.grey,
                                                  backgroundImage: NetworkImage(fetchMaterial.response[index].imageUrl),
                                                ),
                                                title: Text(
                                                  fetchMaterial.response[index].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
                                                  maxLines: 2,
                                                ),
                                                subtitle: Text(
                                                  timeList[index],
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), fontWeight: FontWeight.w400, color: const Color(0xffA9A9A9)),
                                                ),
                                              ),
                                              Divider(
                                                color: Theme.of(context).colorScheme.tertiary,
                                                thickness: 0.8,
                                                height: 0,
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                    return Column(
                                      children: [
                                        index == 0
                                            ? Container(
                                                margin: EdgeInsets.only(bottom: height / 50.75),
                                                alignment: Alignment.centerLeft,
                                                height: height / 20.3,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    //  color: Colors.white
                                                    borderRadius:
                                                        const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                    color: isDarkTheme.value ? const Color(0xff1D1D1E) : const Color(0xffB0B0B0).withOpacity(0.1)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: width / 23.43),
                                                  child: Text(
                                                    fetchMaterial.response[index].day,
                                                    //style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0),),
                                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              )
                                            : fetchMaterial.response[index].day == fetchMaterial.response[index - 1].day
                                                ? const SizedBox()
                                                : Container(
                                                    margin: EdgeInsets.only(bottom: height / 50.75),
                                                    alignment: Alignment.centerLeft,
                                                    height: height / 20.3,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        //  color: Colors.white
                                                        borderRadius:
                                                            const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                        color:
                                                            isDarkTheme.value ? const Color(0xff1D1D1E) : const Color(0xffB0B0B0).withOpacity(0.1)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: width / 23.43),
                                                      child: Text(
                                                        fetchMaterial.response[index].day,
                                                        /*style: TextStyle(
                                                        fontSize: text.scale(16),
                                                        color: const Color(0xffB0B0B0),
                                                      ),*/
                                                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
                                                      ),
                                                    )),
                                        ListTile(
                                          onTap: () async {
                                            bool responseBool = await getIdData(
                                                id: fetchMaterial.response[index].rawData.videoId,
                                                type: fetchMaterial.response[index].type == "feature request"
                                                    ? "feature"
                                                    : fetchMaterial.response[index].type);
                                            if (responseBool) {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return const NoResponsePage();
                                              }));
                                            } else {
                                              if (noFalseResponse) {
                                              } else {
                                                if (fetchMaterial.response[index].type == 'news') {
                                                  ///need to change it soon
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => */
                                                  /*NewsDescriptionPage(comeFrom: 'notification',
                                                        id: fetchMaterial.response[index].rawData.videoId, idList: [], descriptionList: [], snippetList: [],)*/
                                                  /*
                                                            DemoPage(
                                                              url: fetchMaterial.response[index].link,
                                                              image: fetchMaterial.response[index].imageUrl,
                                                              text: fetchMaterial.response[index].name,
                                                              id: fetchMaterial.response[index].rawData.videoId,
                                                              type: 'news',
                                                              activity: false,
                                                            )));*/
                                                  Get.to(const DemoView(), arguments: {
                                                    "id": fetchMaterial.response[index].rawData.videoId,
                                                    "type": "news",
                                                    "url": fetchMaterial.response[index].link
                                                  });
                                                } else if (fetchMaterial.response[index].type == 'forums') {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ForumPostDescriptionPage(
                                                                comeFrom: 'notification',
                                                                forumId: fetchMaterial.response[index].rawData.videoId,
                                                                idList: const [],
                                                              )));
                                                } else if (fetchMaterial.response[index].type == 'feature' ||
                                                    fetchMaterial.response[index].type == 'feature request') {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => FeaturePostDescriptionPage(
                                                                featureDetail: "",
                                                                featureId: fetchMaterial.response[index].rawData.videoId,
                                                                sortValue: "Recent",
                                                                navBool: 'notification',
                                                                idList: const [],
                                                              )));
                                                } else if (fetchMaterial.response[index].type == 'survey') {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AnalyticsPage(
                                                                surveyId: fetchMaterial.response[index].rawData.videoId,
                                                                activity: false,
                                                                surveyTitle: '',
                                                              )));
                                                } else if (fetchMaterial.response[index].type == 'videos') {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => YoutubePlayerLandscapeScreen(
                                                                id: fetchMaterial.response[index].rawData.videoId,
                                                                comeFrom: 'notifications',
                                                              )));
                                                } else if (fetchMaterial.response[index].type == "watch-list") {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => FinalChartPage(
                                                                tickerId: fetchMaterial.response[index].rawData.videoId,
                                                                category: fetchMaterial.response[index].rawData.category,
                                                                exchange: fetchMaterial.response[index].rawData.link,
                                                                chartType: "1",
                                                                index: 0,
                                                                fromLink: false,
                                                              )));
                                                } else if (fetchMaterial.response[index].link == "max" ||
                                                    fetchMaterial.response[index].link == "min") {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      navigatorKey.currentState!.context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ResponsePage(
                                                                notes: fetchMaterial.response[index].rawData.notes,
                                                                link: fetchMaterial.response[index].link,
                                                                title: fetchMaterial.response[index].name,
                                                                logo: fetchMaterial.response[index].imageUrl,
                                                                cat: fetchMaterial.response[index].rawData.category == "stocks"
                                                                    ? 0
                                                                    : fetchMaterial.response[index].rawData.category == "crypto"
                                                                        ? 1
                                                                        : fetchMaterial.response[index].rawData.category == "commodity"
                                                                            ? 2
                                                                            : fetchMaterial.response[index].rawData.category == "commodity"
                                                                                ? 3
                                                                                : 0,
                                                                type: fetchMaterial.response[index].type == "US"
                                                                    ? 0
                                                                    : fetchMaterial.response[index].type == "NSE"
                                                                        ? 1
                                                                        : fetchMaterial.response[index].type == "BSE"
                                                                            ? 2
                                                                            : 0,
                                                                countryInd: fetchMaterial.response[index].type == "India"
                                                                    ? 0
                                                                    : fetchMaterial.response[index].type == "USA"
                                                                        ? 1
                                                                        : 0,
                                                              )));
                                                } else if (fetchMaterial.response[index].type == 'top-trending') {
                                                  int newIndex = fetchMaterial.response[index].rawData.category == "stocks"
                                                      ? 0
                                                      : fetchMaterial.response[index].rawData.category == "crypto"
                                                          ? 1
                                                          : fetchMaterial.response[index].rawData.category == "commodity"
                                                              ? 2
                                                              : fetchMaterial.response[index].rawData.category == "forex"
                                                                  ? 3
                                                                  : 0;
                                                  int excIndex = fetchMaterial.response[index].rawData.link == "NSE"
                                                      ? 1
                                                      : fetchMaterial.response[index].rawData.link == "BSE"
                                                          ? 2
                                                          : 0;
                                                  int countryIndex = fetchMaterial.response[index].rawData.link == "India"
                                                      ? 0
                                                      : fetchMaterial.response[index].rawData.link == "USA"
                                                          ? 1
                                                          : 0;
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => MainBottomNavigationPage(
                                                                newIndex: newIndex,
                                                                excIndex: excIndex,
                                                                text: '',
                                                                countryIndex: countryIndex,
                                                                caseNo1: 0,
                                                                tType: false,
                                                                isHomeFirstTym: false,
                                                              )));
                                                } else if (fetchMaterial.response[index].type == "thanks") {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      navigatorKey.currentState!.context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DetailedForumImagePage(
                                                          filterId: '',
                                                          tickerId: '',
                                                          tickerName: "",
                                                          forumDetail: "",
                                                          text: 'Stocks',
                                                          topic: 'My Answers',
                                                          catIdList: mainCatIdList,
                                                          navBool: true,
                                                          sendUserId: fetchMaterial.response[index].rawData.sendUserId!,
                                                          fromCompare: false,
                                                        ),
                                                      ));
                                                } else if (fetchMaterial.response[index].type == "say-thanks") {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      navigatorKey.currentState!.context,
                                                      MaterialPageRoute(
                                                          builder: (context) => DetailedForumImagePage(
                                                              filterId: '',
                                                              tickerId: '',
                                                              tickerName: "",
                                                              forumDetail: "",
                                                              text: 'Stocks',
                                                              topic: 'My Questions',
                                                              catIdList: mainCatIdList,
                                                              navBool: true,
                                                              sendUserId: fetchMaterial.response[index].rawData.sendUserId!,
                                                              fromCompare: false)));
                                                } else if (fetchMaterial.response[index].type == "Add-watch-list") {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => FinalChartPage(
                                                                tickerId: fetchMaterial.response[index].rawData.videoId,
                                                                category: fetchMaterial.response[index].rawData.category,
                                                                exchange: fetchMaterial.response[index].rawData.link,
                                                                chartType: "1",
                                                                index: 0,
                                                                fromLink: false,
                                                              )));
                                                } else if (fetchMaterial.response[index].type == "profile") {
                                                  if (fetchMaterial.response[index].rawData.category == "business") {
                                                    mainVariables.selectedTickerId.value = fetchMaterial.response[index].rawData.link;
                                                  }
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) => fetchMaterial.response[index].rawData.category == "user"
                                                              ? UserBillBoardProfilePage(
                                                                  userId: fetchMaterial.response[index].rawData.sendUserId ?? "")
                                                              : fetchMaterial.response[index].rawData.category == "business"
                                                                  ? const BusinessProfilePage()
                                                                  : fetchMaterial.response[index].rawData.category == "intermediate"
                                                                      ? IntermediaryBillBoardProfilePage(
                                                                          userId: fetchMaterial.response[index].rawData.sendUserId ?? "")
                                                                      : Container()));
                                                } else {}
                                              }
                                            }
                                          },
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: NetworkImage(fetchMaterial.response[index].imageUrl),
                                          ),
                                          title: Text(
                                            fetchMaterial.response[index].name,
                                            // style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
                                            maxLines: 2,
                                          ),
                                          subtitle: Text(
                                            timeList[index],
                                            /* style: TextStyle(
                                              fontSize: text.scale(10),
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xffA9A9A9)),*/
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(fontWeight: FontWeight.w400, color: const Color(0xffA9A9A9)),
                                          ),
                                        ),
                                        Divider(
                                          color: Theme.of(context).colorScheme.tertiary,
                                          thickness: 0.8,
                                          height: 0,
                                        ),
                                      ],
                                    );
                                  }),
                            )
                  : SizedBox(
                      height: height / 1.4,
                      width: width,
                      child: Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /*  Container(
                    height: 30,
                    margin: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            isDense: true,
                            items: notificationDropDownList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        /*style: TextStyle(
                                          fontSize: text.scale(14),
                                          fontWeight: FontWeight.w500,
                                        ),*/
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (String? value) async {
                              setState(() {
                                selectedValue = value!;
                                int index = notificationDropDownList.indexOf(selectedValue);
                                selectedSlug = notificationSlugList[index];
                              });
                              await loadNotification();
                            },
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconSize: 24,
                              iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
                              iconDisabledColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                              width: 125,
                              elevation: 5,
                            ),
                            menuItemStyleData: const MenuItemStyleData(height: 40),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              elevation: 8,
                              offset: const Offset(-50, -20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),*/

  bottomSheet({
    required BuildContext context,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        backgroundColor: Theme.of(context).colorScheme.background,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Notification Filter",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: text.scale(16),
                            color: isDarkTheme.value ? const Color(0xffD6D6D6) : const Color(0xff2A2727),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/home_screen/close.png",
                            height: height / 43.3,
                            width: width / 20.55,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 0.8,
                    ),
                    ListView.builder(
                      itemCount: notificationDropDownList.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile<String>(
                          value: notificationSlugList[index],
                          groupValue: selectedSlug,
                          onChanged: (String? value) async {
                            Navigator.pop(context);
                            modelSetState(() {
                              selectedSlug = value ?? "";
                            });
                            await loadNotification();
                          },
                          controlAffinity: ListTileControlAffinity.trailing,
                          secondary: Image.asset(
                            isDarkTheme.value ? "assets/home_screen/notify_bell_dark.png" : "assets/home_screen/notify_bell.png",
                            height: height / 43.3,
                            width: width / 20.55,
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            notificationDropDownList[index],
                            style: TextStyle(
                              color: isDarkTheme.value ? const Color(0xffCBCBCB) : const Color(0xff2A2727),
                              fontSize: text.scale(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          activeColor: Colors.green,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

NotificationList notificationListFromJson(String str) => NotificationList.fromJson(json.decode(str));

String notificationListToJson(NotificationList data) => json.encode(data.toJson());

class NotificationList {
  NotificationList({
    required this.status,
    required this.response,
    required this.count,
    required this.message,
  });

  bool status;
  List<Response> response;
  int count;
  String message;

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
        status: json["status"],
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
        count: json["count"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "count": count,
        "message": message,
      };
}

class Response {
  Response({
    required this.id,
    required this.name,
    required this.link,
    required this.imageUrl,
    required this.type,
    required this.rawData,
    required this.day,
  });

  String id;
  String name;
  String link;
  String imageUrl;
  String type;
  RawData rawData;
  String day;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        link: json["link"] ?? "",
        imageUrl: json["image_url"] ?? "",
        type: json["type"] ?? "",
        rawData: RawData.fromJson(json["raw_data"] ?? {}),
        day: json["day"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "link": link,
        "image_url": imageUrl,
        "type": type,
        "raw_data": rawData.toJson(),
        "day": day,
      };
}

class RawData {
  RawData(
      {required this.videoId,
      required this.title,
      required this.link,
      required this.imageUrl,
      required this.type,
      required this.category,
      required this.notes,
      required this.sendUserId});

  String videoId;
  String title;
  String link;
  String imageUrl;
  String type;
  String category;
  String? notes;
  String? sendUserId;

  factory RawData.fromJson(Map<String, dynamic> json) => RawData(
        videoId: json["video_id"] ?? "",
        title: json["title"] ?? "",
        link: json["link"] ?? "",
        imageUrl: json["image_url"] ?? "",
        type: json["type"] ?? "",
        notes: json["notes"] == null ? "" : json['notes'],
        category: json["category"] ?? "",
        sendUserId: json["sender_user_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "title": title,
        "link": link,
        "image_url": imageUrl,
        "type": type,
        "notes": notes,
        "category": category,
        "sender_user_id": sendUserId,
      };
}
