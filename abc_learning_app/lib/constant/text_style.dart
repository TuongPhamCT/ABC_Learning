import 'package:abc_learning_app/constant/color_palette.dart';
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

  //Login Page
  static const TextStyle loginTitle = TextStyle(
    fontSize: 16,
    color: ColorPalette.logintitle,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle loginText = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle loginButtonText = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle MediumTextRegular = TextStyle(
    fontSize: 14,
    color: Color(0xff3C3C43),
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle Typrography = TextStyle(
    fontSize: 32,
    color: Color(0xff273958),
    fontWeight: FontWeight.normal,
    letterSpacing: -0.24,
    fontFamily: AppFonts.lexend,
  );
}

class AppFonts {
  static const String lexend = 'Lexend';
  static const String monter = 'Montserrat';
  static const String inter = 'Inter';
}
