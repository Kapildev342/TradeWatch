import 'dart:core';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Edited_Packages/PopUpLibrary/popup_menu_item.dart';
import 'popup_menu_item_widget.dart';
import 'triangle_painter.dart';

typedef PopupMenuStateChanged = Function(bool isShow);

class PopupMenu {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  OverlayEntry? entry;
  late List<MenuItemProvider> itemsList;
  int _row = 1;
  int _col = 1;
  late Offset _offset;
  late Rect _showRect;
  bool _isDown = true;
  int _maxColumn = 4;
  VoidCallback? dismissCallback;
  PopupMenuStateChanged? popUpStateChanged;
  late Size _screenSize;
  static late BuildContext buildContext;
  late Color _backgroundColor;
  late Color _highlightColor;
  late Color _lineColor;
  bool _isShow = false;
  bool get isShow => _isShow;
  late bool dismissOnClickAway;

  PopupMenu({
    required BuildContext context,
    required List<MenuItemProvider> items,
    VoidCallback? onDismiss,
    int maxColumns = 4,
    Color? backgroundColor,
    Color? highlightColor,
    Color? lineColor,
    PopupMenuStateChanged? stateChanged,
    bool? disClickAway,
  }) {
    dismissCallback = onDismiss;
    popUpStateChanged = stateChanged;
    itemsList = items;
    _maxColumn = maxColumns;
    _backgroundColor = backgroundColor ?? const Color(0xff232323);
    _lineColor = lineColor ?? const Color(0xFFF8F8F8);
    _highlightColor = highlightColor ?? const Color(0x55000000);
    buildContext = context;
    dismissOnClickAway = disClickAway ?? true;
  }

  void show({Rect? rect, GlobalKey? widgetKey, List<MenuItemProvider>? items}) {
    if (rect == null && widgetKey == null) {
      debugPrint("'rect' and 'key' can't be both null");
      return;
    }
    itemsList = items ?? itemsList;
    itemWidth = itemsList.length == 1 ? 300 : 72.0;
    itemHeight = itemsList.length == 1 ? 300 : 65.0;
    _showRect = rect ?? PopupMenu.getWidgetGlobalRect(widgetKey!);
    _screenSize = Size(Get.size.width, Get.size.height);
    dismissCallback = dismissCallback;
    _calculatePosition(PopupMenu.buildContext);
    entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });
    Overlay.of(PopupMenu.buildContext)!.insert(entry!);
    _isShow = true;
    if (popUpStateChanged != null) {
      popUpStateChanged!(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    print(_col);
    _row = _calculateRowCount();
    print(_row);
    _offset = _calculateOffset(PopupMenu.buildContext);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return itemWidth * _col;
  }

  double menuHeight() {
    return itemHeight * _row;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (dismissOnClickAway) {
            dismiss();
          }
        },
        onVerticalDragStart: (DragStartDetails details) {
          if (dismissOnClickAway) {
            dismiss();
          }
        },
        onHorizontalDragStart: (DragStartDetails details) {
          if (dismissOnClickAway) {
            dismiss();
          }
        },
        child: Stack(
          children: <Widget>[
            // triangle arrow
            Positioned(
              left: _showRect.left + _showRect.width / 2.0 - 7.5,
              top: _isDown ? offset.dy + menuHeight() : offset.dy - arrowHeight,
              child: CustomPaint(
                size: Size(25.0, arrowHeight),
                painter: TrianglePainter(isDown: _isDown, color: Colors.black26.withOpacity(0.3)),
              ),
            ),
            // menu content
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Container(
                width: menuWidth() + 2,
                height: menuHeight() + 2,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(color: _backgroundColor, borderRadius: BorderRadius.circular(10.0), boxShadow: [
                  BoxShadow(color: Colors.black26.withOpacity(0.3), offset: const Offset(0.0, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                ]),
                child: Column(
                  children: _createRows(),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  List<Widget> _createRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _row; i++) {
      //    Color color = (i < _row - 1 && _row != 1) ? _lineColor : Colors.transparent;
      Widget rowWidget = Row(
        children: _createRowItems(i),
      );

      rows.add(rowWidget);
    }

    return rows;
  }

  List<Widget> _createRowItems(int row) {
    List<MenuItemProvider> subItems = itemsList.sublist(
      row * _col,
      min(row * _col + _col, itemsList.length),
    );
    List<Widget> itemWidgets = [];
    int i = 0;
    for (var item in subItems) {
      itemWidgets.add(
        _createMenuItem(
          item,
          i < (_col - 1),
        ),
      );
      i++;
    }
    return itemWidgets;
  }

  int _calculateRowCount() {
    if (itemsList.isEmpty) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = itemsList.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  int _calculateColCount() {
    if (itemsList.isEmpty) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = itemsList.length;

    if (_maxColumn != 4 && _maxColumn > 0) {
      return _maxColumn;
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= _maxColumn) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return _maxColumn;
  }

  double get screenWidth {
    double width = Get.size.width;
    double ratio = Get.size.aspectRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItemProvider item, bool showLine) {
    return MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: _lineColor,
      backgroundColor: _backgroundColor,
      highlightColor: _highlightColor,
    );
  }

  Future<void> itemClicked(MenuItemProvider item) async {
    item.clickAction();
    await Future.delayed(const Duration(milliseconds: 500));
    dismiss();
  }

  void dismiss() {
    print(_isShow);
    print(dismissCallback != null);
    print(popUpStateChanged != null);
    if (!_isShow) {
      /// Remove method should only be called once
      return;
    }
    entry?.remove();
    _isShow = false;
    print(_isShow);
    if (dismissCallback != null) {
      dismissCallback!();
    }

    if (popUpStateChanged != null) {
      popUpStateChanged!(false);
    }
  }
}
