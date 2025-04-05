import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/OnBoarding/on_boarding_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class PrivacyPage extends StatefulWidget {
  final bool fromWhere;

  const PrivacyPage({Key? key, required this.fromWhere}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool value = false;
  bool value1 = false;

  userInsightFunc({required String typeData, required String aliasData}) async {
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    await http.post(
      url,
      body: {"alias": aliasData, "type": typeData},
    );
  }

  @override
  void initState() {
    getAllDataMain(name: 'Privacy_Policy_Page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 50.75,
            ),
            Text(
              "One more thing before you start",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(
              height: height / 50.75,
            ),
            SvgPicture.asset(
              isDarkTheme.value ? "assets/splash_screen/logo_dark.svg" : "assets/splash_screen/logo_light.svg",
              height: height / 4.06,
              width: width / 1.875,
            ),
            SizedBox(
              height: height / 23.88,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: const Color(0XFF0EA102),
                  value: value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.value = value!;
                    });
                  },
                ),
                SizedBox(
                  width: width / 1.4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "I understand Trade watch is not a financial advisor and I need to make my own research before investing.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ]),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: const Color(0XFF0EA102),
                  value: value1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (value) {
                    setState(() {
                      value1 = value!;
                    });
                  },
                ),
                SizedBox(
                  width: width / 1.4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "I confirm that I have read, consent & agree to Trade watch ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const DemoView(), arguments: {
                                  "id": "",
                                  "type": "news",
                                  "url": "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247"
                                });
                              },
                            text: "Terms & Conditions, ",
                            style: TextStyle(
                                fontSize: text.scale(14), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const DemoView(),
                                    arguments: {"id": "", "type": "news", "url": "https://www.tradewatch.in/company/privacy-policy"});
                              },
                            text: "Privacy Policy ",
                            style: TextStyle(
                                fontSize: text.scale(14), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const DemoView(), arguments: {
                                  "id": "",
                                  "type": "news",
                                  "url": "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2"
                                });
                              },
                            text: "& Cookie policy ",
                            style: TextStyle(
                                fontSize: text.scale(14), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                          ),
                          TextSpan(
                            text:
                                "and I am of legal age. I understand that I can change my communication preference any time in my trade watch account",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ]),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: height / 25.375,
            ),
            GestureDetector(
              onTap: () async {
                if (value != true || value1 != true) {
                  Flushbar(
                    message: "Please check the terms & condition checkboxes",
                    duration: const Duration(seconds: 2),
                  ).show(context);
                } else {
                  if (Platform.isIOS) {
                    IosDeviceInfo iosDeviceInfo = await functionsMain.deviceInfo.iosInfo;
                    functionsMain.deviceId = iosDeviceInfo.identifierForVendor!;
                    await functionsMain.checkDeviceFunc();
                  } else {
                    AndroidDeviceInfo androidDeviceInfo = await functionsMain.deviceInfo.androidInfo;
                    functionsMain.deviceId = androidDeviceInfo.id;
                    await functionsMain.checkDeviceFunc();
                  }
                  bool privacyAccept = true;
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('privacyAccept', privacyAccept);
                  logEventFunc(name: 'Policies_Accepted', type: 'Privacy');
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const OnBoardingScreen()));
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0XFF0EA102),
                ),
                height: height / 14.5,
                child: const Center(
                  child: Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: "Poppins"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
