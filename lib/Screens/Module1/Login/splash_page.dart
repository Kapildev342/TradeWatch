import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/add_watch_list_page.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/watch_list.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/detailed_forum_image_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';
import 'package:tradewatchfinal/Screens/Module3/locker_skip_screen.dart';
import 'package:tradewatchfinal/Screens/Module3/privacy_page.dart';
import 'package:tradewatchfinal/Screens/Module4/response_page.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';
import 'package:tradewatchfinal/Screens/Module5/set_alert_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_page.dart';

import 'create_password_page.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
    required this.msgType,
    required this.output,
    required this.initialLink,
  }) : super(key: key);
  final String msgType;
  final Map<String, dynamic> output;
  final PendingDynamicLinkData? initialLink;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  String? mainUserId;
  List<String> dynamics = [];

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainSkipValue = prefs.getString('newUserToken') == null ? true : false;
    Map<String, dynamic> output = {};
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        output = jsonDecode(message.data['data']);
        List<String> dataList = output["link"].split("\$&:\$");
        output['scheduled_id'] == null ? debugPrint("nothing") : schedulingFunction(id: output['scheduled_id']);
        if (output['type'] == "news") {
          ///need to change it soon
          /*Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder:
                      (context) => */
          /*NewsDescriptionPage(id: output['video_id'],
                idList: [], descriptionList: [], snippetList: [], comeFrom: 'main')*/
          /*
                          DemoPage(
                            url: '',
                            activity: false,
                            image: output['image_url'],
                            text: output['title'],
                            type: 'news',
                            id: output['video_id'],
                            checkMain: true,
                          )));*/
          Get.to(const DemoView(), arguments: {"id": output['video_id'], "type": "news", "url": "", "fromLink": true});
        } else if (output['type'] == "feature" || output['type'] == "feature request") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => mainSkipValue
                      ? SignInPage(
                          navBool: 'main',
                          id: output['video_id'],
                          category: "Recent",
                          filterId: "",
                          toWhere: "FeaturePostDescriptionPage",
                          fromWhere: "link",
                        )
                      : FeaturePostDescriptionPage(
                          sortValue: "Recent",
                          featureId: output['video_id'],
                          featureDetail: "",
                          navBool: 'main',
                          idList: const [],
                        )));
        } else if (output['type'] == "forums") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => mainSkipValue
                      ? SignInPage(
                          navBool: 'main',
                          id: output['video_id'],
                          category: output['category'],
                          filterId: "",
                          toWhere: "ForumPostDescriptionPage",
                          fromWhere: "link",
                        )
                      : ForumPostDescriptionPage(
                          comeFrom: 'main',
                          forumId: output['video_id'],
                          idList: const [],
                        )));
        } else if (output['type'] == "survey") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => mainSkipValue
                      ? SignInPage(
                          navBool: 'main',
                          id: output['video_id'],
                          category: "",
                          filterId: "",
                          toWhere: "AnalyticsPage",
                          activity: false,
                          fromWhere: "link",
                        )
                      : AnalyticsPage(
                          surveyId: output['video_id'],
                          activity: false,
                          surveyTitle: '',
                        )));
        } else if (output['type'] == "videos") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => YoutubePlayerLandscapeScreen(
                        id: output['video_id'],
                        comeFrom: "main",
                      )));
        } else if (output['type'] == "thanks") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  //Still need to work for thanks currently its in home screen
                  builder: (context) => mainSkipValue
                      ? const MainBottomNavigationPage(
                          caseNo1: 0,
                          text: '',
                          excIndex: 1,
                          newIndex: 0,
                          countryIndex: 0,
                          tType: true,
                          isHomeFirstTym: true,
                        )
                      : DetailedForumImagePage(
                          filterId: '',
                          tickerId: '',
                          tickerName: "",
                          forumDetail: "",
                          text: 'Stocks',
                          topic: 'My Answers',
                          catIdList: mainCatIdList,
                          navBool: true,
                          sendUserId: output['sender_user_id'],
                          fromCompare: false,
                        )));
        } else if (output['type'] == "say-thanks") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  //Still need to work for thanks currently its in home screen
                  builder: (context) => mainSkipValue
                      ? const MainBottomNavigationPage(
                          caseNo1: 0,
                          text: '',
                          excIndex: 1,
                          newIndex: 0,
                          countryIndex: 0,
                          tType: true,
                          isHomeFirstTym: true,
                        )
                      : DetailedForumImagePage(
                          filterId: '',
                          tickerId: '',
                          tickerName: "",
                          forumDetail: "",
                          text: 'Stocks',
                          topic: 'My Questions',
                          catIdList: mainCatIdList,
                          navBool: true,
                          sendUserId: "",
                          fromCompare: false)));
        } else if (output['link'] == "max" || output['link'] == "min") {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  ////Still need to work for thanks currently its in home screen
                  builder: (context) => mainSkipValue
                      ? const MainBottomNavigationPage(
                          caseNo1: 3,
                          text: '',
                          excIndex: 1,
                          newIndex: 0,
                          countryIndex: 0,
                          tType: true,
                          isHomeFirstTym: true,
                        )
                      : ResponsePage(
                          notes: output['notes'],
                          link: output['link'],
                          title: output['title'],
                          logo: output['image_url'],
                          cat: output["category"] == "stocks"
                              ? 0
                              : output["category"] == "crypto"
                                  ? 1
                                  : output["category"] == "commodity"
                                      ? 2
                                      : output["category"] == "commodity"
                                          ? 3
                                          : 0,
                          type: output["type"] == "US"
                              ? 0
                              : output["type"] == "NSE"
                                  ? 1
                                  : output["type"] == "BSE"
                                      ? 2
                                      : 0,
                          countryInd: output["type"] == "India"
                              ? 0
                              : output["type"] == "USA"
                                  ? 1
                                  : 0,
                        )));
        } else if (output['type'] == "watch-list") {
          /*int newIndex=output["category"]=="stocks"? 0
              : output["category"]=="crypto"? 1
              : output["category"]=="commodity"? 2
              : output["category"]=="forex"?3:0;
          int excIndex= output["link"]=="NSE"?1
              :output["link"]=="BSE"?2:0;
          int countryIndex=output["link"]=="India"?0: output["link"]=="USA"?1:0;*/
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalChartPage(
                        tickerId: output['video_id'],
                        category: output["category"],
                        exchange: output['link'],
                        chartType: "1",
                        index: 0,
                        fromLink: true,
                      )
                  /*MainBottomNavigationPage(tType: true,
                  caseNo1: 3, text: "", excIndex: excIndex, newIndex: newIndex, countryIndex: countryIndex,isHomeFirstTym:false,)*/
                  ));
        } else if (output['type'] == "Add-watch-list") {
          /*  int newIndex=output["category"]=="stocks"? 0
              : output["category"]=="crypto"? 1
              : output["category"]=="commodity"? 2
              : output["category"]=="forex"?3:0;
          int excIndex= output["link"]=="NSE"?1
              :output["link"]=="BSE"?2:0;
          int countryIndex=output["link"]=="India"?0: output["link"]=="USA"?1:0;*/
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalChartPage(
                        tickerId: output['video_id'],
                        category: output["category"],
                        exchange: output['link'],
                        chartType: "1",
                        index: 0,
                        fromLink: true,
                      ) /*AddWatchlistPage(newIndex: newIndex, excIndex: excIndex, countryIndex: countryIndex)*/));
        } else if (output['type'] == 'top-trending') {
          int newIndex = output["category"] == "stocks"
              ? 0
              : output["category"] == "crypto"
                  ? 1
                  : output["category"] == "commodity"
                      ? 2
                      : output["category"] == "commodity"
                          ? 3
                          : 0;
          int excIndex = output["link"] == "NSE"
              ? 1
              : output["link"] == "BSE"
                  ? 2
                  : 0;
          int countryIndex = output["link"] == "India"
              ? 0
              : output["type"] == "USA"
                  ? 1
                  : 0;
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
                        isHomeFirstTym: true,
                      )));
        } else if (output['type'] == 'profile') {
          if (output["category"] == "business") {
            mainVariables.selectedTickerId.value = output["link"];
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => output["category"] == "user"
                      ? UserBillBoardProfilePage(
                          userId: output["sender_user_id"],
                          fromLink: "main",
                        )
                      : output["category"] == "business"
                          ? const BusinessProfilePage(
                              fromLink: "main",
                            )
                          : output["category"] == "intermediate"
                              ? IntermediaryBillBoardProfilePage(
                                  userId: output["sender_user_id"],
                                  fromLink: "main",
                                )
                              : Container()));
        } else if (output['type'] == 'new-message') {
          mainVariables.conversationUserData.value = ConversationUserData(
              userId: output['sender_user_id'],
              avatar: output['image_url'],
              firstName: dataList[1],
              lastName: dataList[2],
              userName: dataList[0],
              isBelieved: dataList[3] == "true");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const ConversationPage(
              fromLink: "main",
            );
          }));
        } else {}
      } else {
        var duration = const Duration(seconds: 3);
        return Timer(duration, navigationPage);
      }
    });
  }

  Future<void> navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    kToken = prefs.getString('newUserToken') ?? "";
    bool privacyAccept = prefs.getBool('privacyAccept') ?? false;
    if (privacyAccept == false) {
      if (!mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return const PrivacyPage(
          fromWhere: false,
        );
      }));
    }
    else {
      if (widget.msgType != "") {
        if (!mounted) {
          return;
        }
        widget.msgType == "news"
            ?

            ///need to change it soon
            /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
           return DemoPage(
                  url: widget.output['link'],
                  activity: false,
                  image: widget.output['image_url'],
                  text: widget.output['title'],
                  type: 'news',
                  id: "",
                  checkMain: true,
                ); }))*/
            Get.to(const DemoView(), arguments: {"id": "", "type": "news", "url": widget.output['link'], "fromLink": true})
            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return YoutubePlayerLandscapeScreen(
                  id: widget.output['video_id'],
                  comeFrom: "main",
                );
              }));
      } else {
        if (widget.initialLink != null) {
          final Uri deepLink = widget.initialLink!.link;
          dynamics = deepLink.pathSegments;
          if (mainUserId != null) {
            if (dynamics[0] == "DemoPage") {
              ///need to change it soon
              /*if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return DemoPage(
                  image: '',
                  text: '',
                  id: dynamics[1],
                  url: '',
                  type: dynamics[2],
                  activity: false,
                  checkMain: true,
                );
              }));*/
              Get.to(const DemoView(), arguments: {"id": dynamics[1], "type": dynamics[2], "url": "", "fromLink": true});
            } else if (dynamics[0] == "VideoDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return YoutubePlayerLandscapeScreen(
                  id: dynamics[1],
                  comeFrom: "main",
                );
              }));
            } else if (dynamics[0] == "ForumPostDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return ForumPostDescriptionPage(
                  forumId: dynamics[1],
                  comeFrom: 'main',
                  idList: const [],
                );
              }));
            } else if (dynamics[0] == "FeaturePostDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return mainSkipValue
                    ? const FeatureRequestPage(
                        fromWhere: "link",
                      )
                    : FeaturePostDescriptionPage(
                        navBool: 'main',
                        sortValue: dynamics[3],
                        featureId: dynamics[1],
                        featureDetail: const {},
                        idList: const [],
                      );
              }));
            } else if (dynamics[0] == "AnalyticsPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return AnalyticsPage(
                  surveyTitle: dynamics[3],
                  activity: true,
                  surveyId: dynamics[1],
                );
              }));
            } else if (dynamics[0] == "HomeScreen") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const MainBottomNavigationPage(
                    tType: true, text: "", caseNo1: 0, newIndex: 0, excIndex: 1, countryIndex: 0, isHomeFirstTym: true);
              }));
            } else if (dynamics[0] == "LockerPage") {
              finalisedCategory = dynamics[1];
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return MainBottomNavigationPage(
                  tType: true,
                  text: dynamics[1],
                  caseNo1: 1,
                  newIndex: 0,
                  excIndex: 1,
                  countryIndex: 0,
                  fromLink: true,
                  isHomeFirstTym: false,
                );
              }));
            } else if (dynamics[0] == "FeatureRequestPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const FeatureRequestPage(
                  fromWhere: "link",
                );
              }));
            } else if (dynamics[0] == "StocksAddFilterPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return mainSkipValue
                    ? const MainBottomNavigationPage(
                        caseNo1: 0,
                        text: '',
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        tType: true,
                        isHomeFirstTym: true,
                      )
                    : const StocksAddFilterPage(
                        text: 'Stocks',
                        page: 'locker',
                      );
              }));
            } else if (dynamics[0] == "NewsMainPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return NewsMainPage(
                  tickerId: '',
                  tickerName: '',
                  text: dynamics[1],
                  fromCompare: false,
                );
              }));
            } else if (dynamics[0] == "VideosMainPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return VideosMainPage(
                  tickerId: '',
                  tickerName: '',
                  text: dynamics[1],
                  fromCompare: false,
                );
              }));
            } else if (dynamics[0] == "ForumPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return ForumPage(text: dynamics[1]);
              }));
            } else if (dynamics[0] == "SurveyPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SurveyPage(text: dynamics[1]);
              }));
            } else if (dynamics[0] == "FeaturePostPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const FeaturePostPage(
                  fromLink: true,
                );
              }));
            } else if (dynamics[0] == "ForumPostPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return ForumPostPage(
                  text: dynamics[1],
                  fromLink: true,
                );
              }));
            } else if (dynamics[0] == "SurveyPostPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SurveyPostPage(
                  text: dynamics[1],
                  fromLink: true,
                );
              }));
            } else if (dynamics[0] == "WatchList") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const WatchList(
                  excIndex: 1,
                  countryIndex: 0,
                  newIndex: 0,
                );
              }));
            } else if (dynamics[0] == "AddWatchlistPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return AddWatchlistPage(
                    excIndex: int.parse(dynamics[2][1]),
                    countryIndex: int.parse(dynamics[2][2]),
                    newIndex: int.parse(dynamics[2][0]),
                    tickerId: dynamics[1]);
              }));
            } else if (dynamics[0] == "TickersDetailsPage") {
              switch (dynamics[2]) {
                case "000":
                  {
                    if (!mounted) {
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'US',
                        country: 'USA',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "010":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "020":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'BSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "100":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'crypto',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "200":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'commodity',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "201":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'commodity',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'USA',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "300":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'forex',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'USA',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                default:
                  {
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
              }
            } else if (dynamics[0] == "SetAlertPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SetAlertPage(
                  tickerId: dynamics[1],
                  indexValue: dynamics[2],
                  fromWhere: "main",
                );
              }));
            } else if (dynamics[0] == "MyActivityPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return mainSkipValue
                    ? const MainBottomNavigationPage(
                        caseNo1: 0,
                        text: '',
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        tType: true,
                        isHomeFirstTym: true,
                      )
                    : const MyActivityPage(
                        fromLink: true,
                      );
              }));
            } else if (dynamics[0] == "BlockListPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return mainSkipValue
                    ? const MainBottomNavigationPage(
                        caseNo1: 0,
                        text: '',
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        tType: true,
                        isHomeFirstTym: true,
                      )
                    : const BlockListPage(tabIndex: 0, blockBool: true, fromLink: true);
              }));
            } else if (dynamics[0] == "SettingsPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return mainSkipValue ? const SettingsSkipView() : const SettingsView();
              }));
            } else if (dynamics[0] == "EditProfilePage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return mainSkipValue
                    ? const MainBottomNavigationPage(
                        caseNo1: 0,
                        text: '',
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        tType: true,
                        isHomeFirstTym: true,
                      )
                    : const EditProfilePage(
                        comeFrom: true,
                      );
              }));
            } else if (dynamics[0] == "FinalChartPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return FinalChartPage(
                  tickerId: dynamics[1],
                  category: dynamics[2],
                  exchange: dynamics[3],
                  chartType: dynamics[4],
                  fromLink: true,
                  index: 0,
                );
              }));
            } else if (dynamics[0] == "BillBoardHome") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return MainBottomNavigationPage(
                    caseNo1: 2,
                    text: finalisedCategory.toString().capitalizeFirst ?? "Stocks",
                    excIndex: 1,
                    newIndex: 0,
                    countryIndex: 0,
                    isHomeFirstTym: false,
                    tType: true);
              }));
            } else if (dynamics[0] == "BytesDescriptionPage") {
              if (!mounted) {
                return;
              }
              mainVariables.selectedBillboardIdMain.value = dynamics[1];
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const BytesDescriptionPage(
                  fromWhere: "main",
                );
              }));
            } else if (dynamics[0] == "BlogDescriptionPage") {
              if (!mounted) {
                return;
              }
              mainVariables.selectedBillboardIdMain.value = dynamics[1];
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const BlogDescriptionPage(
                  fromWhere: "main",
                );
              }));
            } else if (dynamics[0] == "UserProfilePage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return UserBillBoardProfilePage(
                  userId: dynamics[1],
                  fromLink: "main",
                );
              }));
            } else if (dynamics[0] == "IntermediaryPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return IntermediaryBillBoardProfilePage(
                  userId: dynamics[1],
                  fromLink: "main",
                );
              }));
            } else if (dynamics[0] == "BusinessProfilePage") {
              if (!mounted) {
                return;
              }
              mainVariables.selectedTickerId.value = dynamics[1];
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const BusinessProfilePage(
                  fromLink: "main",
                );
              }));
            } else {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const MainBottomNavigationPage(
                  caseNo1: 0,
                  text: '',
                  excIndex: 1,
                  newIndex: 0,
                  countryIndex: 0,
                  tType: true,
                  isHomeFirstTym: true,
                );
              }));
            }
          } else {
            if (dynamics[0] == "DemoPage") {
              ///need to change it soon
              /* if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return DemoPage(
                  image: '',
                  text: '',
                  id: dynamics[1],
                  url: '',
                  type: dynamics[2],
                  activity: false,
                  checkMain: true,
                );
              }));*/
              Get.to(const DemoView(), arguments: {"id": dynamics[1], "type": dynamics[2], "url": "", "fromLink": true});
            } else if (dynamics[0] == 'CreatePasswordPage') {
              setState(() {
                prefs.setString('userId', dynamics[1]);
              });
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const CreatePasswordPage();
              }));
            } else if (dynamics[0] == 'SignUpPage') {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignUpPage(
                  socialId: '',
                  devType: Platform.isIOS ? "ios" : "android",
                  lastName: '',
                  type: '',
                  referralCode: '',
                  phoneCode: '',
                  phoneNumber: '',
                  noPass: false,
                  firstName: '',
                  userName: '',
                  socialAvatar: '',
                  email: '',
                );
              }));
            } else if (dynamics[0] == 'SignInPage') {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const SignInPage(
                  fromWhere: "link",
                );
              }));
            } else if (dynamics[0] == "VideoDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return YoutubePlayerLandscapeScreen(
                  id: dynamics[1],
                  comeFrom: "main",
                );
              }));
            } else if (dynamics[0] == "ForumPostDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  navBool: 'main',
                  id: dynamics[1],
                  category: dynamics[3],
                  filterId: dynamics[4],
                  toWhere: dynamics[0],
                  fromWhere: "link",
                );

                /*ForumPostDescriptionPage(
                  forumId:dynamics[1],
                  catIdList: mainCatIdList,
                  text:dynamics[3],
                  filterId: dynamics[4],
                  forumDetail:{},
                  navBool: 'main',)*/
              }));
            } else if (dynamics[0] == "FeaturePostDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  navBool: 'main',
                  id: dynamics[1],
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  fromWhere: "link",
                );
                /*FeaturePostDescriptionPage(
                  navBool: 'main',
                  sortValue:dynamics[3],
                  featureId: dynamics[1],
                  featureDetail: {},
                );*/
              }));
            } else if (dynamics[0] == "AnalyticsPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  navBool: 'main',
                  id: dynamics[1],
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );

                /*AnalyticsPage(surveyTitle: dynamics[3], activity: true, surveyId: dynamics[1],);*/
              }));
            } else if (dynamics[0] == "HomeScreen") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const MainBottomNavigationPage(
                    tType: true, text: "", caseNo1: 0, newIndex: 0, excIndex: 1, countryIndex: 0, isHomeFirstTym: true);
              }));
            } else if (dynamics[0] == "LockerPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const LockerSkipScreen();
                /*MainBottomNavigationPage(tType: true, text: dynamics[1], caseNo1: 1, newIndex: 0, excIndex: 1, countryIndex: 0,fromLink: true,isHomeFirstTym:false,);*/
              }));
            } else if (dynamics[0] == "FeatureRequestPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const FeatureRequestPage(
                  fromWhere: "link",
                );
              }));
            } else if (dynamics[0] == "StocksAddFilterPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const SignInPage(
                  category: 'Stocks',
                  toWhere: "StocksAddFilterPage",
                  fromWhere: "link",
                );
                /*StocksAddFilterPage(text: 'Stocks', page: 'locker',);*/
              }));
            } else if (dynamics[0] == "NewsMainPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return NewsMainPage(
                  tickerId: '',
                  tickerName: '',
                  text: dynamics[1],
                  fromCompare: false,
                );
              }));
            } else if (dynamics[0] == "VideosMainPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return VideosMainPage(
                  tickerId: '',
                  tickerName: '',
                  text: dynamics[1],
                  fromCompare: false,
                );
              }));
            } else if (dynamics[0] == "ForumPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  fromWhere: "link",
                ); /*ForumPage(text: dynamics[1]);*/
              }));
            } else if (dynamics[0] == "SurveyPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  fromWhere: "link",
                ); /*SurveyPage(text: dynamics[1]);*/
              }));
            } else if (dynamics[0] == "ComparePage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /* ComparePage(text: dynamics[3],fromLink: true,);*/
              }));
            } else if (dynamics[0] == "FeaturePostPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                ); /*FeaturePostPage(fromLink: true,);*/
              }));
            } else if (dynamics[0] == "ForumPostPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /*ForumPostPage(text:dynamics[1],fromLink: true,);*/
              }));
            } else if (dynamics[0] == "SurveyPostPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  category: dynamics[3],
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /*SurveyPostPage(text:dynamics[1],fromLink: true,);*/
              }));
            } else if (dynamics[0] == "WatchList") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const WatchList(
                  excIndex: 1,
                  countryIndex: 0,
                  newIndex: 0,
                );
              }));
            } else if (dynamics[0] == "AddWatchlistPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return AddWatchlistPage(
                    excIndex: int.parse(dynamics[2][1]),
                    countryIndex: int.parse(dynamics[2][2]),
                    newIndex: int.parse(dynamics[2][0]),
                    tickerId: dynamics[1]);
              }));
            } else if (dynamics[0] == "TickersDetailsPage") {
              switch (dynamics[2]) {
                case "000":
                  {
                    if (!mounted) {
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'US',
                        country: 'USA',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "010":
                  {
                    if (!mounted) {
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "020":
                  {
                    if (!mounted) {
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'BSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "100":
                  {
                    if (!mounted) {
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'crypto',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "200":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'commodity',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "201":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'commodity',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'USA',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                case "300":
                  {
                    if (!mounted) {
                      return;
                    }
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'forex',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'USA',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
                  break;
                default:
                  {
                    // mainVariables.selectedTickerId.value=dynamics[1];
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                        category: 'stocks',
                        id: dynamics[1],
                        exchange: 'NSE',
                        country: 'India',
                        name: '',
                        fromWhere: "main",
                      );
                    }));
                  }
              }
            } else if (dynamics[0] == "SetAlertPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SetAlertPage(
                  tickerId: dynamics[1],
                  indexValue: dynamics[2],
                  fromWhere: "main",
                );
              }));
            } else if (dynamics[0] == "MyActivityPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /*MyActivityPage(fromLink: true,);*/
              }));
            } else if (dynamics[0] == "BlockListPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                ); /*BlockListPage(tabIndex: 0, blockBool: true,fromLink: true);*/
              }));
            } else if (dynamics[0] == "SettingsPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const SettingsSkipView();
              }));
            } else if (dynamics[0] == "EditProfilePage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /*EditProfilePage(comeFrom: true,);*/
              }));
            } else if (dynamics[0] == "FinalChartPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return FinalChartPage(
                  tickerId: dynamics[1],
                  category: dynamics[2],
                  exchange: dynamics[3],
                  chartType: dynamics[4],
                  fromLink: true,
                  index: 0,
                );
              }));
            } else if (dynamics[0] == "BillBoardHome") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
              }));
            } else if (dynamics[0] == "BytesDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /*MyActivityPage(fromLink: true,);*/
              }));
            } else if (dynamics[0] == "BlogDescriptionPage") {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SignInPage(
                  toWhere: dynamics[0],
                  activity: true,
                  fromWhere: "link",
                );
                /*MyActivityPage(fromLink: true,);*/
              }));
            } else {
              if (!mounted) {
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const MainBottomNavigationPage(
                  caseNo1: 0,
                  text: '',
                  excIndex: 1,
                  newIndex: 0,
                  countryIndex: 0,
                  tType: true,
                  isHomeFirstTym: true,
                );
              }));
            }
          }
        } else {
          if (!mounted) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
              caseNo1: 0,
              text: '',
              excIndex: 1,
              newIndex: 0,
              countryIndex: 0,
              tType: true,
              isHomeFirstTym: true,
            );
          }));
        }
      }
    }
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  getInitData() async {
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();
    conversationFunctionsMain.getSocketFunction(context: context);
    functionsMain.getGeneralData();
    await functionsMain.fireBaseCloudMessagingListeners();
    await getValues();
    startTime();
    await getEx();
    await getAllDataMain(name: 'Splash_Screen');
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: animation.value * 330,
                height: animation.value * 60,
                child: SvgPicture.asset(
                  isDarkTheme.value ? "assets/splash_screen/logo_text_dark.svg" : "assets/splash_screen/logo_text_light.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
