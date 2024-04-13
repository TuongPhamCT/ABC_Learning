import 'package:abc_learning_app/page/splash_page.dart';
import 'package:abc_learning_app/page/starter_page.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashPage.routeName: (context) => SplashPage(),
  StarterPage.routeName: (context) => StarterPage(),
};
