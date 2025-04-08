import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/enum.dart';

class OptionsWidget<T> extends StatelessWidget {
  const OptionsWidget(this.onSelected, {super.key});

  final void Function(OptionItems) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OptionItems>(
      tooltip: 'Add new object',
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) {
        return <PopupMenuEntry<OptionItems>>[
          if (T == Map)
            const PopupMenuWidget(Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5),
                Icon(Icons.add),
                SizedBox(width: 10),
                Text("Insert", style: TextStyle(fontSize: 14)),
              ],
            )),
          if (T == List)
            const PopupMenuWidget(Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5),
                Icon(Icons.add),
                SizedBox(width: 10),
                Text("Append", style: TextStyle(fontSize: 14)),
              ],
            )),
          if (T == Map || T == List) ...[
            const PopupMenuItem<OptionItems>(
              height: popupMenuHeight,
              padding: EdgeInsets.only(left: popupMenuItemPadding),
              value: OptionItems.string,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.abc),
                  SizedBox(width: 10),
                  Text("String", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const PopupMenuItem<OptionItems>(
              height: popupMenuHeight,
              padding: EdgeInsets.only(left: popupMenuItemPadding),
              value: OptionItems.num,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.onetwothree),
                  SizedBox(width: 10),
                  Text("Number", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const PopupMenuItem<OptionItems>(
              height: popupMenuHeight,
              padding: EdgeInsets.only(left: popupMenuItemPadding),
              value: OptionItems.bool,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded),
                  SizedBox(width: 10),
                  Text("Boolean", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const PopupMenuItem<OptionItems>(
              height: popupMenuHeight,
              padding: EdgeInsets.only(left: popupMenuItemPadding),
              value: OptionItems.map,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.data_object),
                  SizedBox(width: 10),
                  Text("Object", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const PopupMenuItem<OptionItems>(
              height: popupMenuHeight,
              padding: EdgeInsets.only(left: popupMenuItemPadding),
              value: OptionItems.list,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.data_array),
                  SizedBox(width: 10),
                  Text("List", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
          const PopupMenuDivider(height: 1),
          const PopupMenuItem<OptionItems>(
            height: popupMenuHeight,
            padding: EdgeInsets.only(left: 5),
            value: OptionItems.delete,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete),
                SizedBox(width: 10),
                Text("Delete", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ];
      },
      child: options,
    );
  }
}

class PopupMenuWidget extends PopupMenuEntry<Never> {
  const PopupMenuWidget(this.child, {super.key});

  final Widget child;

  @override
  final double height = popupMenuHeight;

  @override
  bool represents(_) => false;

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
