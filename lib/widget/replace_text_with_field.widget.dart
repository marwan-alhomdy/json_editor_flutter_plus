import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ReplaceTextWithField extends StatefulWidget {
  const ReplaceTextWithField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.setState,
    this.isKey = false,
    this.isHighlighted = false,
  });

  final dynamic initialValue;
  final bool isKey;
  final ValueChanged<Object> onChanged;
  final StateSetter setState;
  final bool isHighlighted;

  @override
  State<ReplaceTextWithField> createState() => _ReplaceTextWithFieldState();
}

class _ReplaceTextWithFieldState extends State<ReplaceTextWithField> {
  late final _focusNode = FocusNode();
  bool _isFocused = false;
  bool _value = false;
  String _text = "";
  late final BoxConstraints _constraints;

  void handleChange() {
    if (!_focusNode.hasFocus) {
      _text = _text.trim();
      final val = num.tryParse(_text);
      if (val == null) {
        widget.onChanged(_text);
      } else {
        widget.onChanged(val);
      }

      setState(() {
        _isFocused = false;
      });
    }
  }

  Widget wrapWithColoredBox(String keyName) {
    if (widget.isHighlighted) {
      return ColoredBox(
        color: Colors.amber,
        child: Text(keyName, style: textStyle),
      );
    }
    return Text(keyName, style: textStyle);
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialValue is bool) {
      _value = widget.initialValue;
    } else {
      if (widget.initialValue == newKey) {
        _text = "";
        _isFocused = true;
        _focusNode.requestFocus();
      } else {
        _text = widget.initialValue.toString();
      }
    }

    if (widget.isKey) {
      _constraints = const BoxConstraints(minWidth: 20, maxWidth: 100);
    } else if (widget.initialValue is num) {
      _constraints = const BoxConstraints(minWidth: 20, maxWidth: 80);
    } else {
      _constraints = const BoxConstraints(minWidth: 20, maxWidth: 200);
    }

    _focusNode.addListener(handleChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(handleChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue is bool) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 0.75,
            child: Checkbox(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: _value,
              onChanged: (value) {
                widget.onChanged(value!);
                setState(() {
                  _value = value;
                });
              },
            ),
          ),
          Text(_value.toString(), style: textStyle),
        ],
      );
    } else {
      if (_isFocused) {
        return TextFormField(
          initialValue: _text,
          focusNode: _focusNode,
          onChanged: (value) => _text = value,
          autocorrect: false,
          cursorWidth: 1,
          style: textStyle,
          cursorHeight: 12,
          decoration: InputDecoration(
            constraints: _constraints,
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.all(3),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(width: 0.3),
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              _isFocused = true;
            });
            _focusNode.requestFocus();
          },
          mouseCursor: WidgetStateMouseCursor.textable,
          child: widget.initialValue is String && _text.isEmpty
              ? const SizedBox(width: 200, height: 18)
              : wrapWithColoredBox(_text),
        );
      }
    }
  }
}
