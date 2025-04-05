import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/industries_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/tickers_list_page_model.dart';

class BottomSheetsPage extends StatefulWidget {
  final String topic;
  final bool isEditing;

  const BottomSheetsPage({super.key, required this.topic, required this.isEditing});

  @override
  State<BottomSheetsPage> createState() => _BottomSheetsPageState();
}

class _BottomSheetsPageState extends State<BottomSheetsPage> {
  bool loader = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    if (widget.isEditing) {
      debugPrint("do nothing");
      setState(() {
        loader = true;
      });
    } else {
      if (widget.topic == "Industry") {
        communitiesVariables.industriesListForCommunity.clear();
        communitiesVariables.textController.value.clear();
        communitiesVariables.isIndustriesSelectedAll.value = false;
        Map<String, dynamic> industriesData = await communitiesFunctions.getCommunitiesIndustries(skipCount: 0, isEditing: false);
        IndustriesListModel refIndustriesList = IndustriesListModel.fromJson(industriesData);
        communitiesVariables.industriesListForCommunity.addAll(refIndustriesList.response);
        communitiesVariables.isIndustriesSelectedAll.value =
            communitiesVariables.selectedIndustriesListForCommunity.length == communitiesVariables.industriesListForCommunity.length;
        setState(() {
          loader = true;
        });
      } else if (widget.topic == "Company") {
        communitiesVariables.tickersListForCommunity.clear();
        communitiesVariables.tickerTextController.value.clear();
        communitiesVariables.isTickerSelectedAll.value = false;
        Map<String, dynamic> tickerData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
        TickersListModel refTickersList = TickersListModel.fromJson(tickerData);
        communitiesVariables.tickersListForCommunity.addAll(refTickersList.response);
        setState(() {
          loader = true;
        });
      } else {
        setState(() {
          loader = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (loader) {
      switch (widget.topic) {
        case "Content Categories":
          {
            return bottomSheetPageWidgets.categoryBottomSheetFunction(context: context, modelSetState: setState);
          }
        case "Exchange":
          {
            return bottomSheetPageWidgets.exchangeBottomSheetFunction(context: context, modelSetState: setState);
          }
        case "Industry":
          {
            return bottomSheetPageWidgets.industriesBottomSheetFunction(context: context, modelSetState: setState, skipCount: 0);
          }
        case "Type":
          {
            return bottomSheetPageWidgets.typeBottomSheetFunction(context: context, modelSetState: setState);
          }
        case "Country":
          {
            return bottomSheetPageWidgets.countriesBottomSheetFunction(context: context, modelSetState: setState);
          }
        case "Company":
          {
            return bottomSheetPageWidgets.tickersBottomSheetFunction(context: context, modelSetState: setState, skipCount: 0);
          }
        default:
          {
            return Container();
          }
      }
    } else {
      return SizedBox(
        height: height / 1.237,
        child: Center(
          child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
        ),
      );
    }
  }
}
