import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';

import 'contact_list_page.dart';
import 'conversation_page.dart';

class ActiveTradersScreen extends StatefulWidget {
  const ActiveTradersScreen({Key? key}) : super(key: key);

  @override
  State<ActiveTradersScreen> createState() => _ActiveTradersScreenState();
}

class _ActiveTradersScreenState extends State<ActiveTradersScreen> {
  bool loader = false;
  bool isCreateGroup = false;
  int skipCount = 0;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void initState() {
    getAllDataMain(name: 'Active_Users_Page');
    getData();
    super.initState();
  }

  getData() async {
    await conversationApiMain.activeUsersList(
      skipCount: skipCount,
    );
    setState(() {
      loader = true;
    });
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
    super.didChangeDependencies();
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
    final RefreshController homeRefreshController = RefreshController();
    return WillPopScope(
      onWillPop: () async {
        if (mainVariables.billBoardSearchControllerMain.value.text.isEmpty) {
          Navigator.pop(context);
        } else {
          mainVariables.billBoardSearchControllerMain.value.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          mainVariables.billBoardSearchControllerMain.refresh();
          setState(() {});
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 1,
          shadowColor: Theme.of(context).colorScheme.tertiary,
          title: SizedBox(
            height: height / 23.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (mainVariables.billBoardSearchControllerMain.value.text.isEmpty) {
                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                      } else {
                        mainVariables.billBoardSearchControllerMain.value.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                        mainVariables.billBoardSearchControllerMain.refresh();
                        setState(() {});
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
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
                    billBoardFunction: () {},
                  ),
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
        ),
        body: Obx(
          () => mainVariables.billBoardSearchControllerMain.value.text.isNotEmpty
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 41.23,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                            child: Text(
                              "Active Traders",
                              style: TextStyle(fontSize: text.scale(20), fontWeight: FontWeight.w900),
                            )),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: height / 54.125),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onBackground,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  )
                                ]),
                            child: loader
                                ? Obx(() => mainVariables.activeUserList.isEmpty
                                    ? Container(
                                        margin: EdgeInsets.symmetric(horizontal: width / 57.73),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: height / 5.77,
                                                width: width / 2.74,
                                                child: SvgPicture.asset("lib/Constants/Assets/SMLogos/add.svg")),
                                            SizedBox(
                                              height: height / 57.73,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: '😟 Looks like there is no conversations in this list, Would you like to a add ',
                                                        style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: text.scale(12))),
                                                    TextSpan(
                                                      text: ' Add here',
                                                      recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          //userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                            return const ContactsList();
                                                          }));
                                                        },
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          color: const Color(0XFF0EA102),
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: text.scale(14)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SmartRefresher(
                                        controller: homeRefreshController,
                                        enablePullDown: false,
                                        enablePullUp: true,
                                        footer: const ClassicFooter(
                                          loadStyle: LoadStyle.ShowWhenLoading,
                                        ),
                                        onLoading: () async {
                                          skipCount = skipCount + 20;
                                          getData();
                                          if (mounted) {
                                            setState(() {});
                                          }
                                          homeRefreshController.loadComplete();
                                        },
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: mainVariables.activeUserList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return InkWell(
                                                onTap: () {
                                                  mainVariables.conversationUserData.value = ConversationUserData(
                                                      userId: mainVariables.activeUserList[index].userId,
                                                      avatar: mainVariables.activeUserList[index].avatar,
                                                      firstName: mainVariables.activeUserList[index].firstName,
                                                      lastName: mainVariables.activeUserList[index].lastName,
                                                      userName: mainVariables.activeUserList[index].username,
                                                      isBelieved: mainVariables.activeUserList[index].believed);
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return const ConversationPage();
                                                  }));
                                                },
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        bottom: index == 14 ? height / 34.64 : height / 86.6,
                                                        left: width / 27.4,
                                                        right: width / 27.4,
                                                        top: height / 173.2,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                        left: width / 27.4,
                                                        right: width / 82.2,
                                                        top: height / 86.6,
                                                        bottom: height / 86.6,
                                                      ),
                                                      height: height / 11.54,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: Theme.of(context).colorScheme.onBackground,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                                                blurRadius: 4.0,
                                                                spreadRadius: 0.0)
                                                          ]),
                                                      child: Row(children: [
                                                        Stack(
                                                          alignment: Alignment.topRight,
                                                          children: [
                                                            Container(
                                                              height: height / 17.32,
                                                              width: width / 8.22,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(mainVariables.activeUserList[index].avatar),
                                                                      fit: BoxFit.fill)),
                                                            ),
                                                            //mainVariables.activeUserList[index].activeStatus?
                                                            Obx(() => mainVariables.isActiveStatusUsersList[index]
                                                                ? Container(
                                                                    height: height / 57.73,
                                                                    width: width / 27.4,
                                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                                    child: Center(
                                                                      child: Container(
                                                                        height: height / 86.6,
                                                                        width: width / 41.1,
                                                                        decoration:
                                                                            const BoxDecoration(shape: BoxShape.circle, color: Color(0XFF0EA102)),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox()),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 108.25),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "${mainVariables.activeUserList[index].firstName} ${mainVariables.activeUserList[index].lastName}",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: text.scale(14),
                                                                      overflow: TextOverflow.ellipsis),
                                                                  maxLines: 1,
                                                                ),
                                                                Obx(() => Text(
                                                                      '${mainVariables.activeUserList[index].message.value.message} ',
                                                                      style: TextStyle(
                                                                          fontWeight: mainVariables.activeUserList[index].message.value.readStatus
                                                                              ? FontWeight.w400
                                                                              : FontWeight.w900,
                                                                          fontSize: text.scale(10),
                                                                          color: mainVariables.activeUserList[index].message.value.readStatus
                                                                              ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                                                                              : Theme.of(context).colorScheme.onPrimary,
                                                                          overflow: TextOverflow.ellipsis),
                                                                      maxLines: 1,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width / 3.1,
                                                          padding: EdgeInsets.only(
                                                            top: height / 108.25,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  conversationWidgetsMain.getActiveChatBelieveButton(
                                                                      heightValue: height / 33.76,
                                                                      index: index,
                                                                      billboardUserid: mainVariables.activeUserList[index].userId,
                                                                      billboardUserName: mainVariables.activeUserList[index].username,
                                                                      context: context,
                                                                      modelSetState: setState),
                                                                  GestureDetector(
                                                                      onTap: () {
                                                                        conversationWidgetsMain.bottomSheet(
                                                                          context: context,
                                                                          modelSetState: setState,
                                                                          fromWhere: 'list',
                                                                          index: index,
                                                                        );
                                                                      },
                                                                      child: Icon(
                                                                        Icons.more_vert,
                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                      ))
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(right: width / 27.4),
                                                                child: Text(
                                                                  mainVariables.activeUserList[index].message.value.createdAt
                                                                  /*DateFormat('kk:mm a')
                                                                  .format(DateTime
                                                                      .now())*/
                                                                  ,
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(10)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    Obx(() => mainVariables.activeUserList[index].unreadMessages.value == 0
                                                        ? const SizedBox()
                                                        : Positioned(
                                                            right: width / 27.4,
                                                            child: Container(
                                                              height: height / 57.73,
                                                              width: width / 27.4,
                                                              decoration: const BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.red,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  mainVariables.activeUserList[index].unreadMessages.value < 10
                                                                      ? "${mainVariables.activeUserList[index].unreadMessages.value}"
                                                                      : "9+",
                                                                  style: TextStyle(
                                                                      fontSize: mainVariables.activeUserList[index].unreadMessages.value < 10
                                                                          ? text.scale(10)
                                                                          : text.scale(8),
                                                                      color: Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                  ],
                                                ),
                                              );
                                            })))
                                : Center(
                                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                                  ),
                          ),
                        ),
                      ],
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
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ContactsList()));
          },
          child: Center(
            child: Image.asset("lib/Constants/Assets/activity/answer.png"),
          ),
        ),*/
      ),
    );
  }
}
