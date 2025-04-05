import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class LockerScreenWidgets {
  Widget getBodyWidget({
    required BuildContext context,
    required bool bannerAdIsLoaded,
    required bool filterEnabled,
    BannerAd? bannerAd,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        SizedBox(height: height / 57.73),
        getLockerSearchField(context: context),
        SizedBox(height: height / 57.73),
        Expanded(
          child: ListView(
            children: [
              Obx(() => lockerVariables.lockerBuzzList.isEmpty &&
                      lockerVariables.lockerEssentialsList.isEmpty &&
                      lockerVariables.lockerCommunityList.isEmpty &&
                      lockerVariables.lockerServicesList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Sorry,We could not find any results...',
                                  style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  : const SizedBox()),
              Obx(() => lockerVariables.lockerBuzzList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.lockerScreenContents.response[0].topic,
                          /*style: TextStyle(
                            fontSize: text.scale(16),
                            fontWeight: FontWeight.w600,
                            color: const Color(0XFF2A2727),
                          ),*/
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.lockerBuzzList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationFunction(context: context, name: lockerVariables.lockerBuzzList[gridIndex].name);
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.lockerBuzzList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.lockerBuzzList[gridIndex].name,
                                      // style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              Obx(() => lockerVariables.lockerEssentialsList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.lockerScreenContents.response[1].topic,
                          //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.lockerEssentialsList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationFunction(
                                            context: context, name: lockerVariables.lockerEssentialsList[gridIndex].name);
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.lockerEssentialsList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.lockerEssentialsList[gridIndex].name,
                                      // style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              filterEnabled
                  ? const SizedBox()
                  : bannerAdIsLoaded && bannerAd != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                          child: SizedBox(
                            width: bannerAd.size.width.toDouble(),
                            height: bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: bannerAd),
                          ),
                        )
                      : const SizedBox(),
              SizedBox(
                height: height / 57.73,
              ),
              Obx(() => lockerVariables.lockerCommunityList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.lockerScreenContents.response[2].topic,
                          // style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.lockerCommunityList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: () {
                                  extraContainMain.value
                                      ? () {
                                          extraContainMain.value = false;
                                        }
                                      : lockerFunctions.navigationFunction(
                                          context: context, name: lockerVariables.lockerCommunityList[gridIndex].name);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.lockerCommunityList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.lockerCommunityList[gridIndex].name,
                                      //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              Obx(() => lockerVariables.lockerServicesList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.lockerScreenContents.response[3].topic,
                          // style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.lockerServicesList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationFunction(
                                            context: context, name: lockerVariables.lockerServicesList[gridIndex].name);
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.lockerServicesList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.lockerServicesList[gridIndex].name,
                                      // style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
            ],
          ),
        ),
      ],
    );
  }

  Widget getBodyChartsWidget({
    required BuildContext context,
    required bool bannerAdIsLoaded,
    required bool filterEnabled,
    BannerAd? bannerAd,
    required String exchangeName,
    required String defaultTvSymbol,
    required String tvSym1,
    required String tvSym2,
    required String defaultFilterId,
    required String defaultFilterId1,
    required String secondaryFilterId,
    required String secondaryFilterId1,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        SizedBox(height: height / 57.73),
        getLockerChartSearchField(context: context),
        SizedBox(height: height / 57.73),
        Expanded(
          child: ListView(
            children: [
              Obx(() => lockerVariables.chartsTrendList.isEmpty &&
                      lockerVariables.chartsVolatilityList.isEmpty &&
                      lockerVariables.chartsBasicList.isEmpty &&
                      lockerVariables.chartsPatternList.isEmpty &&
                      lockerVariables.chartsComparisonList.isEmpty &&
                      lockerVariables.chartsRequestList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Sorry,We could not find any results...',
                                  style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()),
              Obx(() => lockerVariables.chartsTrendList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.chartScreenContents.response[0].topic,
                          // style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.chartsTrendList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationChartsFunction(
                                          context: context,
                                          name: lockerVariables.chartsTrendList[gridIndex].name,
                                          id: lockerVariables.chartsTrendList[gridIndex].id,
                                          tvSym1: tvSym1,
                                          tvSym2: tvSym2,
                                          defaultFilterId1: defaultFilterId1,
                                          defaultFilterId: defaultFilterId,
                                          secondaryFilterId1: secondaryFilterId1,
                                          secondaryFilterId: secondaryFilterId,
                                          exchangeName: exchangeName,
                                          defaultTvSymbol: defaultTvSymbol,
                                        );
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.chartsTrendList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.chartsTrendList[gridIndex].name,
                                      //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              Obx(() => lockerVariables.chartsVolatilityList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.chartScreenContents.response[1].topic,
                          //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.chartsVolatilityList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationChartsFunction(
                                          context: context,
                                          name: lockerVariables.chartsVolatilityList[gridIndex].name,
                                          id: lockerVariables.chartsVolatilityList[gridIndex].id,
                                          tvSym1: tvSym1,
                                          tvSym2: tvSym2,
                                          defaultFilterId1: defaultFilterId1,
                                          defaultFilterId: defaultFilterId,
                                          secondaryFilterId1: secondaryFilterId1,
                                          secondaryFilterId: secondaryFilterId,
                                          exchangeName: exchangeName,
                                          defaultTvSymbol: defaultTvSymbol,
                                        );
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.chartsVolatilityList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.chartsVolatilityList[gridIndex].name,
                                      //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              Obx(() => lockerVariables.chartsBasicList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.chartScreenContents.response[2].topic,
                          //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.chartsBasicList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationChartsFunction(
                                          context: context,
                                          name: lockerVariables.chartsBasicList[gridIndex].name,
                                          id: lockerVariables.chartsBasicList[gridIndex].id,
                                          tvSym1: tvSym1,
                                          tvSym2: tvSym2,
                                          defaultFilterId1: defaultFilterId1,
                                          defaultFilterId: defaultFilterId,
                                          secondaryFilterId1: secondaryFilterId1,
                                          secondaryFilterId: secondaryFilterId,
                                          exchangeName: exchangeName,
                                          defaultTvSymbol: defaultTvSymbol,
                                        );
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.chartsBasicList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.chartsBasicList[gridIndex].name,
                                      //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              filterEnabled
                  ? const SizedBox()
                  : bannerAdIsLoaded && bannerAd != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                          child: SizedBox(
                            width: bannerAd.size.width.toDouble(),
                            height: bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: bannerAd),
                          ),
                        )
                      : const SizedBox(),
              SizedBox(
                height: height / 57.73,
              ),
              Obx(() => lockerVariables.chartsPatternList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.chartScreenContents.response[3].topic,
                          //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.chartsPatternList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationChartsFunction(
                                          context: context,
                                          name: lockerVariables.chartsPatternList[gridIndex].name,
                                          id: lockerVariables.chartsPatternList[gridIndex].id,
                                          tvSym1: tvSym1,
                                          tvSym2: tvSym2,
                                          defaultFilterId1: defaultFilterId1,
                                          defaultFilterId: defaultFilterId,
                                          secondaryFilterId1: secondaryFilterId1,
                                          secondaryFilterId: secondaryFilterId,
                                          exchangeName: exchangeName,
                                          defaultTvSymbol: defaultTvSymbol,
                                        );
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.chartsPatternList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.chartsPatternList[gridIndex].name,
                                      //style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              Obx(() => lockerVariables.chartsComparisonList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.chartScreenContents.response[2].topic,
                          // style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.chartsComparisonList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationChartsFunction(
                                          context: context,
                                          name: lockerVariables.chartsComparisonList[gridIndex].name,
                                          id: lockerVariables.chartsComparisonList[gridIndex].id,
                                          tvSym1: tvSym1,
                                          tvSym2: tvSym2,
                                          defaultFilterId1: defaultFilterId1,
                                          defaultFilterId: defaultFilterId,
                                          secondaryFilterId1: secondaryFilterId1,
                                          secondaryFilterId: secondaryFilterId,
                                          exchangeName: exchangeName,
                                          defaultTvSymbol: defaultTvSymbol,
                                        );
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.chartsComparisonList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.chartsComparisonList[gridIndex].name,
                                      // style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
              Obx(() => lockerVariables.chartsRequestList.isEmpty
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lockerVariables.chartScreenContents.response[3].topic,
                          //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF2A2727)),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: lockerVariables.chartsRequestList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                onTap: extraContainMain.value
                                    ? () {
                                        extraContainMain.value = false;
                                      }
                                    : () {
                                        lockerFunctions.navigationChartsFunction(
                                          context: context,
                                          name: lockerVariables.chartsRequestList[gridIndex].name,
                                          id: lockerVariables.chartsRequestList[gridIndex].id,
                                          tvSym1: tvSym1,
                                          tvSym2: tvSym2,
                                          defaultFilterId1: defaultFilterId1,
                                          defaultFilterId: defaultFilterId,
                                          secondaryFilterId1: secondaryFilterId1,
                                          secondaryFilterId: secondaryFilterId,
                                          exchangeName: exchangeName,
                                          defaultTvSymbol: defaultTvSymbol,
                                        );
                                      },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height / 13.12,
                                      width: width / 6.22,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(lockerVariables.chartsRequestList[gridIndex].imageUrl), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height / 86.6,
                                    ),
                                    Text(
                                      lockerVariables.chartsRequestList[gridIndex].name,
                                      //  style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF2A2727)),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    )),
            ],
          ),
        ),
      ],
    );
  }

  Widget getLockerSearchField({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => TextFormField(
          controller: lockerVariables.searchControllerMain.value,
          onChanged: (value) async {
            lockerVariables.searchControllerMain.refresh();
            lockerFunctions.filterSearchResults(query: value);
          },
          cursorColor: Colors.green,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
          style: Theme.of(context).textTheme.bodyMedium,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.tertiary,
              filled: true,
              suffixIcon: lockerVariables.searchControllerMain.value.text.isEmpty
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        lockerVariables.searchControllerMain.value.clear();
                        lockerVariables.searchControllerMain.refresh();
                        lockerFunctions.filterSearchResults(query: "");
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                    ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
              ),
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
              hintText: 'Search here',
              errorStyle: TextStyle(fontSize: text.scale(10))),
        ));
  }

  Widget getLockerChartSearchField({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => TextFormField(
          controller: lockerVariables.searchChartControllerMain.value,
          onChanged: (value) async {
            lockerVariables.searchChartControllerMain.refresh();
            lockerFunctions.filterChartSearchResults(query: value);
          },
          cursorColor: Colors.green,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          //style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
          style: Theme.of(context).textTheme.bodyMedium,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.tertiary,
              filled: true,
              suffixIcon: lockerVariables.searchChartControllerMain.value.text.isEmpty
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        lockerVariables.searchChartControllerMain.value.clear();
                        lockerVariables.searchChartControllerMain.refresh();
                        lockerFunctions.filterChartSearchResults(query: "");
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                    ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
              ),
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
              hintText: 'Search here',
              errorStyle: TextStyle(fontSize: text.scale(10))),
        ));
  }
}
