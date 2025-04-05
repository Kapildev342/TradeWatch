import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'on_boarding_screen_initial_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  PageController _controller = PageController();
  Map<String, dynamic> initialData = {
    "response": [
      {
        "topic": "Top Trending",
        "description":
            "Stay informed with the 'Top Trending'. It reveals the day's top 20 companies, with their performance updated every 30 minutes for the latest market movements.",
        "imageUrl": "lib/Constants/Assets/NewAssets/OnBoardingScreen/onBoarding_topTrending.png"
      },
      {
        "topic": "Locker",
        "description": "Unlock instant market insights, detailed charts, and community wisdom with 'Locker' – your quick link in one spot.",
        "imageUrl": "lib/Constants/Assets/NewAssets/OnBoardingScreen/onBoarding_Locker.png"
      },
      {
        "topic": "Watchlist",
        "description": "Effortlessly oversee your portfolio. Get alerts and updates with 'Watchlist'—your investment companion.",
        "imageUrl": "lib/Constants/Assets/NewAssets/OnBoardingScreen/onBoarding_watchList.png"
      },
      {
        "topic": "Charts",
        "description": "Equip yourself with advanced charting capabilities and in-depth technical indicators tailored for strategic analysis.",
        "imageUrl": "lib/Constants/Assets/NewAssets/OnBoardingScreen/onBoarding_charts.png"
      },
      {
        "topic": "Profile +",
        "description":
            "Join the traders' network with 'Profile+'. Engage with posts, get market wisdom, and share your perspective with a community that trades smarter together.",
        "imageUrl": "lib/Constants/Assets/NewAssets/OnBoardingScreen/onBoarding_profile.png"
      },
      {
        "topic": "Feature Request",
        "description": "Have a feature in mind? Propose it and let the community vote. Popular features are built to enhance your experience.",
        "imageUrl": "lib/Constants/Assets/NewAssets/OnBoardingScreen/onBoarding_feature.png"
      }
    ]
  };
  OnBoardingScreenInitialData? onBoardingScreenInitialData;

  @override
  void initState() {
    getAllDataMain(name: 'On_Boarding_Screen');
    onBoardingScreenInitialData = OnBoardingScreenInitialData.fromJson(initialData);
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle textStyle({required String type, required BuildContext context}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    switch (type) {
      case "heading":
        {
          //return TextStyle(fontSize: text.scale(24), fontWeight: FontWeight.w600, color: const Color(0XFF2A2828));
          return Theme.of(context).textTheme.titleLarge!;
        }
      case "description":
        {
          //return TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFF2A2828));
          return Theme.of(context).textTheme.bodyMedium!;
        }
      default:
        {
          // return TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: Colors.black);
          return Theme.of(context).textTheme.bodyMedium!;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
            //backgroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("lib/Constants/Assets/NewAssets/OnBoardingScreen/tt_bg.png"))),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 86.6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                        onPressed: currentIndex == onBoardingScreenInitialData!.response.length - 1
                            ? () {}
                            : () {
                                _controller.jumpToPage(onBoardingScreenInitialData!.response.length - 1);
                              },
                        child: Text(currentIndex == onBoardingScreenInitialData!.response.length - 1 ? "" : "Skip",
                            style: TextStyle(color: const Color(0XFFA2A2A2), fontSize: text.scale(14))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Expanded(
                    child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _controller,
                        onPageChanged: (value) {
                          setState(() {
                            currentIndex = value;
                          });
                        },
                        itemCount: onBoardingScreenInitialData!.response.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  onBoardingScreenInitialData!.response[index].topic,
                                  style: textStyle(type: "heading", context: context),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                    width: width / 1.096,
                                    child: Text(
                                      onBoardingScreenInitialData!.response[index].description,
                                      style: textStyle(type: "description", context: context),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                              Center(
                                child: SizedBox(
                                    height: height / 1.732,
                                    width: width / 1.644,
                                    child: Image.asset(
                                      onBoardingScreenInitialData!.response[index].imageUrl,
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: height / 24.74,
                  ),
                  Container(
                      height: height / 15.74,
                      width: width,
                      color: Theme.of(context).colorScheme.onTertiary, //const Color(0XFF02A155).withOpacity(0.8),
                      child: Stack(alignment: Alignment.centerRight, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onBoardingScreenInitialData!.response.length,
                            (index) {
                              return Container(
                                height: height / 108.25,
                                width: width / 51.375,
                                margin: EdgeInsets.only(right: width / 82.2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: currentIndex == index ? Colors.white : const Color(0XFF018445),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width / 27.4),
                          child: TextButton(
                            style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                            onPressed: () {
                              if (currentIndex == onBoardingScreenInitialData!.response.length - 1) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainBottomNavigationPage(
                                          caseNo1: 0, text: 'stocks', excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: true, tType: true)),
                                );
                              } else {
                                _controller.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
                              }
                            },
                            child: Text(currentIndex == onBoardingScreenInitialData!.response.length - 1 ? "Get started" : "Next",
                                style: TextStyle(color: Colors.white, fontSize: text.scale(12))),
                          ),
                        ),
                      ])),
                ],
              ),
            )));
  }
}
