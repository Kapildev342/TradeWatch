import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class PaymentChoosingPage extends StatefulWidget {
  const PaymentChoosingPage({super.key});

  @override
  State<PaymentChoosingPage> createState() => _PaymentChoosingPageState();
}

class _PaymentChoosingPageState extends State<PaymentChoosingPage> {
  List<Map<String, dynamic>> bankingOption = [
    {"name": "Credit & Debit Cards", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/cards.svg"},
    {"name": "Net Banking", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/net_banking.svg"}
  ];
  List<Map<String, dynamic>> upiOption = Platform.isIOS
      ? [
          {"name": "Google Pay", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/gpay.png"},
          {"name": "Phone Pay", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/phone_pe.png"},
          {"name": "Apple Pay", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/apple-pay.png"}
        ]
      : [
          {"name": "Google Pay", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/gpay.png"},
          {"name": "Phone Pay", "image": "lib/Constants/Assets/NewAssets/CommunitiesScreen/phone_pe.png"}
        ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Choose Payment Option",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20), color: const Color(0XFF2C2C2C)),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: width / 13.7, vertical: height / 28.86),
                padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].initialColor,
                        communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].endColor
                      ],
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 173.2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0XFFFF6B00),
                          ),
                          child: Text(
                            "${communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].discount}% Discount",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(10), color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/subscribe_crown.svg",
                      colorFilter: const ColorFilter.mode(Color(0XFFFFCA00), BlendMode.srcIn),
                      height: height / 11.54,
                      width: width / 5.48,
                    ),
                    SizedBox(height: height / 86.6),
                    Text(
                      communitiesVariables
                          .planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].subscriptionPeriod,
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: text.scale(24), color: const Color(0XFFFFFFFF)),
                    ),
                    SizedBox(
                      height: height / 173.2,
                    ),
                    Text(
                      "\u{20B9} ${communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].paymentAmount}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: text.scale(20), color: Colors.white70, decoration: TextDecoration.lineThrough),
                    ),
                    SizedBox(
                      height: height / 173.2,
                    ),
                    Text(
                      "\u{20B9} ${(communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].paymentAmount - (communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].paymentAmount * communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].discount / 100)).toStringAsFixed(2)}",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20), color: const Color(0XFFFFFFFF)),
                    ),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Text(
                      "${communitiesVariables.planChoosingInitialData.value.response[communitiesVariables.chosenSubscriptionPlan.value].trailPeriod} days Free Trail ",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFFFFFFFF)),
                    ),
                  ],
                ),
              ),
              Text(
                "Banking Options",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF2C2C2C)),
              ),
              SizedBox(
                height: height / 57.73,
              ),
              paymentWidgets.paymentOptionsWidget(context: context, list: bankingOption),
              SizedBox(
                height: height / 57.73,
              ),
              Text(
                "UPI",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF2C2C2C)),
              ),
              SizedBox(
                height: height / 57.73,
              ),
              paymentWidgets.paymentOptionsWidget(context: context, list: upiOption),
            ],
          ),
        ),
      ),
    );
  }
}
