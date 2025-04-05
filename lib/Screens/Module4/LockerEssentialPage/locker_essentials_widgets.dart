import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class LockerEssentialsWidgetsPage {
  Future<dynamic> filterBottomSheet({
    required BuildContext context,
    required String title,
    required StateSetter modelSetState,
  }) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return FilterBottomSheetPage(
            title: title,
            modelSetState: modelSetState,
          );
        });
  }

/*  Future showCalenderAlertDialog({
    required BuildContext context,
    required String title,
    required StateSetter modelSetState,
  }) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: height / 2.40,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          // callFunction();
                        },
                        icon: const Icon(Icons.clear, size: 24, color: Color(0xff000000)),
                      ),
                    ],
                  ),
                  SfDateRangePicker(
                    onSelectionChanged: (args) async {
                      if (args.value is DateTime) {
                        Navigator.pop(context);
                        lockerVariables.selectedDateTime.value = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(args.value);
                        await lockerEssentialApiFunctions.lockerEssentialData(
                            context: context, skipCount: "0", title: title, modelSetState: modelSetState);
                      }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialDisplayDate: DateTime.now(),
                    initialSelectedDate: DateTime.parse(lockerVariables.selectedDateTime.value),
                    backgroundColor: Colors.white,
                    toggleDaySelection: true,
                    showNavigationArrow: true,
                    headerHeight: 50,
                    headerStyle: const DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        backgroundColor: Color(0XFF0EA102),
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
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
                    view: DateRangePickerView.month,
                  ),
                ],
              ),
            ),
          );
        });
  }*/

  Future showCalenderAlertDialog({
    required BuildContext context,
    required String title,
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

  Future<dynamic> sortBottomSheet({
    required BuildContext context,
    required String title,
    required StateSetter modelSetState,
  }) {
    return showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SortBottomSheetPage(
            title: title,
            modelSetState: modelSetState,
          );
        });
  }

  Future<dynamic> extensionTableBottomSheet({
    required BuildContext context,
    required String year,
    required String industry,
    required String tickerId,
    required String dividendId,
    required String name,
    required String code,
    required String logoUrl,
    required StateSetter modelSetState,
  }) {
    return showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return ExtensionTableBottomSheet(
            year: year,
            modelSetState: modelSetState,
            tickerId: tickerId,
            industry: industry,
            dividendId: dividendId,
            name: name,
            code: code,
            logoUrl: logoUrl,
          );
        });
  }
}

class FilterBottomSheetPage extends StatefulWidget {
  final String title;
  final StateSetter modelSetState;

  const FilterBottomSheetPage({
    Key? key,
    required this.title,
    required this.modelSetState,
  }) : super(key: key);

  @override
  State<FilterBottomSheetPage> createState() => _FilterBottomSheetPageState();
}

class _FilterBottomSheetPageState extends State<FilterBottomSheetPage> {
  int selectedCategory = 0;
  bool loader = false;
  Rx<bool> loaderList = false.obs;
  int skipCount = 0;
  List<String> tempIdList = [];

  @override
  void initState() {
    lockerVariables.industriesListMain.clear();
    selectedCategory = lockerVariables.selectedCategory.value == 'general'
        ? 0
        : lockerVariables.selectedCategory.value == 'nse'
            ? 1
            : lockerVariables.selectedCategory.value == 'bse'
                ? 2
                : 3;
    tempIdList.clear();
    tempIdList.addAll(lockerVariables.selectedIndustriesListMain);
    getData(skipCount: '0');
    super.initState();
  }

  getData({required String skipCount}) async {
    await lockerEssentialApiFunctions.getIndustries(skipCount: skipCount);
    loaderList.value = true;
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refreshControl = RefreshController();
    return Container(
      height: height / 1.23,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter",
                style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
              ),
              IconButton(
                  onPressed: () {
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                    lockerVariables.selectedIndustriesListMain.clear();
                    lockerVariables.selectedIndustriesListMain.addAll(tempIdList);
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
          SizedBox(height: height / 57.73),
          Text('Categories', style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14))),
          SizedBox(height: height / 57.73),
          SizedBox(
            height: height / 14.43,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 0,
                    groupValue: selectedCategory,
                    onChanged: (int? value) {
                      setState(() {
                        selectedCategory = value ?? 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("All"),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 1,
                    groupValue: selectedCategory,
                    onChanged: (int? value) {
                      setState(() {
                        selectedCategory = value ?? 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("NSE"),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 2,
                    groupValue: selectedCategory,
                    onChanged: (int? value) {
                      setState(() {
                        selectedCategory = value ?? 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("BSE"),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 3,
                    groupValue: selectedCategory,
                    onChanged: (int? value) {
                      setState(() {
                        selectedCategory = value ?? 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("USA"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height / 57.73),
          Text('Industries', style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14))),
          SizedBox(height: height / 57.73),
          SizedBox(
            height: height / 14.5,
            width: width,
            child: TextFormField(
              style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
              controller: lockerVariables.searchIndustriesBottomSheetControllerMain.value,
              onChanged: (value) async {
                if (value.isEmpty || value.isEmpty) {
                  lockerVariables.searchIndustriesBottomSheetControllerMain.refresh();
                  await lockerEssentialApiFunctions.getIndustries(skipCount: '0');
                } else {
                  String previousValue = value;
                  lockerVariables.searchIndustriesBottomSheetControllerMain.refresh();
                  Timer(const Duration(seconds: 1), () async {
                    if (previousValue == lockerVariables.searchIndustriesBottomSheetControllerMain.value.text) {
                      await lockerEssentialApiFunctions.getIndustries(skipCount: '0');
                    }
                  });
                }
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: lockerVariables.searchIndustriesBottomSheetControllerMain.value.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          lockerVariables.searchIndustriesBottomSheetControllerMain.value.clear();
                          lockerVariables.searchIndustriesBottomSheetControllerMain.refresh();
                          getData(skipCount: '0');
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        child: Icon(Icons.cancel,
                            size: 22,
                            color:
                                lockerVariables.searchIndustriesBottomSheetControllerMain.value.text.isEmpty ? Colors.grey.shade300 : Colors.black),
                      )
                    : const SizedBox(),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                contentPadding: EdgeInsets.only(left: width / 27.4),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.w400, fontFamily: "Robonto"),
                labelText: 'search here',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Obx(
            () => loaderList.value
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 2.24,
                            child: loader
                                ? SmartRefresher(
                                    controller: refreshControl,
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
                                          height: height / 15.74,
                                          child: Center(child: body),
                                        );
                                      },
                                    ),
                                    onLoading: () async {
                                      skipCount = skipCount + 20;
                                      await lockerEssentialApiFunctions.getIndustries(skipCount: skipCount.toString());
                                      setState(() {});
                                      refreshControl.loadComplete();
                                    },
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const ScrollPhysics(),
                                        itemCount: lockerVariables.industriesListMain.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Obx(() => CheckboxListTile(
                                                value: lockerVariables.industriesListMain[index].isChecked,
                                                onChanged: (bool? value) {
                                                  if (value!) {
                                                    lockerVariables.industriesListMain[index].isChecked = value;
                                                    lockerVariables.selectedIndustriesListMain.add(lockerVariables.industriesListMain[index].id);
                                                  } else {
                                                    lockerVariables.industriesListMain[index].isChecked = value;
                                                    for (int i = 0; i < lockerVariables.selectedIndustriesListMain.length; i++) {
                                                      if (lockerVariables.selectedIndustriesListMain
                                                          .contains(lockerVariables.industriesListMain[index].id)) {
                                                        lockerVariables.selectedIndustriesListMain.removeAt(i);
                                                      }
                                                    }
                                                  }
                                                  setState(() {});
                                                },
                                                activeColor: Colors.green,
                                                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                controlAffinity: ListTileControlAffinity.trailing,
                                                title: Text(lockerVariables.industriesListMain[index].name),
                                              ));
                                        }),
                                  )
                                : Column(
                                    children: [
                                      Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: height / 28.86,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 28.86,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context);
                                  lockerVariables.selectedIndustriesListMain.clear();
                                  lockerVariables.selectedIndustriesListMain.addAll(tempIdList);
                                  lockerVariables.searchIndustriesBottomSheetControllerMain.value.clear();
                                },
                                child: const Text("Cancel")),
                            ElevatedButton(
                                onPressed: () async {
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context);
                                  lockerVariables.selectedCategory.value = selectedCategory == 0
                                      ? "general"
                                      : selectedCategory == 1
                                          ? "nse"
                                          : selectedCategory == 2
                                              ? "bse"
                                              : selectedCategory == 3
                                                  ? "usa"
                                                  : "general";
                                  /* for (var items
                                      in lockerVariables.industriesListMain) {
                                    if (items.isChecked == true) {
                                      lockerVariables.selectedIndustriesListMain.add(items.id);
                                    }
                                  }*/
                                  await lockerEssentialApiFunctions.lockerEssentialData(
                                      context: context, skipCount: '0', title: widget.title, modelSetState: widget.modelSetState);
                                  lockerVariables.searchIndustriesBottomSheetControllerMain.value.clear();
                                },
                                child: const Text("Save")),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                  ),
          ),
        ],
      ),
    );
  }
}

class SortBottomSheetPage extends StatefulWidget {
  final String title;
  final StateSetter modelSetState;

  const SortBottomSheetPage({Key? key, required this.title, required this.modelSetState}) : super(key: key);

  @override
  State<SortBottomSheetPage> createState() => _SortBottomSheetPageState();
}

class _SortBottomSheetPageState extends State<SortBottomSheetPage> {
  int selectedIndex = 0;

  @override
  void initState() {
    for (int i = 0; i < lockerVariables.sortListMain.length; i++) {
      if (lockerVariables.sortListMain[i] == lockerVariables.selectedSortValue["field"] && lockerVariables.selectedSortValue["value"] == -1) {
        selectedIndex = i + lockerVariables.sortListMain.length;
      } else if (lockerVariables.sortListMain[i] == lockerVariables.selectedSortValue["field"] && lockerVariables.selectedSortValue["value"] == 1) {
        selectedIndex = i;
      } else {}
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            height: height / 24.74,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sort",
                  style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                ),
                IconButton(
                    onPressed: () {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear))
              ],
            ),
          ),
          SizedBox(height: height / 57.73),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                itemCount: lockerVariables.sortListMain.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: height / 21.65,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: height / 11.54,
                                width: width / 2.5,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [Text(lockerVariables.sortListMain[index].toString().capitalizeFirst!)])),
                            Expanded(
                                child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: index,
                              groupValue: selectedIndex,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedIndex = value!;
                                });
                              },
                              title: Text(
                                "asc",
                                style: TextStyle(fontSize: text.scale(10)),
                              ),
                            )),
                            Expanded(
                                child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              value: index + lockerVariables.sortListMain.length,
                              groupValue: selectedIndex,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedIndex = value!;
                                });
                              },
                              title: Text(
                                "desc",
                                style: TextStyle(fontSize: text.scale(10)),
                              ),
                            )),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }),
          ),
          SizedBox(
            height: height / 24.74,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      int newSelectedIndex =
                          selectedIndex < lockerVariables.sortListMain.length ? selectedIndex : selectedIndex - lockerVariables.sortListMain.length;
                      lockerVariables.selectedSortValue = {
                        "field": lockerVariables.sortListMain[newSelectedIndex],
                        "value": selectedIndex < lockerVariables.sortListMain.length ? 1 : -1
                      }.obs;
                      await lockerEssentialApiFunctions.lockerEssentialData(
                          context: context, skipCount: "0", modelSetState: widget.modelSetState, title: widget.title);
                    },
                    child: const Text("Save")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExtensionTableBottomSheet extends StatefulWidget {
  final String year;
  final String tickerId;
  final String industry;
  final String dividendId;
  final String name;
  final String code;
  final String logoUrl;
  final StateSetter modelSetState;

  const ExtensionTableBottomSheet(
      {Key? key,
      required this.year,
      required this.tickerId,
      required this.industry,
      required this.dividendId,
      required this.name,
      required this.code,
      required this.logoUrl,
      required this.modelSetState})
      : super(key: key);

  @override
  State<ExtensionTableBottomSheet> createState() => _ExtensionTableBottomSheetState();
}

class _ExtensionTableBottomSheetState extends State<ExtensionTableBottomSheet> {
  String skipCount = "0";
  bool isLoadingTable = false;
  final scrollController = ScrollController();
  String legendCell = 'Company';

  @override
  void initState() {
    lockerVariables.titleDividendsHistoryColumnMain = ['Year', 'Date', 'Industry', 'Dividends'].obs;
    getData();
    super.initState();
  }

  getData() async {
    await lockerEssentialApiFunctions.lockerExtensionTableEssentialData(
        context: context,
        skipCount: skipCount,
        modelSetState: setState,
        industry: widget.industry,
        tickerId: widget.tickerId,
        dividendId: widget.dividendId,
        name: widget.name,
        code: widget.code,
        logoUrl: widget.logoUrl);
    setState(() {
      isLoadingTable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      color: Colors.white,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            height: height / 24.74,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Dividend History(${widget.year})",
                  style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF000000), fontSize: text.scale(20)),
                ),
                IconButton(
                    onPressed: () {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear))
              ],
            ),
          ),
          SizedBox(height: height / 57.73),
          Expanded(
            child: isLoadingTable
                ? Obx(() => lockerVariables.lockerDividendHistoryResponseList.isNotEmpty
                    ? StickyHeadersTable(
                        scrollControllers: ScrollControllers(verticalBodyController: scrollController),
                        columnsLength: lockerVariables.titleDividendsHistoryColumnMain.length,
                        rowsLength: lockerVariables.titleDividendsHistoryRowMain.length,
                        columnsTitleBuilder: (i) => Container(
                            height: height / 17.32,
                            width: width / 2.49,
                            margin: EdgeInsets.only(right: i == 3 ? width / 27.4 : 0),
                            decoration: BoxDecoration(
                                color: i.isEven ? const Color(0XFF0EA102).withOpacity(0.1) : const Color(0XFF0EA102).withOpacity(0.3),
                                borderRadius: BorderRadius.only(topRight: i == 3 ? const Radius.circular(15) : const Radius.circular(0))),
                            child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                  child: Text(
                                    lockerVariables.titleDividendsHistoryColumnMain[i],
                                    maxLines: 2,
                                    style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                                  ),
                                ))),
                        rowsTitleBuilder: (i) => Container(
                            height: height / 17.32,
                            width: width / 3.3,
                            decoration: BoxDecoration(
                                color: i.isEven ? const Color(0XFF0EA102).withOpacity(0.1) : const Color(0XFF0EA102).withOpacity(0.3),
                                borderRadius: BorderRadius.only(bottomLeft: i == 7 ? const Radius.circular(15) : const Radius.circular(0))),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                  child: lockerVariables.titleDividendsHistoryRowMain[i],
                                  /* Text(
                                              lockerVariables.titleRowMain[i],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: _text.scale(10)12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),*/
                                ))),
                        contentCellBuilder: (i, j) => Obx(() => Container(
                            height: height / 17.32,
                            width: width / 3.3,
                            margin: EdgeInsets.only(right: i == 3 ? width / 27.4 : 0),
                            decoration: BoxDecoration(
                              color: j.isEven ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                  child: Center(
                                    child: Text(
                                      lockerVariables.matrixDividendsHistoryDataMain[j][i],
                                      maxLines: 2,
                                      style: TextStyle(fontSize: text.scale(12), overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                )))),
                        legendCell: Container(
                            height: height / 17.32,
                            width: width / 3.3,
                            decoration: BoxDecoration(
                                color: const Color(0XFF0EA102).withOpacity(0.3), borderRadius: const BorderRadius.only(topLeft: Radius.circular(15))),
                            child: Center(
                                child:
                                    Text(legendCell, style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(14), color: Colors.black)))),
                        cellAlignments: const CellAlignments.fixed(
                          contentCellAlignment: Alignment.centerLeft,
                          stickyColumnAlignment: Alignment.centerLeft,
                          stickyRowAlignment: Alignment.centerLeft,
                          stickyLegendAlignment: Alignment.centerLeft,
                        ),
                        cellDimensions: CellDimensions.fixed(
                          contentCellWidth: width / 3.3,
                          contentCellHeight: height / 17.32,
                          stickyLegendWidth: width / 3.3,
                          stickyLegendHeight: height / 17.32,
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'No response to display...',
                                      style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                : Center(
                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                  ),
          ),
        ],
      ),
    );
  }
}
