import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Edited_Packages/Rounded_Slider_Library/sleek_circular_slider.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  bool loader = false;

  @override
  void initState() {
    getAllDataMain(name: 'Investment_Planner');
    getData();
    super.initState();
  }

  getData() async {
    await calculatorFunctions.assigningInitialValuesFunction();
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
      // backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: Row(
          children: [
            Text(
              "Investment Planner",
              style: TextStyle(
                fontSize: text.scale(18),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: width / 82.2,
            ),
            GestureDetector(
              child: const Center(
                  child: Icon(
                Icons.info,
                color: Color(0XFF0EA102),
                size: 25,
              )),
              onTap: () {
                calculatorWidgets.infoPopUp(context: context);
              },
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
        actions: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: width / 27.4),
                child: SizedBox(
                  height: height / 43.3,
                  child: GestureDetector(
                    onTap: () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: () {});
                      } else {
                        await calculatorFunctions.favouriteSaveFunction(context: context);
                      }
                    },
                    child: Container(
                      width: width / 7,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            spreadRadius: 0.0,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
      body: loader
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.onBackground, Theme.of(context).colorScheme.background],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Obx(() => Center(
                          child: SleekCircularSlider(
                        min: lockerVariables.minValue.value,
                        max: lockerVariables.maxValue.value,
                        initialValue: lockerVariables.initialValue.value,
                        appearance: CircularSliderAppearance(
                            size: 180,
                            angleRange: 360,
                            startAngle: 90,
                            customColors: CustomSliderColors(
                              dotColor: const Color(0XFF2CD884),
                              progressBarColor: const Color(0XFF0A684A).withOpacity(0.7),
                              shadowMaxOpacity: 0.0,
                              trackColor: Colors.grey.withOpacity(0.8),
                            ),
                            customWidths: CustomSliderWidths(handlerSize: 15, progressBarWidth: width / 20.55, trackWidth: width / 20.55)),
                        onChange: (double endValue) {
                          if (lockerVariables.isIndia.value) {
                            lockerVariables.purchaseValue.value = endValue * 1000000;
                          } else {
                            lockerVariables.purchaseValue.value = (endValue * 1000000) / lockerVariables.dollarValue.value;
                          }
                          lockerVariables.calculatorTextControl.value.text = lockerVariables.purchaseValue.value.toStringAsFixed(2);
                          for (int i = 0; i < lockerVariables.calculatorPageContents!.value.response.length; i++) {
                            for (int j = 0; j < lockerVariables.calculatorPageContents!.value.response[i].responseList.length; j++) {
                              lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.value.value =
                                  lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close == 0
                                      ? lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close.toString()
                                      : lockerVariables.isIndia.value
                                          ? (lockerVariables.purchaseValue.value /
                                                  lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                              .toStringAsFixed(2)
                                          : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                                                  lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                              .toStringAsFixed(2);
                            }
                          }
                        },
                        innerWidget: (v) => InkWell(
                          onTap: () async {
                            setState(() {
                              if (lockerVariables.isIndia.value) {
                                lockerVariables.purchaseValue.value = lockerVariables.purchaseValue.value / lockerVariables.dollarValue.value;
                                lockerVariables.calculatorTextControl.value.text = lockerVariables.purchaseValue.value.toStringAsFixed(2);
                              } else {
                                lockerVariables.purchaseValue.value = lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value;
                                lockerVariables.calculatorTextControl.value.text = lockerVariables.purchaseValue.value.toStringAsFixed(2);
                              }
                              lockerVariables.isIndia.toggle();
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: height / 17.32,
                              ),
                              CircleAvatar(
                                foregroundImage: AssetImage(
                                    lockerVariables.isIndia.value ? "lib/Constants/Assets/flags/in.png" : "lib/Constants/Assets/flags/us.png"),
                                radius: 25,
                              ),
                              SizedBox(
                                height: height / 173.2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text(lockerVariables.isIndia.value ? "INR" : "USD"), const Icon(Icons.arrow_drop_down_outlined)],
                              ),
                            ],
                          ),
                        ),
                      ))),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Obx(() => Center(
                        child: SizedBox(
                          width: width / 2.6,
                          height: height / 24.74,
                          child: TextFormField(
                            controller: lockerVariables.calculatorTextControl.value,
                            style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                lockerVariables.initialValue.value = 0.0;
                              } else {
                                if (double.parse(lockerVariables.calculatorTextControl.value.text) <= 1000000 &&
                                    double.parse(lockerVariables.calculatorTextControl.value.text) > 0) {
                                  lockerVariables.initialValue.value = (double.parse(lockerVariables.calculatorTextControl.value.text)) / 1000000;
                                  lockerVariables.purchaseValue.value = double.parse(lockerVariables.calculatorTextControl.value.text);
                                  for (int i = 0; i < lockerVariables.calculatorPageContents!.value.response.length; i++) {
                                    for (int j = 0; j < lockerVariables.calculatorPageContents!.value.response[i].responseList.length; j++) {
                                      lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.value.value =
                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close == 0
                                              ? lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close.toString()
                                              : lockerVariables.isIndia.value
                                                  ? (lockerVariables.purchaseValue.value /
                                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                                      .toStringAsFixed(2)
                                                  : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                                      .toStringAsFixed(2);
                                    }
                                  }
                                } else if (double.parse(lockerVariables.calculatorTextControl.value.text) > 1000000) {
                                  lockerVariables.initialValue.value = 1.0;
                                  lockerVariables.purchaseValue.value = double.parse(lockerVariables.calculatorTextControl.value.text);
                                  for (int i = 0; i < lockerVariables.calculatorPageContents!.value.response.length; i++) {
                                    for (int j = 0; j < lockerVariables.calculatorPageContents!.value.response[i].responseList.length; j++) {
                                      lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.value.value =
                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close == 0
                                              ? lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close.toString()
                                              : lockerVariables.isIndia.value
                                                  ? (lockerVariables.purchaseValue.value /
                                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                                      .toStringAsFixed(2)
                                                  : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                                      .toStringAsFixed(2);
                                    }
                                  }
                                } else if (double.parse(lockerVariables.calculatorTextControl.value.text) <= 0) {
                                  lockerVariables.initialValue.value = 0.0;
                                  lockerVariables.purchaseValue.value = double.parse(lockerVariables.calculatorTextControl.value.text);
                                  for (int i = 0; i < lockerVariables.calculatorPageContents!.value.response.length; i++) {
                                    for (int j = 0; j < lockerVariables.calculatorPageContents!.value.response[i].responseList.length; j++) {
                                      lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.value.value =
                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close == 0
                                              ? lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close.toString()
                                              : lockerVariables.isIndia.value
                                                  ? (lockerVariables.purchaseValue.value /
                                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                                      .toStringAsFixed(2)
                                                  : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                                                          lockerVariables.calculatorPageContents!.value.response[i].responseList[j].ticker.close)
                                                      .toStringAsFixed(2);
                                    }
                                  }
                                } else {}
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 173.2),
                              fillColor: isDarkTheme.value ? Theme.of(context).colorScheme.background : const Color(0XFFDFECE9),
                              filled: true,
                              prefix: Text(
                                lockerVariables.isIndia.value ? "\u{20B9} " : "\$ ",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16)),
                              ),
                              suffix: Text(
                                lockerVariables.isIndia.value ? " INR" : "  USD",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(12), color: const Color(0XFF0EA102)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(width: 0.1),
                              ),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.1)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.1)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.1)),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.1)),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  calculatorWidgets.bodyListWidgets(context: context),
                ],
              ),
            )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
    ));
  }
}
