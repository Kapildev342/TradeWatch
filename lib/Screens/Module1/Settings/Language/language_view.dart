import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'language_list_model.dart';

class LanguageView extends StatefulWidget {
  final bool audio;

  const LanguageView({Key? key, required this.audio}) : super(key: key);

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final TextEditingController _searchController = TextEditingController();
  late LanguageListModel language;
  bool loader = false;
  int selectedIndex = 0;
  List<LanguageResponse> popularLanguageList = [];
  List<LanguageResponse> searchPopularLanguageList = [];
  List<LanguageResponse> allLanguageList = [];
  List<LanguageResponse> searchAllLanguageList = [];
  late LanguageResponse selectedResponse;
  String selectedLanguage = "";

  @override
  void initState() {
    getAllDataMain(name: 'Language_Page');
    pageVisitFunc(pageName: 'settings');
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      loader = false;
    });
    language = await languageMain.getData(type: widget.audio ? 'audio' : 'text');
    for (int i = 0; i < language.limit; i++) {
      popularLanguageList.add(language.response[i]);
      searchPopularLanguageList.add(language.response[i]);
    }
    for (int j = language.limit; j < language.response.length; j++) {
      allLanguageList.add(language.response[j]);
      searchAllLanguageList.add(language.response[j]);
    }
    String defaultLanguage = language.defaultLanguage == ""
        ? widget.audio
            ? 'en-IN'
            : 'en'
        : language.defaultLanguage;
    selectedResponse = language.response.firstWhere((e) => e.code == defaultLanguage);
    selectedLanguage = selectedResponse.name;
    setState(() {
      loader = true;
    });
  }

  void filterSearchResults({required String query}) {
    if (query.isEmpty) {
      setState(() {
        searchPopularLanguageList = popularLanguageList.toList();
        searchAllLanguageList = allLanguageList.toList();
      });
    } else {
      setState(() {
        searchPopularLanguageList = popularLanguageList.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
        searchAllLanguageList = allLanguageList.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
      // backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        //backgroundColor: const Color(0XFFFFFFFF),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          widget.audio ? 'Audio Translation' : 'Language Translation',
          style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
        ),
        leading: GestureDetector(
            onTap: () {
              if (!mounted) {
                return;
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: width / 20.55),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )),
      ),
      body: loader
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: width / 27.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height / 54.125,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Default Translated",
                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedLanguage,
                            style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.keyboard_arrow_down_outlined)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 28.86,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      filterSearchResults(query: value);
                    },
                    cursorColor: Colors.green,
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: _searchController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: width / 27.4),
                      prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg")),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  filterSearchResults(query: "");
                                });
                              },
                              child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                            )
                          : const SizedBox(),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                      hintText: 'Search here',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 28.86,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: searchPopularLanguageList.isEmpty && searchAllLanguageList.isEmpty
                          ? SizedBox(
                              height: height / 1.5,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: height / 5.77,
                                        width: width / 2.74,
                                        child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                    SizedBox(height: height / 57.73),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Unfortunately, there is nothing to display!',
                                              style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                searchPopularLanguageList.isEmpty
                                    ? const SizedBox()
                                    : Text(
                                        'Popular Languages',
                                        style: TextStyle(
                                            fontSize: text.scale(16),
                                            color: const Color(0XFF4B4B4B),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins"),
                                      ),
                                searchPopularLanguageList.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 54.125,
                                      ),
                                searchPopularLanguageList.isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: searchPopularLanguageList.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (BuildContext context, int index) {
                                          return RadioListTile(
                                              title: Text(searchPopularLanguageList[index].name),
                                              controlAffinity: ListTileControlAffinity.trailing,
                                              value: searchPopularLanguageList[index],
                                              groupValue: selectedResponse,
                                              selected: selectedResponse == searchPopularLanguageList[index],
                                              onChanged: (value) {
                                                selectedResponse = searchPopularLanguageList[index];
                                                widgetsMain
                                                    .languagePopUp(
                                                        context: context, response: selectedResponse, type: widget.audio ? 'audio' : 'text')
                                                    .then((value) {
                                                  setState(() {
                                                    selectedLanguage = searchPopularLanguageList[index].name;
                                                  });
                                                });
                                              });
                                        }),
                                searchPopularLanguageList.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 28.86,
                                      ),
                                searchAllLanguageList.isEmpty
                                    ? const SizedBox()
                                    : Text(
                                        'All Languages',
                                        style: TextStyle(
                                            fontSize: text.scale(16),
                                            color: const Color(0XFF4B4B4B),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins"),
                                      ),
                                searchAllLanguageList.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 54.125,
                                      ),
                                searchAllLanguageList.isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: searchAllLanguageList.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (BuildContext context, int index) {
                                          return RadioListTile(
                                              title: Text(searchAllLanguageList[index].name),
                                              controlAffinity: ListTileControlAffinity.trailing,
                                              value: searchAllLanguageList[index],
                                              groupValue: selectedResponse,
                                              selected: selectedResponse == searchAllLanguageList[index],
                                              onChanged: (value) {
                                                selectedResponse = searchAllLanguageList[index];
                                                widgetsMain
                                                    .languagePopUp(
                                                        context: context, response: selectedResponse, type: widget.audio ? 'audio' : 'text')
                                                    .then((value) {
                                                  setState(() {
                                                    selectedLanguage = searchAllLanguageList[index].name;
                                                  });
                                                });
                                              });
                                        }),
                                searchAllLanguageList.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 54.125,
                                      ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
    ));
  }
}
