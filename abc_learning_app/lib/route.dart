import 'package:abc_learning_app/page/age_profile_page.dart';
import 'package:abc_learning_app/page/email_profile_page.dart';
import 'package:abc_learning_app/page/login_page.dart';
import 'package:abc_learning_app/page/name_profile_page.dart';
import 'package:abc_learning_app/page/password_profile_page.dart';
import 'package:abc_learning_app/page/register_page.dart';
import 'package:abc_learning_app/page/splash_page.dart';
import 'package:abc_learning_app/page/starter_page.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashPage.routeName: (context) => SplashPage(),
  StarterPage.routeName: (context) => StarterPage(),
  LoginPage.routeName: (context) => LoginPage(),
  RegisterPage.routeName: (context) => RegisterPage(),
  AgeProfile.routeName: (context) => AgeProfile(),
  NameProfilePage.routeName: (context) => NameProfilePage(),
  EmailProfile.routeName: (context) => EmailProfile(),
  PasswordProfile.routeName: (context) => PasswordProfile(),
};
