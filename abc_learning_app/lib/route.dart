import 'package:abc_learning_app/page/achievement_page.dart';
import 'package:abc_learning_app/page/age_profile_page.dart';
import 'package:abc_learning_app/page/email_profile_page.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/forgot_password_page.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:abc_learning_app/page/listening/in_a_topic_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:abc_learning_app/page/login_page.dart';
import 'package:abc_learning_app/page/name_profile_page.dart';
import 'package:abc_learning_app/page/no_network_page.dart';
import 'package:abc_learning_app/page/password_profile_page.dart';
import 'package:abc_learning_app/page/reading/read_main_page.dart';
import 'package:abc_learning_app/page/reading/read_sub_page.dart';
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
  NameProfilePage.routeName: (context) => NameProfilePage(
        age: '',
      ),
  EmailProfile.routeName: (context) => const EmailProfile(
        age: '', // Ensure constructor now accepts `age`
        name: '',
      ),
  PasswordProfile.routeName: (context) => const PasswordProfile(
        age: '',
        name: '',
        email: '',
      ),
  NoInteretPage.routeName: (context) => NoInteretPage(),
  ForgotPasswordPage.routeName: (context) => ForgotPasswordPage(),
  HomePage.routeName: (context) => HomePage(),
  AchievementPage.routeName: (context) => AchievementPage(),
  ListenMainPage.routeName: (context) => ListenMainPage(),
  ListenTopicPage.routeName: (context) => ListenTopicPage(),
  ReadMainPage.routeName: (context) => ReadMainPage(),
  ReadSubPage.routeName: (context) => ReadSubPage(),
  ExerciseMainPage.routeName: (context) => ExerciseMainPage(),
};
