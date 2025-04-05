import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';

class HomeScreenWidgets {
  Widget getSearchPage(
      {required BuildContext context,
      required StateSetter modelSetState,
      required Function initState,
      BannerAd? bannerAd,
      required TabController tabController}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    ScrollController scrollControl = ScrollController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Theme.of(context).colorScheme.background /* Colors.white*/,
      child: Column(
        children: [
          Obx(() => homeVariables.homeSearchTickerDataMain.value.response.isNotEmpty
              ? SizedBox(
                  height: height / 57.73,
                )
              : const SizedBox()),
          Obx(
            () => homeVariables.homeSearchTickerDataMain.value.response.isNotEmpty
                ? SizedBox(
                    height: homeVariables.homeSearchTickerDataMain.value.response.length == 1 ? height / 11.54 : height / 5.77,
                    child: Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      controller: scrollControl,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: homeVariables.homeSearchTickerDataMain.value.response.length,
                          physics: const ScrollPhysics(),
                          controller: scrollControl,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return TickersDetailsPage(
                                    category: homeVariables.homeSearchTickerDataMain.value.response[index].category,
                                    id: homeVariables.homeSearchTickerDataMain.value.response[index].id,
                                    exchange: homeVariables.homeSearchTickerDataMain.value.response[index].exchange,
                                    country: homeVariables.homeSearchTickerDataMain.value.response[index].country,
                                    name: homeVariables.homeSearchTickerDataMain.value.response[index].name,
                                    fromWhere: 'search',
                                  );
                                }));
                              },
                              title: Text(homeVariables.homeSearchTickerDataMain.value.response[index].name,
                                  //style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                  style: Theme.of(context).textTheme.bodySmall),
                              subtitle: Text(
                                  "${homeVariables.homeSearchTickerDataMain.value.response[index].code} ${homeVariables.homeSearchTickerDataMain.value.response[index].category == "stocks" ? homeVariables.homeSearchTickerDataMain.value.response[index].exchange == "INDX" ? " - ${homeVariables.homeSearchTickerDataMain.value.response[index].type} Stocks" : homeVariables.homeSearchTickerDataMain.value.response[index].exchange == "NSE" ? " - NSE Stocks" : homeVariables.homeSearchTickerDataMain.value.response[index].exchange == "BSE" ? " - BSE Stocks" : " - USA Stocks" : ""}",
                                  //style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10.0, color: Color(0XFFA5A5A5)),
                                  style: Theme.of(context).textTheme.labelSmall),
                              leading: Container(
                                  height: height / 33.83,
                                  width: width / 15.625,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: homeVariables.homeSearchTickerDataMain.value.response[index].logoUrl.contains("svg")
                                      ? SvgPicture.network(homeVariables.homeSearchTickerDataMain.value.response[index].logoUrl, fit: BoxFit.fill)
                                      : Image.network(homeVariables.homeSearchTickerDataMain.value.response[index].logoUrl, fit: BoxFit.fill)),
                              trailing: SizedBox(
                                width: width / 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(
                                        children: [
                                          homeVariables.homeSearchTickerDataMain.value.response[index].category == "stocks"
                                              ? homeVariables.homeSearchTickerDataMain.value.response[index].exchange == "NSE" ||
                                                      homeVariables.homeSearchTickerDataMain.value.response[index].exchange == "BSE"
                                                  ? Text("\u{20B9} ",
                                                      /*style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: text.scale(14),
                                                          color: Colors.black,
                                                          fontFamily: "Robonto")*/
                                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: "Robonto"))
                                                  : Text("\$ ",
                                                      // style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w700, color: Colors.black),
                                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: "Robonto"))
                                              : homeVariables.homeSearchTickerDataMain.value.response[index].category == "commodity"
                                                  ? homeVariables.homeSearchTickerDataMain.value.response[index].category == "India"
                                                      ? Text("\u{20B9} ",
                                                          /*style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: text.scale(14),
                                                              color: Colors.black,
                                                              fontFamily: "Robonto")*/
                                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: "Robonto"))
                                                      : Text("\$ ",
                                                          /*style:
                                                              TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w700, color: Colors.black),*/
                                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: "Robonto"))
                                                  : homeVariables.homeSearchTickerDataMain.value.response[index].category == "forex"
                                                      ? Text("",
                                                          /*style:
                                                              TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w700, color: Colors.black),*/
                                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: "Robonto"))
                                                      : Text("\$ ",
                                                          /*style:
                                                              TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w700, color: Colors.black),*/
                                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: "Robonto")),
                                          Text(homeVariables.homeSearchTickerDataMain.value.response[index].close.toStringAsFixed(2),
                                              /*style:
                                                  TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0xff000000))*/
                                              style: Theme.of(context).textTheme.bodyLarge),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: homeVariables.homeSearchTickerDataMain.value.response[index].state == 'Increse'
                                                  ? Image.asset("lib/Constants/Assets/SMLogos/Up Arrow.png")
                                                  : Image.asset("lib/Constants/Assets/SMLogos/Down Arrow.png")),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          homeVariables.homeSearchTickerDataMain.value.response[index].state == 'Increse'
                                              ? Text("${homeVariables.homeSearchTickerDataMain.value.response[index].changeP.toStringAsFixed(2)}%",
                                                  /*style: TextStyle(
                                                      fontSize: text.scale(12), fontWeight: FontWeight.w400, color: const Color(0xff0EA102))*/
                                                  style: Theme.of(context).textTheme.bodySmall)
                                              : Text("-${homeVariables.homeSearchTickerDataMain.value.response[index].changeP.toStringAsFixed(2)}%",
                                                  /*style: TextStyle(
                                                      fontSize: text.scale(12), fontWeight: FontWeight.w400, color: const Color(0xffE3507A))*/
                                                  style: Theme.of(context).textTheme.bodySmall)
                                        ],
                                      )
                                    ]),
                                    GestureDetector(
                                      onTap: () async {
                                        if (mainSkipValue) {
                                          commonFlushBar(context: context, initFunction: initState);
                                        } else {
                                          if (homeVariables.homeSearchTickerDataMain.value.response[index].watchlist) {
                                            logEventFunc(name: 'Removed_Watchlist', type: 'WatchList');
                                            modelSetState(() {
                                              homeVariables.homeSearchTickerDataMain.value.response[index].watchlist =
                                                  !homeVariables.homeSearchTickerDataMain.value.response[index].watchlist;
                                            });
                                            await apiFunctionsMain.getRemoveWatchList(
                                                tickerId: homeVariables.homeSearchTickerDataMain.value.response[index].id, context: context);
                                          } else {
                                            /*  bool added = await addWatchList(
                                        tickerId: homeVariables.homeSearchTickerDataMain.value.response[index].id,
                                        categoryIndex: homeVariables.homeSearchTickerDataMain.value.response[index].category == "stocks"
                                            ? 0
                                            : homeVariables.homeSearchTickerDataMain.value.response[index].category == "crypto"
                                            ? 1
                                            : homeVariables.homeSearchTickerDataMain.value.response[index].category == "commodity"
                                            ? 2
                                            : homeVariables.homeSearchTickerDataMain.value.response[index].category == "forex"
                                            ? 3
                                            : 0,
                                        exchangeIndex: homeVariables.homeSearchTickerDataMain.value.response[index].type== "NSE"
                                            ? 1
                                            : homeVariables.homeSearchTickerDataMain.value.response[index].type == "BSE"
                                            ? 2
                                            : 0);*/
                                            bool added = await apiFunctionsMain.getAddWatchList(
                                                tickerId: homeVariables.homeSearchTickerDataMain.value.response[index].id,
                                                context: context,
                                                modelSetState: modelSetState);
                                            if (added) {
                                              logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
                                              modelSetState(() {
                                                homeVariables.homeSearchTickerDataMain.value.response[index].watchlist =
                                                    !homeVariables.homeSearchTickerDataMain.value.response[index].watchlist;
                                              });
                                            }
                                          }
                                        }
                                      },
                                      child: homeVariables.homeSearchTickerDataMain.value.response[index].watchlist
                                          ? Container(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              margin: const EdgeInsets.only(right: 10),
                                              child: SvgPicture.asset(
                                                isDarkTheme.value
                                                    ? "assets/home_screen/filled_star_dark.svg"
                                                    : isDarkTheme.value
                                                        ? "assets/home_screen/filled_star_dark.svg"
                                                        : "lib/Constants/Assets/SMLogos/Star.svg",
                                              ))
                                          : Container(
                                              height: height / 35.03,
                                              width: width / 16.30,
                                              margin: const EdgeInsets.only(right: 10),
                                              child: SvgPicture.asset(
                                                isDarkTheme.value
                                                    ? "assets/home_screen/empty_star_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Center(
                    child: Text("No search results found",
                        //style: TextStyle(fontSize: text.scale(12), color: const Color(0XFF0EA102)),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: const Color(0XFF0EA102))),
                  ),
          ),
          Obx(() => homeVariables.bannerAdIsLoadedMain.value && bannerAd != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                  child: SizedBox(
                    width: bannerAd.size.width.toDouble(),
                    height: bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  ),
                )
              : const SizedBox()),
          Obx(
            () => homeVariables.homeSearchTickerDataMain.value.response.isNotEmpty
                ? Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 0.8,
                  )
                : const SizedBox(),
          ),
          SizedBox(
            height: 35,
            width: width,
            child: TabBar(
              isScrollable: false,
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              dividerColor: Colors.transparent,
              dividerHeight: 0.0,
              indicatorColor: const Color(0XFF0EA102),
              indicatorSize: TabBarIndicatorSize.tab,
              splashFactory: NoSplash.splashFactory,
              tabs: [
                Text("News",
                    /*style: TextStyle(
                                fontSize: text.scale(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),*/
                    style: Theme.of(context).textTheme.bodyMedium),
                Text("Videos",
                    /*style: TextStyle(
                                fontSize: text.scale(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),*/
                    style: Theme.of(context).textTheme.bodyMedium),
                Text("Forum",
                    /*style: TextStyle(
                                fontSize: text.scale(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),*/
                    style: Theme.of(context).textTheme.bodyMedium),
                Text("Survey",
                    /*style: TextStyle(
                                fontSize: text.scale(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),*/
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
              onTap: (int index) async {},
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
              height: height / 1.8,
              child: TabBarView(controller: tabController, physics: const ScrollPhysics(), children: const [
                NewsSearchTabPage(),
                VideosSearchTabPage(),
                ForumSearchTabPage(),
                SurveySearchTabPage(),
              ])),
        ],
      ),
    );
  }
}

class NewsSearchTabPage extends StatefulWidget {
  const NewsSearchTabPage({Key? key}) : super(key: key);

  @override
  State<NewsSearchTabPage> createState() => _NewsSearchTabPageState();
}

class _NewsSearchTabPageState extends State<NewsSearchTabPage> with WidgetsBindingObserver {
  int skipLimit = 0;

  @override
  void initState() {
    homeVariables.tabSearchLoader = false.obs;
    getData();
    super.initState();
  }

  getData() async {
    homeVariables.searchTabType.value = "news";
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.clear();
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.value = true;
    homeVariables.tabSearchLoader.refresh();
  }

  onLoading() async {
    skipLimit = skipLimit + 10;
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.refresh();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refreshController = RefreshController();
    return Obx(
      () => homeVariables.tabSearchLoader.value
          ? homeVariables.homeSearchResponseData.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
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
              : Obx(
                  () => SmartRefresher(
                    controller: refreshController,
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("release to load more");
                        } else {
                          body = const Text("No more Data");
                        }
                        return SizedBox(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    onLoading: onLoading,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: homeVariables.homeSearchResponseData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              /*homeFunctions.getIdDataSearch(
                              id: homeVariables.homeSearchResponseData[index].id,
                              type: "news", modelSetState: setState);*/
                              homeVariables.searchControllerMain.value.clear();
                              /*await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return DemoPage(
                                  url: homeVariables.homeSearchResponseData[index].newsUrl,
                                  text: homeVariables.homeSearchResponseData[index].title,
                                  image: "",
                                  activity: false,
                                  type: "news",
                                  id: homeVariables.homeSearchResponseData[index].id,
                                  checkMain: false,
                                  fromWhere: "search",
                                );
                              }));*/
                              Get.to(const DemoView(), arguments: {
                                "id": homeVariables.homeSearchResponseData[index].id,
                                "type": "news",
                                "url": homeVariables.homeSearchResponseData[index].newsUrl
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: height / 16.3,
                                        width: width / 7.5,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              homeVariables.homeSearchResponseData[index].imageUrl,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 12.5,
                                      ),
                                      SizedBox(
                                        width: width / 1.5,
                                        child: Text(
                                          homeVariables.homeSearchResponseData[index].title,
                                          textAlign: TextAlign.left,
                                          maxLines: 3,
                                          style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 81.2,
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                )
          : Column(
              children: [
                Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
              ],
            ),
    );
  }
}

class VideosSearchTabPage extends StatefulWidget {
  const VideosSearchTabPage({Key? key}) : super(key: key);

  @override
  State<VideosSearchTabPage> createState() => _VideosSearchTabPageState();
}

class _VideosSearchTabPageState extends State<VideosSearchTabPage> with WidgetsBindingObserver {
  int skipLimit = 0;

  @override
  void initState() {
    homeVariables.tabSearchLoader = false.obs;
    getData();
    super.initState();
  }

  getData() async {
    homeVariables.searchTabType.value = "videos";
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.clear();
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.value = true;
    homeVariables.tabSearchLoader.refresh();
  }

  onLoading() async {
    skipLimit = skipLimit + 10;
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.refresh();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refreshController = RefreshController();
    return Obx(() => homeVariables.tabSearchLoader.value
        ? homeVariables.homeSearchResponseData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
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
            : Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = const CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text("release to load more");
                      } else {
                        body = const Text("No more Data");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  onLoading: onLoading,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: homeVariables.homeSearchResponseData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            /*homeFunctions.getIdDataSearch(
                                  id: homeVariables.homeSearchResponseData[index].id,
                                  type: "videos", modelSetState: setState);*/
                            homeVariables.searchControllerMain.value.clear();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return YoutubePlayerLandscapeScreen(
                                id: homeVariables.homeSearchResponseData[index].id,
                                comeFrom: 'search',
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            homeVariables.homeSearchResponseData[index].imageUrl,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: width / 1.5,
                                      child: Text(
                                        homeVariables.homeSearchResponseData[index].title,
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  thickness: 0.8,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
        : Column(
            children: [
              Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
            ],
          ));
  }
}

class ForumSearchTabPage extends StatefulWidget {
  const ForumSearchTabPage({Key? key}) : super(key: key);

  @override
  State<ForumSearchTabPage> createState() => _ForumSearchTabPageState();
}

class _ForumSearchTabPageState extends State<ForumSearchTabPage> with WidgetsBindingObserver {
  int skipLimit = 0;

  @override
  void initState() {
    homeVariables.tabSearchLoader = false.obs;
    getData();
    super.initState();
  }

  getData() async {
    homeVariables.searchTabType.value = "forums";
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.clear();
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.value = true;
    homeVariables.tabSearchLoader.refresh();
  }

  onLoading() async {
    skipLimit = skipLimit + 10;
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.refresh();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refreshController = RefreshController();
    return Obx(() => homeVariables.tabSearchLoader.value
        ? homeVariables.homeSearchResponseData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
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
            : Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = const CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text("release to load more");
                      } else {
                        body = const Text("No more Data");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  onLoading: onLoading,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: homeVariables.homeSearchResponseData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initState);
                            } else {
                              /*await homeFunctions.getIdData(
                                    id: homeVariables.homeSearchResponseData[index].id,
                                    type: 'forums', modelSetState: setState);*/
                              /*homeFunctions.getIdDataSearch(
                                    id: homeVariables.homeSearchResponseData[index].id,
                                    type: "forums",
                                    modelSetState:setState);*/
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return ForumPostDescriptionPage(
                                  forumId: homeVariables.homeSearchResponseData[index].id,
                                  comeFrom: 'home',
                                  idList: const [],
                                );
                              }));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: height / 16.3,
                                      width: width / 7.5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            homeVariables.homeSearchResponseData[index].user.avatar,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 12.5,
                                    ),
                                    SizedBox(
                                      width: width / 1.5,
                                      child: Text(
                                        homeVariables.homeSearchResponseData[index].title,
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height / 81.2,
                                ),
                                Divider(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  thickness: 0.8,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
        : Column(
            children: [
              Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
            ],
          ));
  }
}

class SurveySearchTabPage extends StatefulWidget {
  const SurveySearchTabPage({Key? key}) : super(key: key);

  @override
  State<SurveySearchTabPage> createState() => _SurveySearchTabPageState();
}

class _SurveySearchTabPageState extends State<SurveySearchTabPage> with WidgetsBindingObserver {
  int skipLimit = 0;

  @override
  void initState() {
    homeVariables.tabSearchLoader = false.obs;
    getData();
    super.initState();
  }

  getData() async {
    homeVariables.searchTabType.value = "survey";
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.clear();
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.value = true;
    homeVariables.tabSearchLoader.refresh();
  }

  onLoading() async {
    skipLimit = skipLimit + 10;
    await homeFunctions.getSearchValue(skipLimit: skipLimit.toString());
    homeVariables.homeSearchResponseData.addAll(homeVariables.homeSearchDataMain!.value.response);
    homeVariables.tabSearchLoader.refresh();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refreshController = RefreshController();
    return Obx(() => homeVariables.tabSearchLoader.value
        ? homeVariables.homeSearchResponseData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
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
            : Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = const CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text("release to load more");
                      } else {
                        body = const Text("No more Data");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  onLoading: onLoading,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: homeVariables.homeSearchResponseData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initState);
                            } else {
                              /*homeFunctions.getIdDataSearch(
                                    id: homeVariables.homeSearchResponseData[index].id,
                                    type: "survey",
                                    modelSetState:setState);*/
                              await homeFunctions.getStatusFunc(surveyId: homeVariables.homeSearchResponseData[index].id);
                              if (!mounted) {
                                return;
                              } else {
                                homeVariables.homeSearchResponseData[index].user.id == userIdMain
                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return AnalyticsPage(
                                            surveyId: homeVariables.homeSearchResponseData[index].id,
                                            activity: false,
                                            surveyTitle: homeVariables.homeSearchResponseData[index].title);
                                      }))
                                    : homeVariables.activeStatusMain.value == 'active'
                                        ? homeVariables.answerStatusMain.value
                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return AnalyticsPage(
                                                    surveyId: homeVariables.homeSearchResponseData[index].id,
                                                    activity: false,
                                                    surveyTitle: homeVariables.homeSearchResponseData[index].title);
                                              }))
                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return QuestionnairePage(
                                                  surveyId: homeVariables.homeSearchResponseData[index].id,
                                                  defaultIndex: homeVariables.answeredQuestionMain.value,
                                                );
                                              }))
                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return AnalyticsPage(
                                                surveyId: homeVariables.homeSearchResponseData[index].id,
                                                activity: false,
                                                surveyTitle: homeVariables.homeSearchResponseData[index].title);
                                          }));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: height / 16.3,
                                      width: width / 7.5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            homeVariables.homeSearchResponseData[index].user.avatar,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 12.5,
                                    ),
                                    SizedBox(
                                      width: width / 1.5,
                                      child: Text(
                                        homeVariables.homeSearchResponseData[index].title,
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height / 81.2,
                                ),
                                Divider(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  thickness: 0.8,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
        : Column(
            children: [
              Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
            ],
          ));
  }
}
