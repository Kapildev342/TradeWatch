import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'demo_controller.dart';

class DemoView extends StatefulWidget {
  const DemoView({super.key});

  @override
  State<DemoView> createState() => _DemoViewState();
}

class _DemoViewState extends State<DemoView> {
  @override
  void dispose() {
    _DemoViewState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: GetBuilder<DemoController>(
            init: DemoController(),
            builder: (DemoController controller) {
              return WillPopScope(
                onWillPop: () async {
                  if (controller.fromLink) {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const MainBottomNavigationPage(
                          caseNo1: 0, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true);
                    }));
                  } else {
                    Get.back();
                  }
                  return false;
                },
                child: Scaffold(
                  //backgroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: controller.initialModelData.loading
                      ? AppBar(
                          actions: controller.initialModelData.id != ""
                              ? [
                                  controller.initialModelData.appBarLoading
                                      ? IconButton(
                                          onPressed: () async {
                                            controller.likePressingFunction(context: context);
                                          },
                                          icon: controller.initialModelData.isLiked
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
                                        )
                                      : const SizedBox(),
                                  controller.initialModelData.appBarLoading
                                      ? IconButton(
                                          onPressed: () async {
                                            controller.sharePressingFunction();
                                          },
                                          icon: SvgPicture.asset(
                                            isDarkTheme.value
                                                ? "assets/home_screen/share_dark.svg"
                                                : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                          ),
                                        )
                                      : const SizedBox(),
                                  controller.initialModelData.appBarLoading
                                      ? IconButton(
                                          onPressed: () async {
                                            controller.dislikePressingFunction(context: context);
                                          },
                                          icon: controller.initialModelData.isDisliked
                                              ? SvgPicture.asset(isDarkTheme.value
                                                  ? "assets/home_screen/dislike_filled_dark.svg"
                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg")
                                              : SvgPicture.asset(
                                                  isDarkTheme.value
                                                      ? "assets/home_screen/dislike_dark.svg"
                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                ),
                                        )
                                      : const SizedBox(),
                                  controller.initialModelData.appBarLoading
                                      ? IconButton(
                                          onPressed: () async {
                                            controller.bookmarkPressingFunction(context: context);
                                          },
                                          icon: controller.initialModelData.bookmark
                                              ? Image.asset(
                                                  isDarkTheme.value
                                                      ? "assets/home_screen/bookmark_filled_dark.png"
                                                      : "assets/home_screen/bookmark_filled.png",
                                                  height: 15,
                                                  width: 15,
                                                )
                                              : Image.asset(
                                                  isDarkTheme.value ? "assets/home_screen/bookmark_dark.png" : "assets/home_screen/bookmark.png",
                                                  height: 15,
                                                  width: 15,
                                                ),
                                        )
                                      : const SizedBox(),
                                ]
                              : [],
                          backgroundColor: Theme.of(context).colorScheme.background,
                          elevation: 0.0,
                          leading: IconButton(
                              onPressed: () {
                                if (controller.fromLink) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return const MainBottomNavigationPage(
                                        caseNo1: 0, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true);
                                  }));
                                } else {
                                  Get.back();
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                        )
                      : AppBar(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          elevation: 0.0,
                        ),
                  body: controller.initialModelData.loading
                      ? Column(
                          children: [
                            controller.initialModelData.id != "" ? SizedBox(height: height / 57.73) : const SizedBox(),
                            controller.initialModelData.id != ""
                                ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0XFF0EA102),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return IntermediaryBillBoardProfilePage(userId: controller.initialModelData.intermediaryProfileId);
                                            }));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "lib/Constants/Assets/NewsPageImage/profile.png",
                                                height: height / 28.86,
                                              ),
                                              SizedBox(
                                                width: width / 27.4,
                                              ),
                                              Text(
                                                "Visit Profile",
                                                style: TextStyle(fontSize: text.scale(14), color: Colors.white, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 41.1,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0XFF017FDB),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return FinalChartPage(
                                                  tickerId: controller.initialModelData.newsTickerId,
                                                  category: controller.initialModelData.newsTickerCategoryId,
                                                  exchange: controller.initialModelData.newsTickerExchangeId,
                                                  chartType: '2',
                                                  index: 0,
                                                );
                                              }));
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "lib/Constants/Assets/NewsPageImage/up-arrow.png",
                                                  height: height / 28.86,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: width / 27.4,
                                                ),
                                                Text(
                                                  "Analyze Charts",
                                                  style: TextStyle(fontSize: text.scale(14), color: Colors.white, fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Expanded(child: WebViewWidget(controller: controller.wvController))
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
            }));
  }
}
