import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Edited_Packages/TutorialCoachMark/tutorial_coach_mark.dart';
import 'package:tradewatchfinal/Edited_Packages/expandable_button/flutter_expandable_fab.dart';
import 'package:tradewatchfinal/Edited_Packages/expandable_button/src/expandable_fab.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/profile_data_model.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_post_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_post_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/popular_traders_page.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/LikeButtonList/like_button_list_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/ResponseField/response_field_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/TranslationWidget/bill_board_translation_bloc.dart';

import 'bill_board_home_widgets.dart';
import 'bill_board_home_widgets2.dart';
import 'content_filter_page.dart';

class BillBoardHome extends StatefulWidget {
  const BillBoardHome({Key? key}) : super(key: key);

  @override
  State<BillBoardHome> createState() => _BillBoardHomeState();
}

class _BillBoardHomeState extends State<BillBoardHome> with TickerProviderStateMixin {
  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
  bool customError = false;
  bool switchValue = false;
  bool loader = false;
  bool listLoader = false;
  bool searchEnabled = false;
  late ProfileDataModel profile;
  int skipBillBoardCount = 0;
  int skipSurveyCount = 0;
  int skipForumCount = 0;
  int skipNewsCount = 0;
  late TutorialCoachMark tutorialCoachMark;
  late TutorialCoachMark tutorialCoachMark2;
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  bool isOpen = true;
  bool isLatestFeedAvailable = false;
  final RefreshController _controller = RefreshController();
  ScrollController scrollController = ScrollController();
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  BillBoardHomeWidget adWidget = BillBoardHomeWidget();
  BillBoardHomeWidget2 normalWidget = BillBoardHomeWidget2();

  @override
  void initState() {
    mainVariables.initialPostDate.value = "";
    scrollController.addListener(() {
      double showOffset = 100.0;
      if (scrollController.offset > showOffset) {
        isLatestFeedAvailable = true;
        setState(() {});
      } else {
        isLatestFeedAvailable = false;
        setState(() {});
      }
    });
    getAllDataMain(name: mainVariables.activeTypeMain.value == "believed" ? 'BillBoard_Home_Believed' : 'BillBoard_Home_General');
    getData();
    super.initState();
  }

  getData() async {
    if (mainSkipValue == false) {
      createTutorial();
      context.read<LikeButtonListWidgetBloc>().add(const LikeButtonListLoadingEvent());
      context.read<ResponseFieldWidgetBloc>().add(const ResponseFieldInitialEvent());
      context.read<BillBoardTranslationBloc>().add(const BillBoardLoadingTranslationEvent());
      context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
      billBoardFunctionsMain.getNotifyCountAndImage();
      profile = await settingsMain.getData();
      mainVariables.userNameMyselfMain = profile.response.username;
      mainVariables.firstNameMyselfMain = profile.response.firstName;
      mainVariables.lastNameMyselfMain = profile.response.lastName;
      mainVariables.believersCountMainMyself.value = profile.response.believedCount;
      switchValue = mainVariables.activeTypeMain.value == "believed";
      if (!mounted) {
        return;
      }
      await billBoardApiMain.getPopularTraderData(searchValue: '', context: context);
      await getBillBoardListData();
    }
  }

  getBillBoardListData() async {
    setState(() {
      listLoader = false;
    });
    mainVariables.valueMapListProfilePage.clear();
    mainVariables.responseFocusList.clear();
    mainVariables.isUserTaggingList.clear();
    mainVariables.responseControllerList.clear();
    mainVariables.pickedImageMain.clear();
    mainVariables.pickedVideoMain.clear();
    mainVariables.pickedFileMain.clear();
    mainVariables.docMain.clear();
    mainVariables.selectedUrlTypeMain.clear();
    mainVariables.docFilesMain.clear();
    mainVariables.initialPostDate.value = "";
    nativeAdList.clear();
    nativeAdIsLoadedList.clear();
    await billBoardApiMain.getBillBoardListApiFunc(
      context: context,
      category: mainVariables.contentCategoriesMain,
      contentType: mainVariables.contentTypeMain.value,
      profile: mainVariables.selectedProfileMain.value,
      skipBillBoardCount: 0,
      skipForumCount: 0,
      skipSurveyCount: 0,
      skipNewsCount: 0,
      tickers: [],
      userId: '',
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainVariables.isFirstTime.value = prefs.getBool("isFirstTime") ?? true;
    if (mainVariables.billBoardDataProfilePage!.value.response.isNotEmpty) {
      mainVariables.valueMapListProfilePage.addAll(mainVariables.billBoardDataProfilePage!.value.response);
      mainVariables.initialPostDate.value = mainVariables.valueMapListProfilePage[0].dateTime;
      if (mainVariables.billBoardDataProfilePage!.value.newCounts != 0) {
        setState(() {
          isLatestFeedAvailable = true;
          mainVariables.latestFeedCounts.value = mainVariables.billBoardDataProfilePage!.value.newCounts;
        });
      } else {
        setState(() {
          isLatestFeedAvailable = false;
          mainVariables.latestFeedCounts.value = 0;
        });
      }
      for (int i = 0; i < mainVariables.billBoardDataProfilePage!.value.response.length; i++) {
        mainVariables.responseFocusList.add(FocusNode());
        mainVariables.isUserTaggingList.add(false);
        // mainVariables.globalKeyList.add(GlobalKey());
        mainVariables.responseControllerList.add(TextEditingController());
        mainVariables.pickedImageMain.add(null);
        mainVariables.pickedVideoMain.add(null);
        mainVariables.pickedFileMain.add(null);
        mainVariables.docMain.add(null);
        mainVariables.selectedUrlTypeMain.add("");
        mainVariables.docFilesMain.add([]);
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
      }
      if (mainVariables.activeTypeMain.value == "believed" &&
          mainVariables.believersCountMainMyself.value < 3 &&
          mainVariables.isFirstTime.value == true) {
        Future.delayed(Duration.zero, showTutorial);
        setState(() {});
      } else if (mainVariables.activeTypeMain.value == "believed" &&
          mainVariables.believersCountMainMyself.value >= 3 &&
          mainVariables.isFirstTime.value == true) {
        isOpen = false;
        Future.delayed(Duration.zero, showTutorial2);
        setState(() {});
      }
      setState(() {
        listLoader = true;
        loader = true;
      });
    } else {
      if (mainVariables.activeTypeMain.value == "believed" &&
          mainVariables.believersCountMainMyself.value < 3 &&
          mainVariables.isFirstTime.value == true) {
        Future.delayed(Duration.zero, showTutorial);
        setState(() {});
      } else if (mainVariables.activeTypeMain.value == "believed" &&
          mainVariables.believersCountMainMyself.value >= 3 &&
          mainVariables.isFirstTime.value == true) {
        isOpen = false;
        Future.delayed(Duration.zero, showTutorial2);
        setState(() {});
      }
      setState(() {
        listLoader = true;
        loader = true;
      });
    }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      hideSkip: true,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      onFinish: () {},
      onClickTarget: (target) {
        tutorialCoachMark.finish();
        mainVariables.isJourney.value = true;
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const PopularTradersPage()));
      },
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {},
    );
    tutorialCoachMark2 = TutorialCoachMark(
      targets: _createTargets2(),
      hideSkip: true,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {},
      onClickTarget: (target) {
        if (target.identify == "fab") {
          mainVariables.isJourney.value = true;
          isOpen = true;
          _key.currentState!.toggle();
          tutorialCoachMark2.next();
          setState(() {});
        } else if (target.identify == "bytes") {
          tutorialCoachMark2.finish();
          _key.currentState!.toggle();
          mainVariables.isJourney.value = true;
          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BytesPostPage()));
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {},
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "start",
        keyTarget: keyButton,
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height / 5.77,
                    margin: EdgeInsets.symmetric(horizontal: width / 6.85),
                    padding: EdgeInsets.symmetric(vertical: height / 57.73, horizontal: width / 27.4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Engaging",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Text(
                          "Dive into the world of traders. Click here to start connecting with fellow traders and enhance your network.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(10),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "1/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102)),
                                onPressed: () {
                                  tutorialCoachMark.finish();
                                  mainVariables.isJourney.value = true;
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const PopularTradersPage()));
                                },
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: text.scale(8),
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg")
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    return targets;
  }

  List<TargetFocus> _createTargets2() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "fab",
        keyTarget: keyButton2,
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: height / 9.62,
                    margin: EdgeInsets.only(left: width / 3.425, right: width / 41.1),
                    padding: EdgeInsets.symmetric(vertical: height / 57.73, horizontal: width / 27.4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Introduce Yourself to the Community.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: text.scale(10.0),
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "3/12",
                                    style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102)),
                                onPressed: () {
                                  isOpen = true;
                                  _key.currentState!.toggle();
                                  tutorialCoachMark2.next();
                                  mainVariables.isJourney.value = true;
                                  setState(() {});
                                },
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: text.scale(8),
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width / 20.55),
                    child: SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg"),
                  )
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "bytes",
        keyTarget: keyButton3,
        color: Colors.black26.withOpacity(0.1),
        paddingFocus: 0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height / 6.185,
                    margin: EdgeInsets.only(left: width / 13.7, right: width / 13.7),
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post Your First Byte",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Text(
                          "Share a snippet of your trading wisdom. Create a byte to introduce yourself to the community..",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(10),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "4/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102)),
                                onPressed: () {
                                  tutorialCoachMark2.finish();
                                  _key.currentState!.toggle();
                                  mainVariables.isJourney.value = true;
                                  //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BytesPostPage()));
                                },
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: text.scale(8),
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width / 11.74),
                    child: SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg"),
                  )
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );
    return targets;
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void showTutorial2() {
    tutorialCoachMark2.show(context: context);
  }

  @override
  void didChangeDependencies() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adVariables.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          onAdOpened: (Ad ad) {},
          onAdClosed: (Ad ad) {},
        ),
        request: const AdRequest())
      ..load();
    Future.delayed(const Duration(milliseconds: 500), () {
      mainSkipValue ? commonFlushBar(context: context, initFunction: getData, fromWhere: 'billboard') : debugPrint("nothing");
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    _key.currentState == null ? debugPrint("do nothing") : _key.currentState!.deactivate();
    mainVariables.billBoardSearchControllerMain.value.clear();
    mainVariables.billBoardListSearchControllerMain.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      //color: Colors.white,
      color: Theme.of(context).colorScheme.background,
      child: WillPopScope(
          onWillPop: () async {
            if (tutorialCoachMark.isShowing) {
              tutorialCoachMark.finish();
            } else if (tutorialCoachMark2.isShowing) {
              tutorialCoachMark2.finish();
            } else {
              if (mainVariables.billBoardSearchControllerMain.value.text.isEmpty) {
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
              } else {
                getBillBoardListData();
                mainVariables.billBoardSearchControllerMain.value.clear();
                FocusManager.instance.primaryFocus?.unfocus();
                mainVariables.billBoardSearchControllerMain.refresh();
                setState(() {});
              }
            }
            return false;
          },
          child: SafeArea(
            child: loader
                ? Obx(
                    () => Scaffold(
                      backgroundColor: isDarkTheme.value
                          ? const Color(0XFF1E1E1F)
                          : const Color(0XFFF9FFF9).withOpacity(0.3), //const Color(0XFFF9FFF9).withOpacity(0.3),
                      appBar: loader
                          ? AppBar(
                              //backgroundColor: const Color(0XFFFFFFFF),
                              backgroundColor: Theme.of(context).colorScheme.background,
                              automaticallyImplyLeading: false,
                              leadingWidth: 0,
                              toolbarHeight: mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty ? height / 12.73 : height / 6.5,
                              shape: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                              elevation: 5,
                              shadowColor: Theme.of(context).colorScheme.tertiary,
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height / 84.4,
                                  ),
                                  SizedBox(
                                    height: height / 23.2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (tutorialCoachMark.isShowing) {
                                                tutorialCoachMark.finish();
                                              } else if (tutorialCoachMark2.isShowing) {
                                                tutorialCoachMark2.finish();
                                              } else {
                                                if (mainVariables.billBoardSearchControllerMain.value.text.isEmpty) {
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
                                                } else {
                                                  getBillBoardListData();
                                                  mainVariables.billBoardSearchControllerMain.value.clear();
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                  mainVariables.billBoardSearchControllerMain.refresh();
                                                  setState(() {});
                                                }
                                              }
                                            },
                                            child: Icon(
                                              Icons.arrow_back_rounded,
                                              //color: Color(0XFF777777),
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              size: 25,
                                            )),
                                        SizedBox(
                                          width: width / 51.375,
                                        ),
                                        Expanded(
                                          child: billboardWidgetsMain.getSearchField(
                                            context: context,
                                            modelSetState: setState,
                                            billBoardFunction: getBillBoardListData,
                                          ),
                                        ),
                                        Obx(
                                          () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 19.6,
                                                ),
                                        ),
                                        Obx(
                                          () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : billboardWidgetsMain.getMessageBadge(context: context),
                                        ),
                                        Obx(
                                          () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 23.43,
                                                ),
                                        ),
                                        Obx(
                                          () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : GestureDetector(
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
                                        ),
                                        Obx(
                                          () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: width / 51.375,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height / 84.4),
                                  Obx(() => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            billboardWidgetsMain.getProfile(
                                              context: context,
                                              heightValue: height / 14.93,
                                              widthValue: width / 7.08,
                                              myself: true,
                                              isProfile: profile.response.profileType == "" ? "user" : profile.response.profileType,
                                              userId: userIdMain,
                                              getBillBoardListData: getBillBoardListData,
                                            ),
                                            SizedBox(
                                              width: height / 56.26,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        bool response =
                                                            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return UserBillBoardProfilePage(userId: userIdMain);
                                                        }));
                                                        if (response) {
                                                          getBillBoardListData();
                                                        }
                                                      },
                                                      child: Text("Hi, ${profile.response.firstName}!" /* ${profile.response.lastName}*/,
                                                          /*style: TextStyle(
                                                            fontSize: text.scale(18), fontWeight: FontWeight.w700, color: const Color(0XFF2F2F2F)),*/
                                                          style: Theme.of(context).textTheme.titleMedium),
                                                    ),
                                                    const Text(
                                                      '😄',
                                                      style: TextStyle(fontSize: 20),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        billboardWidgetsMain.believersTabBottomSheet(
                                                          context: context,
                                                          id: userIdMain,
                                                          isBelieversList: true,
                                                        );
                                                      },
                                                      child: Text(
                                                        "You have ${profile.response.believersCount} New Believers",
                                                        style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF737373)),
                                                      ),
                                                    ),
                                                    Text(
                                                      " | ",
                                                      style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF737373)),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        billboardWidgetsMain.believersTabBottomSheet(
                                                          context: context,
                                                          id: userIdMain,
                                                          isBelieversList: false,
                                                        );
                                                      },
                                                      child: Text(
                                                        "${profile.response.profileView} Profile Visits",
                                                        style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF737373)),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                ],
                              ),
                            )
                          : AppBar(
                              backgroundColor: const Color(0XFFF9FFF9),
                              automaticallyImplyLeading: false,
                              leadingWidth: 0,
                              elevation: 0,
                            ),
                      body: loader
                          ? Obx(
                              () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                  ? Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        billboardWidgetsMain.getSearchPage(
                                          context: context,
                                          modelSetState: setState,
                                          getBillBoardListData: getBillBoardListData,
                                        ),
                                        _bannerAdIsLoaded && _bannerAd != null
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                child: SizedBox(
                                                  width: _bannerAd!.size.width.toDouble(),
                                                  height: _bannerAd!.size.height.toDouble(),
                                                  child: AdWidget(ad: _bannerAd!),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height / 41.23,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 24.17),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(switchValue ? "Believed" : "Trending Now", style: Theme.of(context).textTheme.titleMedium),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Transform.scale(
                                                    scale: 0.7,
                                                    child: CupertinoSwitch(
                                                      value: switchValue,
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          getAllDataMain(
                                                              name: mainVariables.activeTypeMain.value == "believed"
                                                                  ? 'BillBoard_Home_Believed'
                                                                  : 'BillBoard_Home_General');
                                                          switchValue = value;
                                                          isOpen = switchValue
                                                              ? tutorialCoachMark2.isShowing
                                                                  ? false
                                                                  : true
                                                              : true;
                                                          listLoader = false;
                                                          skipBillBoardCount = 0;
                                                          skipSurveyCount = 0;
                                                          skipNewsCount = 0;
                                                          skipForumCount = 0;
                                                        });
                                                        mainVariables.activeTypeMain.value = value ? 'believed' : 'trending';
                                                        await getBillBoardListData();
                                                        setState(() {
                                                          listLoader = true;
                                                        });
                                                      },
                                                      activeColor: const Color(0xff0EA102),
                                                      trackColor: const Color.fromARGB(255, 212, 206, 206),
                                                      thumbColor: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 41.1,
                                                  ),
                                                  SizedBox(
                                                    height: height / 28.86,
                                                    child: Stack(
                                                      alignment: Alignment.topRight,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                bool response = await Navigator.push(context,
                                                                    MaterialPageRoute(builder: (BuildContext context) => const ContentFilterPage()));
                                                                if (response) {
                                                                  getBillBoardListData();
                                                                }
                                                              },
                                                              child: Image.asset(
                                                                'lib/Constants/Assets/BillBoard/businessProfile/sort.png',
                                                                height: height / 34.64,
                                                                width: width / 16.44,
                                                                color: Theme.of(context).colorScheme.onPrimary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        mainVariables.contentCategoriesMain.isEmpty &&
                                                                mainVariables.selectedProfileMain.value == "" &&
                                                                mainVariables.contentTypeMain.value == ""
                                                            ? const SizedBox()
                                                            : Container(
                                                                height: height / 173.2,
                                                                width: width / 82.2,
                                                                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 20.55,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (searchEnabled) {
                                                        if (mainVariables.billBoardListSearchControllerMain.value.text.isNotEmpty) {
                                                          getBillBoardListData();
                                                          mainVariables.billBoardListSearchControllerMain.value.clear();
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                        }
                                                        setState(() {
                                                          searchEnabled = false;
                                                        });
                                                        mainVariables.billBoardListSearchControllerMain.refresh();
                                                      } else {
                                                        setState(() {
                                                          searchEnabled = true;
                                                        });
                                                        mainVariables.billBoardListSearchControllerMain.refresh();
                                                      }
                                                    },
                                                    child: searchEnabled
                                                        ? Icon(
                                                            Icons.clear,
                                                            size: 20,
                                                            color: Theme.of(context).colorScheme.onPrimary,
                                                          )
                                                        : SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg",
                                                            height: 20,
                                                            width: 20,
                                                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        searchEnabled
                                            ? SizedBox(
                                                height: height / 86.6,
                                              )
                                            : const SizedBox(),
                                        searchEnabled
                                            ? billboardWidgetsMain.getBillBoardSearchField(
                                                context: context, modelSetState: setState, billBoardFunction: getBillBoardListData)
                                            : SizedBox(
                                                height: height / 41.3,
                                              ),
                                        searchEnabled
                                            ? SizedBox(
                                                height: height / 86.6,
                                              )
                                            : const SizedBox(),
                                        Expanded(
                                          child: listLoader
                                              ? mainVariables.valueMapListProfilePage.isEmpty
                                                  ? mainVariables.contentCategoriesMain.isEmpty &&
                                                          mainVariables.contentTypeMain.value == "" &&
                                                          mainVariables.selectedProfileMain.value == "user"
                                                      ? Center(
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(horizontal: width / 24.17),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Image.asset(
                                                                  "lib/Constants/Assets/BillBoard/emptyBelieved.png",
                                                                  height: height / 3.464,
                                                                  width: width / 1.49,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                                SizedBox(
                                                                  height: height / 57.73,
                                                                ),
                                                                SizedBox(
                                                                  key: keyButton,
                                                                  width: width / 1.2,
                                                                  child: RichText(
                                                                    textAlign: TextAlign.center,
                                                                    text: TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text: 'Check recommended traders on the platform and ',
                                                                            style: TextStyle(
                                                                                fontFamily: "Poppins",
                                                                                color: isDarkTheme.value ? Colors.white : const Color(0XFF282828),
                                                                                fontSize: text.scale(14),
                                                                                fontWeight: FontWeight.w600)),
                                                                        TextSpan(
                                                                            recognizer: TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (BuildContext context) =>
                                                                                            const PopularTradersPage()));
                                                                              },
                                                                            text: 'start engaging.',
                                                                            style: TextStyle(
                                                                                fontFamily: "Poppins",
                                                                                color: const Color(0XFF0EA102),
                                                                                fontSize: text.scale(14),
                                                                                fontWeight: FontWeight.w600)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          height: height / 1.2,
                                                          width: width,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: height / 3.2,
                                                                  width: width,
                                                                  child: Image.asset("lib/Constants/Assets/SMLogos/Illustrasi.png")),
                                                              SizedBox(height: height / 33.83),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                child: Text(
                                                                  "Unfortunately, the content for the specified filters is not available.",
                                                                  textAlign: TextAlign.center,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                    fontSize: text.scale(18),
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 20.3,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                child: const Text(
                                                                  "We're doing everything we can to give all of the content that our customers desire, and we'll keep adding to it as soon as we can.",
                                                                  textAlign: TextAlign.center,
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 54.13,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                child: RichText(
                                                                  textAlign: TextAlign.center,
                                                                  text: TextSpan(children: <TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            "You can try adjusting your filters or submit a new request for this item to be added on the ",
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(12),
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily: "Poppins")),
                                                                    TextSpan(
                                                                      recognizer: TapGestureRecognizer()
                                                                        ..onTap = () {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return const ContentFilterPage();
                                                                          }));
                                                                        },
                                                                      text: "Filter customisation.",
                                                                      style: TextStyle(
                                                                          fontSize: text.scale(12),
                                                                          color: const Color(0XFF0EA102),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                  : SmartRefresher(
                                                      controller: _controller,
                                                      scrollController: scrollController,
                                                      enablePullDown: true,
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
                                                        mainVariables.activeTypeMain.value = switchValue ? 'believed' : 'trending';
                                                        for (int i = 0; i < mainVariables.billBoardDataProfilePage!.value.response.length; i++) {
                                                          if (mainVariables.billBoardDataProfilePage!.value.response[i].type == "byte" ||
                                                              mainVariables.billBoardDataProfilePage!.value.response[i].type == "blog") {
                                                            skipBillBoardCount++;
                                                          } else if (mainVariables.billBoardDataProfilePage!.value.response[i].type == "survey") {
                                                            skipSurveyCount++;
                                                          } else if (mainVariables.billBoardDataProfilePage!.value.response[i].type == "news") {
                                                            skipNewsCount++;
                                                          } else if (mainVariables.billBoardDataProfilePage!.value.response[i].type == "forums") {
                                                            skipForumCount++;
                                                          } else {}
                                                        }
                                                        await billBoardApiMain.getBillBoardListApiFunc(
                                                          context: context,
                                                          category: mainVariables.contentCategoriesMain,
                                                          contentType: mainVariables.contentTypeMain.value,
                                                          profile: mainVariables.selectedProfileMain.value,
                                                          skipBillBoardCount: skipBillBoardCount,
                                                          skipForumCount: skipForumCount,
                                                          skipSurveyCount: skipSurveyCount,
                                                          skipNewsCount: skipNewsCount,
                                                          tickers: [],
                                                          userId: '',
                                                        );
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        mainVariables.isFirstTime.value = prefs.getBool("isFirstTime") ?? true;
                                                        if (mainVariables.billBoardDataProfilePage!.value.newCounts != 0) {
                                                          setState(() {
                                                            isLatestFeedAvailable = true;
                                                            mainVariables.latestFeedCounts.value =
                                                                mainVariables.billBoardDataProfilePage!.value.newCounts;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            isLatestFeedAvailable = false;
                                                            mainVariables.latestFeedCounts.value = 0;
                                                          });
                                                        }
                                                        if (mainVariables.billBoardDataProfilePage!.value.response.isNotEmpty) {
                                                          mainVariables.valueMapListProfilePage
                                                              .addAll(mainVariables.billBoardDataProfilePage!.value.response);
                                                          for (int i = 0; i < mainVariables.billBoardDataProfilePage!.value.response.length; i++) {
                                                            mainVariables.responseFocusList.add(FocusNode());
                                                            mainVariables.isUserTaggingList.add(false);
                                                            mainVariables.responseControllerList.add(TextEditingController());
                                                            mainVariables.pickedImageMain.add(null);
                                                            mainVariables.pickedVideoMain.add(null);
                                                            mainVariables.pickedFileMain.add(null);
                                                            mainVariables.docMain.add(null);
                                                            mainVariables.selectedUrlTypeMain.add("");
                                                            mainVariables.docFilesMain.add([]);
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
                                                          }
                                                          if (mainVariables.activeTypeMain.value == "believed" &&
                                                              mainVariables.believersCountMainMyself.value < 3 &&
                                                              mainVariables.isFirstTime.value == true) {
                                                            Future.delayed(Duration.zero, showTutorial);
                                                            setState(() {});
                                                          } else if (mainVariables.activeTypeMain.value == "believed" &&
                                                              mainVariables.believersCountMainMyself.value >= 3 &&
                                                              mainVariables.isFirstTime.value == true) {
                                                            isOpen = false;
                                                            Future.delayed(Duration.zero, showTutorial2);
                                                            setState(() {});
                                                          }
                                                          setState(() {});
                                                        } else {
                                                          if (mainVariables.activeTypeMain.value == "believed" &&
                                                              mainVariables.believersCountMainMyself.value < 3 &&
                                                              mainVariables.isFirstTime.value == true) {
                                                            Future.delayed(Duration.zero, showTutorial);
                                                            setState(() {});
                                                          } else if (mainVariables.activeTypeMain.value == "believed" &&
                                                              mainVariables.believersCountMainMyself.value >= 3 &&
                                                              mainVariables.isFirstTime.value == true) {
                                                            isOpen = false;
                                                            Future.delayed(Duration.zero, showTutorial2);
                                                            setState(() {});
                                                          }
                                                        }
                                                        if (mounted) {
                                                          setState(() {});
                                                        }
                                                        _controller.loadComplete();
                                                      },
                                                      header: const ClassicHeader(
                                                        refreshingText: "refreshing",
                                                        completeText: "Completed",
                                                        releaseText: "pull to refresh",
                                                      ),
                                                      onRefresh: () async {
                                                        mainVariables.activeTypeMain.value = switchValue ? 'believed' : 'trending';
                                                        mainVariables.initialPostDate.value = "";
                                                        await billBoardApiMain.getBillBoardListApiFunc(
                                                          context: context,
                                                          category: mainVariables.contentCategoriesMain,
                                                          contentType: mainVariables.contentTypeMain.value,
                                                          profile: mainVariables.selectedProfileMain.value,
                                                          skipBillBoardCount: 0,
                                                          skipForumCount: 0,
                                                          skipSurveyCount: 0,
                                                          skipNewsCount: 0,
                                                          tickers: [],
                                                          userId: '',
                                                        );
                                                        if (mainVariables.billBoardDataProfilePage!.value.response.isNotEmpty) {
                                                          mainVariables.valueMapListProfilePage =
                                                              (mainVariables.billBoardDataProfilePage!.value.response).obs;
                                                          mainVariables.initialPostDate.value = mainVariables.valueMapListProfilePage[0].dateTime;
                                                          if (mainVariables.billBoardDataProfilePage!.value.newCounts != 0) {
                                                            setState(() {
                                                              isLatestFeedAvailable = true;
                                                              mainVariables.latestFeedCounts.value =
                                                                  mainVariables.billBoardDataProfilePage!.value.newCounts;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isLatestFeedAvailable = false;
                                                              mainVariables.latestFeedCounts.value = 0;
                                                            });
                                                          }
                                                          mainVariables.responseFocusList = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => FocusNode());
                                                          mainVariables.isUserTaggingList.add(false);
                                                          mainVariables.responseControllerList = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length,
                                                              (index) => TextEditingController());
                                                          mainVariables.pickedImageMain = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                          mainVariables.pickedVideoMain = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                          mainVariables.pickedFileMain = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                          mainVariables.docMain = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                          mainVariables.selectedUrlTypeMain = RxList.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => "");
                                                          mainVariables.docFilesMain = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => []);
                                                          nativeAdIsLoadedList = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length, (index) => false);
                                                          nativeAdList = List.generate(
                                                              mainVariables.billBoardDataProfilePage!.value.response.length,
                                                              (index) => NativeAd(
                                                                    adUnitId: adVariables.nativeAdUnitId,
                                                                    request: const AdRequest(),
                                                                    nativeTemplateStyle: NativeTemplateStyle(
                                                                      templateType: TemplateType.medium,
                                                                      mainBackgroundColor: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                    listener: NativeAdListener(
                                                                      onAdLoaded: (Ad ad) {
                                                                        setState(() {
                                                                          nativeAdIsLoadedList[index] = true;
                                                                        });
                                                                      },
                                                                      onAdFailedToLoad: (Ad ad, LoadAdError error) {
                                                                        ad.dispose();
                                                                      },
                                                                      onAdOpened: (Ad ad) {},
                                                                      onAdClosed: (Ad ad) {},
                                                                    ),
                                                                  )..load());
                                                        }
                                                        if (mounted) {
                                                          setState(() {});
                                                        }
                                                        _controller.refreshCompleted();
                                                        setState(() {});
                                                      },
                                                      child: ListView.builder(
                                                          physics: const ScrollPhysics(),
                                                          padding: EdgeInsets.zero,
                                                          scrollDirection: Axis.vertical,
                                                          itemCount: mainVariables.valueMapListProfilePage.length,
                                                          itemBuilder: (context, index) {
                                                            if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                                                              return adWidget.selectedAdWidget(
                                                                  context: context,
                                                                  index: index,
                                                                  nativeAdList: nativeAdList,
                                                                  nativeAdIsLoadedList: nativeAdIsLoadedList,
                                                                  getBillBoardListData: getBillBoardListData,
                                                                  getData: getData,
                                                                  modelSetState: setState);
                                                            }
                                                            return normalWidget.selectedNormalWidget(
                                                                context: context,
                                                                index: index,
                                                                nativeAdList: nativeAdList,
                                                                nativeAdIsLoadedList: nativeAdIsLoadedList,
                                                                getBillBoardListData: getBillBoardListData,
                                                                getData: getData,
                                                                modelSetState: setState);
                                                          }),
                                                    )
                                              : Center(
                                                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                      height: height / 8.66, width: width / 4.11),
                                                ),
                                        ),
                                      ],
                                    ),
                            )
                          : Center(
                              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                            ),
                      floatingActionButtonLocation: ExpandableFab.location,
                      floatingActionButton: loader
                          ? Obx(
                              () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                  ? const SizedBox()
                                  : Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        ExpandableFab(
                                          key: _key,
                                          duration: const Duration(milliseconds: 500),
                                          distance: 60.0,
                                          type: ExpandableFabType.side,
                                          pos: ExpandableFabPos.right,
                                          childrenOffset: const Offset(0, 0),
                                          fanAngle: 40,
                                          overlayStyle: ExpandableFabOverlayStyle(
                                            blur: 0,
                                          ),
                                          children: [
                                            FloatingActionButton(
                                              backgroundColor: const Color(0XFF0DA102),
                                              child: SvgPicture.asset("lib/Constants/Assets/BillBoard/FilterPage/bottomSurvey.svg"),
                                              onPressed: () {
                                                setState(() {
                                                  if (_key.currentState!.isOpen) {
                                                    _key.currentState!.toggle();
                                                  }
                                                });
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (BuildContext context) => const SurveyPostPage(text: "Stocks")));
                                              },
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: const Color(0XFF0DA102),
                                              child: SvgPicture.asset("lib/Constants/Assets/BillBoard/FilterPage/bottomBlog.svg"),
                                              onPressed: () async {
                                                setState(() {
                                                  if (_key.currentState!.isOpen) {
                                                    _key.currentState!.toggle();
                                                  }
                                                });
                                                bool response = await Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const BlogPostPage()));
                                                if (response) {
                                                  getData();
                                                }
                                              },
                                            ),
                                            FloatingActionButton(
                                              key: keyButton3,
                                              backgroundColor: const Color(0XFF0DA102),
                                              child: SvgPicture.asset(
                                                "lib/Constants/Assets/BillBoard/FilterPage/bottomBytes.svg",
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  if (_key.currentState!.isOpen) {
                                                    _key.currentState!.toggle();
                                                  }
                                                });
                                                /*bool response = await Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const BytesPostPage()));
                                                if (response) {
                                                  getData();
                                                }*/
                                              },
                                            ),
                                          ],
                                        ),
                                        isOpen
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(right: width / 27.4, bottom: height / 54.125),
                                                child: FloatingActionButton(
                                                  onPressed: () {},
                                                  key: keyButton2,
                                                  child: const Icon(Icons.add),
                                                ),
                                              ),
                                        Positioned(
                                            right: 18,
                                            bottom: 75,
                                            child: AnimatedOpacity(
                                              duration: const Duration(seconds: 2),
                                              opacity: isLatestFeedAvailable ? 1.0 : 0.0,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await scrollController.animateTo(0,
                                                      duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                                                  mainVariables.initialPostDate.value = "";
                                                  mainVariables.activeTypeMain.value = switchValue ? 'believed' : 'trending';
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  await billBoardApiMain.getBillBoardListApiFunc(
                                                    context: context,
                                                    category: mainVariables.contentCategoriesMain,
                                                    contentType: mainVariables.contentTypeMain.value,
                                                    profile: mainVariables.selectedProfileMain.value,
                                                    skipBillBoardCount: 0,
                                                    skipForumCount: 0,
                                                    skipSurveyCount: 0,
                                                    skipNewsCount: 0,
                                                    tickers: [],
                                                    userId: '',
                                                  );
                                                  if (mainVariables.billBoardDataProfilePage!.value.response.isNotEmpty) {
                                                    mainVariables.valueMapListProfilePage =
                                                        (mainVariables.billBoardDataProfilePage!.value.response).obs;
                                                    mainVariables.initialPostDate.value = mainVariables.valueMapListProfilePage[0].dateTime;
                                                    if (mainVariables.billBoardDataProfilePage!.value.newCounts != 0) {
                                                      setState(() {
                                                        isLatestFeedAvailable = true;
                                                        mainVariables.latestFeedCounts.value =
                                                            mainVariables.billBoardDataProfilePage!.value.newCounts;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLatestFeedAvailable = false;
                                                        mainVariables.latestFeedCounts.value = 0;
                                                      });
                                                    }
                                                    mainVariables.responseFocusList = List.generate(
                                                        mainVariables.billBoardDataProfilePage!.value.response.length, (index) => FocusNode());
                                                    mainVariables.isUserTaggingList.add(false);
                                                    //mainVariables.globalKeyList=List.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => GlobalKey());
                                                    mainVariables.responseControllerList = List.generate(
                                                        mainVariables.billBoardDataProfilePage!.value.response.length,
                                                        (index) => TextEditingController());
                                                    mainVariables.pickedImageMain =
                                                        List.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                    mainVariables.pickedVideoMain =
                                                        List.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                    mainVariables.pickedFileMain =
                                                        List.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                    mainVariables.docMain =
                                                        List.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => null);
                                                    mainVariables.selectedUrlTypeMain =
                                                        RxList.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => "");
                                                    mainVariables.docFilesMain =
                                                        List.generate(mainVariables.billBoardDataProfilePage!.value.response.length, (index) => []);
                                                  }
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: height / 13.32,
                                                  width: width / 8.22,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26.withOpacity(0.6),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Icon(
                                                        Icons.arrow_drop_up,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                                        child: const Divider(
                                                          color: Colors.white,
                                                          thickness: 1,
                                                          height: 2,
                                                        ),
                                                      ),
                                                      Obx(() => Text(mainVariables.latestFeedCounts.value.toString(),
                                                          style: const TextStyle(color: Colors.white))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                            )
                          : const SizedBox(),
                    ),
                  )
                : Center(
                    child: Lottie.asset(
                      'lib/Constants/Assets/SMLogos/loading.json',
                      height: height / 8.66,
                      width: width / 4.11,
                    ),
                  ),
          )),
    );
  }
}
