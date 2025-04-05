import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunityListPage/communities_list_page.dart';

import 'contact_list_page.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> with TickerProviderStateMixin {
  bool loader = false;
  bool isCreateGroup = false;
  int skipCount = 0;
  TabController? _tabController;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  bool searchEnabled = false;

  @override
  void initState() {
    getAllDataMain(name: 'Contacts_Users_List_Page');
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  getCallDataFunction() async {
    await conversationApiMain.conversationUsersList(
        type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: skipCount, fromWhere: 'conversation');
  }

  @override
  void didChangeDependencies() {
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
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    mainVariables.billBoardListSearchControllerMain.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
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
          toolbarHeight: height / 11.54,
          shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 1.0,
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
                  ),
                ),
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
          shadowColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
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
                            isCreateGroup ? "Create group" : "Messenger",
                            style: TextStyle(fontSize: text.scale(20), fontWeight: FontWeight.w900),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                child: PreferredSize(
                                    preferredSize: Size.fromWidth(width / 29.2),
                                    child: SizedBox(
                                      height: height / 20.55,
                                      child: TabBar(
                                          isScrollable: true,
                                          controller: _tabController,
                                          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
                                          labelColor: const Color(0XFF11AA04),
                                          indicatorColor: Colors.transparent,
                                          indicatorWeight: 0.1,
                                          tabAlignment: TabAlignment.start,
                                          labelPadding: EdgeInsets.only(right: width / 51.375),
                                          dividerColor: Colors.transparent,
                                          splashFactory: NoSplash.splashFactory,
                                          dividerHeight: 0.0,
                                          onTap: (value) {
                                            mainVariables.billBoardListSearchControllerMain.value.clear();
                                            getCallDataFunction();
                                          },
                                          tabs: [
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Believers',
                                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: width / 51.375,
                                                  ),
                                                  VerticalDivider(
                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                    thickness: 0.8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'General',
                                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: width / 51.375,
                                                  ),
                                                  VerticalDivider(
                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                    thickness: 0.8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'Communities',
                                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                            ),
                                          ]),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (searchEnabled) {
                                    if (mainVariables.billBoardListSearchControllerMain.value.text.isNotEmpty) {
                                      // getBillBoardListData();
                                      getCallDataFunction();
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
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg",
                                              height: 12,
                                              width: 12,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Search",
                                              style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        searchEnabled
                            ? SizedBox(
                                height: height / 86.6,
                              )
                            : const SizedBox(),
                        searchEnabled
                            ? billboardWidgetsMain.getBillBoardSearchField(
                                context: context,
                                modelSetState: setState,
                                billBoardFunction: getCallDataFunction,
                              )
                            : SizedBox(
                                height: height / 41.3,
                              ),
                        searchEnabled
                            ? SizedBox(
                                height: height / 86.6,
                              )
                            : const SizedBox(),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onBackground,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: TabBarView(
                                controller: _tabController,
                                physics: const ScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                children: const [
                                  BelieversTabConversationList(),
                                  GeneralTabConversationList(),
                                  CommunitiesPage(),
                                ],
                              )),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_tabController!.index == 2) {
              communitiesPageWidgets.communityCreationBottomSheet(
                context: context,
                isEditing: false,
                communityId: "",
              );
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ContactsList()));
            }
          },
          child: Center(
              child: Image.asset(
            "lib/Constants/Assets/activity/add_group.png",
            scale: 4,
          )),
        ),
      ),
    );
  }
}
