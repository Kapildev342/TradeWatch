import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Edited_Packages/Polygon/src/polygon.dart';
import 'package:tradewatchfinal/Edited_Packages/Polygon/src/polygon_border.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_account_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'profile_data_model.dart';
import 'settings_my_activity_view.dart';
import 'settings_social_view.dart';

class SettingsSkipView extends StatefulWidget {
  final String? fromWhere;

  const SettingsSkipView({Key? key, this.fromWhere}) : super(key: key);

  @override
  State<SettingsSkipView> createState() => _SettingsSkipViewState();
}

class _SettingsSkipViewState extends State<SettingsSkipView> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectIndex = 0;
  late ProfileDataModel profile;
  bool loader = false;
  late bool checkMainSkipValue;

  @override
  void initState() {
    checkMainSkipValue = mainSkipValue;
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    getAllDataMain(name: 'Settings_Page_Skip');
    pageVisitFunc(pageName: 'settings');
    getData();
    super.initState();
  }

  getData() async {
    if (mainSkipValue == false) {
      profile = await settingsMain.getData();
    }
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWhere == 'logout') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainBottomNavigationPage(
                      caseNo1: 0, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
        } else {
          Navigator.pop(context, checkMainSkipValue != mainSkipValue);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: loader
              ? Stack(
                  children: [
                    Container(
                      height: height / 5.77,
                      decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('lib/Constants/Assets/Settings/coverImage_default.png'), fit: BoxFit.fill),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: height / 86.6),
                        SizedBox(
                          height: height / 28.86,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (widget.fromWhere == 'logout') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const MainBottomNavigationPage(
                                                    caseNo1: 0,
                                                    text: "",
                                                    excIndex: 1,
                                                    newIndex: 0,
                                                    countryIndex: 0,
                                                    isHomeFirstTym: false,
                                                    tType: true)));
                                      } else {
                                        Navigator.pop(context, checkMainSkipValue != mainSkipValue);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Color(0XFFC3C3C3),
                                    ),
                                  ),
                                  Text(
                                    "Settings",
                                    style: TextStyle(
                                      fontSize: text.scale(16),
                                      color: const Color(0XFFC3C3C3),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: height / 36.08,
                                margin: EdgeInsets.only(right: width / 27.4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFFC3C3C3).withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    if (mainSkipValue) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => const SignInPage(
                                                    fromWhere: 'settings',
                                                  )));
                                      //commonFlushBar(context: context,initFunction: getData);
                                    } else {
                                      widgetsMain.logoutPopUp(context: context, email: profile.response.email, initFunction: getData);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                                        child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/Logout.svg",
                                            colorFilter: const ColorFilter.mode(Color(0XFFFFFFFF), BlendMode.srcIn), fit: BoxFit.fill),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        mainSkipValue ? "Log in" : "Log out",
                                        style: TextStyle(
                                          fontSize: text.scale(12),
                                          color: const Color(0XFFFFFFFF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height / 17.32),
                        Center(
                          child: GestureDetector(
                            onTap: mainSkipValue
                                ? () {
                                    commonFlushBar(context: context, initFunction: getData);
                                  }
                                : () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return FullScreenImage(
                                        imageUrl: profile.response.avatar,
                                        tag: "generate_a_unique_tag",
                                      );
                                    }));
                                  },
                            child: SizedBox(
                              height: height / 5.77,
                              width: width / 2.74,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DecoratedBox(
                                  decoration: ShapeDecoration(
                                      shape: PolygonBorder(
                                        borderAlign: BorderAlign.outside,
                                        polygon: RegularConvexPolygon(vertexCount: 5),
                                        radius: 15,
                                        turn: 0.15,
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 0,
                                        ),
                                      ),
                                      image: mainSkipValue
                                          ? const DecorationImage(
                                              image: AssetImage('lib/Constants/Assets/SMLogos/SkipPage/No_Image_Available (1).jpg'), fit: BoxFit.fill)
                                          : DecorationImage(image: NetworkImage(profile.response.avatar), fit: BoxFit.fill)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            mainSkipValue ? "User Name" : "${profile.response.firstName} ${profile.response.lastName}",
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                            /*style: TextStyle(
                              fontSize: text.scale(20),
                              color: const Color(0XFF1D1D1D),
                              fontWeight: FontWeight.w600,
                            ),*/
                          ),
                        ),
                        SizedBox(height: height / 86.6),
                        Center(
                          child: Text(
                            mainSkipValue ? "***" : profile.response.username,
                            style: TextStyle(
                              fontSize: text.scale(12),
                              color: const Color(0XFFAFAFAF),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: height / 86.6),
                        Center(
                          child: Container(
                            height: height / 36.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainSkipValue ? Colors.grey : const Color(0XFF0EA102),
                              ),
                              onPressed: mainSkipValue
                                  ? () {
                                      commonFlushBar(context: context, initFunction: getData);
                                    }
                                  : () {
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (BuildContext context) => const EditProfilePage(comeFrom: true)));
                                    },
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: text.scale(14),
                                  color: const Color(0XFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                            child: Card(
                          elevation: 10.0,
                          shape: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.background)),
                          child: Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0XFF0EA102).withOpacity(0.25),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  )
                                ]),
                            child: Column(
                              children: [
                                SizedBox(height: height / 20.55),
                                TabBar(
                                  controller: _tabController,
                                  isScrollable: false,
                                  indicatorWeight: 2,
                                  labelPadding: EdgeInsets.zero,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  dividerColor: Colors.transparent,
                                  dividerHeight: 0.0,
                                  indicatorColor: Colors.green,
                                  onTap: (int newIndex) async {
                                    setState(() {
                                      selectIndex = newIndex;
                                    });
                                  },
                                  tabs: [
                                    Text(
                                      "Account",
                                      //style: TextStyle(color: const Color(0XFF413B3B), fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text("My Activity",
                                        //style: TextStyle(color: const Color(0XFF413B3B), fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        style: Theme.of(context).textTheme.bodyMedium),
                                    Text("Social",
                                        //style: TextStyle(color: const Color(0XFF413B3B), fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                Expanded(
                                  child: TabBarView(controller: _tabController, children: [
                                    SettingsAccountView(
                                      email: mainSkipValue ? "" : profile.response.email,
                                      initFunction: getData,
                                    ),
                                    SettingsMyActivityView(
                                      initFunction: getData,
                                    ),
                                    SettingsSocialView(
                                      initFunction: getData,
                                    ),
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                ),
        ),
      ),
    );
  }
}
