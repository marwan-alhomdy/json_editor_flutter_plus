import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../constants/enum.dart';
import '../manager/json.manager.dart';

class HeaderEditorWidget extends StatelessWidget {
  const HeaderEditorWidget(
      {super.key,
      required this.searchWidget,
      required this.hideEditorsMenuButton,
      required this.actions,
      required this.jsonManager,
      required this.onChangedEditor,
      required this.onExpandAll,
      required this.onCollapseAll,
      required this.onFormat,
      required this.onSave,
      this.foregroundColor});

  final Widget searchWidget;

  final bool hideEditorsMenuButton;
  final List<Widget> actions;

  final JsonManager jsonManager;

  final Function(Editors) onChangedEditor;

  final VoidCallback onExpandAll;
  final VoidCallback onCollapseAll;
  final VoidCallback onFormat;

  final Function(Object?) onSave;

  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: jsonManager.themeColor,
          border: jsonManager.onError
              ? const Border(
                  bottom: BorderSide(color: Colors.red, width: 2),
                )
              : null),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Column(
          children: [
            if (jsonManager.editor == Editors.tree)
              Row(
                spacing: 10,
                children: [
                  Expanded(child: searchWidget),
                  if (jsonManager.results != null)
                    Text(
                      "${jsonManager.results} results",
                      style: TextStyle(color: foregroundColor),
                    ),
                ],
              ),
            Row(
              children: [
                if (!hideEditorsMenuButton)
                  PopupMenuButton<Editors>(
                    initialValue: jsonManager.editor,
                    tooltip: 'Change editor',
                    padding: EdgeInsets.zero,
                    onSelected: onChangedEditor,
                    position: PopupMenuPosition.under,
                    enabled: jsonManager.editors.length > 1,
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 150,
                    ),
                    itemBuilder: (context) {
                      return List.generate(
                        jsonManager.editors.length,
                        (index) => PopupMenuItem<Editors>(
                          height: popupMenuHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          enabled: jsonManager.editors
                              .contains(jsonManager.editors[index]),
                          value: jsonManager.editors[index],
                          child: Text(jsonManager.editors[index].name),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(jsonManager.editor.name,
                            style: textStyle.copyWith(
                              color: foregroundColor,
                            )),
                        Icon(Icons.arrow_drop_down,
                            color: foregroundColor, size: 20),
                      ],
                    ),
                  ),
                const Spacer(),
                if (jsonManager.editor == Editors.text) ...[
                  IconButton(
                    onPressed: onFormat,
                    iconSize: 20,
                    tooltip: 'Format',
                    color: foregroundColor,
                    icon: const Icon(Icons.format_align_left),
                  ),
                ] else ...[
                  IconButton(
                    onPressed: onExpandAll,
                    iconSize: 20,
                    tooltip: 'Expand All',
                    color: foregroundColor,
                    icon: const Icon(Icons.expand),
                  ),
                  IconButton(
                    onPressed: onCollapseAll,
                    iconSize: 20,
                    tooltip: 'Collapse All',
                    color: foregroundColor,
                    icon: const Icon(Icons.compress),
                  ),
                ],
                IconButton(
                  onPressed: copyData,
                  iconSize: 20,
                  tooltip: 'Copy',
                  color: foregroundColor,
                  icon: const Icon(Icons.copy),
                ),
                IconButton(
                  onPressed: () => onSave(jsonManager.data),
                  iconSize: 20,
                  tooltip: 'Save',
                  color: foregroundColor,
                  icon: const Icon(Icons.save),
                ),
                ...actions,
              ],
            ),
          ],
        ),
      ),
    );
  }

  void copyData() async {
    await Clipboard.setData(
      ClipboardData(text: jsonEncode(jsonManager.data)),
    );
  }
}
