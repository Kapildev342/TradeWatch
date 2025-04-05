import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class NoResponsePage extends StatefulWidget {
  const NoResponsePage({Key? key}) : super(key: key);

  @override
  State<NoResponsePage> createState() => _NoResponsePageState();
}

class _NoResponsePageState extends State<NoResponsePage> {
  @override
  void initState() {
    getAllDataMain(name: 'No_Response_Page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          //  backgroundColor: const Color(0XFFFFFFFF),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            // backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0.0,
            leading: GestureDetector(
                onTap: () {
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 25,
                )),
          ),
          body: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg", width: 150),
                  ),
                  const Text(
                    "The requested content is no longer available",
                    style: TextStyle(color: Color(0XFF0EA102), fontSize: 14),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
