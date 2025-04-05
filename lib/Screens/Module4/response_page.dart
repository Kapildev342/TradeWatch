import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class ResponsePage extends StatefulWidget {
  final String link;
  final String? notes;
  final String title;
  final String logo;
  final int cat;
  final int type;
  final int countryInd;

  const ResponsePage(
      {super.key,
      required this.notes,
      required this.link,
      required this.title,
      required this.logo,
      required this.cat,
      required this.type,
      required this.countryInd});

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  String splitText = "";
  String splitValue = "";

  @override
  void initState() {
    getAllDataMain(name: 'Response_Page');
    List<String> splitString = widget.title.split(" ");
    splitText = splitString.first;
    splitValue = splitString.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return const MainBottomNavigationPage(
            tType: true,
            caseNo1: 3,
            text: "",
            excIndex: 1,
            newIndex: 1,
            countryIndex: 0,
            isHomeFirstTym: false,
          );
        }));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0XFF48B83F),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height / 16.24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainBottomNavigationPage(
                                      tType: true,
                                      newIndex: widget.cat,
                                      excIndex: widget.type,
                                      text: '',
                                      caseNo1: 3,
                                      countryIndex: 0,
                                      isHomeFirstTym: false,
                                    )));
                      },
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.white,
                      ))
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(height: height / 2.15, width: width, child: Image.asset("lib/Constants/Assets/SMLogos/Ornament.png", fit: BoxFit.fill)),
                  Container(
                      height: height / 5.413,
                      width: width / 2.5,
                      margin: const EdgeInsets.only(top: 175),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: widget.logo.contains("svg")
                          ? SvgPicture.network(widget.logo, fit: BoxFit.fill)
                          : Image.network(widget.logo, fit: BoxFit.fill))
                ],
              ),
              Column(children: [
                widget.link == 'max'
                    ? Container(
                        //color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/Constants/Assets/SMLogos/applause.png",
                              height: 60,
                              width: 60,
                            ),
                            const SizedBox(width: 10),
                            const Center(
                              child: Text(
                                ' Congratulations!',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ))
                    : Container(
                        //color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/Constants/Assets/SMLogos/warning (1).png",
                              height: 60,
                              width: 60,
                            ),
                            const SizedBox(width: 10),
                            const Center(
                              child: Text(
                                ' Warning',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                SizedBox(height: height / 54.13),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Text(
                        "$splitText has matched your alert price and is currently trading at $splitValue",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    )),
                const SizedBox(
                  height: 75,
                ),
                Text(
                  widget.notes == null ? "" : "Notes: ' ${widget.notes} '",
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height / 19.33),
                /*Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.green,
                            // shadowColor: Colors.greenAccent,
                            shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: Size(_width/1.87, _height/16.91),),
                          onPressed: (){},
                          child: Text('Great,I will help more!! ',style: TextStyle(color: Color(0xff0EA102),fontSize: 14),
                          ),
                        )
                    )*/
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
