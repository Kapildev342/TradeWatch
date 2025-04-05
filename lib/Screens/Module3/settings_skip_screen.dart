import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import '../../Constants/API/api.dart';

class SettingsSkipScreen extends StatefulWidget {
  final String? fromWhere;

  const SettingsSkipScreen({Key? key, this.fromWhere}) : super(key: key);

  @override
  State<SettingsSkipScreen> createState() => _SettingsSkipScreenState();
}

class _SettingsSkipScreenState extends State<SettingsSkipScreen> {
// no init state
  final bool _isSwitched = true;
  final _recipientController = TextEditingController(
    text: 'support@tradewatch.in',
  );
  List<String> attachments = [];
  bool isHTML = false;

  Future<Uri> getLinK() async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/HomeScreen'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: 'TradeWatch', description: '', imageUrl: Uri.parse("http://live.tradewatch.in/uploads/tickers/TradeWatch_logo.png")));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  Future<void> send() async {
    final Email email = Email(
      body: "",
      subject: "",
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = "you don't have a mail app to contact";
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  void initState() {
    getAllDataMain(name: 'Skipped_user_Settings');
    super.initState();
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
          Navigator.pop(context, true);
        }
        return false;
      },
      child: Container(
        //color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Scaffold(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  //backgroundColor: const Color(0XFFFFFFFF),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  toolbarHeight: height / 3.248,
                  automaticallyImplyLeading: false,
                  elevation: 0.0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 67.66,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (widget.fromWhere == 'logout') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MainBottomNavigationPage(
                                              caseNo1: 0, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
                                } else {
                                  Navigator.pop(context, true);
                                }
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )),
                          Text('Settings',
                              style: TextStyle(fontSize: text.scale(36), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins")),
                        ],
                      ),
                      SizedBox(
                        height: height / 50.75,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "User Name",
                              style: TextStyle(fontSize: text.scale(20), color: Colors.grey, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  child: Text(
                                    'Edit Profile',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: Colors.grey, fontFamily: "Poppins"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  "lib/Constants/Assets/SMLogos/Settings/Edit_profile.svg",
                                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            commonFlushBar(context: context);
                          },
                          child: Container(
                            height: height / 9.22,
                            width: width / 4.26,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage('lib/Constants/Assets/SMLogos/SkipPage/No_Image_Available (1).jpg'), fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        )
                      ]),
                      SizedBox(
                        height: height / 50.75,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Uri newLink = await getLinK();
                              await Share.share(
                                "It's a nice trader's social Medium app: Tradewatch ${newLink.toString()}",
                              );
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/Add User.svg"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'invite Friends',
                                  style: TextStyle(
                                      fontSize: text.scale(14), color: const Color(0XFF0EA102), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return const SignInPage(
                                  fromWhere: 'settings',
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/Logout.svg",
                                      colorFilter: const ColorFilter.mode(Color(0XFF0EA102), BlendMode.srcIn)),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Log in",
                                    style: TextStyle(
                                        fontSize: text.scale(14), color: const Color(0XFF0EA102), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://www.instagram.com/officialtradewatch/",
                                        text: "Instagram",
                                        activity: false,
                                        image: "lib/Constants/Assets/SMLogos/Settings/instagram.svg",
                                        type: '',
                                        id: '',
                                      );
                                    }));*/
                                    Get.to(const DemoView(),
                                        arguments: {"id": "", "type": "news", "url": "https://www.instagram.com/officialtradewatch/"});
                                    // userInsightFunc(aliasData: 'settings', typeData: 'instagram');
                                  },
                                  minLeadingWidth: 0,
                                  leading: SizedBox(
                                    height: height / 23.73,
                                    width: width / 13,
                                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/instagram.svg", fit: BoxFit.fill),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Follow us on Instagram',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://www.facebook.com/officialtradewatch/",
                                        text: "Facebook",
                                        activity: false,
                                        image: "lib/Constants/Assets/SMLogos/Logos/facebook.svg",
                                        id: '',
                                        type: '',
                                      );
                                    }));*/
                                    Get.to(const DemoView(),
                                        arguments: {"id": "", "type": "news", "url": "https://www.facebook.com/officialtradewatch/"});
                                    // userInsightFunc(aliasData: 'settings', typeData: 'facebook');
                                  },
                                  minLeadingWidth: 0,
                                  leading: SizedBox(
                                    height: height / 28.48,
                                    width: width / 13,
                                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Logos/facebook.svg", fit: BoxFit.fill),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Like us on Facebook',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://twitter.com/Asktradewatch",
                                        text: "Twitter",
                                        activity: false,
                                        image: "lib/Constants/Assets/SMLogos/Logos/twitter.svg",
                                        type: '',
                                        id: '',
                                      );
                                    }));*/
                                    Get.to(const DemoView(), arguments: {"id": "", "type": "news", "url": "https://twitter.com/Asktradewatch"});
                                    // userInsightFunc(aliasData: 'settings', typeData: 'twitter');
                                  },
                                  minLeadingWidth: 0,
                                  leading: SizedBox(
                                    height: height / 28.48,
                                    width: width / 13,
                                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Logos/twitter.svg", fit: BoxFit.fill),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Follow us on Twitter',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://www.linkedin.com/company/tradewatch/",
                                        text: "LinkedIn",
                                        activity: false,
                                        image: "lib/Constants/Assets/SMLogos/linkedin.png",
                                        id: '',
                                        type: '',
                                      );
                                    }));*/
                                    Get.to(const DemoView(),
                                        arguments: {"id": "", "type": "news", "url": "https://www.linkedin.com/company/tradewatch/"});
                                    //userInsightFunc(aliasData: 'settings', typeData: 'linkedin');
                                  },
                                  minLeadingWidth: 0,
                                  leading: SizedBox(
                                    height: height / 28.48,
                                    width: width / 13,
                                    child: SvgPicture.asset(
                                      "lib/Constants/Assets/SMLogos/Settings/linkedin1.svg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Find us on LinkedIn',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Notification',
                                    style:
                                        TextStyle(color: Colors.grey, fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                                  ),
                                  trailing:
                                      Switch(activeTrackColor: Colors.green, activeColor: Colors.white, value: _isSwitched, onChanged: (value) {}),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  //tileColor: Colors.grey,
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'My Activity',
                                    style:
                                        TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  // tileColor: Colors.grey,
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Feature Request',
                                    style:
                                        TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  // tileColor: Colors.grey,
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'My Blocklist',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: text.scale(14),
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  // tileColor: Colors.grey,
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'My Bookmarks',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: text.scale(14),
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  onTap: () {
                                    //showSheet();
                                    Flushbar(
                                      message: "Coming Soon",
                                      duration: const Duration(seconds: 2),
                                    ).show(context);
                                  },
                                  title: Text(
                                    'Contact Support',
                                    style:
                                        TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(
                                  height: 0.2,
                                ),
                                ListTile(
                                  //tileColor: Colors.grey,
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Messages from Tradewatch',
                                    style:
                                        TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(
                                  height: 0.2,
                                ),
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247",
                                        text: "Terms & Conditions",
                                        activity: false,
                                        image: "",
                                        type: '',
                                        id: '',
                                      );
                                    }));*/
                                    Get.to(const DemoView(), arguments: {
                                      "id": "",
                                      "type": "news",
                                      "url": "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247"
                                    });
                                    //userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Terms & Conditions',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://www.tradewatch.in/company/privacy-policy",
                                        text: "Privacy Policy",
                                        activity: false,
                                        image: "",
                                        type: '',
                                        id: '',
                                      );
                                    }));*/
                                    Get.to(const DemoView(),
                                        arguments: {"id": "", "type": "news", "url": "https://www.tradewatch.in/company/privacy-policy"});
                                    //userInsightFunc(aliasData: 'settings', typeData: 'privacy_policy');
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Privacy Policy',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DemoPage(
                                        url: "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2",
                                        text: "Disclaimer",
                                        image: "",
                                        id: '',
                                        type: '',
                                        activity: false,
                                      );
                                    }));*/
                                    Get.to(const DemoView(), arguments: {
                                      "id": "",
                                      "type": "news",
                                      "url": "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2"
                                    });
                                    //userInsightFunc(aliasData: 'settings', typeData: 'disclaimer');
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Disclaimer',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                ListTile(
                                  //tileColor: Colors.grey,
                                  onTap: () {
                                    commonFlushBar(context: context);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  title: Text(
                                    'Delete Account',
                                    style:
                                        TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: text.scale(14), fontFamily: "Poppins"),
                                  ),
                                ),
                                const Divider(height: 0.2),
                                SizedBox(
                                  height: height / 50.75,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  showSheet() {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      //userInsightFunc(aliasData: 'settings', typeData: 'contact_support');
                      ZohoSalesIQ.startChat("Hello there!!");
                      ZohoSalesIQ.enableInAppNotification();
                      ZohoSalesIQ.show();
                      ZohoSalesIQ.setThemeColorForiOS("#6d85fcff");
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/message-circle (1).png",
                        )),
                    title: Text(
                      "Contact via Chat",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      send();
                      //userInsightFunc(aliasData: 'settings', typeData: 'contact_support');
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/mail.png",
                        )),
                    title: Text(
                      "Contact via Email",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
