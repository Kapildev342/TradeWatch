import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Constants/Common/api_functions.dart';
import 'package:tradewatchfinal/Constants/Common/auth_functions.dart';
import 'package:tradewatchfinal/Constants/Common/common_functions.dart';
import 'package:tradewatchfinal/Constants/Common/common_variable.dart';
import 'package:tradewatchfinal/Constants/Common/common_widgets.dart';
import 'package:tradewatchfinal/Edited_Packages/convex_bottom_bar/convex_bottom_bar.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/forget_password_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Language/language_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_edit_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/related_forums_model.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/related_survey_model.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/MultipleOne/book_mark_multiple_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module4/LTICalculator/lti_calculator_functions.dart';
import 'package:tradewatchfinal/Screens/Module4/LTICalculator/lti_calculator_widgets.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerCalculatorScreen/calculator_page_functions.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerCalculatorScreen/calculator_page_widgets.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/locker_essential_api_functions.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/locker_essentials_widgets.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerScreen/locker.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerScreen/locker_screen_functions.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerScreen/locker_screen_widgets.dart';
import 'package:tradewatchfinal/Screens/Module4/extra_filter_adding_page.dart';
import 'package:tradewatchfinal/Screens/Module4/locker_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_api_functions.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_common_functions.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BillBoard/bill_board_home.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_api_functions.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_common_functions.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/BottomSheets/bottom_sheet_page_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesFunctions/communities_functions.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesPage/communities_page_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunityCreationPage/community_creation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunityListPage/communities_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/MembersPage/members_page_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/Payment/payment_choosing_functions.dart';
import 'package:tradewatchfinal/Screens/Module8/Payment/payment_page_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HomeScreen/Home_screen_widgets.dart';
import 'HomeScreen/home_screen.dart';
import 'HomeScreen/home_screen_functions.dart';
import 'Login/sign_up_page.dart';
import 'NewsPage/Demo/demo_view.dart';
import 'NewsPage/news_description_page.dart';
import 'NewsPage/related_news_model.dart';
import 'VideosPage/related_videos_model.dart';
import 'WatchList/watch_list.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final CommonFunctions functionsMain = CommonFunctions();
final CommonWidgets widgetsMain = CommonWidgets();
final SettingsFunction settingsMain = SettingsFunction();
final LanguageFunction languageMain = LanguageFunction();
final AuthFunctions authFunctionsMain = AuthFunctions();
final ApiFunctions apiFunctionsMain = ApiFunctions();
final CommonVariable mainVariables = CommonVariable();
final CommonHomeVariable homeVariables = CommonHomeVariable();
final CommonWatchListVariable watchVariables = CommonWatchListVariable();
final CommonAdVariables adVariables = CommonAdVariables();
final CommonLockerVariables lockerVariables = CommonLockerVariables();
final CalculatorPageWidgets calculatorWidgets = CalculatorPageWidgets();
final LTICalculatorWidgets longTermWidgets = LTICalculatorWidgets();
final CalculatorPageFunctions calculatorFunctions = CalculatorPageFunctions();
final HomeScreenFunctions homeFunctions = HomeScreenFunctions();
final HomeScreenWidgets homeWidgets = HomeScreenWidgets();
final LockerScreenWidgets lockerWidgets = LockerScreenWidgets();
final LockerScreenFunctions lockerFunctions = LockerScreenFunctions();
final LockerEssentialApiFunctions lockerEssentialApiFunctions = LockerEssentialApiFunctions();
final LockerEssentialsWidgetsPage lockerEssentialWidgets = LockerEssentialsWidgetsPage();
final LTICalculatorFunctions longTermFunctions = LTICalculatorFunctions();
final BillBoardCommonFunctions billBoardFunctionsMain = BillBoardCommonFunctions();
final BillBoardApiFunctions billBoardApiMain = BillBoardApiFunctions();
final BillBoardWidgets billboardWidgetsMain = BillBoardWidgets();
final ConversationWidgets conversationWidgetsMain = ConversationWidgets();
final ConversationCommonFunctions conversationFunctionsMain = ConversationCommonFunctions();
final ConversationApiFunctions conversationApiMain = ConversationApiFunctions();
final CommunitiesWidgets communitiesPageWidgets = CommunitiesWidgets();
final CommonCommunityVariables communitiesVariables = CommonCommunityVariables();
final CommunityCreationWidgets communityCreationWidgets = CommunityCreationWidgets();
final BottomSheetPageWidgets bottomSheetPageWidgets = BottomSheetPageWidgets();
final CommunitiesFunctions communitiesFunctions = CommunitiesFunctions();
final PaymentChoosingFunctions paymentChoosingFunctions = PaymentChoosingFunctions();
final CommunitiesPageWidgets communitiesWidgets = CommunitiesPageWidgets();
final MembersPageWidgets membersWidgets = MembersPageWidgets();
final PaymentPageWidgets paymentWidgets = PaymentPageWidgets();
final Dio dioMain = Dio();

FirebaseDynamicLinks firebaseDynamic = FirebaseDynamicLinks.instance;
List<String> mainCatIdList = [];
List<String> finalExchangeIdList = [];
List<String> showSheetNameList = [];
List<String> showSheetImagesList = [];
List<String> showSheetIdList = [];
List<String> showSheetUserIdList = [];
List<String> videoViewsImagesList = [];
List<String> videoViewsIdList = [];
List<String> videoViewsUserIdList = [];
List<String> videoViewsSourceNameList = [];
List<String> kLikesCountNameList = [];
List<String> kLikesCountImagesList = [];
List<String> kLikesCountIdList = [];
List<String> kLikesCountUserIdList = [];
List<String> listVideoIds = [];
List<String> videoIdsMain = [
  'tcodrIK2P_I',
  'H5v3kku4y6Q',
  'nPt8bK2gbaU',
  'K18cpp_-gP8',
  'iLnmTe5Q2Qw',
  '_WoCV4c6XOE',
  'KmzdUe0RSJo',
  '6jZDSSZZxjQ',
  'p2lYr3vM_1w',
  '7QUtEmBT_-w',
  '34_PXCzGw1M'
];

List<int> likeMainCount = [];
List<int> shareMainCount = [];
List<int> viewMainCount = [];
List<int> responseMainCount = [];
List<int> disLikeMainCount = [];

List<bool> watchNotifyAddedBoolListMain = [];
List<bool> isMainLiked = [];
List<String> titlesListMain = [];
List<bool> translationListMain = [];
List<bool> isMainDisliked = [];
List<bool> bookmarkMainList = [];

String finalisedCategory = "";
String finalisedFilterId = "";
String finalisedFilterName = "";
String tickerDetailLogo = "";
String tickerDetailName = "";
String tickerDetailExc = "";
String tickerDetailCategory = "";
String tickerDetailCode = "";
String tickerDetailIndustry = "";
String tickerDetailAddress = "";
String tickerDetailDescription = "";
String tickerDetailWebUrl = "";
String onTapType = "";
String onTapId = "";
String filterAlertTitle = "Looks like you have not created a filter yet, do you want to create on with current selection?";
String kToken = "";
String checkCategory = "";
String idKeyMain = "";
String apiMain = "";
String onTapTypeMain = "";
String onTapIdMain = "";
String fireBasTokenMain = "";
String userIdMain = "";
String appVersion = Platform.isIOS ? "1.1.0" : "7.0.2";

RxString relatedTopicText = "".obs;
RxString relatedOnPage = "".obs;
RxString similarNavigation = "".obs;
RxString onTabListen = "".obs;
RxString avatarMain = "".obs;
RxString currentVideosId = "".obs;

bool mainSkipValue = true;
bool liveStatusActive = false;
bool liveStatusActive11 = false;
bool liveStatusActive12 = false;
bool lockerFilterResponse = true;
bool onLike = false;
bool onDislike = false;
bool onViews = false;
bool loaderMain = false;
bool loaderMainSearch = false;
bool haveLikesMain = false;
bool haveDisLikesMain = false;
bool haveViewsMain = false;
bool forumEntry = true;
bool surveyEntry = true;

RxBool topTrendSwitch = false.obs;
RxBool topTrendSwitchDisable = false.obs;
RxBool extraContainMain = false.obs;

int currentMainIndex = 1;
int skipCountMain = 0;
int likesCountMain = 0;
int dislikesCountMain = 0;
int viewCountMain = 0;
int forNewsLottieCount = 0;
int forVideosLottieCount = 0;
int forForumsLottieCount = 0;
int forFeaturesLottieCount = 0;

RxInt badgeNotifyCount = 0.obs;
RxInt badgeMessageCount = 0.obs;
RxInt idVideoIndex = 0.obs;

double heightMain = 0;
double widthMain = 0;
TextScaler? textScalarMain;

RefreshController loadingRefreshController = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshController1 = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshController2 = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshController3 = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshController4 = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshController5 = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshController6 = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshControllerSendMessageListGeneral = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshControllerSendMessageListBelievers = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController chatMessagesListController = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshControllerBelievedUsersList = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);
RefreshController loadingRefreshControllerShareUsersList = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);

enum Availability { loading, available, unavailable }

TabController? _kTabController;
StreamController<bool> streamController = StreamController<bool>.broadcast();
StreamController<bool> streamController2 = StreamController<bool>.broadcast();
StreamController<bool> streamController3 = StreamController<bool>.broadcast();

final TextEditingController kUserSearchController = TextEditingController();
final InAppReview _inAppReview = InAppReview.instance;

class MainBottomNavigationPage extends StatefulWidget {
  final int caseNo1;
  final int newIndex;
  final int excIndex;
  final int countryIndex;
  final String text;
  final bool isHomeFirstTym;
  final bool fromLink;
  final bool tType;

  const MainBottomNavigationPage({
    Key? key,
    required this.caseNo1,
    required this.text,
    required this.excIndex,
    required this.newIndex,
    required this.countryIndex,
    required this.isHomeFirstTym,
    this.fromLink = false,
    required this.tType,
  }) : super(key: key);

  @override
  MainBottomNavigationPageState createState() => MainBottomNavigationPageState();
}

class MainBottomNavigationPageState extends State<MainBottomNavigationPage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  int newIndex1 = 0;
  int excIndex1 = 0;
  int countryIndex1 = 0;
  String newText = "";
  String categoryValue = "";
  bool newtType = true;
  bool firstTime = false;
  String mainUserId = "";
  String mainUserToken = "";
  List enteredFilteredList = [];
  List enteredFilteredIdList = [];
  bool singleClick = false;
  bool loader = true;
  double bottomValue = 30.00;
  double topValue = -20.00;
  late TabController _tabs;
  bool centerBool = false;

  void _onItemTapped({required int index}) {
    setState(() {
      mainVariables.activeTypeMain.value = "trending";
      mainVariables.isJourney.value = false;
      firstTime = false;
      homeVariables.searchControllerMain.value.clear();
      homeVariables.searchControllerMain.value.text = '';
      selectedIndex = index == 2 ? selectedIndex : index;
      newtType = true;
      newIndex1 = 0;
      excIndex1 = 1;
      countryIndex1 = 0;
      newText = (mainSkipValue ? 'Stocks' : finalisedCategory.capitalizeFirst) ?? "";
    });
  }

  @override
  void initState() {
    selectedIndex = widget.caseNo1;
    _tabs = TabController(length: 5, vsync: this, initialIndex: selectedIndex);
    newtType = widget.tType;
    newIndex1 = widget.newIndex;
    excIndex1 = widget.excIndex;
    countryIndex1 = widget.countryIndex;
    firstTime = widget.isHomeFirstTym;
    newText = /*widget.text == "" ? "Stocks" : */ widget.text;
    getValues();
    super.initState();
  }

  setData() async {
    setState(() {
      singleClick = false;
      bottomValue = 30.00;
      topValue = -20.00;
      loader = true;
      centerBool = false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedIndex == 0
          ? HomeScreen(
              isHomeFirstTime: firstTime,
              tType: newtType,
              countryIndex: countryIndex1,
              excIndex: excIndex1,
              newIndex: newIndex1,
            )
          : selectedIndex == 1
              ? LockerPage(
                  text: newText,
                  fromLink: widget.fromLink,
                  chartsBool: false,
                )
              : selectedIndex == 2
                  ? const BillBoardHome() /*Obx(() =>
                        gettingPageRoute(pageName: billBoardPageName.value))*/
                  : selectedIndex == 3
                      ? WatchList(
                          excIndex: excIndex1,
                          newIndex: newIndex1,
                          countryIndex: countryIndex1,
                        )
                      : selectedIndex == 4
                          ? LockerChartPage(
                              text: newText,
                              fromLink: widget.fromLink,
                              chartsBool: true,
                            )
                          : Container(),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ConvexAppBar(
            controller: _tabs,
            height: 60,
            elevation: 2.0,
            style: TabStyle.fixedCircle,
            backgroundColor: Theme.of(context).colorScheme.background,
            top: -30,
            curveSize: 90,
            cornerRadius: 20,
            items: [
              TabItem(
                icon: isDarkTheme.value
                    ? Image.asset(selectedIndex == 0 ? "assets/bottom_screen/home_selected_dark.png" : "assets/bottom_screen/home_dark.png")
                    : SvgPicture.asset(selectedIndex != 0 ? "assets/bottom_screen/home_grey.svg" : "assets/bottom_screen/home.svg"),
                title: Text(
                  'Home',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: selectedIndex != 0
                          ? isDarkTheme.value
                              ? Theme.of(context).colorScheme.onTertiary
                              : Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
              ),
              TabItem(
                icon: isDarkTheme.value
                    ? Image.asset(selectedIndex == 1 ? "assets/bottom_screen/locker_selected_dark.png" : "assets/bottom_screen/locker_dark.png")
                    : Image.asset(selectedIndex != 1 ? "assets/bottom_screen/locker_grey.png" : "assets/bottom_screen/locker.png"),
                title: Text(
                  'Locker',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: selectedIndex != 1
                          ? isDarkTheme.value
                              ? Theme.of(context).colorScheme.onTertiary
                              : Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
              ),
              const TabItem(
                icon: SizedBox(),
                title: Text(
                  '',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TabItem(
                icon: isDarkTheme.value
                    ? selectedIndex == 3
                        ? SvgPicture.asset("assets/bottom_screen/watch_list_selected_dark.svg")
                        : Image.asset("assets/bottom_screen/watch_list_dark.png")
                    : SvgPicture.asset(selectedIndex != 3 ? "assets/bottom_screen/watchlist_grey.svg" : "assets/bottom_screen/watchlist.svg"),
                title: Text(
                  'WatchList',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: selectedIndex != 3
                          ? isDarkTheme.value
                              ? Theme.of(context).colorScheme.onTertiary
                              : Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
              ),
              TabItem(
                icon: isDarkTheme.value
                    ? Image.asset(selectedIndex == 4 ? "assets/bottom_screen/charts_selected_dark.png" : "assets/bottom_screen/charts_dark.png")
                    : SvgPicture.asset(selectedIndex != 4 ? "assets/bottom_screen/charts_grey.svg" : "assets/bottom_screen/charts.svg"),
                title: Text(
                  'Charts',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: selectedIndex != 4
                          ? isDarkTheme.value
                              ? Theme.of(context).colorScheme.onTertiary
                              : Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
              _onItemTapped(index: selectedIndex);
            },
          ),
          Positioned(
            top: -25,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: topValue,
            bottom: bottomValue,
            child: GestureDetector(
              onPanStart: (details) {
                if (singleClick == false) {
                  setState(() {
                    selectedIndex = 2;
                  });
                  bottomValue = 130;
                  topValue = -120;
                  singleClick = true;
                  centerBool = true;
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 500), () async {
                    setState(() {});
                    setState(() {
                      singleClick = false;
                      bottomValue = 30.00;
                      topValue = -20.00;
                      centerBool = false;
                    });
                    setState(() {});
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: centerBool
                        ? const Color(0XFF0EA102)
                        : isDarkTheme.value
                            ? Colors.white.withOpacity(0.2)
                            : Theme.of(context).colorScheme.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: isDarkTheme.value ? Colors.transparent : Colors.grey.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: centerBool
                      ? Image.asset("assets/bottom_screen/dragging.png")
                      : Image.asset(
                          selectedIndex != 2 ? "assets/bottom_screen/non_filled_pp_button.png" : "assets/bottom_screen/filled_pp_button.png"),
                ),
              ),
            ),
          ),
        ],
      )
      /*Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ConvexAppBar(
            controller: _tabs,
            height: 60,
            elevation: 2.0,
            style: TabStyle.fixedCircle,
            backgroundColor: Colors.white,
            top: -30,
            curveSize: 90,
            cornerRadius: 20,
            items: [
              TabItem(
                icon: SvgPicture.asset(
                    selectedIndex != 0 ? "lib/Constants/Assets/Footer_icons/Home_grey.svg" : "lib/Constants/Assets/Footer_icons/Home.svg"),
                title: Text(
                  'Home',
                  style: TextStyle(color: selectedIndex != 0 ? Colors.grey : const Color(0XFF0EA102), fontSize: 12),
                ),
              ),
              TabItem(
                icon: Image.asset(
                    selectedIndex != 1 ? "lib/Constants/Assets/Footer_icons/Locker_grey.png" : "lib/Constants/Assets/Footer_icons/Locker.png"),
                title: Text(
                  'Locker',
                  style: TextStyle(color: selectedIndex != 1 ? Colors.grey : const Color(0XFF0EA102), fontSize: 12),
                ),
              ),
              const TabItem(
                icon:
                    SizedBox() */
      /*Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey,width: 5)
                  ),
                )*/
      /*
                ,
                title: Text(
                  '',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TabItem(
                icon: SvgPicture.asset(
                    selectedIndex != 3 ? "lib/Constants/Assets/Footer_icons/Watchlist_grey.svg" : "lib/Constants/Assets/Footer_icons/Watchlist.svg"),
                title: Text(
                  'WatchList',
                  style: TextStyle(color: selectedIndex != 3 ? Colors.grey : const Color(0XFF0EA102), fontSize: 12),
                ),
              ),
              TabItem(
                icon: SvgPicture.asset(
                    selectedIndex != 4 ? "lib/Constants/Assets/Footer_icons/Charts_grey.svg" : "lib/Constants/Assets/Footer_icons/Charts.svg"),
                title: Text(
                  'Charts',
                  style: TextStyle(color: selectedIndex != 4 ? Colors.grey : const Color(0XFF0EA102), fontSize: 12),
                ),
              ),
            ],
            onTap: _onItemTapped,
          ),
          Positioned(
            top: -25,
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: topValue,
            bottom: bottomValue,
            child: GestureDetector(
              onPanStart: (details) {
                if (singleClick == false) {
                  selectedIndex = 2;
                  bottomValue = 130;
                  topValue = -120;
                  singleClick = true;
                  loader = false;
                  centerBool = true;
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 500), () async {
                    setState(() {});
                    setData();
                  });
                }
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: centerBool ? const Color(0XFF0EA102) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300)),
                  child: */
      /* loader?*/
      /* Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: centerBool
                        ? Image.asset("lib/Constants/Assets/BillBoard/dragging.png")
                        : Image.asset(selectedIndex != 2
                            ? "lib/Constants/Assets/BillBoard/non_filled_pp_button.png"
                            : "lib/Constants/Assets/BillBoard/filled_pp_button.png"),
                  ) */
      /*: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(strokeWidth: 3,),
                ),*/
      /*
                  ),
            ),
          ),
        ],
      )*/
      ,
    );
  }
}

getValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userIdMain = prefs.getString('newUserId') ?? "";
  kToken = prefs.getString('newUserToken') ?? "";
  forNewsLottieCount = prefs.getInt('forNewsCount') ?? 0;
  forVideosLottieCount = prefs.getInt('forVideosCount') ?? 0;
  forForumsLottieCount = prefs.getInt('forForumsCount') ?? 0;
  forFeaturesLottieCount = prefs.getInt('forFeaturesCount') ?? 0;
  var url = Uri.parse(baseurl + versionHome + categories);
  var response = await http.post(
    url,
    headers: {'Authorization': kToken},
  );
  var responseData = json.decode(response.body);
  if (responseData["status"]) {
    mainCatIdList.clear();
    mainCatIdList = List.generate(4, (index) => '');
    String regAvatar = responseData["avatar"];
    prefs.setString('newUserAvatar', regAvatar);
    avatarMain.value = regAvatar;
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
    for (int i = 0; i < responseData["response"].length; i++) {
      if (responseData["response"][i]['name'] == 'Stocks') {
        mainCatIdList.removeAt(0);
        mainCatIdList.insert(0, responseData["response"][i]['_id']);
      } else if (responseData["response"][i]['name'] == 'Crypto') {
        mainCatIdList.removeAt(1);
        mainCatIdList.insert(1, responseData["response"][i]['_id']);
      } else if (responseData["response"][i]['name'] == 'Commodity') {
        mainCatIdList.removeAt(2);
        mainCatIdList.insert(2, responseData["response"][i]['_id']);
      } else if (responseData["response"][i]['name'] == 'Forex') {
        mainCatIdList.removeAt(3);
        mainCatIdList.insert(3, responseData["response"][i]['_id']);
      } else {}
    }
  } else {
    if (kToken != "") {
      await getLogout(emailNew: userIdMain);
      await resetLogin(authFunctions: authFunctionsMain);
      await resetAllValues();
    } else {}
  }
  await getSelectedNewValue();
  if (finalisedCategory == "") {
    finalisedCategory = prefs.getString('finalisedCategory1') ?? "";
    finalisedFilterId = prefs.getString('finalisedFilterId1') ?? "";
    finalisedFilterName = prefs.getString('finalisedFilterName1') ?? "";
    prefs.remove("finalisedCategory1");
    prefs.remove("finalisedFilterId1");
    prefs.remove("finalisedFilterName1");
  } else {
    finalisedCategory = prefs.getString('finalisedCategory1') ?? "";
    finalisedFilterId = prefs.getString('finalisedFilterId1') ?? "";
    finalisedFilterName = prefs.getString('finalisedFilterName1') ?? "";
  }
}

getEx() async {
  finalExchangeIdList.clear();
  var url = Uri.parse(baseurl + versionLocker + getExchanges);
  var response = await http.post(url);
  var responseData = json.decode(response.body);
  if (responseData["status"]) {
    for (int i = 0; i < responseData["response"].length; i++) {
      finalExchangeIdList.add(responseData["response"][i]["_id"]);
    }
  } else {}
}

getSelectedNewValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mainUserToken = prefs.getString('newUserToken') ?? "";
  if (mainUserToken != "") {
    String categoryValue = "";
    var url = Uri.parse(baseurl + versionLocker + getLocker);
    var response = await http.post(url, headers: {'Authorization': mainUserToken});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      categoryValue = responseData["response"]["locker"];
      if (categoryValue == "stocks") {
        prefs.setString('finalisedCategory1', "Stocks");
      } else if (categoryValue == "crypto") {
        prefs.setString('finalisedCategory1', "Crypto");
      } else if (categoryValue == "commodity") {
        prefs.setString('finalisedCategory1', "Commodity");
      } else if (categoryValue == "forex") {
        prefs.setString('finalisedCategory1', "Forex");
      }
    }
  } else {
    prefs.setString('finalisedCategory1', "Stocks");
  }
}

Future<bool> likeCountFunc({required BuildContext context, required StateSetter newSetState}) async {
  skipCountMain = 0;
  var url = Uri.parse(apiMain);
  Map<String, dynamic> data = {};
  if (onTapTypeMain == "Views") {
    data = {idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
  } else {
    data = {'type': onTapTypeMain, idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
  }
  var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
  var responseData = json.decode(response.body);
  if (responseData["status"]) {
    kLikesCountNameList.clear();
    kLikesCountImagesList.clear();
    kLikesCountIdList.clear();
    kLikesCountUserIdList.clear();
    newSetState(() {
      for (int i = 0; i < responseData["response"].length; i++) {
        if (responseData["response"][i].containsKey("avatar")) {
          kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
        } else {
          kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
        }
        kLikesCountIdList.add(responseData["response"][i]["_id"]);
        if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
          if (onTapTypeMain == "liked" || onTapTypeMain == "disliked") {
            kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
          } else {
            kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
          }
        } else {
          kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
        }
        kLikesCountNameList.add(responseData["response"][i]["username"]);
      }
      if (kLikesCountIdList.isEmpty) {
        newSetState(() {
          haveLikesMain = false;
          haveDisLikesMain = false;
          haveViewsMain = false;
          loaderMain = true;
          loaderMainSearch = true;
        });
      } else {
        newSetState(() {
          haveLikesMain = true;
          haveDisLikesMain = true;
          haveViewsMain = true;
          loaderMain = true;
          loaderMainSearch = true;
        });
      }
    });
  } else {
    newSetState(() {
      haveLikesMain = false;
      haveDisLikesMain = false;
      haveViewsMain = false;
      loaderMain = true;
      loaderMainSearch = true;
    });
  }
  return responseData["status"];
}

Future<bool> viewsCountFunc(
    {required BuildContext context, required String mainToken, required StateSetter setState, required String api, required String idKey}) async {
  bool reBool = false;
  String mainUserToken;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  mainUserToken = prefs.getString("newUserToken")!;
  var url = Uri.parse(api);
  var response =
      await http.post(url, headers: {'Authorization': mainUserToken}, body: {idKey: onTapId, "skip": "0", 'search': kUserSearchController.text});
  var responseData = json.decode(response.body);
  setState(() {
    if (responseData["status"]) {
      showSheetImagesList.clear();
      showSheetIdList.clear();
      showSheetUserIdList.clear();
      showSheetNameList.clear();
      if (responseData["response"].length == 0) {
        setState(() {
          reBool = false;
          haveViewsMain = false;
        });
      }
      for (int i = 0; i < responseData["response"].length; i++) {
        setState(() {
          reBool = true;
          haveViewsMain = true;
        });
        if (responseData["response"][i].containsKey("avatar")) {
          showSheetImagesList.add(responseData["response"][i]["avatar"]);
        } else {
          showSheetImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
        }
        showSheetIdList.add(responseData["response"][i]["_id"]);
        showSheetUserIdList.add(responseData["response"][i]["user_id"]);
        showSheetNameList.add(responseData["response"][i]["username"]);
      }
    } else {
      setState(() {
        reBool = false;
        haveViewsMain = false;
      });
    }
  });
  return reBool;
}

customShowSheet1({required BuildContext context}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  TextScaler text = MediaQuery.of(context).textScaler;
  showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, modelSetState) {
          return SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 500 : 700,
            child: DefaultTabController(
                length: 1,
                initialIndex: 0,
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: height / 50.75,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.arrow_back),
                      )),
                  TabBar(
                    padding: EdgeInsets.zero,
                    isScrollable: false,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: _kTabController,
                    indicatorColor: const Color(0XFF0EA102),
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    dividerHeight: 0.0,
                    tabs: [
                      Tab(
                          icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          onViews
                              ? Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  child: Center(
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: isDarkTheme.value ? const Color(0xffD9D9D9) : Colors.green,
                                    ),
                                  ))
                              : Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: isDarkTheme.value ? const Color(0xffD9D9D9) : Colors.green,
                                  )),
                          Text(
                            viewCountMain.toString(),
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )
                        ],
                      )),
                    ],
                  ),
                  loaderMain
                      ? Expanded(
                          child: TabBarView(
                            controller: _kTabController,
                            physics: const ScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: height / 50.75,
                                  ),
                                  Container(
                                    height: height / 19.33,
                                    margin: EdgeInsets.symmetric(horizontal: width / 25),
                                    child: TextFormField(
                                      cursorColor: Colors.green,
                                      onChanged: (value) async {
                                        await likeCountFunc(context: context, newSetState: modelSetState);
                                      },
                                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                      controller: kUserSearchController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15),
                                        prefixIcon: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
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
                                        hintStyle: TextStyle(
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(14),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins"),
                                        hintText: 'Search here',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 50.75,
                                  ),
                                  haveViewsMain
                                      ? Expanded(
                                          child: SmartRefresher(
                                            controller: loadingRefreshController1,
                                            enablePullDown: false,
                                            enablePullUp: true,
                                            footer: const ClassicFooter(
                                              loadStyle: LoadStyle.ShowWhenLoading,
                                            ),
                                            onLoading: () async {
                                              skipCountMain += 20;
                                              var url = Uri.parse(apiMain);
                                              Map<String, dynamic> data = {};
                                              if (onTapTypeMain == "Views") {
                                                data = {
                                                  idKeyMain: onTapIdMain,
                                                  "skip": skipCountMain.toString(),
                                                  "search": kUserSearchController.text
                                                };
                                              } else {
                                                data = {
                                                  'type': onTapTypeMain,
                                                  idKeyMain: onTapIdMain,
                                                  "skip": skipCountMain.toString(),
                                                  "search": kUserSearchController.text
                                                };
                                              }
                                              var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
                                              var responseData = json.decode(response.body);
                                              if (responseData["status"]) {
                                                for (int i = 0; i < responseData["response"].length; i++) {
                                                  if (responseData["response"][i].containsKey("avatar")) {
                                                    kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
                                                  } else {
                                                    kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
                                                  }
                                                  kLikesCountIdList.add(responseData["response"][i]["_id"]);
                                                  if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
                                                    if (onTapType == "liked" || onTapType == "disliked") {
                                                      kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
                                                    } else {
                                                      kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                                    }
                                                  } else {
                                                    kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                                  }
                                                  kLikesCountNameList.add(responseData["response"][i]["username"]);
                                                }
                                              } else {}
                                              loadingRefreshController.loadComplete();
                                              modelSetState(() {});
                                            },
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: kLikesCountNameList.length,
                                                physics: const ScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ListTile(
                                                          onTap: () async {
                                                            await checkUser(
                                                                uId: kLikesCountUserIdList[index],
                                                                uType: 'forums',
                                                                mainUserToken: kToken,
                                                                context: context,
                                                                index: 0);
                                                          },
                                                          minLeadingWidth: width / 25,
                                                          leading: Container(
                                                              height: 35,
                                                              width: 35,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(kLikesCountImagesList[index]), fit: BoxFit.fill))),
                                                          title: Text(
                                                            kLikesCountNameList[index],
                                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                          ),
                                                          trailing: Container(
                                                              margin: EdgeInsets.only(right: width / 25),
                                                              height: height / 40.6,
                                                              width: width / 18.75,
                                                              child: Icon(
                                                                Icons.remove_red_eye,
                                                                color: isDarkTheme.value ? const Color(0xffD9D9D9) : Colors.green,
                                                              ))),
                                                      const Divider(
                                                        thickness: 0.0,
                                                        height: 0.0,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            const SizedBox(
                                              height: 75,
                                            ),
                                            Text(kUserSearchController.text.isNotEmpty ? "No search results found" : "No Views"),
                                          ],
                                        ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                        )
                ])),
          );
        });
      });
}

customShowSheetNew2({required BuildContext context}) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 500 : 700,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: const StateFullBottomSheet());
      });
}

customShowSheetNew3({required BuildContext context, required String responseCheck}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, modelSetState) {
          return SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 500 : 700,
            child: DefaultTabController(
                length: 2,
                initialIndex: onTapTypeMain == "liked" ? 0 : 1,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: height / 50.75,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.arrow_back),
                      )),
                  TabBar(
                    isScrollable: false,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: _kTabController,
                    indicatorColor: const Color(0XFF0EA102),
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    dividerHeight: 0.0,
                    tabs: [
                      Tab(
                          icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: width / 25),
                              height: height / 40.6,
                              width: width / 18.75,
                              child: SvgPicture.asset(
                                isDarkTheme.value
                                    ? "assets/home_screen/like_filled_dark.svg"
                                    : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                              )),
                          Text(
                            likesCountMain.toString(),
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )
                        ],
                      )),
                      Tab(
                          icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: width / 25),
                              height: height / 40.6,
                              width: width / 18.75,
                              child: SvgPicture.asset(
                                isDarkTheme.value
                                    ? "assets/home_screen/dislike_filled_dark.svg"
                                    : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                              )),
                          Text(
                            dislikesCountMain.toString(),
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )
                        ],
                      )),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _kTabController,
                      physics: const ScrollPhysics(),
                      children: [TwoTabFirstPage(responseCheck: responseCheck), TwoTabSecondPage(responseCheck: responseCheck)],
                    ),
                  )
                ])),
          );
        });
      });
}

filtersAlertDialogue(
    {required BuildContext context,
    required String title,
    required String tickerId,
    required String selectedValue,
    required List<dynamic> cIdList,
    required String pageType}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            //color: Colors.red,
            height: 147,
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                    child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: "Poppins"),
                )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(
                                //color:Color(0xff0EA102),
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 60),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF0EA102),
                            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return ExtraFilterAddingPage(
                                fromCompare: true,
                                text: selectedValue,
                                tickerId: tickerId,
                                fromWhere: pageType,
                              );
                            }));
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      });
}

Future<bool> lockerCheckFiltersFunc() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mainUserToken = prefs.getString('newUserToken') ?? "";
  var url = Uri.parse(baseurl + versionLocker + checkFilters);
  var response = await http.post(url, headers: {'Authorization': mainUserToken});
  var responseData = json.decode(response.body);
  lockerFilterResponse = responseData["response"] ?? false;
  return lockerFilterResponse;
}

mainSkipDialogue({required BuildContext context}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            //color: Colors.red,
            height: 147,
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Center(
                    child: Text(
                  "Please Log in",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: "Poppins"),
                )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF0EA102),
                            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => const SignUpPage(
                                          firstName: "",
                                          lastName: "",
                                          userName: "",
                                          email: "",
                                          socialId: "",
                                          type: "",
                                          phoneCode: "",
                                          phoneNumber: "",
                                          devType: "",
                                          referralCode: "",
                                          socialAvatar: "",
                                          noPass: false,
                                        )));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      });
}

checkUser({required String uId, required String uType, required String mainUserToken, required BuildContext context, required int index}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  mainUserToken = prefs.getString('newUserToken')!;
  var url = Uri.parse(baseurl + versions + profileDetails);
  var response = await http.post(url, headers: {
    'Authorization': mainUserToken
  }, body: {
    'user_id': uId,
    'type': uType,
  });
  var responseData = json.decode(response.body);
  if (responseData["status"]) {
    if (!context.mounted) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return UserBillBoardProfilePage(userId: uId) /*UserProfilePage(id: uId, type: uType, index: index)*/;
    }));
  } else {
    if (!context.mounted) {
      return;
    }
    Flushbar(
      message: responseData["message"],
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}

Future<void> _launchUrl({required String url}) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

detailedShowSheet({required BuildContext context, required bool indusValue}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  TextScaler text = MediaQuery.of(context).textScaler;
  return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 700,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: height / 3.248,
                    width: width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/Constants/Assets/SMLogos/Ornament.png"),
                      ),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      color: Color(0XFF48B83F),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 27.06,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: width / 46.87, vertical: height / 101.5),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Image.asset(
                                    "lib/Constants/Assets/SMLogos/LockerScreen/x-circle.png",
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            height: height / 5.413,
                            width: width / 2.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(tickerDetailLogo),
                                  fit: BoxFit.fill,
                                )),
                          ),
                        )
                      ],
                    )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: width / 1.5,
                              child: Text(
                                tickerDetailName,
                                style: TextStyle(fontSize: text.scale(22), fontWeight: FontWeight.w700),
                              )),
                          Text(
                            tickerDetailCategory,
                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF48B83F)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height / 101.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            tickerDetailCode,
                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                          ),
                          indusValue
                              ? SizedBox(
                                  width: width / 75,
                                )
                              : const SizedBox(),
                          indusValue
                              ? Container(
                                  height: height / 162.4,
                                  width: width / 75,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                )
                              : const SizedBox(),
                          indusValue
                              ? SizedBox(
                                  width: width / 75,
                                )
                              : const SizedBox(),
                          indusValue
                              ? Text(
                                  tickerDetailIndustry,
                                  style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                                )
                              : const SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: height / 101.5,
                      ),
                      Text(
                        tickerDetailAddress == "" ? "Address not available" : tickerDetailAddress,
                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFF48B83F)),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 8, color: const Color(0xffA5A5A5).withOpacity(0.5)),
                SizedBox(
                  height: height / 50.75,
                ),
                Container(
                  width: width,
                  margin: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(fontSize: text.scale(22), fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: height / 50.75),
                      Text(
                        tickerDetailDescription == "" ? "Description not available" : tickerDetailDescription,
                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: height / 50.75),
                    ],
                  ),
                ),
                InkWell(
                  onTap: tickerDetailWebUrl == ""
                      ? () {}
                      : () {
                          _launchUrl(url: tickerDetailWebUrl);
                        },
                  child: Container(
                    height: height / 13.53,
                    margin: EdgeInsets.symmetric(horizontal: width / 25),
                    color: const Color(0XFF48B83F),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
                          child: Image.asset("lib/Constants/Assets/SMLogos/click_net.png"),
                        ),
                        Text(
                          tickerDetailWebUrl == "" ? "Website url not available" : tickerDetailWebUrl,
                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 50.75,
                ),
              ],
            ),
          ),
        );
      });
}

detailTickersFunc({required String category, required String tickerId}) async {
  var url = Uri.parse(baseurl + versionHome + tickerDetail);
  var response = await http.post(url, headers: {}, body: {
    'category': category.toLowerCase(),
    'ticker_id': tickerId,
  });
  var responseData = json.decode(response.body);
  if (responseData["status"]) {
    tickerDetailCode = responseData["response"]["code"];
    tickerDetailName = responseData["response"]["name"];
    if (responseData["response"]["category"] == "stocks") {
      for (int i = 0; i < finalExchangeIdList.length; i++) {
        if (responseData["response"]["exchange_id"] == finalExchangeIdList[i]) {
          i == 0
              ? tickerDetailCategory = "USA Stocks"
              : i == 1
                  ? tickerDetailCategory = "NSE Stocks"
                  : tickerDetailCategory = "BSE Stocks";
        }
      }
    } else if (responseData["response"]["category"] == "crypto") {
      tickerDetailCategory = "Crypto";
    } else if (responseData["response"]["category"] == "commodity") {
      tickerDetailCategory = "Commodity";
    } else if (responseData["response"]["category"] == "forex") {
      tickerDetailCategory = "Forex";
    } else {
      tickerDetailCategory = "";
    }
    tickerDetailLogo = responseData["response"]["logo_url"];
    tickerDetailIndustry = responseData["response"]["industry"];
    //address
    if (responseData["response"].containsKey("full_address")) {
      tickerDetailAddress = responseData["response"]["full_address"];
    } else {
      tickerDetailAddress = "";
    }
    //description
    if (responseData["response"].containsKey("description")) {
      tickerDetailDescription = responseData["response"]["description"];
    } else {
      tickerDetailDescription = "";
    }
    tickerDetailWebUrl = responseData["response"]["web_url"];
  }
}

class TwoTabFirstPage extends StatefulWidget {
  final String responseCheck;

  const TwoTabFirstPage({Key? key, required this.responseCheck}) : super(key: key);

  @override
  State<TwoTabFirstPage> createState() => _TwoTabFirstPageState();
}

class _TwoTabFirstPageState extends State<TwoTabFirstPage> {
  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    getAllData();
    super.initState();
  }

  getAllData() async {
    setState(() {
      loaderMain = false;
      onLike = true;
      onDislike = false;
      onViews = false;
    });
    if (idKeyMain == "response_id") {
      if (widget.responseCheck == 'forum') {
        checkCategory = versionForum;
      } else {
        checkCategory = versionFeature;
      }
    } else if (idKeyMain == 'forum_id') {
      checkCategory = versionForum;
    } else if (idKeyMain == 'feature_id') {
      checkCategory = versionFeature;
    } else {
      checkCategory = versionLocker;
    }

    idKeyMain = idKeyMain == 'forum_id'
        ? "forum_id"
        : idKeyMain == "feature_id"
            ? "feature_id"
            : idKeyMain == "response_id"
                ? "response_id"
                : idKeyMain == "news_id"
                    ? "news_id"
                    : "";

    apiMain = idKeyMain == "response_id"
        ? baseurl + checkCategory + responseLikeDislikeCount
        : apiMain = idKeyMain == "news_id" ? baseurl + checkCategory + newsLikeDislikeCount : baseurl + checkCategory + likeDislikeUsers;
    onTapTypeMain = "liked";
    await likeCountFunc(
      context: context,
      newSetState: setState,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loaderMain
        ? Column(
            children: [
              SizedBox(
                height: height / 50.75,
              ),
              Container(
                height: height / 19.33,
                margin: EdgeInsets.symmetric(horizontal: width / 25),
                child: TextFormField(
                  cursorColor: Colors.green,
                  onChanged: (value) async {
                    setState(() {
                      onLike = true;
                      onDislike = false;
                      onViews = false;
                      if (idKeyMain == "response_id") {
                        if (widget.responseCheck == 'forum') {
                          checkCategory = versionForum;
                        } else {
                          checkCategory = versionFeature;
                        }
                      } else if (idKeyMain == 'forum_id') {
                        checkCategory = versionForum;
                      } else if (idKeyMain == 'feature_id') {
                        checkCategory = versionFeature;
                      } else {
                        checkCategory = versionLocker;
                      }
                      idKeyMain = idKeyMain == 'forum_id'
                          ? "forum_id"
                          : idKeyMain == "feature_id"
                              ? "feature_id"
                              : idKeyMain == "response_id"
                                  ? "response_id"
                                  : idKeyMain == "news_id"
                                      ? "news_id"
                                      : "";
                      apiMain = idKeyMain == "response_id"
                          ? baseurl + checkCategory + responseLikeDislikeCount
                          : apiMain =
                              idKeyMain == "news_id" ? baseurl + checkCategory + newsLikeDislikeCount : baseurl + checkCategory + likeDislikeUsers;
                      onTapTypeMain = "liked";
                    });
                    await likeCountFunc(context: context, newSetState: setState);
                  },
                  style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                  controller: kUserSearchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0), child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
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
                    hintStyle:
                        TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50.75,
              ),
              haveLikesMain
                  ? Expanded(
                      child: SmartRefresher(
                        controller: loadingRefreshController1,
                        enablePullDown: false,
                        enablePullUp: true,
                        footer: const ClassicFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                        ),
                        onLoading: () async {
                          skipCountMain += 20;
                          var url = Uri.parse(apiMain);
                          Map<String, dynamic> data = {};
                          if (onTapType == "Views") {
                            data = {idKeyMain: onTapIdMain, "skip": skipCountMain.toString(), "search": kUserSearchController.text};
                          } else {
                            data = {
                              'type': onTapTypeMain,
                              idKeyMain: onTapIdMain,
                              "skip": skipCountMain.toString(),
                              "search": kUserSearchController.text
                            };
                          }
                          var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
                          var responseData = json.decode(response.body);
                          if (responseData["status"]) {
                            for (int i = 0; i < responseData["response"].length; i++) {
                              if (responseData["response"][i].containsKey("avatar")) {
                                kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
                              } else {
                                kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
                              }
                              kLikesCountIdList.add(responseData["response"][i]["_id"]);
                              if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
                                if (onTapType == "liked" || onTapType == "disliked") {
                                  kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
                                } else {
                                  kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                }
                              } else {
                                kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                              }
                              kLikesCountNameList.add(responseData["response"][i]["username"]);
                            }
                          } else {}
                          loadingRefreshController.loadComplete();
                          setState(() {});
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: kLikesCountNameList.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      onTap: () async {
                                        await checkUser(
                                            uId: kLikesCountUserIdList[index], uType: 'forums', mainUserToken: kToken, context: context, index: 0);
                                      },
                                      minLeadingWidth: width / 25,
                                      leading: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(image: NetworkImage(kLikesCountImagesList[index]), fit: BoxFit.fill))),
                                      title: Text(
                                        kLikesCountNameList[index],
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                      ),
                                      trailing: Container(
                                          margin: EdgeInsets.only(right: width / 25),
                                          height: height / 40.6,
                                          width: width / 18.75,
                                          child: SvgPicture.asset(
                                            isDarkTheme.value
                                                ? "assets/home_screen/like_filled_dark.svg"
                                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                          ))),
                                  const Divider(
                                    thickness: 0.0,
                                    height: 0.0,
                                  ),
                                ],
                              );
                            }),
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 75,
                        ),
                        Text(kUserSearchController.text.isNotEmpty ? "No search results found" : "No Likes"),
                      ],
                    ),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class TwoTabSecondPage extends StatefulWidget {
  final String responseCheck;

  const TwoTabSecondPage({Key? key, required this.responseCheck}) : super(key: key);

  @override
  State<TwoTabSecondPage> createState() => _TwoTabSecondPageState();
}

class _TwoTabSecondPageState extends State<TwoTabSecondPage> {
  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    getAllData();
    super.initState();
  }

  getAllData() async {
    setState(() {
      loaderMain = false;
      onLike = false;
      onDislike = true;
      onViews = false;
    });

    if (idKeyMain == "response_id") {
      if (widget.responseCheck == 'forum') {
        checkCategory = versionForum;
      } else {
        checkCategory = versionFeature;
      }
    } else if (idKeyMain == 'forum_id') {
      checkCategory = versionForum;
    } else if (idKeyMain == 'feature_id') {
      checkCategory = versionFeature;
    } else {
      checkCategory = versionLocker;
    }
    idKeyMain = idKeyMain == 'forum_id'
        ? "forum_id"
        : idKeyMain == "feature_id"
            ? "feature_id"
            : idKeyMain == "response_id"
                ? "response_id"
                : idKeyMain == "news_id"
                    ? "news_id"
                    : "";
    apiMain = idKeyMain == "response_id"
        ? baseurl + checkCategory + responseLikeDislikeCount
        : apiMain = idKeyMain == "news_id" ? baseurl + checkCategory + newsLikeDislikeCount : baseurl + checkCategory + likeDislikeUsers;
    onTapTypeMain = "disliked";
    await likeCountFunc(context: context, newSetState: setState);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loaderMain
        ? Column(
            children: [
              SizedBox(
                height: height / 50.75,
              ),
              Container(
                height: height / 19.33,
                margin: EdgeInsets.symmetric(horizontal: width / 25),
                child: TextFormField(
                  cursorColor: Colors.green,
                  onChanged: (value) async {
                    setState(() {
                      onLike = false;
                      onDislike = true;
                      onViews = false;
                      if (idKeyMain == "response_id") {
                        if (widget.responseCheck == 'forum') {
                          checkCategory = versionForum;
                        } else {
                          checkCategory = versionFeature;
                        }
                      } else if (idKeyMain == 'forum_id') {
                        checkCategory = versionForum;
                      } else if (idKeyMain == 'feature_id') {
                        checkCategory = versionFeature;
                      } else {
                        checkCategory = versionLocker;
                      }
                      idKeyMain = idKeyMain == 'forum_id'
                          ? "forum_id"
                          : idKeyMain == "feature_id"
                              ? "feature_id"
                              : idKeyMain == "response_id"
                                  ? "response_id"
                                  : idKeyMain == "news_id"
                                      ? "news_id"
                                      : "";
                      apiMain = idKeyMain == "response_id"
                          ? baseurl + checkCategory + responseLikeDislikeCount
                          : apiMain =
                              idKeyMain == "news_id" ? baseurl + checkCategory + newsLikeDislikeCount : baseurl + checkCategory + likeDislikeUsers;
                      onTapTypeMain = "disliked";
                    });
                    await likeCountFunc(context: context, newSetState: setState);
                  },
                  style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                  controller: kUserSearchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0), child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
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
                    hintStyle:
                        TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50.75,
              ),
              haveDisLikesMain
                  ? Expanded(
                      child: SmartRefresher(
                        controller: loadingRefreshController2,
                        enablePullDown: false,
                        enablePullUp: true,
                        footer: const ClassicFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                        ),
                        onLoading: () async {
                          skipCountMain += 20;
                          var url = Uri.parse(apiMain);
                          Map<String, dynamic> data = {};
                          if (onTapType == "Views") {
                            data = {idKeyMain: onTapIdMain, "skip": skipCountMain.toString(), "search": kUserSearchController.text};
                          } else {
                            data = {
                              'type': onTapTypeMain,
                              idKeyMain: onTapIdMain,
                              "skip": skipCountMain.toString(),
                              "search": kUserSearchController.text
                            };
                          }
                          var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
                          var responseData = json.decode(response.body);
                          if (responseData["status"]) {
                            for (int i = 0; i < responseData["response"].length; i++) {
                              if (responseData["response"][i].containsKey("avatar")) {
                                kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
                              } else {
                                kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
                              }
                              kLikesCountIdList.add(responseData["response"][i]["_id"]);
                              if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
                                if (onTapType == "liked" || onTapType == "disliked") {
                                  kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
                                } else {
                                  kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                }
                              } else {
                                kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                              }
                              kLikesCountNameList.add(responseData["response"][i]["username"]);
                            }
                          } else {}
                          loadingRefreshController.loadComplete();
                          setState(() {});
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: kLikesCountNameList.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      onTap: () async {
                                        await checkUser(
                                            uId: kLikesCountUserIdList[index], uType: 'forums', mainUserToken: kToken, context: context, index: 0);
                                      },
                                      minLeadingWidth: width / 25,
                                      leading: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(image: NetworkImage(kLikesCountImagesList[index]), fit: BoxFit.fill))),
                                      title: Text(
                                        kLikesCountNameList[index],
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                      ),
                                      trailing: Container(
                                          margin: EdgeInsets.only(right: width / 25),
                                          height: height / 40.6,
                                          width: width / 18.75,
                                          child: SvgPicture.asset(
                                            isDarkTheme.value
                                                ? "assets/home_screen/dislike_filled_dark.svg"
                                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                          ))),
                                  const Divider(
                                    thickness: 0.0,
                                    height: 0.0,
                                  ),
                                ],
                              );
                            }),
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 75,
                        ),
                        Text(kUserSearchController.text.isNotEmpty ? "No search results found" : "No DisLikes"),
                      ],
                    ),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class ThreeTabFirstPage extends StatefulWidget {
  const ThreeTabFirstPage({Key? key}) : super(key: key);

  @override
  State<ThreeTabFirstPage> createState() => _ThreeTabFirstPageState();
}

class _ThreeTabFirstPageState extends State<ThreeTabFirstPage> {
  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    likeCountFunc1();
    super.initState();
  }

  Future<bool> likeCountFunc1() async {
    setState(() {
      loaderMain = false;
      onLike = false;
      onDislike = false;
      onViews = true;
    });
    onLike = false;
    onDislike = false;
    onViews = true;
    String newsOne = "news/";
    checkCategory = idKeyMain == 'forum_id'
        ? versionForum
        : idKeyMain == 'news_id'
            ? versionLocker
            : versionFeature;
    idKeyMain = idKeyMain == 'forum_id'
        ? "forum_id"
        : idKeyMain == 'news_id'
            ? 'news_id'
            : "feature_id";
    apiMain = idKeyMain == 'news_id' ? baseurl + checkCategory + newsOne + viewsCount : baseurl + checkCategory + viewsCount;
    onTapTypeMain = "Views";
    var url = Uri.parse(apiMain);
    Map<String, dynamic> data = {};
    if (onTapTypeMain == "Views") {
      data = {idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
    } else {
      data = {'type': onTapTypeMain, idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
    }
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      kLikesCountNameList.clear();
      kLikesCountImagesList.clear();
      kLikesCountIdList.clear();
      kLikesCountUserIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            if (responseData["response"][i].containsKey("avatar")) {
              kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
            } else {
              kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
            kLikesCountIdList.add(responseData["response"][i]["_id"]);
            if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
              if (onTapTypeMain == "liked" || onTapTypeMain == "disliked") {
                kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
              } else {
                kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
              }
            } else {
              kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
            }
            kLikesCountNameList.add(responseData["response"][i]["username"]);
          }
          if (kLikesCountIdList.isEmpty) {
            if (mounted) {
              setState(() {
                haveLikesMain = false;
                haveDisLikesMain = false;
                haveViewsMain = false;
                loaderMain = true;
                loaderMainSearch = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                haveLikesMain = true;
                haveDisLikesMain = true;
                haveViewsMain = true;
                loaderMain = true;
                loaderMainSearch = true;
              });
            }
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          haveLikesMain = false;
          haveDisLikesMain = false;
          haveViewsMain = false;
          loaderMain = true;
          loaderMainSearch = true;
        });
      }
    }
    return responseData["status"];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loaderMain
        ? Column(
            children: [
              SizedBox(
                height: height / 50.75,
              ),
              Container(
                height: height / 19.33,
                margin: EdgeInsets.symmetric(horizontal: width / 25),
                child: TextFormField(
                  cursorColor: Colors.green,
                  onChanged: (value) async {
                    if (mounted) {
                      setState(() {
                        loaderMainSearch = false;
                      });
                    }
                    await likeCountFunc1();
                  },
                  style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                  controller: kUserSearchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0), child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
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
                    hintStyle:
                        TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50.75,
              ),
              loaderMainSearch
                  ? haveViewsMain
                      ? Expanded(
                          child: SmartRefresher(
                            controller: loadingRefreshController3,
                            enablePullDown: false,
                            enablePullUp: true,
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                            ),
                            onLoading: () async {
                              skipCountMain += 20;
                              var url = Uri.parse(apiMain);
                              Map<String, dynamic> data = {};
                              if (onTapType == "Views") {
                                data = {idKeyMain: onTapIdMain, "skip": skipCountMain.toString(), "search": kUserSearchController.text};
                              } else {
                                data = {
                                  'type': onTapTypeMain,
                                  idKeyMain: onTapIdMain,
                                  "skip": skipCountMain.toString(),
                                  "search": kUserSearchController.text
                                };
                              }
                              var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
                              var responseData = json.decode(response.body);
                              if (responseData["status"]) {
                                for (int i = 0; i < responseData["response"].length; i++) {
                                  if (responseData["response"][i].containsKey("avatar")) {
                                    kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
                                  } else {
                                    kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
                                  }
                                  kLikesCountIdList.add(responseData["response"][i]["_id"]);
                                  if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
                                    if (onTapType == "liked" || onTapType == "disliked") {
                                      kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
                                    } else {
                                      kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                    }
                                  } else {
                                    kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                  }
                                  kLikesCountNameList.add(responseData["response"][i]["username"]);
                                }
                              } else {}
                              loadingRefreshController3.loadComplete();
                              setState(() {});
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: kLikesCountNameList.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                          onTap: () async {
                                            await checkUser(
                                                uId: kLikesCountUserIdList[index],
                                                uType: 'forums',
                                                mainUserToken: kToken,
                                                context: context,
                                                index: 0);
                                          },
                                          minLeadingWidth: width / 25,
                                          leading: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(image: NetworkImage(kLikesCountImagesList[index]), fit: BoxFit.fill))),
                                          title: Text(
                                            kLikesCountNameList[index],
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                          ),
                                          trailing: Container(
                                              margin: EdgeInsets.only(right: width / 25),
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: Icon(
                                                Icons.remove_red_eye,
                                                color: isDarkTheme.value ? const Color(0xffD9D9D9) : Colors.green,
                                              ))),
                                      const Divider(
                                        thickness: 0.0,
                                        height: 0.0,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 75,
                            ),
                            Text(kUserSearchController.text.isNotEmpty ? "No search results found" : "No Views"),
                          ],
                        )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class ThreeTabSecondPage extends StatefulWidget {
  const ThreeTabSecondPage({Key? key}) : super(key: key);

  @override
  State<ThreeTabSecondPage> createState() => _ThreeTabSecondPageState();
}

class _ThreeTabSecondPageState extends State<ThreeTabSecondPage> {
  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    likeCountFunc2();
    super.initState();
  }

  Future<bool> likeCountFunc2() async {
    setState(() {
      loaderMain = false;
      onLike = true;
      onDislike = false;
      onViews = false;
    });
    // checkCategory = idKeyMain == 'forum_id' ? versionForum : versionFeature;
    if (idKeyMain == 'forum_id') {
      checkCategory = versionForum;
    } else if (idKeyMain == 'feature_id') {
      checkCategory = versionFeature;
    } else {
      checkCategory = versionLocker;
    }
    //idKeyMain = idKeyMain == 'forum_id' ? "forum_id" : "feature_id";
    idKeyMain = idKeyMain == 'forum_id'
        ? "forum_id"
        : idKeyMain == "feature_id"
            ? "feature_id"
            : idKeyMain == "news_id"
                ? "news_id"
                : "";
    // apiMain = baseurl + checkCategory + likeDislikeUsers;
    /* apiMain = idKeyMain == "response_id"
        ? baseurl + checkCategory + responseLikeDislikeCount
        :*/
    apiMain = idKeyMain == "news_id" ? baseurl + checkCategory + newsLikeDislikeCount : baseurl + checkCategory + likeDislikeUsers;
    onTapTypeMain = "liked";
    var url = Uri.parse(apiMain);
    Map<String, dynamic> data = {};
    if (onTapTypeMain == "Views") {
      data = {idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
    } else {
      data = {'type': onTapTypeMain, idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
    }
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      kLikesCountNameList.clear();
      kLikesCountImagesList.clear();
      kLikesCountIdList.clear();
      kLikesCountUserIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            if (responseData["response"][i].containsKey("avatar")) {
              kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
            } else {
              kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
            kLikesCountIdList.add(responseData["response"][i]["_id"]);
            if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
              if (onTapTypeMain == "liked" || onTapTypeMain == "disliked") {
                kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
              } else {
                kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
              }
            } else {
              kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
            }
            kLikesCountNameList.add(responseData["response"][i]["username"]);
          }
          if (kLikesCountIdList.isEmpty) {
            if (mounted) {
              setState(() {
                haveLikesMain = false;
                haveDisLikesMain = false;
                haveViewsMain = false;
                loaderMain = true;
                loaderMainSearch = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                haveLikesMain = true;
                haveDisLikesMain = true;
                haveViewsMain = true;
                loaderMain = true;
                loaderMainSearch = true;
              });
            }
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          haveLikesMain = false;
          haveDisLikesMain = false;
          haveViewsMain = false;
          loaderMain = true;
          loaderMainSearch = true;
        });
      }
    }
    return responseData["status"];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loaderMain
        ? Column(
            children: [
              SizedBox(
                height: height / 50.75,
              ),
              Container(
                height: height / 19.33,
                margin: EdgeInsets.symmetric(horizontal: width / 25),
                child: TextFormField(
                  cursorColor: Colors.green,
                  onChanged: (value) async {
                    if (mounted) {
                      setState(() {
                        loaderMainSearch = false;
                      });
                    }
                    await likeCountFunc2();
                  },
                  style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                  controller: kUserSearchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0), child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
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
                    hintStyle:
                        TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50.75,
              ),
              loaderMainSearch
                  ? haveLikesMain
                      ? Expanded(
                          child: SmartRefresher(
                            controller: loadingRefreshController4,
                            enablePullDown: false,
                            enablePullUp: true,
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                            ),
                            onLoading: () async {
                              skipCountMain += 20;
                              var url = Uri.parse(apiMain);
                              Map<String, dynamic> data = {};
                              if (onTapType == "Views") {
                                data = {idKeyMain: onTapIdMain, "skip": skipCountMain.toString(), "search": kUserSearchController.text};
                              } else {
                                data = {
                                  'type': onTapTypeMain,
                                  idKeyMain: onTapIdMain,
                                  "skip": skipCountMain.toString(),
                                  "search": kUserSearchController.text
                                };
                              }
                              var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
                              var responseData = json.decode(response.body);
                              if (responseData["status"]) {
                                for (int i = 0; i < responseData["response"].length; i++) {
                                  if (responseData["response"][i].containsKey("avatar")) {
                                    kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
                                  } else {
                                    kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
                                  }
                                  kLikesCountIdList.add(responseData["response"][i]["_id"]);
                                  if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
                                    if (onTapType == "liked" || onTapType == "disliked") {
                                      kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
                                    } else {
                                      kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                    }
                                  } else {
                                    kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                  }
                                  kLikesCountNameList.add(responseData["response"][i]["username"]);
                                }
                              } else {}
                              loadingRefreshController4.loadComplete();
                              setState(() {});
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: kLikesCountNameList.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                          onTap: () async {
                                            await checkUser(
                                                uId: kLikesCountUserIdList[index],
                                                uType: 'forums',
                                                mainUserToken: kToken,
                                                context: context,
                                                index: 0);
                                          },
                                          minLeadingWidth: width / 25,
                                          leading: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(image: NetworkImage(kLikesCountImagesList[index]), fit: BoxFit.fill))),
                                          title: Text(
                                            kLikesCountNameList[index],
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                          ),
                                          trailing: Container(
                                              margin: EdgeInsets.only(right: width / 25),
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: SvgPicture.asset(
                                                isDarkTheme.value
                                                    ? "assets/home_screen/like_filled_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                              ))),
                                      const Divider(
                                        thickness: 0.0,
                                        height: 0.0,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 75,
                            ),
                            Text(kUserSearchController.text.isNotEmpty ? "No search results found" : "No Likes"),
                          ],
                        )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class ThreeTabThirdPage extends StatefulWidget {
  const ThreeTabThirdPage({Key? key}) : super(key: key);

  @override
  State<ThreeTabThirdPage> createState() => _ThreeTabThirdPageState();
}

class _ThreeTabThirdPageState extends State<ThreeTabThirdPage> {
  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    likeCountFunc3();
    super.initState();
  }

  Future<bool> likeCountFunc3() async {
    setState(() {
      loaderMain = false;
      onLike = false;
      onDislike = true;
      onViews = false;
    });
    //checkCategory = idKeyMain == 'forum_id' ? versionForum : versionFeature;
    if (idKeyMain == 'forum_id') {
      checkCategory = versionForum;
    } else if (idKeyMain == 'feature_id') {
      checkCategory = versionFeature;
    } else {
      checkCategory = versionLocker;
    }
    //idKeyMain = idKeyMain == 'forum_id' ? "forum_id" : "feature_id";
    idKeyMain = idKeyMain == 'forum_id'
        ? "forum_id"
        : idKeyMain == "feature_id"
            ? "feature_id"
            : idKeyMain == "news_id"
                ? "news_id"
                : "";
    //apiMain = baseurl + checkCategory + likeDislikeUsers;
    apiMain = idKeyMain == "news_id" ? baseurl + checkCategory + newsLikeDislikeCount : baseurl + checkCategory + likeDislikeUsers;
    onTapTypeMain = "disliked";
    var url = Uri.parse(apiMain);
    Map<String, dynamic> data = {};
    if (onTapTypeMain == "Views") {
      data = {idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
    } else {
      data = {'type': onTapTypeMain, idKeyMain: onTapIdMain, "skip": "0", "search": kUserSearchController.text};
    }
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      kLikesCountNameList.clear();
      kLikesCountImagesList.clear();
      kLikesCountIdList.clear();
      kLikesCountUserIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            if (responseData["response"][i].containsKey("avatar")) {
              kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
            } else {
              kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
            kLikesCountIdList.add(responseData["response"][i]["_id"]);
            if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
              if (onTapTypeMain == "liked" || onTapTypeMain == "disliked") {
                kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
              } else {
                kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
              }
            } else {
              kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
            }
            kLikesCountNameList.add(responseData["response"][i]["username"]);
          }
          if (kLikesCountIdList.isEmpty) {
            if (mounted) {
              setState(() {
                haveLikesMain = false;
                haveDisLikesMain = false;
                haveViewsMain = false;
                loaderMain = true;
                loaderMainSearch = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                haveLikesMain = true;
                haveDisLikesMain = true;
                haveViewsMain = true;
                loaderMain = true;
                loaderMainSearch = true;
              });
            }
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          haveLikesMain = false;
          haveDisLikesMain = false;
          haveViewsMain = false;
          loaderMain = true;
          loaderMainSearch = true;
        });
      }
    }
    return responseData["status"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loaderMain
        ? Column(
            children: [
              SizedBox(
                height: height / 50.75,
              ),
              Container(
                height: height / 19.33,
                margin: EdgeInsets.symmetric(horizontal: width / 25),
                child: TextFormField(
                  cursorColor: Colors.green,
                  onChanged: (value) async {
                    if (mounted) {
                      setState(() {
                        loaderMainSearch = false;
                      });
                    }
                    await likeCountFunc3();
                  },
                  style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                  controller: kUserSearchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0), child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
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
                    hintStyle:
                        TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50.75,
              ),
              loaderMainSearch
                  ? haveDisLikesMain
                      ? Expanded(
                          child: SmartRefresher(
                            controller: loadingRefreshController5,
                            enablePullDown: false,
                            enablePullUp: true,
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                            ),
                            onLoading: () async {
                              skipCountMain += 20;
                              var url = Uri.parse(apiMain);
                              Map<String, dynamic> data = {};
                              if (onTapType == "Views") {
                                data = {idKeyMain: onTapIdMain, "skip": skipCountMain.toString(), "search": kUserSearchController.text};
                              } else {
                                data = {
                                  'type': onTapTypeMain,
                                  idKeyMain: onTapIdMain,
                                  "skip": skipCountMain.toString(),
                                  "search": kUserSearchController.text
                                };
                              }
                              var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
                              var responseData = json.decode(response.body);
                              if (responseData["status"]) {
                                for (int i = 0; i < responseData["response"].length; i++) {
                                  if (responseData["response"][i].containsKey("avatar")) {
                                    kLikesCountImagesList.add(responseData["response"][i]["avatar"]);
                                  } else {
                                    kLikesCountImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
                                  }
                                  kLikesCountIdList.add(responseData["response"][i]["_id"]);
                                  if (idKeyMain == "forum_id" || idKeyMain == "feature_id" || idKeyMain == "response_id") {
                                    if (onTapType == "liked" || onTapType == "disliked") {
                                      kLikesCountUserIdList.add(responseData["response"][i]["_id"]);
                                    } else {
                                      kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                    }
                                  } else {
                                    kLikesCountUserIdList.add(responseData["response"][i]["user_id"]);
                                  }
                                  kLikesCountNameList.add(responseData["response"][i]["username"]);
                                }
                              } else {}
                              loadingRefreshController5.loadComplete();
                              setState(() {});
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: kLikesCountNameList.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                          onTap: () async {
                                            await checkUser(
                                                uId: kLikesCountUserIdList[index],
                                                uType: 'forums',
                                                mainUserToken: kToken,
                                                context: context,
                                                index: 0);
                                          },
                                          minLeadingWidth: width / 25,
                                          leading: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(image: NetworkImage(kLikesCountImagesList[index]), fit: BoxFit.fill))),
                                          title: Text(
                                            kLikesCountNameList[index],
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                          ),
                                          trailing: Container(
                                              margin: EdgeInsets.only(right: width / 25),
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: SvgPicture.asset(
                                                isDarkTheme.value
                                                    ? "assets/home_screen/dislike_filled_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                              ))),
                                      const Divider(
                                        thickness: 0.0,
                                        height: 0.0,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 75,
                            ),
                            Text(kUserSearchController.text.isNotEmpty ? "No search results found" : "No Dislikes"),
                          ],
                        )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
            ],
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

class StateFullBottomSheet extends StatefulWidget {
  const StateFullBottomSheet({Key? key}) : super(key: key);

  @override
  State<StateFullBottomSheet> createState() => _StateFullBottomSheetState();
}

class _StateFullBottomSheetState extends State<StateFullBottomSheet> with TickerProviderStateMixin {
  late TabController _kTabControllerMain;

  @override
  void initState() {
    _kTabControllerMain = TabController(
        length: 3,
        vsync: this,
        initialIndex: onTapTypeMain == "liked"
            ? 1
            : onTapTypeMain == "disliked"
                ? 2
                : 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height / 50.75,
        ),
        InkWell(
            onTap: () {
              if (!mounted) {
                return;
              }
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.arrow_back),
            )),
        TabBar(
          isScrollable: false,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
          indicatorColor: const Color(0XFF0EA102),
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _kTabControllerMain,
          dividerColor: Colors.transparent,
          dividerHeight: 0.0,
          tabs: [
            Tab(
                icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(right: width / 25),
                    child: Center(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: isDarkTheme.value ? const Color(0xffD9D9D9) : Colors.green,
                      ),
                    )),
                Text(
                  viewCountMain.toString(),
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )
              ],
            )),
            Tab(
                icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(right: width / 25),
                    height: height / 40.6,
                    width: width / 18.75,
                    child: SvgPicture.asset(
                      isDarkTheme.value ? "assets/home_screen/like_filled_dark.svg" : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                    )),
                Text(
                  likesCountMain.toString(),
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )
              ],
            )),
            Tab(
                icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(right: width / 25),
                    height: height / 40.6,
                    width: width / 18.75,
                    child: SvgPicture.asset(
                      isDarkTheme.value
                          ? "assets/home_screen/dislike_filled_dark.svg"
                          : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                    )),
                Text(
                  dislikesCountMain.toString(),
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )
              ],
            )),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _kTabControllerMain,
            physics: const ScrollPhysics(),
            children: const [
              ThreeTabFirstPage(),
              ThreeTabSecondPage(),
              ThreeTabThirdPage(),
            ],
          ),
        ),
      ],
    );
  }
}

Future<dynamic> notifyBottomSheetMain1({
  required BuildContext context,
  required int currentIndex,
  required String tickerId,
  required String tickerName,
  required bool editValue,
  required String closeValue,
}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return AddNotificationMain(
          tickerName: tickerName,
          tickerId: tickerId,
          currentIndex: currentIndex,
          editValue: editValue,
          closeValue: closeValue,
        );
      });
}

class AddNotificationMain extends StatefulWidget {
  final String tickerId;
  final String tickerName;
  final int currentIndex;
  final bool editValue;
  final String closeValue;

  const AddNotificationMain({
    Key? key,
    required this.currentIndex,
    required this.tickerId,
    required this.tickerName,
    required this.editValue,
    required this.closeValue,
  }) : super(key: key);

  @override
  State<AddNotificationMain> createState() => _AddNotificationMainState();
}

class _AddNotificationMainState extends State<AddNotificationMain> {
  List<TextEditingController> minControllerMainList = List.generate(1, (i) => TextEditingController());
  List<TextEditingController> maxControllerMainList = List.generate(1, (i) => TextEditingController());
  List<TextEditingController> notesControllerMainList = List.generate(1, (i) => TextEditingController());
  List<bool> savePressedList = List.generate(1, (i) => false);
  List<bool> fieldEmptyList = List.generate(1, (i) => false);
  List<String> notificationMainList = List.generate(1, (i) => "");
  bool loading1 = false;
  int newIndex = 0;
  int excIndex = 0;
  List<int> finalMaxPercent = List.generate(1, (index) => 0);
  List<List<int>> minSuggestionList = List.generate(1, (index) => [-10, -5, 0, 5, 10]);
  List<bool> minSuggestionBoolList = List.generate(1, (index) => false);
  List<bool> maxDisableList = List.generate(1, (index) => true);
  List<List<int>> maxSuggestionList = List.generate(1, (index) => [0, 0, 0, 0, 0]);
  List<bool> maxSuggestionBoolList = List.generate(1, (index) => false);

  addNotifyListMain1({
    required BuildContext context,
    required String tickerId,
    required String notificationId,
    required String minValue,
    required String maxvalue,
    required String notes,
  }) async {
    Map<String, dynamic> data = {};
    var url = baseurl + versionWatch + watchListAddNotify;
    if (newIndex == 0) {
      data = notificationId == ""
          ? {
              "category_id": mainCatIdList[newIndex],
              "exchange_id": mainCatIdList[excIndex],
              "ticker_id": tickerId,
              "min_value": minValue,
              "max_value": maxvalue,
              "notes": notes
            }
          : {
              "category_id": mainCatIdList[newIndex],
              "exchange_id": mainCatIdList[excIndex],
              'notification_id': notificationId,
              "ticker_id": tickerId,
              "min_value": minValue,
              "max_value": maxvalue,
              "notes": notes
            };
    } else {
      data = notificationId == ""
          ? {"category_id": mainCatIdList[newIndex], "ticker_id": tickerId, "min_value": minValue, "max_value": maxvalue, "notes": notes}
          : {
              "category_id": mainCatIdList[newIndex],
              'notification_id': notificationId,
              "ticker_id": tickerId,
              "min_value": minValue,
              "max_value": maxvalue,
              "notes": notes
            };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchVariables.alertCountCountTotalMain.value = responseData["watchlist_alert_count"] ?? watchVariables.alertCountCountTotalMain.value;
      if (watchVariables.alertCountCountTotalMain.value % 5 == 0) {
        functionsMain.createInterstitialAd(modelSetState: setState);
      }
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: "Price alert notification set",
        duration: const Duration(seconds: 2),
      ).show(context);
      return responseData;
    } else {
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      return responseData;
    }
  }

  removeNotifyListMain1({
    required BuildContext context,
    required String notifyId,
    required String tickerId,
  }) async {
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: "Price alert notification removed",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    switch (currentMainIndex) {
      case 0:
        newIndex = 0;
        excIndex = 0;
        break;
      case 1:
        newIndex = 0;
        excIndex = 1;
        break;
      case 2:
        newIndex = 0;
        excIndex = 2;
        break;
      case 3:
        newIndex = 1;
        excIndex = 1;
        break;
      case 4:
        newIndex = 2;
        excIndex = 1;
        break;
      case 5:
        newIndex = 2;
        excIndex = 1;
        break;
      case 6:
        newIndex = 3;
        excIndex = 1;
        break;
    }
    widget.editValue ? await editFunc() : debugPrint("nothing");
    setState(() {
      loading1 = true;
    });
  }

  editFunc() async {
    var url = baseurl + versionWatch + watchNotificationList;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: {'ticker_id': widget.tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      minControllerMainList.clear();
      maxControllerMainList.clear();
      savePressedList.clear();
      fieldEmptyList.clear();
      notificationMainList.clear();
      notesControllerMainList.clear();
      minSuggestionBoolList.clear();
      minSuggestionList.clear();
      maxDisableList.clear();
      minControllerMainList = List.generate(responseData["response"].length, (i) => TextEditingController());
      maxControllerMainList = List.generate(responseData["response"].length, (i) => TextEditingController());
      notesControllerMainList = List.generate(responseData["response"].length, (i) => TextEditingController());
      savePressedList = List.generate(responseData["response"].length, (i) => true);
      fieldEmptyList = List.generate(responseData["response"].length, (i) => false);
      notificationMainList = List.generate(responseData["response"].length, (i) => "");
      minSuggestionBoolList = List.generate(responseData["response"].length, (i) => false);
      minSuggestionList = List.generate(responseData["response"].length, (i) => [-10, -5, 0, 5, 10]);
      maxDisableList = List.generate(responseData["response"].length, (i) => false);
      maxSuggestionBoolList = List.generate(responseData["response"].length, (i) => false);
      finalMaxPercent = List.generate(responseData["response"].length, (i) => 0);
      maxSuggestionList = List.generate(responseData["response"].length, (i) => [0, 0, 0, 0, 0]);

      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          notificationMainList[i] = responseData["response"][i]['_id'];
          minControllerMainList[i].text = (responseData["response"][i]['min_value']).toString();
          maxControllerMainList[i].text = (responseData["response"][i]['max_value']).toString();
          if (responseData['response'][i].containsKey("notes")) {
            notesControllerMainList[i].text = (responseData["response"][i]['notes']).toString();
          } else {
            notesControllerMainList[i].text = "";
          }
          double value1 = double.parse(minControllerMainList[i].text);
          double value2 = double.parse(widget.closeValue);
          double finalValue = 0.0;
          finalValue = value1 - value2;
          finalMaxPercent[i] = ((finalValue * 100) / (value2 == 0.0 ? 1.0 : value2)).round();
          maxSuggestionList[i] = [
            finalMaxPercent[i] + 5,
            finalMaxPercent[i] + 10,
            finalMaxPercent[i] + 15,
            finalMaxPercent[i] + 20,
            finalMaxPercent[i] + 25
          ];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loading1
        ? SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height / 54.13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                          setState(() {
                            savePressedList.contains(true)
                                ? watchNotifyAddedBoolListMain[widget.currentIndex] = true
                                : watchNotifyAddedBoolListMain[widget.currentIndex] = false;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      "Turn On Notification",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        'You will be notified when the price of ${widget.tickerName} will cross the threshold points the you will enter below.',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                  ),
                  SizedBox(height: height / 50.75),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Current Price: ",
                              style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                          currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                              ? Text("\u{20B9} ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: 'Robonto', color: const Color(0XFF0EA102)))
                              : currentMainIndex == 6
                                  ? const SizedBox()
                                  : Text("\$ ",
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(12), color: const Color(0XFF0EA102))),
                          Text(widget.closeValue,
                              style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                        ],
                      ),
                      Container(
                        height: height / 34.80,
                        width: width / 16.07,
                        margin: const EdgeInsets.only(right: 25),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                            ? Image.asset("lib/Constants/Assets/SMLogos/rupee.png")
                            : currentMainIndex == 6
                                ? const SizedBox()
                                : SvgPicture.asset(
                                    "lib/Constants/Assets/SMLogos/dollar_image.svg",
                                    fit: BoxFit.fill,
                                  ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 50.75),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: minControllerMainList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 2,
                        shadowColor: Colors.black26,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black26.withOpacity(0.1)),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 31.25),
                          child: Column(
                            children: [
                              savePressedList.contains(true)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              if (notificationMainList[index] == "") {
                                                setState(() {
                                                  minControllerMainList.removeAt(index);
                                                  maxControllerMainList.removeAt(index);
                                                  notesControllerMainList.removeAt(index);
                                                  fieldEmptyList.removeAt(index);
                                                  savePressedList.removeAt(index);
                                                  notificationMainList.removeAt(index);
                                                  minSuggestionBoolList.removeAt(index);
                                                  maxDisableList.removeAt(index);
                                                  finalMaxPercent.removeAt(index);
                                                  maxSuggestionList.removeAt(index);
                                                  maxSuggestionBoolList.removeAt(index);
                                                });
                                              } else {
                                                await removeNotifyListMain1(
                                                  tickerId: widget.tickerId,
                                                  context: context,
                                                  notifyId: notificationMainList[index],
                                                );
                                                setState(() {
                                                  minControllerMainList.removeAt(index);
                                                  maxControllerMainList.removeAt(index);
                                                  notesControllerMainList.removeAt(index);
                                                  fieldEmptyList.removeAt(index);
                                                  savePressedList.removeAt(index);
                                                  notificationMainList.removeAt(index);
                                                  minSuggestionBoolList.removeAt(index);
                                                  maxDisableList.removeAt(index);
                                                  finalMaxPercent.removeAt(index);
                                                  maxSuggestionList.removeAt(index);
                                                  maxSuggestionBoolList.removeAt(index);
                                                });
                                              }
                                            },
                                            splashRadius: 1.0,
                                            icon: SizedBox(
                                                height: height / 40.6,
                                                width: width / 18.75,
                                                child: Image.asset(
                                                  "lib/Constants/Assets/ForumPage/x.png",
                                                )))
                                      ],
                                    )
                                  : SizedBox(
                                      height: height / 50.75,
                                    ),
                              TextFormField(
                                style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                onChanged: (value) {
                                  maxSuggestionBoolList[index] = false;
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      maxDisableList[index] = false;
                                      maxControllerMainList[index].clear();
                                      double value1 = double.parse(minControllerMainList[index].text);
                                      double value2 = double.parse(widget.closeValue);
                                      double finalValue = 0.0;
                                      finalValue = value1 - value2;
                                      finalMaxPercent[index] = ((finalValue * 100) / value2).round();
                                      if (minControllerMainList[index].text.isNotEmpty && maxControllerMainList[index].text.isNotEmpty) {
                                        fieldEmptyList[index] = true;
                                        savePressedList[index] = false;
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      minSuggestionBoolList[index] = true;
                                      maxControllerMainList[index].clear();
                                      maxDisableList[index] = true;
                                      finalMaxPercent[index] = 0;
                                    });
                                  }
                                },
                                onTap: () {
                                  setState(() {
                                    minSuggestionBoolList[index] = true;
                                    finalMaxPercent[index] = 0;
                                  });
                                },
                                controller: minControllerMainList[index],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelStyle: TextStyle(
                                      color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.w400, fontFamily: "Robonto"),
                                  labelText: currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                                      ? 'Min(\u{20B9})'
                                      : currentMainIndex == 6
                                          ? 'Min'
                                          : 'Min(\$)',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: height / 101.5),
                              minControllerMainList[index].text.isEmpty
                                  ? minSuggestionBoolList[index]
                                      ? SizedBox(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "suggestions: ",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: minSuggestionList[index].length,
                                                  itemBuilder: (context, index1) {
                                                    return InkWell(
                                                      onTap: () {
                                                        finalMaxPercent[index] = minSuggestionList[index][index1];
                                                        double value1 = minSuggestionList[index][index1] / 100;
                                                        double value2 = double.parse(widget.closeValue);
                                                        double finalValue = (value1 * value2).abs();
                                                        if (value1 < 0) {
                                                          minControllerMainList[index].text = (value2 - finalValue).toStringAsFixed(3);
                                                          minControllerMainList[index].selection = TextSelection.fromPosition(
                                                              TextPosition(offset: minControllerMainList[index].text.length));
                                                          setState(() {
                                                            minSuggestionBoolList[index] = false;
                                                            maxDisableList[index] = false;
                                                          });
                                                        } else {
                                                          minControllerMainList[index].text = (value2 + finalValue).toStringAsFixed(3);
                                                          minControllerMainList[index].selection = TextSelection.fromPosition(
                                                              TextPosition(offset: minControllerMainList[index].text.length));
                                                          setState(() {
                                                            minSuggestionBoolList[index] = false;
                                                            maxDisableList[index] = false;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        margin: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0XFF0EA102),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${minSuggestionList[index][index1]}%",
                                                            style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              SizedBox(height: height / 101.5),
                              TextFormField(
                                readOnly: maxDisableList[index],
                                style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      maxSuggestionBoolList[index] = true;
                                    });
                                  } else {
                                    setState(() {
                                      if (minControllerMainList[index].text.isNotEmpty && maxControllerMainList[index].text.isNotEmpty) {
                                        fieldEmptyList[index] = true;
                                        savePressedList[index] = false;
                                      }
                                    });
                                  }
                                },
                                onTap: () {
                                  if (maxDisableList[index]) {
                                    Flushbar(
                                      message: "Please enter Minimum Value",
                                      duration: const Duration(seconds: 2),
                                    ).show(context);
                                  } else {
                                    maxSuggestionList[index] = [
                                      finalMaxPercent[index] + 5,
                                      finalMaxPercent[index] + 10,
                                      finalMaxPercent[index] + 15,
                                      finalMaxPercent[index] + 20,
                                      finalMaxPercent[index] + 25
                                    ];
                                    setState(() {
                                      maxSuggestionBoolList[index] = true;
                                    });
                                  }
                                },
                                controller: maxControllerMainList[index],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelStyle: TextStyle(
                                      color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.w400, fontFamily: "Robonto"),
                                  labelText: currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                                      ? 'Max(\u{20B9})'
                                      : currentMainIndex == 6
                                          ? 'Max'
                                          : 'Max(\$)',
                                ),
                              ),
                              SizedBox(height: height / 101.5),
                              maxControllerMainList[index].text.isEmpty
                                  ? maxSuggestionBoolList[index]
                                      ? SizedBox(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "suggestions: ",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: maxSuggestionList[index].length,
                                                  itemBuilder: (context, index1) {
                                                    return InkWell(
                                                      onTap: () {
                                                        double value1 = maxSuggestionList[index][index1] / 100;
                                                        double value2 = double.parse(widget.closeValue);
                                                        double finalValue = (value1 * value2).abs();
                                                        if (value1 < 0) {
                                                          maxControllerMainList[index].text = (value2 - finalValue).toStringAsFixed(3);
                                                          maxControllerMainList[index].selection = TextSelection.fromPosition(
                                                              TextPosition(offset: maxControllerMainList[index].text.length));
                                                          setState(() {
                                                            maxSuggestionBoolList[index] = false;
                                                            maxDisableList[index] = false;
                                                            fieldEmptyList[index] = true;
                                                            savePressedList[index] = false;
                                                          });
                                                        } else {
                                                          maxControllerMainList[index].text = (value2 + finalValue).toStringAsFixed(3);
                                                          maxControllerMainList[index].selection = TextSelection.fromPosition(
                                                              TextPosition(offset: maxControllerMainList[index].text.length));
                                                          setState(() {
                                                            maxSuggestionBoolList[index] = false;
                                                            maxDisableList[index] = false;
                                                            fieldEmptyList[index] = true;
                                                            savePressedList[index] = false;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        margin: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0XFF0EA102),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${maxSuggestionList[index][index1]}%",
                                                            style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              SizedBox(
                                height: height / 50.75,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                onChanged: (value) {
                                  setState(() {
                                    if (minControllerMainList[index].text.isNotEmpty && maxControllerMainList[index].text.isNotEmpty) {
                                      fieldEmptyList[index] = true;
                                      savePressedList[index] = false;
                                    }
                                  });
                                },
                                controller: notesControllerMainList[index],
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                minLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 8),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelStyle: TextStyle(
                                    color: const Color(0XFFA5A5A5),
                                    fontSize: text.scale(15),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelText: "Notes (optional)",
                                ),
                              ),
                              SizedBox(
                                height: height / 50.75,
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: fieldEmptyList[index]
                                          ? savePressedList[index]
                                              ? Colors.grey
                                              : const Color(0XFF0EA102)
                                          : Colors.grey),
                                  onPressed: savePressedList[index]
                                      ? () {}
                                      : () async {
                                          if (double.parse(maxControllerMainList[index].text) <= double.parse(minControllerMainList[index].text)) {
                                            Flushbar(
                                              message: "Max value must greater than min value",
                                              duration: const Duration(seconds: 2),
                                            ).show(context);
                                          } else {
                                            setState(() {
                                              savePressedList[index] = true;
                                            });
                                            watchNotifyAddedBoolListMain[widget.currentIndex] = true;
                                            if (notificationMainList[index] == "") {
                                              var newResponse = await addNotifyListMain1(
                                                  notificationId: notificationMainList[index],
                                                  tickerId: widget.tickerId,
                                                  minValue: minControllerMainList[index].text,
                                                  maxvalue: maxControllerMainList[index].text,
                                                  notes: notesControllerMainList[index].text,
                                                  context: context);
                                              notificationMainList[index] = newResponse["response"]['_id'];
                                            } else {
                                              await addNotifyListMain1(
                                                  notificationId: notificationMainList[index],
                                                  tickerId: widget.tickerId,
                                                  minValue: minControllerMainList[index].text,
                                                  maxvalue: maxControllerMainList[index].text,
                                                  context: context,
                                                  notes: notesControllerMainList[index].text);
                                            }
                                          }
                                        },
                                  child: const Text(
                                    "Save alert",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0XFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 50.75,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: notificationMainList.length >= 5
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Need to add another Alert.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                TextButton(
                                    onPressed: savePressedList.contains(false)
                                        ? () {}
                                        : () {
                                            setState(() {
                                              minControllerMainList.add(TextEditingController());
                                              maxControllerMainList.add(TextEditingController());
                                              notesControllerMainList.add(TextEditingController());
                                              notificationMainList.add("");
                                              savePressedList.add(false);
                                              fieldEmptyList.add(false);
                                              minSuggestionList.add([-10, -5, 0, 5, 10]);
                                              minSuggestionBoolList.add(false);
                                              maxDisableList.add(true);
                                              maxSuggestionBoolList.add(false);
                                              finalMaxPercent.add(0);
                                              maxSuggestionList.add([0, 0, 0, 0, 0]);
                                            });
                                          },
                                    child: Text(
                                      "Click Here",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: savePressedList.contains(false) ? Colors.grey : const Color(0XFF0EA102),
                                      ),
                                    )),
                              ],
                            ) //:
                      ),
                  SizedBox(height: height / 40.6),
                ],
              ),
            ),
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
          );
  }
}

Future<bool> checkProfileVerify() async {
  var url = Uri.parse(baseurl + versionLocker + checkUserMain);
  var response = await http.post(
    url,
    headers: {'Authorization': kToken},
  );
  var responseData = json.decode(response.body);
  return responseData["status"];
}

getAllDataMain({required String name}) async {
  await FirebaseAnalytics.instance.setCurrentScreen(screenName: name);
}

setUserIDAnalyticsFunc({required String userId, required String name, required String value}) async {
  await FirebaseAnalytics.instance.setUserId(id: userId);
  await FirebaseAnalytics.instance.setUserProperty(
    name: name,
    value: value,
  );
}

logEventFunc({required String name, required String type}) async {
  await FirebaseAnalytics.instance.logEvent(name: name, parameters: {'type': type});
}

Future<bool> pageVisitFunc({required String pageName}) async {
  String mainUserToken1 = "";
  var url = Uri.parse(baseurl + versions + pageVisits);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  mainUserToken1 = prefs.getString('newUserToken') ?? "";
  var response = await http.post(url, headers: {'Authorization': mainUserToken1}, body: {"type": pageName});
  var responseData = json.decode(response.body);
  return responseData["status"];
}

Future<dynamic> commonPopUpBar({required BuildContext context}) async {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  TextScaler text = MediaQuery.of(context).textScaler;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        reverse: true,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: SizedBox(
            height: height / 1.37,
            width: width / 4.38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel_outlined
                        )),
                  ],
                ),
                SizedBox(height: height / 102.75),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isDarkTheme.value ? "assets/splash_screen/logo_text_dark.svg" : "assets/splash_screen/logo_text_light.svg",
                      width: width / 1.86,
                      height: height / 19.24,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                SizedBox(height: height / 102.75),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 219),
                  child: Image.asset(
                    "lib/Constants/Assets/SMLogos/SkipPage/skipPopImage.png",
                  ),
                ),
                SizedBox(height: height / 102.75),
                Center(
                    child: Text(
                  "Trade communication made easy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: text.scale(10), fontFamily: "Poppins"),
                )),
                SizedBox(height: height / 102.75),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 219),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Powerful alone. Even better together. ",
                          style:
                              TextStyle(fontSize: text.scale(7), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                      TextSpan(
                        text:
                            "Join one of the fastest-growing social trading community and engage with other traders and get access to exclusive member-only features like news, videos, forums, and surveys published by other traders.",
                        style: TextStyle(fontSize: text.scale(7),fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                      ),
                    ]),
                  ),
                ),
                SizedBox(height: height / 102.75),
                const Center(
                    child: Text(
                  "Join the community today and never miss an insight.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.w400, fontSize: 7, fontFamily: "Poppins"),
                )),
                SizedBox(height: height / 102.75),
                InkWell(
                  onTap: () async {
                    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

                    Navigator.pop(context);
                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const SignInPage(
                        fromWhere: "finalCharts",
                      );
                    }));
                    if (response) {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0XFF0EA102),
                    ),
                    width: width,
                    height: height / 14.5,
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(8), fontFamily: "Poppins"),
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

Future<dynamic> commonFlushBar({required BuildContext context, Function? initFunction, String? fromWhere}) async {
  return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return NonLogin(
          fromWhere: fromWhere,
        );
      }).whenComplete(() {
    if (initFunction != null) {
      mainSkipValue ? debugPrint("Non Login") : initFunction();
    } else {
      mainSkipValue ? debugPrint("nothing") : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SettingsView()));
    }
  });
}

class NonLogin extends StatefulWidget {
  final String? fromWhere;

  const NonLogin({Key? key, this.fromWhere}) : super(key: key);

  @override
  State<NonLogin> createState() => _NonLoginState();
}

class _NonLoginState extends State<NonLogin> {
  bool socialLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String regId = "";
  String regToken = "";
  String regLocker = "";
  bool loading = false;
  bool emailEmpty = false;
  bool doNotShowPassword = false;
  bool passwordEmpty = false;

  socialMediaLogin({
    required String? email,
    required String uid,
    required String type,
    required String firstName,
    required String lastName,
    required String userName,
    required String phoneCode,
    required String? phoneNumber,
    required String referralCode,
    required String socialAvatar,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(baseurl + versions + checkSocial);
    var response = await http.post(url, body: {"socialid": uid, "type": type, "Page": "sign_in"});
    var responseData = json.decode(response.body);
    if (!responseData["status"]) {
      var url = Uri.parse(baseurl + versions + socialLogin);
      var response = await http.post(
        url,
        body: {
          "email": responseData["email"] == "" ? responseData["phone_number"] : responseData["email"],
          "socialid": uid,
          "device_id": functionsMain.deviceId,
          "device_token": functionsMain.fireBasToken,
          "device_type": Platform.isIOS ? "ios" : "android",
          "type": type
        },
      );
      var responseData1 = json.decode(response.body);
      if (responseData1["status"]) {
        logEventFunc(name: 'Social_Media_Login', type: type);
        regId = responseData1["response"]["id"];
        setUserIDAnalyticsFunc(userId: regId, name: responseData1["response"]["username"], value: responseData1["response"]["email"]);
        regToken = responseData1["response"]["token"];
        regLocker = responseData1["response"]["locker"];
        String regAvatar = responseData1["response"]["avatar"];
        mainSkipValue = false;
        //prefs.setBool("skipValue", mainSkipValue);
        kToken = regToken;
        prefs.setString('newUserId', regId);
        prefs.setString('newUserToken', regToken);
        prefs.setString('newUserLocker', regLocker);
        prefs.setString('newUserAvatar', regAvatar);
        if (!context.mounted) {
          return;
        }
        conversationFunctionsMain.getSocketFunction(context: context);
        avatarMain.value = regAvatar;
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
      } else {
        if (!context.mounted) {
          return;
        }
        Flushbar(
          message: responseData1["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        setState(() {
          loading = false;
          socialLoading = false;
        });
      }
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        socialLoading = false;
      });
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SignUpPage(
          firstName: firstName,
          lastName: lastName,
          userName: userName,
          email: email,
          socialId: uid,
          type: type,
          phoneCode: phoneCode,
          phoneNumber: phoneNumber ?? "",
          devType: Platform.isIOS ? "ios" : "android",
          referralCode: "",
          socialAvatar: socialAvatar,
          noPass: true,
        );
      }));
    }
  }

  login({required String email1, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email1 == "" || password == "") {
      if (email1 == "" && password == "") {
        emailEmpty = true;
        passwordEmpty = true;
      } else if (email1 == "" && password != "") {
        emailEmpty = true;
        passwordEmpty = false;
      } else if (email1 != "" && password == "") {
        emailEmpty = false;
        passwordEmpty = true;
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
        if (emailValid) {
          //emailEmptyValid=false;
        } else {
          //emailEmptyValid=true;
        }
      } else {
        emailEmpty = false;
        passwordEmpty = false;
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
        if (emailValid) {
          //emailEmptyValid=false;
        } else {
          //emailEmptyValid=true;
        }
      }
      setState(() {
        loading = false;
      });
    } else {
      emailEmpty = false;
      passwordEmpty = false;
      var url = Uri.parse(baseurl + versions + newLogin);
      var response = await http.post(url, body: {
        "email": email1,
        "password": password,
        "device_token": functionsMain.fireBasToken,
        "device_type": Platform.isIOS ? "ios" : "android",
        "device_id": functionsMain.deviceId
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      var responseData = json.decode(response.body);
      if (responseData["status"]) {
        logEventFunc(
          name: 'Login',
          type: 'normal',
        );
        regId = responseData["response"]["id"];
        setUserIDAnalyticsFunc(userId: regId, name: responseData["response"]["username"], value: responseData["response"]["email"]);
        regToken = responseData["response"]["token"];
        regLocker = responseData["response"]["locker"];
        String regAvatar = responseData["response"]["avatar"];
        mainSkipValue = false;
        // prefs.setBool("skipValue", mainSkipValue);
        kToken = regToken;
        prefs.setString('newUserId', regId);
        prefs.setString('newUserToken', regToken);
        prefs.setString('newUserLocker', regLocker);
        prefs.setString('newUserAvatar', regAvatar);
        if (!context.mounted) {
          return;
        }
        conversationFunctionsMain.getSocketFunction(context: context);
        avatarMain.value = regAvatar;
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        _passwordController.clear();
        _emailController.clear();
      } else {
        if (!context.mounted) {
          return;
        }
        Flushbar(
          message: responseData["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        setState(() {
          loading = false;
        });
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    doNotShowPassword = true;
    // functionsMain.fireBaseCloudMessagingListeners();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWhere == "billboard") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                      caseNo1: 0, text: "Stocks", excIndex: 1, newIndex: 0, countryIndex: 1, isHomeFirstTym: false, tType: true)));
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 21.17, vertical: height / 47.5),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Happy to see you here.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color(0XFF0EA102)),
                  ),
                  IconButton(
                      onPressed: () {
                        if (widget.fromWhere == "billboard") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => const MainBottomNavigationPage(
                                      caseNo1: 0, text: "Stocks", excIndex: 1, newIndex: 0, countryIndex: 1, isHomeFirstTym: false, tType: true)));
                        } else {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 25,
                      )),
                ],
              ),
              const Text(
                "Join the trading community.",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF8D8D8D)),
              ),
              SizedBox(
                height: height / 34.54,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width / 11),
                  child: Column(
                    children: [
                      Platform.isIOS
                          ? Center(
                              child: SizedBox(
                                height: height / 21.11,
                                width: width / 1.61,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        setState(() {
                                          socialLoading = true;
                                        });
                                        UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                        if (user == null) {
                                          setState(() {
                                            socialLoading = false;
                                          });
                                        }
                                        String? phone = user!.user!.phoneNumber;
                                        await socialMediaLogin(
                                          email: user.additionalUserInfo!.profile!["email"],
                                          uid: user.user!.uid,
                                          type: user.credential!.signInMethod,
                                          firstName: user.additionalUserInfo!.profile!["given_name"],
                                          lastName: user.additionalUserInfo!.profile!["family_name"],
                                          userName: "",
                                          phoneCode: "",
                                          phoneNumber: phone,
                                          referralCode: "",
                                          socialAvatar: "",
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                        height: height / 18.45,
                                        width: width / 8.52,
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        /* setState(() {
                                          socialLoading = true;
                                        });*/
                                        UserCredential? user = await authFunctionsMain.signInApples();
                                        if (user == null) {
                                          /* setState(() {
                                            socialLoading = false;
                                          });*/
                                        }
                                        String? phone = user!.user!.phoneNumber ?? user.user!.providerData[0].phoneNumber;
                                        String? name1 = user.user!.displayName ?? user.user!.providerData[0].displayName;
                                        String? email1 = user.user!.providerData[0].email != null
                                            ? (user.user!.providerData[0].email!.contains(".appleid.") ? null : user.user!.providerData[0].email)
                                            : user.user!.email != null
                                                ? (user.user!.email!.contains(".appleid.") ? null : user.user!.email)
                                                : null;
                                        String? firstName1 = "";
                                        String? lastName1 = "";
                                        List parts = [];
                                        if (name1 == null || name1 == "") {
                                          if (email1 == null) {
                                            parts.add("");
                                            parts.add("");
                                            firstName1 = "";
                                            lastName1 = "";
                                          } else {
                                            parts = email1.split("@");
                                            parts[0].trim();
                                            firstName1 = parts[0].trim();
                                            lastName1 = "";
                                          }
                                        } else {
                                          parts = name1.split(" ");
                                          if (parts.isNotEmpty) {
                                            parts[0].trim();
                                            parts[1].trim();
                                            firstName1 = parts[0].trim();
                                            lastName1 = parts[1].trim();
                                          } else {
                                            parts[0].trim();
                                            firstName1 = parts[0].trim();
                                            lastName1 = "";
                                          }
                                        }
                                        await socialMediaLogin(
                                          email: email1,
                                          uid: user.user!.uid,
                                          type: user.credential!.signInMethod,
                                          firstName: firstName1.toString().capitalizeFirst ?? "",
                                          lastName: lastName1.toString().capitalizeFirst ?? "",
                                          userName: "",
                                          phoneCode: "",
                                          phoneNumber: phone,
                                          referralCode: "",
                                          socialAvatar: "",
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        "lib/Constants/Assets/SMLogos/Logos/appleNew.svg",
                                        height: height / 18.45,
                                        width: width / 8.52,
                                      ),
                                    ),
                                    /*IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        setState(() {
                                          socialLoading = true;
                                        });
                                        UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                        if (user == null) {
                                          setState(() {
                                            socialLoading = false;
                                          });
                                        }
                                        String? phone = user!.user!.phoneNumber;
                                        await socialMediaLogin(
                                          email: user.additionalUserInfo!.profile!["email"],
                                          uid: user.user!.uid,
                                          type: user.credential!.signInMethod,
                                          firstName: user.additionalUserInfo!.profile!["first_name"],
                                          lastName: user.additionalUserInfo!.profile!["last_name"],
                                          userName: "",
                                          phoneCode: "",
                                          phoneNumber: phone,
                                          referralCode: "",
                                          socialAvatar: "",
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                        height: height / 18.45,
                                        width: width / 8.52,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: SizedBox(
                                height: height / 21.11,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        setState(() {
                                          socialLoading = true;
                                        });
                                        UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                        if (user == null) {
                                          setState(() {
                                            socialLoading = false;
                                          });
                                        }
                                        String? phone = user!.user!.phoneNumber;
                                        await socialMediaLogin(
                                          email: user.additionalUserInfo!.profile!['email'],
                                          uid: user.user!.uid,
                                          type: user.credential!.signInMethod,
                                          firstName: user.additionalUserInfo!.profile!["given_name"],
                                          lastName: user.additionalUserInfo!.profile!["family_name"],
                                          userName: "",
                                          phoneCode: "",
                                          phoneNumber: phone,
                                          referralCode: "",
                                          socialAvatar: "",
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                        height: height / 18.45,
                                        width: width / 8.52,
                                      ),
                                    ),
                                    /*IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        setState(() {
                                          socialLoading = true;
                                        });
                                        UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                        if (user == null) {
                                          setState(() {
                                            socialLoading = false;
                                          });
                                        }
                                        String? phone = user!.user!.phoneNumber;
                                        await socialMediaLogin(
                                          email: user.additionalUserInfo!.profile!["email"],
                                          uid: user.user!.uid,
                                          type: user.credential!.signInMethod,
                                          firstName: user.additionalUserInfo!.profile!["first_name"],
                                          lastName: user.additionalUserInfo!.profile!["last_name"],
                                          userName: "",
                                          phoneCode: "",
                                          phoneNumber: phone,
                                          referralCode: "",
                                          socialAvatar: "",
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                        height: height / 18.45,
                                        width: width / 8.52,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFF848383), fontFamily: "Poppins"),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return SignUpPage(
                                    firstName: "",
                                    lastName: "",
                                    userName: "",
                                    email: "",
                                    socialId: "",
                                    type: "",
                                    phoneCode: "",
                                    phoneNumber: "",
                                    devType: Platform.isIOS ? "ios" : "android",
                                    referralCode: "",
                                    socialAvatar: "",
                                    noPass: false,
                                  );
                                }));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: text.scale(10), color: const Color(0XFF0DA102), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 0.6,
                              color: Color(0XFF848383),
                              height: 1,
                            ),
                          ),
                          Text(
                            "or",
                            style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF848383)),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 0.6,
                              color: Color(0XFF848383),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 40),
                      SizedBox(
                        height: height / 21.11,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelStyle: TextStyle(
                                color: const Color(0XFFD0D0D0), fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                            labelText: 'Email or Phone Number',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      emailEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text("Enter email address", style: TextStyle(fontSize: 11, color: Colors.red))],
                              ))
                          : const SizedBox(),
                      SizedBox(
                        height: height / 40,
                      ),
                      SizedBox(
                        height: height / 21.11,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          obscureText: doNotShowPassword,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelStyle: TextStyle(
                                color: const Color(0XFFD0D0D0), fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  doNotShowPassword = !doNotShowPassword;
                                });
                              },
                              child: doNotShowPassword
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Color(0XFFA5A5A5),
                                      size: 15,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: Color(0XFF0EA102),
                                      size: 15,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      passwordEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text("Enter password", style: TextStyle(fontSize: 11, color: Colors.red))],
                              ))
                          : const SizedBox(),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return const ForgetPasswordPage();
                                }));
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontSize: text.scale(10), color: const Color(0XFF0DA102), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: height / 50.75,
                      ),
                      loading
                          ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                          : GestureDetector(
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                login(password: _passwordController.text, email1: _emailController.text);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  color: Color(0XFF0DA102),
                                ),
                                width: width,
                                height: height / 21.11,
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: text.scale(10), fontFamily: "Poppins"),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

resetAllValues() {
  mainCatIdList.clear();
  finalExchangeIdList.clear();
  showSheetNameList.clear();
  showSheetImagesList.clear();
  showSheetIdList.clear();
  showSheetUserIdList.clear();
  videoViewsImagesList.clear();
  videoViewsIdList.clear();
  videoViewsUserIdList.clear();
  videoViewsSourceNameList.clear();
  kLikesCountNameList.clear();
  kLikesCountImagesList.clear();
  kLikesCountIdList.clear();
  kLikesCountUserIdList.clear();
  watchNotifyAddedBoolListMain.clear();
  finalisedCategory = "";
  finalisedFilterId = "";
  finalisedFilterName = "";
  tickerDetailLogo = "";
  tickerDetailName = "";
  tickerDetailExc = "";
  tickerDetailCategory = "";
  tickerDetailCode = "";
  tickerDetailIndustry = "";
  tickerDetailAddress = "";
  tickerDetailDescription = "";
  tickerDetailWebUrl = "";
  onTapType = "";
  onTapId = "";
  filterAlertTitle = "Looks like you have not created a filter yet, do you want to create on with current selection?";
  kToken = "";
  checkCategory = "";
  idKeyMain = "";
  apiMain = "";
  onTapTypeMain = "";
  onTapIdMain = "";
  fireBasTokenMain = "";
  userIdMain = "";
  mainSkipValue = true;
  liveStatusActive = false;
  liveStatusActive11 = false;
  liveStatusActive12 = false;
  lockerFilterResponse = true;
  onLike = false;
  onDislike = false;
  onViews = false;
  loaderMain = false;
  loaderMainSearch = false;
  haveLikesMain = false;
  haveDisLikesMain = false;
  haveViewsMain = false;
  currentMainIndex = 1;
  skipCountMain = 0;
  likesCountMain = 0;
  dislikesCountMain = 0;
  viewCountMain = 0;
  mainVariables.contentCategoriesMain.clear();
  mainVariables.contentTypeMain.value = "";
  mainVariables.selectedProfileMain.value = "user";
}

Future<dynamic> getCookies() async {
  var url = baseurl + versionHome + tvCookies;
  var responsePrimary = await dioMain.get(url);
  var responsePrimaryData = responsePrimary.data;
  return responsePrimaryData;
}

Widget excLabelButton({required String text, required BuildContext context, bool? isSmall}) {
  double heightMain = MediaQuery.of(context).size.height;
  double widthMain = MediaQuery.of(context).size.width;
  TextScaler textMain = MediaQuery.of(context).textScaler;
  double width = 0.0;
  double height = 0.0;
  Color color = Colors.white;
  String text0 = "";
  switch (text.toLowerCase()) {
    case "nse":
      {
        width = isSmall == true ? widthMain / 13.7 : widthMain / 10.81;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFFF7931A);
        text0 = "NSE";
        break;
      }
    case "bse":
      {
        width = isSmall == true ? widthMain / 13.7 : widthMain / 10.81;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF3399D2);
        text0 = "BSE";
        break;
      }

    case "indx":
      {
        width = isSmall == true ? widthMain / 10.81 : widthMain / 9.13;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF33D243);
        text0 = "INDEX";
        break;
      }

    case "usastocks":
      {
        width = isSmall == true ? widthMain / 6.5 : widthMain / 4.83;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF33C8D2);
        text0 = "USA STOCKS";
        break;
      }

    case "coin":
      {
        width = isSmall == true ? widthMain / 10.81 : widthMain / 9.13;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF323232);
        text0 = "COIN";
        break;
      }

    case 'token':
      {
        width = isSmall == true ? widthMain / 13.7 : widthMain / 8.22;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF7EBA00);
        text0 = "TOKEN";
        break;
      }

    case "india":
      {
        width = isSmall == true ? widthMain / 13.7 : widthMain / 9.13;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF335DD2);
        text0 = "INDIA";
        break;
      }

    case "usa":
      {
        width = isSmall == true ? widthMain / 13.7 : widthMain / 10.81;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFFD23333);
        text0 = "USA";
        break;
      }

    case "inrusd":
      {
        width = isSmall == true ? widthMain / 12 : widthMain / 7.90;
        height = isSmall == true ? heightMain / 61.85 : heightMain / 48.66;
        color = const Color(0XFF33D299);
        text0 = "INRUSD";
        break;
      }

    default:
      {
        width = 0;
        height = 0;
        color = Colors.transparent;
        text0 = "";
      }
  }
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
    child: Center(
        child: Text(
      text0,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: isSmall == true ? textMain.scale(8) : textMain.scale(12), color: Colors.white),
    )),
  );
}

Widget sentimentButton({required String text, required BuildContext context}) {
  double heightMain = MediaQuery.of(context).size.height;
  double widthMain = MediaQuery.of(context).size.width;
  TextScaler textMain = MediaQuery.of(context).textScaler;
  // Color color = Colors.white;
  String image = "";
  String text0 = "";
  bool isNull = false;
  bool isExpanded = false;

  switch (text) {
    case "positive":
      {
        isNull = true;
        // color = const Color(0XFF39B12F);
        image = "lib/Constants/Assets/SMLogos/LockerScreen/share_up.png";
        text0 = "Positive";
        break;
      }
    case "negative":
      {
        isNull = true;
        // color = const Color(0XFFFA3133);
        image = "lib/Constants/Assets/SMLogos/LockerScreen/share_down.png";
        text0 = "Negative";
        break;
      }
    case "neutral":
      {
        isNull = true;
        // color = const Color(0XFFE4C452);
        image = "lib/Constants/Assets/SMLogos/LockerScreen/neutral.png";
        text0 = "Neutral";
        break;
      }
    default:
      {
        isNull = false;
      }
  }
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter modelSetState) {
      return isNull
          ? SizedBox(
              height: heightMain / 35.04,
              width: isExpanded ? widthMain / 4.56 : widthMain / 16.44,
              child: FloatingActionButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(isExpanded ? 10.0 : 15.0))),
                onPressed: () {
                  modelSetState(() {
                    isExpanded = !isExpanded;
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    modelSetState(() {
                      isExpanded = !isExpanded;
                    });
                  });
                },
                backgroundColor: Colors.white,
                isExtended: true,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: text == "neutral" ? 0.0 : widthMain / 137, vertical: text == "neutral" ? 0.0 : heightMain / 292),
                      child: text == "neutral"
                          ? const Center(
                              child: Icon(
                              Icons.remove,
                              color: Color(0XFFE4C452),
                            ))
                          : Image.asset(
                              image,
                            ),
                    ),
                    SizedBox(
                      width: isExpanded ? widthMain / 82.2 : 0,
                    ),
                    isExpanded
                        ? Text(
                            text0,
                            style: TextStyle(color: Colors.black, fontSize: textMain.scale(10), fontWeight: FontWeight.w700),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            )
          : const SizedBox();
    },
  );
}

similarDataFunc({
  required BuildContext context,
  required dynamic data,
  required List exchangeList,
  required Function initFunction,
  required StateSetter modelSetState,
}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  TextScaler text = MediaQuery.of(context).textScaler;
  if (relatedTopicText.value.toLowerCase() == "news") {
    RelatedNewsModel newsRelatedResponse = data;
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: newsRelatedResponse.response.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (relatedOnPage.value != 'news') {
                modelSetState(() {
                  if (newsRelatedResponse.response[index].description == "" && newsRelatedResponse.response[index].snippet == "") {
                    /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DemoPage(
                                url: newsRelatedResponse.response[index].newsUrl,
                                text: "",
                                image: "",
                                id: newsRelatedResponse.response[index].id,
                                type: 'news',
                                activity: true)));*/
                    Get.to(const DemoView(), arguments: {
                      "id": newsRelatedResponse.response[index].id,
                      "type": "news",
                      "url": newsRelatedResponse.response[index].newsUrl
                    });
                  } else {
                    listIds.clear();
                    List<String> descList = [];
                    List<String> snipList = [];
                    for (int i = 0; i < newsRelatedResponse.response.length; i++) {
                      if (newsRelatedResponse.response[i].description == "" && newsRelatedResponse.response[i].snippet == "") {
                      } else {
                        descList.add(newsRelatedResponse.response[i].description);
                        snipList.add(newsRelatedResponse.response[i].snippet);
                        listIds.add(newsRelatedResponse.response[i].id);
                      }
                    }
                    idIndex.value = listIds.indexOf(newsRelatedResponse.response[index].id);
                    currentNewsId.value = listIds[idIndex.value];
                    /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>NewsDescriptionPage
                      (id: _newsRelatedResponse.response[index].id,comeFrom: "similar", idList: listIds, descriptionList: descList, snippetList: snipList,)));
                      */

                    /// need to change it soon
                    /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DemoPage(
                                  url: newsRelatedResponse.response[index].newsUrl,
                                  text: newsRelatedResponse.response[index].title,
                                  image: "",
                                  id: newsRelatedResponse.response[index].id,
                                  type: 'news',
                                  activity: true,
                                  checkMain: false,
                                )));*/
                    Get.to(const DemoView(), arguments: {
                      "id": newsRelatedResponse.response[index].id,
                      "type": "news",
                      "url": newsRelatedResponse.response[index].newsUrl
                    });
                  }
                });
              } else {
                modelSetState(() {
                  if (newsRelatedResponse.response[index].description == "" && newsRelatedResponse.response[index].snippet == "") {
                    /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DemoPage(
                                url: newsRelatedResponse.response[index].newsUrl,
                                text: "",
                                image: "",
                                id: newsRelatedResponse.response[index].id,
                                type: 'news',
                                activity: true)));*/
                    Get.to(const DemoView(), arguments: {
                      "id": newsRelatedResponse.response[index].id,
                      "type": "news",
                      "url": newsRelatedResponse.response[index].newsUrl
                    });
                  } else {
                    listIds.clear();
                    for (int i = 0; i < newsRelatedResponse.response.length; i++) {
                      if (newsRelatedResponse.response[i].description == "" && newsRelatedResponse.response[i].snippet == "") {
                      } else {
                        listIds.add(newsRelatedResponse.response[i].id);
                      }
                    }
                    idIndex.value = listIds.indexOf(newsRelatedResponse.response[index].id);
                    currentNewsId.value = listIds[idIndex.value];
                    initFunction();
                  }
                });
              }
            },
            child: Column(
              children: [
                Container(
                  // height: _height/8.42,
                  width: width,
                  margin: EdgeInsets.only(top: height / 51.52, bottom: height / 73),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: height / 8.42,
                            width: width / 2.41,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(image: NetworkImage(newsRelatedResponse.response[index].imageUrl), fit: BoxFit.fill)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: excLabelButton(text: exchangeList[index], context: context),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width / 27.4,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: newsRelatedResponse.response[index].title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: text.scale(14),
                                        color: const Color(0XFF1D1919),
                                        fontFamily: "Poppins")),
                                TextSpan(
                                  text: ' ${newsRelatedResponse.response[index].date}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: text.scale(10),
                                    color: const Color(0XFFB7B7B7),
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                WidgetSpan(
                                    child: newsRelatedResponse.response[index].sentiment == 'positive'
                                        ? Container(
                                            margin: const EdgeInsets.only(left: 8.0),
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: const Color(0XFF39B12F),
                                            ),
                                            child: Text(
                                              "Positive",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: text.scale(10),
                                                color: Colors.white,
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          )
                                        : newsRelatedResponse.response[index].sentiment == 'negative'
                                            ? Container(
                                                margin: const EdgeInsets.only(left: 8.0),
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: const Color(0XFFFA3133),
                                                ),
                                                child: Text(
                                                  "Negative",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: text.scale(10),
                                                    color: Colors.white,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              )
                                            : newsRelatedResponse.response[index].sentiment == 'neutral'
                                                ? Container(
                                                    margin: const EdgeInsets.only(left: 8.0),
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: const Color(0XFFE4C452),
                                                    ),
                                                    child: Text(
                                                      "Neutral",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: text.scale(10),
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox())
                              ]),
                            ),
                            //   Text('CNBC-TV18 Market Live: Sensex Turns Range-Bound, Nifty Around 11,050 Sensex Turns Range-Bound, Nifty Around .',style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Color(0XFF1D1919),),textAlign: TextAlign.justify,),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        modelSetState(() {
                                          kUserSearchController.clear();
                                          onTapType = "liked";
                                          onTapId = newsRelatedResponse.response[index].id;
                                          onLike = true;
                                          onDislike = false;
                                          idKeyMain = "news_id";
                                          apiMain = baseurl + versionLocker + newsLikeDislikeCount;
                                          onTapIdMain = newsRelatedResponse.response[index].id;
                                          onTapTypeMain = "liked";
                                          haveLikesMain = newsRelatedResponse.response[index].likesCount > 0 ? true : false;
                                          haveDisLikesMain = newsRelatedResponse.response[index].disLikesCount > 0 ? true : false;
                                          likesCountMain = newsRelatedResponse.response[index].likesCount;
                                          dislikesCountMain = newsRelatedResponse.response[index].disLikesCount;
                                          kToken = kToken;
                                          loaderMain = false;
                                        });
                                        await customShowSheetNew3(
                                          context: context,
                                          responseCheck: 'feature',
                                        );
                                      },
                                      child: Text(
                                        '${data.response[index].likesCount} Like ',
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(8), color: const Color(0XFFB7B7B7)),
                                      )),
                                  SizedBox(
                                    width: width / 102.75,
                                  ),
                                  VerticalDivider(
                                    color: const Color(0XFFB7B7B7),
                                    width: width / 41.1,
                                  ),
                                  SizedBox(
                                    width: width / 102.75,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        modelSetState(() {
                                          kUserSearchController.clear();
                                          onTapType = "disliked";
                                          onTapId = newsRelatedResponse.response[index].id;
                                          onLike = false;
                                          onDislike = true;
                                          idKeyMain = "news_id";
                                          apiMain = baseurl + versionLocker + newsLikeDislikeCount;
                                          onTapIdMain = newsRelatedResponse.response[index].id;
                                          onTapTypeMain = "disliked";
                                          haveLikesMain = newsRelatedResponse.response[index].likesCount > 0 ? true : false;
                                          haveDisLikesMain = newsRelatedResponse.response[index].disLikesCount > 0 ? true : false;
                                          likesCountMain = newsRelatedResponse.response[index].likesCount;
                                          dislikesCountMain = newsRelatedResponse.response[index].disLikesCount;
                                          kToken = kToken;
                                          loaderMain = false;
                                        });
                                        await customShowSheetNew3(
                                          context: context,
                                          responseCheck: 'feature',
                                        );
                                      },
                                      child: Text(
                                        '${data.response[index].disLikesCount} Dislike ',
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(8), color: const Color(0XFFB7B7B7)),
                                      )),
                                  SizedBox(
                                    width: width / 102.75,
                                  ),
                                  VerticalDivider(
                                    width: width / 41.1,
                                    color: const Color(0XFFB7B7B7),
                                  ),
                                  SizedBox(
                                    width: width / 102.75,
                                  ),
                                  InkWell(
                                      onTap: () {},
                                      child: Text(
                                        '${data.response[index].shareCount}  Shared',
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(8), color: const Color(0XFFB7B7B7)),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0XFFEDEAEA),
                  thickness: 0.8,
                ),
              ],
            ),
          );
        });
  } else if (relatedTopicText.value.toLowerCase() == "videos") {
    RelatedVideosModel videosRelatedResponse = data;
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: videosRelatedResponse.response.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (relatedOnPage.value != 'videos') {
              modelSetState(() {
                listVideoIds.clear();
                for (int i = 0; i < videosRelatedResponse.response.length; i++) {
                  listVideoIds.add(videosRelatedResponse.response[i].id);
                }
                idVideoIndex.value = listVideoIds.indexOf(videosRelatedResponse.response[index].id);
                currentVideosId.value = listVideoIds[idVideoIndex.value];
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => YoutubePlayerLandscapeScreen(
                            id: videosRelatedResponse.response[index].id,
                            comeFrom: "similar",
                          )));
            } else {
              modelSetState(() {
                listVideoIds.clear();
                for (int i = 0; i < videosRelatedResponse.response.length; i++) {
                  listVideoIds.add(videosRelatedResponse.response[i].id);
                }
                idVideoIndex.value = listVideoIds.indexOf(videosRelatedResponse.response[index].id);
                currentVideosId.value = listVideoIds[idVideoIndex.value];
                initFunction();
              });
            }
            /*Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (BuildContext context) {
                  return VideoDescriptionPage(
                    url: metaData[index]["news_url"],
                    category: widget.category==""?"general":widget.category.toLowerCase(),
                    id: metaData[index]["_id"],
                    activity: false,
                    type: "videos",
                    tickerId:metaData[index]["ticker_id"],
                  );
                }));*/
          },
          child: Column(
            children: [
              SizedBox(
                //height: _height/8.42,
                width: width,
                //  margin: EdgeInsets.only(top:_height/51.52,bottom: _height/73),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: height / 8.42,
                          width: width / 2.41,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(image: NetworkImage(videosRelatedResponse.response[index].imageUrl), fit: BoxFit.fill)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: excLabelButton(text: exchangeList[index], context: context),
                        ),
                      ],
                    ),
                    /*  Container(
                                                width: _width/2.41,
                                                child: Image.network( metaData[index]["image_url"],height: _height/6.24,width: _width/2.88,fit: BoxFit.fill,),
                                              ),*/
                    SizedBox(
                      width: width / 27.4,
                    ),
                    //Image.network( metaData[index]["image_url"],height: _height/6.24,width: _width/2.88,fit: BoxFit.fill,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                text: videosRelatedResponse.response[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: text.scale(14), color: const Color(0XFF1D1919), fontFamily: "Poppins"),
                              ),
                              WidgetSpan(
                                  child: videosRelatedResponse.response[index].sentiment == ""
                                      ? const SizedBox()
                                      : videosRelatedResponse.response[index].sentiment == "positive"
                                          ? Container(
                                              margin: const EdgeInsets.only(left: 8.0),
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: const Color(0XFF39B12F),
                                              ),
                                              child: Text(
                                                "Positive",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: text.scale(10),
                                                    color: Colors.white,
                                                    fontFamily: "Poppins"),
                                              ),
                                            )
                                          : videosRelatedResponse.response[index].sentiment == "negative"
                                              ? Container(
                                                  margin: const EdgeInsets.only(left: 8.0),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: const Color(0XFFFA3133),
                                                  ),
                                                  child: Text(
                                                    "Negative",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: text.scale(10),
                                                        color: Colors.white,
                                                        fontFamily: "Poppins"),
                                                  ),
                                                )
                                              : videosRelatedResponse.response[index].sentiment == 'neutral'
                                                  ? Container(
                                                      margin: const EdgeInsets.only(left: 8.0),
                                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: const Color(0XFFE4C452),
                                                      ),
                                                      child: Text(
                                                        "Neutral",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: text.scale(10),
                                                            color: Colors.white,
                                                            fontFamily: "Poppins"),
                                                      ),
                                                    )
                                                  : const SizedBox())
                            ]),
                          ),
                          /* Text(metaData[index]["title"],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12,
                                                          fontFamily: "Poppins"),),*/
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                videosRelatedResponse.response[index].sourceName,
                                style: TextStyle(
                                    fontSize: text.scale(10), color: const Color(0XFFF7931A), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    videosRelatedResponse.response[index].date,
                                    style:
                                        const TextStyle(fontSize: 10, color: Color(0XFFB0B0B0), fontWeight: FontWeight.w900, fontFamily: "Poppins"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 5,
                                    width: 5,
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      modelSetState(() {
                                        kUserSearchController.clear();
                                        onTapType = "Views";
                                        onTapId = videosRelatedResponse.response[index].id;
                                        onLike = false;
                                        onDislike = false;
                                        onViews = true;
                                        idKeyMain = "video_id";
                                        apiMain = baseurl + versionLocker + videoViewCount;
                                        onTapIdMain = videosRelatedResponse.response[index].id;
                                        onTapTypeMain = "Views";
                                        haveLikesMain = videosRelatedResponse.response[index].likesCount > 0 ? true : false;
                                        haveDisLikesMain = videosRelatedResponse.response[index].disLikesCount > 0 ? true : false;
                                        haveViewsMain = videosRelatedResponse.response[index].viewsCount > 0 ? true : false;
                                        likesCountMain = videosRelatedResponse.response[index].likesCount;
                                        dislikesCountMain = videosRelatedResponse.response[index].disLikesCount;
                                        viewCountMain = videosRelatedResponse.response[index].viewsCount;
                                        kToken = kToken;
                                      });
                                      //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionLocker + videoViewCount, idKey: 'video_id', setState: setState);
                                      bool data = await likeCountFunc(context: context, newSetState: modelSetState);
                                      if (data) {
                                        if (!context.mounted) {
                                          return;
                                        }
                                        customShowSheet1(context: context);
                                        modelSetState(() {
                                          loaderMain = true;
                                        });
                                      } else {
                                        if (!context.mounted) {
                                          return;
                                        }
                                        Flushbar(
                                          message: "Still no one has viewed this post",
                                          duration: const Duration(seconds: 2),
                                        ).show(context);
                                      }
                                    },
                                    child: Text(
                                      "${videosRelatedResponse.response[index].viewsCount} Views".toString(),
                                      style:
                                          const TextStyle(fontSize: 10, color: Color(0XFFB0B0B0), fontWeight: FontWeight.w900, fontFamily: "Poppins"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color(0XFFEDEAEA),
                thickness: 0.8,
              ),
              SizedBox(
                height: height / 54.13,
              )
            ],
          ),
        );
      },
    );
  } else if (relatedTopicText.value.toLowerCase() == "forums") {
    RelatedForumsModel forumsRelatedResponse = data;
    if (forumEntry) {
      titlesListMain.clear();
      translationListMain.clear();
      for (int i = 0; i < forumsRelatedResponse.response.length; i++) {
        titlesListMain.add(forumsRelatedResponse.response[i].title);
        translationListMain.add(false);
        isMainLiked.add(forumsRelatedResponse.response[i].likes);
        isMainDisliked.add(forumsRelatedResponse.response[i].dislikes);
        likeMainCount.add(forumsRelatedResponse.response[i].likesCount);
        shareMainCount.add(forumsRelatedResponse.response[i].shareCount);
        viewMainCount.add(forumsRelatedResponse.response[i].viewsCount);
        responseMainCount.add(forumsRelatedResponse.response[i].responseCount);
        disLikeMainCount.add(forumsRelatedResponse.response[i].disLikesCount);
        bookmarkMainList.add(forumsRelatedResponse.response[i].bookmark);
      }
      forumEntry = false;
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: titlesListMain.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () async {
              if (relatedOnPage.value != 'forums') {
                modelSetState(() {
                  listForumsIds.clear();
                  for (int i = 0; i < forumsRelatedResponse.response.length; i++) {
                    listForumsIds.add(forumsRelatedResponse.response[i].id);
                  }
                  idForumIndex.value = listForumsIds.indexOf(forumsRelatedResponse.response[index].id);
                  currentForumsId.value = listForumsIds[idForumIndex.value];
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ForumPostDescriptionPage(
                              forumId: forumsRelatedResponse.response[index].id,
                              comeFrom: "similar",
                              idList: listForumsIds,
                            )));
              } else {
                modelSetState(() {
                  listForumsIds.clear();
                  for (int i = 0; i < forumsRelatedResponse.response.length; i++) {
                    listForumsIds.add(forumsRelatedResponse.response[i].id);
                  }
                  idForumIndex.value = listForumsIds.indexOf(forumsRelatedResponse.response[index].id);
                  currentForumsId.value = listForumsIds[idForumIndex.value];
                  initFunction();
                });
              }
              /*  bool refresh=await Navigator.push(context,
                  MaterialPageRoute(builder:
                      (BuildContext context) {
                    return ForumPostDescriptionPage(
                      forumDetail: forumObject,
                      filterId: widget.filterId,
                      text: widget.text,
                      catIdList: mainCatIdList,
                      forumId: forumIdList[index],
                      navBool: 'forum',
                    );
                  }));
              if(refresh){
                initState();
              }*/
            },
            child: Container(
              margin: EdgeInsets.only(bottom: height / 35),
              decoration: BoxDecoration(
                color: relatedOnPage.value == "news" || relatedOnPage.value == "videos"
                    ? const Color(0XFFF9FFF9)
                    : Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 47.9,
                  ),
                  Container(
                    color: relatedOnPage.value == "news" || relatedOnPage.value == "videos"
                        ? const Color(0XFFF9FFF9)
                        : Theme.of(context).colorScheme.background,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return UserBillBoardProfilePage(userId: forumsRelatedResponse.response[index].userId)
                                      /*UserProfilePage(
                                      id: _forumsRelatedResponse
                                          .response[index].userId,
                                      type: 'forums',
                                      index: 0)*/
                                      ;
                                }));
                              },
                              child: Container(
                                height: height / 13.53,
                                width: width / 6.25,
                                margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.tertiary,
                                    image: DecorationImage(
                                        image: NetworkImage(forumsRelatedResponse.response[index].avatar), //userImage
                                        fit: BoxFit.fill)),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width / 1.65,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: width / 2,
                                          child: Text(
                                            titlesListMain[index], //_forumsRelatedResponse.response[index].title,
                                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
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
                                                    margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child: userIdMain == forumsRelatedResponse.response[index].userId
                                                        ? Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ListTile(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return ForumPostEditPage(
                                                                      text: finalisedCategory.toString().capitalizeFirst!,
                                                                      catIdList: mainCatIdList,
                                                                      filterId: finalisedFilterId,
                                                                      forumId: forumsRelatedResponse.response[index].id,
                                                                    );
                                                                  }));
                                                                },
                                                                minLeadingWidth: width / 25,
                                                                leading: const Icon(
                                                                  Icons.edit,
                                                                  size: 20,
                                                                ),
                                                                title: Text(
                                                                  "Edit Post",
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                ),
                                                              ),
                                                              Divider(
                                                                color: Theme.of(context).colorScheme.tertiary,
                                                                thickness: 0.8,
                                                              ),
                                                              ListTile(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                  showDialog(
                                                                      barrierDismissible: false,
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return Dialog(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                          //this right here
                                                                          child: Container(
                                                                            height: height / 6,
                                                                            margin: EdgeInsets.symmetric(
                                                                                vertical: height / 54.13, horizontal: width / 25),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const Center(
                                                                                    child: Text("Delete Respond",
                                                                                        style: TextStyle(
                                                                                            color: Color(0XFF0EA102),
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 20,
                                                                                            fontFamily: "Poppins"))),
                                                                                const Divider(),
                                                                                const Center(child: Text("Are you sure to Delete this Post")),
                                                                                const Spacer(),
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: const Text(
                                                                                          "Cancel",
                                                                                          style: TextStyle(
                                                                                              color: Colors.grey,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontFamily: "Poppins",
                                                                                              fontSize: 15),
                                                                                        ),
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(18.0),
                                                                                          ),
                                                                                          backgroundColor: Colors.green,
                                                                                        ),
                                                                                        onPressed: () async {
                                                                                          Navigator.pop(context);
                                                                                          await deletePostMain(
                                                                                            id: forumsRelatedResponse.response[index].id,
                                                                                            context: context,
                                                                                            locker: 'forum',
                                                                                          );
                                                                                          initFunction();
                                                                                          //await getRelatedForums(forumId: forumObject['_id'], category: widget.text);
                                                                                        },
                                                                                        child: const Text(
                                                                                          "Continue",
                                                                                          style: TextStyle(
                                                                                              color: Colors.white,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontFamily: "Poppins",
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
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ListTile(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                  mainVariables.barController.clear();
                                                                  modelSetState(() {
                                                                    mainVariables.actionValueMain = "Report";
                                                                  });
                                                                  showAlertDialogMain(
                                                                      context: context,
                                                                      id: forumsRelatedResponse.response[index].id,
                                                                      userId: forumsRelatedResponse.response[index].userId,
                                                                      initFunction: initFunction,
                                                                      modelSetState: modelSetState,
                                                                      locker: 'forum');
                                                                },
                                                                minLeadingWidth: width / 25,
                                                                leading: const Icon(
                                                                  Icons.shield,
                                                                  size: 20,
                                                                ),
                                                                title: Text(
                                                                  "Report Post",
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                ),
                                                              ),
                                                              Divider(
                                                                color: Theme.of(context).colorScheme.tertiary,
                                                                thickness: 0.8,
                                                              ),
                                                              ListTile(
                                                                onTap: () {
                                                                  mainVariables.barController.clear();
                                                                  modelSetState(() {
                                                                    mainVariables.actionValueMain = "Block";
                                                                  });

                                                                  Navigator.pop(context);
                                                                  showAlertDialogMain(
                                                                      context: context,
                                                                      id: forumsRelatedResponse.response[index].id,
                                                                      userId: forumsRelatedResponse.response[index].userId,
                                                                      initFunction: initFunction,
                                                                      modelSetState: modelSetState,
                                                                      locker: 'forum');
                                                                },
                                                                minLeadingWidth: width / 25,
                                                                leading: const Icon(
                                                                  Icons.flag,
                                                                  size: 20,
                                                                ),
                                                                title: Text(
                                                                  "Block Post",
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.more_horiz,
                                              size: 20,
                                              color: Theme.of(context).colorScheme.onPrimary,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return UserBillBoardProfilePage(userId: forumsRelatedResponse.response[index].userId)
                                          /*UserProfilePage(
                                          id: _forumsRelatedResponse
                                              .response[index].userId,
                                          type: 'forums',
                                          index: 0)*/
                                          ;
                                    }));
                                  },
                                  child: SizedBox(
                                      height: height / 54.13,
                                      child: Text(
                                        forumsRelatedResponse.response[index].userName, //userName
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                      )),
                                ),
                                SizedBox(
                                  height: height / 54.13,
                                ),
                                SizedBox(
                                  width: width / 1.6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height / 45.11,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                modelSetState(() {
                                                  isMainLiked[index] = !isMainLiked[index];
                                                  isMainDisliked[index] = false;
                                                });
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                String mainUserToken = prefs.getString('newUserToken') ?? "";
                                                var uri = Uri.parse(baseurl + versionLocker + likes);
                                                var response = await http.post(uri, headers: {
                                                  "authorization": mainUserToken,
                                                }, body: {
                                                  "id": forumsRelatedResponse.response[index].id,
                                                  "type": "forums",
                                                });
                                                var responseData = jsonDecode(response.body);
                                                if (responseData['status'] == true) {
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  Flushbar(
                                                    message: responseData['message'],
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                } else {
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  Flushbar(
                                                    message: responseData['message'],
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                }
                                                bool response1 = responseData['status'];
                                                if (response1) {
                                                  logEventFunc(name: "Likes", type: "Forum");
                                                  if (isMainLiked[index] == true) {
                                                    if (isMainDisliked[index] == true) {
                                                    } else {
                                                      likeMainCount[index] -= 1;
                                                    }
                                                  } else {
                                                    if (isMainDisliked[index] == true) {
                                                      disLikeMainCount[index] -= 1;
                                                      likeMainCount[index] += 1;
                                                    } else {
                                                      likeMainCount[index] += 1;
                                                    }
                                                  }
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(right: width / 25),
                                                height: height / 40.6,
                                                width: width / 18.75,
                                                child: isMainLiked[index] //like or not like
                                                    ? SvgPicture.asset(
                                                        isDarkTheme.value
                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                      )
                                                    : SvgPicture.asset(
                                                        isDarkTheme.value
                                                            ? "assets/home_screen/like_dark.svg"
                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                      ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                String mainUserToken = prefs.getString('newUserToken') ?? '';
                                                logEventFunc(name: "Share", type: "Forum");
                                                String type = 'forums';
                                                String category = finalisedCategory.toLowerCase();
                                                String filterId = finalisedFilterId;
                                                final dynamicLinkParams = DynamicLinkParameters(
                                                    uriPrefix: domainLink,
                                                    link: Uri.parse(
                                                        '$domainLink/ForumPostDescriptionPage/${forumsRelatedResponse.response[index].id}/$type/$category/$filterId'),
                                                    androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
                                                    iosParameters:
                                                        const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
                                                    socialMetaTagParameters: SocialMetaTagParameters(
                                                        title: forumsRelatedResponse.response[index].title,
                                                        description: '',
                                                        imageUrl: Uri.parse("")));
                                                final dynamicLink = await FirebaseDynamicLinks.instance
                                                    .buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
                                                Uri newLink = dynamicLink.shortUrl;
                                                /* await getLinK(
                                                    id: forumIdList[
                                                    index],
                                                    type:
                                                    "forums",
                                                    description:
                                                    '',
                                                    imageUrl: "",
                                                    title:
                                                    forumTitlesList[index],
                                                    category: widget.text,
                                                    filterId: widget.filterId);*/
                                                ShareResult result = await Share.share(
                                                  "Look what I was able to find on Tradewatch: ${forumsRelatedResponse.response[index].title} ${newLink.toString()}",
                                                );
                                                if (result.status == ShareResultStatus.success) {
                                                  var uri = Uri.parse(baseurl + versionLocker + share);
                                                  var response = await http.post(uri, headers: {
                                                    "authorization": mainUserToken,
                                                  }, body: {
                                                    "id": forumsRelatedResponse.response[index].id,
                                                    "type": 'forums'
                                                  });
                                                  var responseData = jsonDecode(response.body);
                                                  if (responseData['status'] == true) {
                                                  } else {
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    Flushbar(
                                                      message: responseData['message'],
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                  height: height / 40.6,
                                                  width: width / 18.75,
                                                  margin: EdgeInsets.only(right: width / 25),
                                                  child: SvgPicture.asset(
                                                    isDarkTheme.value
                                                        ? "assets/home_screen/share_dark.svg"
                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                String mainUserToken = prefs.getString('newUserToken') ?? "";
                                                var uri = Uri.parse(baseurl + versionLocker + dislikes);
                                                var response = await http.post(uri, headers: {
                                                  "authorization": mainUserToken,
                                                }, body: {
                                                  "id": forumsRelatedResponse.response[index].id,
                                                  "type": "forums"
                                                });
                                                var responseData = jsonDecode(response.body);
                                                if (responseData['status'] == true) {
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  Flushbar(
                                                    message: responseData['message'],
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                } else {
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  Flushbar(
                                                    message: responseData['message'],
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                }
                                                bool response3 = responseData['status'];
                                                if (response3) {
                                                  logEventFunc(name: "Dislikes", type: "Forum");
                                                  modelSetState(() {
                                                    if (isMainDisliked[index] == true) {
                                                      if (isMainLiked[index] == true) {
                                                      } else {
                                                        disLikeMainCount[index] -= 1;
                                                      }
                                                    } else {
                                                      if (isMainLiked[index] == true) {
                                                        likeMainCount[index] -= 1;
                                                        disLikeMainCount[index] += 1;
                                                      } else {
                                                        disLikeMainCount[index] += 1;
                                                      }
                                                    }
                                                    modelSetState(() {
                                                      isMainDisliked[index] = !isMainDisliked[index];
                                                      isMainLiked[index] = false;
                                                    });
                                                  });
                                                } else {}
                                              },
                                              child: Container(
                                                height: height / 40.6,
                                                width: width / 18.75,
                                                margin: EdgeInsets.only(right: width / 25),
                                                child: isMainDisliked[index] //dislike or not dislike
                                                    ? SvgPicture.asset(
                                                        isDarkTheme.value
                                                            ? "assets/home_screen/dislike_filled_dark.svg"
                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                      )
                                                    : SvgPicture.asset(
                                                        isDarkTheme.value
                                                            ? "assets/home_screen/dislike_dark.svg"
                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                      ),
                                              ),
                                            ),
                                            Container(
                                                height: height / 40.6,
                                                width: width / 18.75,
                                                margin: EdgeInsets.only(right: width / 25),
                                                child: SvgPicture.asset(
                                                  "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                  colorFilter: ColorFilter.mode(
                                                      isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102), BlendMode.srcIn),
                                                )),
                                            bookMarkWidget(
                                                bookMark: bookmarkMainList,
                                                id: forumsRelatedResponse.response[index].id,
                                                type: 'forums',
                                                context: context,
                                                scale: 3.2,
                                                modelSetState: modelSetState,
                                                index: index,
                                                initFunction: initFunction,
                                                notUse: false),
                                          ],
                                        ),
                                      ),
                                      widgetsMain.translationWidget(
                                        id: forumsRelatedResponse.response[index].id,
                                        type: 'forums',
                                        index: index,
                                        initFunction: initFunction,
                                        context: context,
                                        modelSetState: modelSetState,
                                        notUse: false,
                                        translationList: translationListMain,
                                        titleList: titlesListMain,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height / 81.2,
                                ),
                                SizedBox(
                                  height: height / 54.13,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width / 7.5,
                                        child: Text(forumsRelatedResponse.response[index].companyName,
                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700, color: Colors.blue)),
                                      ),
                                      SizedBox(width: width / 22.05),
                                      GestureDetector(
                                        onTap: () async {
                                          modelSetState(() {
                                            kUserSearchController.clear();
                                            onTapType = "Views";
                                            onTapId = forumsRelatedResponse.response[index].id;
                                            onLike = false;
                                            onDislike = false;
                                            onViews = true;
                                            idKeyMain = "forum_id";
                                            apiMain = baseurl + versionForum + viewsCount;
                                            onTapIdMain = forumsRelatedResponse.response[index].id;
                                            onTapTypeMain = "Views";
                                            haveViewsMain = forumsRelatedResponse.response[index].viewsCount > 0 ? true : false;
                                            viewCountMain = forumsRelatedResponse.response[index].viewsCount;
                                            kToken = kToken;
                                          });
                                          //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionForum + viewsCount, idKey: 'forum_id', setState: setState);
                                          bool data = await likeCountFunc(context: context, newSetState: modelSetState);
                                          if (data) {
                                            if (!context.mounted) {
                                              return;
                                            }
                                            customShowSheet1(context: context);
                                            modelSetState(() {
                                              loaderMain = true;
                                            });
                                          } else {
                                            if (!context.mounted) {
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
                                            Text(forumsRelatedResponse.response[index].viewsCount.toString(),
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                            Text(" views", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: width / 22.05),
                                      Text(forumsRelatedResponse.response[index].responseCount.toString(),
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                      Text(" Response", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        /* Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .vertical(
                                        top: Radius
                                            .circular(
                                            30),
                                      ),
                                    ),
                                    context: context,
                                    builder:
                                        (BuildContext
                                    context) {
                                      return SingleChildScrollView(
                                        child:
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                              _width /
                                                  18.75),
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(
                                                  context)
                                                  .viewInsets
                                                  .bottom),
                                          child: userIdMain==_forumsRelatedResponse.response[index].userId
                                              ? Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                onTap: (){
                                                  if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                    return ForumPostEditPage(
                                                        text: finalisedCategory.toString().capitalizeFirst!,
                                                        catIdList: mainCatIdList,
                                                        filterId: finalisedFilterId,
                                                        forumId: _forumsRelatedResponse.response[index].id,
                                                    );
                                                  }));
                                                },
                                                minLeadingWidth: _width/25,
                                                leading: Icon(Icons.edit, size: 20,),
                                                title: Text("Edit Post",style: TextStyle(fontWeight: FontWeight.w500,fontSize: _text*14),),
                                              ),
                                              ListTile(
                                                onTap:
                                                    () {
                                                  if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                          child: Container(
                                                            height: _height / 6,
                                                            margin: EdgeInsets.symmetric(vertical: _height / 54.13, horizontal: _width / 25),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Center(child: Text("Delete Respond", style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Poppins"))),
                                                                Divider(),
                                                                Container(child: Center(child: Text("Are you sure to Delete this Post"))),
                                                                Spacer(),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: _width / 25),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                                        },
                                                                        child: Text(
                                                                          "Cancel",
                                                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(18.0),
                                                                          ),
                                                                          backgroundColor: Colors.green,
                                                                        ),
                                                                        onPressed: () async {
                                                                          if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                                          await deletePostMain(id: _forumsRelatedResponse.response[index].id,context: context, locker: 'forum',);
                                                                          initFunction();
                                                                          //await getRelatedForums(forumId: forumObject['_id'], category: widget.text);
                                                                        },
                                                                        child: Text(
                                                                          "Continue",
                                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
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
                                                minLeadingWidth:
                                                _width / 25,
                                                leading:
                                                Icon(
                                                  Icons.delete,
                                                  size:
                                                  20,
                                                ),
                                                title:
                                                Text(
                                                  "Delete Post",
                                                  style:
                                                  TextStyle(fontWeight: FontWeight.w500, fontSize: _text.scale(20)14),
                                                ),
                                              ),
                                            ],
                                          )
                                              : Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                  barController.clear();
                                                  modelSetState(() {
                                                    actionValueMain = "Report";
                                                  });
                                                  showAlertDialogMain(context: context, id: _forumsRelatedResponse.response[index].id, userId: _forumsRelatedResponse.response[index].userId,  initFunction: initFunction, modelSetState:modelSetState, locker: 'forum');
                                                },
                                                minLeadingWidth: _width / 25,
                                                leading: Icon(
                                                  Icons.shield,
                                                  size: 20,
                                                ),
                                                title: Text(
                                                  "Report Post",
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: _text.scale(20)14),
                                                ),
                                              ),
                                              Divider(
                                                thickness: 0.0,
                                                height: 0.0,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  barController.clear();
                                                  modelSetState(() {
                                                    actionValueMain = "Block";
                                                  });
                                                  if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                                  showAlertDialogMain(context: context, id: _forumsRelatedResponse.response[index].id, userId: _forumsRelatedResponse.response[index].userId, initFunction: initFunction, modelSetState: modelSetState, locker: 'forum');
                                                },
                                                minLeadingWidth: _width / 25,
                                                leading: Icon(
                                                  Icons.flag,
                                                  size: 20,
                                                ),
                                                title: Text(
                                                  "Block Post",
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: _text.scale(20)14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.only(right: _width / 23.4375),
                                  child: Icon(
                                    Icons.more_horiz,
                                    size: 20,
                                  )),
                            ),
                            SizedBox(height: 20,),
                            widgetsMain.translationWidget(
                                id: _forumsRelatedResponse.response[index].id,
                                type: 'forums',
                                index: index,
                                initFunction: initFunction,
                                context: context,
                                modelSetState: modelSetState,
                                notUse: false,
                              translationList: translationListMain,
                              titleList: titlesListMain,
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 47.9,
                  ),
                ],
              ),
            ));
      },
    );
  } else if (relatedTopicText.value.toLowerCase() == "surveys") {
    RelatedSurveyModel surveysRelatedResponse = data;
    if (surveyEntry) {
      context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
      titlesListMain.clear();
      translationListMain.clear();
      for (int i = 0; i < surveysRelatedResponse.response.length; i++) {
        bookmarkMainList.add(surveysRelatedResponse.response[i].bookmark);
        titlesListMain.add(surveysRelatedResponse.response[i].title);
        translationListMain.add(false);
      }
      surveyEntry = false;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: surveysRelatedResponse.response.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () async {
              String activeStatus = "";
              bool answerStatus = false;
              int answeredQuestion = 0;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String mainUserId = prefs.getString('newUserId') ?? "";
              String mainUserToken = prefs.getString('newUserToken') ?? "";
              var url = Uri.parse(baseurl + versionSurvey + surveyStatusCheck);
              var response = await http.post(url, headers: {
                'Authorization': mainUserToken
              }, body: {
                'survey_id': surveysRelatedResponse.response[index].id,
              });
              var responseData = json.decode(response.body);
              if (responseData["status"]) {
                activeStatus = responseData["response"]["status"];

                if (activeStatus == "active") {
                  var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                  var response = await http.post(url, headers: {
                    'Authorization': mainUserToken
                  }, body: {
                    'survey_id': surveysRelatedResponse.response[index].id,
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
              if (!context.mounted) {
                return;
              }
              mainUserId == surveysRelatedResponse.response[index].userId
                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return AnalyticsPage(
                        surveyId: surveysRelatedResponse.response[index].id,
                        activity: false,
                        surveyTitle: surveysRelatedResponse.response[index].title,
                        navBool: false,
                        fromWhere: 'similar',
                      );
                    }))
                  : activeStatus == 'active'
                      ? answerStatus
                          ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return AnalyticsPage(
                                  surveyId: surveysRelatedResponse.response[index].id,
                                  activity: false,
                                  navBool: false,
                                  fromWhere: 'similar',
                                  surveyTitle: surveysRelatedResponse.response[index].title);
                            }))
                          : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return QuestionnairePage(
                                surveyId: surveysRelatedResponse.response[index].id,
                                defaultIndex: answeredQuestion,
                              );
                            }))
                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return AnalyticsPage(
                            surveyId: surveysRelatedResponse.response[index].id,
                            activity: false,
                            surveyTitle: surveysRelatedResponse.response[index].title,
                            navBool: false,
                            fromWhere: 'similar',
                          );
                        }));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: height / 35),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: relatedOnPage.value == "news" || relatedOnPage.value == "videos" ? const Color(0XFFF9FFF9) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 1, spreadRadius: 1)]),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: relatedOnPage.value == "news" || relatedOnPage.value == "videos" ? const Color(0XFFF9FFF9) : Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return UserBillBoardProfilePage(
                                    userId: surveysRelatedResponse.response[index].userId,
                                  )
                                      /*UserProfilePage(
                                      id: _surveysRelatedResponse
                                          .response[index].userId,
                                      type: 'survey',
                                      index: 1)*/
                                      ;
                                }));
                              },
                              child: Container(
                                height: height / 13.53,
                                width: width / 5.95,
                                margin: EdgeInsets.fromLTRB(width / 23.43, height / 203, width / 37.5, height / 27.06),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                    image: DecorationImage(image: NetworkImage(surveysRelatedResponse.response[index].avatar), fit: BoxFit.fill)),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: width / 1.95,
                                    child: Text(
                                      surveysRelatedResponse.response[index].title,
                                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                    )),
                                /*Container(
                                                            width: _width/1.95,
                                                            child: Text(surveySourceNameList[index],style: TextStyle(fontSize: _text*10,fontWeight: FontWeight.w500),)
                                                        ),*/
                                SizedBox(
                                    height: height / 54.13,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return UserBillBoardProfilePage(
                                                  userId: surveysRelatedResponse.response[index].userId,
                                                )
                                                    /*UserProfilePage(
                                                  id: _surveysRelatedResponse.response[index].userId,
                                                  type: 'survey',
                                                  index: 1,
                                                )*/
                                                    ;
                                              }));
                                            },
                                            child: Text(
                                              surveysRelatedResponse.response[index].username,
                                              style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 5,
                                          width: 5,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          surveysRelatedResponse.response[index].questionCount.toString(),
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          " Questions",
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: height / 87.6,
                                ),
                                bookMarkWidget(
                                    bookMark: bookmarkMainList,
                                    context: context,
                                    scale: 3.2,
                                    id: surveysRelatedResponse.response[index].id,
                                    type: 'surveys',
                                    modelSetState: modelSetState,
                                    index: index,
                                    initFunction: initFunction,
                                    notUse: false),
                                SizedBox(
                                  height: height / 87.6,
                                ),
                                SizedBox(
                                  height: height / 54.13,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: width / 7.5,
                                          child: Text(surveysRelatedResponse.response[index].companyName,
                                              style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700, color: Colors.blue))),
                                      /*Container(
                                                                  height:_height/162,width: _width/75,decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xffC4C4C4),)),*/
                                      SizedBox(width: width / 22.05),
                                      GestureDetector(
                                        onTap: () async {
                                          modelSetState(() {
                                            kUserSearchController.clear();
                                            onTapType = "Views";
                                            onTapId = surveysRelatedResponse.response[index].id;
                                            onLike = false;
                                            onDislike = false;
                                            onViews = true;
                                            idKeyMain = "survey_id";
                                            apiMain = baseurl + versionSurvey + viewsCount;
                                            onTapIdMain = surveysRelatedResponse.response[index].id;
                                            onTapTypeMain = "Views";
                                            haveViewsMain = surveysRelatedResponse.response[index].viewsCount > 0 ? true : false;
                                            viewCountMain = surveysRelatedResponse.response[index].viewsCount;
                                            kToken = kToken;
                                          });
                                          //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionSurvey + viewsCount, idKey: 'survey_id', setState: setState);
                                          bool data = await likeCountFunc(context: context, newSetState: modelSetState);
                                          if (data) {
                                            if (!context.mounted) {
                                              return;
                                            }
                                            customShowSheet1(context: context);
                                            modelSetState(() {
                                              loaderMain = true;
                                            });
                                          } else {
                                            if (!context.mounted) {
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
                                            Text(surveysRelatedResponse.response[index].viewsCount.toString(),
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                            Text(" Views", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
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
                                            Text(surveysRelatedResponse.response[index].answersCount.toString(),
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                            Text(" Responses", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
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
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: userIdMain == surveysRelatedResponse.response[index].userId
                                              ? ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                            //this right here
                                                            child: Container(
                                                              height: height / 6,
                                                              margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Center(
                                                                      child: Text("Delete Post",
                                                                          style: TextStyle(
                                                                              color: Color(0XFF0EA102),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20,
                                                                              fontFamily: "Poppins"))),
                                                                  const Divider(),
                                                                  const Center(child: Text("Are you sure to Delete this Post")),
                                                                  const Spacer(),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text(
                                                                            "Cancel",
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "Poppins",
                                                                                fontSize: 15),
                                                                          ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ),
                                                                            backgroundColor: const Color(0XFF0EA102),
                                                                          ),
                                                                          onPressed: () async {
                                                                            deletePostMain(
                                                                                id: surveysRelatedResponse.response[index].id,
                                                                                context: context,
                                                                                locker: 'survey');

                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text(
                                                                            "Continue",
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "Poppins",
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
                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        mainVariables.barController.clear();
                                                        modelSetState(() {
                                                          mainVariables.actionValueMain = "Report";
                                                        });
                                                        showAlertDialogMain(
                                                            context: context,
                                                            id: surveysRelatedResponse.response[index].id,
                                                            userId: surveysRelatedResponse.response[index].userId,
                                                            initFunction: initFunction,
                                                            modelSetState: modelSetState,
                                                            locker: 'survey');
                                                      },
                                                      minLeadingWidth: width / 25,
                                                      leading: const Icon(
                                                        Icons.shield,
                                                        size: 20,
                                                      ),
                                                      title: Text(
                                                        "Report Post",
                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 0.0,
                                                      height: 0.0,
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        mainVariables.barController.clear();
                                                        modelSetState(() {
                                                          mainVariables.actionValueMain = "Block";
                                                        });

                                                        Navigator.pop(context);
                                                        showAlertDialogMain(
                                                            context: context,
                                                            id: surveysRelatedResponse.response[index].id,
                                                            userId: surveysRelatedResponse.response[index].userId,
                                                            initFunction: initFunction,
                                                            modelSetState: modelSetState,
                                                            locker: 'survey');
                                                      },
                                                      minLeadingWidth: width / 25,
                                                      leading: const Icon(
                                                        Icons.flag,
                                                        size: 20,
                                                      ),
                                                      title: Text(
                                                        "Block Post",
                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                  padding: EdgeInsets.only(right: width / 23.4375),
                                  child: const Icon(
                                    Icons.more_horiz,
                                    size: 20,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            widgetsMain.translationWidget(
                              id: surveysRelatedResponse.response[index].id,
                              type: 'survey',
                              index: index,
                              initFunction: initFunction,
                              context: context,
                              modelSetState: modelSetState,
                              notUse: false,
                              translationList: translationListMain,
                              titleList: titlesListMain,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  } else {}
}

lockerCategories({
  required BuildContext context,
  required Function initFunction,
}) {
  List<String> imagesList = [
    "lib/Constants/Assets/SMLogos/LockerScreen/newsPaper.png",
    "lib/Constants/Assets/SMLogos/LockerScreen/VideosBottom.png",
    "lib/Constants/Assets/SMLogos/LockerScreen/Forums.png",
    "lib/Constants/Assets/SMLogos/LockerScreen/Surveys.png"
  ];
  List<String> titleList = ["News", "Videos", "Forums", "Surveys"];
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
      builder: (BuildContext context) {
        int radioIndex = titleList.indexOf(relatedTopicText.value);
        return StatefulBuilder(builder: (BuildContext context, StateSetter modelSetState) {
          return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: height / 57.73),
              shrinkWrap: true,
              itemCount: titleList.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<int>(
                  value: index,
                  groupValue: radioIndex,
                  onChanged: (value) {
                    if (mainSkipValue) {
                      if (index <= 1) {
                        modelSetState(() {
                          Navigator.pop(context);
                          radioIndex = int.parse(value.toString());
                          relatedTopicText.value = titleList[radioIndex];
                          forumEntry = true;
                          surveyEntry = true;
                          isMainLiked.clear();
                          isMainDisliked.clear();
                          bookmarkMainList.clear();
                          likeMainCount.clear();
                          shareMainCount.clear();
                          viewMainCount.clear();
                          responseMainCount.clear();
                          disLikeMainCount.clear();
                        });
                        initFunction();
                      } else {
                        Navigator.pop(context);
                        commonFlushBar(context: context, initFunction: initFunction);
                      }
                    } else {
                      modelSetState(() {
                        Navigator.pop(context);
                        radioIndex = int.parse(value.toString());
                        relatedTopicText.value = titleList[radioIndex];
                        forumEntry = true;
                        surveyEntry = true;
                        isMainLiked.clear();
                        isMainDisliked.clear();
                        bookmarkMainList.clear();
                        likeMainCount.clear();
                        shareMainCount.clear();
                        viewMainCount.clear();
                        responseMainCount.clear();
                        disLikeMainCount.clear();
                      });
                      initFunction();
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  secondary: Container(
                      height: height / 19.68,
                      width: width / 9.34,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF169A0D)),
                      child: Center(
                          child: Image.asset(
                        imagesList[index],
                        height: height / 34.64,
                        width: width / 16.44,
                      ))),
                  title: Text(
                    titleList[index],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(12), color: const Color(0XFF2C3335)),
                  ),
                );
              });
        });
      });
}

getLogout({required String emailNew}) async {
  var url = Uri.parse(baseurl + versions + logout);
  final responseData = await http.post(url, body: {"email": emailNew});
  if (responseData.statusCode == 200) {
  } else {}
}

resetLogin({required AuthFunctions authFunctions}) async {
  authFunctions.signOutUser();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
  prefs.clear();
  bool privacyAccept = true;
  mainSkipValue = true;
  prefs.setBool('privacyAccept', privacyAccept);
  prefs.setBool('skipValue', mainSkipValue);
}

swipeLeftAnimation({required BuildContext context}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Lottie.asset('lib/Constants/Assets/SMLogos/Swipe-Final.json', height: height / 2.88, width: width / 1.37);
}

deletePostMain({required BuildContext context, required String id, required String locker}) async {
  var url = locker == 'forum' ? Uri.parse(baseurl + versionForum + forumDelete) : Uri.parse(baseurl + versionSurvey + deleteSurvey);
  var responseNew = await http.post(url, body: locker == 'forum' ? {"forum_id": id} : {"survey_id": id}, headers: {'Authorization': kToken});
  var responseDataNew = json.decode(responseNew.body);
  if (responseDataNew["status"]) {
    if (!context.mounted) {
      return;
    }
    Flushbar(
      message: responseDataNew["message"],
      duration: const Duration(seconds: 2),
    ).show(context);
    // getForumValues(text: "",category: widget.text,filterId: widget.filterId, topic: widget.topic);
  } else {
    if (!context.mounted) {
      return;
    }
    Flushbar(
      message: responseDataNew["message"],
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}

reportPostMain(
    {required String action,
    required String why,
    required BuildContext context,
    required String description,
    required String locker,
    required String id,
    required String userId}) async {
  Map<String, dynamic> data1 = {};
  if (why == "Other") {
    if (description == "") {
      Flushbar(
        message: "Please describe the reason in the description ",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      var url = locker == "forum" ? Uri.parse(baseurl + versionForum + addReport) : Uri.parse(baseurl + versionSurvey + surveyAddReport);
      data1 = locker == "forum"
          ? {
              "action": action,
              "why": why,
              "description": description,
              "forum_id": id,
              "forum_user": userId,
            }
          : {"action": action, "why": why, "description": description, "survey_id": id, "survey_user": userId};
      var responseNew = await http.post(url, body: data1, headers: {'Authorization': kToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (!context.mounted) {
          return;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!context.mounted) {
          return;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  } else {
    var url = locker == "forum" ? Uri.parse(baseurl + versionForum + addReport) : Uri.parse(baseurl + versionSurvey + surveyAddReport);
    data1 = locker == "forum"
        ? {
            "action": action,
            "why": why,
            "description": description,
            "forum_id": id,
            "forum_user": userId,
          }
        : {"action": action, "why": why, "description": description, "survey_id": id, "survey_user": userId};
    var responseNew = await http.post(url, body: data1, headers: {'Authorization': kToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }
}

void showAlertDialogMain(
    {required BuildContext context,
    required Function initFunction,
    required StateSetter modelSetState,
    required String locker,
    required String id,
    required String userId}) {
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
                      mainVariables.actionValueMain == "Report"
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
                              items: mainVariables.actionListMain
                                  .map((label) => DropdownMenuItem<String>(
                                      value: label,
                                      child: Text(
                                        label,
                                        style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                      )))
                                  .toList(),
                              value: mainVariables.actionValueMain,
                              onChanged: (String? value) {
                                modelSetState(() {
                                  mainVariables.actionValueMain = value!;
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
                              items: mainVariables.whyListMain
                                  .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                        ),
                                      ))
                                  .toList(),
                              value: mainVariables.whyValueMain,
                              onChanged: (String? value) {
                                modelSetState(() {
                                  mainVariables.whyValueMain = value!;
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
                  controller: mainVariables.barController,
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
                  onTap: () async {
                    logEventFunc(name: mainVariables.actionValueMain == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Forum');
                    reportPostMain(
                        action: mainVariables.actionValueMain,
                        why: mainVariables.whyValueMain,
                        context: context,
                        description: mainVariables.barController.text,
                        id: id,
                        userId: userId,
                        locker: locker);
                    initFunction();

                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: isDarkTheme.value
                          ? const Color(0xff464646)
                          : mainVariables.actionValueMain == "Report"
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

Widget bookMarkWidget({
  required List<bool> bookMark,
  required String id,
  required String type,
  required int index,
  required BuildContext context,
  double? scale,
  Color? color,
  bool? enabled,
  required Function initFunction,
  required StateSetter modelSetState,
  required bool notUse,
}) {
  return BlocBuilder<BookMarkWidgetBloc, BookMarkWidgetState>(
    builder: (context, state) {
      if (state is LoadedState) {
        return GestureDetector(
            onTap: enabled == false
                ? () {}
                : () async {
                    if (mainSkipValue) {
                      commonFlushBar(context: context, initFunction: initFunction);
                    } else {
                      context.read<BookMarkWidgetBloc>().add(InitialEvent(
                          id: id, type: type, bookmark: state.bookMark, index: index, context: context, initFunction: notUse ? initFunction : () {}));
                    }
                  },
            child: Image.asset(
              state.bookMark[index]
                  ? isDarkTheme.value
                      ? "assets/home_screen/bookmark_filled_dark.png"
                      : "assets/home_screen/bookmark_filled.png"
                  : isDarkTheme.value
                      ? "assets/home_screen/bookmark_dark.png"
                      : "assets/home_screen/bookmark.png",
              scale: 4,
              // color: color ?? const Color(0XFF169A0D),
            ));
      } else {
        return GestureDetector(
            onTap: enabled == false
                ? () {}
                : () async {
                    if (mainSkipValue) {
                      commonFlushBar(context: context, initFunction: initFunction);
                    } else {
                      context.read<BookMarkWidgetBloc>().add(InitialEvent(
                          id: id, type: type, bookmark: bookMark, index: index, context: context, initFunction: notUse ? initFunction : () {}));
                    }
                  },
            child: Image.asset(
              bookMark[index]
                  ? isDarkTheme.value
                      ? "assets/home_screen/bookmark_filled_dark.png"
                      : "assets/home_screen/bookmark_filled.png"
                  : isDarkTheme.value
                      ? "assets/home_screen/bookmark_dark.png"
                      : "assets/home_screen/bookmark.png",
              scale: 4,
              // color: color ?? const Color(0XFF169A0D),
            ));
      }
    },
  );
}

Widget bookMarkWidgetSingle(
    {required List<bool> bookMark,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    Color? color,
    bool? enabled,
    Function? initFunction,
    required StateSetter modelSetState}) {
  return BlocBuilder<BookMarkSingleWidgetBloc, BookMarkSingleWidgetState>(
    builder: (context, state) {
      if (state is BookLoadedState) {
        return GestureDetector(
            onTap: enabled == false
                ? () {}
                : () async {
                    if (mainSkipValue) {
                      commonFlushBar(context: context, initFunction: initFunction);
                    } else {
                      context
                          .read<BookMarkSingleWidgetBloc>()
                          .add(BookInitialEvent(id: id, type: type, bookmark: state.bookMark, index: 0, context: context));
                    }
                  },
            child: Image.asset(
              state.bookMark
                  ? isDarkTheme.value
                      ? "assets/home_screen/bookmark_filled_dark.png"
                      : "assets/home_screen/bookmark_filled.png"
                  : isDarkTheme.value
                      ? "assets/home_screen/bookmark_dark.png"
                      : "assets/home_screen/bookmark.png",
              scale: 4,
              // color: color ?? const Color(0XFF169A0D),
            ));
      } else {
        return GestureDetector(
            onTap: enabled == false
                ? () {}
                : () async {
                    if (mainSkipValue) {
                      commonFlushBar(context: context, initFunction: initFunction);
                    } else {
                      context
                          .read<BookMarkSingleWidgetBloc>()
                          .add(BookInitialEvent(id: id, type: type, bookmark: bookMark[0], index: 0, context: context));
                    }
                  },
            child: Image.asset(
              bookMark[0]
                  ? isDarkTheme.value
                      ? "assets/home_screen/bookmark_filled_dark.png"
                      : "assets/home_screen/bookmark_filled.png"
                  : isDarkTheme.value
                      ? "assets/home_screen/bookmark_dark.png"
                      : "assets/home_screen/bookmark.png",
              scale: 4,
              // color: color ?? const Color(0XFF169A0D),
            ));
      }
    },
  );
}

Widget bookMarkWidgetMultiple(
    {required List<List<bool>> bookMark,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    required Function initFunction}) {
  int lockerIndex = type == 'news'
      ? 0
      : type == 'videos'
          ? 1
          : type == 'forums'
              ? 2
              : type == 'survey'
                  ? 3
                  : type == 'users'
                      ? 4
                      : type == 'billboard'
                          ? 5
                          : 6;
  return BlocBuilder<BookMarkMultipleWidgetBloc, BookMarkMultipleWidgetState>(
    builder: (context, state) {
      if (state is MultipleLoadedState) {
        return GestureDetector(
            onTap: () async {
              context.read<BookMarkMultipleWidgetBloc>().add(MultipleInitialEvent(
                  id: id, type: type, bookmark: state.bookMark, index: 0, context: context, locker: lockerIndex, initFunction: initFunction));
            },
            child: Image.asset(
              state.bookMark[lockerIndex][index]
                  ? isDarkTheme.value
                      ? "assets/home_screen/bookmark_filled_dark.png"
                      : "assets/home_screen/bookmark_filled.png"
                  : isDarkTheme.value
                      ? "assets/home_screen/bookmark_dark.png"
                      : "assets/home_screen/bookmark.png",
              scale: 4,
              // color: const Color(0XFF169A0D),
            ));
      } else {
        return GestureDetector(
            onTap: () async {
              context.read<BookMarkMultipleWidgetBloc>().add(MultipleInitialEvent(
                  id: id, type: type, bookmark: bookMark, index: 0, context: context, locker: lockerIndex, initFunction: initFunction));
            },
            child: Image.asset(
              bookMark[lockerIndex][index]
                  ? isDarkTheme.value
                      ? "assets/home_screen/bookmark_filled_dark.png"
                      : "assets/home_screen/bookmark_filled.png"
                  : isDarkTheme.value
                      ? "assets/home_screen/bookmark_dark.png"
                      : "assets/home_screen/bookmark.png",
              scale: 4,
              // color: const Color(0XFF169A0D),
            ));
      }
    },
  );
}

schedulingFunction({required String id}) async {
  var url = Uri.parse(baseurl + versions + scheduled);
  Map<String, dynamic> data1 = {
    "scheduled_id": id,
  };
  var responseNew = await http.post(url, body: data1, headers: {'Authorization': kToken});
  json.decode(responseNew.body);
}

showSheetForReview({required BuildContext context}) {
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
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 57.73,
                ),
                SvgPicture.asset("lib/Constants/Assets/Footer_icons/review_popup.svg"),
                SizedBox(
                  height: height / 57.73,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                            child: Text(
                              "May be later",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), color: Colors.black),
                            ),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () async {
                            Navigator.pop(context);
                            _inAppReview.requestReview();
                            //_inAppReview.openStoreListing(appStoreId: _appStoreId,);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                            child: Text(
                              "Rate us",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 57.73,
                ),
              ],
            ),
          ),
        );
      });
}

getReview({required BuildContext context}) async {
  //final isAvailable = await _inAppReview.isAvailable();
  //Availability _availability = isAvailable && !Platform.isAndroid ? Availability.available : Availability.unavailable;
  var url = baseurl + versions + reviewCheck;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mainUserToken = prefs.getString('newUserToken') ?? "";
  var response = await dioMain.get(
    url,
    options: Options(headers: {'Authorization': mainUserToken}),
  );
  var responseData = response.data;
  if (responseData["status"]) {
    _inAppReview.requestReview();
  }
}
