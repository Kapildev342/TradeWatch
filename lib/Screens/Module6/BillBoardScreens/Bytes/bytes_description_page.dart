import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/custom_render.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:river_player/river_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/DoubleOne/translation_widget_single_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_description_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_response_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_similar_content_model.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/LikeButtonList/like_button_list_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/ResponseField/response_field_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/SingleLikeButton/single_like_button_bloc.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:video_player/video_player.dart';

class BytesDescriptionPage extends StatefulWidget {
  final String? fromWhere;

  const BytesDescriptionPage({Key? key, this.fromWhere}) : super(key: key);

  @override
  State<BytesDescriptionPage> createState() => _BytesDescriptionPageState();
}

class _BytesDescriptionPageState extends State<BytesDescriptionPage> {
  bool loader = false;
  TextEditingController bottomSheetController = TextEditingController();
  bool customError = false;
  bool isExpanded = false;
  bool isPlaying = false;
  RxList<bool> isBelievedList = RxList<bool>([]);
  RxList<bool> isBelievedSingle = RxList<bool>([]);
  List<int> likeCountList = [];
  List<int> likeCountListSingle = [];
  List<int> viewCountListSingle = [];
  List<int> dislikeCountList = [];
  List<int> dislikeCountSingle = [];
  List<bool> likeList = [];
  List<bool> likeListSingle = [];
  List<bool> dislikeList = [];
  List<bool> dislikeListSingle = [];
  List<String> titlesList = [];
  List<bool> translationList = [];
  String nHtml = "";
  int carouselIndexGlobal = 0;
  late BillBoardDescriptionModel billBoardData;
  late BillBoardResponseModel billBoardResponseData;
  late BillBoardSimilarContentModel billBoardRelatedData;

  // late PageManager _pageManager;
  final List<String> _choose = ["Recent", "Most Liked", "Most Disliked", "Most Commented"];
  String selectedValue = "Recent";
  bool emptyBoolResponses = false;
  List<String> networkUrls = [];
  List<BetterPlayerController> betterPlayerList = [];
  List<bool> playerConditions = [];
  List<String> playerVideoId = [];
  bool fullScreenBool = false;
  List<Map<String, dynamic>> fileList = [];
  FocusNode requestFocus = FocusNode();

  CustomRenderMatcher imageTagMatcher() => (context) {
        return context.tree.element?.localName == 'img';
      };

  CustomRenderMatcher videoTagMatcher() => (context) {
        return context.tree.element?.localName == 'video';
      };
  List<ChewieController> cvControllerList = [];
  List<ChewieController> responseCvControllerList = [];
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  final CarouselController _carController = CarouselController();

/*  List<int> likeCountRelatedList = [];
  List<int> dislikeCountRelatedList = [];
  List<bool> likeRelatedList = [];
  List<bool> dislikeRelatedList = [];
  RxList<bool> isBelievedRelatedList = RxList<bool>([]);
  List<String> networkRelatedUrls = [];
  List<bool> playerRelatedConditions = [];
  List<String> playerRelatedVideoId = [];
  List<TextEditingController> responseControllerRelatedList = [];
  List<BetterPlayerController> betterPlayerRelatedList = [];
  bool emptyBoolRelatedBytes = false;
  List<String> titlesRelatedList = [];
  List<bool> translationRelatedList = [];
  List<ChewieController> responseCvControllerRelatedList = [];*/

  @override
  void initState() {
    getAllDataMain(name: 'Byte_Description_Page');
    getData();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
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
    context.read<LikeButtonListWidgetBloc>().add(const LikeButtonListLoadingEvent());
    context.read<SingleLikeButtonBloc>().add(const SingleLikeButtonListLoadingEvent());
    context.read<ResponseFieldWidgetBloc>().add(const ResponseFieldInitialEvent());
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    context.read<TranslationWidgetSingleBloc>().add(const LoadingTranslationSingleEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    await getBillBoardData();
  }

  getBillBoardData() async {
    fileList.clear();
    billBoardData = await billBoardApiMain.getBillBoardSingleData(context: context, id: mainVariables.selectedBillboardIdMain.value);
    watchVariables.postCountTotalMain.value = billBoardData.postViewCounts;
    if (watchVariables.postCountTotalMain.value % 5 == 0) {
      functionsMain.createInterstitialAd(modelSetState: setState);
    }
    titleMain = billBoardData.response.title;
    likeCountListSingle.add(billBoardData.response.likesCount);
    viewCountListSingle.add(billBoardData.response.viewsCount);
    dislikeCountSingle.add(billBoardData.response.disLikesCount);
    likeListSingle.add(billBoardData.response.likes);
    dislikeListSingle.add(billBoardData.response.dislikes);
    isBelievedSingle.add(billBoardData.response.believed);
    mainVariables.singleBelievedMain = billBoardData.response.postUserId.believersCount.obs;
    for (int i = 0; i < billBoardData.response.files.length; i++) {
      fileList.add(billBoardData.response.files[i]);
      cvControllerList.add(await functionsMain.getVideoPlayer(
        url: fileList[i]["file"],
      ));
    }
    await getResponseData();
    await getRelatedData();
    setState(() {
      loader = true;
    });
  }

  getResponseData() async {
    billBoardResponseData = await billBoardApiMain.getBillBoardResponseData(
        context: context, id: mainVariables.selectedBillboardIdMain.value, sortType: mainVariables.selectedResponseSortTypeMain.value);
    if (billBoardResponseData.response.isNotEmpty) {
      likeCountList.clear();
      dislikeCountList.clear();
      likeList.clear();
      dislikeList.clear();
      isBelievedList.clear();
      networkUrls.clear();
      playerConditions.clear();
      playerVideoId.clear();
      likeCountList.clear();
      mainVariables.pickedImageMain.clear();
      mainVariables.pickedVideoMain.clear();
      mainVariables.pickedFileMain.clear();
      mainVariables.docMain.clear();
      mainVariables.selectedUrlTypeMain.clear();
      mainVariables.docFilesMain.clear();
      betterPlayerList.clear();
      emptyBoolResponses = false;
      for (int i = 0; i < billBoardResponseData.response.length; i++) {
        isBelievedList.add(billBoardResponseData.response[i].believed);
        likeCountList.add(billBoardResponseData.response[i].likesCount);
        dislikeCountList.add(billBoardResponseData.response[i].dislikesCount);
        likeList.add(billBoardResponseData.response[i].likes);
        dislikeList.add(billBoardResponseData.response[i].dislikes);
        titlesList.add(billBoardResponseData.response[i].message);
        translationList.add(billBoardResponseData.response[i].translation);
        if (billBoardResponseData.response[i].files.isNotEmpty) {
          responseCvControllerList.add(await functionsMain.getVideoPlayer(
            url: billBoardResponseData.response[i].files.first,
          ));
        } else {
          responseCvControllerList.add(ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(""))));
        }
      }
    } else {
      likeCountList.clear();
      dislikeCountList.clear();
      likeList.clear();
      dislikeList.clear();
      isBelievedList.clear();
      networkUrls.clear();
      playerConditions.clear();
      playerVideoId.clear();
      likeCountList.clear();
      mainVariables.pickedImageMain.clear();
      mainVariables.pickedVideoMain.clear();
      mainVariables.pickedFileMain.clear();
      mainVariables.docMain.clear();
      mainVariables.selectedUrlTypeMain.clear();
      mainVariables.docFilesMain.clear();
      betterPlayerList.clear();
      emptyBoolResponses = true;
    }
    if (!mounted) {
      return;
    }
    billBoardData = await billBoardApiMain.getBillBoardSingleData(context: context, id: mainVariables.selectedBillboardIdMain.value);
    setState(() {});
  }

  getRelatedData() async {
    mainVariables.valueMapListProfileRelatedPage.clear();
    mainVariables.responseFocusRelatedList.clear();
    mainVariables.isUserTaggingRelatedList.clear();
    mainVariables.responseControllerRelatedList.clear();
    mainVariables.pickedImageRelatedMain.clear();
    mainVariables.pickedVideoRelatedMain.clear();
    mainVariables.pickedFileRelatedMain.clear();
    mainVariables.docRelatedMain.clear();
    mainVariables.selectedUrlTypeRelatedMain.clear();
    mainVariables.docFilesRelatedMain.clear();
    mainVariables.initialPostRelatedDate.value = "";
    billBoardRelatedData = await billBoardApiMain.getBillBoardRelatedData(context: context, id: mainVariables.selectedBillboardIdMain.value);
    if (billBoardRelatedData.response.isNotEmpty) {
      mainVariables.valueMapListProfileRelatedPage.addAll(mainVariables.billBoardDataProfilePage!.value.response);
      mainVariables.initialPostRelatedDate.value = mainVariables.valueMapListProfileRelatedPage[0].dateTime;
      for (int i = 0; i < mainVariables.valueMapListProfileRelatedPage.length; i++) {
        mainVariables.responseFocusRelatedList.add(FocusNode());
        mainVariables.isUserTaggingRelatedList.add(false);
        mainVariables.responseControllerRelatedList.add(TextEditingController());
        mainVariables.pickedImageRelatedMain.add(null);
        mainVariables.pickedVideoRelatedMain.add(null);
        mainVariables.pickedFileRelatedMain.add(null);
        mainVariables.docRelatedMain.add(null);
        mainVariables.selectedUrlTypeRelatedMain.add("");
        mainVariables.docFilesRelatedMain.add([]);
      }
    }
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    mainVariables.selectedResponseSortTypeMain.value = "";
    mainVariables.billBoardSearchControllerMain.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWhere == "main") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
              tType: true,
              caseNo1: 0,
              text: "",
              excIndex: 1,
              newIndex: 0,
              countryIndex: 0,
              isHomeFirstTym: false,
            );
          }));
        } else if (widget.fromWhere == "profile") {
          Navigator.pop(context, true);
        } else {
          if (mainVariables.billBoardSearchControllerMain.value.text.isEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainBottomNavigationPage(
                        caseNo1: 2, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
          } else {
            mainVariables.billBoardSearchControllerMain.value.clear();
            FocusManager.instance.primaryFocus?.unfocus();
            mainVariables.billBoardSearchControllerMain.refresh();
            setState(() {});
          }
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        appBar: loader
            ? AppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                toolbarHeight: height / 11.54,
                shape: const OutlineInputBorder(
                    borderSide: BorderSide.none, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                elevation: 1.0,
                shadowColor: Colors.black26,
                title: Column(
                  children: [
                    SizedBox(
                      height: height / 23.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (widget.fromWhere == "main") {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return const MainBottomNavigationPage(
                                      tType: true,
                                      caseNo1: 0,
                                      text: "",
                                      excIndex: 1,
                                      newIndex: 0,
                                      countryIndex: 0,
                                      isHomeFirstTym: false,
                                    );
                                  }));
                                } else if (widget.fromWhere == "profile") {
                                  Navigator.pop(context, true);
                                } else {
                                  if (mainVariables.billBoardSearchControllerMain.value.text.isEmpty) {
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
                                  } else {
                                    mainVariables.billBoardSearchControllerMain.value.clear();
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    mainVariables.billBoardSearchControllerMain.refresh();
                                    setState(() {});
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0XFF777777),
                                size: 25,
                              )),
                          SizedBox(
                            width: width / 51.375,
                          ),
                          Expanded(
                            child: billboardWidgetsMain.getSearchField(
                              context: context,
                              modelSetState: setState,
                              billBoardFunction: () {},
                            ),
                          ),
                          SizedBox(
                            width: width / 84.4,
                          ),
                          Obx(
                            () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                                ? const SizedBox()
                                : Row(
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
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : AppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                elevation: 0,
              ),
        body: loader
            ? Obx(() => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      billboardWidgetsMain.getSearchPage(context: context, modelSetState: setState),
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
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: height / 1.1,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                        height: height / 57.73,
                                        width: width,
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: 2),
                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                        //padding: EdgeInsets.symmetric(horizontal:fileList.isEmpty ? _width / 27.4:0),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onBackground,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2), blurRadius: 4.0, spreadRadius: 0.0)
                                            ]),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            fileList.isEmpty
                                                ? SizedBox(
                                                    height: height / 57.73,
                                                  )
                                                : const SizedBox(),
                                            fileList.isEmpty
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: width / 27.4,
                                                      ),
                                                      billboardWidgetsMain.getProfile(
                                                        context: context,
                                                        heightValue: height / 17.32,
                                                        widthValue: width / 8.22,
                                                        myself: false,
                                                        avatar: billBoardData.response.postUserId.userAvatar,
                                                        userId: billBoardData.response.postUserId.id,
                                                        isProfile: billBoardData.response.profileType,
                                                        repostAvatar: billBoardData.response.repostAvatar,
                                                        repostUserId: billBoardData.response.repostUser,
                                                        isRepostProfile: billBoardData.response.repostProfileType,
                                                      ),
                                                      SizedBox(
                                                        width: width / 41.1,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return UserBillBoardProfilePage(userId: billBoardData.response.postUserId.id)
                                                                      /*UserProfilePage(
                                                          id:billBoardData.response.postUserId.id,type:'forums',index:0)*/
                                                                      ;
                                                                }));
                                                              },
                                                              child: Text(
                                                                billBoardData.response.postUserId.userName,
                                                                style: TextStyle(
                                                                    fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: height / 173.2,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  billBoardData.response.createdAt,
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: const Color(0XFF737373),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  " | ",
                                                                  style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFF737373),
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.believersTabBottomSheet(
                                                                      context: context,
                                                                      id: billBoardData.response.postUserId.id,
                                                                      isBelieversList: true,
                                                                    );
                                                                  },
                                                                  child: Obx(
                                                                    () => Text(
                                                                      "${mainVariables.singleBelievedMain.value} Believers",
                                                                      style: TextStyle(
                                                                          fontSize: text.scale(10),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          userIdMain != billBoardData.response.postUserId.id
                                                              ? billboardWidgetsMain.getBelieveButton(
                                                                  heightValue: height / 33.76,
                                                                  isBelieved: isBelievedSingle,
                                                                  billboardUserid: billBoardData.response.postUserId.id,
                                                                  billboardUserName: billBoardData.response.postUserId.userName,
                                                                  context: context,
                                                                  modelSetState: setState,
                                                                  index: 0,
                                                                  background: true,
                                                                  believersCount:
                                                                      RxList.generate(1, (index) => billBoardData.response.postUserId.believersCount),
                                                                  isSearchData: false,
                                                                )
                                                              : const SizedBox(),
                                                          SizedBox(
                                                            width: width / 27.4,
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                billboardWidgetsMain.bottomSheet(
                                                                    context1: context,
                                                                    myself: userIdMain == billBoardData.response.postUserId.id,
                                                                    billboardId: billBoardData.response.id,
                                                                    billboardUserId: billBoardData.response.postUserId.id,
                                                                    type: "billboard",
                                                                    responseId: "",
                                                                    responseUserId: "",
                                                                    commentId: "",
                                                                    commentUserId: "",
                                                                    callFunction: getData,
                                                                    contentType: billBoardData.response.type,
                                                                    modelSetState: setState,
                                                                    responseDetail: {},
                                                                    category: billBoardData.response.category,
                                                                    isDescription: "yes",
                                                                    index: 0);
                                                              },
                                                              icon: Icon(
                                                                Icons.more_horiz,
                                                                color: Theme.of(context).colorScheme.onPrimary,
                                                                size: 25,
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            fileList.isEmpty ? SizedBox(height: height / 64) : const SizedBox(),
                                            fileList.isEmpty
                                                ? const SizedBox()
                                                : SizedBox(
                                                    height: height / 57.73,
                                                  ),
                                            fileList.isEmpty
                                                ? const SizedBox()
                                                : Stack(
                                                    alignment: Alignment.topRight,
                                                    children: [
                                                      Container(
                                                        height: height / 3.85,
                                                        width: width,
                                                        color: Theme.of(context).colorScheme.onBackground,
                                                        child: Center(
                                                          child: PageView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              physics: const ScrollPhysics(),
                                                              itemCount: fileList.length,
                                                              onPageChanged: (index) async {
                                                                setState(() {
                                                                  carouselIndexGlobal = index;
                                                                });
                                                              },
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    if (fileList[index]["file_type"] == "image") {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return FullScreenImage(
                                                                            imageUrl: fileList[index]["file"], tag: "generate_a_unique_tag");
                                                                      }));
                                                                    } else if (fileList[index]["file_type"] == "video") {
                                                                    } else if (fileList[index]["file_type"] == "document") {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute<dynamic>(
                                                                          builder: (_) => PDFViewerFromUrl(
                                                                            url: fileList[index]["file"],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.black,
                                                                        borderRadius: BorderRadius.circular(15),
                                                                        border: Border.all(color: Theme.of(context).colorScheme.onBackground)),
                                                                    clipBehavior: Clip.hardEdge,
                                                                    child: fileList[index]["file_type"] == "image"
                                                                        ? Image.network(
                                                                            fileList[index]["file"],
                                                                            fit: BoxFit.contain,
                                                                          )
                                                                        : fileList[index]["file_type"] == "video"
                                                                            ? billboardWidgetsMain.getVideoPlayer(
                                                                                cvController: cvControllerList[index],
                                                                                heightValue: height / 3.85,
                                                                                widthValue: width,
                                                                              )
                                                                            : fileList[index]["file_type"] == "document"
                                                                                ? Stack(
                                                                                    alignment: Alignment.center,
                                                                                    children: [
                                                                                      Image.asset(
                                                                                        "lib/Constants/Assets/Settings/coverImage.png",
                                                                                        height: height / 3.85,
                                                                                        width: width,
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                      Container(
                                                                                        height: height / 17.32,
                                                                                        width: width / 8.22,
                                                                                        decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          color: Colors.black26.withOpacity(0.3),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Image.asset(
                                                                                            "lib/Constants/Assets/BillBoard/document.png",
                                                                                            color: Colors.white,
                                                                                            height: height / 34.64,
                                                                                            width: width / 16.44,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                : const SizedBox(),
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: height / 72.16,
                                                        right: width / 34.25,
                                                        child: Row(
                                                          children: [
                                                            userIdMain != billBoardData.response.postUserId.id
                                                                ? billboardWidgetsMain.getBelieveButton(
                                                                    heightValue: height / 33.76,
                                                                    isBelieved: isBelievedSingle,
                                                                    billboardUserid: billBoardData.response.postUserId.id,
                                                                    billboardUserName: billBoardData.response.postUserId.userName,
                                                                    context: context,
                                                                    modelSetState: setState,
                                                                    index: 0,
                                                                    background: true,
                                                                    believersCount: RxList.generate(
                                                                        1, (index) => billBoardData.response.postUserId.believersCount),
                                                                    isSearchData: false,
                                                                  )
                                                                : const SizedBox(),
                                                            SizedBox(
                                                              width: width / 27.4,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  billboardWidgetsMain.bottomSheet(
                                                                      context1: context,
                                                                      myself: userIdMain == billBoardData.response.postUserId.id,
                                                                      billboardId: billBoardData.response.id,
                                                                      billboardUserId: billBoardData.response.postUserId.id,
                                                                      type: "billboard",
                                                                      responseId: "",
                                                                      responseUserId: "",
                                                                      commentId: "",
                                                                      commentUserId: "",
                                                                      callFunction: getData,
                                                                      contentType: billBoardData.response.type,
                                                                      modelSetState: setState,
                                                                      responseDetail: {},
                                                                      category: billBoardData.response.category,
                                                                      index: 0);
                                                                },
                                                                child: Icon(
                                                                  Icons.more_vert,
                                                                  color: Theme.of(context).colorScheme.onBackground,
                                                                  size: 25,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      fileList.length > 1
                                                          ? Positioned(
                                                              bottom: height / 57.73,
                                                              left: (width / 2) - 50,
                                                              child: SizedBox(
                                                                height: height / 173.2,
                                                                child: ListView.builder(
                                                                    shrinkWrap: true,
                                                                    scrollDirection: Axis.horizontal,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    itemCount: fileList.length,
                                                                    itemBuilder: (BuildContext context, int index1) {
                                                                      return Container(
                                                                        height: height / 173.2,
                                                                        width: carouselIndexGlobal == index1 ? width / 20.55 : width / 82.2,
                                                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8), color: Colors.white),
                                                                      );
                                                                    }),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                            fileList.isEmpty
                                                ? const SizedBox()
                                                : SizedBox(
                                                    height: height / 57.73,
                                                  ),
                                            fileList.isEmpty
                                                ? const SizedBox()
                                                : Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: width / 41.1,
                                                      ),
                                                      billboardWidgetsMain.getProfile(
                                                        context: context,
                                                        heightValue: height / 17.32,
                                                        widthValue: width / 8.22,
                                                        myself: false,
                                                        isProfile: billBoardData.response.profileType,
                                                        avatar: billBoardData.response.postUserId.userAvatar,
                                                        userId: billBoardData.response.postUserId.id,
                                                        repostAvatar: billBoardData.response.repostAvatar,
                                                        repostUserId: billBoardData.response.repostUser,
                                                        isRepostProfile: billBoardData.response.repostProfileType,
                                                      ),
                                                      SizedBox(
                                                        width: width / 41.1,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return UserBillBoardProfilePage(userId: billBoardData.response.postUserId.id)
                                                                      /*UserProfilePage(
                                                                id:billBoardData.response.postUserId.id,type:'forums',index:0)*/
                                                                      ;
                                                                }));
                                                              },
                                                              child: Text(
                                                                billBoardData.response.postUserId.userName,
                                                                style: TextStyle(
                                                                    fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: height / 173.2,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  billBoardData.response.createdAt,
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: const Color(0XFF737373),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  " | ",
                                                                  style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFF737373),
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.believersTabBottomSheet(
                                                                      context: context,
                                                                      id: billBoardData.response.postUserId.id,
                                                                      isBelieversList: true,
                                                                    );
                                                                  },
                                                                  child: Obx(() => Text(
                                                                        "${mainVariables.singleBelievedMain.value} Believers",
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(10),
                                                                            color: const Color(0XFF737373),
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily: "Poppins"),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            fileList.isEmpty ? const SizedBox() : SizedBox(height: height / 64),
                                            Container(
                                                width: width,
                                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                color: Theme.of(context).colorScheme.onBackground,
                                                child: RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: conversationFunctionsMain.spanList(
                                                        message: titleMain.length > 200 ? titleMain.substring(0, 200) : titleMain, context: context),
                                                  ),
                                                )),
                                            titleMain.length > 200
                                                ? Container(
                                                    width: width,
                                                    padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                                  isScrollControlled: true,
                                                                  isDismissible: false,
                                                                  enableDrag: false,
                                                                  builder: (BuildContext context) {
                                                                    return StatefulBuilder(
                                                                      builder: (BuildContext context, StateSetter modelSetState) {
                                                                        return Container(
                                                                          height: height / 1.23,
                                                                          margin: EdgeInsets.symmetric(
                                                                              horizontal: width / 27.4, vertical: height / 57.73),
                                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                          child: Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: SingleChildScrollView(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: height / 54.13,
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Description",
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(14),
                                                                                                  fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                            IconButton(
                                                                                                onPressed: () {
                                                                                                  if (!mounted) {
                                                                                                    return;
                                                                                                  }
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                icon: const Icon(
                                                                                                  Icons.highlight_remove,
                                                                                                  size: 25,
                                                                                                )),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: height / 54.13,
                                                                                      ),
                                                                                      Container(
                                                                                          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                          width: width,
                                                                                          child: RichText(
                                                                                            textAlign: TextAlign.left,
                                                                                            text: TextSpan(
                                                                                                children: conversationFunctionsMain.spanList(
                                                                                                    message: titleMain, context: context)),
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: height / 50.75,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  });
                                                            },
                                                            child: Text(
                                                              "read more..",
                                                              style: TextStyle(
                                                                  color: const Color(0XFF0EA102),
                                                                  fontSize: text.scale(12),
                                                                  fontFamily: "Poppins",
                                                                  fontWeight: FontWeight.w400),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: height / 64),
                                            SizedBox(
                                              height: height / 57.73,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    billboardWidgetsMain.singleLikeButtonListWidget(
                                                      likeList: likeListSingle,
                                                      id: mainVariables.selectedBillboardIdMain.value,
                                                      index: 0,
                                                      context: context,
                                                      initFunction: () {},
                                                      modelSetState: setState,
                                                      notUse: true,
                                                      dislikeList: dislikeListSingle,
                                                      likeCountList: likeCountListSingle,
                                                      dislikeCountList: dislikeCountSingle,
                                                      type: 'byte',
                                                      image: "",
                                                      title: titleMain,
                                                      description: "",
                                                      fromWhere: 'descriptionPage',
                                                      responseId: '',
                                                      controller: bottomSheetController,
                                                      commentId: '',
                                                      postUserId: billBoardData.response.postUserId.id,
                                                      responseUserId: '',
                                                      billBoardType: 'billboard',
                                                      responseFocus: requestFocus,
                                                      repostUserName: billBoardData.response.postUserId.userName,
                                                      profileType: billBoardData.response.postUserId.profileType,
                                                      tickerId: billBoardData.response.postUserId.tickerId,
                                                      category: billBoardData.response.category,
                                                    ),
                                                    SizedBox(
                                                      height: height / 34.64,
                                                      width: width / 4,
                                                      child: bookMarkWidgetSingle(
                                                          bookMark: [billBoardData.response.bookmark],
                                                          context: context,
                                                          id: billBoardData.response.id,
                                                          type: 'billboard',
                                                          modelSetState: setState,
                                                          index: 0),
                                                    ),
                                                    billBoardData.response.repostedCount == 0 || billBoardData.response.repostAvatar == ""
                                                        ? const SizedBox()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              billboardWidgetsMain.believedTabBottomSheet(
                                                                  context: context,
                                                                  id: billBoardData.response.repostId,
                                                                  type: billBoardData.response.type);
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                SizedBox(
                                                                  height: height / 28.86,
                                                                  width: width / 13.7,
                                                                ),
                                                                Positioned(
                                                                  left: 0,
                                                                  bottom: 0,
                                                                  child: Container(
                                                                    height: height / 34.64,
                                                                    width: width / 16.44,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        image: const DecorationImage(
                                                                          image: AssetImage("lib/Constants/Assets/BillBoard/repost_green.png"),
                                                                        )),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: Container(
                                                                    height: height / 57.73,
                                                                    width: width / 27.4,
                                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                    child: Center(
                                                                        child: Text(
                                                                      billBoardData.response.repostedCount > 9
                                                                          ? "9+"
                                                                          : billBoardData.response.repostedCount.toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                    )),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: width / 16.44,
                                                    ),
                                                    widgetsMain.translationWidgetSingle(
                                                      translation: false,
                                                      id: billBoardData.response.id,
                                                      type: 'billboard',
                                                      index: 0,
                                                      initFunction: getData,
                                                      context: context,
                                                      modelSetState: setState,
                                                      notUse: false,
                                                      title: titleMain, //billBoardData.response.title,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height / 64),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        billBoardData.response.companyName,
                                                        style: TextStyle(
                                                            fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.getLikeDislikeUsersList(
                                                              context: context,
                                                              billBoardId: billBoardData.response.id,
                                                              responseId: "",
                                                              commentId: "",
                                                              billBoardType: "billboard",
                                                              action: "views",
                                                              likeCount: likeCountListSingle.first.toString(),
                                                              disLikeCount: dislikeCountSingle.first.toString(),
                                                              index: 0,
                                                              viewCount: viewCountListSingle.first.toString(),
                                                              isViewIncluded: true);
                                                        },
                                                        child: Text(
                                                          " ${viewCountListSingle[0]} views ",
                                                          style: TextStyle(fontSize: text.scale(10)),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.getLikeDislikeUsersList(
                                                              context: context,
                                                              billBoardId: billBoardData.response.id,
                                                              responseId: "",
                                                              commentId: "",
                                                              billBoardType: "billboard",
                                                              action: "likes",
                                                              likeCount: likeCountListSingle.first.toString(),
                                                              disLikeCount: dislikeCountSingle.first.toString(),
                                                              index: 1,
                                                              viewCount: viewCountListSingle.first.toString(),
                                                              isViewIncluded: true);
                                                        },
                                                        child: Text(
                                                          " ${likeCountListSingle[0]} likes ",
                                                          style: TextStyle(fontSize: text.scale(10)),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.getLikeDislikeUsersList(
                                                              context: context,
                                                              billBoardId: billBoardData.response.id,
                                                              responseId: "",
                                                              commentId: "",
                                                              billBoardType: "billboard",
                                                              action: "dislikes",
                                                              likeCount: likeCountListSingle.first.toString(),
                                                              disLikeCount: dislikeCountSingle.first.toString(),
                                                              index: 2,
                                                              viewCount: viewCountListSingle.first.toString(),
                                                              isViewIncluded: true);
                                                        },
                                                        child: Text(
                                                          " ${dislikeCountSingle[0]} DisLikes ",
                                                          style: TextStyle(fontSize: text.scale(10)),
                                                        ),
                                                      ),
                                                      Text(
                                                        " ${billBoardData.response.responseCount} Response ",
                                                        style: TextStyle(fontSize: text.scale(10)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: height / 42.6),
                                              ]),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(1.5),
                                              margin: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  borderRadius: BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                        blurRadius: 4.0,
                                                        spreadRadius: 0.0)
                                                  ]),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: height / 108.25, horizontal: width / 51.375),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return UserBillBoardProfilePage(userId: userIdMain)
                                                              /*UserProfilePage(
                                                    id:userIdMain,type:'forums',index:0)*/
                                                              ;
                                                        }));
                                                      },
                                                      child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    billboardWidgetsMain.getResponseFieldSingle(
                                                      context: context,
                                                      modelSetState: setState,
                                                      billBoardId: mainVariables.selectedBillboardIdMain.value,
                                                      postUserId: billBoardData.response.postUserId.id,
                                                      responseId: "",
                                                      index: 0,
                                                      fromWhere: 'descriptionPage',
                                                      callFunction: getResponseData,
                                                      contentType: billBoardData.response.type,
                                                      category: billBoardData.response.category,
                                                      responseCountList: [billBoardData.response.responseCount],
                                                      responseFocus: requestFocus,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 86.6,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                    Obx(() => mainVariables.isUserTagged.value
                                        ? Positioned(
                                            bottom: height / 5.5,
                                            child: const UserTaggingBillBoardSingleContainer(
                                              billboardListIndex: 0,
                                            ))
                                        : const SizedBox()),
                                  ],
                                ),
                                Container(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  padding: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Response order",
                                        style: TextStyle(fontSize: text.scale(13), color: const Color(0XFFB0B0B0)),
                                      ),
                                      SizedBox(
                                        width: width / 53.57,
                                      ),
                                      Icon(Icons.access_time, size: height / 37.5),
                                      SizedBox(
                                        width: width / 75,
                                      ),
                                      SizedBox(
                                        width: width / 3.40,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            isExpanded: true,
                                            isDense: true,
                                            items: _choose
                                                .map((item) => DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedValue,
                                            onChanged: (String? value) async {
                                              setState(() {
                                                selectedValue = value!;
                                                mainVariables.selectedResponseSortTypeMain.value = selectedValue == "Recent"
                                                    ? ""
                                                    : selectedValue == "Most Liked"
                                                        ? ""
                                                        : selectedValue == "Most Disliked"
                                                            ? ""
                                                            : selectedValue == "Most Commented"
                                                                ? ""
                                                                : "";
                                              });
                                            },
                                            iconStyleData: IconStyleData(
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                                iconSize: 20,
                                                iconEnabledColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                                iconDisabledColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                            buttonStyleData: ButtonStyleData(height: height / 17.32, width: width / 3.28, elevation: 0),
                                            menuItemStyleData: MenuItemStyleData(height: height / 21.65),
                                            dropdownStyleData: DropdownStyleData(
                                                maxHeight: height / 4.33,
                                                width: width / 2.055,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15), color: Theme.of(context).colorScheme.onBackground),
                                                elevation: 8,
                                                offset: const Offset(-20, 0)),
                                            /*icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                                iconSize: 20,
                                                iconEnabledColor: Colors.black
                                                    .withOpacity(0.5),
                                                iconDisabledColor: Colors.black
                                                    .withOpacity(0.5),
                                                buttonHeight: 50,
                                                buttonWidth: 125,
                                                buttonElevation: 0,
                                                itemHeight: 40,
                                                dropdownMaxHeight: 200,
                                                dropdownWidth: 200,
                                                dropdownDecoration:
                                                    BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white,
                                                ),
                                                dropdownElevation: 8,
                                                scrollbarRadius:
                                                    const Radius.circular(40),
                                                scrollbarThickness: 6,
                                                scrollbarAlwaysShow: true,
                                                offset: const Offset(-20, 0),*/
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                emptyBoolResponses
                                    ? const SizedBox()
                                    : Container(
                                        margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                        height: height / 86.6,
                                        width: width,
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                emptyBoolResponses
                                    ? Center(
                                        child: Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                                height: height / 4.81,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                          blurRadius: 4.0,
                                                          spreadRadius: 0.0)
                                                    ]),
                                                clipBehavior: Clip.hardEdge,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: height / 57.73,
                                                    ),
                                                    Expanded(
                                                      child: SvgPicture.asset(
                                                        "lib/Constants/Assets/SMLogos/no respone.svg",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 86.6,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: 'No response to display...',
                                                              style: TextStyle(
                                                                  fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 57.73,
                                                    )
                                                  ],
                                                )),
                                            SizedBox(
                                              height: height / 57.73,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onBackground,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                  offset: const Offset(0.0, 0.0),
                                                  blurRadius: 1.0,
                                                  spreadRadius: 1.0)
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: height / 57.73,
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.onBackground,
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                              ),
                                            ),
                                            ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: billBoardResponseData.response.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                      color: Theme.of(context).colorScheme.onBackground,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          billboardWidgetsMain.getProfile(
                                                            context: context,
                                                            heightValue: height / 17.32,
                                                            widthValue: width / 8.22,
                                                            myself: false,
                                                            isProfile: billBoardResponseData.response[index].profileType,
                                                            avatar: billBoardResponseData.response[index].users.avatar,
                                                            userId: billBoardResponseData.response[index].users.userId,
                                                          ),
                                                          SizedBox(
                                                            width: width / 41.1,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: width / 1.5,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                              return UserBillBoardProfilePage(
                                                                                      userId: billBoardResponseData.response[index].users.userId)
                                                                                  /*UserProfilePage(
                                                                              id:billBoardResponseData
                                                                                  .response[index]
                                                                                  .users.userId,type:'forums',index:0)*/
                                                                                  ;
                                                                            }));
                                                                          },
                                                                          child: Text(
                                                                            billBoardResponseData.response[index].users.username,
                                                                            style: TextStyle(
                                                                                fontSize: text.scale(14),
                                                                                fontWeight: FontWeight.w700,
                                                                                fontFamily: "Poppins"),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: height / 173.2,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              billBoardResponseData.response[index].createdAt,
                                                                              style: TextStyle(
                                                                                  fontSize: text.scale(10),
                                                                                  color: const Color(0XFF737373),
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontFamily: "Poppins"),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        userIdMain != billBoardResponseData.response[index].users.userId
                                                                            ? billboardWidgetsMain.getBelieveButton(
                                                                                heightValue: height / 33.76,
                                                                                isBelieved: isBelievedList,
                                                                                billboardUserid: billBoardResponseData.response[index].users.userId,
                                                                                billboardUserName:
                                                                                    billBoardResponseData.response[index].users.username,
                                                                                context: context,
                                                                                modelSetState: setState,
                                                                                index: index,
                                                                                background: true,
                                                                                believersCount: RxList.generate(
                                                                                    billBoardResponseData.response.length,
                                                                                    (index) =>
                                                                                        billBoardResponseData.response[index].users.believersCount),
                                                                                isSearchData: false,
                                                                              )
                                                                            : const SizedBox(),
                                                                        SizedBox(
                                                                          width: width / 41.1,
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap: () {
                                                                              billboardWidgetsMain.bottomSheet(
                                                                                  context1: context,
                                                                                  myself: userIdMain ==
                                                                                      billBoardResponseData.response[index].users.userId,
                                                                                  billboardId: billBoardData.response.id,
                                                                                  billboardUserId: billBoardData.response.postUserId.id,
                                                                                  type: "response",
                                                                                  responseId: billBoardResponseData.response[index].id,
                                                                                  responseUserId: billBoardResponseData.response[index].users.userId,
                                                                                  commentId: "",
                                                                                  commentUserId: "",
                                                                                  callFunction: getResponseData,
                                                                                  contentType: 'blog_response',
                                                                                  modelSetState: setState,
                                                                                  responseDetail: billBoardResponseData.response[index],
                                                                                  category: billBoardData.response.category,
                                                                                  index: index);
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.more_horiz,
                                                                              color: Colors.black,
                                                                              size: 25,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              SizedBox(
                                                                  width: width / 1.5,
                                                                  child: RichText(
                                                                    textAlign: TextAlign.left,
                                                                    text: TextSpan(
                                                                      children: conversationFunctionsMain.spanList(
                                                                          message: billBoardResponseData.response[index].message.length > 200
                                                                              ? billBoardResponseData.response[index].message.substring(0, 200)
                                                                              : billBoardResponseData.response[index].message,
                                                                          context: context),
                                                                    ),
                                                                  )),
                                                              billBoardResponseData.response[index].message.length > 200
                                                                  ? SizedBox(
                                                                      width: width / 1.5,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
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
                                                                                    isScrollControlled: true,
                                                                                    isDismissible: false,
                                                                                    enableDrag: false,
                                                                                    builder: (BuildContext context) {
                                                                                      return StatefulBuilder(
                                                                                        builder: (BuildContext context, StateSetter modelSetState) {
                                                                                          return Container(
                                                                                            height: height / 1.23,
                                                                                            margin: EdgeInsets.symmetric(
                                                                                                horizontal: width / 27.4, vertical: height / 57.73),
                                                                                            padding: EdgeInsets.only(
                                                                                                bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: SingleChildScrollView(
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: height / 54.13,
                                                                                                        ),
                                                                                                        Container(
                                                                                                          padding: EdgeInsets.symmetric(
                                                                                                              horizontal: width / 27.4),
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment:
                                                                                                                MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "Description",
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: text.scale(14),
                                                                                                                    fontWeight: FontWeight.w700),
                                                                                                              ),
                                                                                                              IconButton(
                                                                                                                  onPressed: () {
                                                                                                                    if (!mounted) {
                                                                                                                      return;
                                                                                                                    }
                                                                                                                    Navigator.pop(context);
                                                                                                                  },
                                                                                                                  icon: const Icon(
                                                                                                                    Icons.highlight_remove,
                                                                                                                    size: 25,
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: height / 54.13,
                                                                                                        ),
                                                                                                        billBoardResponseData
                                                                                                                    .response[index].fileType ==
                                                                                                                ""
                                                                                                            ? const SizedBox()
                                                                                                            : Row(
                                                                                                                mainAxisAlignment:
                                                                                                                    billBoardResponseData
                                                                                                                                .response[index]
                                                                                                                                .fileType ==
                                                                                                                            "doc"
                                                                                                                        ? MainAxisAlignment.start
                                                                                                                        : MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  billBoardResponseData
                                                                                                                              .response[index]
                                                                                                                              .fileType ==
                                                                                                                          ""
                                                                                                                      ? const SizedBox()
                                                                                                                      : billBoardResponseData
                                                                                                                                  .response[index]
                                                                                                                                  .fileType ==
                                                                                                                              "image"
                                                                                                                          ? GestureDetector(
                                                                                                                              onTap: () {
                                                                                                                                Navigator.push(
                                                                                                                                    context,
                                                                                                                                    MaterialPageRoute(
                                                                                                                                        builder:
                                                                                                                                            (BuildContext
                                                                                                                                                context) {
                                                                                                                                  return FullScreenImage(
                                                                                                                                      imageUrl: billBoardResponseData
                                                                                                                                          .response[
                                                                                                                                              index]
                                                                                                                                          .files[0],
                                                                                                                                      tag:
                                                                                                                                          "generate_a_unique_tag");
                                                                                                                                }));
                                                                                                                              },
                                                                                                                              child: Container(
                                                                                                                                  padding:
                                                                                                                                      const EdgeInsets
                                                                                                                                          .only(
                                                                                                                                          top: 8,
                                                                                                                                          right: 5),
                                                                                                                                  height:
                                                                                                                                      height / 6.76,
                                                                                                                                  width: width / 3.12,
                                                                                                                                  child:
                                                                                                                                      Image.network(
                                                                                                                                    billBoardResponseData
                                                                                                                                        .response[
                                                                                                                                            index]
                                                                                                                                        .files
                                                                                                                                        .first,
                                                                                                                                    fit: BoxFit.fill,
                                                                                                                                  )),
                                                                                                                            )
                                                                                                                          : billBoardResponseData
                                                                                                                                      .response[index]
                                                                                                                                      .fileType ==
                                                                                                                                  "video"
                                                                                                                              ? SizedBox(
                                                                                                                                  width: width / 1.7,
                                                                                                                                  child: Stack(
                                                                                                                                    alignment:
                                                                                                                                        Alignment
                                                                                                                                            .center,
                                                                                                                                    children: [
                                                                                                                                      BetterPlayer(
                                                                                                                                        controller:
                                                                                                                                            betterPlayerList[
                                                                                                                                                index],
                                                                                                                                      ),
                                                                                                                                      GestureDetector(
                                                                                                                                          onTap: () {
                                                                                                                                            for (int i =
                                                                                                                                                    1;
                                                                                                                                                i < networkUrls.length;
                                                                                                                                                i++) {
                                                                                                                                              if (index ==
                                                                                                                                                  i - 1) {
                                                                                                                                                if (betterPlayerList[i].isPlaying() ==
                                                                                                                                                    true) {
                                                                                                                                                  betterPlayerList[i].pause();
                                                                                                                                                } else if (betterPlayerList[i].videoPlayerController?.value.duration ==
                                                                                                                                                    betterPlayerList[i].videoPlayerController?.value.position) {
                                                                                                                                                  betterPlayerList[i].seekTo(const Duration(seconds: 0));
                                                                                                                                                } else {
                                                                                                                                                  betterPlayerList[i].play();
                                                                                                                                                }
                                                                                                                                              } else {
                                                                                                                                                betterPlayerList[i]
                                                                                                                                                    .pause();
                                                                                                                                                betterPlayerList[i]
                                                                                                                                                    .seekTo(const Duration(seconds: 0));
                                                                                                                                              }
                                                                                                                                            }
                                                                                                                                          },
                                                                                                                                          child: const Center(
                                                                                                                                              child: Icon(
                                                                                                                                            Icons
                                                                                                                                                .play_circle_fill_rounded,
                                                                                                                                            color: Colors
                                                                                                                                                .transparent,
                                                                                                                                            size: 30,
                                                                                                                                          )))
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                )
                                                                                                                              : billBoardResponseData
                                                                                                                                          .response[
                                                                                                                                              index]
                                                                                                                                          .fileType ==
                                                                                                                                      "doc"
                                                                                                                                  ? Column(
                                                                                                                                      children: [
                                                                                                                                        SizedBox(
                                                                                                                                          height:
                                                                                                                                              height /
                                                                                                                                                  86.6,
                                                                                                                                        ),
                                                                                                                                        GestureDetector(
                                                                                                                                          onTap: () {
                                                                                                                                            Navigator
                                                                                                                                                .push(
                                                                                                                                              context,
                                                                                                                                              MaterialPageRoute<
                                                                                                                                                  dynamic>(
                                                                                                                                                builder: (_) =>
                                                                                                                                                    PDFViewerFromUrl(
                                                                                                                                                  url:
                                                                                                                                                      billBoardResponseData.response[index].files.first,
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            );
                                                                                                                                          },
                                                                                                                                          child: Row(
                                                                                                                                            children: [
                                                                                                                                              Container(
                                                                                                                                                padding: EdgeInsets.symmetric(
                                                                                                                                                    horizontal: width / 41.1,
                                                                                                                                                    vertical: height / 86.6),
                                                                                                                                                decoration:
                                                                                                                                                    BoxDecoration(border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                                                                                                child:
                                                                                                                                                    Text(
                                                                                                                                                  billBoardResponseData.response[index].files.first.split('/').last.toString(),
                                                                                                                                                  style:
                                                                                                                                                      TextStyle(color: Colors.black, fontSize: text.scale(12)),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                              const SizedBox(
                                                                                                                                                  width:
                                                                                                                                                      5),
                                                                                                                                              const Icon(
                                                                                                                                                Icons
                                                                                                                                                    .file_copy_outlined,
                                                                                                                                                color:
                                                                                                                                                    Colors.red,
                                                                                                                                              )
                                                                                                                                            ],
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                        SizedBox(
                                                                                                                                          height:
                                                                                                                                              height /
                                                                                                                                                  86.6,
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    )
                                                                                                                                  : const SizedBox(),
                                                                                                                ],
                                                                                                              ),
                                                                                                        SizedBox(
                                                                                                          height: height / 54.13,
                                                                                                        ),
                                                                                                        Container(
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                                horizontal: width / 27.4),
                                                                                                            width: width,
                                                                                                            child: RichText(
                                                                                                              textAlign: TextAlign.left,
                                                                                                              text: TextSpan(
                                                                                                                  children: conversationFunctionsMain
                                                                                                                      .spanList(
                                                                                                                          message:
                                                                                                                              billBoardResponseData
                                                                                                                                  .response[index]
                                                                                                                                  .message,
                                                                                                                          context: context)),
                                                                                                            )),
                                                                                                        SizedBox(
                                                                                                          height: height / 50.75,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    });
                                                                              },
                                                                              child: Text(
                                                                                "read more..",
                                                                                style: TextStyle(
                                                                                    color: const Color(0XFF0EA102),
                                                                                    fontSize: text.scale(12),
                                                                                    fontFamily: "Poppins",
                                                                                    fontWeight: FontWeight.w400),
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                              billBoardResponseData.response[index].fileType == ""
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      mainAxisAlignment: billBoardResponseData.response[index].fileType == "doc"
                                                                          ? MainAxisAlignment.start
                                                                          : MainAxisAlignment.center,
                                                                      children: [
                                                                        billBoardResponseData.response[index].fileType == ""
                                                                            ? const SizedBox()
                                                                            : billBoardResponseData.response[index].fileType == "image"
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.push(context,
                                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return FullScreenImage(
                                                                                            imageUrl: billBoardResponseData.response[index].files[0],
                                                                                            tag: "generate_a_unique_tag");
                                                                                      }));
                                                                                    },
                                                                                    child: Container(
                                                                                        padding: const EdgeInsets.only(top: 8, right: 5),
                                                                                        height: height / 6.76,
                                                                                        width: width / 3.12,
                                                                                        child: Image.network(
                                                                                          billBoardResponseData.response[index].files.first,
                                                                                          fit: BoxFit.fill,
                                                                                        )),
                                                                                  )
                                                                                : billBoardResponseData.response[index].fileType == "video"
                                                                                    ? billboardWidgetsMain.getVideoPlayer(
                                                                                        cvController: responseCvControllerList[index],
                                                                                        heightValue: height / 5.4,
                                                                                        widthValue: width / 1.45,
                                                                                      )
                                                                                    : billBoardResponseData.response[index].fileType == "doc"
                                                                                        ? Column(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height / 86.6,
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                onTap: () {
                                                                                                  Navigator.push(
                                                                                                    context,
                                                                                                    MaterialPageRoute<dynamic>(
                                                                                                      builder: (_) => PDFViewerFromUrl(
                                                                                                        url: billBoardResponseData
                                                                                                            .response[index].files.first,
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      padding: EdgeInsets.symmetric(
                                                                                                          horizontal: width / 41.1,
                                                                                                          vertical: height / 86.6),
                                                                                                      decoration: BoxDecoration(
                                                                                                          border: Border.all(
                                                                                                              color: const Color(0xffD8D8D8)
                                                                                                                  .withOpacity(0.5))),
                                                                                                      child: Text(
                                                                                                        billBoardResponseData
                                                                                                            .response[index].files.first
                                                                                                            .split('/')
                                                                                                            .last
                                                                                                            .toString(),
                                                                                                        style: TextStyle(
                                                                                                            color: Colors.black,
                                                                                                            fontSize: text.scale(12)),
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(width: 5),
                                                                                                    const Icon(
                                                                                                      Icons.file_copy_outlined,
                                                                                                      color: Colors.red,
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: height / 86.6,
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        : const SizedBox(),
                                                                      ],
                                                                    ),
                                                              SizedBox(
                                                                height: height / 54.13,
                                                              ),
                                                              SizedBox(
                                                                width: width / 1.5,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    billboardWidgetsMain.likeButtonListWidget(
                                                                      likeList: likeList,
                                                                      id: mainVariables.selectedBillboardIdMain.value,
                                                                      postUserId: billBoardData.response.postUserId.id,
                                                                      responseId: billBoardResponseData.response[index].id,
                                                                      responseUserId: billBoardResponseData.response[index].users.userId,
                                                                      commentId: '',
                                                                      index: index,
                                                                      context: context,
                                                                      initFunction: getResponseData,
                                                                      modelSetState: setState,
                                                                      notUse: true,
                                                                      dislikeList: dislikeList,
                                                                      likeCountList: likeCountList,
                                                                      dislikeCountList: dislikeCountList,
                                                                      type: 'response',
                                                                      billBoardType: 'billboard',
                                                                      image: "",
                                                                      title: "",
                                                                      description: "",
                                                                      fromWhere: 'response',
                                                                      controller: bottomSheetController,
                                                                      repostUserName: billBoardData.response.postUserId.userName,
                                                                      profileType: billBoardData.response.postUserId.profileType,
                                                                      tickerId: billBoardData.response.postUserId.tickerId,
                                                                      category: "",
                                                                    ),
                                                                    /*widgetsMain.translationWidget(
                                                                    translationList:
                                                                        translationList,
                                                                    id: billBoardResponseData
                                                                        .response[
                                                                            index]
                                                                        .id,
                                                                    type:
                                                                        'billboard-response',
                                                                    index: index,
                                                                    initFunction:
                                                                        getData,
                                                                    context:
                                                                        context,
                                                                    modelSetState:
                                                                        setState,
                                                                    notUse: false,
                                                                    titleList:
                                                                        titlesList),*/
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 81.2,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: billBoardData.response.id,
                                                                          responseId: billBoardResponseData.response[index].id,
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "likes",
                                                                          likeCount: likeCountList[index].toString(),
                                                                          disLikeCount: dislikeCountList[index].toString(),
                                                                          index: 1,
                                                                          viewCount: '0',
                                                                          isViewIncluded: false);
                                                                    },
                                                                    child: Text(
                                                                      " ${likeCountList[index]} likes ",
                                                                      style: TextStyle(fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: billBoardData.response.id,
                                                                          responseId: billBoardResponseData.response[index].id,
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "dislikes",
                                                                          likeCount: likeCountList[index].toString(),
                                                                          disLikeCount: dislikeCountList[index].toString(),
                                                                          index: 2,
                                                                          viewCount: '0',
                                                                          isViewIncluded: false);
                                                                    },
                                                                    child: Text(
                                                                      " ${dislikeCountList[index]} DisLikes ",
                                                                      style: TextStyle(fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      await billboardWidgetsMain
                                                                          .commentsBottomSheet(
                                                                        context: context,
                                                                        responseId: billBoardResponseData.response[index].id,
                                                                        billBoardPostUser: billBoardData.response.postUserId.id,
                                                                        responsePostUser: billBoardResponseData.response[index].users.userId,
                                                                        category: billBoardData.response.category,
                                                                      )
                                                                          .then((value) {
                                                                        context
                                                                            .read<LikeButtonListWidgetBloc>()
                                                                            .add(const LikeButtonListLoadingEvent());
                                                                        getResponseData();
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          " ${billBoardResponseData.response[index].responseCount} Response ",
                                                                          style: TextStyle(fontSize: text.scale(10)),
                                                                        ),
                                                                        const Icon(Icons.keyboard_arrow_down_outlined)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    index == billBoardResponseData.response.length - 1 ? const SizedBox() : const Divider(),
                                                  ],
                                                );
                                              },
                                            ),
                                            Container(
                                              height: height / 34.64,
                                              width: width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  borderRadius: const BorderRadius.only(
                                                    bottomLeft: Radius.circular(15),
                                                    bottomRight: Radius.circular(15),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                Container(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  padding: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Related Posts",
                                        style: TextStyle(
                                            fontSize: text.scale(16), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                mainVariables.valueMapListProfileRelatedPage.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                        height: height / 86.6,
                                        width: width,
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                mainVariables.valueMapListProfileRelatedPage.isEmpty
                                    ? Center(
                                        child: Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                                height: height / 4.81,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                          blurRadius: 4.0,
                                                          spreadRadius: 0.0)
                                                    ]),
                                                clipBehavior: Clip.hardEdge,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: height / 57.73,
                                                    ),
                                                    Expanded(
                                                      child: SvgPicture.asset(
                                                        "lib/Constants/Assets/SMLogos/no respone.svg",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 86.6,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: 'No response to display...',
                                                              style: TextStyle(
                                                                  fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 57.73,
                                                    ),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: height / 57.73,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(left: width / 51.375, right: width / 51.375),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onBackground,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2), blurRadius: 4.0, spreadRadius: 0.0)
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: height / 57.73,
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.onBackground,
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                              ),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                scrollDirection: Axis.vertical,
                                                itemCount: mainVariables.valueMapListProfileRelatedPage.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                      padding: EdgeInsets.only(left: width / 41.1, right: width / 41.1),
                                                      child: Column(children: [
                                                        Stack(
                                                          children: [
                                                            mainVariables.valueMapListProfileRelatedPage[index].files.isEmpty
                                                                ? //final //NonBelievedCategory, NoFiles, byte
                                                                Container(
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                                                      BoxShadow(
                                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                                          blurRadius: 4.0,
                                                                          spreadRadius: 0.0)
                                                                    ]),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Theme.of(context).colorScheme.tertiary,
                                                                            borderRadius: const BorderRadius.only(
                                                                                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: height / 86.6,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: width / 41.1,
                                                                                  ),
                                                                                  billboardWidgetsMain.getProfile(
                                                                                    context: context,
                                                                                    heightValue: height / 17.32,
                                                                                    widthValue: width / 8.22,
                                                                                    myself: false,
                                                                                    isProfile: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].profileType,
                                                                                    avatar:
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].avatar,
                                                                                    userId:
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].userId,
                                                                                    repostAvatar: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].repostAvatar,
                                                                                    repostUserId: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].repostUser,
                                                                                    isRepostProfile: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].repostProfileType,
                                                                                    getBillBoardListData: getRelatedData,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: width / 41.1,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () async {
                                                                                            bool response = await Navigator.push(context,
                                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                              return UserBillBoardProfilePage(
                                                                                                  userId: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId);
                                                                                            }));
                                                                                            if (response) {
                                                                                              getBillBoardData();
                                                                                            }
                                                                                          },
                                                                                          child: Text(
                                                                                            mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].username
                                                                                                .toString()
                                                                                                .capitalizeFirst!,
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(12),
                                                                                                fontWeight: FontWeight.w700,
                                                                                                fontFamily: "Poppins"),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].createdAt,
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  color: const Color(0XFF737373),
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  fontFamily: "Poppins"),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 3,
                                                                                            ),
                                                                                            Text(
                                                                                              " | ",
                                                                                              style: TextStyle(
                                                                                                fontSize: text.scale(11),
                                                                                                color: const Color(0XFF737373),
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 3,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                billboardWidgetsMain.believersTabBottomSheet(
                                                                                                  context: context,
                                                                                                  id: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId,
                                                                                                  isBelieversList: true,
                                                                                                );
                                                                                              },
                                                                                              child: Text(
                                                                                                "${mainVariables.valueMapListProfileRelatedPage[index].believersCount} Believers",
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    color: const Color(0XFF737373),
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    fontFamily: "Poppins"),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  userIdMain !=
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].userId
                                                                                      ? billboardWidgetsMain.getHomeBelieveButton(
                                                                                          heightValue: height / 33.76,
                                                                                          isBelieved: List.generate(
                                                                                              mainVariables.valueMapListProfileRelatedPage.length,
                                                                                              (ind) => mainVariables
                                                                                                  .valueMapListProfileRelatedPage[ind].believed),
                                                                                          billboardUserid: mainVariables
                                                                                              .valueMapListProfileRelatedPage[index].userId,
                                                                                          billboardUserName: mainVariables
                                                                                              .valueMapListProfileRelatedPage[index].username,
                                                                                          context: context,
                                                                                          modelSetState: setState,
                                                                                          index: index,
                                                                                          background: false,
                                                                                        )
                                                                                      : const SizedBox(),

                                                                                  ///more_vert
                                                                                  IconButton(
                                                                                      onPressed: () {
                                                                                        billboardWidgetsMain.bottomSheet(
                                                                                          context1: context,
                                                                                          myself: userIdMain ==
                                                                                              mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].userId,
                                                                                          billboardId:
                                                                                              mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                          billboardUserId: mainVariables
                                                                                              .valueMapListProfileRelatedPage[index].userId,
                                                                                          type: "billboard",
                                                                                          responseId: "",
                                                                                          responseUserId: "",
                                                                                          commentId: "",
                                                                                          commentUserId: "",
                                                                                          callFunction: getData,
                                                                                          contentType: mainVariables
                                                                                              .valueMapListProfileRelatedPage[index].type,
                                                                                          modelSetState: setState,
                                                                                          responseDetail: {},
                                                                                          category: mainVariables
                                                                                              .valueMapListProfileRelatedPage[index].category,
                                                                                          valueMapList: mainVariables.valueMapListProfileRelatedPage,
                                                                                          index: index,
                                                                                        );
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons.more_vert,
                                                                                        color: Theme.of(context).colorScheme.onBackground,
                                                                                        size: 25,
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: height / 64),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            switch (mainVariables.valueMapListProfileRelatedPage[index].type) {
                                                                              case "blog":
                                                                                {
                                                                                  mainVariables.selectedBillboardIdMain.value =
                                                                                      mainVariables.valueMapListProfileRelatedPage[index].id;
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (BuildContext context) =>
                                                                                              const BlogDescriptionPage()));
                                                                                  break;
                                                                                }
                                                                              case "byte":
                                                                                {
                                                                                  mainVariables.selectedBillboardIdMain.value =
                                                                                      mainVariables.valueMapListProfileRelatedPage[index].id;
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (BuildContext context) =>
                                                                                              const BytesDescriptionPage()));
                                                                                  break;
                                                                                }
                                                                              case "forums":
                                                                                {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                              idList: List.generate(
                                                                                                  mainVariables.valueMapListProfileRelatedPage.length,
                                                                                                  (ind) => mainVariables
                                                                                                      .valueMapListProfileRelatedPage[ind].id),
                                                                                              comeFrom: "billBoardHome",
                                                                                              forumId: mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].id)));
                                                                                  break;
                                                                                }
                                                                              case "survey":
                                                                                {
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
                                                                                    'survey_id':
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                  });
                                                                                  var responseData = json.decode(response.body);
                                                                                  if (responseData["status"]) {
                                                                                    activeStatus = responseData["response"]["status"];
                                                                                    if (activeStatus == "active") {
                                                                                      var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                                      var response = await http.post(url, headers: {
                                                                                        'Authorization': mainUserToken
                                                                                      }, body: {
                                                                                        'survey_id':
                                                                                            mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                      });
                                                                                      var responseData = json.decode(response.body);
                                                                                      if (responseData["status"]) {
                                                                                        answerStatus = responseData["response"][0]["final_question"];
                                                                                        answeredQuestion =
                                                                                            responseData["response"][0]["question_number"];
                                                                                      } else {
                                                                                        answerStatus = false;
                                                                                        answeredQuestion = 0;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  if (!mounted) {
                                                                                    return;
                                                                                  }
                                                                                  mainUserId ==
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].userId
                                                                                      ? Navigator.push(context,
                                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return AnalyticsPage(
                                                                                            surveyId: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            activity: false,
                                                                                            surveyTitle: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].title,
                                                                                            navBool: false,
                                                                                            fromWhere: 'similar',
                                                                                          );
                                                                                        }))
                                                                                      : activeStatus == 'active'
                                                                                          ? answerStatus
                                                                                              ? Navigator.push(context,
                                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                                  return AnalyticsPage(
                                                                                                      surveyId: mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index].id,
                                                                                                      activity: false,
                                                                                                      navBool: false,
                                                                                                      fromWhere: 'similar',
                                                                                                      surveyTitle: mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .title);
                                                                                                }))
                                                                                              : Navigator.push(context,
                                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                                  return QuestionnairePage(
                                                                                                    surveyId: mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].id,
                                                                                                    defaultIndex: answeredQuestion,
                                                                                                  );
                                                                                                }))
                                                                                          : Navigator.push(context,
                                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                                              return AnalyticsPage(
                                                                                                surveyId: mainVariables
                                                                                                    .valueMapListProfileRelatedPage[index].id,
                                                                                                activity: false,
                                                                                                surveyTitle: mainVariables
                                                                                                    .valueMapListProfileRelatedPage[index].title,
                                                                                                navBool: false,
                                                                                                fromWhere: 'similar',
                                                                                              );
                                                                                            }));
                                                                                  break;
                                                                                }
                                                                              default:
                                                                                {
                                                                                  break;
                                                                                }
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            height: height / 9,
                                                                            color: Theme.of(context).colorScheme.onBackground,
                                                                            alignment: Alignment.topLeft,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(12.0),
                                                                              child: RichText(
                                                                                textAlign: TextAlign.left,
                                                                                text: TextSpan(
                                                                                  children: conversationFunctionsMain.spanListBillBoardHome(
                                                                                      message: mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                  .title.length >
                                                                                              140
                                                                                          ? mainVariables.valueMapListProfileRelatedPage[index].title
                                                                                              .substring(0, 140)
                                                                                          : mainVariables.valueMapListProfileRelatedPage[index].title,
                                                                                      context: context,
                                                                                      isByte: true),
                                                                                ),
                                                                              ) /*Text( mainVariables.valueMapListProfileRelatedPage[index].title.toString().capitalizeFirst!,
                                                     style:TextStyle(
                                                       fontSize: _text.scale(10)14,
                                                       fontWeight: FontWeight.w400,
                                                       color: Color(0XFF403D3D),
                                                     ),
                                                     textAlign: TextAlign.justify,
                                                     maxLines: 3,
                                                     overflow: TextOverflow.ellipsis,
                                                   )*/
                                                                              ,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Theme.of(context).colorScheme.onBackground,
                                                                            borderRadius: const BorderRadius.only(
                                                                                bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: height / 86.6,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Row(children: [
                                                                                    SizedBox(
                                                                                      width: width / 41.1,
                                                                                    ),
                                                                                    billboardWidgetsMain.likeButtonHomeListWidget(
                                                                                      likeList: List.generate(
                                                                                          mainVariables.valueMapListProfileRelatedPage.length,
                                                                                          (ind) =>
                                                                                              mainVariables.valueMapListProfileRelatedPage[ind].like),
                                                                                      id: mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                      index: index,
                                                                                      context: context,
                                                                                      initFunction: () {},
                                                                                      modelSetState: setState,
                                                                                      notUse: true,
                                                                                      dislikeList: List.generate(
                                                                                          mainVariables.valueMapListProfileRelatedPage.length,
                                                                                          (ind) => mainVariables
                                                                                              .valueMapListProfileRelatedPage[ind].dislike),
                                                                                      likeCountList: List.generate(
                                                                                          mainVariables.valueMapListProfileRelatedPage.length,
                                                                                          (ind) => mainVariables
                                                                                              .valueMapListProfileRelatedPage[ind].likesCount),
                                                                                      dislikeCountList: List.generate(
                                                                                          mainVariables.valueMapListProfileRelatedPage.length,
                                                                                          (ind) => mainVariables
                                                                                              .valueMapListProfileRelatedPage[ind].disLikesCount),
                                                                                      type: mainVariables.valueMapListProfileRelatedPage[index].type,
                                                                                      billBoardType:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].type ==
                                                                                                  "news"
                                                                                              ? "news"
                                                                                              : mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                          .type ==
                                                                                                      "forums"
                                                                                                  ? "forums"
                                                                                                  : mainVariables
                                                                                                              .valueMapListProfileRelatedPage[index]
                                                                                                              .type ==
                                                                                                          "survey"
                                                                                                      ? "survey"
                                                                                                      : "billboard",
                                                                                      /*mainVariables.valueMapListProfileRelatedPage[index].type=='survey'?'survey':'billboard',*/
                                                                                      image:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].avatar,
                                                                                      title:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].title,
                                                                                      description: "",
                                                                                      fromWhere: 'homePage',
                                                                                      responseId: '',
                                                                                      controller: bottomSheetController,
                                                                                      commentId: '',
                                                                                      postUserId:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].userId,
                                                                                      responseFocusList: mainVariables.responseFocusRelatedList,
                                                                                      responseUserId: '',
                                                                                      valueMapList: mainVariables.valueMapListProfileRelatedPage,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width / 27.4,
                                                                                    ),
                                                                                    /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfileRelatedPage.length, (ind) =>  mainVariables.valueMapListProfileRelatedPage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3.2,
                                                            id: mainVariables.valueMapListProfileRelatedPage[index].id,
                                                            type:mainVariables.valueMapListProfileRelatedPage[index].type=="byte"||mainVariables.valueMapListProfileRelatedPage[index].type=="blog"?"billboard":mainVariables.valueMapListProfileRelatedPage[index].type,
                                                            modelSetState: setState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false,
                                                          ),*/
                                                                                    billboardWidgetsMain.billBoardBookMarkWidget(
                                                                                        context: context, index: index),
                                                                                  ]),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                      .repostCount ==
                                                                                                  0 ||
                                                                                              mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                      .repostAvatar ==
                                                                                                  ""
                                                                                          ? const SizedBox()
                                                                                          : GestureDetector(
                                                                                              onTap: () {
                                                                                                billboardWidgetsMain.believedTabBottomSheet(
                                                                                                    context: context,
                                                                                                    id: mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index]
                                                                                                        .repostId,
                                                                                                    type: mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].type);
                                                                                              },
                                                                                              child: Stack(
                                                                                                children: [
                                                                                                  const SizedBox(
                                                                                                    height: 30,
                                                                                                    width: 30,
                                                                                                  ),
                                                                                                  Positioned(
                                                                                                    left: 0,
                                                                                                    bottom: 0,
                                                                                                    child: Container(
                                                                                                      height: 25,
                                                                                                      width: 25,
                                                                                                      decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                          image: const DecorationImage(
                                                                                                            image: AssetImage(
                                                                                                                "lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                                                          )),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Positioned(
                                                                                                    top: 0,
                                                                                                    right: 0,
                                                                                                    child: Container(
                                                                                                      height: 15,
                                                                                                      width: 15,
                                                                                                      decoration: const BoxDecoration(
                                                                                                          shape: BoxShape.circle, color: Colors.red),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                        mainVariables
                                                                                                                    .valueMapListProfileRelatedPage[
                                                                                                                        index]
                                                                                                                    .repostCount >
                                                                                                                9
                                                                                                            ? "9+"
                                                                                                            : mainVariables
                                                                                                                .valueMapListProfileRelatedPage[index]
                                                                                                                .repostCount
                                                                                                                .toString(),
                                                                                                        style: const TextStyle(
                                                                                                            color: Colors.white, fontSize: 10),
                                                                                                      )),
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                      SizedBox(
                                                                                        width: width / 27.4,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 35,
                                                                                        width: 35,
                                                                                        child: billboardWidgetsMain.translationWidget(
                                                                                            id: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            type: mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].type ==
                                                                                                    "forums"
                                                                                                ? "forums"
                                                                                                : mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                            .type ==
                                                                                                        "survey"
                                                                                                    ? "survey"
                                                                                                    : mainVariables
                                                                                                                .valueMapListProfileRelatedPage[index]
                                                                                                                .type ==
                                                                                                            "news"
                                                                                                        ? "news"
                                                                                                        : 'billboard',
                                                                                            index: index,
                                                                                            initFunction: getData,
                                                                                            context: context,
                                                                                            modelSetState: setState,
                                                                                            notUse: false,
                                                                                            valueMapList:
                                                                                                mainVariables.valueMapListProfileRelatedPage),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: width / 27.4,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: height / 64),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      mainVariables.valueMapListProfileRelatedPage[index].companyName,
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          color: const Color(0xFF017FDB),
                                                                                          fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                                                            context: context,
                                                                                            billBoardId: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            responseId: "",
                                                                                            commentId: "",
                                                                                            billBoardType: "billboard",
                                                                                            action: "views",
                                                                                            likeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].likesCount
                                                                                                .toString(),
                                                                                            disLikeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].disLikesCount
                                                                                                .toString(),
                                                                                            index: 0,
                                                                                            viewCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].viewsCount
                                                                                                .toString(),
                                                                                            isViewIncluded: true);
                                                                                      },
                                                                                      child: Text(
                                                                                        " ${mainVariables.valueMapListProfileRelatedPage[index].viewsCount} views ",
                                                                                        style: TextStyle(fontSize: text.scale(10)),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                                                            context: context,
                                                                                            billBoardId: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            responseId: "",
                                                                                            commentId: "",
                                                                                            billBoardType: "billboard",
                                                                                            action: "likes",
                                                                                            likeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].likesCount
                                                                                                .toString(),
                                                                                            disLikeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].disLikesCount
                                                                                                .toString(),
                                                                                            index: 1,
                                                                                            viewCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].viewsCount
                                                                                                .toString(),
                                                                                            isViewIncluded: true);
                                                                                      },
                                                                                      child: Text(
                                                                                        " ${mainVariables.valueMapListProfileRelatedPage[index].likesCount} likes ",
                                                                                        style: TextStyle(fontSize: text.scale(10)),
                                                                                      ),
                                                                                    ),
                                                                                    /* InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.getLikeDislikeUsersList(
                                                              context: context,
                                                              billBoardId:mainVariables.valueMapListProfileRelatedPage[index].id,
                                                              responseId:"",
                                                              commentId:"",
                                                              billBoardType:"billboard",
                                                              action:"dislikes",
                                                              likeCount: mainVariables.valueMapListProfileRelatedPage[index].likesCount.toString(),
                                                              disLikeCount:mainVariables.valueMapListProfileRelatedPage[index].disLikesCount.toString(),
                                                              index: 2,
                                                              viewCount: mainVariables.valueMapListProfileRelatedPage[index].viewsCount.toString(),
                                                              isViewIncluded: true
                                                          );
                                                        },
                                                        child: Text(
                                                          " ${mainVariables.valueMapListProfileRelatedPage[index].disLikesCount} DisLikes ",
                                                          style: TextStyle(
                                                              fontSize: _text.scale(10)10,
                                                              color: Colors.black54),
                                                        ),
                                                      ),*/
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        switch (mainVariables
                                                                                            .valueMapListProfileRelatedPage[index].type) {
                                                                                          case "blog":
                                                                                            {
                                                                                              mainVariables.selectedBillboardIdMain.value =
                                                                                                  mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].id;
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                      builder: (BuildContext context) =>
                                                                                                          const BlogDescriptionPage()));
                                                                                              break;
                                                                                            }
                                                                                          case "byte":
                                                                                            {
                                                                                              mainVariables.selectedBillboardIdMain.value =
                                                                                                  mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].id;
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                      builder: (BuildContext context) =>
                                                                                                          const BytesDescriptionPage()));
                                                                                              break;
                                                                                            }
                                                                                          case "forums":
                                                                                            {
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                      builder: (BuildContext context) =>
                                                                                                          ForumPostDescriptionPage(
                                                                                                              idList: List.generate(
                                                                                                                  mainVariables
                                                                                                                      .valueMapListProfileRelatedPage
                                                                                                                      .length,
                                                                                                                  (ind) => mainVariables
                                                                                                                      .valueMapListProfileRelatedPage[
                                                                                                                          ind]
                                                                                                                      .id),
                                                                                                              comeFrom: "billBoardHome",
                                                                                                              forumId: mainVariables
                                                                                                                  .valueMapListProfileRelatedPage[
                                                                                                                      index]
                                                                                                                  .id)));
                                                                                              break;
                                                                                            }
                                                                                          case "survey":
                                                                                            {
                                                                                              String activeStatus = "";
                                                                                              bool answerStatus = false;
                                                                                              int answeredQuestion = 0;
                                                                                              SharedPreferences prefs =
                                                                                                  await SharedPreferences.getInstance();
                                                                                              String mainUserId = prefs.getString('newUserId') ?? "";
                                                                                              String mainUserToken =
                                                                                                  prefs.getString('newUserToken') ?? "";
                                                                                              var url = Uri.parse(
                                                                                                  baseurl + versionSurvey + surveyStatusCheck);
                                                                                              var response = await http.post(url, headers: {
                                                                                                'Authorization': mainUserToken
                                                                                              }, body: {
                                                                                                'survey_id': mainVariables
                                                                                                    .valueMapListProfileRelatedPage[index].id,
                                                                                              });
                                                                                              var responseData = json.decode(response.body);
                                                                                              if (responseData["status"]) {
                                                                                                activeStatus = responseData["response"]["status"];
                                                                                                if (activeStatus == "active") {
                                                                                                  var url = Uri.parse(
                                                                                                      baseurl + versionSurvey + checkAnswer);
                                                                                                  var response = await http.post(url, headers: {
                                                                                                    'Authorization': mainUserToken
                                                                                                  }, body: {
                                                                                                    'survey_id': mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].id,
                                                                                                  });
                                                                                                  var responseData = json.decode(response.body);
                                                                                                  if (responseData["status"]) {
                                                                                                    answerStatus =
                                                                                                        responseData["response"][0]["final_question"];
                                                                                                    answeredQuestion = responseData["response"][0]
                                                                                                        ["question_number"];
                                                                                                  } else {
                                                                                                    answerStatus = false;
                                                                                                    answeredQuestion = 0;
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              mainUserId ==
                                                                                                      mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .userId
                                                                                                  ? Navigator.push(context, MaterialPageRoute(
                                                                                                      builder: (BuildContext context) {
                                                                                                      return AnalyticsPage(
                                                                                                        surveyId: mainVariables
                                                                                                            .valueMapListProfileRelatedPage[index].id,
                                                                                                        activity: false,
                                                                                                        surveyTitle: mainVariables
                                                                                                            .valueMapListProfileRelatedPage[index]
                                                                                                            .title,
                                                                                                        navBool: false,
                                                                                                        fromWhere: 'similar',
                                                                                                      );
                                                                                                    }))
                                                                                                  : activeStatus == 'active'
                                                                                                      ? answerStatus
                                                                                                          ? Navigator.push(context, MaterialPageRoute(
                                                                                                              builder: (BuildContext context) {
                                                                                                              return AnalyticsPage(
                                                                                                                  surveyId: mainVariables
                                                                                                                      .valueMapListProfileRelatedPage[
                                                                                                                          index]
                                                                                                                      .id,
                                                                                                                  activity: false,
                                                                                                                  navBool: false,
                                                                                                                  fromWhere: 'similar',
                                                                                                                  surveyTitle: mainVariables
                                                                                                                      .valueMapListProfileRelatedPage[
                                                                                                                          index]
                                                                                                                      .title);
                                                                                                            }))
                                                                                                          : Navigator.push(context, MaterialPageRoute(
                                                                                                              builder: (BuildContext context) {
                                                                                                              return QuestionnairePage(
                                                                                                                surveyId: mainVariables
                                                                                                                    .valueMapListProfileRelatedPage[
                                                                                                                        index]
                                                                                                                    .id,
                                                                                                                defaultIndex: answeredQuestion,
                                                                                                              );
                                                                                                            }))
                                                                                                      : Navigator.push(context, MaterialPageRoute(
                                                                                                          builder: (BuildContext context) {
                                                                                                          return AnalyticsPage(
                                                                                                            surveyId: mainVariables
                                                                                                                .valueMapListProfileRelatedPage[index]
                                                                                                                .id,
                                                                                                            activity: false,
                                                                                                            surveyTitle: mainVariables
                                                                                                                .valueMapListProfileRelatedPage[index]
                                                                                                                .title,
                                                                                                            navBool: false,
                                                                                                            fromWhere: 'similar',
                                                                                                          );
                                                                                                        }));
                                                                                              break;
                                                                                            }
                                                                                          default:
                                                                                            {
                                                                                              break;
                                                                                            }
                                                                                        }
                                                                                      },
                                                                                      child: Text(
                                                                                        " ${mainVariables.valueMapListProfileRelatedPage[index].responseCount} Responses ",
                                                                                        style: TextStyle(fontSize: text.scale(10)),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: height / 42.6),
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        bool response = await Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return UserBillBoardProfilePage(
                                                                                            userId: userIdMain,
                                                                                          );
                                                                                        }));
                                                                                        if (response) {
                                                                                          getBillBoardData();
                                                                                        }
                                                                                      },
                                                                                      child: CircleAvatar(
                                                                                          radius: 22,
                                                                                          backgroundImage: NetworkImage(avatarMain.value)),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width / 41.1,
                                                                                    ),
                                                                                    billboardWidgetsMain.getResponseRelatedField(
                                                                                      context: context,
                                                                                      modelSetState: setState,
                                                                                      billBoardId:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                      postUserId:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].userId,
                                                                                      responseId: "",
                                                                                      index: index,
                                                                                      fromWhere: 'homePage',
                                                                                      callFunction: () {},
                                                                                      contentType:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].type,
                                                                                      category: mainVariables
                                                                                          .valueMapListProfileRelatedPage[index].category,
                                                                                      responseCountList: List.generate(
                                                                                          mainVariables.valueMapListProfileRelatedPage.length,
                                                                                          (ind) => mainVariables
                                                                                              .valueMapListProfileRelatedPage[ind].responseCount),
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
                                                                : //final //NonBelievedCategory, files, byte
                                                                Container(
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                                                      BoxShadow(
                                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                                          blurRadius: 4.0,
                                                                          spreadRadius: 0.0)
                                                                    ]),
                                                                    child: Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            switch (mainVariables.valueMapListProfileRelatedPage[index].type) {
                                                                              case "blog":
                                                                                {
                                                                                  mainVariables.selectedBillboardIdMain.value =
                                                                                      mainVariables.valueMapListProfileRelatedPage[index].id;
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (BuildContext context) =>
                                                                                              const BlogDescriptionPage()));
                                                                                  break;
                                                                                }
                                                                              case "byte":
                                                                                {
                                                                                  mainVariables.selectedBillboardIdMain.value =
                                                                                      mainVariables.valueMapListProfileRelatedPage[index].id;
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (BuildContext context) =>
                                                                                              const BytesDescriptionPage()));
                                                                                  break;
                                                                                }
                                                                              case "forums":
                                                                                {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                              idList: List.generate(
                                                                                                  mainVariables.valueMapListProfileRelatedPage.length,
                                                                                                  (ind) => mainVariables
                                                                                                      .valueMapListProfileRelatedPage[ind].id),
                                                                                              comeFrom: "billBoardHome",
                                                                                              forumId: mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].id)));
                                                                                  break;
                                                                                }
                                                                              case "survey":
                                                                                {
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
                                                                                    'survey_id':
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                  });
                                                                                  var responseData = json.decode(response.body);
                                                                                  if (responseData["status"]) {
                                                                                    activeStatus = responseData["response"]["status"];

                                                                                    if (activeStatus == "active") {
                                                                                      var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                                      var response = await http.post(url, headers: {
                                                                                        'Authorization': mainUserToken
                                                                                      }, body: {
                                                                                        'survey_id':
                                                                                            mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                      });
                                                                                      var responseData = json.decode(response.body);
                                                                                      if (responseData["status"]) {
                                                                                        answerStatus = responseData["response"][0]["final_question"];
                                                                                        answeredQuestion =
                                                                                            responseData["response"][0]["question_number"];
                                                                                      } else {
                                                                                        answerStatus = false;
                                                                                        answeredQuestion = 0;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  if (!mounted) {
                                                                                    return;
                                                                                  }
                                                                                  mainUserId ==
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].userId
                                                                                      ? Navigator.push(context,
                                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return AnalyticsPage(
                                                                                            surveyId: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            activity: false,
                                                                                            surveyTitle: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].title,
                                                                                            navBool: false,
                                                                                            fromWhere: 'similar',
                                                                                          );
                                                                                        }))
                                                                                      : activeStatus == 'active'
                                                                                          ? answerStatus
                                                                                              ? Navigator.push(context,
                                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                                  return AnalyticsPage(
                                                                                                      surveyId: mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index].id,
                                                                                                      activity: false,
                                                                                                      navBool: false,
                                                                                                      fromWhere: 'similar',
                                                                                                      surveyTitle: mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .title);
                                                                                                }))
                                                                                              : Navigator.push(context,
                                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                                  return QuestionnairePage(
                                                                                                    surveyId: mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].id,
                                                                                                    defaultIndex: answeredQuestion,
                                                                                                  );
                                                                                                }))
                                                                                          : Navigator.push(context,
                                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                                              return AnalyticsPage(
                                                                                                surveyId: mainVariables
                                                                                                    .valueMapListProfileRelatedPage[index].id,
                                                                                                activity: false,
                                                                                                surveyTitle: mainVariables
                                                                                                    .valueMapListProfileRelatedPage[index].title,
                                                                                                navBool: false,
                                                                                                fromWhere: 'similar',
                                                                                              );
                                                                                            }));
                                                                                  break;
                                                                                }
                                                                              default:
                                                                                {
                                                                                  break;
                                                                                }
                                                                            }
                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              Container(
                                                                                  height: height / 3.97,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context).colorScheme.onBackground,
                                                                                    borderRadius: const BorderRadius.only(
                                                                                        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                                  ),
                                                                                  child: CarouselSlider.builder(
                                                                                    carouselController: _carController,
                                                                                    options: CarouselOptions(
                                                                                        enableInfiniteScroll: false,
                                                                                        enlargeCenterPage: false,
                                                                                        onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                                                          setState(() {
                                                                                            carouselIndexGlobal = index;
                                                                                          });
                                                                                        }),
                                                                                    itemCount: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].files.length,
                                                                                    itemBuilder:
                                                                                        (BuildContext context, int carouselIndex, int realIndex) {
                                                                                      return mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                  .files[carouselIndex].type ==
                                                                                              "image"
                                                                                          ? Image.network(
                                                                                              mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                  .files[carouselIndex].file,
                                                                                              fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                                                              return Image.asset(
                                                                                                  "lib/Constants/Assets/Settings/coverImage_default.png");
                                                                                            })
                                                                                          : mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                      .files[carouselIndex].type ==
                                                                                                  "video"
                                                                                              ? Stack(
                                                                                                  alignment: Alignment.center,
                                                                                                  children: [
                                                                                                    Image.asset(
                                                                                                      "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                                                      fit: BoxFit.fill,
                                                                                                      height: height / 3.97,
                                                                                                    ),
                                                                                                    Container(
                                                                                                        height: 50,
                                                                                                        width: 50,
                                                                                                        decoration: BoxDecoration(
                                                                                                            shape: BoxShape.circle,
                                                                                                            color: Colors.black26.withOpacity(0.7)),
                                                                                                        child: const Icon(
                                                                                                          Icons.play_arrow_sharp,
                                                                                                          color: Colors.white,
                                                                                                          size: 40,
                                                                                                        ))
                                                                                                  ],
                                                                                                )
                                                                                              : mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                          .files[carouselIndex].type ==
                                                                                                      "document"
                                                                                                  ? Stack(
                                                                                                      alignment: Alignment.center,
                                                                                                      children: [
                                                                                                        Image.asset(
                                                                                                          "lib/Constants/Assets/Settings/coverImage.png",
                                                                                                          fit: BoxFit.fill,
                                                                                                          height: height / 3.97,
                                                                                                        ),
                                                                                                        Container(
                                                                                                          height: 50,
                                                                                                          width: 50,
                                                                                                          decoration: BoxDecoration(
                                                                                                            shape: BoxShape.circle,
                                                                                                            color: Colors.black26.withOpacity(0.3),
                                                                                                          ),
                                                                                                          child: Center(
                                                                                                            child: Image.asset(
                                                                                                              "lib/Constants/Assets/BillBoard/document.png",
                                                                                                              color: Colors.white,
                                                                                                              height: 25,
                                                                                                              width: 25,
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  : const SizedBox();
                                                                                    },
                                                                                  )),
                                                                              Positioned(
                                                                                top: 0,
                                                                                left: 0,
                                                                                child: Container(
                                                                                  height: height / 18,
                                                                                  width: width / 1.06,
                                                                                  padding: EdgeInsets.only(
                                                                                    left: width / 27.4,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.black12.withOpacity(0.3),
                                                                                    borderRadius: const BorderRadius.only(
                                                                                      topLeft: Radius.circular(15),
                                                                                      topRight: Radius.circular(15),
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfileRelatedPagevalueMapListProfileRelatedPage.length, (ind) => mainVariables.valueMapListProfileRelatedPage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfileRelatedPage[index].id,
                                                            type:mainVariables.valueMapListProfileRelatedPage[index].type=="byte"||mainVariables.valueMapListProfileRelatedPage[index].type=="blog"?"billboard":mainVariables.valueMapListProfileRelatedPage[index].type,
                                                            modelSetState: setState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                                                          billboardWidgetsMain.billBoardBookMarkWidget(
                                                                                              context: context, index: index),
                                                                                          const SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                          billboardWidgetsMain.translationWidget(
                                                                                              id: mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].id,
                                                                                              type: mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .type ==
                                                                                                      "forums"
                                                                                                  ? "forums"
                                                                                                  : mainVariables
                                                                                                              .valueMapListProfileRelatedPage[index]
                                                                                                              .type ==
                                                                                                          "survey"
                                                                                                      ? "survey"
                                                                                                      : mainVariables
                                                                                                                  .valueMapListProfileRelatedPage[
                                                                                                                      index]
                                                                                                                  .type ==
                                                                                                              "news"
                                                                                                          ? "news"
                                                                                                          : 'billboard',
                                                                                              index: index,
                                                                                              initFunction: getData,
                                                                                              context: context,
                                                                                              modelSetState: setState,
                                                                                              notUse: false,
                                                                                              valueMapList:
                                                                                                  mainVariables.valueMapListProfileRelatedPage),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          userIdMain !=
                                                                                                  mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId
                                                                                              ? billboardWidgetsMain.getHomeBelieveButton(
                                                                                                  heightValue: height / 33.76,
                                                                                                  isBelieved: List.generate(
                                                                                                      mainVariables
                                                                                                          .valueMapListProfileRelatedPage.length,
                                                                                                      (ind) => mainVariables
                                                                                                          .valueMapListProfileRelatedPage[ind]
                                                                                                          .believed),
                                                                                                  billboardUserid: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId,
                                                                                                  billboardUserName: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].username,
                                                                                                  context: context,
                                                                                                  modelSetState: setState,
                                                                                                  index: index,
                                                                                                  background: true,
                                                                                                )
                                                                                              : const SizedBox(),

                                                                                          ///more_vert
                                                                                          IconButton(
                                                                                              onPressed: () {
                                                                                                billboardWidgetsMain.bottomSheet(
                                                                                                  context1: context,
                                                                                                  myself: userIdMain ==
                                                                                                      mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .userId,
                                                                                                  billboardId: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].id,
                                                                                                  billboardUserId: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId,
                                                                                                  type: "billboard",
                                                                                                  responseId: "",
                                                                                                  responseUserId: "",
                                                                                                  commentId: "",
                                                                                                  commentUserId: "",
                                                                                                  callFunction: getData,
                                                                                                  contentType: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].type,
                                                                                                  modelSetState: setState,
                                                                                                  responseDetail: {},
                                                                                                  category: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].category,
                                                                                                  valueMapList:
                                                                                                      mainVariables.valueMapListProfileRelatedPage,
                                                                                                  index: index,
                                                                                                );
                                                                                              },
                                                                                              icon: const Icon(
                                                                                                Icons.more_vert,
                                                                                                color: Colors.white,
                                                                                                size: 25,
                                                                                              ))
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              mainVariables.valueMapListProfileRelatedPage[index].files.length > 1
                                                                                  ? Positioned(
                                                                                      bottom: 75,
                                                                                      left: (width / 2) - 35,
                                                                                      child: SizedBox(
                                                                                        height: 5,
                                                                                        child: ListView.builder(
                                                                                            shrinkWrap: true,
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                                            itemCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].files.length,
                                                                                            itemBuilder: (BuildContext context, int index1) {
                                                                                              return Container(
                                                                                                height: 5,
                                                                                                width: carouselIndexGlobal == index1 ? 20 : 5,
                                                                                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                                    color: carouselIndexGlobal == index1
                                                                                                        ? const Color(0XFF0EA102)
                                                                                                        : Colors.white),
                                                                                              );
                                                                                            }),
                                                                                      ))
                                                                                  : const SizedBox(),
                                                                              mainVariables.valueMapListProfileRelatedPage[index].repostCount == 0 ||
                                                                                      mainVariables
                                                                                              .valueMapListProfileRelatedPage[index].repostAvatar ==
                                                                                          ""
                                                                                  ? const SizedBox()
                                                                                  : Positioned(
                                                                                      top: height / 15,
                                                                                      right: 15,
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          billboardWidgetsMain.believedTabBottomSheet(
                                                                                              context: context,
                                                                                              id: mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].repostId,
                                                                                              type: mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].type);
                                                                                        },
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            const SizedBox(
                                                                                              height: 35,
                                                                                              width: 35,
                                                                                            ),
                                                                                            Positioned(
                                                                                              left: 0,
                                                                                              bottom: 0,
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 30,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                    image: const DecorationImage(
                                                                                                      image: AssetImage(
                                                                                                          "lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                                                    )),
                                                                                              ),
                                                                                            ),
                                                                                            Positioned(
                                                                                              top: 0,
                                                                                              right: 0,
                                                                                              child: Container(
                                                                                                height: 15,
                                                                                                width: 15,
                                                                                                decoration: const BoxDecoration(
                                                                                                    shape: BoxShape.circle, color: Colors.red),
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                              .repostCount >
                                                                                                          9
                                                                                                      ? "9+"
                                                                                                      : mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .repostCount
                                                                                                          .toString(),
                                                                                                  style: const TextStyle(
                                                                                                      color: Colors.white, fontSize: 10),
                                                                                                )),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                              Positioned(
                                                                                bottom: 0,
                                                                                left: 0,
                                                                                child: Container(
                                                                                  height: height / 14,
                                                                                  width: width,
                                                                                  padding: EdgeInsets.only(
                                                                                      top: height / 86.6,
                                                                                      bottom: height / 86.6,
                                                                                      right: width / 13.7,
                                                                                      left: width / 41.1),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.black12.withOpacity(0.3),
                                                                                  ),
                                                                                  child: RichText(
                                                                                    textAlign: TextAlign.left,
                                                                                    text: TextSpan(
                                                                                      children: conversationFunctionsMain.spanListBillBoardHome(
                                                                                          message: mainVariables.valueMapListProfileRelatedPage[index]
                                                                                                      .title.length >
                                                                                                  100
                                                                                              ? mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].title
                                                                                                  .substring(0, 100)
                                                                                              : mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].title,
                                                                                          context: context,
                                                                                          isByte: false),
                                                                                    ),
                                                                                  ) /*Text(
                                                         mainVariables.valueMapListProfileRelatedPage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                                                                  ,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Theme.of(context).colorScheme.onBackground,
                                                                            borderRadius: const BorderRadius.only(
                                                                                bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: height / 86.6,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: width / 41.1,
                                                                                  ),
                                                                                  billboardWidgetsMain.getProfile(
                                                                                    context: context,
                                                                                    heightValue: height / 17.32,
                                                                                    widthValue: width / 8.22,
                                                                                    myself: false,
                                                                                    avatar:
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].avatar,
                                                                                    isProfile: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].profileType,
                                                                                    userId:
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].userId,
                                                                                    repostAvatar: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].repostAvatar,
                                                                                    repostUserId: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].repostUser,
                                                                                    isRepostProfile: mainVariables
                                                                                        .valueMapListProfileRelatedPage[index].repostProfileType,
                                                                                    getBillBoardListData: getBillBoardData,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: width / 41.1,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () async {
                                                                                            /*Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0);}));*/
                                                                                            bool response = await Navigator.push(context,
                                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                              return UserBillBoardProfilePage(
                                                                                                  userId: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId);
                                                                                            }));
                                                                                            if (response) {
                                                                                              getBillBoardData();
                                                                                            }
                                                                                          },
                                                                                          child: Text(
                                                                                            mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].username
                                                                                                .toString()
                                                                                                .capitalizeFirst!,
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(12),
                                                                                                fontWeight: FontWeight.w700,
                                                                                                fontFamily: "Poppins"),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              mainVariables
                                                                                                  .valueMapListProfileRelatedPage[index].createdAt,
                                                                                              style: TextStyle(
                                                                                                  fontSize: text.scale(10),
                                                                                                  color: const Color(0XFF737373),
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  fontFamily: "Poppins"),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 3,
                                                                                            ),
                                                                                            Text(
                                                                                              " | ",
                                                                                              style: TextStyle(
                                                                                                fontSize: text.scale(11),
                                                                                                color: const Color(0XFF737373),
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 3,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () async {
                                                                                                billboardWidgetsMain.believersTabBottomSheet(
                                                                                                  context: context,
                                                                                                  id: mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].userId,
                                                                                                  isBelieversList: true,
                                                                                                );
                                                                                              },
                                                                                              child: Text(
                                                                                                "${mainVariables.valueMapListProfileRelatedPage[index].believersCount} Believers",
                                                                                                style: TextStyle(
                                                                                                    fontSize: text.scale(10),
                                                                                                    color: const Color(0XFF737373),
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    fontFamily: "Poppins"),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  billboardWidgetsMain.likeButtonHomeListWidget(
                                                                                    likeList: List.generate(
                                                                                        mainVariables.valueMapListProfileRelatedPage.length,
                                                                                        (ind) =>
                                                                                            mainVariables.valueMapListProfileRelatedPage[ind].like),
                                                                                    id: mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                    index: index,
                                                                                    context: context,
                                                                                    initFunction: () {},
                                                                                    modelSetState: setState,
                                                                                    notUse: true,
                                                                                    dislikeList: List.generate(
                                                                                        mainVariables.valueMapListProfileRelatedPage.length,
                                                                                        (ind) => mainVariables
                                                                                            .valueMapListProfileRelatedPage[ind].dislike),
                                                                                    likeCountList: List.generate(
                                                                                        mainVariables.valueMapListProfileRelatedPage.length,
                                                                                        (ind) => mainVariables
                                                                                            .valueMapListProfileRelatedPage[ind].likesCount),
                                                                                    dislikeCountList: List.generate(
                                                                                        mainVariables.valueMapListProfileRelatedPage.length,
                                                                                        (ind) => mainVariables
                                                                                            .valueMapListProfileRelatedPage[ind].disLikesCount),
                                                                                    type: mainVariables.valueMapListProfileRelatedPage[index].type,
                                                                                    billBoardType: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].type ==
                                                                                            "news"
                                                                                        ? "news"
                                                                                        : mainVariables.valueMapListProfileRelatedPage[index].type ==
                                                                                                "forums"
                                                                                            ? "forums"
                                                                                            : mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].type ==
                                                                                                    "survey"
                                                                                                ? "survey"
                                                                                                : "billboard",
                                                                                    /*mainVariables.valueMapListProfileRelatedPage[index].type=='survey'?'survey':'billboard',*/
                                                                                    image: mainVariables.valueMapListProfileRelatedPage[index].avatar,
                                                                                    title: mainVariables.valueMapListProfileRelatedPage[index].title,
                                                                                    description: "",
                                                                                    fromWhere: 'homePage',
                                                                                    responseId: '',
                                                                                    controller: bottomSheetController,
                                                                                    commentId: '',
                                                                                    postUserId:
                                                                                        mainVariables.valueMapListProfileRelatedPage[index].userId,
                                                                                    responseFocusList: mainVariables.responseFocusRelatedList,
                                                                                    responseUserId: '',
                                                                                    valueMapList: mainVariables.valueMapListProfileRelatedPage,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: width / 41.1,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: height / 64),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      mainVariables.valueMapListProfileRelatedPage[index].companyName,
                                                                                      style: TextStyle(
                                                                                          fontSize: text.scale(10),
                                                                                          color: const Color(0xFF017FDB),
                                                                                          fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                                                            context: context,
                                                                                            billBoardId: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            responseId: "",
                                                                                            commentId: "",
                                                                                            billBoardType: "billboard",
                                                                                            action: "views",
                                                                                            likeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].likesCount
                                                                                                .toString(),
                                                                                            disLikeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].disLikesCount
                                                                                                .toString(),
                                                                                            index: 0,
                                                                                            viewCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].viewsCount
                                                                                                .toString(),
                                                                                            isViewIncluded: true);
                                                                                      },
                                                                                      child: Text(
                                                                                        " ${mainVariables.valueMapListProfileRelatedPage[index].viewsCount} views ",
                                                                                        style: TextStyle(fontSize: text.scale(10)),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                                                            context: context,
                                                                                            billBoardId: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].id,
                                                                                            responseId: "",
                                                                                            commentId: "",
                                                                                            billBoardType: "billboard",
                                                                                            action: "likes",
                                                                                            likeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].likesCount
                                                                                                .toString(),
                                                                                            disLikeCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].disLikesCount
                                                                                                .toString(),
                                                                                            index: 1,
                                                                                            viewCount: mainVariables
                                                                                                .valueMapListProfileRelatedPage[index].viewsCount
                                                                                                .toString(),
                                                                                            isViewIncluded: true);
                                                                                      },
                                                                                      child: Text(
                                                                                        " ${mainVariables.valueMapListProfileRelatedPage[index].likesCount} likes ",
                                                                                        style: TextStyle(fontSize: text.scale(10)),
                                                                                      ),
                                                                                    ),
                                                                                    /*  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfileRelatedPage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfileRelatedPage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfileRelatedPage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfileRelatedPage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfileRelatedPage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10)10,
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        switch (mainVariables
                                                                                            .valueMapListProfileRelatedPage[index].type) {
                                                                                          case "blog":
                                                                                            {
                                                                                              mainVariables.selectedBillboardIdMain.value =
                                                                                                  mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].id;
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                      builder: (BuildContext context) =>
                                                                                                          const BlogDescriptionPage()));
                                                                                              break;
                                                                                            }
                                                                                          case "byte":
                                                                                            {
                                                                                              mainVariables.selectedBillboardIdMain.value =
                                                                                                  mainVariables
                                                                                                      .valueMapListProfileRelatedPage[index].id;
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                      builder: (BuildContext context) =>
                                                                                                          const BytesDescriptionPage()));
                                                                                              break;
                                                                                            }
                                                                                          case "forums":
                                                                                            {
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                      builder: (BuildContext context) =>
                                                                                                          ForumPostDescriptionPage(
                                                                                                              idList: List.generate(
                                                                                                                  mainVariables
                                                                                                                      .valueMapListProfileRelatedPage
                                                                                                                      .length,
                                                                                                                  (ind) => mainVariables
                                                                                                                      .valueMapListProfileRelatedPage[
                                                                                                                          ind]
                                                                                                                      .id),
                                                                                                              comeFrom: "billBoardHome",
                                                                                                              forumId: mainVariables
                                                                                                                  .valueMapListProfileRelatedPage[
                                                                                                                      index]
                                                                                                                  .id)));
                                                                                              break;
                                                                                            }
                                                                                          case "survey":
                                                                                            {
                                                                                              String activeStatus = "";
                                                                                              bool answerStatus = false;
                                                                                              int answeredQuestion = 0;
                                                                                              SharedPreferences prefs =
                                                                                                  await SharedPreferences.getInstance();
                                                                                              String mainUserId = prefs.getString('newUserId') ?? "";
                                                                                              String mainUserToken =
                                                                                                  prefs.getString('newUserToken') ?? "";
                                                                                              var url = Uri.parse(
                                                                                                  baseurl + versionSurvey + surveyStatusCheck);
                                                                                              var response = await http.post(url, headers: {
                                                                                                'Authorization': mainUserToken
                                                                                              }, body: {
                                                                                                'survey_id': mainVariables
                                                                                                    .valueMapListProfileRelatedPage[index].id,
                                                                                              });
                                                                                              var responseData = json.decode(response.body);
                                                                                              if (responseData["status"]) {
                                                                                                activeStatus = responseData["response"]["status"];
                                                                                                if (activeStatus == "active") {
                                                                                                  var url = Uri.parse(
                                                                                                      baseurl + versionSurvey + checkAnswer);
                                                                                                  var response = await http.post(url, headers: {
                                                                                                    'Authorization': mainUserToken
                                                                                                  }, body: {
                                                                                                    'survey_id': mainVariables
                                                                                                        .valueMapListProfileRelatedPage[index].id,
                                                                                                  });
                                                                                                  var responseData = json.decode(response.body);
                                                                                                  if (responseData["status"]) {
                                                                                                    answerStatus =
                                                                                                        responseData["response"][0]["final_question"];
                                                                                                    answeredQuestion = responseData["response"][0]
                                                                                                        ["question_number"];
                                                                                                  } else {
                                                                                                    answerStatus = false;
                                                                                                    answeredQuestion = 0;
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              mainUserId ==
                                                                                                      mainVariables
                                                                                                          .valueMapListProfileRelatedPage[index]
                                                                                                          .userId
                                                                                                  ? Navigator.push(context, MaterialPageRoute(
                                                                                                      builder: (BuildContext context) {
                                                                                                      return AnalyticsPage(
                                                                                                        surveyId: mainVariables
                                                                                                            .valueMapListProfileRelatedPage[index].id,
                                                                                                        activity: false,
                                                                                                        surveyTitle: mainVariables
                                                                                                            .valueMapListProfileRelatedPage[index]
                                                                                                            .title,
                                                                                                        navBool: false,
                                                                                                        fromWhere: 'similar',
                                                                                                      );
                                                                                                    }))
                                                                                                  : activeStatus == 'active'
                                                                                                      ? answerStatus
                                                                                                          ? Navigator.push(context, MaterialPageRoute(
                                                                                                              builder: (BuildContext context) {
                                                                                                              return AnalyticsPage(
                                                                                                                  surveyId: mainVariables
                                                                                                                      .valueMapListProfileRelatedPage[
                                                                                                                          index]
                                                                                                                      .id,
                                                                                                                  activity: false,
                                                                                                                  navBool: false,
                                                                                                                  fromWhere: 'similar',
                                                                                                                  surveyTitle: mainVariables
                                                                                                                      .valueMapListProfileRelatedPage[
                                                                                                                          index]
                                                                                                                      .title);
                                                                                                            }))
                                                                                                          : Navigator.push(context, MaterialPageRoute(
                                                                                                              builder: (BuildContext context) {
                                                                                                              return QuestionnairePage(
                                                                                                                surveyId: mainVariables
                                                                                                                    .valueMapListProfileRelatedPage[
                                                                                                                        index]
                                                                                                                    .id,
                                                                                                                defaultIndex: answeredQuestion,
                                                                                                              );
                                                                                                            }))
                                                                                                      : Navigator.push(context, MaterialPageRoute(
                                                                                                          builder: (BuildContext context) {
                                                                                                          return AnalyticsPage(
                                                                                                            surveyId: mainVariables
                                                                                                                .valueMapListProfileRelatedPage[index]
                                                                                                                .id,
                                                                                                            activity: false,
                                                                                                            surveyTitle: mainVariables
                                                                                                                .valueMapListProfileRelatedPage[index]
                                                                                                                .title,
                                                                                                            navBool: false,
                                                                                                            fromWhere: 'similar',
                                                                                                          );
                                                                                                        }));
                                                                                              break;
                                                                                            }
                                                                                          default:
                                                                                            {
                                                                                              break;
                                                                                            }
                                                                                        }
                                                                                      },
                                                                                      child: Text(
                                                                                        " ${mainVariables.valueMapListProfileRelatedPage[index].responseCount} Responses ",
                                                                                        style: TextStyle(fontSize: text.scale(10)),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: height / 42.6),
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        bool response = await Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return UserBillBoardProfilePage(
                                                                                            userId: userIdMain,
                                                                                          );
                                                                                        }));
                                                                                        if (response) {
                                                                                          getBillBoardData();
                                                                                        }
                                                                                      },
                                                                                      child: CircleAvatar(
                                                                                          radius: 22,
                                                                                          backgroundImage: NetworkImage(avatarMain.value)),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width / 41.1,
                                                                                    ),
                                                                                    billboardWidgetsMain.getResponseRelatedField(
                                                                                      context: context,
                                                                                      modelSetState: setState,
                                                                                      billBoardId:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].id,
                                                                                      postUserId:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].userId,
                                                                                      responseId: "",
                                                                                      index: index,
                                                                                      fromWhere: 'homePage',
                                                                                      callFunction: () {},
                                                                                      contentType:
                                                                                          mainVariables.valueMapListProfileRelatedPage[index].type,
                                                                                      category: mainVariables
                                                                                          .valueMapListProfileRelatedPage[index].category,
                                                                                      responseCountList: List.generate(
                                                                                          mainVariables.valueMapListProfileRelatedPage.length,
                                                                                          (ind) => mainVariables
                                                                                              .valueMapListProfileRelatedPage[ind].responseCount),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                            Obx(() => mainVariables.isUserTaggingRelatedList[index]
                                                                ? Positioned(
                                                                    bottom: height / 13,
                                                                    child: UserTaggingBillBoardHomeContainer(
                                                                      billboardListIndex: index,
                                                                    ))
                                                                : const SizedBox()),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height / 33.83,
                                                        )
                                                      ]));
                                                }),
                                            Container(
                                              height: height / 34.64,
                                              width: width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  borderRadius: const BorderRadius.only(
                                                    bottomLeft: Radius.circular(15),
                                                    bottomRight: Radius.circular(15),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                  height: height / 86.6,
                                  width: width,
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                              ],
                            ),
                          ),
                        ),
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
                  ))
            : Center(
                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
              ),
      ),
    );
  }
}
