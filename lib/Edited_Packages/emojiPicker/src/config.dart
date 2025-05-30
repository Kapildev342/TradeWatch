import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/category_emoji.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/category_icons.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/emoji_picker.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/recent_tab_behavior.dart';

/// Default Widget if no recent is available
const DefaultNoRecentsWidget = Text(
  'No Recents',
  style: TextStyle(fontSize: 20, color: Colors.black26),
  textAlign: TextAlign.center,
);

/// Config for customizations
class Config {
  /// Constructor
  const Config({
    this.columns = 7,
    this.emojiSizeMax = 32.0,
    this.verticalSpacing = 0,
    this.horizontalSpacing = 0,
    this.gridPadding = EdgeInsets.zero,
    this.initCategory = Category.RECENT,
    this.bgColor = const Color(0xFFEBEFF2),
    this.indicatorColor = Colors.blue,
    this.iconColor = Colors.grey,
    this.iconColorSelected = Colors.blue,
    this.backspaceColor = Colors.blue,
    this.skinToneDialogBgColor = Colors.white,
    this.skinToneIndicatorColor = Colors.grey,
    this.enableSkinTones = true,
    this.recentTabBehavior = RecentTabBehavior.RECENT,
    this.recentsLimit = 28,
    this.replaceEmojiOnLimitExceed = false,
    this.noRecents = DefaultNoRecentsWidget,
    this.loadingIndicator = const SizedBox.shrink(),
    this.tabIndicatorAnimDuration = kTabScrollDuration,
    this.categoryIcons = const CategoryIcons(),
    this.buttonMode = ButtonMode.MATERIAL,
    this.checkPlatformCompatibility = true,
    this.emojiSet,
    this.emojiTextStyle,
  });

  /// Number of emojis per row
  final int columns;

  /// Width and height the emoji will be maximal displayed
  /// Can be smaller due to screen size and amount of columns
  final double emojiSizeMax;

  /// Verical spacing between emojis
  final double verticalSpacing;

  /// Horizontal spacing between emojis
  final double horizontalSpacing;

  /// The initial [Category] that will be selected
  /// This [Category] will have its button in the bottombar darkened
  final Category initCategory;

  /// The background color of the Widget
  final Color bgColor;

  /// The color of the category indicator
  final Color indicatorColor;

  /// The color of the category icons
  final Color iconColor;

  /// The color of the category icon when selected
  final Color iconColorSelected;

  /// The color of the backspace icon button
  final Color backspaceColor;

  /// The background color of the skin tone dialog
  final Color skinToneDialogBgColor;

  /// Color of the small triangle next to multiple skin tone emoji
  final Color skinToneIndicatorColor;

  /// Enable feature to select a skin tone of certain emoji's
  final bool enableSkinTones;

  /// Behavior of Recent Tab (Recent, Popular)
  final RecentTabBehavior recentTabBehavior;

  /// Limit of recently used emoji that will be saved
  final int recentsLimit;

  /// A widget (usually [Text]) to be displayed if no recent emojis to display
  final Widget noRecents;

  /// A widget to display while emoji picker is initializing
  final Widget loadingIndicator;

  /// Duration of tab indicator to animate to next category
  final Duration tabIndicatorAnimDuration;

  /// Determines the icon to display for each [Category]
  final CategoryIcons categoryIcons;

  /// Choose visual response for tapping on an emoji cell
  final ButtonMode buttonMode;

  /// The padding of GridView, default is [EdgeInsets.zero]
  final EdgeInsets gridPadding;

  /// Replace latest emoji on recents list on limit exceed
  final bool replaceEmojiOnLimitExceed;

  /// Verify that emoji glyph is supported by the platform (Android only)
  final bool checkPlatformCompatibility;

  /// Custom emojis; if set, overrides default emojis provided by the library
  final List<CategoryEmoji>? emojiSet;

  /// Custom emoji text style to apply to emoji characters in the grid
  ///
  /// If you define a custom fontFamily or use GoogleFonts to set this property
  /// be sure to set [checkPlatformCompatibility] to false. It will improve
  /// initalization performance and prevent technically supported glyphs from
  /// being filtered out.
  final TextStyle? emojiTextStyle;

  /// Get Emoji size based on properties and screen width
  double getEmojiSize(double width) {
    final maxSize = width / columns;
    return min(maxSize, emojiSizeMax);
  }

  /// Returns the icon for the category
  IconData getIconForCategory(Category category) {
    switch (category) {
      case Category.RECENT:
        return categoryIcons.recentIcon;
      case Category.SMILEYS:
        return categoryIcons.smileyIcon;
      case Category.ANIMALS:
        return categoryIcons.animalIcon;
      case Category.FOODS:
        return categoryIcons.foodIcon;
      case Category.TRAVEL:
        return categoryIcons.travelIcon;
      case Category.ACTIVITIES:
        return categoryIcons.activityIcon;
      case Category.OBJECTS:
        return categoryIcons.objectIcon;
      case Category.SYMBOLS:
        return categoryIcons.symbolIcon;
      case Category.FLAGS:
        return categoryIcons.flagIcon;
      default:
        throw Exception('Unsupported Category');
    }
  }

  @override
  bool operator ==(other) {
    return (other is Config) &&
        other.columns == columns &&
        other.emojiSizeMax == emojiSizeMax &&
        other.verticalSpacing == verticalSpacing &&
        other.horizontalSpacing == horizontalSpacing &&
        other.initCategory == initCategory &&
        other.bgColor == bgColor &&
        other.indicatorColor == indicatorColor &&
        other.iconColor == iconColor &&
        other.iconColorSelected == iconColorSelected &&
        other.backspaceColor == backspaceColor &&
        other.skinToneDialogBgColor == skinToneDialogBgColor &&
        other.skinToneIndicatorColor == skinToneIndicatorColor &&
        other.enableSkinTones == enableSkinTones &&
        other.recentTabBehavior == recentTabBehavior &&
        other.recentsLimit == recentsLimit &&
        other.noRecents == noRecents &&
        other.loadingIndicator == loadingIndicator &&
        other.tabIndicatorAnimDuration == tabIndicatorAnimDuration &&
        other.categoryIcons == categoryIcons &&
        other.buttonMode == buttonMode &&
        other.gridPadding == gridPadding &&
        other.replaceEmojiOnLimitExceed == replaceEmojiOnLimitExceed &&
        other.checkPlatformCompatibility == checkPlatformCompatibility &&
        other.emojiSet == emojiSet &&
        other.emojiTextStyle == emojiTextStyle;
  }

  @override
  int get hashCode =>
      columns.hashCode ^
      emojiSizeMax.hashCode ^
      verticalSpacing.hashCode ^
      horizontalSpacing.hashCode ^
      initCategory.hashCode ^
      bgColor.hashCode ^
      indicatorColor.hashCode ^
      iconColor.hashCode ^
      iconColorSelected.hashCode ^
      backspaceColor.hashCode ^
      skinToneDialogBgColor.hashCode ^
      skinToneIndicatorColor.hashCode ^
      enableSkinTones.hashCode ^
      recentTabBehavior.hashCode ^
      recentsLimit.hashCode ^
      noRecents.hashCode ^
      loadingIndicator.hashCode ^
      tabIndicatorAnimDuration.hashCode ^
      categoryIcons.hashCode ^
      buttonMode.hashCode ^
      gridPadding.hashCode ^
      replaceEmojiOnLimitExceed.hashCode ^
      checkPlatformCompatibility.hashCode ^
      (emojiSet?.hashCode ?? 0) ^
      (emojiTextStyle?.hashCode ?? 0);
}
