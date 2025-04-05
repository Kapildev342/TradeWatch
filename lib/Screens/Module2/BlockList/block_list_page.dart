import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class BlockListPage extends StatefulWidget {
  final bool blockBool;
  final int tabIndex;
  final bool fromLink;

  const BlockListPage({Key? key, required this.blockBool, required this.tabIndex, this.fromLink = false}) : super(key: key);

  @override
  State<BlockListPage> createState() => _BlockListPageState();
}

class _BlockListPageState extends State<BlockListPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabControllerMain;
  int selectIndex = 0;

  @override
  void initState() {
    getAllDataMain(name: 'My_Block_List_Page');
    _tabControllerMain = TabController(length: 2, vsync: this, initialIndex: widget.blockBool ? 0 : 1);
    selectIndex = widget.blockBool ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromLink) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                        text: '',
                        caseNo1: 0,
                        tType: true,
                        newIndex: 0,
                        excIndex: 1,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                      )));
        } else {
          /* if (!mounted) {
            return false;
          }*/
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
          //backgroundColor: const Color(0XFFFFFFFF),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            elevation: 0,
            //backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            automaticallyImplyLeading: false,
            toolbarHeight: height / 16.75,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (widget.fromLink) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => const MainBottomNavigationPage(
                                      text: '',
                                      caseNo1: 0,
                                      tType: true,
                                      newIndex: 0,
                                      excIndex: 1,
                                      countryIndex: 0,
                                      isHomeFirstTym: false,
                                    )));
                      } else {
                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    )),
                SizedBox(width: width / 46.8),
                Text(
                  "My Block List",
                  style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w700),
                ),
              ],
            ),
            bottom: TabBar(
                isScrollable: false,
                indicatorWeight: 2,
                controller: _tabControllerMain,
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.green,
                dividerColor: Colors.transparent,
                dividerHeight: 0.0,
                onTap: (int newIndex) async {
                  setState(() {
                    selectIndex = newIndex;
                  });
                },
                tabs: const [
                  Text(
                    "Userlist",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    "Postlist",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabControllerMain,
            physics: const ScrollPhysics(),
            children: [
              const UserList(),
              PostList(index: widget.tabIndex),
            ],
          )),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String mainUserToken = '';
  bool emptyBool = false;
  List<String> avatar = [];
  List<String> username = [];
  List<String> userid = [];
  bool loading = true;
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  blockList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + blockedList);
    var response = await http.post(
      url,
      headers: {'authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool = true;
        });
      } else {
        avatar.clear();
        username.clear();
        userid.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatar.add(responseData["response"][i]["avatar"]);
          username.add(responseData["response"][i]["username"]);
          userid.add(responseData["response"][i]["_id"]);
        }
        setState(() {
          emptyBool = false;
        });
      }
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        emptyBool = false;
        loading = false;
      });
    }
  }

  unblockUser({required String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + blockUnblock);
    var responseNew = await http.post(url, body: {"block_user": userId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockList();
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  void initState() {
    blockList();
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      // backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height / 50.75, horizontal: width / 25),
          child: loading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg", width: 150),
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        right: width / 23.43,
                        left: width / 23.43,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: username.length,
                          itemBuilder: (context, index) {
                            if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                              return Column(
                                children: [
                                  Container(
                                      height: height / 9.10,
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                      child: AdWidget(ad: nativeAdList[index])),
                                  SizedBox(height: height / 57.73),
                                  Container(
                                    margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                          Container(
                                            height: height / 15.03,
                                            width: width / 6.94,
                                            //margin: EdgeInsets.fromLTRB(_width/23.43, _height/203, _width/37.5, _height/27.06),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey,
                                                image: DecorationImage(image: NetworkImage(avatar[index]), fit: BoxFit.fill)),
                                          ),
                                          SizedBox(width: width / 23.43),
                                          Text(
                                            username[index],
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0xff000000)),
                                          ),
                                        ]),
                                        // SizedBox(width: _width/9.86),
                                        GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                    child: Container(
                                                      height: height / 6,
                                                      margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          const Center(
                                                              child: Text("Unblock User",
                                                                  style: TextStyle(
                                                                      color: Color(0XFF0EA102),
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 20,
                                                                      fontFamily: "Poppins"))),
                                                          const Divider(),
                                                          const Text("Are you sure to Unblock this User"),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    if (!mounted) {
                                                                      return;
                                                                    }
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Colors.grey,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFamily: "Poppins",
                                                                        fontSize: 15),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(18.0),
                                                                    ),
                                                                    backgroundColor: const Color(0XFF0EA102),
                                                                  ),
                                                                  onPressed: () async {
                                                                    if (!mounted) {
                                                                      return;
                                                                    }
                                                                    Navigator.pop(context);
                                                                    await unblockUser(userId: userid[index]);
                                                                  },
                                                                  child: const Text(
                                                                    "Continue",
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFamily: "Poppins",
                                                                        fontSize: 15),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Container(
                                            height: height / 29,
                                            width: width / 5.76,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xff0EA102),
                                              ),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Unblock",
                                                style:
                                                    TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                            return Container(
                              margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    Container(
                                      height: height / 15.03,
                                      width: width / 6.94,
                                      //margin: EdgeInsets.fromLTRB(_width/23.43, _height/203, _width/37.5, _height/27.06),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).colorScheme.tertiary,
                                          image: DecorationImage(image: NetworkImage(avatar[index]), fit: BoxFit.fill)),
                                    ),
                                    SizedBox(width: width / 23.43),
                                    Text(
                                      username[index],
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                    ),
                                  ]),
                                  // SizedBox(width: _width/9.86),
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                              child: Container(
                                                height: height / 6,
                                                margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Center(
                                                        child: Text("Unblock User",
                                                            style: TextStyle(
                                                                color: Color(0XFF0EA102),
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20,
                                                                fontFamily: "Poppins"))),
                                                    const Divider(),
                                                    const Text("Are you sure to Unblock this User"),
                                                    const Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0),
                                                              ),
                                                              backgroundColor: const Color(0XFF0EA102),
                                                            ),
                                                            onPressed: () async {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.pop(context);
                                                              await unblockUser(userId: userid[index]);
                                                            },
                                                            child: const Text(
                                                              "Continue",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      height: height / 29,
                                      width: width / 5.76,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff0EA102),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Unblock",
                                          style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
        ),
      ),
    );
  }
}

class PostList extends StatefulWidget {
  final int index;

  const PostList({Key? key, required this.index}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> with TickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this, initialIndex: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: TabBar(
              isScrollable: true,
              indicatorWeight: 2,
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.center,
              dividerColor: Colors.transparent,
              dividerHeight: 0.0,
              indicatorColor: Colors.green,
              splashFactory: NoSplash.splashFactory,
              tabs: const [
                Text(
                  "News",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "Videos",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "Forum",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "Survey",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "Feature Request",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "BillBoard",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ]),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const ScrollPhysics(),
        children: const [
          NewsList(),
          VideosList(),
          ForumList(),
          SurveyList(),
          FeatureList(),
          BillBoardList(),
        ],
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  bool emptyBool1 = true;
  String mainUserToken = '';
  bool tabBarLoading = true;
  List<String> avatarPostList = [];
  List<String> titlesPostList = [];
  List<String> idsPostList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  unblockPost({required String postId, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + unblockedPostList);
    var responseNew = await http.post(url, body: {"id": postId, "type": type}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockPostFunc(type: type);
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockPostFunc({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + blockedPostList);
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool1 = false;
          tabBarLoading = false;
        });
      } else {
        avatarPostList.clear();
        titlesPostList.clear();
        idsPostList.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatarPostList.add(responseData["response"][i]["image_url"]);
          titlesPostList.add(responseData["response"][i]["title"]);
          idsPostList.add(responseData["response"][i]["_id"]);
        }
        setState(() {
          tabBarLoading = false;
        });
      }
    } else {
      setState(() {
        tabBarLoading = false;
      });
    }
  }

  @override
  void initState() {
    blockPostFunc(
      type: 'news',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      // backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
          child: tabBarLoading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool1
                  ? ListView.builder(
                      itemCount: titlesPostList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: AdWidget(ad: nativeAdList[index])),
                              SizedBox(height: height / 57.73),
                              Container(
                                margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Container(
                                        height: height / 15.03,
                                        width: width / 6.94,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                      ),
                                      SizedBox(width: width / 23.43),
                                      SizedBox(
                                        width: width / 1.8,
                                        child: Text(
                                          titlesPostList[index],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        ),
                                      ),
                                    ]),
                                    // SizedBox(width: _width/9.86),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                child: Container(
                                                  height: height / 6,
                                                  margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Center(
                                                          child: Text("Unblock User",
                                                              style: TextStyle(
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  fontFamily: "Poppins"))),
                                                      const Divider(),
                                                      const Text("Are you sure to Unblock this User"),
                                                      const Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                ),
                                                                backgroundColor: const Color(0XFF0EA102),
                                                              ),
                                                              onPressed: () async {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                                await unblockPost(postId: idsPostList[index], type: "news");
                                                              },
                                                              child: const Text(
                                                                "Continue",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: height / 29,
                                        width: width / 5.76,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xff0EA102),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Unblock",
                                            style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Container(
                                  height: height / 15.03,
                                  width: width / 6.94,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                ),
                                SizedBox(width: width / 23.43),
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    titlesPostList[index],
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                  ),
                                ),
                              ]),
                              // SizedBox(width: _width/9.86),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                          child: Container(
                                            height: height / 6,
                                            margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Center(
                                                    child: Text("Unblock User",
                                                        style: TextStyle(
                                                            color: Color(0XFF0EA102),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            fontFamily: "Poppins"))),
                                                const Divider(),
                                                const Text("Are you sure to Unblock this User"),
                                                const Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                          backgroundColor: const Color(0XFF0EA102),
                                                        ),
                                                        onPressed: () async {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          await unblockPost(postId: idsPostList[index], type: "news");
                                                        },
                                                        child: const Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: height / 29,
                                  width: width / 5.76,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff0EA102),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Unblock",
                                      style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class VideosList extends StatefulWidget {
  const VideosList({Key? key}) : super(key: key);

  @override
  State<VideosList> createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  bool emptyBool1 = true;
  String mainUserToken = '';
  bool tabBarLoading = true;
  List<String> avatarPostList = [];
  List<String> titlesPostList = [];
  List<String> idsPostList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  unblockPost({required String postId, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + unblockedPostList);
    var responseNew = await http.post(url, body: {"id": postId, "type": type}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockPostFunc(type: type);
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockPostFunc({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + blockedPostList);
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool1 = false;
          tabBarLoading = false;
        });
      } else {
        avatarPostList.clear();
        titlesPostList.clear();
        idsPostList.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatarPostList.add(responseData["response"][i]["image_url"]);
          titlesPostList.add(responseData["response"][i]["title"]);
          idsPostList.add(responseData["response"][i]["_id"]);
        }
        setState(() {
          tabBarLoading = false;
        });
      }
    } else {
      setState(() {
        tabBarLoading = false;
      });
    }
  }

  @override
  void initState() {
    blockPostFunc(
      type: 'videos',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
          child: tabBarLoading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool1
                  ? ListView.builder(
                      itemCount: titlesPostList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: AdWidget(ad: nativeAdList[index])),
                              SizedBox(height: height / 57.73),
                              Container(
                                margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Container(
                                        height: height / 15.03,
                                        width: width / 6.94,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                      ),
                                      SizedBox(width: width / 23.43),
                                      SizedBox(
                                        width: width / 1.8,
                                        child: Text(
                                          titlesPostList[index],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        ),
                                      ),
                                    ]),
                                    // SizedBox(width: _width/9.86),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                child: Container(
                                                  height: height / 6,
                                                  margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Center(
                                                          child: Text("Unblock User",
                                                              style: TextStyle(
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  fontFamily: "Poppins"))),
                                                      const Divider(),
                                                      const Text("Are you sure to Unblock this User"),
                                                      const Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                ),
                                                                backgroundColor: const Color(0XFF0EA102),
                                                              ),
                                                              onPressed: () async {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                                await unblockPost(postId: idsPostList[index], type: "videos");
                                                              },
                                                              child: const Text(
                                                                "Continue",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: height / 29,
                                        width: width / 5.76,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xff0EA102),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Unblock",
                                            style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Container(
                                  height: height / 15.03,
                                  width: width / 6.94,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                ),
                                SizedBox(width: width / 23.43),
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    titlesPostList[index],
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                  ),
                                ),
                              ]),
                              // SizedBox(width: _width/9.86),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                          child: Container(
                                            height: height / 6,
                                            margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Center(
                                                    child: Text("Unblock User",
                                                        style: TextStyle(
                                                            color: Color(0XFF0EA102),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            fontFamily: "Poppins"))),
                                                const Divider(),
                                                const Text("Are you sure to Unblock this User"),
                                                const Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                          backgroundColor: const Color(0XFF0EA102),
                                                        ),
                                                        onPressed: () async {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          await unblockPost(postId: idsPostList[index], type: "videos");
                                                        },
                                                        child: const Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: height / 29,
                                  width: width / 5.76,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff0EA102),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Unblock",
                                      style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                          const SizedBox(
                            height: 15,
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class ForumList extends StatefulWidget {
  const ForumList({Key? key}) : super(key: key);

  @override
  State<ForumList> createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  bool emptyBool1 = true;
  String mainUserToken = '';
  bool tabBarLoading = true;
  List<String> avatarPostList = [];
  List<String> titlesPostList = [];
  List<String> idsPostList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  unblockPost({required String userId, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + unblockedPostList);
    var responseNew = await http.post(url, body: {"id": userId, "type": type}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockPostFunc(type: type);
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockPostFunc({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + blockedPostList);
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool1 = false;
          tabBarLoading = false;
        });
      } else {
        avatarPostList.clear();
        titlesPostList.clear();
        idsPostList.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatarPostList.add(responseData["response"][i]["user"]);
          titlesPostList.add(responseData["response"][i]["title"]);
          idsPostList.add(responseData["response"][i]["_id"]);
        }
        setState(() {
          tabBarLoading = false;
        });
      }
    } else {
      setState(() {
        tabBarLoading = false;
      });
    }
  }

  @override
  void initState() {
    blockPostFunc(
      type: 'forums',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
          child: tabBarLoading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool1
                  ? ListView.builder(
                      itemCount: titlesPostList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: AdWidget(ad: nativeAdList[index])),
                              SizedBox(height: height / 57.73),
                              Container(
                                margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Container(
                                        height: height / 15.03,
                                        width: width / 6.94,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                      ),
                                      SizedBox(width: width / 23.43),
                                      SizedBox(
                                        width: width / 1.8,
                                        child: Text(
                                          titlesPostList[index],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        ),
                                      ),
                                    ]),
                                    // SizedBox(width: _width/9.86),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                child: Container(
                                                  height: height / 6,
                                                  margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Center(
                                                          child: Text("Unblock User",
                                                              style: TextStyle(
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  fontFamily: "Poppins"))),
                                                      const Divider(),
                                                      const Text("Are you sure to Unblock this User"),
                                                      const Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                ),
                                                                backgroundColor: const Color(0XFF0EA102),
                                                              ),
                                                              onPressed: () async {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                                await unblockPost(userId: idsPostList[index], type: "forums");
                                                              },
                                                              child: const Text(
                                                                "Continue",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: height / 29,
                                        width: width / 5.76,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xff0EA102),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Unblock",
                                            style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Container(
                                  height: height / 15.03,
                                  width: width / 6.94,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                ),
                                SizedBox(width: width / 23.43),
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    titlesPostList[index],
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                  ),
                                ),
                              ]),
                              // SizedBox(width: _width/9.86),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                          child: Container(
                                            height: height / 6,
                                            margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Center(
                                                    child: Text("Unblock User",
                                                        style: TextStyle(
                                                            color: Color(0XFF0EA102),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            fontFamily: "Poppins"))),
                                                const Divider(),
                                                const Text("Are you sure to Unblock this User"),
                                                const Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                          backgroundColor: const Color(0XFF0EA102),
                                                        ),
                                                        onPressed: () async {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          await unblockPost(userId: idsPostList[index], type: "forums");
                                                        },
                                                        child: const Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: height / 29,
                                  width: width / 5.76,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff0EA102),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Unblock",
                                      style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class SurveyList extends StatefulWidget {
  const SurveyList({Key? key}) : super(key: key);

  @override
  State<SurveyList> createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {
  bool emptyBool1 = true;
  String mainUserToken = '';
  bool tabBarLoading = true;
  List<String> avatarPostList = [];
  List<String> titlesPostList = [];
  List<String> idsPostList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  unblockPost({required String userId, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + unblockedPostList);
    var responseNew = await http.post(url, body: {"id": userId, "type": type}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockPostFunc(type: type);
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockPostFunc({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + blockedPostList);
    mainUserToken = prefs.getString('newUserToken')!;
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool1 = false;
          tabBarLoading = false;
        });
      } else {
        avatarPostList.clear();
        titlesPostList.clear();
        idsPostList.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatarPostList.add(responseData["response"][i]["user"]);
          titlesPostList.add(responseData["response"][i]["title"]);
          idsPostList.add(responseData["response"][i]["_id"]);
        }
        setState(() {
          tabBarLoading = false;
        });
      }
    } else {
      setState(() {
        tabBarLoading = false;
      });
    }
  }

  @override
  void initState() {
    blockPostFunc(
      type: 'survey',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
          child: tabBarLoading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool1
                  ? ListView.builder(
                      itemCount: titlesPostList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: AdWidget(ad: nativeAdList[index])),
                              SizedBox(height: height / 57.73),
                              Container(
                                margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Container(
                                        height: height / 15.03,
                                        width: width / 6.94,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                      ),
                                      SizedBox(width: width / 23.43),
                                      SizedBox(
                                        width: width / 1.8,
                                        child: Text(
                                          titlesPostList[index],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        ),
                                      ),
                                    ]),
                                    // SizedBox(width: _width/9.86),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                child: Container(
                                                  height: height / 6,
                                                  margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Center(
                                                          child: Text("Unblock User",
                                                              style: TextStyle(
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  fontFamily: "Poppins"))),
                                                      const Divider(),
                                                      const Text("Are you sure to Unblock this User"),
                                                      const Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                ),
                                                                backgroundColor: const Color(0XFF0EA102),
                                                              ),
                                                              onPressed: () async {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                                await unblockPost(userId: idsPostList[index], type: "survey");
                                                              },
                                                              child: const Text(
                                                                "Continue",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: height / 29,
                                        width: width / 5.76,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xff0EA102),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Unblock",
                                            style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Container(
                                  height: height / 15.03,
                                  width: width / 6.94,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                ),
                                SizedBox(width: width / 23.43),
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    titlesPostList[index],
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                  ),
                                ),
                              ]),
                              // SizedBox(width: _width/9.86),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                          child: Container(
                                            height: height / 6,
                                            margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Center(
                                                    child: Text("Unblock User",
                                                        style: TextStyle(
                                                            color: Color(0XFF0EA102),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            fontFamily: "Poppins"))),
                                                const Divider(),
                                                const Text("Are you sure to Unblock this User"),
                                                const Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                          backgroundColor: const Color(0XFF0EA102),
                                                        ),
                                                        onPressed: () async {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          await unblockPost(userId: idsPostList[index], type: "survey");
                                                        },
                                                        child: const Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: height / 29,
                                  width: width / 5.76,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff0EA102),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Unblock",
                                      style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class FeatureList extends StatefulWidget {
  const FeatureList({Key? key}) : super(key: key);

  @override
  State<FeatureList> createState() => _FeatureListState();
}

class _FeatureListState extends State<FeatureList> {
  bool emptyBool1 = true;
  String mainUserToken = '';
  bool tabBarLoading = true;
  List<String> avatarPostList = [];
  List<String> titlesPostList = [];
  List<String> idsPostList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  unblockPost({required String userId, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + unblockedPostList);
    var responseNew = await http.post(url, body: {"id": userId, "type": type}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockPostFunc(type: type);
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockPostFunc({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + blockedPostList);
    mainUserToken = prefs.getString('newUserToken')!;
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool1 = false;
          tabBarLoading = false;
        });
      } else {
        avatarPostList.clear();
        titlesPostList.clear();
        idsPostList.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatarPostList.add(responseData["response"][i]["user"]);
          titlesPostList.add(responseData["response"][i]["title"]);
          idsPostList.add(responseData["response"][i]["_id"]);
        }
        setState(() {
          tabBarLoading = false;
        });
      }
    } else {
      setState(() {
        tabBarLoading = false;
      });
    }
  }

  @override
  void initState() {
    blockPostFunc(
      type: 'feature',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
          child: tabBarLoading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool1
                  ? ListView.builder(
                      itemCount: titlesPostList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: AdWidget(ad: nativeAdList[index])),
                              SizedBox(height: height / 57.73),
                              Container(
                                margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Container(
                                        height: height / 15.03,
                                        width: width / 6.94,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                      ),
                                      SizedBox(width: width / 23.43),
                                      SizedBox(
                                        width: width / 1.8,
                                        child: Text(
                                          titlesPostList[index],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        ),
                                      ),
                                    ]),
                                    // SizedBox(width: _width/9.86),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                child: Container(
                                                  height: height / 6,
                                                  margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Center(
                                                          child: Text("Unblock User",
                                                              style: TextStyle(
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  fontFamily: "Poppins"))),
                                                      const Divider(),
                                                      const Text("Are you sure to Unblock this User"),
                                                      const Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                ),
                                                                backgroundColor: const Color(0XFF0EA102),
                                                              ),
                                                              onPressed: () async {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                                await unblockPost(userId: idsPostList[index], type: "feature");
                                                              },
                                                              child: const Text(
                                                                "Continue",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: height / 29,
                                        width: width / 5.76,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xff0EA102),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Unblock",
                                            style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Container(
                                  height: height / 15.03,
                                  width: width / 6.94,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                ),
                                SizedBox(width: width / 23.43),
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    titlesPostList[index],
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                  ),
                                ),
                              ]),
                              // SizedBox(width: _width/9.86),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                          child: Container(
                                            height: height / 6,
                                            margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Center(
                                                    child: Text("Unblock User",
                                                        style: TextStyle(
                                                            color: Color(0XFF0EA102),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            fontFamily: "Poppins"))),
                                                const Divider(),
                                                const Text("Are you sure to Unblock this User"),
                                                const Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                          backgroundColor: const Color(0XFF0EA102),
                                                        ),
                                                        onPressed: () async {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          await unblockPost(userId: idsPostList[index], type: "feature");
                                                        },
                                                        child: const Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: height / 29,
                                  width: width / 5.76,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff0EA102),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Unblock",
                                      style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class BillBoardList extends StatefulWidget {
  const BillBoardList({Key? key}) : super(key: key);

  @override
  State<BillBoardList> createState() => _BillBoardListState();
}

class _BillBoardListState extends State<BillBoardList> {
  bool emptyBool1 = true;
  String mainUserToken = '';
  bool tabBarLoading = true;
  List<String> avatarPostList = [];
  List<String> titlesPostList = [];
  List<String> idsPostList = [];
  List<String> typePostList = [];
  List<NativeAd> nativeAdList = <NativeAd>[];
  List<bool> nativeAdIsLoadedList = <bool>[];

  @override
  void dispose() {
    for (int i = 0; i < nativeAdList.length; i++) {
      nativeAdList[i].dispose();
    }
    super.dispose();
  }

  unblockPost({required String userId, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + unblockedPostList);
    var responseNew = await http.post(url, body: {"id": userId, "type": type}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      await blockPostFunc(type: type);
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  blockPostFunc({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + blockedPostList);
    var response = await http.post(url, headers: {'authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool1 = false;
          tabBarLoading = true;
        });
      } else {
        avatarPostList.clear();
        titlesPostList.clear();
        idsPostList.clear();
        typePostList.clear();
        nativeAdList.clear();
        nativeAdIsLoadedList.clear();
        for (int i = 0; i < responseData["response"].length; i++) {
          nativeAdIsLoadedList.add(false);
          nativeAdList.add(NativeAd(
            adUnitId: adVariables.nativeAdUnitId,
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.small,
              mainBackgroundColor: Theme.of(context).colorScheme.background,
            ),
            listener: NativeAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('$NativeAd loaded.');
                setState(() {
                  nativeAdIsLoadedList[i] = true;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('$NativeAd failedToLoad: $error');
                ad.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
              onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
            ),
          )..load());
          avatarPostList.add(responseData["response"][i]["user"]);
          titlesPostList.add(responseData["response"][i]["title"]);
          idsPostList.add(responseData["response"][i]["_id"]);
          typePostList.add(responseData["response"][i]["billboard_type"]);
        }
        setState(() {
          tabBarLoading = false;
        });
      }
    } else {
      setState(() {
        tabBarLoading = false;
      });
    }
  }

  @override
  void initState() {
    blockPostFunc(
      type: 'billboard',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 50.75),
          child: tabBarLoading
              ? Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                )
              : emptyBool1
                  ? ListView.builder(
                      itemCount: titlesPostList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index % 5 == 4 && nativeAdIsLoadedList[index]) {
                          return Column(
                            children: [
                              Container(
                                  height: height / 9.10,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: AdWidget(ad: nativeAdList[index])),
                              SizedBox(height: height / 57.73),
                              Container(
                                margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            height: height / 15.03,
                                            width: width / 6.94,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).colorScheme.tertiary,
                                                image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                          ),
                                          Container(
                                            height: height / 30.06,
                                            width: width / 13.88,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context).colorScheme.tertiary,
                                            ),
                                            clipBehavior: Clip.none,
                                            child: SvgPicture.asset(
                                              typePostList[index] == "byte"
                                                  ? "lib/Constants/Assets/BillBoard/FilterPage/bottomBytes.svg"
                                                  : "lib/Constants/Assets/BillBoard/FilterPage/bottomBlog.svg",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width / 23.43),
                                      SizedBox(
                                        width: width / 1.8,
                                        child: Text(
                                          titlesPostList[index],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        ),
                                      ),
                                    ]),
                                    // SizedBox(width: _width/9.86),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                child: Container(
                                                  height: height / 6,
                                                  margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Center(
                                                          child: Text("Unblock User",
                                                              style: TextStyle(
                                                                  color: Color(0XFF0EA102),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  fontFamily: "Poppins"))),
                                                      const Divider(),
                                                      const Text("Are you sure to Unblock this User"),
                                                      const Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                ),
                                                                backgroundColor: const Color(0XFF0EA102),
                                                              ),
                                                              onPressed: () async {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Navigator.pop(context);
                                                                await unblockPost(userId: idsPostList[index], type: "feature");
                                                              },
                                                              child: const Text(
                                                                "Continue",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: height / 29,
                                        width: width / 5.76,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xff0EA102),
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Unblock",
                                            style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: height / 15.03,
                                      width: width / 6.94,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).colorScheme.tertiary,
                                          image: DecorationImage(image: NetworkImage(avatarPostList[index]), fit: BoxFit.fill)),
                                    ),
                                    Container(
                                      height: height / 30.06,
                                      width: width / 13.88,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                      clipBehavior: Clip.none,
                                      child: SvgPicture.asset(
                                        typePostList[index] == "byte"
                                            ? "lib/Constants/Assets/BillBoard/FilterPage/bottomBytes.svg"
                                            : "lib/Constants/Assets/BillBoard/FilterPage/bottomBlog.svg",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: width / 23.43),
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    titlesPostList[index],
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                  ),
                                ),
                              ]),
                              // SizedBox(width: _width/9.86),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                          child: Container(
                                            height: height / 6,
                                            margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Center(
                                                    child: Text("Unblock User",
                                                        style: TextStyle(
                                                            color: Color(0XFF0EA102),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            fontFamily: "Poppins"))),
                                                const Divider(),
                                                const Text("Are you sure to Unblock this User"),
                                                const Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                          backgroundColor: const Color(0XFF0EA102),
                                                        ),
                                                        onPressed: () async {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                          await unblockPost(userId: idsPostList[index], type: "feature");
                                                        },
                                                        child: const Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: height / 29,
                                  width: width / 5.76,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff0EA102),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Unblock",
                                      style: TextStyle(color: const Color(0xff0EA102), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Nothing to display.', style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
