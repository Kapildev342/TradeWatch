import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkOverAll/book_mark_view.dart';

class SettingsMyActivityView extends StatefulWidget {
  final Function initFunction;
  const SettingsMyActivityView({Key? key, required this.initFunction}) : super(key: key);

  @override
  State<SettingsMyActivityView> createState() => _SettingsMyActivityViewState();
}

class _SettingsMyActivityViewState extends State<SettingsMyActivityView> {
  @override
  void initState() {
    settingsMainTabIndex = 1.obs;
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
            height: height / 27.4,
          ),
          Text(
            "Activities", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            //style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: const Color(0XFF4B4B4B)),
          ),
          ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const MyActivityPage();
                    }));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/my_activity.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/myActivity.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "My Activity",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333)),
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
          ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const BlockListPage(
                        blockBool: true,
                        tabIndex: 0,
                      );
                    }));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/blocklist.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/blockList.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "My Blocklist",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333)),
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
          ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const BookMarksView();
                    }));
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/bookmark.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/bookmarks.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "My Bookmarks",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333)),
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
          ListTile(
            onTap: mainSkipValue
                ? () {
                    commonFlushBar(context: context, initFunction: widget.initFunction);
                  }
                : () {
                    billboardWidgetsMain.believedTabBottomSheet(context: context, id: userIdMain);
                  },
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: isDarkTheme.value
                ? Image.asset(
                    "assets/settings/bookmark.png",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    "lib/Constants/Assets/Settings/bookmarks.svg",
                    height: height / 28.86,
                    width: width / 13.7,
                    fit: BoxFit.fill,
                  ),
            title: Text(
              "My Believed List",
              //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: mainSkipValue ? Colors.grey : const Color(0XFF373333)),
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
        ],
      ),
    );
  }
}
