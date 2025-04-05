import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/emoji_picker_flutter.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/skin_tone_overlay.dart';

/// Default EmojiPicker Implementation
class DefaultEmojiPickerView extends EmojiPickerBuilder {
  /// Constructor
  DefaultEmojiPickerView(Config config, EmojiViewState state) : super(config, state);

  @override
  _DefaultEmojiPickerViewState createState() => _DefaultEmojiPickerViewState();
}

class _DefaultEmojiPickerViewState extends State<DefaultEmojiPickerView> with SingleTickerProviderStateMixin, SkinToneOverlayStateMixin {
  final double _tabBarHeight = 46;
  late PageController _pageController;
  late TabController _tabController;
  late final _scrollController = ScrollController();
  late final _utils = EmojiPickerUtils();
  CategoryEmoji customizedEmojiList = const CategoryEmoji(Category.CUSTOMISED, [
    Emoji('👍', 'Thumbs Up', hasSkinTone: true),
    Emoji('🎊', 'Confetti Ball'),
    Emoji('😍', 'Smiling Face With Heart-Eyes'),
    Emoji('😄', 'Grinning Face With Smiling Eyes'),
    Emoji('😆', 'Grinning Squinting Face'),
    Emoji('😯', 'Hushed Face'),
    Emoji('🙁', 'Slightly Frowning Face'),
    Emoji('😥', 'Sad but Relieved Face'),
    Emoji('😡', 'Pouting Face'),
    Emoji('🤔', 'Thinking Face'),
    Emoji('🔥', 'Fire'),
  ]);

  @override
  void initState() {
    var initCategory = widget.state.categoryEmoji.indexWhere((element) => element.category == widget.config.initCategory);
    if (initCategory == -1) {
      initCategory = 0;
    }
    _tabController = TabController(initialIndex: initCategory, length: widget.state.categoryEmoji.length, vsync: this);
    _pageController = PageController(initialPage: initCategory)..addListener(closeSkinToneOverlay);
    _scrollController.addListener(closeSkinToneOverlay);
    super.initState();
  }

  @override
  void dispose() {
    closeSkinToneOverlay();
    _pageController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return EmojiContainer(
          color: Colors.green.withOpacity(0.01), //widget.config.bgColor,
          buttonMode: widget.config.buttonMode,
          child: Column(
            children: [
              Flexible(child: _buildPage(25, customizedEmojiList)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage(double emojiSize, CategoryEmoji categoryEmoji) {
    return GestureDetector(
      onTap: closeSkinToneOverlay,
      child: GridView.count(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          primary: false,
          padding: widget.config.gridPadding,
          crossAxisCount: widget.config.columns,
          mainAxisSpacing: widget.config.verticalSpacing,
          crossAxisSpacing: widget.config.horizontalSpacing,
          children: categoryEmoji.emoji
              .map((emoji) => EmojiCell.fromConfig(
                    emoji: emoji,
                    //categoryEmoji.emoji[i],
                    emojiSize: emojiSize,
                    categoryEmoji: categoryEmoji,
                    index: 0,
                    onEmojiSelected: (category, emoji) {
                      closeSkinToneOverlay();
                      widget.state.onEmojiSelected(category, emoji);
                    },
                    onSkinToneDialogRequested: _openSkinToneDialog,
                    config: widget.config,
                  ))
              .toList()
          /*[

            for (int i = 0; i < categoryEmoji.emoji.length; i++)
              EmojiCell.fromConfig(
                emoji: categoryEmoji.emoji[i],
                emojiSize: emojiSize,
                categoryEmoji: categoryEmoji,
                index: i,
                onEmojiSelected: (category, emoji) {
                  closeSkinToneOverlay();
                  widget.state.onEmojiSelected(category, emoji);
                },
                onSkinToneDialogRequested: _openSkinToneDialog,
                config: widget.config,
              )
          ]*/
          ),
    );
  }

  void _openSkinToneDialog(
    Emoji emoji,
    double emojiSize,
    CategoryEmoji? categoryEmoji,
    int index,
  ) {
    closeSkinToneOverlay();
    if (!emoji.hasSkinTone || !widget.config.enableSkinTones) {
      return;
    }
    showSkinToneOverlay(emoji, emojiSize, categoryEmoji, index, kSkinToneCount, widget.config, _scrollController.offset, _tabBarHeight, _utils,
        _onSkinTonedEmojiSelected);
  }

  void _onSkinTonedEmojiSelected(Category? category, Emoji emoji) {
    widget.state.onEmojiSelected(category, emoji);
    closeSkinToneOverlay();
  }
}
