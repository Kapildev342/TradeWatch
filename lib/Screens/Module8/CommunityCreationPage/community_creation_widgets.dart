import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/BottomSheets/bottom_sheets_page.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/post_limitation_model.dart';

class CommunityCreationWidgets {
  Widget textFieldFunction({
    required BuildContext context,
    required String topic,
    required TextEditingController controller,
  }) {
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 57.73),
        Text(topic, style: TextStyle(fontSize: text.scale(12), color: const Color(0XFF666565), fontWeight: FontWeight.w500)),
        SizedBox(height: height / 86.6),
        TextFormField(
          style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w600),
          controller: controller,
          keyboardType: TextInputType.text,
          showCursor: true,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
            hintText: topic,
          ),
          maxLines: 4,
          minLines: 1,
        ),
      ],
    );
  }

  Widget categoriesTextFieldFunction({
    required BuildContext context,
    required String topic,
    required TextEditingController controller,
    required bool isEditing,
  }) {
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 57.73),
        Text(topic, style: TextStyle(fontSize: text.scale(12), color: const Color(0XFF666565), fontWeight: FontWeight.w500)),
        SizedBox(height: height / 86.6),
        TextFormField(
          readOnly: true,
          style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w600),
          controller: controller,
          keyboardType: TextInputType.text,
          showCursor: false,
          onTap: () {
            if (topic == "Company" &&
                communitiesVariables.selectedCategoryForCommunity.value.slug.value == "stocks" &&
                communitiesVariables.selectedIndustriesListForCommunity.isEmpty) {
              Flushbar(
                message: "Please choose at least one industry in industry tab.",
                duration: const Duration(seconds: 2),
              ).show(context);
            } else {
              selectionBottomSheet(context: context, topic: topic, isEditing: isEditing);
            }
          },
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
            hintText: topic,
          ),
        ),
      ],
    );
  }

  Widget postLimitationFunction({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      children: [
        SizedBox(
          height: height / 17.32,
          child: ListView.builder(
              itemCount: communitiesVariables.postLimitationData.value.response.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    communitiesVariables.selectedPostLimitResponseOptionValue.clear();
                    communitiesVariables.selectedPostLimitValue.value = communitiesVariables.postLimitationData.value.response[index];
                    communitiesVariables.selectedPostLimitResponseOptionValue
                        .add(communitiesVariables.postLimitationData.value.response[index].options[0].slug.value);
                  },
                  child: SizedBox(
                    width: width / 3,
                    child: Obx(
                      () => Row(
                        children: [
                          Radio(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: communitiesVariables.postLimitationData.value.response[index].slug.value,
                            groupValue: communitiesVariables.selectedPostLimitValue.value.slug.value,
                            onChanged: (value) {
                              communitiesVariables.selectedPostLimitResponseOptionValue.clear();
                              communitiesVariables.selectedPostLimitValue.value = communitiesVariables.postLimitationData.value.response[index];
                              communitiesVariables.selectedPostLimitResponseOptionValue
                                  .add(communitiesVariables.postLimitationData.value.response[index].options[0].slug.value);
                            },
                          ),
                          Text(
                            communitiesVariables.postLimitationData.value.response[index].name.value,
                            style: TextStyle(
                                fontSize: text.scale(12),
                                color: communitiesVariables.postLimitationData.value.response[index].slug.value ==
                                        communitiesVariables.selectedPostLimitValue.value.slug.value
                                    ? const Color(0XFF0EA102)
                                    : const Color(0XFF666565),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Container(
          width: width,
          margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 57.73),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.tertiary,
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Obx(() => ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: communitiesVariables.selectedPostLimitValue.value.options.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: communitiesVariables.selectedPostLimitResponseOptionValue
                      .contains(communitiesVariables.selectedPostLimitValue.value.options[index].slug.value),
                  activeColor: const Color(0XFF0EA102),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  onChanged: (value) {
                    if (value!) {
                      communitiesVariables.selectedPostLimitResponseOptionValue
                          .add(communitiesVariables.selectedPostLimitValue.value.options[index].slug.value);
                      communitiesVariables.selectedPostLimitResponseOptionValue.refresh();
                    } else {
                      communitiesVariables.selectedPostLimitResponseOptionValue.refresh();
                      if (communitiesVariables.selectedPostLimitResponseOptionValue.length < 2) {
                        Flushbar(
                          message: "You must select at least one",
                          duration: const Duration(seconds: 2),
                        ).show(context);
                      } else {
                        communitiesVariables.selectedPostLimitResponseOptionValue
                            .remove(communitiesVariables.selectedPostLimitValue.value.options[index].slug.value);
                        communitiesVariables.selectedPostLimitResponseOptionValue.refresh();
                      }
                    }
                    modelSetState(() {});
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    communitiesVariables.selectedPostLimitValue.value.options[index].name.value,
                    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                  ),
                );
              })),
        )
      ],
    );
  }

  Widget subscriptionFunction({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    List<String> subscriptionType = ["Free", "Paid"];
    return SizedBox(
      height: height / 17.32,
      width: width / 1.5,
      child: ListView.builder(
          itemCount: subscriptionType.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: width / 3.5,
              child: Obx(() => RadioListTile(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    contentPadding: EdgeInsets.zero,
                    value: subscriptionType[index],
                    groupValue: communitiesVariables.selectedSubscriptionType.value,
                    onChanged: (value) {
                      if (value == "Paid") {
                        Flushbar(
                          message: "This feature will reflect in next update",
                          duration: const Duration(seconds: 2),
                        ).show(context);
                      } else {
                        communitiesVariables.selectedSubscriptionType.value = subscriptionType[index];
                      }
                    },
                    title: Text(
                      subscriptionType[index],
                      style: TextStyle(
                          fontSize: text.scale(12),
                          color: subscriptionType[index] == communitiesVariables.selectedSubscriptionType.value
                              ? const Color(0XFF0EA102)
                              : const Color(0XFF666565),
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            );
          }),
    );
  }

  Widget paidSubscriptionFunc({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: communitiesVariables.paymentController.length,
      itemBuilder: (BuildContext context, int superIndex) {
        return Container(
          width: width,
          margin: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 57.73),
          padding: EdgeInsets.symmetric(vertical: height / 57.73),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.tertiary,
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Subscription type",
                      style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                    ),
                    communitiesVariables.selectedSubscriptionPeriodValue.length > 1
                        ? InkWell(
                            onTap: () {
                              communitiesVariables.selectedSubscriptionPeriodValue.removeAt(superIndex);
                              communitiesVariables.selectedTrailAvailableValue.removeAt(superIndex);
                              communitiesVariables.selectedTrailFreeValue.removeAt(superIndex);
                              communitiesVariables.paymentController.removeAt(superIndex);
                              communitiesVariables.discountController.removeAt(superIndex);
                              communitiesVariables.isDiscountAvailable.removeAt(superIndex);
                              communitiesVariables.periodDataSlugList.removeAt(superIndex);
                            },
                            child: Image.asset(
                              "lib/Constants/Assets/ForumPage/x.png",
                              height: height / 43.3,
                              width: width / 20.55,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: height / 17.32,
                child: ListView.builder(
                    itemCount: communitiesVariables.subscriptionPeriodData.value.response.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (communitiesVariables.periodDataSlugList
                              .contains(communitiesVariables.subscriptionPeriodData.value.response[index].slug.value)) {
                            Flushbar(
                              message: "You already added for this subscription period",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          } else {
                            communitiesVariables.selectedSubscriptionPeriodValue[superIndex] =
                                communitiesVariables.subscriptionPeriodData.value.response[index];
                          }
                        },
                        child: SizedBox(
                          width: width / 4.5,
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: communitiesVariables.subscriptionPeriodData.value.response[index].slug.value,
                                  groupValue: communitiesVariables.selectedSubscriptionPeriodValue[superIndex].slug.value,
                                  fillColor: communitiesVariables.subscriptionPeriodData.value.response[index].slug.value ==
                                          communitiesVariables.selectedSubscriptionPeriodValue[superIndex].slug.value
                                      ? MaterialStateProperty.all(const Color(0XFF0EA102))
                                      : communitiesVariables.periodDataSlugList
                                              .contains(communitiesVariables.subscriptionPeriodData.value.response[index].slug.value)
                                          ? MaterialStateProperty.all(Colors.grey)
                                          : MaterialStateProperty.all(const Color(0XFF0EA102)),
                                  onChanged: (value) {
                                    if (communitiesVariables.periodDataSlugList
                                        .contains(communitiesVariables.subscriptionPeriodData.value.response[index].slug.value)) {
                                      Flushbar(
                                        message: "You already added for this subscription period",
                                        duration: const Duration(seconds: 2),
                                      ).show(context);
                                    } else {
                                      communitiesVariables.selectedSubscriptionPeriodValue[superIndex] =
                                          communitiesVariables.subscriptionPeriodData.value.response[index];
                                    }
                                  },
                                ),
                                Text(
                                  communitiesVariables.subscriptionPeriodData.value.response[index].name.value,
                                  style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: communitiesVariables.subscriptionPeriodData.value.response[index].slug.value ==
                                              communitiesVariables.selectedSubscriptionPeriodValue[superIndex].slug.value
                                          ? const Color(0XFF0EA102)
                                          : const Color(0XFF666565),
                                      fontWeight: FontWeight.w500,
                                      decoration: communitiesVariables.subscriptionPeriodData.value.response[index].slug.value ==
                                              communitiesVariables.selectedSubscriptionPeriodValue[superIndex].slug.value
                                          ? TextDecoration.none
                                          : communitiesVariables.periodDataSlugList
                                                  .contains(communitiesVariables.subscriptionPeriodData.value.response[index].slug.value)
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.tertiary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.background,
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width / 2.49,
                        child: Text(
                          "Do you have a trial period?",
                          style: TextStyle(fontSize: text.scale(11), color: const Color(0XFF666565), fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: height / 34.64,
                        width: width / 2.74,
                        child: ListView.builder(
                            itemCount: communitiesVariables.trailAvailableData.value.response.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  communitiesVariables.selectedTrailAvailableValue[superIndex] =
                                      communitiesVariables.trailAvailableData.value.response[index];
                                },
                                child: SizedBox(
                                  width: width / 5.48,
                                  child: Obx(
                                    () => Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: communitiesVariables.trailAvailableData.value.response[index].slug.value,
                                          groupValue: communitiesVariables.selectedTrailAvailableValue[superIndex].slug.value,
                                          onChanged: (value) {
                                            communitiesVariables.selectedTrailAvailableValue[superIndex] =
                                                communitiesVariables.trailAvailableData.value.response[index];
                                          },
                                        ),
                                        Text(
                                          communitiesVariables.trailAvailableData.value.response[index].name.value,
                                          style: TextStyle(
                                            fontSize: text.scale(10),
                                            color: communitiesVariables.trailAvailableData.value.response[index].slug.value ==
                                                    communitiesVariables.selectedTrailAvailableValue[superIndex].slug.value
                                                ? const Color(0XFF0EA102)
                                                : const Color(0XFF666565),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => communitiesVariables.selectedTrailAvailableValue[superIndex].slug.value == "no"
                    ? const SizedBox()
                    : communityCreationWidgets.freeTrailWidget(context: context, superIndex: superIndex),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.tertiary,
                    boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.background, blurRadius: 4, spreadRadius: 0)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${communitiesVariables.selectedSubscriptionPeriodValue[superIndex].name.value} payment",
                        style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: width / 4,
                        height: height / 28.86,
                        child: Obx(
                          () => TextFormField(
                            style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w600),
                            controller: communitiesVariables.paymentController[superIndex],
                            keyboardType: TextInputType.phone,
                            showCursor: true,
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: width / 27.4),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              hintStyle: TextStyle(
                                  color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                              hintText: "1499",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: width / 51.375),
                                child: Text(
                                  "\u{20B9}",
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontFamily: "Robonto", fontSize: text.scale(16)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CheckboxListTile(
                value: communitiesVariables.isDiscountAvailable[superIndex],
                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onChanged: (value) {
                  communitiesVariables.isDiscountAvailable[superIndex] = value!;
                  modelSetState(() {});
                },
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: const Color(0XFF0EA102),
                title: Text(
                  "Do you have an entry discount?",
                  style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w400),
                ),
              ),
              communitiesVariables.isDiscountAvailable[superIndex]
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.tertiary,
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).colorScheme.background, offset: const Offset(0, 2), blurRadius: 7, spreadRadius: 5)
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Discount amount (in %)",
                              style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: width / 4,
                              height: height / 28.86,
                              child: Obx(
                                () => TextFormField(
                                  style: TextStyle(fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w600),
                                  controller: communitiesVariables.discountController[superIndex],
                                  keyboardType: TextInputType.phone,
                                  showCursor: true,
                                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    hintStyle: TextStyle(
                                        color: const Color(0XFFA5A5A5),
                                        fontSize: text.scale(12),
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Poppins"),
                                    hintText: "15",
                                    suffix: Padding(
                                      padding: EdgeInsets.only(left: width / 51.375),
                                      child: Text(
                                        "%",
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.onPrimary, fontFamily: "Robonto", fontSize: text.scale(16)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              superIndex == communitiesVariables.selectedSubscriptionPeriodValue.length - 1
                  ? communitiesVariables.selectedSubscriptionPeriodValue.length == 4
                      ? const SizedBox()
                      : SizedBox(height: height / 57.73)
                  : const SizedBox(),
              superIndex == communitiesVariables.selectedSubscriptionPeriodValue.length - 1
                  ? communitiesVariables.selectedSubscriptionPeriodValue.length == 4
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Need to add another Alert.",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: text.scale(12),
                                color: const Color(0XFF666565),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  communitiesVariables.periodDataSlugList.clear();
                                  for (int i = 0; i < communitiesVariables.selectedSubscriptionPeriodValue.length; i++) {
                                    communitiesVariables.periodDataSlugList.add(communitiesVariables.selectedSubscriptionPeriodValue[i].slug.value);
                                  }
                                  for (int i = 0; i < communitiesVariables.subscriptionPeriodData.value.response.length; i++) {
                                    if (communitiesVariables.periodDataSlugList
                                        .contains(communitiesVariables.subscriptionPeriodData.value.response[i].slug.value)) {
                                    } else {
                                      communitiesVariables.selectedSubscriptionPeriodValue
                                          .add(communitiesVariables.subscriptionPeriodData.value.response[i]);
                                      break;
                                    }
                                  }
                                  communitiesVariables.selectedTrailAvailableValue
                                      .add(PostLimitationResponse.fromJson({"name": "Yes", "slug": "yes"}));
                                  communitiesVariables.selectedTrailFreeValue.add(PostLimitationResponse.fromJson({"name": "7 days", "slug": "7"}));
                                  communitiesVariables.paymentController.add(TextEditingController());
                                  communitiesVariables.discountController.add(TextEditingController());
                                  communitiesVariables.paymentController[superIndex + 1].text = "1499";
                                  communitiesVariables.isDiscountAvailable.add(false);
                                  communitiesVariables.discountController[superIndex + 1].text = "15";
                                  if (communitiesVariables.paymentController.length == 4) {
                                    communitiesVariables.periodDataSlugList.clear();
                                    for (int i = 0; i < communitiesVariables.selectedSubscriptionPeriodValue.length; i++) {
                                      communitiesVariables.periodDataSlugList.add(communitiesVariables.selectedSubscriptionPeriodValue[i].slug.value);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Text(
                                    "Click Here",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: text.scale(12),
                                      color: communitiesVariables.paymentController[superIndex].text == "" ||
                                              communitiesVariables.discountController[superIndex].text == ""
                                          ? Colors.grey
                                          : const Color(0XFF0EA102),
                                    ),
                                  ),
                                )),
                          ],
                        )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget disclaimerFunc({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height / 57.73,
        ),
        Text(
          "Disclaimer",
          style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: height / 173.2,
        ),
        CheckboxListTile(
          value: communitiesVariables.isDisclaimerChecked.value,
          onChanged: (value) {
            communitiesVariables.isDisclaimerChecked.toggle();
          },
          activeColor: const Color(0XFF0EA102),
          contentPadding: EdgeInsets.zero,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          title: Text(
            "Lorem ipsum dolor sit amet, consec tetur adipis cing elit, sed do eiusmod tempor incid idunt ut labore",
            style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
            maxLines: 3,
          ),
          controlAffinity: ListTileControlAffinity.leading,
        )
      ],
    );
  }

  Widget freeTrailWidget({required BuildContext context, required int superIndex}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Free trial",
            style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: height / 17.32,
            child: ListView.builder(
                itemCount: communitiesVariables.trailFreeData.value.response.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      communitiesVariables.selectedTrailFreeValue[superIndex] = communitiesVariables.trailFreeData.value.response[index];
                    },
                    child: SizedBox(
                      width: width / 3.6,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Radio(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: communitiesVariables.trailFreeData.value.response[index].slug.value,
                              groupValue: communitiesVariables.selectedTrailFreeValue[superIndex].slug.value,
                              onChanged: (value) {
                                communitiesVariables.selectedTrailFreeValue[superIndex] = communitiesVariables.trailFreeData.value.response[index];
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 173.2),
                              decoration: BoxDecoration(
                                color: const Color(0XFF0EA102),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                communitiesVariables.trailFreeData.value.response[index].name.value,
                                style: TextStyle(fontSize: text.scale(12), color: const Color(0XFFFFFFFF), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  selectionBottomSheet({required BuildContext context, required String topic, required bool isEditing}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return BottomSheetsPage(
            topic: topic,
            isEditing: isEditing,
          );
        });
  }

  showChangeBottomSheet({required BuildContext context, required StateSetter modelSetState}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pop(context);
                        cameraImage(modelSetState: modelSetState);
                      },
                      minLeadingWidth: width / 25,
                      leading: SvgPicture.asset(
                        "lib/Constants/Assets/Settings/camera.svg",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Camera",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pop(context);
                        galleryImage(modelSetState: modelSetState);
                      },
                      minLeadingWidth: width / 25,
                      leading: SvgPicture.asset(
                        "lib/Constants/Assets/Settings/gallery.svg",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Image",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  galleryImage({required StateSetter modelSetState}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    cropImageFunc(currentImage: image!, modelSetState: modelSetState);
  }

  cameraImage({required StateSetter modelSetState}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    cropImageFunc(currentImage: image!, modelSetState: modelSetState);
  }

  cropImageFunc({required XFile currentImage, required StateSetter modelSetState}) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(sourcePath: currentImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: const Color(0XFF0EA102),
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: const Color(0XFF0EA102),
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: false,
          lockAspectRatio: false),
    ]);
    if (croppedFile != null) {
      modelSetState(() {
        communitiesVariables.selectedImageForCommunity = File(croppedFile.path);
      });
    } else {}
  }
}
