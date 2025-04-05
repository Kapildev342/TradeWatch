import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class ContentFilterPage extends StatefulWidget {
  const ContentFilterPage({Key? key}) : super(key: key);

  @override
  State<ContentFilterPage> createState() => _ContentFilterPageState();
}

class _ContentFilterPageState extends State<ContentFilterPage> {
  bool loader = false;
  List<BottomListModel> categories = [
    BottomListModel(name: "General", tag: "general"),
    BottomListModel(name: "Stocks", tag: "stocks"),
    BottomListModel(name: "Crypto", tag: "crypto"),
    BottomListModel(name: "Commodity", tag: "commodity"),
    BottomListModel(name: "Forex", tag: "forex"),
  ];
  List<Widget> categoriesImages = [
    Image.asset(isDarkTheme.value ? "assets/settings/general_icon.png" : "lib/Constants/Assets/BillBoard/FilterPage/General.png"),
    Image.asset(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_stocks_dark.png"
        : "lib/Constants/Assets/BillBoard/FilterPage/stocks.png"),
    Image.asset(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_crypto_dark.png"
        : "lib/Constants/Assets/BillBoard/FilterPage/cyrpto.png"),
    Image.asset(isDarkTheme.value
        ? "lib/Constants/Assets/NewAssets/HomeScreen/home_commodity_dark.png"
        : "lib/Constants/Assets/BillBoard/FilterPage/commodity.png"),
    Image.asset(
        isDarkTheme.value ? "lib/Constants/Assets/NewAssets/HomeScreen/home_forex.dark.png" : "lib/Constants/Assets/BillBoard/FilterPage/forex.png"),
  ];
  List<bool> boolList = List.generate(5, (index) => false);
  List<BottomListModel> contentType = [
    BottomListModel(name: "Bytes", tag: "byte"),
    BottomListModel(name: "Blog", tag: "blog"),
    BottomListModel(name: "Survey", tag: "survey"),
    BottomListModel(name: "Forum", tag: "forum"),
  ];
  List<Widget> contentTypeImages = [
    Image.asset(isDarkTheme.value ? "assets/settings/bytes.png" : "lib/Constants/Assets/BillBoard/FilterPage/Bytes.png"),
    Image.asset(isDarkTheme.value ? "assets/settings/blog.png" : "lib/Constants/Assets/BillBoard/FilterPage/Blog.png"),
    Image.asset(isDarkTheme.value ? "assets/settings/survey.png" : "lib/Constants/Assets/BillBoard/FilterPage/surveyImage.png"),
    Image.asset(isDarkTheme.value ? "assets/settings/terms.png" : "lib/Constants/Assets/BillBoard/FilterPage/Bytes.png"),
  ];
  List<BottomListModel> profileType = [
    BottomListModel(name: "Business Profile +", tag: "buisness"),
    BottomListModel(name: "User Profile +", tag: "user"),
    BottomListModel(name: "Intermediary Profile +", tag: "intermediate"),
  ];
  List<Widget> profileTypeImages = [
    Image.asset(isDarkTheme.value ? "assets/settings/business.png" : "lib/Constants/Assets/BillBoard/FilterPage/business_profile.png"),
    Image.asset(isDarkTheme.value ? "assets/settings/user.png" : "lib/Constants/Assets/BillBoard/FilterPage/user_profile.png"),
    Image.asset(isDarkTheme.value ? "assets/settings/user.png" : "lib/Constants/Assets/BillBoard/FilterPage/user_profile.png"),
  ];
  String selectedContentType = "";
  String selectedProfile = "";
  List<String> previousSelectedCategories = [];
  String previousSelectedContentType = "";
  String previousSelectedProfile = "";
  List<String> categoriesNameList = [];
  List<String> categoriesTagList = [];
  List<String> contentTypeNameList = [];
  List<String> contentTypeTagList = [];
  List<String> profileTypeNameList = [];
  List<String> profileTypeTagList = [];

  @override
  void initState() {
    for (int i = 0; i < categories.length; i++) {
      categoriesNameList.add(categories[i].name);
      categoriesTagList.add(categories[i].tag);
    }
    for (int i = 0; i < contentType.length; i++) {
      contentTypeNameList.add(contentType[i].name);
      contentTypeTagList.add(contentType[i].tag);
    }
    for (int i = 0; i < profileType.length; i++) {
      profileTypeNameList.add(profileType[i].name);
      profileTypeTagList.add(profileType[i].tag);
    }
    if (mainVariables.contentCategoriesMain.isNotEmpty) {
      previousSelectedCategories.addAll(mainVariables.contentCategoriesMain);
      for (int i = 0; i < mainVariables.contentCategoriesMain.length; i++) {
        int matchedIndex = categoriesTagList.indexOf(mainVariables.contentCategoriesMain[i]);
        boolList[matchedIndex] = true;
      }
    }
    selectedContentType = mainVariables.contentTypeMain.value == "" ? selectedContentType : mainVariables.contentTypeMain.value;
    previousSelectedContentType = selectedContentType;
    selectedProfile = mainVariables.selectedProfileMain.value == "" ? selectedProfile : mainVariables.selectedProfileMain.value;
    previousSelectedProfile = selectedProfile;
    getAllDataMain(name: "Content_Filter_Page");
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
    return WillPopScope(
      onWillPop: () async {
        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>MainBottomNavigationPage(caseNo1: 2, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: loader
            ? Container(
                height: height,
                width: width,
                color: Theme.of(context).colorScheme.background,
                child: Container(
                  margin: EdgeInsets.all(height / 54.125),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      height: height / 19.24,
                    ),
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
                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>MainBottomNavigationPage(caseNo1: 2, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                )),
                            SizedBox(
                              width: width / 27.4,
                            ),
                            Text(
                              "Filter",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall, /*TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF383838)),*/
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              mainVariables.contentCategoriesMain.clear();
                              mainVariables.contentTypeMain.value = "";
                              mainVariables.selectedProfileMain.value = "user";
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restart_alt,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 25,
                              ),
                              SizedBox(
                                width: width / 82.2,
                              ),
                              Text(
                                "Reset",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium, /*TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFF383838)),*/
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
                      "Content Categories",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall, /*TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF383838)),*/
                    ),
                    SizedBox(
                      height: height / 61.85,
                    ),
                    InkWell(
                      onTap: () {
                        billboardWidgetsMain.filtersBottomSheet(
                            context: context,
                            checkBox: true,
                            imageList: categoriesImages,
                            textList: categories,
                            profile: false,
                            boolList: boolList,
                            selectedProfile: '',
                            heading: "Content Categories",
                            selectedIndex: 0,
                            newSetState: setState);
                      },
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0XFFDFDFDF), width: 0.1)),
                        padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              mainVariables.contentCategoriesMain.isEmpty
                                  ? "Content Categories"
                                  : mainVariables.contentCategoriesMain.length > 1
                                      ? "Multiple Selected"
                                      : mainVariables.contentCategoriesMain.first.toString().capitalizeFirst!,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: mainVariables.contentCategoriesMain.isEmpty
                                      ? const Color(0XFFC3C3C3)
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary) /*TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: text.scale(12),
                                  color: mainVariables.contentCategoriesMain.isEmpty ? const Color(0XFFC3C3C3) : Colors.black)*/
                              ,
                            ),
                            Icon(Icons.keyboard_arrow_down_sharp, color: Theme.of(context).colorScheme.onPrimary /*Color(0XFFC3C3C3),*/
                                )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    Text(
                      "Content types",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall, /*TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF383838)),*/
                    ),
                    SizedBox(
                      height: height / 61.85,
                    ),
                    InkWell(
                      onTap: () {
                        billboardWidgetsMain.filtersBottomSheet(
                            context: context,
                            checkBox: false,
                            imageList: contentTypeImages,
                            textList: contentType,
                            profile: false,
                            boolList: [],
                            selectedProfile: '',
                            heading: "Content types",
                            selectedIndex: contentTypeTagList.indexOf(selectedContentType),
                            newSetState: setState);
                      },
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0XFFDFDFDF), width: 0.1)),
                        padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                mainVariables.contentTypeMain.value == ""
                                    ? "Content types"
                                    : mainVariables.contentTypeMain.value.toString().capitalizeFirst!,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: mainVariables.contentTypeMain.value == ""
                                        ? const Color(0XFFC3C3C3)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary) /*TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: text.scale(12),
                                  color: mainVariables.contentTypeMain.value == "" ? const Color(0XFFC3C3C3) : Colors.black),*/
                                ),
                            Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).colorScheme.onPrimary /*Color(0XFFC3C3C3)*/,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    Text(
                      "Select profile",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall, /*TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF383838)),*/
                    ),
                    SizedBox(
                      height: height / 61.85,
                    ),
                    InkWell(
                      onTap: () {
                        selectedProfile = mainVariables.selectedProfileMain.value;
                        billboardWidgetsMain.filtersBottomSheet(
                            context: context,
                            checkBox: false,
                            imageList: profileTypeImages,
                            textList: profileType,
                            profile: true,
                            boolList: [],
                            selectedProfile: selectedProfile,
                            heading: "Select profile",
                            selectedIndex: profileTypeTagList.indexOf(selectedProfile),
                            newSetState: setState);
                      },
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0XFFDFDFDF), width: 0.1)),
                        padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              mainVariables.selectedProfileMain.value == ""
                                  ? "Select profile"
                                  : mainVariables.selectedProfileMain.value == "intermediate"
                                      ? profileType[2].name
                                      : mainVariables.selectedProfileMain.value == "user"
                                          ? profileType[1].name
                                          : profileType[0].name,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: mainVariables.selectedProfileMain.value == ""
                                      ? const Color(0XFFC3C3C3)
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary) /*TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: text.scale(12),
                                  color: mainVariables.selectedProfileMain.value == "" ? const Color(0XFFC3C3C3) : Colors.black)*/
                              ,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).colorScheme.onPrimary /*Color(0XFFC3C3C3)*/,
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
                                if (mainVariables.contentCategoriesMain.isNotEmpty) {
                                  mainVariables.contentCategoriesMain.clear();
                                  mainVariables.contentCategoriesMain.addAll(previousSelectedCategories);
                                } else {
                                  mainVariables.contentCategoriesMain.clear();
                                }
                                mainVariables.contentTypeMain.value = previousSelectedContentType;
                                mainVariables.selectedProfileMain.value = previousSelectedProfile;
                                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>MainBottomNavigationPage(caseNo1: 2, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
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
                                logEventFunc(name: "Content_Filter_Created", type: "BillBoard");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => const MainBottomNavigationPage(
                                            caseNo1: 2,
                                            text: "stocks",
                                            excIndex: 1,
                                            newIndex: 0,
                                            countryIndex: 0,
                                            isHomeFirstTym: false,
                                            tType: true)));
                                // if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
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
      ),
    );
  }
}

class BottomListModel {
  final String name;
  final String tag;

  BottomListModel({required this.name, required this.tag});
}
