import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/add_watch_list_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';

import 'calculator_page_design_model.dart';

class CalculatorPageWidgets {
  Widget bodyListWidgets({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: lockerVariables.calculatorPageContents!.value.response.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 0,
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                      height: height / 21.65,
                      width: width,
                      /*decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
                        color: Theme.of(context).colorScheme.onBackground,
                      ),*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height / 28.86,
                                width: width / 13.7,
                                child: lockerVariables.calculatorPageContents!.value.response[index].imageUrl.contains(".png")
                                    ? Image.asset(lockerVariables.calculatorPageContents!.value.response[index].imageUrl, fit: BoxFit.fill)
                                    : SvgPicture.asset(lockerVariables.calculatorPageContents!.value.response[index].imageUrl, fit: BoxFit.fill),
                              ),
                              SizedBox(
                                width: width / 27.4,
                              ),
                              Text(
                                lockerVariables.calculatorPageContents!.value.response[index].topic,
                                style: TextStyle(fontSize: text.scale(15), fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Obx(
                            () => lockerVariables.isDeletingEnabled[index]
                                ? InkWell(
                                    onTap: () {
                                      lockerVariables.isDeletingEnabled[index] = false;
                                    },
                                    child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Color(0XFF0EA102),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                  )
                                : InkWell(
                                    onTap: () {
                                      modifyBottomSheet(context: context, superIndex: index);
                                    },
                                    child: Image.asset(
                                      "lib/Constants/Assets/NewAssets/LockerScreen/edit.png",
                                      fit: BoxFit.fill,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 0.8,
                  ),
                  childrenWidgets(context: context, superIndex: index),
                ],
              ),
            );
          }),
    );
  }

  Widget childrenWidgets({required BuildContext context, required int superIndex}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: height / 144.3),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return TickersDetailsPage(
                          category: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.category,
                          id: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.id,
                          exchange: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.exchange,
                          country: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.country,
                          name: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.name,
                          fromWhere: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.fromWhere);
                    }));
                  },
                  leading: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.imageUrl),
                      ),
                      superIndex == 3
                          ? const SizedBox()
                          : lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.country == "India"
                              ? const CircleAvatar(
                                  foregroundImage: AssetImage("lib/Constants/Assets/flags/in.png"),
                                  radius: 8,
                                )
                              : const CircleAvatar(
                                  foregroundImage: AssetImage("lib/Constants/Assets/flags/us.png"),
                                  radius: 8,
                                ),
                    ],
                  ),
                  title: Text(
                    lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.name,
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          excLabelButton(
                              text: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].name,
                              context: context,
                              isSmall: true),
                          Text(
                            "  |  ",
                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, color: const Color(0XFF403D3D)),
                          ),
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: Text(
                                lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.code,
                                style: TextStyle(
                                    fontSize: text.scale(10),
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                              ),
                            ),
                          ),
                          Text(
                            "  |  ",
                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          Text(
                            "${lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.country == "India" ? "\u{20B9}" : "\$"} ${lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.close}",
                            style: TextStyle(
                                fontSize: text.scale(10),
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 173.2),
                      decoration:
                          BoxDecoration(color: Theme.of(context).colorScheme.onBackground, borderRadius: BorderRadius.circular(8), boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                          spreadRadius: 0,
                        )
                      ]),
                      child: Text(
                        "S : ${lockerVariables.calculatorPageContents!.value.response[superIndex].responseList[index].ticker.value.value}",
                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => lockerVariables.isDeletingEnabled[superIndex]
                    ? Positioned(
                        top: 5,
                        right: 5,
                        child: lockerVariables.calculatorPageContents!.value.response[superIndex].responseList.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  lockerVariables.calculatorSelectedTickersList[superIndex].removeAt(index);
                                  lockerVariables.calculatorPageContents!.value.response[superIndex].responseList.removeAt(index);
                                },
                                child: Image.asset(
                                  "lib/Constants/Assets/NewAssets/LockerScreen/delete.png",
                                ),
                              )
                            : const SizedBox())
                    : const SizedBox(),
              ),
            ],
          );
        }));
  }

  modifyBottomSheet({required BuildContext context, required int superIndex}) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      color: Theme.of(context).colorScheme.background),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: width / 16.44),
                        child: Text("Modify your favourites", style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w600)),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    tickersBottomSheet(
                      context: context,
                      superIndex: superIndex,
                    );
                  },
                  tileColor: Theme.of(context).colorScheme.background,
                  leading: Container(
                      height: height / 27.47,
                      width: width / 11.74,
                      margin: EdgeInsets.only(right: width / 27.4),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                          spreadRadius: 0,
                        )
                      ]),
                      child: const Icon(
                        Icons.add,
                        color: Color(0XFF0EA102),
                      )),
                  title: Text("Add", style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w400)),
                ),
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 0.8,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    if (lockerVariables.calculatorPageContents!.value.response[superIndex].responseList.length > 1) {
                      lockerVariables.isDeletingEnabled[superIndex] = true;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("At least one company must be in each categories"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  tileColor: Theme.of(context).colorScheme.background,
                  leading: Container(
                    height: height / 27.47,
                    width: width / 11.74,
                    margin: EdgeInsets.only(right: width / 27.4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Image.asset(
                      "lib/Constants/Assets/activity/delete.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text("Remove", style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w400)),
                ),
                Container(
                  height: height / 57.73,
                  color: Theme.of(context).colorScheme.background,
                ),
              ]);
        });
  }

  tickersBottomSheet({
    required BuildContext context,
    required int superIndex,
  }) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return TickersListBottomSheet(
            superIndex: superIndex,
          );
        });
  }

  infoPopUp({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Information',
                style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                    height: height / 34.64,
                    width: width / 16.44,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                      )
                    ]),
                    child: Center(child: Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 20))),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          "Enter your investment amount and see exactly how much of each stock, crypto, commodity, or forex you can acquire with your money on the current asset price.",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: text.scale(14),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins")),
                ]),
              ),
              SizedBox(
                height: height / 57.73,
              ),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Disclaimer:",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: text.scale(12),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text:
                        " This is not financial advice but just a simulation tool. We recommend you contact your financial advisor or do research before investing.",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: text.scale(12),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.italic),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TickersListBottomSheet extends StatefulWidget {
  final int superIndex;

  const TickersListBottomSheet({Key? key, required this.superIndex}) : super(key: key);

  @override
  State<TickersListBottomSheet> createState() => _TickersListBottomSheetState();
}

class _TickersListBottomSheetState extends State<TickersListBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    switch (widget.superIndex) {
      case 0:
        {
          return SizedBox(
            height: height / 1.44,
            width: width,
            child: Column(children: [
              SizedBox(height: height / 57.73),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Companies",
                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  )),
              const Expanded(
                child: StocksPage(
                  excIndex: 1,
                ),
              ),
            ]),
          );
        }
      case 1:
        {
          return SizedBox(
            height: height / 1.44,
            width: width,
            child: Column(children: [
              SizedBox(height: height / 57.73),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Companies",
                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  )),
              const Expanded(
                child: CryptoPage(),
              ),
            ]),
          );
        }
      case 2:
        {
          return SizedBox(
            height: height / 1.44,
            width: width,
            child: Column(children: [
              SizedBox(height: height / 57.73),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Companies",
                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  )),
              const Expanded(
                child: CommodityPage(
                  countryIndex: 0,
                ),
              ),
            ]),
          );
        }
      case 3:
        {
          return SizedBox(
            height: height / 1.44,
            width: width,
            child: Column(children: [
              SizedBox(height: height / 57.73),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Companies",
                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  )),
              const Expanded(
                child: ForexPage(),
              ),
            ]),
          );
        }
      default:
        {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        }
    }
  }
}

class StocksPage extends StatefulWidget {
  final int excIndex;

  const StocksPage({Key? key, required this.excIndex}) : super(key: key);

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  String mainUserToken = "";
  int excIndex = 1;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 5, initialIndex: widget.excIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          SizedBox(height: height / 57.73),
          PreferredSize(
            preferredSize: Size.fromWidth(width / 13.7),
            child: SizedBox(
              height: height / 24.74,
              width: width,
              child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
                  labelColor: const Color(0XFF11AA04),
                  indicatorColor: Colors.green,
                  indicatorWeight: 2,
                  tabAlignment: TabAlignment.start,
                  labelPadding: EdgeInsets.only(right: width / 8.22),
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  dividerHeight: 0.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Text(
                      "Indian Indexes",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                    Text("NSE India", style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14))),
                    Text(
                      "BSE India",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                    Text(
                      "USA Indexes",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                    Text(
                      "USA Stocks",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: height / 57.73),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const ScrollPhysics(),
              children: const [
                IndianIndexesPage(),
                NSEPage(),
                BSEPage(),
                USAIndexesPage(),
                USAPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IndianIndexesPage extends StatefulWidget {
  const IndianIndexesPage({Key? key}) : super(key: key);

  @override
  State<IndianIndexesPage> createState() => _IndianIndexesPageState();
}

class _IndianIndexesPageState extends State<IndianIndexesPage> {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List mainExchangeIdList = [];
  int selectedRadioIndex = -1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getLiveStatus();
    await getEx();
    await getWatchValues(text: '');
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController2.add(responseData["response"]);
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      //headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            mainExchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  /* Future<bool> addWatchList({required String tickerId}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAdd;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": mainExchangeIdList[1],
      "ticker_id": tickerId,
    };
    var response = await dioMain.post(url,
        options: Options(headers: {'Authorization': mainUserToken}),
        data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      Flushbar(
        message: responseData["message"],
        duration: Duration(seconds: 2),
      )..show(context);
    } else {
      Flushbar(
        message: responseData["message"],
        duration: Duration(seconds: 2),
      )..show(context);
    }
    return responseData["status"];
  }*/

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": mainExchangeIdList[1],
      "ticker_id": tickerId,
      "min_value": minValue,
      "max_value": maxvalue
    };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;
    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;
    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "India",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: height / 34.80,
                              width: width / 16.07,
                              margin: EdgeInsets.only(right: width / 16.44),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("lib/Constants/Assets/SMLogos/rupee.png")),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\u{20B9})',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\u{20B9})',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 17.32),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'stocks',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          onDoubleTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'stocks',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'stocks',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              onDoubleTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'stocks',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: text.scale(10),
                                                              color: const Color(0xffB0B0B0),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.8,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("\u{20B9}",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: "Robonto")),
                                                          Text(watchCloseList[index].toStringAsFixed(2),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: text.scale(12),
                                                              )),
                                                        ],
                                                      ),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "indx",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'stocks',
                                                          exchange: 'INDX',
                                                          country: 'India',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[0].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[0].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                )
        ],
      ),
    );
  }
}

class NSEPage extends StatefulWidget {
  const NSEPage({Key? key}) : super(key: key);

  @override
  State<NSEPage> createState() => _NSEPageState();
}

class _NSEPageState extends State<NSEPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List mainExchangeIdList = [];
  int selectedRadioIndex = -1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getLiveStatus();
    await getEx();
    await getWatchValues(text: '');
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController2.add(responseData["response"]);
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      //headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            mainExchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": mainExchangeIdList[1],
      "ticker_id": tickerId,
      "min_value": minValue,
      "max_value": maxvalue
    };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;
    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: height / 34.80,
                              width: width / 16.07,
                              margin: EdgeInsets.only(right: width / 27.4),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("lib/Constants/Assets/SMLogos/rupee.png")),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\u{20B9})',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\u{20B9})',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 8.22),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'stocks',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          onDoubleTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'stocks',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'stocks',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              onDoubleTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'stocks',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3.8,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: const Color(0xffB0B0B0),
                                                              fontSize: text.scale(10),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("\u{20B9}",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: "Robonto")),
                                                          Text(watchCloseList[index].toStringAsFixed(2),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: text.scale(12),
                                                              )),
                                                        ],
                                                      ),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "nse",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'stocks',
                                                          exchange: 'NSE',
                                                          country: 'India',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[0].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[0].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                )
        ],
      ),
    );
  }
}

class BSEPage extends StatefulWidget {
  const BSEPage({Key? key}) : super(key: key);

  @override
  State<BSEPage> createState() => _BSEPageState();
}

class _BSEPageState extends State<BSEPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List mainExchangeIdList = [];
  int selectedRadioIndex = -1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getLiveStatus();
    await getEx();
    await getWatchValues(text: '');
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "BSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController2.add(responseData["response"]);
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      //headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            mainExchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": mainExchangeIdList[2],
      "ticker_id": tickerId,
      "min_value": minValue,
      "max_value": maxvalue
    };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[2],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: height / 34.80,
                              width: width / 16.07,
                              margin: EdgeInsets.only(right: width / 16.44),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("lib/Constants/Assets/SMLogos/rupee.png")),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\u{20B9})',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\u{20B9})',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            //getWatchValues(newIndex: newIndex, excIndex: excIndex,countryIndex:countryIndex, text: text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 17.32),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'stocks',
                                                id: watchIdList[index],
                                                exchange: 'BSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          onDoubleTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'stocks',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                            /*await detailTickersFunc(
                                          tickerId:
                                          watchIdList[
                                          index],
                                          category:
                                          'stocks');
                                  detailedShowSheet(
                                          context:
                                          context,
                                          indusValue:
                                          true);*/
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'stocks',
                                                    id: watchIdList[index],
                                                    exchange: 'BSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              onDoubleTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'stocks',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: text.scale(10),
                                                              color: const Color(0xffB0B0B0),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.8,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("\u{20B9}",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: "Robonto")),
                                                          Text(watchCloseList[index].toStringAsFixed(2),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: text.scale(12),
                                                              )),
                                                        ],
                                                      ),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "bse",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'stocks',
                                                          exchange: 'BSE',
                                                          country: 'India',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[0].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[0].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset(
                    'lib/Constants/Assets/SMLogos/loading.json',
                    height: height / 8.66,
                    width: width / 4.11,
                  ),
                )
        ],
      ),
    );
  }
}

class USAIndexesPage extends StatefulWidget {
  const USAIndexesPage({Key? key}) : super(key: key);

  @override
  State<USAIndexesPage> createState() => _USAIndexesPageState();
}

class _USAIndexesPageState extends State<USAIndexesPage> {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List mainExchangeIdList = [];
  int selectedRadioIndex = -1;

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getLiveStatus();
    await getEx();
    await getWatchValues(text: '');
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "US",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController2.add(responseData["response"]);
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      // headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            mainExchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": mainExchangeIdList[0],
      "ticker_id": tickerId,
      "min_value": minValue,
      "max_value": maxvalue
    };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        loading = true;
        emptyList = false;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": "625e59ec49d900f6585bc694",
        "type": "US",
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: height / 34.80,
                            width: width / 16.07,
                            margin: EdgeInsets.only(right: width / 16.44),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/dollar_image.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\$)',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\$)',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            //getWatchValues(newIndex: newIndex, excIndex: excIndex,countryIndex:countryIndex, text: text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
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
    return SizedBox(
      height: height / 1.62,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overflow) {
          overflow.disallowIndicator();
          return true;
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              child: TextFormField(
                cursorColor: Colors.green,
                onChanged: (value) async {
                  setState(() {
                    loading = false;
                  });
                  await getWatchValues(text: value);
                },
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _searchController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: width / 27.4),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              _searchController.clear();
                            });
                            await getWatchValues(text: "");
                            if (!mounted) {
                              return;
                            }
                            FocusScope.of(context).unfocus();
                          },
                          child: const Icon(Icons.cancel, size: 22),
                        )
                      : const SizedBox(),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                  hintText: 'Search here',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 50.75,
            ),
            loading
                ? emptyList
                    ? Padding(
                        padding: EdgeInsets.only(top: height / 17.32),
                        child: const Center(child: Text("No search results found")),
                      )
                    : Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 25),
                          child: SmartRefresher(
                            controller: _refreshController,
                            enablePullDown: false,
                            enablePullUp: true,
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus? mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text("pull up to load");
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
                                  height: height / 14.76,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            onLoading: _onGetWatchLoading,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: watchTitleList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                      decoration: BoxDecoration(
                                          color: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                              ? Theme.of(context).colorScheme.tertiary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              /*mainVariables.selectedTickerId.value=watchIdList[index];
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return TickersDetailsPage(
                                                  category: 'stocks',
                                                  id: watchIdList[index],
                                                  exchange: 'US',
                                                  country: "USA",
                                                  name: watchTitleList[index],
                                                  fromWhere: 'add_watch',
                                                );
                                              }));
                                            },
                                            onDoubleTap: () async {
                                              /*mainVariables.selectedTickerId.value=watchIdList[index];
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return TickersDetailsPage(
                                                  category: 'stocks',
                                                  id: watchIdList[index],
                                                  exchange: 'US',
                                                  country: "USA",
                                                  name: watchTitleList[index],
                                                  fromWhere: 'add_watch',
                                                );
                                              }));
                                            },
                                            child: SizedBox(
                                              height: height / 33.83,
                                              width: width / 15.625,
                                              child: Image.network(
                                                watchLogoList[index],
                                                fit: BoxFit.fill,
                                                errorBuilder: (context, _, stack) {
                                                  return SvgPicture.network(watchLogoList[index]);
                                                },
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  // mainVariables.selectedTickerId.value=watchIdList[index];
                                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return TickersDetailsPage(
                                                      category: 'stocks',
                                                      id: watchIdList[index],
                                                      exchange: 'US',
                                                      country: "USA",
                                                      name: watchTitleList[index],
                                                      fromWhere: 'add_watch',
                                                    );
                                                  }));
                                                },
                                                onDoubleTap: () async {
                                                  // mainVariables.selectedTickerId.value=watchIdList[index];
                                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return TickersDetailsPage(
                                                      category: 'stocks',
                                                      id: watchIdList[index],
                                                      exchange: 'US',
                                                      country: "USA",
                                                      name: watchTitleList[index],
                                                      fromWhere: 'add_watch',
                                                    );
                                                  }));
                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: width / 34.25,
                                                    ),
                                                    SizedBox(
                                                      width: width / 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(watchTitleList[index],
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: text.scale(14),
                                                                  overflow: TextOverflow.ellipsis)),
                                                          Text(
                                                            watchSubTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(10),
                                                                color: const Color(0xffB0B0B0),
                                                                overflow: TextOverflow.ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 3.8,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("\$${watchCloseList[index].toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: text.scale(12),
                                                            )),
                                                        Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: text.scale(12),
                                                                color: watchStatusList[index] == "Increse"
                                                                    ? const Color(0xff0EA102)
                                                                    : const Color(0XFFFB1212))),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: width / 16.5),
                                              Radio<int>(
                                                  value: index,
                                                  groupValue: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                                      ? index
                                                      : selectedRadioIndex,
                                                  onChanged: (value) {
                                                    if (lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("This company already added in your favourites")));
                                                    } else {
                                                      ResponseCalculatorList data = ResponseCalculatorList(
                                                          name: "indx",
                                                          ticker: Ticker(
                                                            id: watchIdList[index],
                                                            imageUrl: watchLogoList[index],
                                                            name: watchTitleList[index],
                                                            category: 'stocks',
                                                            exchange: 'INDX',
                                                            country: 'USA',
                                                            code: watchSubTitleList[index],
                                                            close: watchCloseList[index],
                                                            value: (watchCloseList[index] == 0
                                                                    ? watchCloseList[index].toString()
                                                                    : (lockerVariables.isIndia.value
                                                                            ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                            : ((lockerVariables.purchaseValue.value *
                                                                                    lockerVariables.dollarValue.value) /
                                                                                watchCloseList[index]))
                                                                        .toStringAsFixed(2))
                                                                .obs,
                                                            fromWhere: 'calculator',
                                                          ));
                                                      lockerVariables.calculatorPageContents!.value.response[0].responseList.add(data);
                                                      setState(() {
                                                        selectedRadioIndex = value!;
                                                      });
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      lockerVariables.calculatorSelectedTickersList[0].add(watchIdList[index]);
                                                    }
                                                  }),
                                              SizedBox(width: width / 37.5),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      thickness: 0.8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                : Center(
                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                  ),
          ],
        ),
      ),
    );
  }
}

class USAPage extends StatefulWidget {
  const USAPage({Key? key}) : super(key: key);

  @override
  State<USAPage> createState() => _USAPageState();
}

class _USAPageState extends State<USAPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List mainExchangeIdList = [];
  int selectedRadioIndex = -1;

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getLiveStatus();
    await getEx();
    await getWatchValues(text: '');
  }

  getLiveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "US",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController2.add(responseData["response"]);
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      // headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      mainExchangeIdList.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            mainExchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": mainExchangeIdList[0],
      "ticker_id": tickerId,
      "min_value": minValue,
      "max_value": maxvalue
    };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        loading = true;
        emptyList = false;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "stocks",
        "category_id": mainCatIdList[0],
        "exchange_id": mainExchangeIdList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: height / 34.80,
                            width: width / 16.07,
                            margin: EdgeInsets.only(right: width / 16.44),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/dollar_image.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\$)',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\$)',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            //getWatchValues(newIndex: newIndex, excIndex: excIndex,countryIndex:countryIndex, text: text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
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
    return SizedBox(
      height: height / 1.62,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overflow) {
          overflow.disallowIndicator();
          return true;
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              child: TextFormField(
                cursorColor: Colors.green,
                onChanged: (value) async {
                  setState(() {
                    loading = false;
                  });
                  await getWatchValues(text: value);
                },
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _searchController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: width / 27.4),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              _searchController.clear();
                            });
                            await getWatchValues(text: "");
                            if (!mounted) {
                              return;
                            }
                            FocusScope.of(context).unfocus();
                          },
                          child: const Icon(Icons.cancel, size: 22),
                        )
                      : const SizedBox(),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                  hintText: 'Search here',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 50.75,
            ),
            loading
                ? emptyList
                    ? Padding(
                        padding: EdgeInsets.only(top: height / 17.32),
                        child: const Center(child: Text("No search results found")),
                      )
                    : Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 25),
                          child: SmartRefresher(
                            controller: _refreshController,
                            enablePullDown: false,
                            enablePullUp: true,
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus? mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text("pull up to load");
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
                                  height: height / 14.76,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            onLoading: _onGetWatchLoading,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: watchTitleList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                      decoration: BoxDecoration(
                                          color: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                              ? Theme.of(context).colorScheme.tertiary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              /*mainVariables.selectedTickerId.value=watchIdList[index];
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return TickersDetailsPage(
                                                  category: 'stocks',
                                                  id: watchIdList[index],
                                                  exchange: 'US',
                                                  country: "USA",
                                                  name: watchTitleList[index],
                                                  fromWhere: 'add_watch',
                                                );
                                              }));
                                            },
                                            onDoubleTap: () async {
                                              /*mainVariables.selectedTickerId.value=watchIdList[index];
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));*/
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return TickersDetailsPage(
                                                  category: 'stocks',
                                                  id: watchIdList[index],
                                                  exchange: 'US',
                                                  country: "USA",
                                                  name: watchTitleList[index],
                                                  fromWhere: 'add_watch',
                                                );
                                              }));
                                            },
                                            child: SizedBox(
                                              height: height / 33.83,
                                              width: width / 15.625,
                                              child: Image.network(
                                                watchLogoList[index],
                                                fit: BoxFit.fill,
                                                errorBuilder: (context, _, stack) {
                                                  return SvgPicture.network(watchLogoList[index]);
                                                },
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  // mainVariables.selectedTickerId.value=watchIdList[index];
                                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return TickersDetailsPage(
                                                      category: 'stocks',
                                                      id: watchIdList[index],
                                                      exchange: 'US',
                                                      country: "USA",
                                                      name: watchTitleList[index],
                                                      fromWhere: 'add_watch',
                                                    );
                                                  }));
                                                },
                                                onDoubleTap: () async {
                                                  // mainVariables.selectedTickerId.value=watchIdList[index];
                                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return TickersDetailsPage(
                                                      category: 'stocks',
                                                      id: watchIdList[index],
                                                      exchange: 'US',
                                                      country: "USA",
                                                      name: watchTitleList[index],
                                                      fromWhere: 'add_watch',
                                                    );
                                                  }));
                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: width / 34.25,
                                                    ),
                                                    SizedBox(
                                                      width: width / 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(watchTitleList[index],
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: text.scale(14),
                                                                  overflow: TextOverflow.ellipsis)),
                                                          Text(
                                                            watchSubTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(10),
                                                                color: const Color(0xffB0B0B0),
                                                                overflow: TextOverflow.ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 3.8,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("\$${watchCloseList[index].toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: text.scale(12),
                                                            )),
                                                        Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: text.scale(12),
                                                                color: watchStatusList[index] == "Increse"
                                                                    ? const Color(0xff0EA102)
                                                                    : const Color(0XFFFB1212))),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: width / 16.5),
                                              Radio<int>(
                                                  value: index,
                                                  groupValue: lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])
                                                      ? index
                                                      : selectedRadioIndex,
                                                  onChanged: (value) {
                                                    if (lockerVariables.calculatorSelectedTickersList[0].contains(watchIdList[index])) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("This company already added in your favourites")));
                                                    } else {
                                                      ResponseCalculatorList data = ResponseCalculatorList(
                                                          name: "usastocks",
                                                          ticker: Ticker(
                                                            id: watchIdList[index],
                                                            imageUrl: watchLogoList[index],
                                                            name: watchTitleList[index],
                                                            category: 'stocks',
                                                            exchange: 'USA',
                                                            country: 'USA',
                                                            code: watchSubTitleList[index],
                                                            close: watchCloseList[index],
                                                            value: (watchCloseList[index] == 0
                                                                    ? watchCloseList[index].toString()
                                                                    : (lockerVariables.isIndia.value
                                                                            ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                            : ((lockerVariables.purchaseValue.value *
                                                                                    lockerVariables.dollarValue.value) /
                                                                                watchCloseList[index]))
                                                                        .toStringAsFixed(2))
                                                                .obs,
                                                            fromWhere: 'calculator',
                                                          ));
                                                      lockerVariables.calculatorPageContents!.value.response[0].responseList.add(data);
                                                      setState(() {
                                                        selectedRadioIndex = value!;
                                                      });
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      lockerVariables.calculatorSelectedTickersList[0].add(watchIdList[index]);
                                                    }
                                                  }),
                                              SizedBox(width: width / 37.5),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      thickness: 0.8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                : Center(
                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                  ),
          ],
        ),
      ),
    );
  }
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  int selectedRadioIndex = -1;

  @override
  void dispose() {
    super.dispose();
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {"category_id": mainCatIdList[1], "ticker_id": tickerId, "min_value": minValue, "max_value": maxvalue};
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "crypto",
        "category_id": mainCatIdList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: height / 34.80,
                            width: width / 16.07,
                            margin: EdgeInsets.only(right: width / 16.44),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/dollar_image.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\$)',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\$)',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void initState() {
    streamController2.add(true);
    getWatchValues(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          SizedBox(
            height: height / 40.6,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 173.2),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[1].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'crypto',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          onDoubleTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'crypto',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'crypto',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              onDoubleTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'crypto',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: text.scale(10),
                                                              color: const Color(0xffB0B0B0),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.8,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("\$${watchCloseList[index].toStringAsFixed(2)}",
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(12))),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[1].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[1].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "coin",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'crypto',
                                                          exchange: 'COIN',
                                                          country: 'USA',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[1].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[1].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                )
        ],
      ),
    );
  }
}

class CommodityPage extends StatefulWidget {
  final int countryIndex;

  const CommodityPage({Key? key, required this.countryIndex}) : super(key: key);

  @override
  State<CommodityPage> createState() => _CommodityPageState();
}

class _CommodityPageState extends State<CommodityPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2, initialIndex: widget.countryIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / 50.75),
            child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
                labelColor: const Color(0XFF11AA04),
                indicatorColor: Colors.green,
                indicatorWeight: 2,
                labelPadding: EdgeInsets.only(right: width / 8.22),
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                dividerHeight: 0.0,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: false,
                onTap: (int newIndex) async {},
                tabs: [
                  Text(
                    "India",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                  ),
                  Text("USA", style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14))),
                ]),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const ScrollPhysics(),
              children: const [
                IndiaPage(),
                CommodityUSAPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IndiaPage extends StatefulWidget {
  const IndiaPage({Key? key}) : super(key: key);

  @override
  State<IndiaPage> createState() => _IndiaPageState();
}

class _IndiaPageState extends State<IndiaPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List<String> countryList = ["India", "USA"];
  int selectedRadioIndex = -1;

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {"category_id": mainCatIdList[2], "ticker_id": tickerId, "min_value": minValue, "max_value": maxvalue};
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[0],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: height / 34.80,
                              width: width / 16.07,
                              margin: EdgeInsets.only(right: width / 16.44),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("lib/Constants/Assets/SMLogos/rupee.png")),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\u{20B9})',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\u{20B9})',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            //getWatchValues(newIndex: newIndex, excIndex: excIndex,countryIndex:countryIndex, text: text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void initState() {
    streamController2.add(true);
    getWatchValues(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 17.32),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[2].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'commodity',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          onDoubleTap: () async {
                                            // mainVariables.selectedTickerId.value=watchIdList[index];
                                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return TickersDetailsPage(
                                                category: 'commodity',
                                                id: watchIdList[index],
                                                exchange: 'NSE',
                                                country: "India",
                                                name: watchTitleList[index],
                                                fromWhere: 'add_watch',
                                              );
                                            }));
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'commodity',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              onDoubleTap: () async {
                                                // mainVariables.selectedTickerId.value=watchIdList[index];
                                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return BusinessProfilePage();}));
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return TickersDetailsPage(
                                                    category: 'commodity',
                                                    id: watchIdList[index],
                                                    exchange: 'NSE',
                                                    country: "India",
                                                    name: watchTitleList[index],
                                                    fromWhere: 'add_watch',
                                                  );
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: text.scale(10),
                                                              color: const Color(0xffB0B0B0),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.8,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("\u{20B9}",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: "Robonto")),
                                                          Text(watchCloseList[index].toStringAsFixed(2),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: text.scale(12),
                                                              )),
                                                        ],
                                                      ),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[2].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[2].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "india",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'commodity',
                                                          exchange: 'India',
                                                          country: 'India',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[2].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[2].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                )
        ],
      ),
    );
  }
}

class CommodityUSAPage extends StatefulWidget {
  const CommodityUSAPage({Key? key}) : super(key: key);

  @override
  State<CommodityUSAPage> createState() => _CommodityUSAPageState();
}

class _CommodityUSAPageState extends State<CommodityUSAPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool loading = false;
  bool emptyList = false;
  List<String> countryList = ["India", "USA"];
  int selectedRadioIndex = -1;

  @override
  void dispose() {
    super.dispose();
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;

    if (selectedWatchListIndex == 1) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;
    if (selectedWatchListIndex == 1) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "commodity",
        "category_id": mainCatIdList[2],
        "country": countryList[1],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {"category_id": mainCatIdList[2], "ticker_id": tickerId, "min_value": minValue, "max_value": maxvalue};
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: height / 34.80,
                            width: width / 16.07,
                            margin: EdgeInsets.only(right: width / 16.44),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/dollar_image.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min(\$)',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max(\$)',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void initState() {
    streamController2.add(true);
    getWatchValues(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 17.32),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[2].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            mainVariables.selectedTickerId.value = watchIdList[index];
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BusinessProfilePage();
                                            }));
                                          },
                                          onDoubleTap: () async {
                                            mainVariables.selectedTickerId.value = watchIdList[index];
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BusinessProfilePage();
                                            }));
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                mainVariables.selectedTickerId.value = watchIdList[index];
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BusinessProfilePage();
                                                }));
                                                /*Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return TickersDetailsPage(
                                                      category: 'commodity',
                                                      id: watchIdList[index],
                                                      exchange: 'NSE',
                                                      country: "USA",
                                                      name: watchTitleList[index],fromWhere: 'add_watch',);
                                                }));*/
                                              },
                                              onDoubleTap: () async {
                                                mainVariables.selectedTickerId.value = watchIdList[index];
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BusinessProfilePage();
                                                }));
                                                /*Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return TickersDetailsPage(
                                                      category: 'commodity',
                                                      id: watchIdList[index],
                                                      exchange: 'NSE',
                                                      country: "USA",
                                                      name: watchTitleList[index],fromWhere: 'add_watch',);
                                                }));*/
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: text.scale(10),
                                                              color: const Color(0xffB0B0B0),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.8,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("\$${watchCloseList[index].toStringAsFixed(2)}",
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(12))),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[2].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[2].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "usa",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'commodity',
                                                          exchange: 'USA',
                                                          country: 'USA',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[2].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[2].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                )
        ],
      ),
    );
  }
}

class ForexPage extends StatefulWidget {
  const ForexPage({Key? key}) : super(key: key);

  @override
  State<ForexPage> createState() => _ForexPageState();
}

class _ForexPageState extends State<ForexPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String mainUserToken = "";
  int newInt = 0;
  List<String> watchIdList = [];
  List<String> watchTitleList = [];
  List<String> watchSubTitleList = [];
  List<String> watchLogoList = [];
  List<double> watchCloseList = [];
  List<double> watchPercentageList = [];
  List<bool> watchNotifyList = [];
  List<bool> watchStarList = [];
  List<String> watchStatusList = [];
  List<String> watchAddedIdList = [];
  List<String> watchNotifyAddedIdList = [];
  List<bool> watchNotifyAddedBoolList = [];
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool emptyList = false;
  bool loading = false;
  int selectedRadioIndex = -1;

  @override
  void dispose() {
    super.dispose();
  }

  getWatchValues({required String text}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;
    if (selectedWatchListIndex == 1) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": 0,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchIdList.clear();
      watchTitleList.clear();
      watchSubTitleList.clear();
      watchLogoList.clear();
      watchCloseList.clear();
      watchPercentageList.clear();
      watchNotifyList.clear();
      watchStarList.clear();
      watchStatusList.clear();
      watchAddedIdList.clear();
      watchNotifyAddedIdList.clear();
      watchNotifyAddedBoolList.clear();
      watchNotifyAddedBoolListMain.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        watchIdList.add(responseData["response"][i]["_id"]);
        watchTitleList.add(responseData["response"][i]["name"]);
        watchSubTitleList.add(responseData["response"][i]["code"]);
        watchLogoList.add(responseData["response"][i]["logo_url"]);
        watchCloseList.add((responseData["response"][i]["close"]).toDouble());
        watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
        watchNotifyList.add(responseData["response"][i]["notification"]);
        watchStarList.add(responseData["response"][i]["watchlist"]);
        watchStatusList.add(responseData["response"][i]["state"]);
        watchNotifyAddedBoolList.add(false);
        watchNotifyAddedBoolListMain.add(false);
        if (responseData["response"][i]["watch_list"].length != 0) {
          watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
        } else {
          watchAddedIdList.add("");
        }
        if (responseData["response"][i]["watchnotification"].length != 0) {
          watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
        } else {
          watchNotifyAddedIdList.add("");
        }
      }
      setState(() {
        emptyList = false;
        loading = true;
      });
    } else {
      setState(() {
        emptyList = true;
        loading = true;
      });
    }
  }

  void _onGetWatchLoading() async {
    String text = "";
    setState(() {
      newInt = newInt + 20;
      text = _searchController.text;
    });
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchTickers;
    if (selectedWatchListIndex == 1) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 2) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "close", 'type': 'asc'}
      };
    } else if (selectedWatchListIndex == 3) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'dsc'}
      };
    } else if (selectedWatchListIndex == 4) {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
        'sort': {"name": "change_p", 'type': 'asc'}
      };
    } else {
      data = {
        "category": "forex",
        "category_id": mainCatIdList[3],
        "skip": newInt,
        "search": text,
        "ticker_exist": false,
        'tickers': [],
      };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          watchIdList.add(responseData["response"][i]["_id"]);
          watchTitleList.add(responseData["response"][i]["name"]);
          watchSubTitleList.add(responseData["response"][i]["code"]);
          watchLogoList.add(responseData["response"][i]["logo_url"]);
          watchCloseList.add((responseData["response"][i]["close"]).toDouble());
          watchPercentageList.add((responseData["response"][i]["change_p"]).toDouble());
          watchNotifyList.add(responseData["response"][i]["notification"]);
          watchStarList.add(responseData["response"][i]["watchlist"]);
          watchStatusList.add(responseData["response"][i]["state"]);
          watchNotifyAddedBoolList.add(false);
          watchNotifyAddedBoolListMain.add(false);
          if (responseData["response"][i]["watch_list"].length != 0) {
            watchAddedIdList.add(responseData["response"][i]["watch_list"][0]["_id"]);
          } else {
            watchAddedIdList.add("");
          }
          if (responseData["response"][i]["watchnotification"].length != 0) {
            watchNotifyAddedIdList.add(responseData["response"][i]["watchnotification"][0]["_id"]);
          } else {
            watchNotifyAddedIdList.add("");
          }
        }
      });
    } else {}

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  removeWatchList({required String watchId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"watchlist_id": watchId, "ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  removeNotifyList({required String notifyId, required String tickerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response = await dioMain
        .post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  Future<dynamic> notifyBottomSheet({
    required BuildContext context,
    required String tickerId,
    required String tickerName,
    required bool bellStatus,
    required String text,
    required int currentIndex,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 54.13,
                      ),
                      Center(
                        child: Text(
                          bellStatus ? "Turn Off Notification" : "Turn On Notification",
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width / 41.1),
                        child: Text('You will be notified when the price of $tickerName will cross the threshold points the you will enter below.',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                      ),
                      SizedBox(height: height / 50.75),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: _height / 34.80,
                            width: _width / 16.07,
                            margin: EdgeInsets.only(right: _width/16.44),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/dollar_image.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),*/
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Min',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 101.5),
                      SizedBox(
                        height: height / 14.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: width / 27.4),
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
                            labelText: 'Max',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 32.48,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (double.parse(_maxController.text) < double.parse(_minController.text)) {
                            Flushbar(
                              message: "Max value must greater than min value",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              //loading3 = false;
                              watchNotifyAddedBoolList[currentIndex] = true;
                            });
                            await addNotifyList(tickerId: tickerId, minValue: _minController.text, maxvalue: _maxController.text);
                            _minController.clear();
                            _maxController.clear();
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
                              "Turn On",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  addNotifyList({
    required String tickerId,
    required String minValue,
    required String maxvalue,
  }) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAddNotify;
    data = {"category_id": mainCatIdList[3], "ticker_id": tickerId, "min_value": minValue, "max_value": maxvalue};
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
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
    streamController2.add(true);
    getWatchValues(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overflow) {
        overflow.disallowIndicator();
        return true;
      },
      child: Column(
        children: [
          SizedBox(
            height: height / 40.6,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: TextFormField(
              cursorColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  loading = false;
                });
                await getWatchValues(text: value);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: EdgeInsets.only(left: width / 27.4),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _searchController.clear();
                          });
                          await getWatchValues(text: "");
                          if (!mounted) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(Icons.cancel, size: 22),
                      )
                    : const SizedBox(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 50.75,
          ),
          loading
              ? emptyList
                  ? Padding(
                      padding: EdgeInsets.only(top: height / 17.32),
                      child: const Center(child: Text("No search results found")),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 25),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text("pull up to load");
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
                                height: height / 14.76,
                                child: Center(child: body),
                              );
                            },
                          ),
                          onLoading: _onGetWatchLoading,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: watchTitleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 82.2),
                                    decoration: BoxDecoration(
                                        color: lockerVariables.calculatorSelectedTickersList[3].contains(watchIdList[index])
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            mainVariables.selectedTickerId.value = watchIdList[index];
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BusinessProfilePage();
                                            }));
                                            /*Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  return TickersDetailsPage(
                                                      category: 'forex',
                                                      id: watchIdList[index],
                                                      exchange: 'NSE',
                                                      country: "India",
                                                      name: watchTitleList[index],fromWhere: 'add_watch',);
                                                }));*/
                                          },
                                          onDoubleTap: () async {
                                            mainVariables.selectedTickerId.value = watchIdList[index];
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return const BusinessProfilePage();
                                            }));
                                            /*Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  return TickersDetailsPage(
                                                      category: 'forex',
                                                      id: watchIdList[index],
                                                      exchange: 'NSE',
                                                      country: "India",
                                                      name: watchTitleList[index],fromWhere: 'add_watch',);
                                                }));*/
                                          },
                                          child: SizedBox(
                                            height: height / 33.83,
                                            width: width / 15.625,
                                            child: Image.network(
                                              watchLogoList[index],
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, _, stack) {
                                                return SvgPicture.network(watchLogoList[index]);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                mainVariables.selectedTickerId.value = watchIdList[index];
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BusinessProfilePage();
                                                }));
                                                /*Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return TickersDetailsPage(
                                                      category: 'forex',
                                                      id: watchIdList[index],
                                                      exchange: 'NSE',
                                                      country: "India",
                                                      name: watchTitleList[index],fromWhere: 'add_watch',);
                                                }));*/
                                              },
                                              onDoubleTap: () async {
                                                mainVariables.selectedTickerId.value = watchIdList[index];
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const BusinessProfilePage();
                                                }));
                                                /*Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return TickersDetailsPage(
                                                      category: 'forex',
                                                      id: watchIdList[index],
                                                      exchange: 'NSE',
                                                      country: "India",
                                                      name: watchTitleList[index],fromWhere: 'add_watch',);
                                                }));*/
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 34.25,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(watchTitleList[index],
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: text.scale(14),
                                                                overflow: TextOverflow.ellipsis)),
                                                        Text(
                                                          watchSubTitleList[index],
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: text.scale(10),
                                                              color: const Color(0xffB0B0B0),
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.8,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(watchCloseList[index].toStringAsFixed(2),
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(12))),
                                                      Text("${watchPercentageList[index].toStringAsFixed(2)}%",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: text.scale(12),
                                                              color: watchStatusList[index] == "Increse"
                                                                  ? const Color(0xff0EA102)
                                                                  : const Color(0XFFFB1212))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width / 16.5),
                                            Radio<int>(
                                                value: index,
                                                groupValue: lockerVariables.calculatorSelectedTickersList[3].contains(watchIdList[index])
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.calculatorSelectedTickersList[3].contains(watchIdList[index])) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    ResponseCalculatorList data = ResponseCalculatorList(
                                                        name: "inrusd",
                                                        ticker: Ticker(
                                                          id: watchIdList[index],
                                                          imageUrl: watchLogoList[index],
                                                          name: watchTitleList[index],
                                                          category: 'forex',
                                                          exchange: 'Forex',
                                                          country: 'USA',
                                                          code: watchSubTitleList[index],
                                                          close: watchCloseList[index],
                                                          value: (watchCloseList[index] == 0
                                                                  ? watchCloseList[index].toString()
                                                                  : (lockerVariables.isIndia.value
                                                                          ? (lockerVariables.purchaseValue.value / watchCloseList[index])
                                                                          : ((lockerVariables.purchaseValue.value *
                                                                                  lockerVariables.dollarValue.value) /
                                                                              watchCloseList[index]))
                                                                      .toStringAsFixed(2))
                                                              .obs,
                                                          fromWhere: 'calculator',
                                                        ));
                                                    lockerVariables.calculatorPageContents!.value.response[3].responseList.add(data);
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.calculatorSelectedTickersList[3].add(watchIdList[index]);
                                                  }
                                                }),
                                            SizedBox(width: width / 37.5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                )
        ],
      ),
    );
  }
}
