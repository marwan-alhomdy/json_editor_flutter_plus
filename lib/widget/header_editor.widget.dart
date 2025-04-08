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
      required this.onFormat});

  final Widget searchWidget;

  final bool hideEditorsMenuButton;
  final List<Widget> actions;

  final JsonManager jsonManager;

  final Function(Editors) onChangedEditor;

  final VoidCallback onExpandAll;
  final VoidCallback onCollapseAll;
  final VoidCallback onFormat;

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
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        child: Row(
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
                  return <PopupMenuEntry<Editors>>[
                    PopupMenuItem<Editors>(
                      height: popupMenuHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      enabled: jsonManager.editors.contains(Editors.tree),
                      value: Editors.tree,
                      child: const Text("Tree"),
                    ),
                    PopupMenuItem<Editors>(
                      height: popupMenuHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      enabled: jsonManager.editors.contains(Editors.text),
                      value: Editors.text,
                      child: const Text("Text"),
                    ),
                  ];
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(jsonManager.editor.name, style: textStyle),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            const Spacer(),
            if (jsonManager.editor == Editors.text) ...[
              const SizedBox(width: 20),
              InkWell(
                onTap: onFormat,
                child: const Tooltip(
                  message: 'Format',
                  child: Icon(Icons.format_align_left, size: 20),
                ),
              ),
            ] else ...[
              const SizedBox(width: 20),
              if (jsonManager.results != null) ...[
                Text("${jsonManager.results} results"),
                const SizedBox(width: 5),
              ],
              searchWidget,
              const SizedBox(width: 20),
              InkWell(
                onTap: onExpandAll,
                child: const Tooltip(
                  message: 'Expand All',
                  child: Icon(Icons.expand, size: 20),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: onCollapseAll,
                child: const Tooltip(
                  message: 'Collapse All',
                  child: Icon(Icons.compress, size: 20),
                ),
              ),
            ],
            const SizedBox(width: 20),
            InkWell(
              onTap: copyData,
              child: const Tooltip(
                message: 'Copy',
                child: Icon(Icons.copy, size: 20),
              ),
            ),
            if (actions.isNotEmpty) const SizedBox(width: 20),
            ...actions,
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
