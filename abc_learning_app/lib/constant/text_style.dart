import 'package:flutter/material.dart';

extension ExtendedTextStyle on TextStyle {
  TextStyle get light {
    return copyWith(fontWeight: FontWeight.w300);
  }

  TextStyle get bold {
    return copyWith(fontWeight: FontWeight.bold);
  }

  TextStyle get semibold {
    return copyWith(fontWeight: FontWeight.bold);
  }

  TextStyle get extrabold {
    return copyWith(fontWeight: FontWeight.w900);
  }
}

class TextStyles {
  TextStyles(this.context);
  BuildContext? context;
}

class AppFonts {
  static const String lexend = 'Lexend';
  static const String monter = 'Montserrat';
  static const String inter = 'Inter';
}
