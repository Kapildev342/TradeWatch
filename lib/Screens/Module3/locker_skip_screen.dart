import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class LockerSkipScreen extends StatefulWidget {
  final String? navBool;
  final String? category;
  final String? id;
  final String? toWhere;
  final String? fromWhere;

  const LockerSkipScreen({Key? key, this.navBool = "", this.category = "", this.id = "", this.toWhere = "", this.fromWhere}) : super(key: key);

  @override
  State<LockerSkipScreen> createState() => _LockerSkipScreenState();
}

class _LockerSkipScreenState extends State<LockerSkipScreen> {
  List<AssetImage> assetList = [
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/News.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Compare.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Videos.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Forum.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Survey.png"),
    const AssetImage("lib/Constants/Assets/SMLogos/LockerScreen/Brokers.png"),
  ];

  List titleList = [
    "News",
    "Compare",
    "Videos",
    "Forum",
    "Survey",
    "Brokers",
  ];

  @override
  void initState() {
    getAllDataMain(name: 'Skipped_User_Locker_Page');
    super.initState();
  }

  getAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mainSkipDialogue(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return const MainBottomNavigationPage(
              caseNo1: 1, text: 'Stocks', excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: true, tType: true);
        }));
        return false;
      },
      child: Container(
        // color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
              //backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height / 16.24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return const MainBottomNavigationPage(
                                      caseNo1: 1, text: 'Stocks', excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: true, tType: true);
                                }));
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 25,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          isDarkTheme.value ? "assets/splash_screen/logo_text_dark.svg" : "assets/splash_screen/logo_text_light.svg",
                          width: width / 1.86,
                          height: height / 19.24,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    SizedBox(height: height / 50.75),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                      child: Image.asset(
                        "lib/Constants/Assets/SMLogos/SkipPage/skipPopImage.png",
                      ),
                    ),
                    SizedBox(height: height / 32.48),
                    const Center(
                        child: Text(
                      "Trade communication made easy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, fontFamily: "Poppins"),
                    )),
                    SizedBox(height: height / 50.75),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 18.75),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Powerful alone. Even better together. ",
                              style: TextStyle(
                                  fontSize: text.scale(13), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                          TextSpan(
                            text:
                                "Join one of the fastest-growing social trading community and engage with other traders and get access to exclusive member-only features like news, videos, forums, and surveys published by other traders.",
                            style: TextStyle(fontSize: text.scale(13), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: height / 32.48),
                    const Center(
                        child: Text(
                      "Join the community today and never miss an insight.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0XFF0EA102), fontWeight: FontWeight.w400, fontSize: 13, fontFamily: "Poppins"),
                    )),
                    SizedBox(height: height / 32.48),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return SignInPage(
                            navBool: widget.navBool,
                            id: widget.id,
                            category: widget.category,
                            toWhere: widget.toWhere,
                            fromWhere: widget.fromWhere,
                          );
                        }));
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
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 32.48),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
