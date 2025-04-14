library json_editor_flutter_plus;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'constants/enum.dart';
import 'manager/json.manager.dart';
import 'widget/header_editor.widget.dart';
import 'widget/search_field.widget.dart';
import 'widget/syntax_error.widget.dart';
import 'widget/text_editors.widget.dart';
import 'widget/tree_editors.widget.dart';

bool _enableMoreOptions = true;
bool _enableKeyEdit = true;
bool _enableValueEdit = true;

/// Edit your JSON object with this Widget. Create, edit and format objects
/// using this user friendly widget.
class JsonEditor extends StatefulWidget {
  /// JSON can be edited in two ways, Tree editor or text editor. You can disable
  /// either of them.
  ///
  /// When UI editor is active, you can disable adding/deleting keys by using
  /// [enableMoreOptions]. Editing keys and values can also be disabled by using
  /// [enableKeyEdit] and [enableValueEdit].
  ///
  /// When text editor is active, it will simply ignore [enableMoreOptions],
  /// [enableKeyEdit] and [enableValueEdit].
  ///
  /// [duration] is the debounce time for [onChanged] function. Defaults to
  /// 500 milliseconds.
  ///
  /// [editors] is the supported list of editors. First element will be
  /// used as default editor. Defaults to `[Editors.tree, Editors.text]`.
  const JsonEditor({
    super.key,
    required this.json,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 500),
    this.enableMoreOptions = true,
    this.enableKeyEdit = true,
    this.enableValueEdit = true,
    this.editors = const [Editors.tree, Editors.text],
    this.themeColor,
    this.actions = const [],
    this.enableHorizontalScroll = false,
    this.searchDuration = const Duration(milliseconds: 500),
    this.hideEditorsMenuButton = false,
    this.expandedObjects = const [],
    required this.onSave,
  }) : assert(editors.length > 0, "editors list cannot be empty");

  /// JSON string to be edited.
  final String json;

  /// Callback function that will be called with the new [dynamic] data.
  final ValueChanged<dynamic> onChanged;

  /// Debounce duration for [onChanged] function.
  final Duration duration;

  /// Enables more options like adding or deleting data. Defaults to `true`.
  final bool enableMoreOptions;

  /// Enables editing of keys. Defaults to `true`.
  final bool enableKeyEdit;

  /// Enables editing of values. Defaults to `true`.
  final bool enableValueEdit;

  /// Theme color for the editor. Changes the border color and header color.
  final Color? themeColor;

  /// List of supported editors. First element will be used as default editor.
  final List<Editors> editors;

  /// A list of Widgets to display in a row at the end of header.
  final List<Widget> actions;

  /// Enables horizontal scroll for the tree view. Defaults to `false`.
  final bool enableHorizontalScroll;

  /// Debounce duration for search function.
  final Duration searchDuration;

  /// Hides the option of changing editor. Defaults to `false`.
  final bool hideEditorsMenuButton;

  /// [expandedObjects] refers to the objects that will be expanded by
  /// default. Index can be provided when the data is a List.
  ///
  /// Examples:
  /// ```dart
  /// data = {
  ///   "hobbies": ["Reading books", "Playing Cricket"],
  ///   "education": [
  ///     {"name": "Bachelor of Engineering", "marks": 75},
  ///     {"name": "Master of Engineering", "marks": 72},
  ///   ],
  /// }
  /// ```
  ///
  /// For the given data
  /// 1. To expand education pass => `["education"]`
  /// 2. To expand hobbies and education pass => `["hobbies", "education"]`
  /// 3. To expand the first element (index 0) of education list, this means
  /// we need to expand education too. In this case you need not to pass
  /// "education" separately. Just pass a list of all nested objects =>
  /// `[["education", 0]]`
  ///
  /// ```dart
  /// JsonEditor(
  ///   expandedObjects: const [
  ///     "hobbies",
  ///     ["education", 0] // expands nested object in education
  ///   ],
  ///   onChanged: (_) {},
  ///   json: jsonEncode(data),
  /// )
  /// ```
  final List expandedObjects;

  /// Callback function that will be called when the user clicks the save button.
  final Function(Object?) onSave;

  @override
  State<JsonEditor> createState() => _JsonEditorState();
}

class _JsonEditorState extends State<JsonEditor> {
  late final JsonManager jsonManager;

  @override
  void initState() {
    super.initState();

    _enableMoreOptions = widget.enableMoreOptions;
    _enableKeyEdit = widget.enableKeyEdit;
    _enableValueEdit = widget.enableValueEdit;
  }

  @override
  void didChangeDependencies() {
    jsonManager = JsonManager(
      context,
      themeColor: widget.themeColor,
      data: jsonDecode(widget.json),
      editors: widget.editors,
      duration: widget.duration,
      searchDuration: widget.searchDuration,
      onChangedJson: widget.onChanged,
      setState: setState,
      expandedObjects: widget.expandedObjects,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    jsonManager.timer?.cancel();
    jsonManager.searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          width: jsonManager.onError ? 2 : 1,
          color: jsonManager.onError ? Colors.red : Colors.transparent,
        ),
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderEditorWidget(
                actions: widget.actions,
                jsonManager: jsonManager,
                hideEditorsMenuButton: widget.hideEditorsMenuButton,
                onSave: widget.onSave,
                searchWidget: SearchFieldWidget(
                    onChanged: jsonManager.onSearch,
                    onAction: jsonManager.onSearchAction),
                onChangedEditor: (value) {
                  if (value == Editors.text) {
                    jsonManager.controller.text =
                        jsonManager.stringifyData(jsonManager.data, 0, true);
                  }
                  setState(() {
                    jsonManager.editor = value;
                  });
                },
                onExpandAll: () {
                  jsonManager.expandedObjects[["object"].toString()] = true;
                  jsonManager.expandAllObjects(jsonManager.data, ["object"]);
                  setState(() {});
                },
                onCollapseAll: () {
                  jsonManager.expandedObjects.clear();
                  setState(() {});
                },
                onFormat: () {
                  jsonManager.controller.text =
                      jsonManager.stringifyData(jsonManager.data, 0, true);
                }),
            if (jsonManager.onError) const SyntaxErrorWidget(),
            if (jsonManager.editor == Editors.tree)
              Expanded(
                child: TreeEditorsWidget(
                  jsonManager: jsonManager,
                  enableHorizontalScroll: widget.enableHorizontalScroll,
                  enableMoreOptions: _enableMoreOptions,
                  enableKeyEdit: _enableKeyEdit,
                  enableValueEdit: _enableValueEdit,
                ),
              ),
            if (jsonManager.editor == Editors.text)
              Expanded(
                  child: TextEditorsWidget(
                controller: jsonManager.controller,
                onChanged: jsonManager.parseData,
              )),
          ],
        ),
      ),
    );
  }
}
