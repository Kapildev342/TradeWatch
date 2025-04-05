import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Edited_Packages/TutorialCoachMark/tutorial_coach_mark.dart';
import 'package:tradewatchfinal/Edited_Packages/expandable_button/src/expandable_fab.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';

import 'UserProfile/user_bill_board_profile_page.dart';

class PopularTradersPage extends StatefulWidget {
  final String fromWhere;

  const PopularTradersPage({Key? key, this.fromWhere = ""}) : super(key: key);

  @override
  State<PopularTradersPage> createState() => _PopularTradersPageState();
}

class _PopularTradersPageState extends State<PopularTradersPage> {
  bool loader = false;
  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    createTutorial();
    getAllDataMain(name: 'Popular_Traders_Page');
    getData();
    super.initState();
  }

  getData() async {
    await billBoardApiMain.getPopularTraderData(searchValue: '', context: context);
    billBoardFunctionsMain.getNotifyCountAndImage();
    if (mainVariables.believersCountMainMyself.value < 3 && mainVariables.isJourney.value) {
      mainVariables.isFirstTime.value ? Future.delayed(Duration.zero, showTutorial) : debugPrint("nothing");
    }
    setState(() {
      loader = true;
    });
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      hideSkip: true,
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      onFinish: () {},
      onClickTarget: (target) {
        mainVariables.isJourney.value = true;
        tutorialCoachMark.finish();
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
        identify: "selection",
        keyTarget: keyButton,
        targetPosition: TargetPosition(const Size(0, 0), const Offset(0, 0)),
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(top: 20, left: 0),
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height / 7.216,
                    margin: EdgeInsets.symmetric(horizontal: width / 20.55),
                    padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
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
                          "Believe in Traders",
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
                          "To personalize your feed, select at least three traders you believe in. Their insights will shape your 'Believed' section.",
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
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    "2/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
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
        radius: 1,
      ),
    );
    return targets;
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  void dispose() {
    _key.currentState == null ? debugPrint("do nothing") : _key.currentState!.deactivate();
    mainVariables.popularSearchControllerMain.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (mainVariables.believersCountMainMyself.value < 3 && mainVariables.isJourney.value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Please believe ${3 - mainVariables.believersCountMainMyself.value} more users to do this action",
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            margin: EdgeInsets.only(bottom: height - 300),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            duration: const Duration(seconds: 1),
          ));
        } else if (mainVariables.isJourney.value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "please use forward button to move forward",
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            margin: EdgeInsets.only(bottom: height - 300),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            duration: const Duration(seconds: 1),
          ));
        } else {
          if (widget.fromWhere == "billBoardHome") {
            Navigator.pop(context);
          } else {
            if (tutorialCoachMark.isShowing) {
              tutorialCoachMark.finish();
            }
            mainVariables.activeTypeMain.value = "trending";
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainBottomNavigationPage(
                        caseNo1: 2, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
          }
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: loader
              ? Container(
                  height: height,
                  width: width,
                  color: Theme.of(context).colorScheme.background, //Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height / 23.2,
                        margin: EdgeInsets.symmetric(vertical: height / 54.125, horizontal: width / 25.68),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (mainVariables.believersCountMainMyself.value < 3 && mainVariables.isJourney.value) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content:
                                              Text("Please believe ${3 - mainVariables.believersCountMainMyself.value} more users to do this action"),
                                          margin: EdgeInsets.only(bottom: height - 200),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      } else if (mainVariables.isJourney.value) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: const Text("please use forward button to move forward"),
                                          margin: EdgeInsets.only(bottom: height - 200),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      } else {
                                        if (widget.fromWhere == "billBoardHome") {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                        } else {
                                          if (tutorialCoachMark.isShowing) {
                                            tutorialCoachMark.finish();
                                          }
                                          mainVariables.activeTypeMain.value = "trending";
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => const MainBottomNavigationPage(
                                                      caseNo1: 2,
                                                      text: "stocks",
                                                      excIndex: 1,
                                                      newIndex: 0,
                                                      countryIndex: 0,
                                                      isHomeFirstTym: false,
                                                      tType: true)));
                                        }
                                      }
                                    },
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      color: Theme.of(context).colorScheme.onPrimary, //Color(0XFF777777),
                                      size: 25,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: width / 51.375),
                                  child: Text(
                                    "Popular Traders",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall, //TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(18), color: const Color(0XFF212121)),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                billboardWidgetsMain.getMessageBadge(context: context),
                                SizedBox(
                                  width: width / 23.43,
                                ),
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
                                  width: width / 51.375,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 17),
                          decoration: BoxDecoration(
                              color: isDarkTheme.value ? const Color(0XFF1E1E1F) : const Color(0XFFF9FFF9), //const Color(0XFFF9FFF9),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                              boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 54.125,
                              ),
                              SizedBox(
                                height: height / 24,
                                child: billboardWidgetsMain.getPopularSearchField(
                                  context: context,
                                  modelSetState: setState,
                                  forWhat: 'popular',
                                ),
                              ),
                              mainVariables.isFirstTime.value
                                  ? SizedBox(
                                      height: height / 108.25,
                                    )
                                  : const SizedBox(),
                              mainVariables.isFirstTime.value
                                  ? Text(
                                      "Please, Find popular trader home you can believe ${mainVariables.believersCountMainMyself}/3.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: text.scale(10),
                                          color: isDarkTheme.value ? const Color(0XFF626161) : const Color(0XFF2F2F2F)),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: height / 36,
                              ),
                              Expanded(
                                child: Obx(() => mainVariables.popularSearchDataMain!.value.response.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No matched profiles found",
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.onPrimary /*const Color(0XFF0EA102)*/,
                                              fontWeight: FontWeight.w400,
                                              fontSize: text.scale(12)),
                                        ),
                                      )
                                    : ListView.builder(
                                        key: keyButton,
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: mainVariables.popularSearchDataMain!.value.response.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                onTap: mainVariables.isFirstTime.value
                                                    ? () {}
                                                    : () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return UserBillBoardProfilePage(
                                                              userId: mainVariables.popularSearchDataMain!.value.response[index]
                                                                  .id) /*UserProfilePage(id:mainVariables.popularSearchDataMain!.value.response[index].id,type:'forums',index:0)*/;
                                                        }));
                                                      },
                                                contentPadding: EdgeInsets.zero,
                                                leading: billboardWidgetsMain.getProfile(
                                                    context: context,
                                                    heightValue: height / 18.42,
                                                    widthValue: width / 8.74,
                                                    myself: false,
                                                    avatar: mainVariables.popularSearchDataMain!.value.response[index].avatar,
                                                    userId: mainVariables.popularSearchDataMain!.value.response[index].id,
                                                    isProfile: mainVariables.popularSearchDataMain!.value.response[index].profileType),
                                                trailing: SizedBox(
                                                    width: width / 4,
                                                    child: GestureDetector(
                                                        onTap: () async {
                                                          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
                                                            id: mainVariables.popularSearchDataMain!.value.response[index].id,
                                                            name: mainVariables.popularSearchDataMain!.value.response[index].username,
                                                          );
                                                          if (responseData['message'] == "Believed successfully") {
                                                            logEventFunc(
                                                                name:
                                                                    "Believed_User_${mainVariables.popularSearchDataMain!.value.response[index].id}",
                                                                type: "BillBoard");
                                                            mainVariables.believersCountMainMyself.value++;
                                                            mainVariables.popularSearchDataMain!.value.response[index].believersCount++;
                                                            mainVariables.popularSearchDataMain!.value.response[index].believed = true;
                                                            if (mainVariables.isJourney.value) {
                                                              if (mainVariables.believersCountMainMyself.value < 3) {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Please believe ${3 - mainVariables.believersCountMainMyself.value} more users for next steps"),
                                                                  margin: EdgeInsets.only(bottom: height - 200),
                                                                  behavior: SnackBarBehavior.floating,
                                                                  duration: const Duration(seconds: 1),
                                                                ));
                                                              } else {
                                                                if (tutorialCoachMark.isShowing) {
                                                                  tutorialCoachMark.finish();
                                                                }
                                                                mainVariables.activeTypeMain.value = "believed";
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) => const MainBottomNavigationPage(
                                                                            caseNo1: 2,
                                                                            text: "stocks",
                                                                            excIndex: 1,
                                                                            newIndex: 0,
                                                                            countryIndex: 0,
                                                                            isHomeFirstTym: false,
                                                                            tType: true)));
                                                              }
                                                            }
                                                            setState(() {});
                                                          } else if (responseData['message'] == "Unbelieved successfully") {
                                                            logEventFunc(
                                                                name:
                                                                    "Unbelieved_User_${mainVariables.popularSearchDataMain!.value.response[index].id}",
                                                                type: "BillBoard");
                                                            mainVariables.believersCountMainMyself.value--;
                                                            mainVariables.popularSearchDataMain!.value.response[index].believersCount--;
                                                            mainVariables.popularSearchDataMain!.value.response[index].believed = false;
                                                            if (mainVariables.isJourney.value) {
                                                              if (mainVariables.believersCountMainMyself.value < 3) {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Please believe ${3 - mainVariables.believersCountMainMyself.value} more users to do this action"),
                                                                  margin: EdgeInsets.only(bottom: height - 200),
                                                                  behavior: SnackBarBehavior.floating,
                                                                  duration: const Duration(seconds: 1),
                                                                ));
                                                              } else {
                                                                if (tutorialCoachMark.isShowing) {
                                                                  tutorialCoachMark.finish();
                                                                }
                                                                mainVariables.activeTypeMain.value = "believed";
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) => const MainBottomNavigationPage(
                                                                            caseNo1: 2,
                                                                            text: "stocks",
                                                                            excIndex: 1,
                                                                            newIndex: 0,
                                                                            countryIndex: 0,
                                                                            isHomeFirstTym: false,
                                                                            tType: true)));
                                                              }
                                                            }
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Obx(() => Container(
                                                              height: height / 33.76,
                                                              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                              decoration: BoxDecoration(
                                                                color: mainVariables.popularSearchDataMain!.value.response[index].believed
                                                                    ? Colors.transparent
                                                                    : Colors.green,
                                                                border: Border.all(
                                                                    color: mainVariables.popularSearchDataMain!.value.response[index].believed
                                                                        ? const Color(0XFFD9D9D9)
                                                                        : Colors.transparent),
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              clipBehavior: Clip.hardEdge,
                                                              child: Center(
                                                                child: Text(
                                                                  mainVariables.popularSearchDataMain!.value.response[index].believed
                                                                      ? "Believed"
                                                                      : "Believe",
                                                                  style: TextStyle(
                                                                      color: mainVariables.popularSearchDataMain!.value.response[index].believed
                                                                          ? isDarkTheme.value
                                                                              ? Colors.white
                                                                              : Colors.black
                                                                          : Colors.white),
                                                                ),
                                                              ),
                                                            )))

                                                    /*billboardWidgetsMain.getBelieveButton(
                                                                                      heightValue: _height/33.76,
                                                                                      isBelieved: RxList.generate(mainVariables.popularSearchDataMain!.value.response.length, (index) => mainVariables.popularSearchDataMain!.value.response[index].believed),//mainVariables.popularSearchDataBelievedList,
                                                                                      billboardUserid: mainVariables.popularSearchDataMain!.value.response[index].id,
                                                                                      billboardUserName: mainVariables.popularSearchDataMain!.value.response[index].username,
                                                                                      context: context,
                                                                                      modelSetState: setState,
                                                                                      index: index,
                                                                                    believersCount:RxList.generate(mainVariables.popularSearchDataMain!.value.response.length, (index) => mainVariables.popularSearchDataMain!.value.response[index].believersCount), isSearchData: false,
                                                                                  ),*/
                                                    ),
                                                title: Text(
                                                  "${mainVariables.popularSearchDataMain!.value.response[index].firstName} ${mainVariables.popularSearchDataMain!.value.response[index].lastName} ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium, /*TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFF1D1D1D)),*/
                                                ),
                                                subtitle: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          width: width / 4.3,
                                                          child: Text(
                                                            mainVariables.popularSearchDataMain!.value.response[index].username,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: text.scale(10),
                                                                color: const Color(0XFFAFAFAF)),
                                                          )),
                                                      const VerticalDivider(
                                                        thickness: 1.5,
                                                      ),
                                                      InkWell(
                                                        onTap: mainVariables.isFirstTime.value
                                                            ? () {}
                                                            : () {
                                                                billboardWidgetsMain.believersTabBottomSheet(
                                                                  context: context,
                                                                  id: mainVariables.popularSearchDataMain!.value.response[index].id,
                                                                  isBelieversList: true,
                                                                );
                                                              },
                                                        child: Text(
                                                          "${mainVariables.popularSearchDataMain!.value.response[index].believersCount} Believers",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFAFAFAF)),
                                                        ),
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
                                        })),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                ),
          /*floatingActionButton:
          mainVariables.isFirstTime.value?
          mainVariables.believersCountMainMyself.value<3?
          SizedBox() :
          FloatingActionButton(
            onPressed: (){
              if(tutorialCoachMark.isShowing){
                tutorialCoachMark.finish();
              }
              mainVariables.activeTypeMain.value="believed";
              billBoardPageName.value="billboard";
              gettingPageRoute(pageName: billBoardPageName.value);
            },
            child: Icon(Icons.arrow_forward_ios,),
          ):
          SizedBox(),*/
        ),
      ),
    );
  }
}
