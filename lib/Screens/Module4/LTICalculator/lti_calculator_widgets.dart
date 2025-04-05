import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/WatchList/add_watch_list_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';

import 'LTIPageModel/lti_page_initial_model.dart';

class LTICalculatorWidgets {
  tickersBottomSheet({
    required BuildContext context,
    required int superIndex,
    required StateSetter modelSetState,
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
          return TickersListLongTermBottomSheet(
            superIndex: superIndex,
            modelSetState: modelSetState,
          );
        });
  }

  splitsBottomSheet({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RxList<SplitsList> splits = RxList<SplitsList>([]);
    splits.addAll(lockerVariables.longTermInitialData!.value.splitsList.reversed);
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
          return Container(
            height: height / 1.732,
            margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Splits", style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: Colors.black)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ))
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: height / 57.73,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text("Split Date", style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.black))),
                    SizedBox(
                      width: width / 27.4,
                    ),
                    Expanded(child: Text("Shares", style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.black))),
                  ],
                ),
                SizedBox(
                  height: height / 57.73,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: splits.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: height / 108.25),
                        margin: EdgeInsets.symmetric(vertical: height / 108.25),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: width / 51.375),
                                child: Text(DateFormat("dd/MM/yyyy").format(splits[index].splitDate.value),
                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black)),
                              )),
                              SizedBox(
                                width: width / 27.4,
                                child: const VerticalDivider(
                                  thickness: 1.5,
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("New shares: ${splits[index].newShares}",
                                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black)),
                                  Text("Old shares: ${splits[index].oldShares}",
                                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  dividendsBottomSheet({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RxList<DividendList> dividends = RxList<DividendList>([]);
    dividends.addAll(lockerVariables.longTermInitialData!.value.dividendList.reversed);
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
          return Container(
            height: height / 1.732,
            margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Dividends", style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: Colors.black)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ))
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: height / 57.73,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text("Dividend Date", style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.black))),
                    SizedBox(
                      width: width / 27.4,
                    ),
                    Expanded(
                        child: Text("DividendValue / Shares",
                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.black))),
                  ],
                ),
                SizedBox(
                  height: height / 57.73,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: dividends.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: height / 108.25),
                        margin: EdgeInsets.symmetric(vertical: height / 108.25),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: width / 51.375),
                                child: Text(DateFormat("dd/MM/yyyy").format(dividends[index].date.value),
                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black)),
                              )),
                              SizedBox(
                                width: width / 27.4,
                                child: const VerticalDivider(
                                  thickness: 1.5,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                      "Div - ${lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value == "India" ? "\u{20B9}" : "\$"} ${dividends[index].value}/share",
                                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  /* Future showCalenderAlertDialog({
    required BuildContext context,
    required StateSetter modelSetState,
  }) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: Theme.of(context).colorScheme.background,
            content: SizedBox(
              height: height / 2.75,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:height/3.25,
                    child:SfDateRangePicker(
                      onSelectionChanged: (args) async {
                        if (args.value is DateTime) {
                          Navigator.pop(context);
                          lockerVariables.longTermInitialData!.value.selectedDate.value = args.value;
                          longTermFunctions.longTermInitialDataFunction(modelSetState: modelSetState);
                        }
                      },
                      toggleDaySelection: true,
                      showNavigationArrow: true,
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialDisplayDate: lockerVariables.longTermInitialData!.value.selectedDate.value,
                      initialSelectedDate: lockerVariables.longTermInitialData!.value.selectedDate.value,
                      minDate: DateTime.now().subtract(const Duration(days: 1825)),
                      maxDate: DateTime.now(),
                      headerHeight: 50,
                      backgroundColor: Colors.transparent,
                      headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.w600,
                          fontSize: text.scale(14),
                        ),
                      ),
                      view: DateRangePickerView.month,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (value) {
                        Navigator.pop(context);
                      },
                      showTodayButton: false,
                      monthFormat: "MMMM",
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        dayFormat: "EE",
                        viewHeaderHeight: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 35,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("save")))),
                ],
              ),
            ),
          );
        });
  }*/

  Future showCalenderAlertDialog({
    required BuildContext context,
    required StateSetter modelSetState,
  }) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: width / 27.32),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(15), boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                spreadRadius: 1.0,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
              )
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height / 57.73,
                ),
                const Row(
                  children: [
                    Text(
                      "Select date & Save",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 57.73,
                ),
                SfCalendar(
                  view: CalendarView.month,
                  showNavigationArrow: true,
                  initialDisplayDate: lockerVariables.longTermInitialData!.value.selectedDate.value,
                  initialSelectedDate: lockerVariables.longTermInitialData!.value.selectedDate.value,
                  minDate: DateTime.now().subtract(const Duration(days: 1825)),
                  maxDate: DateTime.now(),
                  headerHeight: 50,
                  backgroundColor: Colors.transparent,
                  cellBorderColor: Colors.transparent,
                  selectionDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green.withOpacity(0.4),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  monthViewSettings: const MonthViewSettings(
                    dayFormat: "EEE",
                    showTrailingAndLeadingDates: true,
                  ),
                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  showDatePickerButton: true,
                  onSelectionChanged: (value) {
                    lockerVariables.longTermInitialData!.value.selectedDate = (value.date ?? DateTime.now()).obs;
                    longTermFunctions.longTermInitialDataFunction(modelSetState: modelSetState);
                  },
                ),
                SizedBox(
                  height: height / 51.375,
                ),
                SizedBox(
                  height: 35,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("save"),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 51.375,
                ),
              ],
            ),
          );
        });
  }

  categoriesBottomSheet({required BuildContext context, required StateSetter modelSetState}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height / 57.73,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            lockerVariables.longTermCategory.value.text =
                                lockerVariables.longTermInitialData!.value.category.value = lockerVariables.categoriesList[index];
                            lockerVariables.longTermSelectedCategoryIndex.value = index;
                            if (index == 0) {
                              lockerVariables.longTermInitialData!.value.tickerId.value = "626787088bbdb6e89bb6815d";
                              lockerVariables.longTermInitialData!.value.tickerName.value = "MRF Limited";
                              longTermFunctions.longTermInitialDataFunction(modelSetState: modelSetState);
                            } else if (index == 1) {
                              lockerVariables.longTermInitialData!.value.tickerId.value = "626792ff571e2b2b72048855";
                              lockerVariables.longTermInitialData!.value.tickerName.value = "Bitcoin";
                              longTermFunctions.longTermInitialDataFunction(modelSetState: modelSetState);
                            } else if (index == 2) {
                              lockerVariables.longTermInitialData!.value.tickerId.value = "62678b59046ce7527909158b";
                              lockerVariables.longTermInitialData!.value.tickerName.value = "Gold Petal (MCX)";
                              longTermFunctions.longTermInitialDataFunction(modelSetState: modelSetState);
                            } else if (index == 3) {
                              lockerVariables.longTermInitialData!.value.tickerId.value = "62679b3b41b7862c69a579b7";
                              lockerVariables.longTermInitialData!.value.tickerName.value = "Indian Rupee/US Dollar FX Cross Rate";
                              longTermFunctions.longTermInitialDataFunction(modelSetState: modelSetState);
                            } else {}
                          },
                          minLeadingWidth: width / 25,
                          leading: SizedBox(
                              height: height / 34.64,
                              width: width / 16.44,
                              child: lockerVariables.categoriesImagesList[index].contains(".png")
                                  ? Image.asset(
                                      lockerVariables.categoriesImagesList[index],
                                      fit: BoxFit.fill,
                                    )
                                  : SvgPicture.asset(
                                      lockerVariables.categoriesImagesList[index],
                                      fit: BoxFit.fill,
                                    )),
                          title: Text(
                            lockerVariables.categoriesList[index],
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                          ),
                        ),
                        const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

class TickersListLongTermBottomSheet extends StatefulWidget {
  final int superIndex;
  final StateSetter modelSetState;

  const TickersListLongTermBottomSheet({Key? key, required this.superIndex, required this.modelSetState}) : super(key: key);

  @override
  State<TickersListLongTermBottomSheet> createState() => _TickersListLongTermBottomSheetState();
}

class _TickersListLongTermBottomSheetState extends State<TickersListLongTermBottomSheet> {
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
              Expanded(
                child: StocksLongTermPage(
                  excIndex: 1,
                  modelSetState: widget.modelSetState,
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
              Expanded(
                child: CryptoLongTermPage(
                  modelSetState: widget.modelSetState,
                ),
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
              Expanded(
                child: CommodityLongTermPage(
                  countryIndex: 0,
                  modelSetState: widget.modelSetState,
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
              Expanded(
                child: ForexLongTermPage(
                  modelSetState: widget.modelSetState,
                ),
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

class StocksLongTermPage extends StatefulWidget {
  final int excIndex;
  final StateSetter modelSetState;

  const StocksLongTermPage({Key? key, required this.excIndex, required this.modelSetState}) : super(key: key);

  @override
  State<StocksLongTermPage> createState() => _StocksLongTermPageState();
}

class _StocksLongTermPageState extends State<StocksLongTermPage> with TickerProviderStateMixin, WidgetsBindingObserver {
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
                  labelPadding: const EdgeInsets.only(right: 35, left: 15),
                  indicatorColor: const Color(0XFF0EA102),
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  dividerHeight: 0.0,
                  splashFactory: NoSplash.splashFactory,
                  indicatorWeight: 2,
                  tabs: [
                    Text(
                      "Indian Indexes",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "NSE India",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "BSE India",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "USA Indexes",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "USA Stocks",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ]),
            ),
          ),
          SizedBox(height: height / 57.73),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const ScrollPhysics(),
              children: [
                IndianIndexesLongTermPage(
                  modelSetState: widget.modelSetState,
                ),
                NSELongTermPage(
                  modelSetState: widget.modelSetState,
                ),
                BSELongTermPage(
                  modelSetState: widget.modelSetState,
                ),
                USAIndexesLongTermPage(
                  modelSetState: widget.modelSetState,
                ),
                USALongTermPage(
                  modelSetState: widget.modelSetState,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IndianIndexesLongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const IndianIndexesLongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<IndianIndexesLongTermPage> createState() => _IndianIndexesLongTermPageState();
}

class _IndianIndexesLongTermPageState extends State<IndianIndexesLongTermPage> {
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
        return false;
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                    lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                    longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class NSELongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const NSELongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<NSELongTermPage> createState() => _NSELongTermPageState();
}

class _NSELongTermPageState extends State<NSELongTermPage> with WidgetsBindingObserver {
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                    lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                    longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class BSELongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const BSELongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<BSELongTermPage> createState() => _BSELongTermPageState();
}

class _BSELongTermPageState extends State<BSELongTermPage> with WidgetsBindingObserver {
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                              groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                  ? index
                                                  : selectedRadioIndex,
                                              onChanged: (value) {
                                                if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                } else {
                                                  setState(() {
                                                    selectedRadioIndex = value!;
                                                  });
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.pop(context);
                                                  lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                  lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                  longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
                                                }
                                              },
                                            ),
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

class USAIndexesLongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const USAIndexesLongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<USAIndexesLongTermPage> createState() => _USAIndexesLongTermPageState();
}

class _USAIndexesLongTermPageState extends State<USAIndexesLongTermPage> {
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
                        padding: EdgeInsets.only(left: width / 27.4),
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
                                          color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                  exchange: 'US',
                                                  country: "USA",
                                                  name: watchTitleList[index],
                                                  fromWhere: 'add_watch',
                                                );
                                              }));
                                            },
                                            onDoubleTap: () async {
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
                                                  groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                      ? index
                                                      : selectedRadioIndex,
                                                  onChanged: (value) {
                                                    if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("This company already added in your favourites")));
                                                    } else {
                                                      setState(() {
                                                        selectedRadioIndex = value!;
                                                      });
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                      lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                      longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class USALongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const USALongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<USALongTermPage> createState() => _USALongTermPageState();
}

class _USALongTermPageState extends State<USALongTermPage> with WidgetsBindingObserver {
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
                                          color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                              ? Colors.grey.shade200
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
                                                  groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                      ? index
                                                      : selectedRadioIndex,
                                                  onChanged: (value) {
                                                    if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("This company already added in your favourites")));
                                                    } else {
                                                      setState(() {
                                                        selectedRadioIndex = value!;
                                                      });
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                      lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                      longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class CryptoLongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const CryptoLongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<CryptoLongTermPage> createState() => _CryptoLongTermPageState();
}

class _CryptoLongTermPageState extends State<CryptoLongTermPage> with WidgetsBindingObserver {
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
                      padding: EdgeInsets.only(top: height / 17.32),
                      child: const Center(
                        child: Text("No search results found"),
                      ),
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                    lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                    longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class CommodityLongTermPage extends StatefulWidget {
  final int countryIndex;
  final StateSetter modelSetState;

  const CommodityLongTermPage({Key? key, required this.countryIndex, required this.modelSetState}) : super(key: key);

  @override
  State<CommodityLongTermPage> createState() => _CommodityLongTermPageState();
}

class _CommodityLongTermPageState extends State<CommodityLongTermPage> with TickerProviderStateMixin, WidgetsBindingObserver {
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
    TextScaler text = MediaQuery.of(context).textScaler;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / 50.75),
            child: TabBar(
                isScrollable: false,
                indicatorWeight: 2,
                controller: _tabController,
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.green,
                dividerColor: Colors.transparent,
                dividerHeight: 0.0,
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
              children: [
                IndiaLongTermPage(
                  modelSetState: widget.modelSetState,
                ),
                CommodityLongTermUSAPage(
                  modelSetState: widget.modelSetState,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IndiaLongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const IndiaLongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<IndiaLongTermPage> createState() => _IndiaLongTermPageState();
}

class _IndiaLongTermPageState extends State<IndiaLongTermPage> with WidgetsBindingObserver {
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
                        padding: EdgeInsets.only(left: width / 27.4),
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
                        child: const Icon(Icons.cancel, size: 22, color: Colors.black),
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                    lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                    longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class CommodityLongTermUSAPage extends StatefulWidget {
  final StateSetter modelSetState;

  const CommodityLongTermUSAPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<CommodityLongTermUSAPage> createState() => _CommodityLongTermUSAPageState();
}

class _CommodityLongTermUSAPageState extends State<CommodityLongTermUSAPage> with WidgetsBindingObserver {
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

/*  Future<bool> addWatchList({required String tickerId}) async {
    Map<String, dynamic> data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionWatch + watchListAdd;
    data = {
      "category_id": mainCatIdList[2],
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                    lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                    longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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

class ForexLongTermPage extends StatefulWidget {
  final StateSetter modelSetState;

  const ForexLongTermPage({Key? key, required this.modelSetState}) : super(key: key);

  @override
  State<ForexLongTermPage> createState() => _ForexLongTermPageState();
}

class _ForexLongTermPageState extends State<ForexLongTermPage> with WidgetsBindingObserver {
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
                                        color: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
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
                                                groupValue: lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]
                                                    ? index
                                                    : selectedRadioIndex,
                                                onChanged: (value) {
                                                  if (lockerVariables.longTermInitialData!.value.tickerId.value == watchIdList[index]) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(content: Text("This company already added in your favourites")));
                                                  } else {
                                                    setState(() {
                                                      selectedRadioIndex = value!;
                                                    });
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                    lockerVariables.longTermInitialData!.value.tickerId.value = watchIdList[index];
                                                    lockerVariables.longTermInitialData!.value.tickerName.value = watchTitleList[index];
                                                    longTermFunctions.longTermInitialDataFunction(modelSetState: widget.modelSetState);
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
