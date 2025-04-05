import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Edited_Packages/PopUpLibrary/popup_menu.dart';
import 'package:tradewatchfinal/Edited_Packages/PopUpLibrary/popup_menu_item.dart';

class ContextualMenu extends StatefulWidget {
  final Widget child;
  final List<MenuItemProvider> items;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? lineColor;
  final BuildContext ctx;
  final GlobalKey targetWidgetKey;
  final Function()? onDismiss;
  final Function(bool)? stateChanged;
  final bool dismissOnClickAway;
  final int maxColumns;

  const ContextualMenu({
    Key? key,
    required this.targetWidgetKey,
    required this.child,
    required this.items,
    required this.ctx,
    this.backgroundColor,
    this.highlightColor,
    this.lineColor,
    this.onDismiss,
    this.dismissOnClickAway = true,
    this.stateChanged,
    this.maxColumns = 3,
  }) : super(key: key);

  @override
  State<ContextualMenu> createState() => _ContextualMenuState();
}

class _ContextualMenuState extends State<ContextualMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        PopupMenu popupMenu = PopupMenu(
          context: widget.ctx,
          backgroundColor: widget.backgroundColor,
          lineColor: widget.lineColor,
          maxColumns: widget.maxColumns,
          disClickAway: widget.dismissOnClickAway,
          items: widget.items,
          highlightColor: widget.highlightColor,
          stateChanged: widget.stateChanged,
          onDismiss: widget.onDismiss,
        );
        popupMenu.show(widgetKey: widget.targetWidgetKey);
      },
    );
  }
}
