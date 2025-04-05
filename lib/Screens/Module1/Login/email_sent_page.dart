import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'sign_in_page.dart';

class EmailSentPage extends StatefulWidget {
  const EmailSentPage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<EmailSentPage> createState() => _EmailSentPageState();
}

class _EmailSentPageState extends State<EmailSentPage> {
  bool loading = false;
  List<String> pathList = [];
  String newId = "";

  login({required String email1}) async {
    Uri newLink = await getLinK();
    String newLink1 = newLink.toString();
    var url = Uri.parse(baseurl + versions + forgotPassWord);
    var response = await http.post(url, body: {
      "email": email1,
      "deep_link": newLink1,
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      Future.delayed(const Duration(seconds: 25), () {
        setState(() {
          loading = false;
        });
      });
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    }
  }

  Future<Uri> getLinK() async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/CreatePasswordPage'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    return dynamicLink;
  }

  @override
  void initState() {
    getAllDataMain(name: 'Email_Sent_Page');
    FirebaseMessaging.instance.getInitialMessage();

    setState(() {
      loading = true;
    });
    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      // color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height / 25.375),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const SignInPage();
                      }));
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                const SizedBox(height: 4),
                Text(
                  "Email has been sent",
                  style: TextStyle(fontSize: text.scale(28), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                ),
                const SizedBox(height: 5),
                Text(
                  "Please check your inbox and click in the received link to reset a password",
                  style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                  maxLines: 2,
                ),
                SizedBox(height: height / 11.43),
                Center(
                  child: SizedBox(
                    height: height / 3.38,
                    width: width / 1.33,
                    child: SvgPicture.asset(
                      "lib/Constants/Assets/SMLogos/EmailSentImage.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: height / 10.15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const SignInPage();
                    }));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0XFF0EA102),
                    ),
                    height: height / 17.4,
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height / 32.48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't receive the link?",
                      style: TextStyle(color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w400, fontSize: text.scale(18), fontFamily: "Poppins"),
                    ),
                    loading
                        ? TextButton(
                            onPressed: () {},
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                  fontSize: text.scale(18), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                            ))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              login(email1: widget.email);
                              /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                            return const ForgetPasswordPage();
                          }));*/
                            },
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                  fontSize: text.scale(18), color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                            ))
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
