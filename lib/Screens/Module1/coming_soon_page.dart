import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';

import '../Module2/FeatureRequest/feature_request_page.dart';
import 'bottom_navigation.dart';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({Key? key}) : super(key: key);

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  String deviceId = "";

  @override
  void initState() {
    getAllDataMain(name: 'Coming_Soon_Page');
    super.initState();
  }

  notifyMeFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString('DeviceIDD') ?? "";
    Uri url = Uri.parse(baseurl + versions + chartNotification);
    var response = await http.post(
      url,
      body: {
        "device_id": deviceId,
      },
    );
    var responseData = jsonDecode(response.body);
    if (responseData["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "Notification enabled. Once charts got ready You will get notification, ",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "Already notification enabled. Once charts got ready You will get notification, ",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      //canPop: true,
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Container(
        color: const Color(0XFF48B83F),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0XFF48B83F),
            body: Column(
              children: [
                SizedBox(
                  height: height / 16.24,
                ),
                SizedBox(height: height / 2.15, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Ornament.png", fit: BoxFit.fill)),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(height: 50),
                Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green, backgroundColor: Colors.white,
                    // shadowColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(width / 1.87, height / 16.91),
                  ),
                  onPressed: () {
                    /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>MainBottomNavigationPage(
                            caseNo1: 1, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));*/
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '“Coming Soon”',
                    style: TextStyle(color: Color(0xff0EA102), fontSize: 14),
                  ),
                )),
                const SizedBox(height: 25),
                const SizedBox(),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Need anything specific - add them now within ",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return const FeatureRequestPage();
                          }));
                        },
                        child: const Text("Feature request.",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.underline))),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
