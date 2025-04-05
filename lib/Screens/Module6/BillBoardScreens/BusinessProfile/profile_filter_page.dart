import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BillBoard/content_filter_page.dart';

class ProfileFilterPage extends StatefulWidget {
  const ProfileFilterPage({Key? key}) : super(key: key);

  @override
  State<ProfileFilterPage> createState() => _ProfileFilterPageState();
}

class _ProfileFilterPageState extends State<ProfileFilterPage> {
  bool loader = false;
  List<BottomListModel> sortType = [
    BottomListModel(name: "Recent", tag: "recent"),
    BottomListModel(name: "Most Liked", tag: "most_liked"),
    BottomListModel(name: "Most Disliked", tag: "most_disliked"),
    BottomListModel(name: "Most Response", tag: "most_response"),
    BottomListModel(name: "Most Share", tag: "most_share"),
  ];
  List<Widget> sortTypeImages = [];
  List<BottomListModel> sentimentType = [
    BottomListModel(name: "All", tag: "all"),
    BottomListModel(name: "Positive", tag: "positive"),
    BottomListModel(name: "Negative", tag: "negative"),
  ];
  List<Widget> sentimentTypeImages = [];
  String selectedSortType = "";
  String selectedSentiment = "";
  String previousSelectedSortType = "";
  String previousSelectedSentiment = "";
  List<String> sortTypeNameList = [];
  List<String> sortTypeTagList = [];
  List<String> sentimentNameList = [];
  List<String> sentimentTagList = [];

  @override
  void initState() {
    getAllDataMain(name: 'Profile_Filter_Page');
    for (int i = 0; i < sortType.length; i++) {
      sortTypeNameList.add(sortType[i].name);
      sortTypeTagList.add(sortType[i].tag);
    }
    for (int i = 0; i < sentimentType.length; i++) {
      sentimentNameList.add(sentimentType[i].name);
      sentimentTagList.add(sentimentType[i].tag);
    }
    selectedSortType = mainVariables.sortTypeMain.value == "" ? selectedSortType : mainVariables.sortTypeMain.value;
    previousSelectedSortType = selectedSortType;
    selectedSentiment = mainVariables.sentimentTypeMain.value == "" ? selectedSentiment : mainVariables.sentimentTypeMain.value;
    previousSelectedSentiment = selectedSentiment;
    setState(() {
      loader = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
      body: loader
          ? Container(
              height: height,
              width: width,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.all(height / 54.125),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (!mounted) {
                                  return;
                                }
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black26,
                              )),
                          SizedBox(
                            width: width / 27.4,
                          ),
                          Text(
                            "Filter",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF383838)),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mainVariables.sortTypeMain.value = "";
                            mainVariables.sentimentTypeMain.value = "";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.restart_alt,
                              color: Colors.black26,
                            ),
                            SizedBox(
                              width: width / 82.2,
                            ),
                            Text(
                              "Reset",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFF383838)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 15,
                  ),
                  Text(
                    "Sort",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF383838)),
                  ),
                  SizedBox(
                    height: height / 61.85,
                  ),
                  InkWell(
                    onTap: () {
                      billboardWidgetsMain.filtersBottomSheet(
                          context: context,
                          checkBox: false,
                          imageList: [],
                          textList: sortType,
                          profile: false,
                          boolList: [],
                          selectedProfile: '',
                          heading: "Sort",
                          selectedIndex: sortTypeTagList.indexOf(selectedSortType),
                          newSetState: setState);
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0XFFDFDFDF), width: 1.5)),
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            mainVariables.sortTypeMain.value == "" ? "sort" : mainVariables.sortTypeMain.value,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: text.scale(12),
                                color: mainVariables.sortTypeMain.value == "" ? const Color(0XFFC3C3C3) : Colors.black),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Color(0XFFC3C3C3),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 36,
                  ),
                  Text(
                    "Date Range",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF383838)),
                  ),
                  SizedBox(
                    height: height / 61.85,
                  ),
                  InkWell(
                    onTap: () {
                      billboardWidgetsMain.filtersBottomSheetCalender(
                        context: context,
                        newSetState: setState,
                        heading: "Date Range",
                      );
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0XFFDFDFDF), width: 1.5)),
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                mainVariables.dateRangeMain.value == "" ? "Date Range" : mainVariables.dateRangeMain.value,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: text.scale(12),
                                    color: mainVariables.dateRangeMain.value == "" ? const Color(0XFFC3C3C3) : Colors.black),
                              )),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Color(0XFFC3C3C3),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 36,
                  ),
                  Text(
                    "Sentiment",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF383838)),
                  ),
                  SizedBox(
                    height: height / 61.85,
                  ),
                  InkWell(
                    onTap: () {
                      billboardWidgetsMain.filtersBottomSheet(
                          context: context,
                          checkBox: false,
                          imageList: [],
                          textList: sentimentType,
                          profile: true,
                          boolList: [],
                          selectedProfile: selectedSentiment,
                          heading: "Sentiments",
                          selectedIndex: sentimentTagList.indexOf(selectedSentiment),
                          newSetState: setState);
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0XFFDFDFDF), width: 1.5)),
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            mainVariables.sentimentTypeMain.value == "" ? "Sentiment" : mainVariables.sentimentTypeMain.value,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: text.scale(12),
                                color: mainVariables.sentimentTypeMain.value == "" ? const Color(0XFFC3C3C3) : Colors.black),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Color(0XFFC3C3C3),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 6.14,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 13.7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              mainVariables.sortTypeMain.value = previousSelectedSortType;
                              mainVariables.sentimentTypeMain.value = previousSelectedSentiment;
                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width / 10.275, vertical: height / 86.6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0XFFC1C1C1), width: 1),
                                  color: const Color(0XFFFFFFFF),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                "Cancel",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF0EA102)),
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width / 10.275, vertical: height / 86.6),
                              decoration: BoxDecoration(color: const Color(0XFF0EA102), borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                "Apply",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFFFFFFFF)),
                              ),
                            ))
                      ],
                    ),
                  )
                ]),
              ),
            )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
    ));
  }
}
