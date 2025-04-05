import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:river_player/river_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcard/tcard.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/ForSurvey/translation_survey_bloc.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';

import 'analytics_page.dart';

class QuestionnairePage extends StatefulWidget {
  final String surveyId;
  final int defaultIndex;
  final String? fromWhere;

  const QuestionnairePage({Key? key, required this.surveyId, required this.defaultIndex, this.fromWhere}) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TCardController _controller = TCardController();
  int pageIndex = 0;
  int selectedIndex = 0;
  int _index = 0;
  List<bool> tick1 = List.generate(10, (index) => false);
  List<bool> tick2 = List.generate(10, (index) => false);
  List<bool> tick3 = List.generate(10, (index) => false);
  List<bool> tick4 = List.generate(10, (index) => false);
  List<bool> tick5 = List.generate(10, (index) => false);
  String mainUserToken = "";
  int totalQuestions = 0;
  List<String> answerTypeList = [];
  List<String> optionalTypeList = [];
  List<String> questionList = [];
  List<String> answerList1 = [];
  List<String> answerList2 = [];
  List<String> answerList3 = [];
  List<String> answerList4 = [];
  List<String> answerList5 = [];
  List<String> urlTypeList = [];
  List<String> urlList = [];
  List<int> answerCount1 = [];
  List<int> answerCount2 = [];
  List<int> answerCount3 = [];
  List<int> answerCount4 = [];
  List<int> answerCount5 = [];
  List<int> answerTotalCount = [];
  List<bool> answer1List = [];
  List<bool> answer2List = [];
  List<bool> answer3List = [];
  List<bool> answer4List = [];
  List<bool> answer5List = [];
  List<BetterPlayerController> betterPlayerList = [];
  List<String> networkUrls = [];
  List<bool> playerConditions = [];
  List<String> playerVideoId = [];
  bool loading = false;
  Map<String, dynamic> data = {};
  String surveyId = "";
  String surveyUser = "";
  List<String> questionIdList = [];
  bool previousDisable = false;
  bool nextDisable = false;
  BannerAd? _bannerAd;
  int _numInterstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;
  int maxFailedLoadAttempts = 3;
  bool _bannerAdIsLoaded = false;
  bool adShown = true;
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    getAllDataMain(name: 'Questionnaire_Page');
    getAllData();
    super.initState();
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

  getAllData() async {
    context.read<TranslationSurveyBloc>().add(const LoadingTranslationSurveyEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + surveyDetails);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'survey_id': widget.surveyId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      watchVariables.postCountTotalMain.value = responseData["post_view_counts"];
      if (watchVariables.postCountTotalMain.value % 5 == 0) {
        debugPrint(" ad Started");
        functionsMain.createInterstitialAd(modelSetState: setState);
      }
      if (responseData["response"].length == 0) {
      } else {
        answerTypeList.clear();
        betterPlayerList.clear();
        optionalTypeList.clear();
        questionIdList.clear();
        questionList.clear();
        answerCount1.clear();
        answerCount2.clear();
        answerCount3.clear();
        answerCount4.clear();
        answerCount5.clear();
        answerTotalCount.clear();
        answer1List.clear();
        answer2List.clear();
        answer3List.clear();
        answer4List.clear();
        answer5List.clear();
        answerList1.clear();
        answerList2.clear();
        answerList3.clear();
        answerList4.clear();
        answerList5.clear();
        urlTypeList.clear();
        urlList.clear();
        totalQuestions = responseData["response"]["questions"].length;
        surveyId = responseData["response"]["_id"];
        surveyUser = responseData["response"]["user_id"];
        for (int i = 0; i < responseData["response"]["questions"].length; i++) {
          answerTypeList.add(responseData["response"]["questions"][i]["answer_type"]);
          optionalTypeList.add(responseData["response"]["questions"][i]["optional_type"]);
          questionIdList.add(responseData["response"]["questions"][i]["_id"]);
          questionList.add(responseData["response"]["questions"][i]["title"]);
          answerCount1.add(responseData["response"]["questions"][i]["answer1_count"]);
          answerCount2.add(responseData["response"]["questions"][i]["answer2_count"]);
          answerCount3.add(responseData["response"]["questions"][i]["answer3_count"]);
          answerCount4.add(responseData["response"]["questions"][i]["answer4_count"]);
          answerCount5.add(responseData["response"]["questions"][i]["answer5_count"]);
          answerTotalCount.add((responseData["response"]["questions"][i]["answer1_count"]) +
              (responseData["response"]["questions"][i]["answer2_count"]) +
              (responseData["response"]["questions"][i]["answer3_count"]) +
              (responseData["response"]["questions"][i]["answer4_count"]) +
              (responseData["response"]["questions"][i]["answer5_count"]));
          if (responseData["response"]["questions"][i].containsKey("url_type")) {
            urlTypeList.add(responseData["response"]["questions"][i]["url_type"]);
            urlList.add(responseData["response"]["questions"][i]["url"]);
            if (responseData["response"]["questions"][i]["url_type"] == 'video') {
              networkUrls.add(responseData["response"]["questions"][i]["url"]);
              playerConditions.add(false);
              playerVideoId.add(responseData["response"]["questions"][i]["_id"]);
            } else {
              networkUrls.add("a");
              playerConditions.add(false);
              playerVideoId.add(responseData["response"]["questions"][i]["_id"]);
            }
          } else {
            urlTypeList.add("");
            urlList.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer1')) {
            answer1List.add(true);
            answerList1.add(responseData["response"]["questions"][i]["answer1"]);
          } else {
            answer1List.add(false);
            answerList1.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer2')) {
            answer2List.add(true);
            answerList2.add(responseData["response"]["questions"][i]["answer2"]);
          } else {
            answer2List.add(false);
            answerList2.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer3')) {
            answer3List.add(true);
            answerList3.add(responseData["response"]["questions"][i]["answer3"]);
          } else {
            answer3List.add(false);
            answerList3.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer4')) {
            answer4List.add(true);
            answerList4.add(responseData["response"]["questions"][i]["answer4"]);
          } else {
            answer4List.add(false);
            answerList4.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer5')) {
            answer5List.add(true);
            answerList5.add(responseData["response"]["questions"][i]["answer5"]);
          } else {
            answer5List.add(false);
            answerList5.add("");
          }
        }
        var url = baseurl + versionSurvey + surveyViewCount;
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
          'survey_id': widget.surveyId,
          'question_id': questionIdList[0],
          'question_index': 1,
        });
        for (var element in networkUrls) {
          betterPlayerList.add(
            BetterPlayer.network(
              element,
              betterPlayerConfiguration: const BetterPlayerConfiguration(
                aspectRatio: 16 / 9,
                fit: BoxFit.contain,
                autoDispose: false,
                controlsConfiguration: BetterPlayerControlsConfiguration(
                  enablePip: false,
                  enableOverflowMenu: false,
                  enablePlayPause: false,
                  enableAudioTracks: false,
                  enableMute: false,
                  enableSkips: false,
                  enableProgressText: false,
                ),
              ),
            ).controller,
          );
        }
      }
      setState(() {
        loading = true;
      });
    }
  }

  ansFunc({required Map<String, dynamic> newData, required int index}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + answer);
    await http.post(url, headers: {'Authorization': mainUserToken}, body: data);
    if (index == questionIdList.length) {
      if (!mounted) {
        return;
      }
      if (widget.fromWhere == "finalCharts") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
          return AnalyticsPage(
            surveyTitle: '',
            activity: false,
            navBool: false,
            fromWhere: "finalCharts",
            surveyId: widget.surveyId,
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return AnalyticsPage(
            surveyTitle: '',
            activity: false,
            surveyId: widget.surveyId,
            fromWhere: "answers",
          );
        }));
      }
    }
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
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
        createInterstitialAd();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWhere == "finalCharts") {
          //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
        }
        Navigator.pop(context, true);
        return false;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            // color: const Color(0XFFFFFFFF),
            color: Theme.of(context).colorScheme.background,
            child: SafeArea(
                child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              /*const Color(0xffFDFDFD),*/
              appBar: AppBar(
                elevation: 0,
                // backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                leading: IconButton(
                    onPressed: () {
                      if (widget.fromWhere == "finalCharts") {
                        //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                      }
                      Navigator.pop(context, true);
                    },
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Questionnaire", style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700, fontFamily: "Poppins")),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                          _controller.reset();
                        },
                        child: SvgPicture.asset(
                          "lib/Constants/Assets/SMLogos/resetButton.svg",
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                        )),
                  ],
                ),
              ),
              body: loading
                  ? SingleChildScrollView(
                      child: Container(
                        // color: const Color(0XFFFDFDFD),
                        color: Theme.of(context).colorScheme.background,
                        //margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height / 40.6),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Question  ${selectedIndex + 1}/$totalQuestions",
                                    style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                  ),
                                  questionList.length == 1
                                      ? const SizedBox()
                                      : optionalTypeList[selectedIndex] == 'mandatory'
                                          ? const SizedBox()
                                          : (selectedIndex + 1) == questionList.length
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      data = {
                                                        "survey_id": surveyId,
                                                        "survey_user": surveyUser,
                                                        "question_id": questionIdList[selectedIndex],
                                                        "answer1": tick1[_index].toString(),
                                                        "answer2": tick2[_index].toString(),
                                                        "answer3": tick3[_index].toString(),
                                                        "answer4": tick4[_index].toString(),
                                                        "answer5": tick5[_index].toString(),
                                                        "question_number": (selectedIndex + 1).toString(),
                                                        "final_question": "true"
                                                      };
                                                      selectedIndex < questionList.length ? selectedIndex++ : debugPrint("nothing");
                                                      _controller.forward(direction: SwipDirection.Left);
                                                    });
                                                    ansFunc(newData: data, index: selectedIndex);
                                                    // var url = Uri.parse(baseurl + versionSurvey + surveyViewCount);
                                                    var url = baseurl + versionSurvey + surveyViewCount;
                                                    await dioMain.post(url,
                                                        options: Options(
                                                          headers: {'Authorization': mainUserToken},
                                                        ),
                                                        data: {
                                                          'survey_id': widget.surveyId,
                                                          'question_id': questionIdList[selectedIndex],
                                                          'question_index': selectedIndex + 1,
                                                        });
                                                  },
                                                  child: Text(
                                                    'skip>>',
                                                    style: TextStyle(
                                                        color: const Color(0XFF0EA102),
                                                        fontSize: text.scale(12),
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "poppins"),
                                                  ),
                                                )
                                              : tick1[selectedIndex] ||
                                                      tick2[selectedIndex] ||
                                                      tick3[selectedIndex] ||
                                                      tick4[selectedIndex] ||
                                                      tick5[selectedIndex]
                                                  ? GestureDetector(
                                                      onTap: () {},
                                                      child: Text(
                                                        'skip>>',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: text.scale(12),
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: "poppins"),
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          data = {
                                                            "survey_id": surveyId,
                                                            "survey_user": surveyUser,
                                                            "question_id": questionIdList[selectedIndex],
                                                            "answer1": tick1[_index].toString(),
                                                            "answer2": tick2[_index].toString(),
                                                            "answer3": tick3[_index].toString(),
                                                            "answer4": tick4[_index].toString(),
                                                            "answer5": tick5[_index].toString(),
                                                            "question_number": (selectedIndex + 1).toString(),
                                                            "final_question": "false"
                                                          };
                                                          selectedIndex < questionList.length ? selectedIndex++ : debugPrint("nothing");
                                                          _controller.forward(direction: SwipDirection.Left);
                                                        });
                                                        ansFunc(newData: data, index: selectedIndex);
                                                        //var url = Uri.parse(baseurl + versionSurvey + surveyViewCount);
                                                        var url = baseurl + versionSurvey + surveyViewCount;
                                                        await dioMain.post(url,
                                                            options: Options(
                                                              headers: {'Authorization': mainUserToken},
                                                            ),
                                                            data: {
                                                              'survey_id': widget.surveyId,
                                                              'question_id': questionIdList[selectedIndex],
                                                              'question_index': selectedIndex + 1,
                                                            });
                                                      },
                                                      child: Text(
                                                        'skip>>',
                                                        style: TextStyle(
                                                            color: const Color(0XFF0EA102),
                                                            fontSize: text.scale(12),
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: "poppins"),
                                                      ),
                                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: height / 101.5),
                            Container(
                              height: height / 162.4,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: LinearProgressIndicator(
                                  backgroundColor: const Color(0xffC4C4C4),
                                  value: (selectedIndex + 1) / totalQuestions,
                                  color: const Color(0XFF0EA102).withOpacity(0.6),
                                  semanticsLabel: 'Linear progress indicator'),
                            ),
                            SizedBox(height: height / 54.13),
                            TCard(
                              size: Size(width, height / 1.5),
                              cards: List.generate(
                                questionList.length,
                                (int index) {
                                  return StatefulBuilder(
                                    builder: (context, setInnerState) => Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)]),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height / 47.76,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 23.4375),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'select an answer',
                                                          style: TextStyle(
                                                              color: const Color(0XFF0EA102),
                                                              fontSize: text.scale(12),
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: "poppins"),
                                                        ),
                                                        Text(
                                                          answerTypeList[index] == 'single' ? " (Single)" : " (Multiple)",
                                                          style:
                                                              TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                                        ),
                                                      ],
                                                    ),
                                                    widgetsMain.translationWidgetSurvey(
                                                        translation: false,
                                                        id: widget.surveyId,
                                                        type: 'survey',
                                                        index: 0,
                                                        initFunction: getAllData,
                                                        context: context,
                                                        modelSetState: setInnerState,
                                                        notUse: false,
                                                        questionList: questionList,
                                                        answer1List: answerList1,
                                                        answer2List: answerList2,
                                                        answer3List: answerList3,
                                                        answer4List: answerList4,
                                                        answer5List: answerList5),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: height / 81.2),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: width / 23.4375),
                                                child: Text(
                                                  questionList[index],
                                                  style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, fontFamily: "poppins"),
                                                ),
                                              ),
                                              SizedBox(height: height / 81.2),
                                              Column(
                                                children: [
                                                  answer1List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer1List[index]
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setInnerState(() {
                                                              _index = index;
                                                              if (answerTypeList[index] == 'single') {
                                                                tick1[index] = true;
                                                                tick2[index] = false;
                                                                tick3[index] = false;
                                                                tick4[index] = false;
                                                                tick5[index] = false;
                                                              } else {
                                                                tick1[index] = !tick1[index];
                                                              }
                                                            });
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                              horizontal: width / 28.84,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Theme.of(context).colorScheme.background,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                ]),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                                                                  width: width / 1.5,
                                                                  child: Text(
                                                                    answerList1[index],
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                                tick1[index]
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.check,
                                                                            size: 20, color: Theme.of(context).colorScheme.onPrimary),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  answer1List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer2List[index]
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setInnerState(() {
                                                              _index = index;
                                                              if (answerTypeList[index] == 'single') {
                                                                tick1[index] = false;
                                                                tick2[index] = true;
                                                                tick3[index] = false;
                                                                tick4[index] = false;
                                                                tick5[index] = false;
                                                              } else {
                                                                tick2[index] = !tick2[index];
                                                              }
                                                            });
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                              horizontal: width / 28.84,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Theme.of(context).colorScheme.background,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                ]),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                                                                  width: width / 1.5,
                                                                  child: Text(
                                                                    answerList2[index],
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                                tick2[index]
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.check,
                                                                            size: 20, color: Theme.of(context).colorScheme.onPrimary),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  answer2List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer3List[index]
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setInnerState(() {
                                                              _index = index;
                                                              if (answerTypeList[index] == 'single') {
                                                                tick1[index] = false;
                                                                tick2[index] = false;
                                                                tick3[index] = true;
                                                                tick4[index] = false;
                                                                tick5[index] = false;
                                                              } else {
                                                                tick3[index] = !tick3[index];
                                                              }
                                                            });
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                              horizontal: width / 28.84,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Theme.of(context).colorScheme.background,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                ]),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                                                                  width: width / 1.5,
                                                                  child: Text(
                                                                    answerList3[index],
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                                tick3[index]
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.check,
                                                                            size: 20, color: Theme.of(context).colorScheme.onPrimary),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  answer3List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer4List[index]
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setInnerState(() {
                                                              _index = index;
                                                              if (answerTypeList[index] == 'single') {
                                                                tick1[index] = false;
                                                                tick2[index] = false;
                                                                tick3[index] = false;
                                                                tick4[index] = true;
                                                                tick5[index] = false;
                                                              } else {
                                                                tick4[index] = !tick4[index];
                                                              }
                                                            });
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                              horizontal: width / 28.84,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Theme.of(context).colorScheme.background,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                ]),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                                                                  width: width / 1.5,
                                                                  child: Text(
                                                                    answerList4[index],
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                                tick4[index]
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.check,
                                                                            size: 20, color: Theme.of(context).colorScheme.onPrimary),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  answer4List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer5List[index]
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setInnerState(() {
                                                              _index = index;
                                                              if (answerTypeList[index] == 'single') {
                                                                tick1[index] = false;
                                                                tick2[index] = false;
                                                                tick3[index] = false;
                                                                tick4[index] = false;
                                                                tick5[index] = true;
                                                              } else {
                                                                tick5[index] = !tick5[index];
                                                              }
                                                            });
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                              horizontal: width / 28.84,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Theme.of(context).colorScheme.background,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                                ]),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                                                                  width: width / 1.5,
                                                                  child: Text(
                                                                    answerList5[index],
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                                tick5[index]
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.check,
                                                                            size: 20, color: Theme.of(context).colorScheme.onPrimary),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  answer5List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              urlTypeList[selectedIndex] == ""
                                                  ? const SizedBox()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        urlTypeList[selectedIndex] == "image"
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                                return FullScreenImage(
                                                                  imageUrl: urlList[index],
                                                                  tag: "generate_a_unique_tag",
                                                                );
                                                              }))
                                                            : urlTypeList[selectedIndex] == "video"
                                                                ? showAlertDialog(context: context, index: index)
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute<dynamic>(
                                                                      builder: (_) => PDFViewerFromUrl(
                                                                        url: urlList[index],
                                                                      ),
                                                                    ),
                                                                  );
                                                      },
                                                      child: Container(
                                                        height: 18,
                                                        margin: const EdgeInsets.only(left: 15, bottom: 15),
                                                        child: Row(
                                                          children: [
                                                            urlTypeList[selectedIndex] == "image"
                                                                ? SvgPicture.asset("lib/Constants/Assets/SMLogos/image.svg")
                                                                : urlTypeList[selectedIndex] == "video"
                                                                    ? SvgPicture.asset("lib/Constants/Assets/SMLogos/video.svg")
                                                                    : SvgPicture.asset("lib/Constants/Assets/SMLogos/document.svg"),
                                                            const SizedBox(width: 10),
                                                            Text(
                                                              "view attachment",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: isDarkTheme.value
                                                                      ? Theme.of(context).colorScheme.onPrimary
                                                                      : const Color(0XFF7A7A7A),
                                                                  fontWeight: FontWeight.w500,
                                                                  decoration: TextDecoration.underline),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              controller: _controller,
                              delaySlideFor: 1000,
                              slideSpeed: 1000,
                            ),
                            SizedBox(height: height / 50.75),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  selectedIndex == 0
                                      ? const SizedBox()
                                      : InkWell(
                                          onTap: previousDisable
                                              ? () {}
                                              : () {
                                                  setState(() {
                                                    previousDisable = true;
                                                    nextDisable = true;
                                                    selectedIndex > 0 ? selectedIndex-- : debugPrint("nothing");
                                                    _controller.back();
                                                  });
                                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                                    setState(() {
                                                      previousDisable = false;
                                                      nextDisable = false;
                                                    });
                                                  });
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              "Previous",
                                              style: TextStyle(
                                                  fontSize: text.scale(14),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                  color: previousDisable
                                                      ? Colors.transparent
                                                      : isDarkTheme.value
                                                          ? Theme.of(context).colorScheme.onPrimary
                                                          : const Color(0XFF4A4A4A)),
                                            ),
                                          ),
                                        ),
                                  questionList.length == 1
                                      ? tick1[selectedIndex] ||
                                              tick2[selectedIndex] ||
                                              tick3[selectedIndex] ||
                                              tick4[selectedIndex] ||
                                              tick5[selectedIndex]
                                          ? InkWell(
                                              onTap: () async {
                                                logEventFunc(name: 'Responses', type: "Survey");
                                                data = {
                                                  "survey_id": surveyId,
                                                  "survey_user": surveyUser,
                                                  "question_id": questionIdList[selectedIndex],
                                                  "answer1": tick1[_index].toString(),
                                                  "answer2": tick2[_index].toString(),
                                                  "answer3": tick3[_index].toString(),
                                                  "answer4": tick4[_index].toString(),
                                                  "answer5": tick5[_index].toString(),
                                                  "question_number": (selectedIndex + 1).toString(),
                                                  "final_question": "true"
                                                };
                                                await ansFunc(newData: data, index: selectedIndex + 1);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                      color: const Color(0XFF4A4A4A)),
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Flushbar(
                                                  message: "Please select answer",
                                                  duration: const Duration(seconds: 2),
                                                ).show(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            )
                                      : (selectedIndex + 1) == questionList.length
                                          ? tick1[selectedIndex] ||
                                                  tick2[selectedIndex] ||
                                                  tick3[selectedIndex] ||
                                                  tick4[selectedIndex] ||
                                                  tick5[selectedIndex]
                                              ? InkWell(
                                                  onTap: () async {
                                                    logEventFunc(name: 'Responses', type: "Survey");
                                                    data = {
                                                      "survey_id": surveyId,
                                                      "survey_user": surveyUser,
                                                      "question_id": questionIdList[selectedIndex],
                                                      "answer1": tick1[_index].toString(),
                                                      "answer2": tick2[_index].toString(),
                                                      "answer3": tick3[_index].toString(),
                                                      "answer4": tick4[_index].toString(),
                                                      "answer5": tick5[_index].toString(),
                                                      "question_number": (selectedIndex + 1).toString(),
                                                      "final_question": "true"
                                                    };
                                                    await ansFunc(newData: data, index: selectedIndex + 1);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontSize: text.scale(14),
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "Poppins",
                                                          color:
                                                              isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF4A4A4A)),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    optionalTypeList[selectedIndex] == 'mandatory'
                                                        ? Flushbar(
                                                            message: "This question mentioned as Mandatory,Please select answer",
                                                            duration: const Duration(seconds: 2),
                                                          )
                                                        : Flushbar(
                                                            message:
                                                                "You are proceeding without an answer, if you want to skip this question, use skip button(top corner)",
                                                            duration: const Duration(seconds: 2),
                                                          ).show(context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          fontSize: text.scale(14),
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "Poppins",
                                                          color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : Colors.grey),
                                                    ),
                                                  ),
                                                )
                                          : tick1[selectedIndex] ||
                                                  tick2[selectedIndex] ||
                                                  tick3[selectedIndex] ||
                                                  tick4[selectedIndex] ||
                                                  tick5[selectedIndex]
                                              ? InkWell(
                                                  onTap: nextDisable
                                                      ? () {}
                                                      : () async {
                                                          _controller.forward(direction: SwipDirection.Left);
                                                          setState(() {
                                                            nextDisable = true;
                                                            previousDisable = true;
                                                            data = {
                                                              "survey_id": surveyId,
                                                              "survey_user": surveyUser,
                                                              "question_id": questionIdList[selectedIndex],
                                                              "answer1": tick1[_index].toString(),
                                                              "answer2": tick2[_index].toString(),
                                                              "answer3": tick3[_index].toString(),
                                                              "answer4": tick4[_index].toString(),
                                                              "answer5": tick5[_index].toString(),
                                                              "question_number": (selectedIndex + 1).toString(),
                                                              "final_question": "false"
                                                            };
                                                            selectedIndex < questionList.length ? selectedIndex++ : debugPrint("nothing");
                                                          });
                                                          ansFunc(newData: data, index: selectedIndex);
                                                          var url = baseurl + versionSurvey + surveyViewCount;
                                                          await dioMain.post(url,
                                                              options: Options(
                                                                headers: {'Authorization': mainUserToken},
                                                              ),
                                                              data: {
                                                                'survey_id': widget.surveyId,
                                                                'question_id': questionIdList[selectedIndex],
                                                                'question_index': selectedIndex + 1,
                                                              });
                                                          Future.delayed(const Duration(milliseconds: 1000), () {
                                                            setState(() {
                                                              nextDisable = false;
                                                              previousDisable = false;
                                                            });
                                                          });
                                                        },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Text(
                                                      "Next",
                                                      style: TextStyle(
                                                          fontSize: text.scale(14),
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "Poppins",
                                                          color: nextDisable
                                                              ? Colors.transparent
                                                              : isDarkTheme.value
                                                                  ? Theme.of(context).colorScheme.onPrimary
                                                                  : const Color(0XFF4A4A4A)),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    optionalTypeList[selectedIndex] == 'mandatory'
                                                        ? Flushbar(
                                                            message: "This question mentioned as Mandatory,Please select answer",
                                                            duration: const Duration(seconds: 2),
                                                          )
                                                        : Flushbar(
                                                            message:
                                                                "You are proceeding without an answer, if you want to skip this question, use skip button(top corner)",
                                                            duration: const Duration(seconds: 2),
                                                          ).show(context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Text(
                                                      "Next",
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
            )),
          ),
          /*AdmobBanner(
            adUnitId: AdHelper.bannerAdUnitId,
            adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: _width.toInt()),
            listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
              AdHelper().handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController controller) {},
          ),*/
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
        ],
      ),
    );
  }

  showAlertDialog({required BuildContext context, required int index}) {
    double width = MediaQuery.of(context).size.width;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          reverse: true,
          child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              content: SizedBox(
                width: width / 1.7,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    BetterPlayer(
                      controller: betterPlayerList[index],
                    ),
                    GestureDetector(
                        onTap: () {
                          for (int i = 0; i < networkUrls.length; i++) {
                            if (index == i) {
                              if (betterPlayerList[i].isPlaying() == true) {
                                betterPlayerList[i].pause();
                              } else if (betterPlayerList[i].videoPlayerController?.value.duration ==
                                  betterPlayerList[i].videoPlayerController?.value.position) {
                                betterPlayerList[i].seekTo(const Duration(seconds: 0));
                              } else {
                                betterPlayerList[index].play();
                              }
                            } else {
                              // betterPlayerList[i].videoPlayerController?.setMixWithOthers(false);
                              betterPlayerList[i].pause();
                              betterPlayerList[i].seekTo(const Duration(seconds: 0));
                            }
                          }
                        },
                        child: const Center(
                            child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.transparent,
                          size: 30,
                        )))
                  ],
                ),
              )),
        );
      },
    );
  }
}
