import 'package:abc_learning_app/component/dependency_injection.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/firebase_options.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:abc_learning_app/page/starter_page.dart';
import 'package:abc_learning_app/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ABC Learning',
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthenticationWrapper(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Wait for 5 seconds and then hide the splash screen
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return _showSplash ? SplashPage() : StarterPage();
    return FirebaseAuth.instance.currentUser == null ? const StarterPage() : const HomePage();
    // : StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return SplashScreen();
    //       } else {
    //         if (snapshot.hasData) {
    //           return FutureBuilder(
    //             future: AuthServices.UpdateCurrentUser(),
    //             builder:
    //                 (BuildContext context, AsyncSnapshot<void> snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) {
    //                 // Show a loading indicator if necessary
    //                 return SplashScreen();
    //               } else {
    //                 // If the update is complete, navigate to the MainScreen
    //                 return MainScreen();
    //               }
    //             },
    //           );
    //         } else {
    //           return LoginScreen();
    //         }
    //       }
    //     },
    //   );
  }
}
