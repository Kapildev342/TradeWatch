import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/industries_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/tickers_list_page_model.dart';

class BottomSheetPageWidgets {
  Widget categoryBottomSheetFunction({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Categories",
                style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height / 28.86,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 41.1)),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        const Text("save"),
                      ],
                    )),
              ),
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: communitiesVariables.categoriesList.value.response.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                    title: Text(
                      communitiesVariables.categoriesList.value.response[index].name.value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: text.scale(14),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    secondary: Container(
                      height: height / 24.74,
                      width: width / 11.74,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.hardEdge,
                      child: communitiesVariables.categoriesList.value.response[index].image.value.contains(".png")
                          ? Image.asset(
                              communitiesVariables.categoriesList.value.response[index].image.value,
                              fit: BoxFit.fill,
                            )
                          : SvgPicture.asset(
                              communitiesVariables.categoriesList.value.response[index].image.value,
                              fit: BoxFit.fill,
                            ),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: communitiesVariables.categoriesList.value.response[index].slug.value,
                    groupValue: communitiesVariables.selectedCategoryForCommunity.value.slug.value,
                    onChanged: (value) {
                      communitiesVariables.selectedCategoryForCommunity.value = communitiesVariables.categoriesList.value.response[index];
                      communitiesVariables.selectedCategoryForCommunity.refresh();
                      communitiesVariables.selectedCategoryForCommunity.value.slug.refresh();
                      communitiesVariables.categoriesController.value.text = communitiesVariables.categoriesList.value.response[index].name.value;
                      communitiesFunctions.getData();
                      modelSetState(() {});
                    });
              })
        ],
      ),
    );
  }

  Widget exchangeBottomSheetFunction({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Exchanges",
                style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height / 28.86,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 41.1)),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        const Text("save"),
                      ],
                    )),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: communitiesVariables.exchangeList!.value.response.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                    title: Text(
                      communitiesVariables.exchangeList!.value.response[index].name.value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: text.scale(14),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: communitiesVariables.exchangeList!.value.response[index].id.value,
                    groupValue: communitiesVariables.selectedExchangeForCommunity.value.id.value,
                    onChanged: (value) {
                      communitiesVariables.selectedExchangeForCommunity.value = communitiesVariables.exchangeList!.value.response[index];
                      communitiesVariables.selectedExchangeForCommunity.refresh();
                      communitiesVariables.selectedExchangeForCommunity.value.id.refresh();
                      communitiesVariables.exchangeController.value.text = communitiesVariables.exchangeList!.value.response[index].name.value;
                      communitiesVariables.industriesController.value.text = "";
                      communitiesVariables.tickerController.value.text = "";
                      communitiesVariables.selectedIndustriesListForCommunity = RxList<String>([]);
                      communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
                      modelSetState(() {});
                    });
              })
        ],
      ),
    );
  }

  Widget typeBottomSheetFunction({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Crypto Type",
                style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height / 28.86,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 41.1)),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        const Text("save"),
                      ],
                    )),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: communitiesVariables.cryptoIndustriesList!.value.response.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                    title: Text(
                      communitiesVariables.cryptoIndustriesList!.value.response[index].name.value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: text.scale(14),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: communitiesVariables.cryptoIndustriesList!.value.response[index].id.value,
                    groupValue: communitiesVariables.selectedCryptoTypeForCommunity.value.id.value,
                    onChanged: (value) {
                      communitiesVariables.tickerController.value.text = "";
                      communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
                      communitiesVariables.selectedCryptoTypeForCommunity.value = communitiesVariables.cryptoIndustriesList!.value.response[index];
                      communitiesVariables.selectedCryptoTypeForCommunity.refresh();
                      communitiesVariables.selectedCryptoTypeForCommunity.value.id.refresh();
                      communitiesVariables.cryptoTypeController.value.text =
                          communitiesVariables.cryptoIndustriesList!.value.response[index].name.value;
                      modelSetState(() {});
                    });
              })
        ],
      ),
    );
  }

  Widget countriesBottomSheetFunction({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Country",
                style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height / 28.86,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 41.1)),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        const Text("save"),
                      ],
                    )),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: communitiesVariables.commodityCountriesList!.value.response.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                    title: Text(
                      communitiesVariables.commodityCountriesList!.value.response[index].name.value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: text.scale(14),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: communitiesVariables.commodityCountriesList!.value.response[index].id.value,
                    groupValue: communitiesVariables.selectedCountryForCommunity.value.id.value,
                    onChanged: (value) {
                      communitiesVariables.tickerController.value.text = "";
                      communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
                      communitiesVariables.selectedCountryForCommunity.value = communitiesVariables.commodityCountriesList!.value.response[index];
                      communitiesVariables.selectedCountryForCommunity.refresh();
                      communitiesVariables.selectedCountryForCommunity.value.id.refresh();
                      communitiesVariables.countryController.value.text =
                          communitiesVariables.commodityCountriesList!.value.response[index].name.value;
                      modelSetState(() {});
                    });
              })
        ],
      ),
    );
  }

  Widget industriesBottomSheetFunction({
    required BuildContext context,
    required StateSetter modelSetState,
    required int skipCount,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refController = RefreshController();
    return Container(
      height: height / 1.237,
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Industries",
                style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height / 28.86,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 41.1)),
                    onPressed: () async {
                      Navigator.pop(context);
                      communitiesVariables.tickerController.value.text = "";
                      communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
                      if (communitiesVariables.selectedIndustriesListForCommunity.isEmpty) {
                        communitiesVariables.industriesController.value.text = "None Selected";
                      } else if (communitiesVariables.selectedIndustriesListForCommunity.length == 1) {
                        for (int i = 0; i < communitiesVariables.industriesListForCommunity.length; i++) {
                          if (communitiesVariables.industriesListForCommunity[i].id.value ==
                              communitiesVariables.selectedIndustriesListForCommunity[0]) {
                            communitiesVariables.industriesController.value.text = communitiesVariables.industriesListForCommunity[i].name;
                          }
                        }
                      } else if (communitiesVariables.selectedIndustriesListForCommunity.length > 1) {
                        communitiesVariables.industriesController.value.text = "Multiple";
                      } else {
                        communitiesVariables.industriesController.value.text = "";
                      }
                      modelSetState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        const Text("save"),
                      ],
                    )),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            height: height / 17.32,
            child: TextFormField(
              style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w600),
              controller: communitiesVariables.textController.value,
              keyboardType: TextInputType.text,
              showCursor: true,
              cursorColor: const Color(0XFF0EA102),
              onChanged: (value) {
                String previousValue = value;
                Timer(const Duration(seconds: 1), () async {
                  if (previousValue == communitiesVariables.textController.value.text) {
                    Map<String, dynamic> industriesData = await communitiesFunctions.getCommunitiesIndustries(skipCount: 0, isEditing: false);
                    IndustriesListModel refIndustriesList = IndustriesListModel.fromJson(industriesData);
                    communitiesVariables.industriesListForCommunity.clear();
                    communitiesVariables.industriesListForCommunity.addAll(refIndustriesList.response);
                    if (communitiesVariables.industriesListForCommunity.length == communitiesVariables.selectedIndustriesListForCommunity.length) {
                      communitiesVariables.isIndustriesSelectedAll.value = true;
                    } else {
                      communitiesVariables.isIndustriesSelectedAll.value = false;
                    }
                    modelSetState(() {});
                  }
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: height / 173.2, left: width / 27.4),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                hintText: "search here",
              ),
            ),
          ),
          communitiesVariables.industriesListForCommunity.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: height / 57.73,
                ),
          communitiesVariables.industriesListForCommunity.isEmpty
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Obx(
                        () => CheckboxListTile(
                          value: communitiesVariables.isIndustriesSelectedAll.value,
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (value) {
                            if (value!) {
                              communitiesVariables.selectedIndustriesListForCommunity.clear();
                              for (int i = 0; i < communitiesVariables.industriesListForCommunity.length; i++) {
                                communitiesVariables.selectedIndustriesListForCommunity
                                    .add(communitiesVariables.industriesListForCommunity[i].id.value);
                              }
                            } else {
                              communitiesVariables.selectedIndustriesListForCommunity.clear();
                            }
                            communitiesVariables.isIndustriesSelectedAll.toggle();
                            communitiesVariables.isIndustriesSelectedAll.refresh();
                            modelSetState(() {});
                          },
                          autofocus: false,
                          activeColor: Colors.green,
                          title: const Text("Select All"),
                        ),
                      ),
                    ),
                  ],
                ),
          communitiesVariables.industriesListForCommunity.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: height / 57.73,
                ),
          Expanded(
            child: communitiesVariables.industriesListForCommunity.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'No response to display...',
                                  style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SmartRefresher(
                    controller: refController,
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("release to load more");
                        } else {
                          body = const Text("No more Data");
                        }
                        return SizedBox(
                          height: height / 15.74,
                          child: Center(child: body),
                        );
                      },
                    ),
                    onLoading: () async {
                      skipCount = skipCount + 20;
                      Map<String, dynamic> industriesData =
                          await communitiesFunctions.getCommunitiesIndustries(skipCount: skipCount, isEditing: false);
                      IndustriesListModel refIndustriesList = IndustriesListModel.fromJson(industriesData);
                      communitiesVariables.industriesListForCommunity.addAll(refIndustriesList.response);
                      if (communitiesVariables.isIndustriesSelectedAll.value) {
                        for (int i = 0; i < refIndustriesList.response.length; i++) {
                          communitiesVariables.selectedIndustriesListForCommunity.add(refIndustriesList.response[i].id.value);
                        }
                      }
                      if (!context.mounted) {
                        modelSetState(() {});
                      }
                      refController.loadComplete();
                    },
                    child: Obx(
                      () => ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: communitiesVariables.industriesListForCommunity.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                title: Text(
                                  communitiesVariables.industriesListForCommunity[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: text.scale(14),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: communitiesVariables.selectedIndustriesListForCommunity
                                    .contains(communitiesVariables.industriesListForCommunity[index].id.value),
                                autofocus: false,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  if (value!) {
                                    communitiesVariables.selectedIndustriesListForCommunity
                                        .add(communitiesVariables.industriesListForCommunity[index].id.value);
                                    if (communitiesVariables.industriesListForCommunity.length ==
                                        communitiesVariables.selectedIndustriesListForCommunity.length) {
                                      communitiesVariables.isIndustriesSelectedAll.value = true;
                                    }
                                  } else {
                                    communitiesVariables.selectedIndustriesListForCommunity
                                        .remove(communitiesVariables.industriesListForCommunity[index].id.value);
                                    communitiesVariables.isIndustriesSelectedAll.value = false;
                                  }
                                  communitiesVariables.selectedIndustriesListForCommunity.refresh();
                                  modelSetState(() {});
                                }
                                /*onChanged: (value) {
                                  if (value!) {
                                    communitiesVariables.selectedIndustriesListForCommunity
                                        .add(communitiesVariables.industriesListForCommunity[index].id.value);
                                    if (communitiesVariables.industriesListForCommunity.length ==
                                        communitiesVariables.selectedIndustriesListForCommunity.length) {
                                      communitiesVariables.isIndustriesSelectedAll.value = true;
                                    }
                                  } else {
                                    communitiesVariables.selectedIndustriesListForCommunity
                                        .remove(communitiesVariables.industriesListForCommunity[index].id.value);
                                    communitiesVariables.isIndustriesSelectedAll.value = false;
                                  }
                                  communitiesVariables.selectedIndustriesListForCommunity.refresh();
                                  if (communitiesVariables.selectedIndustriesListForCommunity.isEmpty) {
                                    communitiesVariables.industriesController.value.text = "None Selected";
                                  } else if (communitiesVariables.selectedIndustriesListForCommunity.length == 1) {
                                    for (int i = 0; i < communitiesVariables.industriesListForCommunity.length; i++) {
                                      if (communitiesVariables.industriesListForCommunity[i].id.value ==
                                          communitiesVariables.selectedIndustriesListForCommunity[0]) {
                                        communitiesVariables.tickerController.value.text = communitiesVariables.industriesListForCommunity[i].name;
                                      }
                                    }
                                  } else if (communitiesVariables.selectedIndustriesListForCommunity.length > 1) {
                                    communitiesVariables.industriesController.value.text = "Multiple";
                                  } else {
                                    communitiesVariables.industriesController.value.text = "";
                                  }
                                  modelSetState(() {});
                                }*/
                                );
                          }),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget tickersBottomSheetFunction({
    required BuildContext context,
    required StateSetter modelSetState,
    required int skipCount,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    RefreshController refController = RefreshController();
    return Container(
      height: height / 1.237,
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Companies",
                style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height / 28.86,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height / 288.6, horizontal: width / 41.1)),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (communitiesVariables.selectedTickersListForCommunity.isEmpty) {
                        communitiesVariables.tickerController.value.text = "None Selected";
                      } else if (communitiesVariables.selectedTickersListForCommunity.length == 1) {
                        for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
                          if (communitiesVariables.tickersListForCommunity[i].id.value == communitiesVariables.selectedTickersListForCommunity[0]) {
                            communitiesVariables.tickerController.value.text = communitiesVariables.tickersListForCommunity[i].name;
                          }
                        }
                      } else if (communitiesVariables.selectedTickersListForCommunity.length > 1) {
                        communitiesVariables.tickerController.value.text = "Multiple";
                      } else {
                        communitiesVariables.tickerController.value.text = "";
                      }
                      modelSetState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 41.1,
                        ),
                        const Text("save"),
                      ],
                    )),
              )
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          SizedBox(
            height: height / 17.32,
            child: TextFormField(
              style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w600),
              controller: communitiesVariables.tickerTextController.value,
              keyboardType: TextInputType.text,
              showCursor: true,
              cursorColor: const Color(0XFF0EA102),
              onChanged: (value) {
                String previousValue = value;
                Timer(const Duration(seconds: 1), () async {
                  if (previousValue == communitiesVariables.tickerTextController.value.text) {
                    Map<String, dynamic> tickersData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
                    TickersListModel refTickersList = TickersListModel.fromJson(tickersData);
                    communitiesVariables.tickersListForCommunity.clear();
                    communitiesVariables.tickersListForCommunity.addAll(refTickersList.response);
                    if (communitiesVariables.tickersListForCommunity.length == communitiesVariables.selectedTickersListForCommunity.length) {
                      communitiesVariables.isTickerSelectedAll.value = true;
                    } else {
                      communitiesVariables.isTickerSelectedAll.value = false;
                    }
                    modelSetState(() {});
                  }
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: height / 173.2, left: width / 27.4),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                hintText: "search here",
              ),
            ),
          ),
          communitiesVariables.tickersListForCommunity.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: height / 57.73,
                ),
          communitiesVariables.tickersListForCommunity.isEmpty
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Obx(
                        () => CheckboxListTile(
                          value: communitiesVariables.isTickerSelectedAll.value,
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (value) {
                            if (value!) {
                              communitiesVariables.selectedTickersListForCommunity.clear();
                              for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
                                communitiesVariables.selectedTickersListForCommunity.add(communitiesVariables.tickersListForCommunity[i].id.value);
                              }
                            } else {
                              communitiesVariables.selectedTickersListForCommunity.clear();
                            }
                            communitiesVariables.isTickerSelectedAll.toggle();
                            communitiesVariables.isTickerSelectedAll.refresh();
                            modelSetState(() {});
                          },
                          autofocus: false,
                          activeColor: Colors.green,
                          title: const Text("Select All"),
                        ),
                      ),
                    ),
                  ],
                ),
          communitiesVariables.tickersListForCommunity.isEmpty ? const SizedBox() : SizedBox(height: height / 57.73),
          Expanded(
            child: communitiesVariables.tickersListForCommunity.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'No response to display...',
                                  style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SmartRefresher(
                    controller: refController,
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("release to load more");
                        } else {
                          body = const Text("No more Data");
                        }
                        return SizedBox(
                          height: height / 15.74,
                          child: Center(child: body),
                        );
                      },
                    ),
                    onLoading: () async {
                      skipCount = skipCount + 20;
                      Map<String, dynamic> tickersData = await communitiesFunctions.getCommunitiesTickers(skipCount: skipCount, isEditing: false);
                      TickersListModel refTickersList = TickersListModel.fromJson(tickersData);
                      communitiesVariables.tickersListForCommunity.addAll(refTickersList.response);
                      if (communitiesVariables.isTickerSelectedAll.value) {
                        for (int i = 0; i < refTickersList.response.length; i++) {
                          communitiesVariables.selectedTickersListForCommunity.add(refTickersList.response[i].id.value);
                        }
                      }
                      if (!context.mounted) {
                        modelSetState(() {});
                      }
                      refController.loadComplete();
                    },
                    child: Obx(
                      () => ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: communitiesVariables.tickersListForCommunity.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                title: Text(
                                  communitiesVariables.tickersListForCommunity[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: text.scale(14),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: communitiesVariables.selectedTickersListForCommunity
                                    .contains(communitiesVariables.tickersListForCommunity[index].id.value),
                                secondary: Container(
                                  height: height / 28.86,
                                  width: width / 13.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(communitiesVariables.tickersListForCommunity[index].logoUrl),
                                      )),
                                ),
                                autofocus: false,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  if (value!) {
                                    communitiesVariables.selectedTickersListForCommunity
                                        .add(communitiesVariables.tickersListForCommunity[index].id.value);
                                    if (communitiesVariables.tickersListForCommunity.length ==
                                        communitiesVariables.selectedTickersListForCommunity.length) {
                                      communitiesVariables.isTickerSelectedAll.value = true;
                                    }
                                  } else {
                                    communitiesVariables.selectedTickersListForCommunity
                                        .remove(communitiesVariables.tickersListForCommunity[index].id.value);
                                    communitiesVariables.isTickerSelectedAll.value = false;
                                  }
                                  communitiesVariables.selectedTickersListForCommunity.refresh();
                                  modelSetState(() {});
                                });
                          }),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
