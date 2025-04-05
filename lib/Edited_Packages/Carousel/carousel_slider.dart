// ignore_for_file: no_logic_in_create_state, unnecessary_this, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, prefer_conditional_assignment, deprecated_member_use

library carousel_slider;

import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/API.dart';
import 'package:tradewatchfinal/Screens/Module1/HomeScreen/tape_ticker_model.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';

import 'carousel_controller.dart';
import 'carousel_options.dart';
import 'carousel_state.dart';
import 'utils.dart';

export 'carousel_controller.dart';
export 'carousel_options.dart';

typedef ExtendedIndexedWidgetBuilder = Widget Function(BuildContext context, int index, int realIndex);

class CarouselSlider extends StatefulWidget {
  final CarouselOptions options;
  final bool? disableGesture;
  final CarouselControllerImpl _carouselController;

  CarouselSlider({required this.options, this.disableGesture, CarouselController? carouselController, Key? key})
      : _carouselController =
            carouselController != null ? carouselController as CarouselControllerImpl : CarouselController() as CarouselControllerImpl,
        super(key: key);

  CarouselSlider.builder({required this.options, this.disableGesture, CarouselController? carouselController, Key? key})
      : _carouselController =
            carouselController != null ? carouselController as CarouselControllerImpl : CarouselController() as CarouselControllerImpl,
        super(key: key);

  @override
  CarouselSliderState createState() => CarouselSliderState(_carouselController);
}

class CarouselSliderState extends State<CarouselSlider> with TickerProviderStateMixin {
  final CarouselControllerImpl carouselController;
  Timer? timer;
  late TapeTickerModel tapeTickerResponse;
  List tickerTapeExchange = [];
  final List<bool> tapeWatchList = [];
  bool carLoader = false;

  CarouselOptions get options => widget.options;
  CarouselState? carouselState;
  PageController? pageController;
  CarouselPageChangedReason mode = CarouselPageChangedReason.controller;
  int side = 0;
  String selectedSide = "";
  double selectedIndex = 0;

  CarouselSliderState(this.carouselController);

  List<NativeAd> nativeAdTickerList = <NativeAd>[];
  List<bool> nativeAdIsLoadedTickerList = <bool>[];

  void changeMode(CarouselPageChangedReason mode) {
    mode = mode;
  }

  @override
  void initState() {
    doAllTasks();
    super.initState();
  }

  doAllTasks() async {
    await getTapeTickerValues();
    carouselState = CarouselState(this.options, clearTimer, resumeTimer, this.changeMode);
    carouselState!.itemCount = tapeTickerResponse.response.length;
    carouselController.state = carouselState;
    carouselState!.initialPage = widget.options.initialPage;
    carouselState!.realPage = options.enableInfiniteScroll ? carouselState!.realPage + carouselState!.initialPage : carouselState!.initialPage;
    handleAutoPlay();
    pageController = PageController(
      viewportFraction: options.viewportFraction,
      initialPage: carouselState!.realPage,
    );
    carouselState!.pageController = pageController;
  }

  getTapeTickerValues() async {
    tickerTapeExchange.clear();
    tapeWatchList.clear();
    nativeAdTickerList.clear();
    nativeAdIsLoadedTickerList.clear();
    var url = baseurl + versionHome + tickerTape;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var response = await dioMain.get(
      url,
      options: Options(headers: {'Authorization': mainUserToken}),
    );
    var responseData = response.data;
    tapeTickerResponse = TapeTickerModel.fromJson(responseData);
    for (int i = 0; i < tapeTickerResponse.response.length; i++) {
      if (tapeTickerResponse.response[i].category == 'stocks') {
        if (tapeTickerResponse.response[i].exchange == "NSE" ||
            tapeTickerResponse.response[i].exchange == "BSE" ||
            tapeTickerResponse.response[i].exchange == "INDX") {
          tickerTapeExchange.add(tapeTickerResponse.response[i].exchange.toLowerCase());
        } else if (responseData["response"][i]["exchange"] == "" || responseData["response"][i]["exchange"] == null) {
          tickerTapeExchange.add("");
        } else {
          tickerTapeExchange.add("usastocks");
        }
      } else if (tapeTickerResponse.response[i].category == 'crypto') {
        tickerTapeExchange
            .add(tapeTickerResponse.response[i].industry.isEmpty ? 'coin' : tapeTickerResponse.response[i].industry[0].name.toLowerCase());
      } else if (tapeTickerResponse.response[i].category == 'commodity') {
        tickerTapeExchange.add(tapeTickerResponse.response[i].country.toLowerCase());
      } else {
        tickerTapeExchange.add("inrusd");
      }
      tapeWatchList.add(tapeTickerResponse.response[i].watchlist);
    }
    setState(() {
      carLoader = true;
    });
  }

  getAddWatchList({required int index}) async {
    if (mainSkipValue) {
      commonFlushBar(context: context, initFunction: initState);
    } else {
      if (tapeWatchList[index]) {
        removeWatchList(tickerId: tapeTickerResponse.response[index].id);
        setState(() {
          tapeWatchList[index] = !tapeWatchList[index];
        });
      } else {
        bool added =
            await apiFunctionsMain.getAddWatchList(tickerId: tapeTickerResponse.response[index].id, context: context, modelSetState: setState);
        if (added) {
          logEventFunc(name: 'Added_Watchlist', type: 'WatchList');
          setState(() {
            tapeWatchList[index] = !tapeWatchList[index];
          });
        }
      }
    }
  }

  removeWatchList({required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      )..show(context);
    } else {
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      )..show(context);
    }
  }

  Timer? getTimer() {
    return widget.options.autoPlay
        ? Timer.periodic(widget.options.autoPlayInterval, (_) {
            if (!mounted) {
              clearTimer();
              return;
            }

            final route = ModalRoute.of(context);
            if (route?.isCurrent == false) {
              return;
            }

            CarouselPageChangedReason previousReason = mode;
            changeMode(CarouselPageChangedReason.timed);
            int nextPage = carouselState!.pageController!.page!.round() + 1;
            int itemCount = tapeTickerResponse.response.length;

            if (nextPage >= itemCount && widget.options.enableInfiniteScroll == false) {
              if (widget.options.pauseAutoPlayInFiniteScroll) {
                clearTimer();
                return;
              }
              nextPage = 0;
            }

            carouselState!.pageController!
                .animateToPage(nextPage, duration: widget.options.autoPlayAnimationDuration, curve: widget.options.autoPlayCurve)
                .then((_) => changeMode(previousReason));
          })
        : null;
  }

  void clearTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  void resumeTimer() {
    if (timer == null) {
      timer = getTimer();
    }
  }

  void handleAutoPlay() {
    bool autoPlayEnabled = widget.options.autoPlay;
    if (autoPlayEnabled && timer != null) return;
    clearTimer();
    if (autoPlayEnabled) {
      resumeTimer();
    }
  }

  Widget getGestureWrapper(Widget child) {
    Widget wrapper;
    if (widget.options.height != null) {
      wrapper = SizedBox(height: widget.options.height, child: child);
    } else {
      wrapper = AspectRatio(aspectRatio: widget.options.aspectRatio, child: child);
    }

    if (true == widget.disableGesture) {
      return NotificationListener(
        onNotification: (Notification notification) {
          if (widget.options.onScrolled != null && notification is ScrollUpdateNotification) {
            widget.options.onScrolled!(carouselState!.pageController!.page);
          }
          return false;
        },
        child: wrapper,
      );
    }
    return GestureDetector(
      onTapUp: (value) {
        double value = pageController!.page! - pageController!.page!.toInt();
        if (value != 0.0) {
          Flushbar(
            message: "Tap again to add/remove watchlist",
            duration: const Duration(seconds: 2),
          )..show(context);
        }
      },
      onDoubleTap: () {
        double value = pageController!.page! - pageController!.page!.toInt();
        if (value == 0.0) {
          int index = pageController!.page!.toInt() - pageController!.initialPage.toInt();
          if (selectedSide == "left") {
            index = index - 1;
          } else if (selectedSide == "right") {
            index = index + 1;
          } else {}
          /* mainVariables.selectedTickerId.value=tapeTickerResponse.response[index].id;
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return TickersDetailsPage(
                category: tapeTickerResponse.response[index].category,
                id: tapeTickerResponse.response[index].id,
                exchange: tapeTickerResponse.response[index].exchange,
                country: tapeTickerResponse.response[index].country,
                name: tapeTickerResponse.response[index].name,
                fromWhere: "main");
          }));
        }
        /*   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return TickersDetailsPage(category: category, id: id, exchange: exchange, country: country, name: name, fromWhere: fromWhere)
        }));*/
      },
      onTapDown: (value) {
        double value = pageController!.page! - pageController!.page!.toInt();
        if (value == 0.0) {
          int index = pageController!.page!.toInt() - pageController!.initialPage.toInt();
          selectedSide = side < 60
              ? "left"
              : side > 350
                  ? 'right'
                  : "center";
          if (selectedSide == "left") {
            index = index - 1;
          } else if (selectedSide == "right") {
            index = index + 1;
          } else {}
          getAddWatchList(index: index);
        }
      },
      onPanDown: (value) {
        side = value.localPosition.dx.toInt();
        onPanDown();
      },
      onPanStart: (value) {
        onStart();
      },
      onPanEnd: (value) {
        onPanUp();
      },
      onPanCancel: () {
        onPanUp();
      },
      child: NotificationListener(
        onNotification: (Notification notification) {
          if (widget.options.onScrolled != null && notification is ScrollUpdateNotification) {
            widget.options.onScrolled!(carouselState!.pageController!.page);
          }
          return false;
        },
        child: wrapper,
      ),
    );
  }

  Widget getCenterWrapper(Widget child) {
    if (widget.options.disableCenter) {
      return Container(
        child: child,
      );
    }
    return Center(child: child);
  }

  Widget getEnlargeWrapper(Widget? child, {double? width, double? height, double? scale, required double itemOffset}) {
    if (widget.options.enlargeStrategy == CenterPageEnlargeStrategy.height) {
      return SizedBox(width: width, height: height, child: child);
    }
    if (widget.options.enlargeStrategy == CenterPageEnlargeStrategy.zoom) {
      late Alignment alignment;
      final bool horizontal = options.scrollDirection == Axis.horizontal;
      if (itemOffset > 0) {
        alignment = horizontal ? Alignment.centerRight : Alignment.bottomCenter;
      } else {
        alignment = horizontal ? Alignment.centerLeft : Alignment.topCenter;
      }
      return Transform.scale(scale: scale!, alignment: alignment, child: child);
    }
    return Transform.scale(scale: scale!, child: SizedBox(width: width, height: height, child: child));
  }

  void onStart() {
    changeMode(CarouselPageChangedReason.manual);
  }

  void onPanDown() {
    if (widget.options.pauseAutoPlayOnTouch) {
      clearTimer();
    }
    changeMode(CarouselPageChangedReason.manual);
  }

  void onPanUp() {
    if (widget.options.pauseAutoPlayOnTouch) {
      resumeTimer();
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < nativeAdTickerList.length; i++) {
      nativeAdTickerList[i].dispose();
    }
    nativeAdTickerList.clear();
    super.dispose();
    clearTimer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height0 = MediaQuery.of(context).size.height;
    double text = MediaQuery.of(context).textScaleFactor;
    return carLoader
        ? getGestureWrapper(PageView.builder(
            padEnds: widget.options.padEnds,
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              overscroll: false,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            clipBehavior: widget.options.clipBehavior,
            physics: widget.options.scrollPhysics,
            scrollDirection: widget.options.scrollDirection,
            pageSnapping: widget.options.pageSnapping,
            controller: carouselState!.pageController,
            reverse: widget.options.reverse,
            itemCount: widget.options.enableInfiniteScroll ? null : tapeTickerResponse.response.length,
            key: widget.options.pageViewKey,
            onPageChanged: (int index) {
              int currentPage = getRealIndex(index + carouselState!.initialPage, carouselState!.realPage, tapeTickerResponse.response.length);
              if (widget.options.onPageChanged != null) {
                widget.options.onPageChanged!(currentPage, mode);
              }
            },
            itemBuilder: (BuildContext context, int idx) {
              final int index = getRealIndex(idx + carouselState!.initialPage, carouselState!.realPage, tapeTickerResponse.response.length);
              return AnimatedBuilder(
                animation: carouselState!.pageController!,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  color: Theme.of(context).colorScheme.background,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: height0 / 35.04,
                              width: height0 / 16.44,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: tapeTickerResponse.response[index].logoUrl.contains("svg")
                                  ? SvgPicture.network(tapeTickerResponse.response[index].logoUrl, fit: BoxFit.fill)
                                  : Image.network(tapeTickerResponse.response[index].logoUrl, fit: BoxFit.fill),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tapeTickerResponse.response[index].code,
                                  //style: TextStyle(fontSize: _text * 12, color: const Color(0XFF616161), fontWeight: FontWeight.w500),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                tickerTapeExchange[index] == 'nse' || tickerTapeExchange[index] == 'bse' || tickerTapeExchange[index] == 'india'
                                    ? Text(
                                        '\u{20B9} ${tapeTickerResponse.response[index].close.toStringAsFixed(2)}',
                                        /*style: TextStyle(
                                            fontSize: _text * 12, color: const Color(0XFF2C3335), fontWeight: FontWeight.w600, fontFamily: "Robonto"),*/
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                      )
                                    : Text(
                                        '\$ ${tapeTickerResponse.response[index].close.toStringAsFixed(2)}',
                                        //style: TextStyle(fontSize: _text * 12, color: const Color(0XFF2C3335), fontWeight: FontWeight.w600),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                      ),
                                tapeTickerResponse.response[index].state == 'Decrease'
                                    ? Text(
                                        '-${tapeTickerResponse.response[index].changeP.toStringAsFixed(2)}%',
                                        style: TextStyle(fontSize: text * 12, color: const Color(0XFFE80E0E), fontWeight: FontWeight.w600),
                                      )
                                    : Text(
                                        '+${tapeTickerResponse.response[index].changeP.toStringAsFixed(2)}%',
                                        style: TextStyle(fontSize: text * 12, color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
                                      ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: width / 51.375, vertical: height0 / 219),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  excLabelButton(text: tickerTapeExchange[index], context: context),
                                  SizedBox(
                                    height: height0 / 109.5,
                                  ),
                                  tapeWatchList[index]
                                      ? SizedBox(
                                          height: height0 / 35.04,
                                          width: width / 16.44,
                                          child: SvgPicture.asset(
                                            isDarkTheme.value
                                                ? "assets/home_screen/filled_star_dark.svg"
                                                : isDarkTheme.value
                                                    ? "assets/home_screen/filled_star_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/Star.svg",
                                          ))
                                      : SizedBox(
                                          height: height0 / 35.04,
                                          width: width / 16.44,
                                          child: SvgPicture.asset(
                                            isDarkTheme.value
                                                ? "assets/home_screen/empty_star_dark.svg"
                                                : isDarkTheme.value
                                                    ? "assets/home_screen/empty_star_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/emptyStar.svg",
                                          )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 2,
                          child: VerticalDivider(
                            thickness: 2,
                            color: Theme.of(context).colorScheme.tertiary,
                          ))
                    ],
                  ),
                ),
                builder: (BuildContext context, child) {
                  double distortionValue = 1.0;
                  double itemOffset = 0;
                  if (widget.options.enlargeCenterPage != null && widget.options.enlargeCenterPage == true) {
                    var position = carouselState?.pageController?.position;
                    if (position != null && position.hasPixels && position.hasContentDimensions) {
                      var page = carouselState?.pageController?.page;
                      if (page != null) {
                        itemOffset = page - idx;
                      }
                    } else {
                      BuildContext storageContext = carouselState!.pageController!.position.context.storageContext;
                      final double? previousSavedPosition = PageStorage.of(storageContext)?.readState(storageContext) as double?;
                      if (previousSavedPosition != null) {
                        itemOffset = previousSavedPosition - idx.toDouble();
                      } else {
                        itemOffset = carouselState!.realPage.toDouble() - idx.toDouble();
                      }
                    }

                    final double enlargeFactor = options.enlargeFactor.clamp(0.0, 1.0);
                    final num distortionRatio = (1 - (itemOffset.abs() * enlargeFactor)).clamp(0.0, 1.0);
                    distortionValue = Curves.easeOut.transform(distortionRatio as double);
                  }

                  final double height = widget.options.height ?? MediaQuery.of(context).size.width * (1 / widget.options.aspectRatio);

                  if (widget.options.scrollDirection == Axis.horizontal) {
                    return getCenterWrapper(
                        getEnlargeWrapper(child, height: distortionValue * height, scale: distortionValue, itemOffset: itemOffset));
                  } else {
                    return getCenterWrapper(getEnlargeWrapper(child,
                        width: distortionValue * MediaQuery.of(context).size.width * 2, scale: distortionValue, itemOffset: itemOffset));
                  }
                },
              );
            },
          ))
        : Container(
            height: 60,
            width: width,
            color: Theme.of(context).colorScheme.background,
            child: Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/LockerScreen/Loading Dots.json', height: 100, width: 100),
            ),
          );
  }
}

//class _MultipleGestureRecognizer extends PanGestureRecognizer {}
