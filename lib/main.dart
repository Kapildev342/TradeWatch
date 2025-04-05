import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local;
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salesiq_mobilisten/launcher.dart';
import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'package:tradewatchfinal/firebase_options.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'Screens/Module1/Login/sign_in_page.dart';
import 'Screens/Module1/Login/splash_page.dart';
import 'Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'Screens/Module1/bottom_navigation.dart';
import 'Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'Screens/Module2/Forum/detailed_forum_image_page.dart';
import 'Screens/Module2/Forum/forum_post_description_page.dart';
import 'Screens/Module2/Survey/analytics_page.dart';
import 'Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'Screens/Module3/BookMarks/BookMarkWidget/MultipleOne/book_mark_multiple_widget_bloc.dart';
import 'Screens/Module3/Translation/DoubleOne/translation_widget_single_bloc.dart';
import 'Screens/Module3/Translation/ForSurvey/translation_survey_bloc.dart';
import 'Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'Screens/Module4/response_page.dart';
import 'Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'Screens/Module6/WidgetsBloc/CommentLikeButton/comment_like_button_bloc.dart';
import 'Screens/Module6/WidgetsBloc/LikeButtonAllWidgetBloc/like_button_all_widget_bloc.dart';
import 'Screens/Module6/WidgetsBloc/LikeButtonList/like_button_list_widget_bloc.dart';
import 'Screens/Module6/WidgetsBloc/MultipleLikeButton/multiple_like_button_bloc.dart';
import 'Screens/Module6/WidgetsBloc/ResponseField/response_field_widget_bloc.dart';
import 'Screens/Module6/WidgetsBloc/SingleLikeButton/single_like_button_bloc.dart';
import 'Screens/Module6/WidgetsBloc/TranslationWidget/bill_board_translation_bloc.dart';
import 'Screens/Module7/ConversationModels/conversation_models.dart';
import 'Screens/Module7/ConversationScreens/conversation_page.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ["D5FADCD990EAE787E640852882FEDEE6"]));
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    if (io.Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            return null;
          },
        ));
      }
    }
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //Stripe.publishableKey = "pk_live_51OmwOGSC7ezFZkHHVPA2Q0hmevXjkzvzVtkvw86hJUkn6EejIQtvBUmLJjKA7ZZBG9c0IAMsf2AJkZWmoSMRyFnC00ccoCQXKk";
    await dotenv.load(fileName: "lib/Constants/Assets/keys.env");
    PendingDynamicLinkData? initialLink;
    if (io.Platform.isIOS) {
      await Future.delayed(const Duration(seconds: 2), () async {
        initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
      });
    } else {
      initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    if (io.Platform.isAndroid) {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
    runApp(MyApp(
      initialLink: initialLink,
    ));
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  final PendingDynamicLinkData? initialLink;

  const MyApp({
    super.key,
    required this.initialLink,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> dynamics = [];
  bool deep = false;
  String newId = "";
  String newPage = "";
  String msgType = "";
  String category = "";
  Map<String, dynamic> output = {};

  @override
  void initState() {
    initPlatformState();
    initMobiListen();
    super.initState();
    fireOnMessageOpenedApp();
  }

  fireOnMessageOpenedApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //mainSkipValue=prefs.getBool('skipValue')??true;
    mainSkipValue = prefs.getString('newUserToken') == null ? true : false;
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      output = jsonDecode(message.data['data']);
      msgType = output['type'];
      List<String> dataList = output["link"].split("\$&:\$");
      output['scheduled_id'] == null ? () {} : schedulingFunction(id: output['scheduled_id']);
      if (output['type'] == "news") {
        ///need to change it soon
        /* Navigator.push(
            navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder:
                    (context) => */ /*NewsDescriptionPage(id: output['video_id'],
                idList: [], descriptionList: [], snippetList: [], comeFrom: 'main')*/ /*
                        DemoPage(
                          url: '',
                          activity: false,
                          image: output['image_url'],
                          text: output['title'],
                          type: 'news',
                          id: output['video_id'],
                          checkMain: true,
                        )));*/
        Get.to(const DemoView(), arguments: {"id": output['video_id'], "type": 'news', "url": "", "fromLink": true});
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
            navigatorKey.currentState!.context,
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
            navigatorKey.currentState!.context,
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
            navigatorKey.currentState!.context,
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
        Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (BuildContext context) {
          return const ConversationPage(
            fromLink: "main",
          );
        }));
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    heightMain = MediaQuery.of(context).size.height;
    widthMain = MediaQuery.of(context).size.width;
    textScalarMain = MediaQuery.of(context).textScaler;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BookMarkWidgetBloc()),
        BlocProvider(create: (context) => BookMarkSingleWidgetBloc()),
        BlocProvider(create: (context) => BookMarkMultipleWidgetBloc()),
        BlocProvider(create: (context) => TranslationWidgetBloc()),
        BlocProvider(create: (context) => TranslationWidgetSingleBloc()),
        BlocProvider(create: (context) => TranslationSurveyBloc()),
        BlocProvider(create: (context) => LikeButtonListWidgetBloc()),
        BlocProvider(create: (context) => ResponseFieldWidgetBloc()),
        BlocProvider(create: (context) => CommentLikeButtonBloc()),
        BlocProvider(create: (context) => SingleLikeButtonBloc()),
        BlocProvider(create: (context) => MultipleLikeButtonBloc()),
        BlocProvider(create: (context) => BillBoardTranslationBloc()),
        BlocProvider(create: (context) => LikeButtonAllWidgetBloc()),
      ],
      child: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'TradeWatch',
          /* theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: const Color(0XFF0EA102),
            scaffoldBackgroundColor: Colors.white,
            switchTheme: SwitchThemeData(
                thumbColor: const MaterialStatePropertyAll<Color>(Colors.white),
                trackColor: MaterialStatePropertyAll<Color>(Colors.grey.shade300),
                trackOutlineColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                trackOutlineWidth: const MaterialStatePropertyAll<double>(0.0)),
            bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF0EA102), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
            dialogTheme: const DialogTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, surfaceTint: Colors.white, primary: Colors.white, secondary: Colors.white),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
            dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 1),
            fontFamily: 'Poppins',
            radioTheme: const RadioThemeData(fillColor: MaterialStatePropertyAll<Color>(Color(0XFF0EA102))),
            tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent, dividerHeight: 0.0),
            floatingActionButtonTheme:
                const FloatingActionButtonThemeData(shape: CircleBorder(), backgroundColor: Color(0XFF0EA102), foregroundColor: Colors.white)),*/
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentTheme.value,
          home: SplashScreen(initialLink: widget.initialLink, msgType: msgType, output: output),
        ),
      ),
    );
    /*MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomePageBloc(),),
        BlocProvider(create: (context) => HomePageTabBloc()),
        BlocProvider(create: (context) => HomePageSearchBloc(),),
        BlocProvider(create: (context) => HomeSearchBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'TradeWatch',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Poppins',
        ),
        home: SplashScreen(
          msgType: msgType,
          output: output,
          initialLink: widget.initialLink,
        ),
      ),
    );*/
  }
}

class Routes {
  static const String createPasswordPage = '/CreatePasswordPage';
}

Future<void> cancelAllNotifications() async {
  await local.AndroidFlutterLocalNotificationsPlugin().cancelAll();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future firebaseInitialize() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  if (io.Platform.isIOS) {
    firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

Future<void> initMobiListen() async {
  if (io.Platform.isIOS || io.Platform.isAndroid) {
    String appKey;
    String accessKey;
    if (io.Platform.isIOS) {
      appKey = "4xGrEyoCNh%2BDlzmReSdaxK2lJwHgbd%2FVL%2FoqR92se95j5MY7Dj1PTTadnTQzdY23_in";
      accessKey =
          "aiuio6MHUWkTHKT1VWB1iCHhp22j%2FLtXOsFSd0omA9BQXM3Qdq9V8QQ9boG0rLE7z4U6SyqOCNZWrHRSXf3tQOQaY8PiVGwOirORe7SuVdeHPOQemo36MJ4UhWy0dFMatEQUnbdN9%2FhB0R%2FIOaZHjfr9fCvJ8xrfu7PEDZ6s4UU%3D";
    } else {
      appKey = "4xGrEyoCNh%2BDlzmReSdaxK2lJwHgbd%2FVL%2FoqR92se95j5MY7Dj1PTTadnTQzdY23_in";
      accessKey =
          "aiuio6MHUWkTHKT1VWB1iCHhp22j%2FLtXOsFSd0omA9BQXM3Qdq9V8QQ9boG0rLE7z4U6SyqOCNZbrpBa%2Bb5XVSFI0jaJ8fegJHaPuH5UzWmn%2FfKBHOD%2FO0U%2BIPKVsX2FtEQUnbdN9%2FhB0R%2FIOaZHjfr9fCvJ8xrfu7PEDZ6s4UU%3D";
    }
    ZohoSalesIQ.init(appKey, accessKey).then((_) {
      ZohoSalesIQ.launcher.show(VisibilityMode.never);
    }).catchError((error) {});
  }
}

Future<void> initPlatformState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String themeValue = prefs.getString("theme") ?? "light";
  currentTheme.value = themeValue == "light" ? ThemeMode.light : ThemeMode.dark;
  isDarkTheme.value = themeValue == "dark";
  return;
}
