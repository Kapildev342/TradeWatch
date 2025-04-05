import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';

import 'LTIPageModel/lti_page_initial_model.dart';

class LTICalculatorPage extends StatefulWidget {
  const LTICalculatorPage({Key? key}) : super(key: key);

  @override
  State<LTICalculatorPage> createState() => _LTICalculatorPageState();
}

class _LTICalculatorPageState extends State<LTICalculatorPage> {
  bool loader = false;
  Map<String, dynamic> data = {
    "selected_date": DateTime.now().subtract(const Duration(days: 1825)),
    "category": lockerVariables.categoriesList[0],
    "ticker_id": "626787088bbdb6e89bb6815d",
    "ticker_name": "MRF Limited",
    "purchase_value": 150000.00,
    "purchase_date_close_value": 0.00,
    "shares": 0.0,
    "slider_value": 0.0,
    "ticker_details": {
      "_id": "626787088bbdb6e89bb6815d",
      "exchange": "NSE",
      "code": "MRF",
      "name": "MRF Limited",
      "country": "India",
      "currency": "INR",
      "type": "Common Stock",
      "category": "stocks",
      "industry": "Auto Parts",
      "logo_url": "https://eodhistoricaldata.com/img/logos/NSE/MRF.png",
      "change_p": 2.11,
      "close": 129300.00
    },
    "lti_values": {
      "total_investment_value": 0.00,
      "total_investment_percent": 0.00,
      "total_investment_percent_status": true,
      "no_of_shares": 0.00,
      "no_of_shares_percent": 0.00,
      "no_of_shares_percent_status": true,
      "is_splits_available": true,
      "total_dividend_earnings": 0.00,
      "is_dividend_available": true
    },
    "splits_list": [
      {
        "_id": "655da6423d73dcdc7eb6ed2d",
        "code": "LIBAS",
        "name": "Libas Consumer Products Limited",
        "category": "stocks",
        "exchange": "NSE",
        "industry": "Apparel Manufacturing",
        "exchange_id": "625e59ec49d900f6585bc683",
        "category_id": "625feb5da30e9baa64758043",
        "industry_id": "626bf5ccb50e1e87315fba1e",
        "ticker_id": "626787078bbdb6e89bb67fbf",
        "split_date": "2021-04-06T00:00:00.000Z",
        "optionable": "N",
        "old_shares": 5,
        "new_shares": 6,
        "status": 1,
        "createdAt": "2023-11-22T06:57:06.992Z",
        "updatedAt": "2023-11-22T06:57:06.992Z"
      },
      {
        "_id": "655da6423d73dcdc7eb6edaa",
        "code": "LIBAS",
        "name": "Libas Consumer Products Limited",
        "category": "stocks",
        "exchange": "NSE",
        "industry": "Apparel Manufacturing",
        "exchange_id": "625e59ec49d900f6585bc683",
        "category_id": "625feb5da30e9baa64758043",
        "industry_id": "626bf5ccb50e1e87315fba1e",
        "ticker_id": "626787078bbdb6e89bb67fbf",
        "split_date": "2021-09-21T00:00:00.000Z",
        "optionable": "N",
        "old_shares": 5,
        "new_shares": 6,
        "status": 1,
        "createdAt": "2023-11-22T06:57:06.999Z",
        "updatedAt": "2023-11-22T06:57:06.999Z"
      }
    ],
    "dividend_list": [
      {
        "_id": "655f23b03194494e5492072f",
        "code": "LIBAS",
        "name": "Libas Consumer Products Limited",
        "category": "stocks",
        "exchange": "NSE",
        "industry": "Apparel Manufacturing",
        "exchange_id": "625e59ec49d900f6585bc683",
        "category_id": "625feb5da30e9baa64758043",
        "industry_id": "626bf5ccb50e1e87315fba1e",
        "ticker_id": "626787078bbdb6e89bb67fbf",
        "date": "2021-09-06T00:00:00.000Z",
        "value": 0.07765,
        "unadjustedValue": 0.09318,
        "currency": "INR",
        "status": 1,
        "createdAt": "2023-11-23T10:04:32.148Z",
        "updatedAt": "2023-11-23T10:04:32.148Z"
      }
    ]
  };

  @override
  void initState() {
    getAllDataMain(name: 'Long_Term_Calculator');
    lockerVariables.longTermSelectedCategoryIndex = 0.obs;
    lockerVariables.longTermInitialData = (LTIPageInitialModel.fromJson(data)).obs;
    getData();
    super.initState();
  }

  getData() async {
    await longTermFunctions.longTermInitialDataFunction(modelSetState: setState);
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        //backgroundColor: const Color(0XFFFFFFFF),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "LTI Calculator",
                  style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w900, fontFamily: "Poppins"),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
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
                SizedBox(
                  width: width / 23.43,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return mainSkipValue ? const SettingsSkipView() : const SettingsView();
                      }));
                    },
                    child: widgetsMain.getProfileImage(context: context, isLogged: mainSkipValue)),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            if (!mounted) {
              return;
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: loader
          ? Container(
              width: width,
              padding: EdgeInsets.only(top: height / 57.73, left: width / 27.4, right: width / 27.4),
              margin: EdgeInsets.only(top: height / 173.2),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(blurRadius: 1, spreadRadius: 1, color: const Color(0XFF0EA102).withOpacity(0.3), offset: const Offset(0.0, 0.0))
                  ]),
              child: ListView(
                children: [
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Text(
                    "Purchase Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  SizedBox(
                    height: height / 14.5,
                    child: Obx(
                      () => TextFormField(
                        style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                        controller: lockerVariables.longTermDateController.value,
                        readOnly: true,
                        onTap: () async {
                          await longTermWidgets.showCalenderAlertDialog(context: context, modelSetState: setState);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: width / 27.4),
                              child: const Icon(
                                Icons.calendar_month,
                                size: 25,
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Text(
                    "Assets",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  SizedBox(
                    height: height / 14.5,
                    child: Obx(
                      () => TextFormField(
                        style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                        controller: lockerVariables.longTermCategory.value,
                        readOnly: true,
                        onTap: () async {
                          await longTermWidgets.categoriesBottomSheet(context: context, modelSetState: setState);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: width / 27.4),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Text(
                    "Ticker",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  SizedBox(
                    height: height / 14.5,
                    child: Obx(
                      () => TextFormField(
                        style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                        controller: lockerVariables.longTermTicker.value,
                        readOnly: true,
                        onTap: () async {
                          longTermWidgets.tickersBottomSheet(
                              context: context, superIndex: lockerVariables.longTermSelectedCategoryIndex.value, modelSetState: setState);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: width / 27.4),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(
                          () => TextFormField(
                            style: TextStyle(
                                fontSize: text.scale(12),
                                fontFamily: "Poppins",
                                color: lockerVariables.isLongTermPrice.value ? Theme.of(context).colorScheme.background : const Color(0XFFAEAEAE),
                                fontWeight: FontWeight.w600),
                            readOnly: true,
                            initialValue: "Total Purchase Price",
                            onTap: () async {
                              lockerVariables.isLongTermPrice.value = true;
                              lockerVariables.longTermInitialData!.value.purchaseValue.value =
                                  lockerVariables.longTermInitialData!.value.shares.value *
                                      lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
                              lockerVariables.longTermInputAmount.value.text =
                                  lockerVariables.longTermInitialData!.value.purchaseValue.value.toStringAsFixed(2);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: lockerVariables.isLongTermPrice.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.background,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(6),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 51.375,
                      ),
                      Expanded(
                        child: Obx(
                          () => TextFormField(
                            style: TextStyle(
                                fontSize: text.scale(10.5),
                                fontFamily: "Poppins",
                                color: lockerVariables.isLongTermPrice.value ? const Color(0XFFAEAEAE) : Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.w600),
                            readOnly: true,
                            controller: lockerVariables.purchasedQuantityController.value,
                            onTap: () async {
                              lockerVariables.isLongTermPrice.value = false;
                              lockerVariables.longTermInitialData!.value.shares.value =
                                  lockerVariables.longTermInitialData!.value.purchaseValue.value /
                                      lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
                              lockerVariables.longTermInputAmount.value.text =
                                  lockerVariables.longTermInitialData!.value.shares.value.toStringAsFixed(2);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: lockerVariables.isLongTermPrice.value
                                  ? Theme.of(context).colorScheme.background
                                  : Theme.of(context).colorScheme.primary,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(6),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 51.375,
                      ),
                      SizedBox(
                        width: width / 4.56,
                        child: Obx(
                          () => TextFormField(
                            style: TextStyle(
                                fontSize: text.scale(12), fontFamily: "Poppins", color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
                            controller: lockerVariables.longTermInputAmount.value,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              if (lockerVariables.isLongTermPrice.value) {
                                lockerVariables.longTermInitialData!.value.purchaseValue.value = double.parse(value);
                                longTermFunctions.longTermValuesCalculation();
                                if (double.parse(value) > 1000000.00) {
                                  lockerVariables.longTermInitialData!.value.sliderValue.value = 1.0;
                                } else if (double.parse(value) <= 0.00) {
                                  lockerVariables.longTermInitialData!.value.sliderValue.value = 0.0;
                                } else {
                                  lockerVariables.longTermInitialData!.value.sliderValue.value = (double.parse(value) / 1000000.00);
                                }
                              } else {
                                lockerVariables.longTermInitialData!.value.shares.value = double.parse(value);
                                lockerVariables.longTermInitialData!.value.purchaseValue.value =
                                    lockerVariables.longTermInitialData!.value.shares.value *
                                        lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
                                if (lockerVariables.longTermInitialData!.value.purchaseValue.value > 1000000.00) {
                                  lockerVariables.longTermInitialData!.value.sliderValue.value = 1.0;
                                } else if (lockerVariables.longTermInitialData!.value.purchaseValue.value <= 0.00) {
                                  lockerVariables.longTermInitialData!.value.sliderValue.value = 0.0;
                                } else {
                                  lockerVariables.longTermInitialData!.value.sliderValue.value =
                                      (lockerVariables.longTermInitialData!.value.purchaseValue.value / 1000000.00);
                                }
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: const Color(0XFFE6FFE6),
                              prefix: lockerVariables.isLongTermPrice.value
                                  ? Text(
                                      "\u{20B9} ",
                                      style: TextStyle(
                                          fontSize: text.scale(12),
                                          fontFamily: "Poppins",
                                          color: const Color(0XFF0EA102),
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const SizedBox(),
                              contentPadding: const EdgeInsets.all(6),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0XFFD8D8D8), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Obx(
                    () => Slider(
                      value: lockerVariables.longTermInitialData!.value.sliderValue.value,
                      onChanged: (double value) {
                        lockerVariables.longTermInitialData!.value.sliderValue.value = value;
                        lockerVariables.longTermInitialData!.value.purchaseValue.value =
                            lockerVariables.longTermInitialData!.value.sliderValue.value * 1000000.00;
                        lockerVariables.longTermInitialData!.value.shares.value = lockerVariables.longTermInitialData!.value.purchaseValue.value /
                            lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
                        if (lockerVariables.isLongTermPrice.value) {
                          lockerVariables.longTermInputAmount.value.text =
                              (lockerVariables.longTermInitialData!.value.sliderValue.value * 1000000.00).toStringAsFixed(2);
                        } else {
                          lockerVariables.longTermInputAmount.value.text = lockerVariables.longTermInitialData!.value.shares.value.toStringAsFixed(2);
                        }
                        longTermFunctions.longTermValuesCalculation();
                      },
                      thumbColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Price",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        Obx(() => ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return TickersDetailsPage(
                                    category: lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value,
                                    id: lockerVariables.longTermInitialData!.value.tickerDetails.value.id.value,
                                    exchange: lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value,
                                    country: lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value,
                                    fromWhere: "LTICalculator",
                                    name: lockerVariables.longTermInitialData!.value.tickerDetails.value.name.value,
                                  );
                                }));
                              },
                              leading: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: height / 14.43,
                                    width: width / 6.85,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            image: NetworkImage(lockerVariables.longTermInitialData!.value.tickerDetails.value.logoUrl.value),
                                            fit: BoxFit.fill)),
                                  ),
                                  lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value == "India"
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
                                lockerVariables.longTermInitialData!.value.tickerDetails.value.name.value,
                                style: TextStyle(
                                  fontSize: text.scale(14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lockerVariables.longTermInitialData!.value.tickerDetails.value.code.value,
                                        style: TextStyle(
                                            fontSize: text.scale(12),
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value == "India" ? "\u{20B9}" : "\$"} ${lockerVariables.longTermInitialData!.value.tickerDetails.value.close.value.toString()}",
                                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF0EA102)),
                                      ),
                                      SizedBox(
                                        width: width / 82.2,
                                      ),
                                      Text(
                                        "(${(lockerVariables.longTermInitialData!.value.tickerDetails.value.close.value / lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value).toStringAsFixed(2)}%)",
                                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF0EA102)),
                                      ),
                                      (lockerVariables.longTermInitialData!.value.tickerDetails.value.close.value /
                                                  lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value) >=
                                              0
                                          ? const Icon(
                                              Icons.arrow_upward,
                                              color: Color(0XFF0EA102),
                                              size: 15,
                                            )
                                          : const Icon(
                                              Icons.arrow_downward,
                                              color: Color(0XFFFB1212),
                                              size: 15,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: excLabelButton(
                                  text: lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value == "stocks"
                                      ? lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value == "NSE" ||
                                              lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value == "BSE" ||
                                              lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value == "INDX"
                                          ? lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value
                                          : "usastocks"
                                      : lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value == "crypto"
                                          ? lockerVariables.longTermInitialData!.value.tickerDetails.value.industry.value
                                          : lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value == "commodity"
                                              ? lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value
                                              : lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value == "forex"
                                                  ? "inrusd"
                                                  : "",
                                  context: context),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 0,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            "${DateFormat("MMM dd, yyyy").format(lockerVariables.longTermInitialData!.value.selectedDate.value)} vs Today",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                          ),
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        Obx(
                          () => Row(
                            children: [
                              const Expanded(child: Text("Total investment value")),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: height / 86.6,
                                  ),
                                  Text(
                                      "\u{20B9} ${lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentValue.value.toStringAsFixed(2)}"),
                                  SizedBox(
                                    height: height / 173.2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercent.value.toStringAsFixed(2)}%",
                                        style: TextStyle(
                                            fontSize: text.scale(12),
                                            fontWeight: FontWeight.w500,
                                            color: lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercentStatus.value
                                                ? const Color(0XFF0EA102)
                                                : const Color(0XFFFB1212)),
                                      ),
                                      lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercentStatus.value
                                          ? const Icon(
                                              Icons.arrow_upward,
                                              color: Color(0XFF0EA102),
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.arrow_downward,
                                              color: Color(0XFFFB1212),
                                              size: 20,
                                            )
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Obx(
                          () => Row(
                            children: [
                              const Expanded(child: Text("Number of Shares/Units")),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: height / 86.6,
                                  ),
                                  Text("${lockerVariables.longTermInitialData!.value.ltiValues.value.noOfShares.value.toStringAsFixed(2)} Shares"),
                                  SizedBox(
                                    height: height / 173.2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercent.value.toStringAsFixed(2)}%",
                                        style: TextStyle(
                                            fontSize: text.scale(12),
                                            fontWeight: FontWeight.w500,
                                            color: lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercentStatus.value
                                                ? const Color(0XFF0EA102)
                                                : const Color(0XFFFB1212)),
                                      ),
                                      lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercentStatus.value
                                          ? const Icon(
                                              Icons.arrow_upward,
                                              color: Color(0XFF0EA102),
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.arrow_downward,
                                              color: Color(0XFFFB1212),
                                              size: 20,
                                            )
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text("Splits")),
                            Expanded(
                                child: SizedBox(
                              height: height / 34.64,
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    lockerVariables.longTermInitialData!.value.ltiValues.value.isSplitsAvailable.value
                                        ? ElevatedButton(onPressed: () {}, child: const Text("Yes"))
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () {}, child: const Text("No")),
                                    lockerVariables.longTermInitialData!.value.ltiValues.value.isSplitsAvailable.value
                                        ? SizedBox(
                                            width: width / 41.1,
                                          )
                                        : const SizedBox(),
                                    lockerVariables.longTermInitialData!.value.ltiValues.value.isSplitsAvailable.value
                                        ? InkWell(
                                            onTap: () {
                                              longTermWidgets.splitsBottomSheet(context: context);
                                            },
                                            child: const Icon(
                                              Icons.add_circle,
                                              color: Color(0XFF0EA102),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: height / 28.86,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text("Total Dividend Earnings")),
                            Expanded(
                                child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      "${lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value == "India" ? "\u{20B9}" : "\$"} ${lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value.toStringAsFixed(2)}"),
                                  lockerVariables.longTermInitialData!.value.ltiValues.value.isDividendsAvailable.value
                                      ? SizedBox(
                                          width: width / 41.1,
                                        )
                                      : const SizedBox(),
                                  lockerVariables.longTermInitialData!.value.ltiValues.value.isDividendsAvailable.value
                                      ? InkWell(
                                          onTap: () {
                                            longTermWidgets.dividendsBottomSheet(context: context);
                                          },
                                          child: const Icon(
                                            Icons.add_circle,
                                            color: Color(0XFF0EA102),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return TickersDetailsPage(
                                  category: lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value,
                                  id: lockerVariables.longTermInitialData!.value.tickerDetails.value.id.value,
                                  exchange: lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value,
                                  country: lockerVariables.longTermInitialData!.value.tickerDetails.value.country.value,
                                  fromWhere: "LTICalculator",
                                  name: lockerVariables.longTermInitialData!.value.tickerDetails.value.name.value,
                                );
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
                                  style: TextStyle(
                                      fontSize: text.scale(14), color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              backgroundColor: const Color(0XFF017FDB),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return FinalChartPage(
                                  tickerId: lockerVariables.longTermInitialData!.value.tickerDetails.value.id.value,
                                  category: lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value,
                                  exchange: lockerVariables.longTermInitialData!.value.tickerDetails.value.exchange.value,
                                  chartType: "2",
                                  fromLink: false,
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
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  /*    Container(
                      width: _width,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: Color(0XFF0EA102).withOpacity(0.2),
                                offset: Offset(0.0, 0.0))
                          ]),
                      child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat('dd/MM/yyyy'),
                            minimum: lockerVariables.minXValue.value,
                            maximum: lockerVariables.maxXValue.value,
                            isVisible: false,
                            majorGridLines: MajorGridLines(width: 0),
                            placeLabelsNearAxisLine: false,
                          ),
                          primaryYAxis: NumericAxis(
                            isVisible: true,
                            majorGridLines: MajorGridLines(width: 0),
                            opposedPosition: true,
                            minimum:
                                (lockerVariables.minYValue.value).toDouble(),
                            maximum:
                                (lockerVariables.maxYValue.value).toDouble(),
                            placeLabelsNearAxisLine: false,
                          ),
                          series: <CartesianSeries>[
                            SplineAreaSeries<ChartData, DateTime>(
                                splineType: SplineType.cardinal,
                                dataSource:
                                    lockerVariables.longTermChartDataList,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                emptyPointSettings: EmptyPointSettings(
                                    mode: EmptyPointMode.average)),
                          ])),
                  SizedBox(
                    height: _height/57.73,
                  ),*/
                ],
              ),
            )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
    ));
  }
}
