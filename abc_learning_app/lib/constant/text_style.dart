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
    letterSpacing: -0.7,
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

  //Profile - property Page
  static const TextStyle profileTitle = TextStyle(
    fontSize: 22,
    color: ColorPalette.profileTitle,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.lexend,
    letterSpacing: -1,
  );

  //No Internet Page
  static const TextStyle noInternetTitle = TextStyle(
    fontSize: 22,
    color: Color(0xff212121),
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle noInternetDes = TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle verifyCode = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.poppins,
    letterSpacing: -0.24,
  );
  static const TextStyle verifyDes = TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontFamily: AppFonts.poppins,
    letterSpacing: -0.24,
  );

  //home page
  static const TextStyle titleComponent = TextStyle(
    fontSize: 20,
    color: ColorPalette.titleComponent,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle progress = TextStyle(
    fontSize: 10,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.poppins,
    letterSpacing: -0.24,
  );
  static const TextStyle bottomBar = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.inter,
  );

  //Achievement Page
  static const TextStyle pageTitle = TextStyle(
    fontSize: 18,
    color: ColorPalette.pageTitle,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
    letterSpacing: -0.7,
  );
  static const TextStyle heading = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.lexend,
    letterSpacing: -1,
  );
  static const TextStyle content = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontFamily: AppFonts.lexend,
  );

  //Listening Main Page
  static const TextStyle titlePage = TextStyle(
    fontSize: 28,
    color: ColorPalette.titlePage,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle itemTitle = TextStyle(
    fontSize: 18,
    color: ColorPalette.titlePage,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
    letterSpacing: -0.7,
  );
  static const TextStyle itemprogress = TextStyle(
    fontSize: 10,
    color: Color(0xff898A8D),
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.poppins,
    letterSpacing: -0.41,
  );

  //question
  static const TextStyle questionResult = TextStyle(
    fontSize: 20,
    color: Colors.green,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle questionLabel = TextStyle(
    fontSize: 17,
    color: Colors.green,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle trueAnswer = TextStyle(
    fontSize: 24,
    color: Colors.green,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.poppins,
  );

  //Reading Page
  static const TextStyle storyTitle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle storyContent = TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle storyQuestion = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle storyAnswer = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.poppins,
    letterSpacing: -0.41,
  );

  //Exercise Page
  static const TextStyle exerciseContent = TextStyle(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle result = TextStyle(
    fontSize: 28,
    color: Colors.green,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.lexend,
  );

  //Profile Page
  static const TextStyle kindUser = TextStyle(
    fontSize: 12,
    color: ColorPalette.kindUser,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle labelField = TextStyle(
    fontSize: 12,
    color: ColorPalette.kindUser,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle nameFunction = TextStyle(
    fontSize: 16,
    color: ColorPalette.nameFunction,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.lexend,
  );
  static const TextStyle logOutTitle = TextStyle(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.poppins,
  );
  static const TextStyle logOutContent = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.poppins,
  );

  //Privacy Page
  static const TextStyle privacyContent = TextStyle(
    fontSize: 16,
    color: Color(0xff707070),
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.lexend,
    letterSpacing: 0.2,
  );
}

class AppFonts {
  static const String lexend = 'Lexend';
  static const String monter = 'Montserrat';
  static const String inter = 'Inter';
  static const String poppins = 'Poppins';
}
