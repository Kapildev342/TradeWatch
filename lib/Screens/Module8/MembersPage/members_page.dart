import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class MembersPage extends StatefulWidget {
  final String communityId;

  const MembersPage({super.key, required this.communityId});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  bool loader = false;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    communitiesVariables.subAdminPerson =
        RxList.generate(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.length, (index) => 0);
    communitiesVariables.moderatorPerson =
        RxList.generate(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.length, (index) => 1);
    communitiesVariables.memberPerson =
        RxList.generate(communitiesVariables.communitiesPageInitialData.value.communityData.membersList.length, (index) => 2);
    communitiesVariables.removePerson =
        RxList.generate(communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers.length, (index) => 3);
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
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: loader
            ? AppBar(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                toolbarHeight: height / 11.54,
                shape: const OutlineInputBorder(
                    borderSide: BorderSide.none, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                elevation: 1.0,
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
                                size: 25,
                              )),
                          SizedBox(
                            width: width / 51.375,
                          ),
                          Expanded(
                            child: billboardWidgetsMain.getSearchField(
                                context: context, modelSetState: setState, billBoardFunction: () {}, color: const Color(0XFFDDDDDD)),
                          ),
                          SizedBox(
                            width: width / 57.73,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                            child: Text(
                              "Community members",
                              style: TextStyle(fontSize: text.scale(20), fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: width,
                              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                                  ]),
                              child: ListView(
                                children: [
                                  communitiesVariables.communitiesPageInitialData.value.communityData.adminsList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.adminsList.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          "Group admins",
                                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.adminsList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.adminsList.isEmpty
                                      ? const SizedBox()
                                      : membersWidgets.memberAdminCardList(
                                          context: context,
                                          modelSetState: setState,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.adminsList.isEmpty
                                      ? const SizedBox()
                                      : const Divider(),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          "Sub admins",
                                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.isEmpty
                                      ? const SizedBox()
                                      : membersWidgets.memberSubAdminCardList(
                                          context: context,
                                          modelSetState: setState,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.isEmpty
                                      ? const SizedBox()
                                      : const Divider(),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          "Moderators",
                                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.isEmpty
                                      ? const SizedBox()
                                      : membersWidgets.memberModeratorCardList(
                                          context: context,
                                          modelSetState: setState,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.isEmpty
                                      ? const SizedBox()
                                      : const Divider(),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          "Members",
                                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 57.73,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList.isEmpty
                                      ? const SizedBox()
                                      : membersWidgets.membersCardList(
                                          context: context,
                                          modelSetState: setState,
                                        ),
                                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 17.34,
                                        ),
                                ],
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
                  ))
            : Center(
                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
              ),
      )),
    );
  }
}
