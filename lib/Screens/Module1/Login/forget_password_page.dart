import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'email_sent_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;
  String newId = "";

  login({required String email1}) async {
    Uri newLink = await getLinK();
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
    if (email1 == "") {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Please Enter Email Address",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else if (!emailValid) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Enter valid Email Address",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else {
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
        if (!mounted) {
          return false;
        }
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return EmailSentPage(
            email: email1,
          );
        }));
        _emailController.clear();
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
    getAllDataMain(name: 'Forget_Password_Page');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      //color: const Color(0XFFFFFFFF),
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
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                const SizedBox(height: 4),
                Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: text.scale(28), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                ),
                const SizedBox(height: 5),
                Text("Enter your registered email below to receive password reset instruction",
                    style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                SizedBox(height: height / 16.5),
                Center(
                  child: SizedBox(
                    height: height / 2.64,
                    width: width / 1.58,
                    child: SvgPicture.asset(
                      "lib/Constants/Assets/SMLogos/forgetPasswordImage.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: height / 23.2),
                SizedBox(
                  height: height / 14.5,
                  child: TextFormField(
                    style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelStyle:
                          TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 32.48,
                ),
                loading
                    ? Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          login(email1: _emailController.text);
                          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return EmailSentPage();}));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color(0XFF0EA102),
                          ),
                          height: height / 14.5,
                          child: Center(
                            child: Text(
                              "Send Reset Link",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
