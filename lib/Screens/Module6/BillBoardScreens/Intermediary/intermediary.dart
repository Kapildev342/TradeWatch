import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/user_profile_data_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_page.dart';

class IntermediaryBillBoardProfilePage extends StatefulWidget {
  final String userId;
  final String? fromLink;

  const IntermediaryBillBoardProfilePage({Key? key, required this.userId, this.fromLink}) : super(key: key);

  @override
  State<IntermediaryBillBoardProfilePage> createState() => _IntermediaryBillBoardProfilePageState();
}

class _IntermediaryBillBoardProfilePageState extends State<IntermediaryBillBoardProfilePage> with TickerProviderStateMixin {
  bool loader = false;
  int selectedIndex = 0;
  TabController? _intermediaryTabController;
  late UserProfileDataModel profile;
  int believersCount = 0;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void initState() {
    getAllDataMain(name: 'Intermediary_Profile_Page');
    getData();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716',
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
  }

  getData() async {
    _intermediaryTabController = TabController(length: 9, vsync: this, initialIndex: 0);
    mainVariables.selectedIntermediaryControllerIndex.value = _intermediaryTabController!.index;
    profile = await settingsMain.getUserProfileData(userId: widget.userId);
    billBoardFunctionsMain.getNotifyCountAndImage();
    await billBoardApiMain.getProfileVisitNotificationFunc(id: widget.userId);
    mainVariables.userBelievedProfileSingle = (profile.response.believed).obs;
    believersCount = profile.response.believersCount;
    setState(() {
      loader = true;
    });
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    mainVariables.selectedIntermediaryControllerIndex.value = _intermediaryTabController!.index;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromLink == "main") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                        text: '',
                        caseNo1: 0,
                        tType: true,
                        newIndex: 0,
                        excIndex: 1,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                      )));
        } else {
          mainVariables.billBoardListSearchControllerMain.value.clear();
          Navigator.pop(context, true);
        }
        return false;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: Colors.black,
            child: SafeArea(
                child: Scaffold(
              //backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: loader
                  ? CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          delegate:
                              MySliverAppBar(expandedHeight: height / 4.02, setState: setState, profile: profile, fromLink: widget.fromLink ?? ""),
                          pinned: true,
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 11.54,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${profile.response.firstName.toUpperCase()} ${profile.response.lastName.toUpperCase()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary, fontSize: text.scale(22)),
                                    ),
                                    Text(
                                      "+${profile.response.username.toLowerCase()}",
                                      style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0XFF0EA102), fontSize: text.scale(10)),
                                    ),
                                    SizedBox(height: height / 57.73),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        userIdMain == widget.userId
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (BuildContext context) => const EditProfilePage(comeFrom: true)));
                                                },
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ))
                                            : const SizedBox(),
                                        userIdMain == widget.userId
                                            ? SizedBox(
                                                width: width / 16.44,
                                              )
                                            : const SizedBox(),
                                        billboardWidgetsMain.profileShare(
                                            context: context,
                                            heightValue: height / 34.64,
                                            widthValue: width / 16.44,
                                            id: profile.response.id,
                                            type: 'intermediate'),
                                        SizedBox(
                                          width: width / 16.44,
                                        ),
                                        userIdMain == profile.response.id
                                            ? const SizedBox()
                                            : bookMarkWidgetSingle(
                                                bookMark: [profile.response.bookmark],
                                                id: profile.response.id,
                                                type: "users",
                                                context: context,
                                                scale: 3.2,
                                                modelSetState: setState,
                                                index: 0),
                                        /*userIdMain==profile.response.id
                                              ?GestureDetector(
                                            onTap: () {
                                              mainVariables.conversationUserData.value =
                                                  ConversationUserData(
                                                      userId: profile.response.id,
                                                      avatar: profile.response.avatar,
                                                      firstName: profile.response.firstName,
                                                      lastName: profile.response.lastName,
                                                      userName: profile.response.username,
                                                      isBelieved: profile.response.believed);
                                              Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (BuildContext context){
                                                    return ConversationPage();
                                                  }));
                                            },
                                            child: Stack(
                                                alignment: Alignment.topRight,
                                                children:[
                                                  Container(
                                                    height: _height / 25.02,
                                                    width: _width / 11.74,
                                                    padding: EdgeInsets.symmetric(vertical:5),
                                                    child: Center(
                                                      child: Image.asset(
                                                          "lib/Constants/Assets/BillBoard/messages.png"),
                                                    ),
                                                  ),
                                                  badgeMessageCount.value == 0
                                                      ? SizedBox()
                                                      : Container(
                                                    height: _height / 50,
                                                    width: _width / 25,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0XFFF5103A),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                          badgeMessageCount.value > 99
                                                              ? "99+"
                                                              : badgeMessageCount.value.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: badgeMessageCount.value.toString().length == 1
                                                                ? _text.scale(10)10
                                                                : badgeMessageCount.value.toString().length == 2
                                                                ? _text.scale(10)8
                                                                : _text.scale(10)6,
                                                          ),
                                                        )),
                                                  )
                                                ]
                                            ),
                                          ):SizedBox(),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 57.73,
                              ),
                              Container(
                                width: width,
                                height: height / 14.43,
                                margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                padding: EdgeInsets.symmetric(vertical: width / 102.75),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Theme.of(context).colorScheme.tertiary),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            profile.response.postCount < 999
                                                ? "${profile.response.postCount}"
                                                : profile.response.postCount > 999 && profile.response.postCount < 99999
                                                    ? "${(profile.response.postCount / 1000).toStringAsFixed(1)}K"
                                                    : "${(profile.response.postCount / 100000).toStringAsFixed(1)}L",
                                            //   "${profile.response.postCount}",
                                            style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF0CA202)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          Text(
                                            "Post",
                                            style: TextStyle(
                                                fontSize: text.scale(14),
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onPrimary),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(),
                                      InkWell(
                                        onTap: () {
                                          billboardWidgetsMain.believersTabBottomSheet(
                                            context: context,
                                            id: widget.userId,
                                            isBelieversList: true,
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              believersCount < 999
                                                  ? "$believersCount"
                                                  : believersCount > 999 && believersCount < 99999
                                                      ? "${(believersCount / 1000).toStringAsFixed(1)}K"
                                                      : "${(believersCount / 100000).toStringAsFixed(1)}L",
                                              // "$believersCount",
                                              style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF0CA202)),
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            Text(
                                              "Believed",
                                              style: TextStyle(
                                                  fontSize: text.scale(14),
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.onPrimary),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            profile.response.reportCount < 999
                                                ? "${profile.response.reportCount}"
                                                : profile.response.reportCount > 999 && profile.response.reportCount < 99999
                                                    ? "${(profile.response.reportCount / 1000).toStringAsFixed(1)}K"
                                                    : "${(profile.response.reportCount / 100000).toStringAsFixed(1)}L",
                                            // "${profile.response.reportCount}",
                                            style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF0CA202)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          Text(
                                            "Reports",
                                            style: TextStyle(
                                                fontSize: text.scale(14),
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onPrimary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 57.73,
                              ),
                              userIdMain == widget.userId
                                  ? const SizedBox()
                                  : Container(
                                      height: 40,
                                      width: width,
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              Map<String, dynamic> response = await billBoardApiMain.getUserBelieve(
                                                id: profile.response.id,
                                                name: profile.response.username,
                                              );
                                              if (response["status"]) {
                                                setState(() {
                                                  mainVariables.userBelievedProfileSingle.value = !mainVariables.userBelievedProfileSingle.value;
                                                  mainVariables.userBelievedProfileSingle.value ? believersCount++ : believersCount--;
                                                });
                                                if (!mounted) {
                                                  return;
                                                }
                                                await billBoardApiMain.getSearchData(
                                                    searchKey: mainVariables.billBoardSearchControllerMain.value.text, context: context);
                                                for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
                                                  if (mainVariables.popularSearchDataMain!.value.response[i].id == profile.response.id) {
                                                    mainVariables.popularSearchDataMain!.value.response[i].believed = false;
                                                    mainVariables.popularSearchDataMain!.value.response[i].believersCount--;
                                                  }
                                                }
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
                                                  userId: profile.response.id,
                                                );
                                                mainVariables.valueMapListProfilePage.clear();
                                                mainVariables.valueMapListProfilePage.addAll(mainVariables.billBoardDataProfilePage!.value.response);
                                              }
                                            },
                                            child: Obx(() => mainVariables.userBelievedProfileSingle.value
                                                ? Container(
                                                    width: width / 1.3,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: isDarkTheme.value ? Colors.transparent : const Color(0XFF0EA102)),
                                                      color: isDarkTheme.value ? const Color(0xff464646) : Colors.white,
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        "Believed",
                                                        style: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: width / 1.3,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: const Color(0XFF0EA102),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        "Believe",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  )),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              mainVariables.conversationUserData.value = ConversationUserData(
                                                  userId: profile.response.id,
                                                  avatar: profile.response.avatar,
                                                  firstName: profile.response.firstName,
                                                  lastName: profile.response.lastName,
                                                  userName: profile.response.username,
                                                  isBelieved: profile.response.believed);
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return const ConversationPage();
                                              }));
                                            },
                                            child: SizedBox(
                                              width: 40,
                                              child: Center(
                                                child: SvgPicture.asset("lib/Constants/Assets/BillBoard/messageSymbol.svg"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: height / 57.73,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                      fontSize: text.scale(14),
                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: height / 86.6,
                              ),
                              Container(
                                  width: width,
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Text(
                                    profile.response.about == "" ? "Description not available" : profile.response.about,
                                    style: TextStyle(
                                        fontSize: text.scale(12), fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary),
                                  )),
                              SizedBox(
                                height: height / 57.73,
                              ),
                              SizedBox(
                                height: height / 1.13,
                                width: width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: height / 57.73,
                                    ),
                                    PreferredSize(
                                      preferredSize: Size.fromWidth(width / 29.2),
                                      child: SizedBox(
                                        height: height / 20.55,
                                        child: TabBar(
                                          isScrollable: true,
                                          indicatorWeight: 0.1,
                                          dividerColor: Colors.transparent,
                                          dividerHeight: 0.0,
                                          indicatorColor: Colors.transparent,
                                          tabAlignment: TabAlignment.start,
                                          controller: _intermediaryTabController,
                                          splashFactory: NoSplash.splashFactory,
                                          splashBorderRadius: BorderRadius.circular(15),
                                          tabs: [
                                            Tab(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffAFAFAF),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Obx(
                                                  () => Text(
                                                    'BillBoard',
                                                    style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      fontWeight: FontWeight.w600,
                                                      color: mainVariables.selectedIntermediaryControllerIndex.value == 0
                                                          ? const Color(0XFF0EA102)
                                                          : isDarkTheme.value
                                                              ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                              : Colors.black38,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Live Sessions',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 1
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Communities',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 2
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Services',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 3
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Credentials',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 4
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Testimonials',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 5
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Resource Hub',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 6
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Activity',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 7
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Tab(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffAFAFAF),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      'Featured',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedIntermediaryControllerIndex.value == 8
                                                            ? const Color(0XFF0EA102)
                                                            : isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                                                                : Colors.black38,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                          onTap: (index) {
                                            mainVariables.billBoardListSearchControllerMain.value.clear();
                                            selectedIndex = index;
                                            mainVariables.selectedIntermediaryControllerIndex.value = selectedIndex;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 57.73,
                                    ),
                                    Container(
                                      height: height / 1.27,
                                      width: width,
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                        color: Theme.of(context).colorScheme.onBackground,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: height / 57.73,
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _intermediaryTabController,
                                              physics: const ScrollPhysics(),
                                              children: [
                                                BillBoardTabPage(
                                                  userId: widget.userId,
                                                ),
                                                const LiveSessionsPage(),
                                                const CommunitiesTabPage(),
                                                const ServicesPage(),
                                                const CredentialsPage(),
                                                const TestimonialsPage(),
                                                const ResourceHubPage(),
                                                const ActivityTabPage(),
                                                FeaturedTabPage(
                                                  tickerId: "",
                                                  userId: widget.userId,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ]))
                      ],
                    )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                    ),
            )),
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
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final UserProfileDataModel profile;
  StateSetter setState;
  final String fromLink;

  MySliverAppBar({
    required this.expandedHeight,
    required this.setState,
    required this.profile,
    required this.fromLink,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Stack(clipBehavior: Clip.none, fit: StackFit.expand, alignment: Alignment.centerLeft, children: [
      profile.response.coverImage == ""
          ? Image.asset(
              "lib/Constants/Assets/Settings/coverImage_default.png",
              fit: BoxFit.fill,
            )
          : profile.response.coverImage.contains("svg")
              ? SvgPicture.network(profile.response.coverImage, fit: BoxFit.fill)
              : Image.network(
                  profile.response.coverImage,
                  fit: BoxFit.fill,
                ),
      Opacity(
        opacity: shrinkOffset / expandedHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: width / 4.11),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black26.withOpacity(0.3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width / 1.5,
                    child: Text(
                      "${profile.response.firstName.toUpperCase()} ${profile.response.lastName.toUpperCase()}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: const Color(0XFFFFFFFF), fontSize: text.scale(16), overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    profile.response.username,
                    style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0XFFFFFFFF), fontSize: text.scale(10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: (-0.85 * shrinkOffset) + height / 6.414,
        left: (-0.01 * shrinkOffset),
        right: (1.3 * shrinkOffset),
        child: Transform.scale(
          scale: 1 - (shrinkOffset * 0.7) / expandedHeight,
          //opacity: (1 - shrinkOffset / expandedHeight),
          child: Container(
            height: height / 5.77,
            width: width / 2.74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black26.withOpacity(0.3)),
              image: profile.response.avatar == "" || profile.response.avatar.contains("svg")
                  ? const DecorationImage(image: AssetImage("lib/Constants/Assets/SMLogos/Logos/TradeWatch.png"), fit: BoxFit.contain)
                  : DecorationImage(image: NetworkImage(profile.response.avatar), fit: BoxFit.contain),
            ),
            clipBehavior: Clip.hardEdge,
          ),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: IconButton(
            onPressed: () async {
              if (fromLink == "main") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const MainBottomNavigationPage(
                              text: '',
                              caseNo1: 0,
                              tType: true,
                              newIndex: 0,
                              excIndex: 1,
                              countryIndex: 0,
                              isHomeFirstTym: false,
                            )));
              } else {
                mainVariables.billBoardListSearchControllerMain.value.clear();
                Navigator.pop(context, true);
                /*mainVariables.valueMapListProfilePage.clear();
                  mainVariables.responseFocusList.clear();
                  mainVariables.globalKeyList.clear();
                  mainVariables.responseControllerList.clear();
                  mainVariables.pickedImageMain.clear();
                  mainVariables.pickedVideoMain.clear();
                  mainVariables.pickedFileMain.clear();
                  mainVariables.docMain.clear();
                  mainVariables.selectedUrlTypeMain.clear();
                  mainVariables.docFilesMain.clear();
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
                  if(mainVariables.billBoardDataProfilePage!.value.response.isNotEmpty){
                    mainVariables.valueMapListProfilePage.addAll(mainVariables.billBoardDataProfilePage!.value.response);
                    for(int i=0;i<mainVariables.billBoardDataProfilePage!.value.response.length;i++){
                      mainVariables.responseFocusList.add(FocusNode());
                      mainVariables.globalKeyList.add(GlobalKey());
                      mainVariables.responseControllerList.add(TextEditingController());
                      mainVariables.pickedImageMain.add(null);
                      mainVariables.pickedVideoMain.add(null);
                      mainVariables.pickedFileMain.add(null);
                      mainVariables.docMain.add(null);
                      mainVariables.selectedUrlTypeMain.add("");
                      mainVariables.docFilesMain.add([]);
                    }
                  }*/
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      profile.response.id == userIdMain
          ? const SizedBox()
          : Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                  onPressed: () async {
                    conversationWidgetsMain.bottomSheet(
                        context: context, modelSetState: setState, fromWhere: 'list', index: 0, userId: profile.response.id);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))),
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class LiveSessionsPage extends StatefulWidget {
  const LiveSessionsPage({Key? key}) : super(key: key);

  @override
  State<LiveSessionsPage> createState() => _LiveSessionsPageState();
}

class _LiveSessionsPageState extends State<LiveSessionsPage> {
  @override
  void initState() {
    mainVariables.billBoardListSearchControllerMain.value.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedIntermediaryControllerIndex.value = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 24.17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/businessProfile/rocket.svg",
            height: height / 3.464,
            width: width / 1.49,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: text.scale(24)),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            width: width / 1.2,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'On your way very shortly, Stay tuned! ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          fontSize: text.scale(12),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          // ElevatedButton(onPressed: (){}, child: Text("Notify",style: TextStyle(fontSize:_text* 12,fontWeight: FontWeight.w600),))
        ],
      ),
    );
  }
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    mainVariables.billBoardListSearchControllerMain.value.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedIntermediaryControllerIndex.value = 3;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 24.17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/businessProfile/rocket.svg",
            height: height / 3.464,
            width: width / 1.49,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: text.scale(24)),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            width: width / 1.2,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'On your way very shortly, Stay tuned! ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          fontSize: text.scale(12),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          //  ElevatedButton(onPressed: (){}, child: Text("Notify",style: TextStyle(fontSize:_text* 12,fontWeight: FontWeight.w600),))
        ],
      ),
    );
  }
}

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({Key? key}) : super(key: key);

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  @override
  void initState() {
    mainVariables.billBoardListSearchControllerMain.value.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedIntermediaryControllerIndex.value = 4;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 24.17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/businessProfile/rocket.svg",
            height: height / 3.464,
            width: width / 1.49,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: text.scale(24)),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            width: width / 1.2,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'On your way very shortly, Stay tuned! ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          fontSize: text.scale(12),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          //  ElevatedButton(onPressed: (){}, child: Text("Notify",style: TextStyle(fontSize:_text* 12,fontWeight: FontWeight.w600),))
        ],
      ),
    );
  }
}

class TestimonialsPage extends StatefulWidget {
  const TestimonialsPage({Key? key}) : super(key: key);

  @override
  State<TestimonialsPage> createState() => _TestimonialsPageState();
}

class _TestimonialsPageState extends State<TestimonialsPage> {
  @override
  void initState() {
    mainVariables.billBoardListSearchControllerMain.value.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedIntermediaryControllerIndex.value = 5;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 24.17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/businessProfile/rocket.svg",
            height: height / 3.464,
            width: width / 1.49,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: text.scale(24)),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            width: width / 1.2,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'On your way very shortly, Stay tuned! ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          fontSize: text.scale(12),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          //ElevatedButton(onPressed: (){}, child: Text("Notify",style: TextStyle(fontSize:_text* 12,fontWeight: FontWeight.w600),))
        ],
      ),
    );
  }
}

class ResourceHubPage extends StatefulWidget {
  const ResourceHubPage({Key? key}) : super(key: key);

  @override
  State<ResourceHubPage> createState() => _ResourceHubPageState();
}

class _ResourceHubPageState extends State<ResourceHubPage> {
  @override
  void initState() {
    mainVariables.billBoardListSearchControllerMain.value.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedIntermediaryControllerIndex.value = 6;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 24.17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/businessProfile/rocket.svg",
            height: height / 3.464,
            width: width / 1.49,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: text.scale(24)),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            width: width / 1.2,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'On your way very shortly, Stay tuned! ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          fontSize: text.scale(12),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          //  ElevatedButton(onPressed: (){}, child: Text("Notify",style: TextStyle(fontSize:_text* 12,fontWeight: FontWeight.w600),))
        ],
      ),
    );
  }
}
