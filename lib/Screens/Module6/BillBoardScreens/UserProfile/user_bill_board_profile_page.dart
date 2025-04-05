import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/add_watch_list_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/user_profile_data_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_page.dart';

class UserBillBoardProfilePage extends StatefulWidget {
  final String userId;
  final String? fromLink;

  const UserBillBoardProfilePage({Key? key, required this.userId, this.fromLink}) : super(key: key);

  @override
  State<UserBillBoardProfilePage> createState() => _UserBillBoardProfilePageState();
}

class _UserBillBoardProfilePageState extends State<UserBillBoardProfilePage> with TickerProviderStateMixin {
  bool loader = false;
  int selectedIndex = 0;
  int believersCount = 0;
  TabController? _userTabController;
  late UserProfileDataModel profile;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void initState() {
    getAllDataMain(name: 'User_BillBoard_Profile_Screen');
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    getData();
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
    _userTabController = TabController(length: 6, vsync: this, initialIndex: 0);

    mainVariables.selectedUserControllerIndex = _userTabController!.index.obs;
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
    mainVariables.selectedUserControllerIndex.value = _userTabController!.index;
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
                                            type: 'user'),
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
                                        /* userIdMain == profile.response.id
                                            ? GestureDetector(
                                          onTap: () {
                                            mainVariables
                                                .conversationUserData.value =
                                                ConversationUserData(
                                                    userId: profile.response.id,
                                                    avatar:
                                                    profile.response.avatar,
                                                    firstName: profile
                                                        .response.firstName,
                                                    lastName:
                                                    profile.response.lastName,
                                                    userName:
                                                    profile.response.username,
                                                    isBelieved: profile
                                                        .response.believed);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  return ConversationPage();
                                                }));
                                          },
                                                child: Stack(
                                                    alignment: Alignment.topRight,
                                                    children: [
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                                color: Color(
                                                                    0XFFF5103A),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                badgeMessageCount
                                                                            .value >
                                                                        99
                                                                    ? "99+"
                                                                    : badgeMessageCount
                                                                        .value
                                                                        .toString(),
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: badgeMessageCount
                                                                              .value
                                                                              .toString()
                                                                              .length ==
                                                                          1
                                                                      ? _text.scale(10)10
                                                                      : badgeMessageCount
                                                                                  .value
                                                                                  .toString()
                                                                                  .length ==
                                                                              2
                                                                          ? _text *
                                                                              8
                                                                          : _text *
                                                                              6,
                                                                ),
                                                              )),
                                                            )
                                                    ]),
                                              )
                                            : SizedBox(),*/
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
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
                                            // "${profile.response.postCount}",
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
                                            //"${profile.response.reportCount}",
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
                                                var url = Uri.parse(baseurl + versions + activity);
                                                var response =
                                                    await http.post(url, headers: {'authorization': kToken}, body: {"userId": widget.userId});
                                                Map<String, dynamic> notify = jsonDecode(response.body);
                                                mainVariables.fetchMaterialMain!.value = ActivityList.fromJson(notify);
                                                mainVariables.fetchMaterialMain!.refresh();
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
                                    profile.response.about,
                                    style: TextStyle(
                                        fontSize: text.scale(12), fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary),
                                  )),
                              SizedBox(
                                height: height / 1.13,
                                width: width,
                                child: Column(
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
                                          controller: _userTabController,
                                          indicatorWeight: 0.1,
                                          dividerColor: Colors.transparent,
                                          dividerHeight: 0.0,
                                          indicatorColor: Colors.transparent,
                                          tabAlignment: TabAlignment.start,
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
                                                      color: mainVariables.selectedUserControllerIndex.value == 0
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
                                                      'Portfolio',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedUserControllerIndex.value == 1
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
                                                        color: mainVariables.selectedUserControllerIndex.value == 2
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
                                                      'Reposted',
                                                      style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w600,
                                                        color: mainVariables.selectedUserControllerIndex.value == 3
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
                                                        color: mainVariables.selectedUserControllerIndex.value == 4
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
                                                        color: mainVariables.selectedUserControllerIndex.value == 5
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
                                            mainVariables.selectedUserControllerIndex.value = _userTabController!.index;
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: height / 57.73,
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _userTabController,
                                              physics: const ScrollPhysics(),
                                              children: [
                                                BillBoardTabPage(userId: widget.userId),
                                                const PortFolioPage(),
                                                const CommunitiesTabPage(),
                                                RepostsTabPage(userId: widget.userId),
                                                FeaturedTabPage(tickerId: "", userId: widget.userId),
                                                ActivityUserTabPage(userId: widget.userId, userName: profile.response.username),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ]))
                      ],
                    )
                  : Center(
                      child: Lottie.asset(
                        'lib/Constants/Assets/SMLogos/loading.json',
                        height: height / 8.66,
                        width: width / 4.11,
                      ),
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
                          fontWeight: FontWeight.w600,
                          color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.background,
                          fontSize: text.scale(16),
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    profile.response.username,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.background,
                        fontSize: text.scale(10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: (-0.85 * shrinkOffset) + (height / 6.414),
        left: (-0.01 * shrinkOffset), //-60,
        right: (1.3 * shrinkOffset),
        child: Transform.scale(
          scale: 1 - (shrinkOffset * 0.7) / expandedHeight,
          //opacity: (1 - shrinkOffset / expandedHeight),
          child: Container(
            height: height / 5.77,
            width: width / 2.74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.background,
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
                /* mainVariables.valueMapListProfilePage.clear();
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
                /*await billBoardApiMain.getBillBoardListApiFunc(
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
                    mainVariables.valueMapListProfilePage.clear();
                    mainVariables.valueMapListProfilePage.addAll(
                        mainVariables.billBoardDataProfilePage!.value.response);*/
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.background,
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
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )))
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class PortFolioPage extends StatefulWidget {
  const PortFolioPage({Key? key}) : super(key: key);

  @override
  State<PortFolioPage> createState() => _PortFolioPageState();
}

class _PortFolioPageState extends State<PortFolioPage> {
  @override
  void initState() {
    mainVariables.billBoardListSearchControllerMain.value.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedUserControllerIndex.value = 1;
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
      color: Theme.of(context).colorScheme.onBackground,
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

class ActivityUserTabPage extends StatefulWidget {
  final String userId;
  final String userName;

  const ActivityUserTabPage({Key? key, required this.userId, required this.userName}) : super(key: key);

  @override
  State<ActivityUserTabPage> createState() => _ActivityUserTabPageState();
}

class _ActivityUserTabPageState extends State<ActivityUserTabPage> {
  late Future<ActivityList> futureNotificationList;
  bool loading = false;
  String mainUserToken = "";
  String mainUserId = "";
  String categoryTitle = "";
  var time = '';
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

  /*String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
      time = "few sec ago";
    }
    else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
      time = diff.inMinutes.toString() + " min ago";
    }
    else if (diff.inHours >= 0 && diff.inHours <= 23) {
      time = time = diff.inHours.toString() + " hrs ago";
    }
    else if (diff.inDays >= 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    }
    else {
      if (diff.inDays >= 7 && diff.inDays <= 13) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else if (diff.inDays > 13 && diff.inDays <= 29) {
        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      } else if (diff.inDays > 29 && diff.inDays <= 59) {
        time = (diff.inDays / 30).floor().toString() + ' month ago';
      } else if (diff.inDays > 59 && diff.inDays <= 360) {
        time = (diff.inDays / 30).floor().toString() + ' months ago';
      } else {
        time = "a year ago";
      }
    }
    setState(() {
      timeList.add(time);
    });
    return time;
  }*/

  Future getIdData({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
    mainVariables.billBoardListSearchControllerMain.value.clear();
    getAllDataMain(name: 'My_Activity');
    Future.delayed(const Duration(milliseconds: 100), () {
      mainVariables.selectedUserControllerIndex.value = 5;
    });
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getEx();
    getNotifyCountAndImage();
    await activityList(userId: widget.userId);
    setState(() {
      loading = true;
    });
  }

  activityList({required String userId}) async {
    nativeAdList.clear();
    nativeAdIsLoadedList.clear();
    var url = Uri.parse(baseurl + versions + activity);
    var response = await http.post(url, headers: {'authorization': kToken}, body: {"userId": userId});
    Map<String, dynamic> notify = jsonDecode(response.body);
    mainVariables.fetchMaterialMain = (ActivityList.fromJson(notify)).obs;
    if (mainVariables.fetchMaterialMain!.value.status) {
      if (mainVariables.fetchMaterialMain!.value.response.isNotEmpty) {
        for (int i = 0; i < mainVariables.fetchMaterialMain!.value.response.length; i++) {
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
          /* DateTime dt = DateTime.parse(mainVariables.fetchMaterialMain!.value.response[i].createdAt);
          final timestamp1 = dt.millisecondsSinceEpoch;
          readTimestamp(timestamp1);*/
        }
      }
    }
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
    return loading
        ? SingleChildScrollView(
            child: Obx(
              () => mainVariables.fetchMaterialMain!.value.response.isEmpty
                  ? mainVariables.fetchMaterialMain!.value.believed
                      ? Container(
                          height: height / 1.4,
                          width: width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                  image: AssetImage("lib/Constants/Assets/BillBoard/businessProfile/trust_activity.jpg"), fit: BoxFit.fill)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                            const Expanded(
                                child: Text(
                              "Please believe him to visit this profile Activities",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(color: Colors.black, fontSize: 10, fontStyle: FontStyle.italic),
                            )),
                            billboardWidgetsMain.getUserActivityBelieveButton(
                                heightValue: height / 24.74,
                                context: context,
                                background: false,
                                modelSetState: setState,
                                id: widget.userId,
                                name: widget.userName),
                          ]))
                      : Container(
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
                      itemCount: mainVariables.fetchMaterialMain!.value.response.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index % 3 == 2 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 1, offset: const Offset(1, 2), color: Colors.grey.shade300)],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                                              mainVariables.fetchMaterialMain!.value.response[index].day,
                                              style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                            ),
                                          ))
                                      : mainVariables.fetchMaterialMain!.value.response[index].day ==
                                              mainVariables.fetchMaterialMain!.value.response[index - 1].day
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
                                                  mainVariables.fetchMaterialMain!.value.response[index].day,
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
                                          if (mainVariables.fetchMaterialMain!.value.response[index].type == 'forums' ||
                                              mainVariables.fetchMaterialMain!.value.response[index].type == 'survey' ||
                                              mainVariables.fetchMaterialMain!.value.response[index].type == 'feature') {
                                            activityResponse = await getIdData(
                                                type: mainVariables.fetchMaterialMain!.value.response[index].type,
                                                id: mainVariables.fetchMaterialMain!.value.response[index].typeId);
                                            activityResponseStatus = activityResponse["status"];
                                          } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch_notification') {
                                            activityResponse = await getNotify(id: mainVariables.fetchMaterialMain!.value.response[index].typeId);
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
                                          } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch') {
                                            activityResponse = await getWatch(id: mainVariables.fetchMaterialMain!.value.response[index].typeId);
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
                                            mainVariables.fetchMaterialMain!.value.response[index].type == 'survey'
                                                ? await statusFunc(surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId)
                                                : debugPrint("nothing");
                                            if (!mounted) {
                                              return;
                                            }
                                            if (mainVariables.fetchMaterialMain!.value.response[index].type == 'news') {
                                              /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return DemoPage(
                                                  url: "",
                                                  text: "",
                                                  image: "",
                                                  id: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                  type: 'news',
                                                  activity: true,
                                                );
                                              }));*/
                                              Get.to(const DemoView(), arguments: {
                                                "id": mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                "type": "news",
                                                "url": ""
                                              });
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'videos') {
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return YoutubePlayerLandscapeScreen(
                                                  comeFrom: "activity",
                                                  id: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                );
                                              }));
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'forums') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    blockBool: false,
                                                    tabIndex: 0,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return ForumPostDescriptionPage(
                                                    forumId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    comeFrom: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              } else {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return ForumPostDescriptionPage(
                                                    forumId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    comeFrom: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              }
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'feature') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 2,
                                                    blockBool: false,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FeaturePostDescriptionPage(
                                                    sortValue: 'Recent',
                                                    featureDetail: '',
                                                    featureId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    navBool: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              } else {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FeaturePostDescriptionPage(
                                                    sortValue: 'Recent',
                                                    featureDetail: '',
                                                    featureId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    navBool: 'activity',
                                                    idList: const [],
                                                  );
                                                }));
                                              }
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'survey') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    blockBool: false,
                                                    tabIndex: 1,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                mainVariables.fetchMaterialMain!.value.response[index].user.id == mainUserId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                          surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                          activity: true,
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                  activity: true,
                                                                  surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                activity: true,
                                                                surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name);
                                                          }));
                                              } else {
                                                mainVariables.fetchMaterialMain!.value.response[index].user.id == mainUserId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                          surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                          activity: true,
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                  activity: true,
                                                                  surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                activity: true,
                                                                surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name);
                                                          }));
                                              }
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch') {
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
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch_notification') {
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
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'user') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                //await checkUser(uId: fetchMaterial.response[index].typeId, uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(
                                                      userId: mainVariables.fetchMaterialMain!.value.response[index]
                                                          .typeId) /*UserProfilePage(id: uId, type: uType, index: index)*/;
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'believed') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(
                                                      userId: mainVariables.fetchMaterialMain!.value.response[index].user.id);
                                                }));
                                              } else {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const EditProfilePage(
                                                    comeFrom: true,
                                                  );
                                                }));
                                              }
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'billboard') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                mainVariables.selectedBillboardIdMain.value =
                                                    mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                                if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage(
                                                      fromWhere: "profile",
                                                    );
                                                  }));
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage(
                                                      fromWhere: "profile",
                                                    );
                                                  }));
                                                }
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'Create') {
                                                mainVariables.selectedBillboardIdMain.value =
                                                    mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                                if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              } else {
                                                mainVariables.selectedBillboardIdMain.value =
                                                    mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                                if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BytesDescriptionPage();
                                                  }));
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const BlogDescriptionPage();
                                                  }));
                                                }
                                              }
                                            } else {
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
                                                    forumId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
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
                                                    featureId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
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
                                                mainVariables.fetchMaterialMain!.value.response[index].user.id == mainUserId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                          surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                          activity: true,
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                  activity: true,
                                                                  surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                                );
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                                activity: true,
                                                                surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name);
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
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch_notification') {
                                              if (!mounted) {
                                                return;
                                              }
                                              Flushbar(
                                                message: "Notification alert removed by you",
                                                duration: const Duration(seconds: 2),
                                              ).show(context);
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch') {
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
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'user') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                await checkUser(
                                                    uId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    uType: 'forums',
                                                    mainUserToken: mainUserToken,
                                                    context: context,
                                                    index: 0);
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'believed') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(
                                                      userId: mainVariables.fetchMaterialMain!.value.response[index].user.id);
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
                                            } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'billboard') {
                                              if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                                if (!mounted) {
                                                  return;
                                                }
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BlockListPage(
                                                    tabIndex: 0,
                                                    blockBool: true,
                                                  );
                                                }));
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                                mainVariables.selectedBillboardIdMain.value =
                                                    mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                                if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                              } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'Create') {
                                                mainVariables.selectedBillboardIdMain.value =
                                                    mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                                if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                                mainVariables.selectedBillboardIdMain.value =
                                                    mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                                if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                                      image: NetworkImage(mainVariables.fetchMaterialMain!.value.response[index].user.avatar),
                                                      fit: BoxFit.fill)),
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
                                                          activity: mainVariables.fetchMaterialMain!.value.response[index].activity,
                                                          type: mainVariables.fetchMaterialMain!.value.response[index].type),
                                                      fit: BoxFit.fill)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        mainVariables.fetchMaterialMain!.value.response[index].name,
                                        style: TextStyle(
                                            fontSize: text.scale(12), fontWeight: FontWeight.w500, fontFamily: "Poppins", color: Colors.black),
                                      )
                                      /*RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: fetchMaterial
                                                    .response[index].activity ==
                                                "update" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "change password" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "blocked" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "unblocked" ||
                                            fetchMaterial
                                                    .response[index].type ==
                                                "watch_notification" ||
                                            fetchMaterial
                                                    .response[index].type ==
                                                "watch"
                                        ? ""
                                        : 'You ',
                                    style: TextStyle(
                                        fontSize: _text.scale(10)12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: fetchMaterial.response[index].activity ==
                                            "liked"
                                        ? "liked"
                                        : fetchMaterial
                                                    .response[index].activity ==
                                                "disliked"
                                            ? "disliked"
                                            : fetchMaterial.response[index]
                                                        .activity ==
                                                    "shared"
                                                ? "shared"
                                                : fetchMaterial.response[index]
                                                            .activity ==
                                                        "viewed"
                                                    ? "viewed"
                                                    : fetchMaterial
                                                                .response[index]
                                                                .activity ==
                                                            "dislike removed"
                                                        ? "removed the dislike"
                                                        : fetchMaterial.response[index].activity ==
                                                                "like removed"
                                                            ? "removed the like"
                                                            : fetchMaterial
                                                                        .response[
                                                                            index]
                                                                        .activity ==
                                                                    "Create"
                                                                ? fetchMaterial.response[index].type ==
                                                                            "watch_notification" ||
                                                                        fetchMaterial.response[index].type ==
                                                                            "watch"
                                                                    ? ""
                                                                    : "created"
                                                                : fetchMaterial
                                                                            .response[index]
                                                                            .activity ==
                                                                        "update"
                                                                    ? ""
                                                                    : fetchMaterial.response[index].activity == "answered"
                                                                        ? "answered"
                                                                        : fetchMaterial.response[index].activity == "Delete"
                                                                            ? fetchMaterial.response[index].type == "watch_notification" || fetchMaterial.response[index].type == "watch"
                                                                                ? ""
                                                                                : "deleted"
                                                                            : fetchMaterial.response[index].activity == "responded"
                                                                                ? "responded"
                                                                                : fetchMaterial.response[index].activity == "change password"
                                                                                    ? ""
                                                                                    : fetchMaterial.response[index].activity == "unblocked"
                                                                                        ? ""
                                                                                        : fetchMaterial.response[index].type == "forum response" || fetchMaterial.response[index].type == "feature response"
                                                                                            ? fetchMaterial.response[index].activity == "blocked"
                                                                                                ? "blocked"
                                                                                                : fetchMaterial.response[index].activity == "reported"
                                                                                                    ? "reported"
                                                                                                    : fetchMaterial.response[index].activity == "response removed"
                                                                                                        ? "removed"
                                                                                                        : ""
                                                                                            : fetchMaterial.response[index].activity == "blocked"
                                                                                                ? ""
                                                                                                : "",
                                    style: TextStyle(
                                        fontSize: _text.scale(10)12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: fetchMaterial
                                                    .response[index].activity ==
                                                "update" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "change password" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "blocked" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "unblocked" ||
                                            fetchMaterial
                                                    .response[index].type ==
                                                "watch_notification" ||
                                            fetchMaterial
                                                    .response[index].type ==
                                                "watch"
                                        ? ""
                                        : " ",
                                    style: TextStyle(
                                        fontSize: _text.scale(10)12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        color: Colors.black),
                                  ),
                                  fetchMaterial.response[index].type == "news"
                                      ? TextSpan(
                                          text:
                                              " ${fetchMaterial.response[index].type} ",
                                          style: TextStyle(
                                              fontSize: _text.scale(10)12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Poppins",
                                              color: Colors.black),
                                        )
                                      : fetchMaterial.response[index].type ==
                                              "videos"
                                          ? TextSpan(
                                              text: "video ",
                                              style: TextStyle(
                                                  fontSize: _text.scale(10)12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins",
                                                  color: Colors.black),
                                            )
                                          : fetchMaterial.response[index]
                                                          .activity ==
                                                      "update" ||
                                                  fetchMaterial.response[index]
                                                          .activity ==
                                                      "change password" ||
                                                  fetchMaterial.response[index]
                                                          .activity ==
                                                      "blocked" ||
                                                  fetchMaterial.response[index]
                                                          .activity ==
                                                      "unblocked" ||
                                                  fetchMaterial.response[index]
                                                          .type ==
                                                      "watch_notification" ||
                                                  fetchMaterial.response[index]
                                                          .type ==
                                                      "watch"
                                              ? TextSpan(
                                                  text: "",
                                                  style: TextStyle(
                                                      fontSize: _text.scale(10)12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Poppins",
                                                      color: Colors.black),
                                                )
                                              : TextSpan(
                                                  text: fetchMaterial
                                                              .response[index]
                                                              .user
                                                              .id ==
                                                          mainUserId
                                                      ? "your "
                                                      : "${fetchMaterial.response[index].user.username}'s ",
                                                  style: TextStyle(
                                                      fontSize: _text.scale(10)12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Poppins",
                                                      color: Colors.black),
                                                ),
                                  TextSpan(
                                    text:
                                        '${fetchMaterial.response[index].name} ',
                                    style: fetchMaterial
                                                    .response[index].activity ==
                                                "update" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "change password" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "blocked" ||
                                            fetchMaterial
                                                    .response[index].activity ==
                                                "unblocked"
                                        ? TextStyle(
                                            fontSize: _text.scale(10)12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins",
                                            color: Colors.black)
                                        : TextStyle(
                                            fontSize: _text.scale(10)12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins",
                                            color: Colors.black),
                                  ),
                                  fetchMaterial.response[index].type ==
                                              'news' ||
                                          fetchMaterial.response[index].type ==
                                              'videos' ||
                                          fetchMaterial.response[index].type ==
                                              "watch_notification" ||
                                          fetchMaterial.response[index].type ==
                                              "watch"
                                      ? TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: _text.scale(10)12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Poppins",
                                              color: Colors.black),
                                        )
                                      : TextSpan(
                                          text: fetchMaterial
                                                      .response[index].type ==
                                                  'forums'
                                              ? 'Forum'
                                              : fetchMaterial.response[index]
                                                          .type ==
                                                      'survey'
                                                  ? "Survey"
                                                  : fetchMaterial
                                                              .response[index]
                                                              .type ==
                                                          'feature'
                                                      ? "Feature Request"
                                                      : fetchMaterial
                                                                  .response[
                                                                      index]
                                                                  .type ==
                                                              'forum response'
                                                          ? "forum's response"
                                                          : fetchMaterial
                                                                      .response[
                                                                          index]
                                                                      .type ==
                                                                  'feature response'
                                                              ? "feature's response"
                                                              : '',
                                          style: TextStyle(
                                              fontSize: _text.scale(10)12,
                                              fontWeight: FontWeight.w500,
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
                                            mainVariables.fetchMaterialMain!.value.response[index].createdAt,
                                            //timeList[index],
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
                                        mainVariables.fetchMaterialMain!.value.response[index].day,
                                        style: TextStyle(fontSize: text.scale(16), color: const Color(0xffB0B0B0)),
                                      ),
                                    ))
                                : mainVariables.fetchMaterialMain!.value.response[index].day ==
                                        mainVariables.fetchMaterialMain!.value.response[index - 1].day
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
                                            mainVariables.fetchMaterialMain!.value.response[index].day,
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
                                    if (mainVariables.fetchMaterialMain!.value.response[index].type == 'forums' ||
                                        mainVariables.fetchMaterialMain!.value.response[index].type == 'survey' ||
                                        mainVariables.fetchMaterialMain!.value.response[index].type == 'feature') {
                                      activityResponse = await getIdData(
                                          type: mainVariables.fetchMaterialMain!.value.response[index].type,
                                          id: mainVariables.fetchMaterialMain!.value.response[index].typeId);
                                      activityResponseStatus = activityResponse["status"];
                                    } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch_notification') {
                                      activityResponse = await getNotify(id: mainVariables.fetchMaterialMain!.value.response[index].typeId);
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
                                    } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch') {
                                      activityResponse = await getWatch(id: mainVariables.fetchMaterialMain!.value.response[index].typeId);
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
                                      mainVariables.fetchMaterialMain!.value.response[index].type == 'survey'
                                          ? await statusFunc(surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId)
                                          : debugPrint("nothing");
                                      if (mainVariables.fetchMaterialMain!.value.response[index].type == 'news') {
                                        Get.to(const DemoView(), arguments: {
                                          "id": mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                          "type": "news",
                                          "url": ""
                                        });
                                        /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                          return DemoPage(
                                            url: "",
                                            text: "",
                                            image: "",
                                            id: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                            type: 'news',
                                            activity: true,
                                          );
                                        }));*/
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'videos') {
                                        if (!mounted) {
                                          return;
                                        }
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                          return YoutubePlayerLandscapeScreen(
                                            comeFrom: "activity",
                                            id: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                          );
                                        }));
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'forums') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              blockBool: false,
                                              tabIndex: 0,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return ForumPostDescriptionPage(
                                              forumId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
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
                                              forumId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                              comeFrom: 'activity',
                                              idList: const [],
                                            );
                                          }));
                                        }
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'feature') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 2,
                                              blockBool: false,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return FeaturePostDescriptionPage(
                                              sortValue: 'Recent',
                                              featureDetail: '',
                                              featureId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
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
                                              featureId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                              navBool: 'activity',
                                              idList: const [],
                                            );
                                          }));
                                        }
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'survey') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              blockBool: false,
                                              tabIndex: 1,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          mainVariables.fetchMaterialMain!.value.response[index].user.id == mainUserId
                                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return AnalyticsPage(
                                                    surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                    activity: true,
                                                  );
                                                }))
                                              : activeStatus == 'active'
                                                  ? answerStatus
                                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return AnalyticsPage(
                                                            surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                            activity: true,
                                                            surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                          );
                                                        }))
                                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return QuestionnairePage(
                                                            surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                            defaultIndex: answeredQuestion,
                                                          );
                                                        }))
                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return AnalyticsPage(
                                                          surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                          activity: true,
                                                          surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name);
                                                    }));
                                        } else {
                                          if (!mounted) {
                                            return;
                                          }
                                          mainVariables.fetchMaterialMain!.value.response[index].user.id == mainUserId
                                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return AnalyticsPage(
                                                    surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                    activity: true,
                                                  );
                                                }))
                                              : activeStatus == 'active'
                                                  ? answerStatus
                                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return AnalyticsPage(
                                                            surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                            activity: true,
                                                            surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                          );
                                                        }))
                                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return QuestionnairePage(
                                                            surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                            defaultIndex: answeredQuestion,
                                                          );
                                                        }))
                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return AnalyticsPage(
                                                          surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                          activity: true,
                                                          surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name);
                                                    }));
                                        }
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch') {
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch_notification') {
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'user') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 0,
                                              blockBool: true,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          //await checkUser(uId: fetchMaterial.response[index].typeId, uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return UserBillBoardProfilePage(
                                                userId: mainVariables.fetchMaterialMain!.value.response[index]
                                                    .typeId) /*UserProfilePage(id: uId, type: uType, index: index)*/;
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'believed') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return UserBillBoardProfilePage(userId: mainVariables.fetchMaterialMain!.value.response[index].user.id);
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'billboard') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 0,
                                              blockBool: true,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BytesDescriptionPage(
                                                fromWhere: "profile",
                                              );
                                            }));
                                          } else {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BlogDescriptionPage(
                                                fromWhere: "profile",
                                              );
                                            }));
                                          }
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'Create') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'billboard-response') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 0,
                                              blockBool: true,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BytesDescriptionPage(
                                                fromWhere: "profile",
                                              );
                                            }));
                                          } else {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BlogDescriptionPage(
                                                fromWhere: "profile",
                                              );
                                            }));
                                          }
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'Create') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                              forumId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
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
                                              featureId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
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
                                          mainVariables.fetchMaterialMain!.value.response[index].user.id == mainUserId
                                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return AnalyticsPage(
                                                    surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                    surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                    activity: true,
                                                  );
                                                }))
                                              : activeStatus == 'active'
                                                  ? answerStatus
                                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return AnalyticsPage(
                                                            surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                            activity: true,
                                                            surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name,
                                                          );
                                                        }))
                                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return QuestionnairePage(
                                                            surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                            defaultIndex: answeredQuestion,
                                                          );
                                                        }))
                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return AnalyticsPage(
                                                          surveyId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                                          activity: true,
                                                          surveyTitle: mainVariables.fetchMaterialMain!.value.response[index].name);
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch_notification') {
                                        if (!mounted) {
                                          return;
                                        }
                                        Flushbar(
                                          message: "Notification alert removed by you",
                                          duration: const Duration(seconds: 2),
                                        ).show(context);
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'watch') {
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'user') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 0,
                                              blockBool: true,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          await checkUser(
                                              uId: mainVariables.fetchMaterialMain!.value.response[index].typeId,
                                              uType: 'forums',
                                              mainUserToken: mainUserToken,
                                              context: context,
                                              index: 0);
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'believed') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return UserBillBoardProfilePage(userId: mainVariables.fetchMaterialMain!.value.response[index].user.id);
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'billboard') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 0,
                                              blockBool: true,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'Create') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                      } else if (mainVariables.fetchMaterialMain!.value.response[index].type == 'billboard-response') {
                                        if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'blocked') {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return const BlockListPage(
                                              tabIndex: 0,
                                              blockBool: true,
                                            );
                                          }));
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'unblocked') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BytesDescriptionPage(
                                                fromWhere: "profile",
                                              );
                                            }));
                                          } else {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BlogDescriptionPage(
                                                fromWhere: "profile",
                                              );
                                            }));
                                          }
                                        } else if (mainVariables.fetchMaterialMain!.value.response[index].activity == 'Create') {
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                          mainVariables.selectedBillboardIdMain.value = mainVariables.fetchMaterialMain!.value.response[index].typeId;
                                          if (mainVariables.fetchMaterialMain!.value.response[index].name.contains("a byte")) {
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
                                                image: NetworkImage(mainVariables.fetchMaterialMain!.value.response[index].user.avatar),
                                                fit: BoxFit.fill)),
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
                                                    activity: mainVariables.fetchMaterialMain!.value.response[index].activity,
                                                    type: mainVariables.fetchMaterialMain!.value.response[index].type),
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                  ],
                                ),
                                title: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: conversationFunctionsMain.spanListBillBoardHome(
                                        message: mainVariables.fetchMaterialMain!.value.response[index].name, context: context, isByte: true),
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      mainVariables.fetchMaterialMain!.value.response[index].createdAt,
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
                        );
                      }),
            ),
          )
        : SizedBox(
            height: height / 1.4,
            width: width,
            child: Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
            ));
  }
}
