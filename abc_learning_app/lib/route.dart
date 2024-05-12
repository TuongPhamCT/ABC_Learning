import 'package:abc_learning_app/model/reading_data_model.dart';
import 'package:abc_learning_app/page/achievement_page.dart';
import 'package:abc_learning_app/page/age_profile_page.dart';
import 'package:abc_learning_app/page/email_profile_page.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/exercise/exercise_sub_page.dart';
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
  SplashPage.routeName: (context) => const SplashPage(),
  StarterPage.routeName: (context) => const StarterPage(),
  LoginPage.routeName: (context) => const LoginPage(),
  RegisterPage.routeName: (context) => const RegisterPage(),
  AgeProfile.routeName: (context) => const AgeProfile(),
  NameProfilePage.routeName: (context) => const NameProfilePage(
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
  NoInteretPage.routeName: (context) => const NoInteretPage(),
  ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
  HomePage.routeName: (context) => const HomePage(),
  AchievementPage.routeName: (context) => const AchievementPage(),
  ListenMainPage.routeName: (context) => const ListenMainPage(),
  ListenTopicPage.routeName: (context) => const ListenTopicPage(
        unitsId: '',
      ),
  ReadMainPage.routeName: (context) => const ReadMainPage(),
  ReadSubPage.routeName: (context) => ReadSubPage(
    readingTopic : ReadingTopic(topic: "topic", img_url: "img_url", maxQuestions: 1, unitId: "unitId")
  ),
  ExerciseMainPage.routeName: (context) => const ExerciseMainPage(),
  ExerciseSubPage.routeName: (context) => const ExerciseSubPage(),
};
