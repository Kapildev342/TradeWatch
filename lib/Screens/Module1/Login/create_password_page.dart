import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'sign_in_page.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool doNotShowPassword = false;
  bool doNotShowPassword1 = false;
  bool loading = false;
  String loginUserId = "";

  @override
  void initState() {
    getAllDataMain(name: 'Create_Password_Page');
    getValue();
    doNotShowPassword = true;
    doNotShowPassword1 = true;
    super.initState();
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginUserId = prefs.getString('userId')!;
  }

  login({required String pass, required String conPass}) async {
    bool passWordValid = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(pass);
    if (pass == "" || conPass == "") {
      Flushbar(
        message: "Please fill all fields",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else if (!passWordValid) {
      Flushbar(
        message:
            "Password should contain Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else if (pass != conPass) {
      Flushbar(
        message: "Both password are Not Matched",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else {
      var url = Uri.parse(baseurl + versions + resetPassWord);
      var response = await http.post(url, body: {
        "password": pass,
        "changePassword": conPass,
        "id": loginUserId,
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      var responseData = json.decode(response.body);
      if (responseData["status"]) {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseData["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return const SignInPage();
        }));
        setState(() {
          loading = false;
        });
      } else {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseData["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
        //color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height / 11.94),
                  Text(
                    "Create New Password",
                    style: TextStyle(fontSize: text.scale(24), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                  ),
                  SizedBox(height: height / 67.66),
                  Text("You new password must be different from previous used passwords.",
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                  SizedBox(height: height / 33.83),
                  SizedBox(
                    height: height / 14.5,
                    child: TextFormField(
                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                      obscureText: doNotShowPassword,
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
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
                            TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              doNotShowPassword = !doNotShowPassword;
                            });
                          },
                          child: doNotShowPassword
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Color(0XFFA5A5A5),
                                  size: 25,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Color(0XFFA5A5A5),
                                  size: 25,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height / 67.66),
                  Text(
                    "Must be at least 8 Characters",
                    style: TextStyle(fontSize: text.scale(12), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                  ),
                  SizedBox(height: height / 67.66),
                  SizedBox(
                    height: height / 14.5,
                    child: TextFormField(
                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                      obscureText: doNotShowPassword1,
                      controller: _newPasswordController,
                      keyboardType: TextInputType.text,
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
                            TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              doNotShowPassword1 = !doNotShowPassword1;
                            });
                          },
                          child: doNotShowPassword1
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Color(0XFFA5A5A5),
                                  size: 25,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Color(0XFFA5A5A5),
                                  size: 25,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height / 67.66),
                  Text(
                    "Both passwords must match.",
                    style: TextStyle(fontSize: text.scale(12), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                  ),
                  SizedBox(
                    height: height / 25.77,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        loading = true;
                      });
                      login(pass: _passwordController.text, conPass: _newPasswordController.text);
                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return SignInPage(initialLink: null,);}));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0XFF0EA102),
                      ),
                      height: height / 14.5,
                      child: Center(
                        child: Text(
                          "Reset Password",
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
      ),
    );
  }
}
