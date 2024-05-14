import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorPalette.googleDialog.withOpacity(0.93),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Gap(15),
          Text(
            'Logout Account?',
            style: TextStyles.logOutTitle,
          ),
          Gap(10),
          Text(
            'Are you sure want to logout this account?',
            style: TextStyles.logOutContent,
          ),
          Expanded(child: Container()),
          ElevatedButton(
            onPressed: () {
              //TODO: Add logout function
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(8)),
              fixedSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * 0.8, 55)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: Colors.white, width: 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            child: Text('Log Out', style: TextStyles.loginButtonText),
          ),
          const Gap(15),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyles.logOutContent),
          ),
        ],
      ),
    );
  }
}
