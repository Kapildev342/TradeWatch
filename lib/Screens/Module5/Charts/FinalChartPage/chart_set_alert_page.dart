import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class ChartSetAlertPage extends StatefulWidget {
  final String tickerId;
  final String tickerName;
  final int currentIndex;
  final bool editValue;
  final String closeValue;
  final String? fromWhere;

  const ChartSetAlertPage({
    Key? key,
    required this.currentIndex,
    required this.tickerId,
    required this.tickerName,
    required this.editValue,
    required this.closeValue,
    this.fromWhere,
  }) : super(key: key);

  @override
  State<ChartSetAlertPage> createState() => _ChartSetAlertPageState();
}

class _ChartSetAlertPageState extends State<ChartSetAlertPage> {
  List<TextEditingController> minControllerMainList = List.generate(1, (i) => TextEditingController());
  List<TextEditingController> maxControllerMainList = List.generate(1, (i) => TextEditingController());
  List<TextEditingController> notesControllerMainList = List.generate(1, (i) => TextEditingController());
  List<bool> savePressedList = List.generate(1, (i) => false);
  List<bool> fieldEmptyList = List.generate(1, (i) => false);
  List<String> notificationMainList = List.generate(1, (i) => "");
  bool loading1 = false;
  int newIndex = 0;
  int excIndex = 0;
  List<int> finalMaxPercent = List.generate(1, (index) => 0);
  List<List<int>> minSuggestionList = List.generate(1, (index) => [-10, -5, 0, 5, 10]);
  List<bool> minSuggestionBoolList = List.generate(1, (index) => false);
  List<bool> maxDisableList = List.generate(1, (index) => true);
  List<List<int>> maxSuggestionList = List.generate(1, (index) => [0, 0, 0, 0, 0]);
  List<bool> maxSuggestionBoolList = List.generate(1, (index) => false);
  List<String> chartList = [
    "Bar",
    "Candle",
    "Line",
    "Area",
    "Column",
    "Baseline",
    "HiLo",
    "Renko",
    "Kagi",
    "PnF",
    "LineBreak",
    "HeikinAshi",
    "HollowCandle",
    "Compare",
  ];

  addNotifyListMain1({
    required String tickerId,
    required String notificationId,
    required String minValue,
    required String maxvalue,
    required String notes,
  }) async {
    Map<String, dynamic> data = {};
    var url = baseurl + versionWatch + watchListAddNotify;
    if (newIndex == 0) {
      data = notificationId == ""
          ? {
              "category_id": mainCatIdList[newIndex],
              "exchange_id": mainCatIdList[excIndex],
              "ticker_id": tickerId,
              "min_value": minValue,
              "max_value": maxvalue,
              "notes": notes
            }
          : {
              "category_id": mainCatIdList[newIndex],
              "exchange_id": mainCatIdList[excIndex],
              'notification_id': notificationId,
              "ticker_id": tickerId,
              "min_value": minValue,
              "max_value": maxvalue,
              "notes": notes
            };
    } else {
      data = notificationId == ""
          ? {"category_id": mainCatIdList[newIndex], "ticker_id": tickerId, "min_value": minValue, "max_value": maxvalue, "notes": notes}
          : {
              "category_id": mainCatIdList[newIndex],
              'notification_id': notificationId,
              "ticker_id": tickerId,
              "min_value": minValue,
              "max_value": maxvalue,
              "notes": notes
            };
    }
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "Price alert notification set",
        duration: const Duration(seconds: 2),
      ).show(context);
      return responseData;
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      return responseData;
    }
  }

  removeNotifyListMain1({required String notifyId, required String tickerId}) async {
    var url = baseurl + versionWatch + watchListRemoveNotify;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: {"notification_id": notifyId, 'ticker_id': tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "Price alert notification removed",
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
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    getAllDataMain(name: 'Alert_Set_Page');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    getAllData();
    super.initState();
  }

  getAllData() async {
    currentMainIndex = widget.currentIndex;
    switch (currentMainIndex) {
      case 0:
        newIndex = 0;
        excIndex = 0;
        break;
      case 1:
        newIndex = 0;
        excIndex = 1;
        break;
      case 2:
        newIndex = 0;
        excIndex = 2;
        break;
      case 3:
        newIndex = 1;
        excIndex = 1;
        break;
      case 4:
        newIndex = 2;
        excIndex = 1;
        break;
      case 5:
        newIndex = 2;
        excIndex = 1;
        break;
      case 6:
        newIndex = 3;
        excIndex = 1;
        break;
    }
    widget.editValue ? await editFunc() : debugPrint("nothing");
    setState(() {
      loading1 = true;
    });
  }

  editFunc() async {
    var url = baseurl + versionWatch + watchNotificationList;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: {'ticker_id': widget.tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      minControllerMainList.clear();
      maxControllerMainList.clear();
      savePressedList.clear();
      fieldEmptyList.clear();
      notificationMainList.clear();
      notesControllerMainList.clear();
      minSuggestionBoolList.clear();
      minSuggestionList.clear();
      maxDisableList.clear();
      minControllerMainList = List.generate(responseData["response"].length, (i) => TextEditingController());
      maxControllerMainList = List.generate(responseData["response"].length, (i) => TextEditingController());
      notesControllerMainList = List.generate(responseData["response"].length, (i) => TextEditingController());
      savePressedList = List.generate(responseData["response"].length, (i) => true);
      fieldEmptyList = List.generate(responseData["response"].length, (i) => false);
      notificationMainList = List.generate(responseData["response"].length, (i) => "");
      minSuggestionBoolList = List.generate(responseData["response"].length, (i) => false);
      minSuggestionList = List.generate(responseData["response"].length, (i) => [-10, -5, 0, 5, 10]);
      maxDisableList = List.generate(responseData["response"].length, (i) => false);
      maxSuggestionBoolList = List.generate(responseData["response"].length, (i) => false);
      finalMaxPercent = List.generate(responseData["response"].length, (i) => 0);
      maxSuggestionList = List.generate(responseData["response"].length, (i) => [0, 0, 0, 0, 0]);

      setState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          notificationMainList[i] = responseData["response"][i]['_id'];
          minControllerMainList[i].text = (responseData["response"][i]['min_value']).toString();
          maxControllerMainList[i].text = (responseData["response"][i]['max_value']).toString();
          if (responseData['response'][i].containsKey("notes")) {
            notesControllerMainList[i].text = (responseData["response"][i]['notes']).toString();
          } else {
            notesControllerMainList[i].text = "";
          }
          double value1 = double.parse(minControllerMainList[i].text);
          double value2 = double.parse(widget.closeValue);
          double finalValue = 0.0;
          finalValue = value1 - value2;
          finalMaxPercent[i] = ((finalValue * 100) / (value2 == 0.0 ? 1.0 : value2)).round();
          maxSuggestionList[i] = [
            finalMaxPercent[i] + 5,
            finalMaxPercent[i] + 10,
            finalMaxPercent[i] + 15,
            finalMaxPercent[i] + 20,
            finalMaxPercent[i] + 25
          ];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: loading1
              ? SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 54.13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                                // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                                // savePressedList.isEmpty?Navigator.pop(context):debugPrint("nothing");
                                Navigator.pop(context, true);
                                /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                              return FinalChartPage(
                                tickerId: widget.tickerId,
                                category: finalisedCategory.toLowerCase(),
                                exchange:finalChartExchange.value,
                                chartType:chartList.indexOf(finalChartMain.value).toString(),
                                index: 6,fromWhere: "addNotify",);
                            }));*/

                                /* setState(() {
                          savePressedList.contains(true)
                              ? watchNotifyAddedBoolListMain[widget.currentIndex] = true
                              : watchNotifyAddedBoolListMain[widget.currentIndex] = false;
                        });*/
                              },
                              icon: const Icon(Icons.clear),
                            )
                          ],
                        ),
                        Center(
                          child: Text(
                            "Turn On Notification",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                              'You will be notified when the price of ${widget.tickerName} will cross the threshold points the you will enter below.',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12))),
                        ),
                        SizedBox(height: height / 50.75),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Current Price: ",
                                    style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                                    ? Text("\u{20B9} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: text.scale(12),
                                            fontFamily: 'Robonto',
                                            color: const Color(0XFF0EA102)))
                                    : currentMainIndex == 6
                                        ? const SizedBox()
                                        : Text("\$ ",
                                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(12), color: const Color(0XFF0EA102))),
                                Text(widget.closeValue,
                                    style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                              ],
                            ),
                            Container(
                              height: height / 34.80,
                              width: width / 16.07,
                              margin: const EdgeInsets.only(right: 25),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                                  ? Image.asset("lib/Constants/Assets/SMLogos/rupee.png")
                                  : currentMainIndex == 6
                                      ? const SizedBox()
                                      : SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/dollar_image.svg",
                                          fit: BoxFit.fill,
                                        ),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 50.75),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: minControllerMainList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 2,
                              shadowColor: Colors.black26,
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.black26.withOpacity(0.1)),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width / 31.25),
                                child: Column(
                                  children: [
                                    savePressedList.contains(true)
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    if (notificationMainList[index] == "") {
                                                      setState(() {
                                                        minControllerMainList.removeAt(index);
                                                        maxControllerMainList.removeAt(index);
                                                        notesControllerMainList.removeAt(index);
                                                        fieldEmptyList.removeAt(index);
                                                        savePressedList.removeAt(index);
                                                        notificationMainList.removeAt(index);
                                                        minSuggestionBoolList.removeAt(index);
                                                        maxDisableList.removeAt(index);
                                                        finalMaxPercent.removeAt(index);
                                                        maxSuggestionList.removeAt(index);
                                                        maxSuggestionBoolList.removeAt(index);
                                                      });
                                                    } else {
                                                      await removeNotifyListMain1(
                                                        tickerId: widget.tickerId,
                                                        notifyId: notificationMainList[index],
                                                      );
                                                      logEventFunc(name: 'Removed_Price_Alerts', type: 'WatchList');
                                                      setState(() {
                                                        minControllerMainList.removeAt(index);
                                                        maxControllerMainList.removeAt(index);
                                                        notesControllerMainList.removeAt(index);
                                                        fieldEmptyList.removeAt(index);
                                                        savePressedList.removeAt(index);
                                                        notificationMainList.removeAt(index);
                                                        minSuggestionBoolList.removeAt(index);
                                                        maxDisableList.removeAt(index);
                                                        finalMaxPercent.removeAt(index);
                                                        maxSuggestionList.removeAt(index);
                                                        maxSuggestionBoolList.removeAt(index);
                                                      });
                                                    }
                                                  },
                                                  splashRadius: 1.0,
                                                  icon: SizedBox(
                                                      height: height / 40.6,
                                                      width: width / 18.75,
                                                      child: Image.asset(
                                                        "lib/Constants/Assets/ForumPage/x.png",
                                                      )))
                                            ],
                                          )
                                        : SizedBox(
                                            height: height / 50.75,
                                          ),
                                    TextFormField(
                                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                      onChanged: (value) {
                                        maxSuggestionBoolList[index] = false;
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            maxDisableList[index] = false;
                                            maxControllerMainList[index].clear();
                                            double value1 = double.parse(minControllerMainList[index].text);
                                            double value2 = double.parse(widget.closeValue);
                                            double finalValue = 0.0;
                                            finalValue = value1 - value2;
                                            finalMaxPercent[index] = ((finalValue * 100) / value2).round();
                                            if (minControllerMainList[index].text.isNotEmpty && maxControllerMainList[index].text.isNotEmpty) {
                                              fieldEmptyList[index] = true;
                                              savePressedList[index] = false;
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            minSuggestionBoolList[index] = true;
                                            maxControllerMainList[index].clear();
                                            maxDisableList[index] = true;
                                            finalMaxPercent[index] = 0;
                                          });
                                        }
                                      },
                                      onTap: () {
                                        setState(() {
                                          minSuggestionBoolList[index] = true;
                                          finalMaxPercent[index] = 0;
                                        });
                                      },
                                      controller: minControllerMainList[index],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15),
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
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(15),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Robonto"),
                                        labelText: currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                                            ? 'Min(\u{20B9})'
                                            : currentMainIndex == 6
                                                ? 'Min'
                                                : 'Min(\$)',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height / 101.5),
                                    minControllerMainList[index].text.isEmpty
                                        ? minSuggestionBoolList[index]
                                            ? SizedBox(
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "suggestions: ",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: minSuggestionList[index].length,
                                                        itemBuilder: (context, index1) {
                                                          return InkWell(
                                                            onTap: () {
                                                              finalMaxPercent[index] = minSuggestionList[index][index1];
                                                              double value1 = minSuggestionList[index][index1] / 100;
                                                              double value2 = double.parse(widget.closeValue);
                                                              double finalValue = (value1 * value2).abs();
                                                              if (value1 < 0) {
                                                                minControllerMainList[index].text = (value2 - finalValue).toStringAsFixed(3);
                                                                minControllerMainList[index].selection = TextSelection.fromPosition(
                                                                    TextPosition(offset: minControllerMainList[index].text.length));
                                                                setState(() {
                                                                  minSuggestionBoolList[index] = false;
                                                                  maxDisableList[index] = false;
                                                                });
                                                              } else {
                                                                minControllerMainList[index].text = (value2 + finalValue).toStringAsFixed(3);
                                                                minControllerMainList[index].selection = TextSelection.fromPosition(
                                                                    TextPosition(offset: minControllerMainList[index].text.length));
                                                                setState(() {
                                                                  minSuggestionBoolList[index] = false;
                                                                  maxDisableList[index] = false;
                                                                });
                                                              }
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                              margin: const EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                color: const Color(0XFF0EA102),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${minSuggestionList[index][index1]}%",
                                                                  style:
                                                                      const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox()
                                        : const SizedBox(),
                                    SizedBox(height: height / 101.5),
                                    TextFormField(
                                      readOnly: maxDisableList[index],
                                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            maxSuggestionBoolList[index] = true;
                                          });
                                        } else {
                                          setState(() {
                                            if (minControllerMainList[index].text.isNotEmpty && maxControllerMainList[index].text.isNotEmpty) {
                                              fieldEmptyList[index] = true;
                                              savePressedList[index] = false;
                                            }
                                          });
                                        }
                                      },
                                      onTap: () {
                                        if (maxDisableList[index]) {
                                          Flushbar(
                                            message: "Please enter Minimum Value",
                                            duration: const Duration(seconds: 2),
                                          ).show(context);
                                        } else {
                                          maxSuggestionList[index] = [
                                            finalMaxPercent[index] + 5,
                                            finalMaxPercent[index] + 10,
                                            finalMaxPercent[index] + 15,
                                            finalMaxPercent[index] + 20,
                                            finalMaxPercent[index] + 25
                                          ];
                                          setState(() {
                                            maxSuggestionBoolList[index] = true;
                                          });
                                        }
                                      },
                                      controller: maxControllerMainList[index],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15),
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
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(15),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Robonto"),
                                        labelText: currentMainIndex == 1 || currentMainIndex == 2 || currentMainIndex == 4
                                            ? 'Max(\u{20B9})'
                                            : currentMainIndex == 6
                                                ? 'Max'
                                                : 'Max(\$)',
                                      ),
                                    ),
                                    SizedBox(height: height / 101.5),
                                    maxControllerMainList[index].text.isEmpty
                                        ? maxSuggestionBoolList[index]
                                            ? SizedBox(
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "suggestions: ",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: maxSuggestionList[index].length,
                                                        itemBuilder: (context, index1) {
                                                          return InkWell(
                                                            onTap: () {
                                                              double value1 = maxSuggestionList[index][index1] / 100;
                                                              double value2 = double.parse(widget.closeValue);
                                                              double finalValue = (value1 * value2).abs();
                                                              if (value1 < 0) {
                                                                maxControllerMainList[index].text = (value2 - finalValue).toStringAsFixed(3);
                                                                maxControllerMainList[index].selection = TextSelection.fromPosition(
                                                                    TextPosition(offset: maxControllerMainList[index].text.length));
                                                                setState(() {
                                                                  maxSuggestionBoolList[index] = false;
                                                                  maxDisableList[index] = false;
                                                                  fieldEmptyList[index] = true;
                                                                  savePressedList[index] = false;
                                                                });
                                                              } else {
                                                                maxControllerMainList[index].text = (value2 + finalValue).toStringAsFixed(3);
                                                                maxControllerMainList[index].selection = TextSelection.fromPosition(
                                                                    TextPosition(offset: maxControllerMainList[index].text.length));
                                                                setState(() {
                                                                  maxSuggestionBoolList[index] = false;
                                                                  maxDisableList[index] = false;
                                                                  fieldEmptyList[index] = true;
                                                                  savePressedList[index] = false;
                                                                });
                                                              }
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                              margin: const EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                color: const Color(0XFF0EA102),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${maxSuggestionList[index][index1]}%",
                                                                  style:
                                                                      const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox()
                                        : const SizedBox(),
                                    SizedBox(
                                      height: height / 50.75,
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                      onChanged: (value) {
                                        setState(() {
                                          if (minControllerMainList[index].text.isNotEmpty && maxControllerMainList[index].text.isNotEmpty) {
                                            fieldEmptyList[index] = true;
                                            savePressedList[index] = false;
                                          }
                                        });
                                      },
                                      controller: notesControllerMainList[index],
                                      keyboardType: TextInputType.text,
                                      maxLines: null,
                                      minLines: null,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 8),
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
                                          color: const Color(0XFFA5A5A5),
                                          fontSize: text.scale(15),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        labelText: "Notes (optional)",
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 50.75,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: fieldEmptyList[index]
                                                ? savePressedList[index]
                                                    ? Colors.grey
                                                    : const Color(0XFF0EA102)
                                                : Colors.grey),
                                        onPressed: savePressedList[index]
                                            ? () {}
                                            : () async {
                                                if (double.parse(maxControllerMainList[index].text) <=
                                                    double.parse(minControllerMainList[index].text)) {
                                                  Flushbar(
                                                    message: "Max value must greater than min value",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                } else {
                                                  setState(() {
                                                    savePressedList[index] = true;
                                                  });
                                                  // watchNotifyAddedBoolListMain[widget.currentIndex] = true;
                                                  if (notificationMainList[index] == "") {
                                                    var newResponse = await addNotifyListMain1(
                                                      notificationId: notificationMainList[index],
                                                      tickerId: widget.tickerId,
                                                      minValue: minControllerMainList[index].text,
                                                      maxvalue: maxControllerMainList[index].text,
                                                      notes: notesControllerMainList[index].text,
                                                    );
                                                    notificationMainList[index] = newResponse["response"]['_id'];
                                                    logEventFunc(name: 'Set_Price_Alerts', type: 'WatchList');
                                                  } else {
                                                    await addNotifyListMain1(
                                                        notificationId: notificationMainList[index],
                                                        tickerId: widget.tickerId,
                                                        minValue: minControllerMainList[index].text,
                                                        maxvalue: maxControllerMainList[index].text,
                                                        notes: notesControllerMainList[index].text);
                                                    logEventFunc(name: 'Updated_Price_Alerts', type: 'WatchList');
                                                  }
                                                }
                                              },
                                        child: const Text(
                                          "Save alert",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0XFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 50.75,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: notificationMainList.length >= 5
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Need to add another Alert.",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: savePressedList.contains(false)
                                              ? () {}
                                              : () {
                                                  setState(() {
                                                    minControllerMainList.add(TextEditingController());
                                                    maxControllerMainList.add(TextEditingController());
                                                    notesControllerMainList.add(TextEditingController());
                                                    notificationMainList.add("");
                                                    savePressedList.add(false);
                                                    fieldEmptyList.add(false);
                                                    minSuggestionList.add([-10, -5, 0, 5, 10]);
                                                    minSuggestionBoolList.add(false);
                                                    maxDisableList.add(true);
                                                    maxSuggestionBoolList.add(false);
                                                    finalMaxPercent.add(0);
                                                    maxSuggestionList.add([0, 0, 0, 0, 0]);
                                                  });
                                                },
                                          child: Text(
                                            "Click Here",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: savePressedList.contains(false) ? Colors.grey : const Color(0XFF0EA102),
                                            ),
                                          )),
                                    ],
                                  ) //:
                            ),
                        SizedBox(height: height / 40.6),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                ),
        ),
      ),
    );
  }
}
