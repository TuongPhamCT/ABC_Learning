import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const String routeName = 'splash_page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: ColorPalette.primaryColor,
        child: GradientText(
          'ABC\nLearning',
          textAlign: TextAlign.center,
          colors: [
            Colors.white,
            Colors.amber,
            Colors.grey,
          ],
          style: TextStyle(
            fontSize: 65,
            fontFamily: AppFonts.lexend,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
