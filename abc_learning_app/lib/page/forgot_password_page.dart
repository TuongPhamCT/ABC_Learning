import 'package:abc_learning_app/component/input_frame.dart';
import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  static const String routeName = 'forgot_password_page';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(30),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                AssetHelper.logo,
                width: 310,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input Your Email',
                    style: TextStyles.loginTitle,
                  ),
                  const Gap(8),
                  InputFrame(hintText: 'Email', controller: _emailController),
                  const Gap(8),
                  const Gap(17),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        String email = _emailController.text.trim();
                        _resetPassword(email);
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(8)),
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size(size.width / 2, 55)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorPalette.primaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.white, width: 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      child: Text('Confirm', style: TextStyles.loginButtonText),
                    ),
                  ),
                  const Gap(18),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back to Login Page',
                        style: TextStyles.MediumTextRegular.copyWith(
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const Gap(45),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để gửi email thiết lập lại mật khẩu
  void _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('A password reset link has been sent to your email.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginPage.routeName);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Xử lý lỗi và hiển thị thông báo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to send password reset email. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
