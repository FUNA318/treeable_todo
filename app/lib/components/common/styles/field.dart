import 'package:app/colors.dart';
import 'package:flutter/material.dart';

class TextInputFieldStyles {
  static final outlinedTextFieldStyle = const InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.outline, width: 0.33),
    ),
    hintStyle: TextStyle(color: ThemeColors.outline),
  );
}
