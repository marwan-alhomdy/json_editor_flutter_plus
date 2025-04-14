import 'package:flutter/material.dart';

class TextEditorsWidget extends StatelessWidget {
  const TextEditorsWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPhysics: const ClampingScrollPhysics(),
      controller: controller,
      onChanged: onChanged,
      maxLines: null,
      minLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          left: 5,
          top: 8,
          bottom: 8,
        ),
      ),
    );
  }
}
