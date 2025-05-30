import 'package:flutter/material.dart';

abstract class MenuItemProvider {
  String get menuTitle;
  Widget? get menuImage;
  Widget? get menuListTile;
  TextStyle get menuTextStyle;
  TextAlign get menuTextAlign;
  Function get clickAction;
}

class CustomPopupMenuItem extends MenuItemProvider {
  Widget? image;
  Widget? listTileWidget;
  String title;
  TextStyle textStyle;
  TextAlign textAlign;
  Function press;

  CustomPopupMenuItem({
    this.title = "",
    this.image,
    this.listTileWidget,
    required this.textStyle,
    required this.textAlign,
    required this.press,
  });

  @override
  Function get clickAction => press;

  @override
  Widget? get menuImage => image;

  @override
  Widget? get menuListTile => listTileWidget;

  @override
  String get menuTitle => title;

  @override
  TextStyle get menuTextStyle => textStyle;

  @override
  TextAlign get menuTextAlign => textAlign;

}
