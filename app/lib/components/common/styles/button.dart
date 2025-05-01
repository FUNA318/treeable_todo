import 'package:app/colors.dart';
import 'package:flutter/material.dart';

class FilledButtonStyles {
  static final primaryFilledButtonStyle = FilledButton.styleFrom(
    backgroundColor: ThemeColors.primary,
    foregroundColor: ThemeColors.onPrimary,
  );
}

class TextButtonStyles {
  static final primaryTextButtonStyle = TextButton.styleFrom(
    foregroundColor: ThemeColors.primary,
  );
}

class OutlinedButtonStyles {
  static final primaryOutlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: ThemeColors.primary,
  );
}
