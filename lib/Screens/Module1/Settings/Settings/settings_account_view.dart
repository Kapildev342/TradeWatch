import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Language/language_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Notifications/notification_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/ThemeView.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/trade_watch_message_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';

class SettingsAccountView extends StatefulWidget {
  final String email;
  final Function initFunction;
  const SettingsAccountView({Key? key, required this.email, required this.initFunction}) : super(key: key);

  @override
  State<SettingsAccountView> createState() => _SettingsAccountViewState();
}

class _SettingsAccountViewState extends State<SettingsAccountView> {
  @override
  void initState() {
    settingsMainTabIndex = 0.obs;
    widget.initFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        SizedBox(
          height: height / 57.73,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          child: Text("General",
              // style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600) //TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
              ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: () async {
              Uri newLink = await settingsMain.getLinK();
              await Share.share(
                "It's a nice trader's social Medium app: Tradewatch ${newLink.toString()}",
              );
              functionsMain.userInsightFunc(aliasData: "settings", typeData: "invite_friends");
              logEventFunc(name: "Invite_Friends", type: "SettingsPage");
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/invite_dark.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/invite_friends.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Invite Friends",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333).withOpacity(0.5)),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const FeatureRequestPage();
                    }));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/feature.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/feature_request.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Feature Request",
              // style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333).withOpacity(0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /* color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const TradeWatchMessagePage();
                    }));
                    functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'messagefrom');
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/messages.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/message_TW.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Message from Tradewatch",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333).withOpacity(0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /*color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        SizedBox(
          height: height / 57.73,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          child: Text("Help",
              //style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    widgetsMain.contactSupportShowSheet(context: context);
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/contact.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/contact_support.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Contact Support",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333).withOpacity(0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /*color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        SizedBox(
          height: height / 57.73,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          child: Text("Preference",
              //style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ComingSoonPage()));
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const ThemeView();
              }));
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/theme.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/theme.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Theme",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const LanguageView(audio: false);
                    }));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/language.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/translation.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Language Translation",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /*color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const LanguageView(audio: true);
                    }));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/audio.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/audio_trans.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Audio translation",
              // style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /*color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const NotificationMainPage(),
                        ));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/notification.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/notification.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Notification",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /*color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        SizedBox(
          height: height / 57.73,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          child: Text("Policy",
              //style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: () {
              Get.to(const DemoView(),
                  arguments: {"id": "", "type": "news", "url": "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247"});
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'terms_conditions');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/terms.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/terms_conditions.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Terms and Condition",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: () {
              Get.to(const DemoView(), arguments: {"id": "", "type": "news", "url": "https://www.tradewatch.in/company/privacy-policy"});
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'privacy_policy');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/privacy.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/privacy.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Privacy Policy",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value
                  ? const Color(0XFFE2E2E2)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: () {
              Get.to(const DemoView(),
                  arguments: {"id": "", "type": "news", "url": "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2"});
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'disclaimer');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/disclaimer.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/disclaimer.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Disclaimer",
              // style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value
                  ? const Color(0XFFE2E2E2)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
        SizedBox(
          height: height / 57.73,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          child: Text("Other",
              //style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    widgetsMain.deleteAccountBottomSheet(context: context, email: widget.email);
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/delete.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/delete_account.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "Delete Account",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)),
              style: mainSkipValue
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5))
                  : Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              /*color: isDarkTheme.value
                  ? mainSkipValue
                      ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                      : const Color(0XFFE2E2E2)
                  : const Color(0XFF2A2727),*/
              color: mainSkipValue
                  ? const Color(0XFF373333).withOpacity(isDarkTheme.value ? 1.0 : 0.5)
                  : isDarkTheme.value
                      ? const Color(0XFFFFFFFF)
                      : const Color(0XFF2A2727),
            ),
          ),
        ),
      ],
    );
  }
}
