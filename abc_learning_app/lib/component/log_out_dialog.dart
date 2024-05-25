import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/starter_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorPalette.googleDialog.withOpacity(0.93),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const Gap(15),
          const Text(
            'Logout Account?',
            style: TextStyles.logOutTitle,
          ),
          const Gap(10),
          const Text(
            'Are you sure want to logout this account?',
            style: TextStyles.logOutContent,
          ),
          Expanded(child: Container()),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).pushNamed(StarterPage.routeName));
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(8)),
              fixedSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * 0.8, 55)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              side: MaterialStateProperty.all<BorderSide>(
                  const BorderSide(color: Colors.white, width: 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            child: const Text('Log Out', style: TextStyles.loginButtonText),
          ),
          const Gap(15),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyles.logOutContent),
          ),
        ],
      ),
    );
  }
}
