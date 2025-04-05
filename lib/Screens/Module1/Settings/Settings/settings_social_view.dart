import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class SettingsSocialView extends StatefulWidget {
  final Function initFunction;
  const SettingsSocialView({Key? key, required this.initFunction}) : super(key: key);
  @override
  State<SettingsSocialView> createState() => _SettingsSocialViewState();
}

class _SettingsSocialViewState extends State<SettingsSocialView> {
  @override
  void initState() {
    settingsMainTabIndex = 2.obs;
    widget.initFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: ListView(
        children: [
          SizedBox(
            height: height / 57.73,
          ),
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
              Get.to(const DemoView(), arguments: {
                "id": "",
                "type": '',
                "url": 'https://www.instagram.com/officialtradewatch/',
              });
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'instagram');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: Image.asset(
              "lib/Constants/Assets/Settings/instagram.png",
              height: height / 28.86,
              width: width / 13.7,
              fit: BoxFit.fill,
            ),
            title: Text("Instagram",
                //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333)),
                style: Theme.of(context).textTheme.titleSmall),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
          ListTile(
            onTap: () async {
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
              Get.to(const DemoView(), arguments: {
                "id": "",
                "type": '',
                "url": 'https://www.facebook.com/officialtradewatch',
              });
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'facebook');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: Image.asset(
              "lib/Constants/Assets/Settings/facebook.png",
              height: height / 28.86,
              width: width / 13.7,
              fit: BoxFit.fill,
            ),
            title: Text("Facebook",
                //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333)),
                style: Theme.of(context).textTheme.titleSmall),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
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
              Get.to(const DemoView(), arguments: {
                "id": "",
                "type": '',
                "url": 'https://twitter.com/Asktradewatch',
              });
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'twitter');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              "lib/Constants/Assets/SMLogos/Logos/twitter.svg",
              height: height / 28.86,
              width: width / 13.7,
              fit: BoxFit.fill,
            ),
            title: Text("Twitter",
                //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333)),
                style: Theme.of(context).textTheme.titleSmall),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
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
              Get.to(const DemoView(), arguments: {
                "id": "",
                "type": '',
                "url": 'https://www.linkedin.com/company/tradewatch/',
              });
              functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'linkedin');
            },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: Image.asset(
              "lib/Constants/Assets/Settings/linkedin.png",
              height: height / 28.86,
              width: width / 13.7,
              fit: BoxFit.fill,
            ),
            title: Text("LinkedIn",
                //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333)),
                style: Theme.of(context).textTheme.titleSmall),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme.value ? const Color(0XFFE2E2E2) : const Color(0XFF2A2727),
            ),
          ),
        ],
      ),
    );
  }
}
