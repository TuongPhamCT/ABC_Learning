import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controller/network_controller.dart';

class NoInteretPage extends StatefulWidget {
  const NoInteretPage({super.key});
  static const String routeName = 'no_internet_page';

  @override
  State<NoInteretPage> createState() => _NoInteretPageState();
}

class _NoInteretPageState extends State<NoInteretPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetHelper.noInternet,
              width: 325,
              height: 260,
            ),
            Text(
              'Not Connected',
              style: TextStyles.noInternetTitle,
            ),
            Gap(12),
            Text(
              'Ups. You are not connected to internet\nTry again',
              textAlign: TextAlign.center,
              style: TextStyles.noInternetDes,
            ),
            const Gap(30),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(8)),
                fixedSize:
                    MaterialStateProperty.all<Size>(Size(size.width / 2, 50)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
                side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.white, width: 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              child: Text(
                'Try Again',
                style:
                    TextStyles.loginButtonText.copyWith(letterSpacing: -0.41),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
