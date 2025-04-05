import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/Payment/payment_choosing_page.dart';

class PlanChoosingPage extends StatefulWidget {
  const PlanChoosingPage({super.key});

  @override
  State<PlanChoosingPage> createState() => _PlanChoosingPageState();
}

class _PlanChoosingPageState extends State<PlanChoosingPage> {
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
            "Subscription",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20), color: const Color(0XFF2C2C2C)),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SvgPicture.asset(
                    "lib/Constants/Assets/NewAssets/CommunitiesScreen/plan_choosing_crown.svg",
                    width: width,
                  ),
                  Text(
                    "Choose Your Plan",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20), color: const Color(0XFF2C2C2C)),
                  ),
                ],
              ),
              SizedBox(
                height: height / 57.73,
              ),
              Center(
                child: SizedBox(
                  width: width / 1.2,
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore  incididunt ut labore ut labore  incididunt ut labore .",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(10), color: const Color(0XFF545151)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: height / 57.73,
              ),
              paymentWidgets.planGridWidgets(context: context),
              SizedBox(
                height: height / 57.73,
              ),
              paymentWidgets.bottomRulesWidgets(context: context),
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const PaymentChoosingPage();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: height / 108.25, horizontal: width / 4.11),
                    padding: EdgeInsets.symmetric(vertical: height / 108.25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const RadialGradient(
                        radius: 5,
                        colors: [Color(0XFFEDA130), Color(0XFFFFD361)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: height / 108.25),
                          child: SvgPicture.asset(
                            "lib/Constants/Assets/NewAssets/CommunitiesScreen/subscribe_crown.svg",
                            height: height / 34.64,
                            width: width / 16.44,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: width / 27.4,
                        ),
                        Text(
                          "Subscribe",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: Colors.white),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: height / 57.73,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
