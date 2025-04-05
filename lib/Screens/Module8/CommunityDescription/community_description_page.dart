
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:lottie/lottie.dart";
import "package:river_player/river_player.dart";
import "package:share_plus/share_plus.dart";
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import "package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart";
import "package:tradewatchfinal/Screens/Module1/bottom_navigation.dart";
import "package:tradewatchfinal/Screens/Module1/notifications_page.dart";
import "package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart";
import "package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart";
import "package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart";
import "package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart";
import "package:video_player/video_player.dart";

class CommunityDescriptionPage extends StatefulWidget {
  final int index;

  const CommunityDescriptionPage({super.key, required this.index});

  @override
  State<CommunityDescriptionPage> createState() => _CommunityDescriptionPageState();
}

class _CommunityDescriptionPageState extends State<CommunityDescriptionPage> {
  bool loader = false;
  int carouselIndexGlobal = 0;
  List<ChewieController> cvControllerList = [];
  final List<String> _choose = ["Recent", "Most Liked", "Most Disliked", "Most Commented"];
  String selectedValue = "Recent";
  List<String> networkUrls = [];
  List<BetterPlayerController> betterPlayerList = [];
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  List<ChewieController> responseCvControllerList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    responseCvControllerList.clear();
    for (int i = 0; i < communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].files.length; i++) {
      cvControllerList.add(await functionsMain.getVideoPlayer(
        url: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].files[i].file.value,
      ));
    }
    communitiesVariables.communitiesPostResponsesList = null;
    await communitiesFunctions.getCommunityPostResponsesList(
        postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].id.value, skipCount: 0);
    for (int i = 0; i < communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.length; i++) {
      if (communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[i].files.isNotEmpty) {
        responseCvControllerList.add(await functionsMain.getVideoPlayer(
          url: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[i].files[0].file.value,
        ));
      } else {
        responseCvControllerList.add(ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(""))));
      }
    }
    setState(() {
      loader = true;
    });
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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: loader
            ? AppBar(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                toolbarHeight: height / 11.54,
                shape: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                elevation: 2.0,
                shadowColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
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
                                Navigator.pop(context);
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
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                elevation: 0,
              ),
        body: loader
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Obx(
                    () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
                        ? billboardWidgetsMain.getSearchPage(context: context, modelSetState: setState)
                        : Column(
                            children: [
                              SizedBox(
                                height: height / 57.73,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                        blurRadius: 4.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: ListView(
                                    children: [
                                      Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height / 57.73,
                                                width: width,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                        blurRadius: 4.0,
                                                        spreadRadius: 0.0),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
                                                        ? SizedBox(
                                                            height: height / 57.73,
                                                          )
                                                        : const SizedBox(),
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
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
                                                                avatar: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                    .postContents[widget.index].avatar.value,
                                                                userId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                    .postContents[widget.index].userId.value,
                                                                isProfile: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                    .postContents[widget.index].profileType.value,
                                                                repostAvatar: "",
                                                                repostUserId: "",
                                                                isRepostProfile: "",
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
                                                                          return UserBillBoardProfilePage(
                                                                              userId: communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[widget.index].userId.value);
                                                                        }));
                                                                      },
                                                                      child: Text(
                                                                        communitiesVariables.communitiesPageInitialData.value.communityData
                                                                            .postContents[widget.index].username.value,
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(14),
                                                                            fontWeight: FontWeight.w700,
                                                                            fontFamily: "Poppins"),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 173.2,
                                                                    ),
                                                                    Text(
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].postDate.value,
                                                                      style: TextStyle(
                                                                          fontSize: text.scale(10),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 173.2,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        billboardWidgetsMain.believersTabBottomSheet(
                                                                          context: context,
                                                                          id: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].userId.value,
                                                                          isBelieversList: true,
                                                                        );
                                                                      },
                                                                      child: Obx(
                                                                        () => Text(
                                                                          "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].believersCount.value} Believers",
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
                                                              ),
                                                              Row(
                                                                children: [
                                                                  userIdMain !=
                                                                          communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].userId.value
                                                                      ? billboardWidgetsMain.getBelieveButton(
                                                                          heightValue: height / 33.76,
                                                                          isBelieved: [
                                                                            communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                .postContents[widget.index].believed.value
                                                                          ].obs,
                                                                          billboardUserid: communitiesVariables.communitiesPageInitialData.value
                                                                              .communityData.postContents[widget.index].userId.value,
                                                                          billboardUserName: communitiesVariables.communitiesPageInitialData.value
                                                                              .communityData.postContents[widget.index].username.value,
                                                                          context: context,
                                                                          modelSetState: setState,
                                                                          index: 0,
                                                                          background: true,
                                                                          believersCount: RxList.generate(
                                                                              1,
                                                                              (index) => communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[widget.index].believersCount.value),
                                                                          isSearchData: false,
                                                                        )
                                                                      : const SizedBox(),
                                                                  IconButton(
                                                                      onPressed: () {},
                                                                      icon: const Icon(
                                                                        Icons.more_horiz,
                                                                        size: 25,
                                                                      )),
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
                                                        ? SizedBox(height: height / 64)
                                                        : const SizedBox(),
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
                                                        ? const SizedBox()
                                                        : const SizedBox(
                                                            height: 0,
                                                          ),
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
                                                        ? const SizedBox()
                                                        : Stack(
                                                            alignment: Alignment.topRight,
                                                            children: [
                                                              SizedBox(
                                                                height: height / 3.85,
                                                                width: width,
                                                                child: Center(
                                                                  child: PageView.builder(
                                                                      scrollDirection: Axis.horizontal,
                                                                      physics: const ScrollPhysics(),
                                                                      itemCount: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].files.length,
                                                                      onPageChanged: (index) async {
                                                                        setState(() {
                                                                          carouselIndexGlobal = index;
                                                                        });
                                                                      },
                                                                      itemBuilder: (BuildContext context, int index) {
                                                                        return GestureDetector(
                                                                          onTap: () {
                                                                            if (communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                    .postContents[widget.index].files[index].fileType.value ==
                                                                                "image") {
                                                                              Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                return FullScreenImage(
                                                                                    imageUrl: communitiesVariables
                                                                                        .communitiesPageInitialData
                                                                                        .value
                                                                                        .communityData
                                                                                        .postContents[widget.index]
                                                                                        .files[index]
                                                                                        .file
                                                                                        .value,
                                                                                    tag: "generate_a_unique_tag");
                                                                              }));
                                                                            } else if (communitiesVariables
                                                                                    .communitiesPageInitialData
                                                                                    .value
                                                                                    .communityData
                                                                                    .postContents[widget.index]
                                                                                    .files[index]
                                                                                    .fileType
                                                                                    .value ==
                                                                                "video") {
                                                                            } else if (communitiesVariables
                                                                                    .communitiesPageInitialData
                                                                                    .value
                                                                                    .communityData
                                                                                    .postContents[widget.index]
                                                                                    .files[index]
                                                                                    .fileType
                                                                                    .value ==
                                                                                "document") {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute<dynamic>(
                                                                                  builder: (_) => PDFViewerFromUrl(
                                                                                    url: communitiesVariables
                                                                                        .communitiesPageInitialData
                                                                                        .value
                                                                                        .communityData
                                                                                        .postContents[widget.index]
                                                                                        .files[index]
                                                                                        .file
                                                                                        .value,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            margin: EdgeInsets.symmetric(horizontal: width / 68.5, vertical: 5),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.black,
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                /*border: Border.all(color: Colors.grey.shade500)*/
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                      blurRadius: 4.0,
                                                                                      spreadRadius: 0.0,
                                                                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5))
                                                                                ]),
                                                                            clipBehavior: Clip.hardEdge,
                                                                            child: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                        .postContents[widget.index].files[index].fileType.value ==
                                                                                    "image"
                                                                                ? Image.network(
                                                                                    communitiesVariables
                                                                                        .communitiesPageInitialData
                                                                                        .value
                                                                                        .communityData
                                                                                        .postContents[widget.index]
                                                                                        .files[index]
                                                                                        .file
                                                                                        .value,
                                                                                    fit: BoxFit.contain,
                                                                                  )
                                                                                : communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                            .postContents[widget.index].files[index].fileType.value ==
                                                                                        "video"
                                                                                    ? billboardWidgetsMain.getVideoPlayer(
                                                                                        cvController: cvControllerList[index],
                                                                                        heightValue: height / 3.85,
                                                                                        widthValue: width,
                                                                                      )
                                                                                    : communitiesVariables
                                                                                                .communitiesPageInitialData
                                                                                                .value
                                                                                                .communityData
                                                                                                .postContents[widget.index]
                                                                                                .files[index]
                                                                                                .fileType
                                                                                                .value ==
                                                                                            "document"
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
                                                                    userIdMain !=
                                                                            communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                .postContents[widget.index].userId.value
                                                                        ? billboardWidgetsMain.getBelieveButton(
                                                                            heightValue: height / 33.76,
                                                                            isBelieved: [
                                                                              communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                  .postContents[widget.index].believed.value
                                                                            ].obs,
                                                                            billboardUserid: communitiesVariables.communitiesPageInitialData.value
                                                                                .communityData.postContents[widget.index].userId.value,
                                                                            billboardUserName: communitiesVariables.communitiesPageInitialData.value
                                                                                .communityData.postContents[widget.index].username.value,
                                                                            context: context,
                                                                            modelSetState: setState,
                                                                            index: 0,
                                                                            background: true,
                                                                            believersCount: RxList.generate(
                                                                                1,
                                                                                (index) => communitiesVariables.communitiesPageInitialData.value
                                                                                    .communityData.postContents[widget.index].believersCount.value),
                                                                            isSearchData: false,
                                                                          )
                                                                        : const SizedBox(),
                                                                    SizedBox(
                                                                      width: width / 27.4,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {},
                                                                        child: const Icon(
                                                                          Icons.more_vert,
                                                                          color: Colors.white,
                                                                          size: 25,
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                              communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].files.length >
                                                                      1
                                                                  ? Positioned(
                                                                      bottom: height / 57.73,
                                                                      left: (width / 2) - 50,
                                                                      child: SizedBox(
                                                                        height: height / 173.2,
                                                                        child: ListView.builder(
                                                                            shrinkWrap: true,
                                                                            scrollDirection: Axis.horizontal,
                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                            itemCount: communitiesVariables.communitiesPageInitialData.value
                                                                                .communityData.postContents[widget.index].files.length,
                                                                            itemBuilder: (BuildContext context, int index1) {
                                                                              return Container(
                                                                                height: height / 173.2,
                                                                                width: carouselIndexGlobal == index1 ? width / 20.55 : width / 82.2,
                                                                                margin: EdgeInsets.symmetric(horizontal: width / 137),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8), color: Colors.white),
                                                                              );
                                                                            }),
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
                                                        ? const SizedBox()
                                                        : SizedBox(
                                                            height: height / 57.73,
                                                          ),
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
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
                                                                isProfile: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                    .postContents[widget.index].profileType.value,
                                                                avatar: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                    .postContents[widget.index].avatar.value,
                                                                userId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                    .postContents[widget.index].userId.value,
                                                                repostAvatar: "",
                                                                repostUserId: "",
                                                                isRepostProfile: "",
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
                                                                          return UserBillBoardProfilePage(
                                                                              userId: communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[widget.index].userId.value);
                                                                        }));
                                                                      },
                                                                      child: Text(
                                                                        communitiesVariables.communitiesPageInitialData.value.communityData
                                                                            .postContents[widget.index].username.value,
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
                                                                          communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].postDate.value,
                                                                          style: TextStyle(
                                                                              fontSize: text.scale(10),
                                                                              color: const Color(0XFF737373),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins"),
                                                                        ),
                                                                        SizedBox(
                                                                          width: width / 137,
                                                                        ),
                                                                        Text(
                                                                          " | ",
                                                                          style: TextStyle(
                                                                            fontSize: text.scale(10),
                                                                            color: const Color(0XFF737373),
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: width / 137,
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () async {
                                                                            billboardWidgetsMain.believersTabBottomSheet(
                                                                              context: context,
                                                                              id: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                                  .postContents[widget.index].userId.value,
                                                                              isBelieversList: true,
                                                                            );
                                                                          },
                                                                          child: Obx(() => Text(
                                                                                "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].believersCount.value} Believers",
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
                                                    communitiesVariables
                                                            .communitiesPageInitialData.value.communityData.postContents[widget.index].files.isEmpty
                                                        ? const SizedBox()
                                                        : SizedBox(height: height / 64),
                                                    Container(
                                                        width: width,
                                                        padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                        child: RichText(
                                                          textAlign: TextAlign.left,
                                                          text: TextSpan(
                                                            children: conversationFunctionsMain.spanList(
                                                                message: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                            .postContents[widget.index].title.value.length >
                                                                        200
                                                                    ? communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].title.value
                                                                        .substring(0, 200)
                                                                    : communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].title.value,
                                                                context: context),
                                                          ),
                                                        )),
                                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index]
                                                                .title.value.length >
                                                            200
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
                                                                                                padding:
                                                                                                    EdgeInsets.symmetric(horizontal: width / 27.4),
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
                                                                                                  padding:
                                                                                                      EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                                  width: width,
                                                                                                  child: RichText(
                                                                                                    textAlign: TextAlign.left,
                                                                                                    text: TextSpan(
                                                                                                        children: conversationFunctionsMain.spanList(
                                                                                                            message: communitiesVariables
                                                                                                                .communitiesPageInitialData
                                                                                                                .value
                                                                                                                .communityData
                                                                                                                .postContents[widget.index]
                                                                                                                .title
                                                                                                                .value,
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
                                                    SizedBox(
                                                      height: height / 57.73,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  bool response = await communitiesFunctions.communityLikeFunction(
                                                                    postId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].id.value,
                                                                    communityId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].communityId.value,
                                                                    type: 'likes',
                                                                  );
                                                                  if (response) {
                                                                    communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].isLiked
                                                                        .toggle();
                                                                    if (communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].isDisliked.value) {
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].isDisliked
                                                                          .toggle();
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].dislikesCount.value--;
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].likesCount.value++;
                                                                    } else {
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].isLiked.value
                                                                          ? communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].likesCount.value++
                                                                          : communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].likesCount.value--;
                                                                    }
                                                                  } else {
                                                                    if (context.mounted) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                          content: Text("Something went wrong, please try again later")));
                                                                    }
                                                                  }
                                                                },
                                                                child: Obx(() => communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].isLiked.value
                                                                    ? SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                        height: height / 43.3,
                                                                        width: width / 20.55)
                                                                    : SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                        height: height / 34.64,
                                                                        width: width / 16.44,
                                                                      )),
                                                              ),
                                                              Obx(() => Text(
                                                                    "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].likesCount.value}",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(8),
                                                                        color: const Color(0XFFA7A7A7),
                                                                        fontWeight: FontWeight.w600),
                                                                  )),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                  onTap: () async {
                                                                    logEventFunc(name: "Share", type: "Forum");
                                                                    Uri newLink = await communitiesFunctions.getCommunityLinK(
                                                                      id: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].id.value,
                                                                      type: "CommunityDescriptionPage",
                                                                      title: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].title.value,
                                                                      imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].files.isEmpty
                                                                          ? ""
                                                                          : communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].files[0].file.value,
                                                                      description: "",
                                                                    );
                                                                    ShareResult result = await Share.share(
                                                                      "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].title.value} ${newLink.toString()}",
                                                                    );
                                                                    if (result.status == ShareResultStatus.success) {
                                                                      await communitiesFunctions.shareFunction(
                                                                          id: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].id.value);
                                                                    }
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/share_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                  )),
                                                              Text(
                                                                "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].shareCount.value}",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(8),
                                                                    color: const Color(0XFFA7A7A7),
                                                                    fontWeight: FontWeight.w600),
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  bool response = await communitiesFunctions.communityLikeFunction(
                                                                    postId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].id.value,
                                                                    communityId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].communityId.value,
                                                                    type: 'dislikes',
                                                                  );
                                                                  if (response) {
                                                                    communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].isDisliked
                                                                        .toggle();
                                                                    if (communitiesVariables.communitiesPageInitialData.value.communityData
                                                                        .postContents[widget.index].isLiked.value) {
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].isLiked
                                                                          .toggle();
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].likesCount.value--;
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].dislikesCount.value++;
                                                                    } else {
                                                                      communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].isDisliked.value
                                                                          ? communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].dislikesCount.value++
                                                                          : communitiesVariables.communitiesPageInitialData.value.communityData
                                                                              .postContents[widget.index].dislikesCount.value--;
                                                                    }
                                                                  } else {
                                                                    if (context.mounted) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                          content: Text("Something went wrong, please try again later")));
                                                                    }
                                                                  }
                                                                },
                                                                child: Obx(
                                                                  () => communitiesVariables.communitiesPageInitialData.value.communityData
                                                                          .postContents[widget.index].isDisliked.value
                                                                      ? SvgPicture.asset(
                                                                          isDarkTheme.value
                                                                              ? "assets/home_screen/dislike_filled_dark.svg"
                                                                              : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                          height: height / 43.3,
                                                                          width: width / 20.55)
                                                                      : SvgPicture.asset(
                                                                          isDarkTheme.value
                                                                              ? "assets/home_screen/dislike_dark.svg"
                                                                              : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                          height: height / 34.64,
                                                                          width: width / 16.44,
                                                                        ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].dislikesCount.value}",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(8),
                                                                        color: const Color(0XFFA7A7A7),
                                                                        fontWeight: FontWeight.w600),
                                                                  )),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  /* communitiesWidgets.commentsBottomSheet(
                                                                                                      context: context,
                                                                                                    );*/
                                                                  communitiesVariables.communitiesPageInitialData.value.communityData
                                                                      .postContents[widget.index].responseFocus.value
                                                                      .requestFocus();
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                  colorFilter: ColorFilter.mode(
                                                                      isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102),
                                                                      BlendMode.srcIn),
                                                                  height: height / 34.64,
                                                                  width: width / 16.44,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[widget.index].responseCount.value}",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(8),
                                                                    color: const Color(0XFFA7A7A7),
                                                                    fontWeight: FontWeight.w600),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 57.73,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left: width / 41.1, right: width / 41.1, top: height / 86.6),
                                                      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.onBackground,
                                                        borderRadius: BorderRadius.circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                                              blurRadius: 4.0,
                                                              spreadRadius: 0.0),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return UserBillBoardProfilePage(userId: userIdMain);
                                                              }));
                                                            },
                                                            child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                          ),
                                                          SizedBox(
                                                            width: width / 51.375,
                                                          ),
                                                          communitiesWidgets.getDescriptionResponseField(
                                                            context: context,
                                                            modelSetState: setState,
                                                            index: widget.index,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Obx(() => mainVariables.isUserTagged.value
                                              ? Positioned(
                                                  bottom: height / 5.5,
                                                  child: const UserTaggingBillBoardSingleContainer(
                                                    billboardListIndex: 0,
                                                  ))
                                              : const SizedBox()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Response order",
                                            style: TextStyle(fontSize: text.scale(13), color: const Color(0XFFB0B0B0)),
                                          ),
                                          SizedBox(
                                            width: width / 53.57,
                                          ),
                                          Icon(Icons.access_time,
                                              size: height / 37.5, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
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
                                                  await communitiesFunctions.getCommunityPostResponsesList(
                                                      postId: communitiesVariables
                                                          .communitiesPageInitialData.value.communityData.postContents[widget.index].id.value,
                                                      skipCount: 0);
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
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                                    elevation: 8,
                                                    offset: const Offset(-20, 0)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () => communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.isEmpty
                                            ? Center(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        height: height / 4.81,
                                                        width: width,
                                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.onBackground,
                                                          borderRadius: BorderRadius.circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                                                blurRadius: 4.0,
                                                                spreadRadius: 0.0),
                                                          ],
                                                        ),
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
                                                                          fontFamily: "Poppins",
                                                                          color: const Color(0XFF0EA102),
                                                                          fontSize: text.scale(12))),
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
                                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ListTile(
                                                          onTap: () async {
                                                            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return UserBillBoardProfilePage(
                                                                  userId: communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                      .responsesList[index].userId.value);
                                                            }));
                                                          },
                                                          contentPadding: EdgeInsets.zero,
                                                          leading: CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage: NetworkImage(communitiesVariables
                                                                .communitiesDescriptionPageResponseList.value.responsesList[index].avatar.value),
                                                          ),
                                                          title: Text(
                                                            communitiesVariables
                                                                .communitiesDescriptionPageResponseList.value.responsesList[index].firstName.value,
                                                            style: TextStyle(
                                                              fontSize: text.scale(14),
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          subtitle: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                  communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                      .responsesList[index].username.value,
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      fontWeight: FontWeight.w500,
                                                                      color: const Color(0XFF808080))),
                                                              Text(" | ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      fontWeight: FontWeight.w500,
                                                                      color: const Color(0XFF808080))),
                                                              InkWell(
                                                                onTap: () {
                                                                  billboardWidgetsMain.believersTabBottomSheet(
                                                                    context: context,
                                                                    id: communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                        .responsesList[index].userId.value,
                                                                    isBelieversList: true,
                                                                  );
                                                                },
                                                                child: Text(
                                                                    "${communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believersCount.value} Believers",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0XFF808080))),
                                                              ),
                                                            ],
                                                          ),
                                                          trailing: SizedBox(
                                                            width: width / 3.5,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                userIdMain ==
                                                                        communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].userId.value
                                                                    ? const SizedBox()
                                                                    : membersWidgets.getResponseBelieveButton(
                                                                        heightValue: height / 34.64,
                                                                        index: index,
                                                                        context: context,
                                                                      ),
                                                                userIdMain !=
                                                                        communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].userId.value
                                                                    ? const SizedBox()
                                                                    : SizedBox(
                                                                        width: width / 41.1,
                                                                      ),
                                                                userIdMain !=
                                                                        communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].userId.value
                                                                    ? const SizedBox()
                                                                    : InkWell(
                                                                        onTap: () {
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].responseController.value.text =
                                                                              communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].message.value;
                                                                          if (userIdMain ==
                                                                              communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].userId.value) {
                                                                            communitiesPageWidgets.editOrDeleteBottomSheet(
                                                                              context: context,
                                                                              communityId: communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[widget.index].communityId.value,
                                                                              list: '',
                                                                              index: index,
                                                                              type: "response",
                                                                              postId: communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[widget.index].id.value,
                                                                              responseId: communitiesVariables.communitiesDescriptionPageResponseList
                                                                                  .value.responsesList[index].id.value,
                                                                            );
                                                                          } else {
                                                                            communitiesPageWidgets.blockOrReportBottomSheet(
                                                                              context: context,
                                                                              modelSetState: setState,
                                                                              communityId: communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[widget.index].communityId.value,
                                                                              userId: communitiesVariables.communitiesDescriptionPageResponseList
                                                                                  .value.responsesList[index].userId.value,
                                                                              list: '',
                                                                              index: index,
                                                                              type: "response",
                                                                              postId: communitiesVariables.communitiesPageInitialData.value
                                                                                  .communityData.postContents[index].id.value,
                                                                              responseId: communitiesVariables.communitiesDescriptionPageResponseList
                                                                                  .value.responsesList[index].id.value,
                                                                            );
                                                                          }
                                                                        },
                                                                        child: const Icon(Icons.more_vert)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Obx(
                                                          () => communitiesVariables
                                                                  .communitiesDescriptionPageResponseList.value.responsesList[index].isEditing.value
                                                              ? Padding(
                                                                  padding: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      communitiesWidgets.getResponseEditingField(
                                                                        context: context,
                                                                        modelSetState: setState,
                                                                        index: index,
                                                                      ),
                                                                      InkWell(
                                                                          onTap: () {
                                                                            communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                .responsesList[index].isEditing.value = false;
                                                                          },
                                                                          child: const Icon(
                                                                            Icons.highlight_off_sharp,
                                                                            color: Colors.red,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                          .responsesList[index].message.value),
                                                                      communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].files.isEmpty
                                                                          ? const SizedBox()
                                                                          : SizedBox(
                                                                              height: height / 86.6,
                                                                            ),
                                                                      communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].files.isEmpty
                                                                          ? const SizedBox()
                                                                          : SizedBox(
                                                                              height: height / 3.464,
                                                                              child: ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  padding: EdgeInsets.zero,
                                                                                  physics: const BouncingScrollPhysics(),
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemCount: communitiesVariables
                                                                                      .communitiesDescriptionPageResponseList
                                                                                      .value
                                                                                      .responsesList[index]
                                                                                      .files
                                                                                      .length,
                                                                                  itemBuilder: (BuildContext context, int idx) {
                                                                                    return Container(
                                                                                      width: communitiesVariables
                                                                                                  .communitiesDescriptionPageResponseList
                                                                                                  .value
                                                                                                  .responsesList[index]
                                                                                                  .files
                                                                                                  .length ==
                                                                                              1
                                                                                          ? width / 1.2
                                                                                          : width / 1.644,
                                                                                      margin: EdgeInsets.symmetric(
                                                                                          vertical: height / 108.25,
                                                                                          horizontal: index == 0 ? width / 205.5 : width / 51.375),
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(12),
                                                                                          color: Colors.white,
                                                                                          boxShadow: [
                                                                                            BoxShadow(
                                                                                              blurRadius: 1,
                                                                                              spreadRadius: 1,
                                                                                              color: Colors.grey.shade300,
                                                                                            )
                                                                                          ]),
                                                                                      clipBehavior: Clip.hardEdge,
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(12),
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        child: communitiesVariables
                                                                                                    .communitiesDescriptionPageResponseList
                                                                                                    .value
                                                                                                    .responsesList[index]
                                                                                                    .files[idx]
                                                                                                    .fileType
                                                                                                    .value ==
                                                                                                "image"
                                                                                            ? Image.network(
                                                                                                communitiesVariables
                                                                                                    .communitiesDescriptionPageResponseList
                                                                                                    .value
                                                                                                    .responsesList[index]
                                                                                                    .files[idx]
                                                                                                    .file
                                                                                                    .value,
                                                                                                fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                                                                return Image.asset(
                                                                                                    "lib/Constants/Assets/Settings/coverImage_default.png");
                                                                                              })
                                                                                            : communitiesVariables
                                                                                                        .communitiesDescriptionPageResponseList
                                                                                                        .value
                                                                                                        .responsesList[index]
                                                                                                        .files[idx]
                                                                                                        .fileType
                                                                                                        .value ==
                                                                                                    "video"
                                                                                                ? Stack(
                                                                                                    alignment: Alignment.center,
                                                                                                    children: [
                                                                                                      Image.asset(
                                                                                                        "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                                                        fit: BoxFit.fill,
                                                                                                        height: height / 3.464,
                                                                                                      ),
                                                                                                      Container(
                                                                                                          height: height / 17.32,
                                                                                                          width: width / 8.22,
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
                                                                                                : communitiesVariables
                                                                                                            .communitiesDescriptionPageResponseList
                                                                                                            .value
                                                                                                            .responsesList[index]
                                                                                                            .files[idx]
                                                                                                            .fileType
                                                                                                            .value ==
                                                                                                        "document"
                                                                                                    ? Stack(
                                                                                                        alignment: Alignment.center,
                                                                                                        children: [
                                                                                                          Image.asset(
                                                                                                            "lib/Constants/Assets/Settings/coverImage.png",
                                                                                                            fit: BoxFit.fill,
                                                                                                            height: height / 3.464,
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
                                                                      communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].files.isEmpty
                                                                          ? const SizedBox()
                                                                          : SizedBox(
                                                                              height: height / 86.6,
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                        ),
                                                        SizedBox(height: height / 57.73),
                                                        Container(
                                                          width: width / 2.74,
                                                          padding: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      bool response = await communitiesFunctions.communityResponseLikeFunction(
                                                                        postId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                            .postContents[widget.index].id.value,
                                                                        responseId: communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].id.value,
                                                                        communityId: communitiesVariables.communitiesPageInitialData.value
                                                                            .communityData.postContents[widget.index].communityId.value,
                                                                        type: 'likes',
                                                                      );
                                                                      if (response) {
                                                                        communitiesVariables
                                                                            .communitiesDescriptionPageResponseList.value.responsesList[index].likes
                                                                            .toggle();
                                                                        if (communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].dislikes.value) {
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].dislikes
                                                                              .toggle();
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].dislikesCount.value--;
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].likesCount.value++;
                                                                        } else {
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].likes.value
                                                                              ? communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].likesCount.value++
                                                                              : communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].likesCount.value--;
                                                                        }
                                                                      } else {
                                                                        if (context.mounted) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                              content: Text("Something went wrong, please try again later")));
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Obx(() => communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].likes.value
                                                                        ? SvgPicture.asset(
                                                                            isDarkTheme.value
                                                                                ? "assets/home_screen/like_filled_dark.svg"
                                                                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                            height: height / 43.3,
                                                                            width: width / 20.55)
                                                                        : SvgPicture.asset(
                                                                            isDarkTheme.value
                                                                                ? "assets/home_screen/like_dark.svg"
                                                                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                            height: height / 43.3,
                                                                            width: width / 20.55,
                                                                          )),
                                                                  ),
                                                                  Obx(() => Text(
                                                                        "${communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].likesCount.value}",
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(8),
                                                                            color: const Color(0XFFA7A7A7),
                                                                            fontWeight: FontWeight.w600),
                                                                      )),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      bool response = await communitiesFunctions.communityResponseLikeFunction(
                                                                        postId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                            .postContents[widget.index].id.value,
                                                                        communityId: communitiesVariables.communitiesPageInitialData.value
                                                                            .communityData.postContents[widget.index].communityId.value,
                                                                        type: 'dislikes',
                                                                        responseId: communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].id.value,
                                                                      );
                                                                      if (response) {
                                                                        communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].dislikes
                                                                            .toggle();
                                                                        if (communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].likes.value) {
                                                                          communitiesVariables
                                                                              .communitiesDescriptionPageResponseList.value.responsesList[index].likes
                                                                              .toggle();
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].likesCount.value--;
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].dislikesCount.value++;
                                                                        } else {
                                                                          communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].dislikes.value
                                                                              ? communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].dislikesCount.value++
                                                                              : communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                                  .responsesList[index].dislikesCount.value--;
                                                                        }
                                                                      } else {
                                                                        if (context.mounted) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                              content: Text("Something went wrong, please try again later")));
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Obx(
                                                                      () => communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                              .responsesList[index].dislikes.value
                                                                          ? SvgPicture.asset(
                                                                              isDarkTheme.value
                                                                                  ? "assets/home_screen/dislike_filled_dark.svg"
                                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                              height: height / 43.3,
                                                                              width: width / 20.55)
                                                                          : SvgPicture.asset(
                                                                              isDarkTheme.value
                                                                                  ? "assets/home_screen/dislike_dark.svg"
                                                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                              height: height / 43.3,
                                                                              width: width / 20.55,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                  Obx(() => Text(
                                                                        "${communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].dislikesCount.value}",
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(8),
                                                                            color: const Color(0XFFA7A7A7),
                                                                            fontWeight: FontWeight.w600),
                                                                      )),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      communitiesWidgets.commentsBottomSheet(
                                                                        context: context,
                                                                        responseId: communitiesVariables.communitiesDescriptionPageResponseList.value
                                                                            .responsesList[index].id.value,
                                                                        postId: communitiesVariables.communitiesPageInitialData.value.communityData
                                                                            .postContents[widget.index].id.value,
                                                                        communityId: communitiesVariables.communitiesPageInitialData.value
                                                                            .communityData.postContents[widget.index].communityId.value,
                                                                      );
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                      colorFilter: ColorFilter.mode(
                                                                          isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102),
                                                                          BlendMode.srcIn),
                                                                      height: height / 43.3,
                                                                      width: width / 20.55,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].responseCount.value}",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(8),
                                                                        color: const Color(0XFFA7A7A7),
                                                                        fontWeight: FontWeight.w600),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        index ==
                                                                communitiesVariables
                                                                        .communitiesDescriptionPageResponseList.value.responsesList.length -
                                                                    1
                                                            ? const SizedBox()
                                                            : const Divider(
                                                                thickness: 1.5,
                                                              ),
                                                        SizedBox(
                                                          height: height / 86.6,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        height: height / 16,
                                        width: width,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
              )
            : Center(
                child: Lottie.asset(
                  'lib/Constants/Assets/SMLogos/loading.json',
                  height: height / 8.66,
                  width: width / 4.11,
                ),
              ),
      ),
    );
  }
}
