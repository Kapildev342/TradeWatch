import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class PaymentPageWidgets {
  Widget planGridWidgets({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 41.1),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: communitiesVariables.planChoosingInitialData.value.response.length,
          itemBuilder: (BuildContext context, int index) {
            return Obx(() => InkWell(
                  onTap: () {
                    communitiesVariables.chosenSubscriptionPlan.value = index;
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: width,
                        margin: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 108.25),
                        padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 57.73),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              communitiesVariables.planChoosingInitialData.value.response[index].initialColor,
                              communitiesVariables.planChoosingInitialData.value.response[index].endColor
                            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio(
                              value: index,
                              groupValue: communitiesVariables.chosenSubscriptionPlan.value,
                              onChanged: (int? value) {
                                communitiesVariables.chosenSubscriptionPlan.value = value!;
                              },
                              fillColor: MaterialStateProperty.all(Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          communitiesVariables.planChoosingInitialData.value.response[index].subscriptionPeriod,
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(14), color: const Color(0XFFFFFFFF)),
                                        ),
                                        SizedBox(
                                          height: height / 86.6,
                                        ),
                                        Text(
                                          "${communitiesVariables.planChoosingInitialData.value.response[index].trailPeriod} days Free Trail ",
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(8), color: const Color(0XFFFFFFFF)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\u{20B9} ${(communitiesVariables.planChoosingInitialData.value.response[index].paymentAmount - (communitiesVariables.planChoosingInitialData.value.response[index].paymentAmount * communitiesVariables.planChoosingInitialData.value.response[index].discount / 100)).toStringAsFixed(2)}",
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFFFFFFFF)),
                                        ),
                                        SizedBox(
                                          height: height / 173.2,
                                        ),
                                        Text(
                                          "\u{20B9} ${communitiesVariables.planChoosingInitialData.value.response[index].paymentAmount}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: text.scale(12),
                                              color: Colors.white70,
                                              decoration: TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width / 82.2, top: height / 288.6),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.bookmark,
                              color: Color(0XFFFF6B00),
                              size: 40,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${communitiesVariables.planChoosingInitialData.value.response[index].discount}%",
                                  style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                                Text(
                                  "OFF",
                                  style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w800, color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          }),
    );
  }

  Widget bottomRulesWidgets({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              "${communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].subscriptionPeriod} subscription",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(16), color: const Color(0XFF2C2C2C)),
            ),
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height / 144.3),
                child: const Icon(
                  Icons.circle,
                  color: Colors.black,
                  size: 12,
                ),
              ),
              SizedBox(
                width: width / 41.1,
              ),
              const Expanded(
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipi scing elit, sedsedsed dododo eiusmod tempor incididunt ut labore  incididunt "),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height / 144.3),
                child: const Icon(
                  Icons.circle,
                  color: Colors.black,
                  size: 12,
                ),
              ),
              SizedBox(
                width: width / 41.1,
              ),
              const Expanded(
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipi scing elit, sedsedsed dododo eiusmod tempor incididunt ut labore  incididunt "),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height / 144.3),
                child: const Icon(
                  Icons.circle,
                  color: Colors.black,
                  size: 12,
                ),
              ),
              SizedBox(
                width: width / 41.1,
              ),
              const Expanded(
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipi scing elit, sedsedsed dododo eiusmod tempor incididunt ut labore  incididunt "),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
        ],
      ),
    );
  }

  Widget paymentOptionsWidget({required BuildContext context, required List<Map<String, dynamic>> list}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 0, color: const Color(0XFF000000).withOpacity(0.15), offset: const Offset(0, 0))]),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                //paymentChoosingFunctions.stripeMakePayment();
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(width: 1, color: const Color(0XFFF4F4F4))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: height / 34.64,
                              width: width / 16.44,
                              child:
                                  list[index]["image"].contains(".png") ? Image.asset(list[index]["image"]) : SvgPicture.asset(list[index]["image"])),
                          SizedBox(
                            width: width / 27.4,
                          ),
                          Text(
                            list[index]["name"],
                            style: TextStyle(fontSize: text.scale(14), color: const Color(0XFF414141)),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
