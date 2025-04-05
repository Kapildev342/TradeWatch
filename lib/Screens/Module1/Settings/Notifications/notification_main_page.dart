import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'notification_categories_model.dart';

class NotificationMainPage extends StatefulWidget {
  const NotificationMainPage({Key? key}) : super(key: key);

  @override
  State<NotificationMainPage> createState() => _NotificationMainPageState();
}

class _NotificationMainPageState extends State<NotificationMainPage> {
  bool isSwitched = true;
  List<NotificationCategoryResponse> categoriesList = [];
  List<bool> boolList = [];
  late NotificationCategoriesModel notifyCategories;
  bool loader = false;

  @override
  void initState() {
    getAllDataMain(name: 'Notification_Main_Screen');
    getData();
    super.initState();
  }

  getData() async {
    if (mainSkipValue == false) {
      notifyCategories = await settingsMain.notificationCategories();
      isSwitched = notifyCategories.notification;
      for (int i = 0; i < notifyCategories.response.length; i++) {
        categoriesList.add(notifyCategories.response[i]);
        boolList.add(notifyCategories.response[i].notify);
      }
      setState(() {
        loader = true;
      });
    } else {
      setState(() {
        loader = true;
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
        //backgroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          // backgroundColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          title: Text("Notification",
              //style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0XFF403D3D)),
              style: Theme.of(context).textTheme.titleSmall),
          leading: IconButton(
            onPressed: () {
              if (!mounted) {
                return;
              }
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: loader
            ? SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text("Notification Alert",
                            //style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, color: const Color(0XFF373333),
                            style: Theme.of(context).textTheme.titleSmall),
                        trailing: Switch(
                            activeTrackColor: Colors.green,
                            activeColor: Colors.white,
                            value: isSwitched,
                            onChanged: (value) async {
                              if (mainSkipValue == false) {
                                setState(() {
                                  isSwitched = value;
                                });
                                settingsMain.notificationFunc(isSwitched: isSwitched, slug: 'all');
                                if (value) {
                                  boolList.clear();
                                  boolList = List.generate(notifyCategories.response.length, (index) => true);
                                  setState(() {});
                                } else {
                                  boolList.clear();
                                  boolList = List.generate(notifyCategories.response.length, (index) => false);
                                  setState(() {});
                                }
                              }
                            }),
                      ),
                      ListTile(
                        onTap: isSwitched
                            ? mainSkipValue
                                ? () {}
                                : () async {
                                    widgetsMain.notifyFilterShowSheet(context: context, boolList: boolList, categoriesList: categoriesList);
                                  }
                            : () {},
                        minLeadingWidth: width / 25,
                        title: Text(
                          "Notification Categories",
                          style: TextStyle(
                              fontSize: text.scale(16),
                              fontWeight: FontWeight.w600,
                              color: isSwitched
                                  ? mainSkipValue
                                      ? Colors.grey
                                      : const Color(0XFF373333)
                                  : Colors.grey),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
              ),
      ),
    );
  }
}
