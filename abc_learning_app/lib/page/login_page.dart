import 'package:abc_learning_app/component/google_login_dialog.dart';
import 'package:abc_learning_app/component/input_frame.dart';
import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:abc_learning_app/page/no_network_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Assuming using Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to home screen or another relevant screen on successful login
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      // Handle errors, perhaps show an AlertDialog with the error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(e.message ?? 'Unknown Error'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  Text(
                    'Input Your Password',
                    style: TextStyles.loginTitle,
                  ),
                  const Gap(8),
                  InputFrame(
                    hintText: 'Password',
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const Gap(17),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        var email = _emailController.text;
                        var password = _passwordController.text;
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đăng nhập thành công!'),
                            ),
                          );
                          Navigator.of(context)
                              .pushReplacementNamed(NoInteretPage.routeName);
                        } on FirebaseAuthException catch (e) {
                          // Handle errors
                          print(e
                              .message); // Consider using a more user-friendly error handling
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Email hoặc mật khẩu không đúng, xin vui lòng nhập lại!'),
                            ),
                          );
                        }
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
                      child: Text('Login', style: TextStyles.loginButtonText),
                    ),
                  ),
                  Gap(18),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GoogleLoginDialog(); // Hiển thị bottom sheet tài khoản Google
                        },
                        isScrollControlled:
                            true, // Đảm bảo bottom sheet chiếm nửa màn hình
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login With Google',
                          style: TextStyles.loginText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const Gap(12),
                        Icon(
                          FontAwesomeIcons.google,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                  Gap(45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Doesn\'t have an account? ',
                        style: TextStyles.MediumTextRegular.copyWith(
                          color: Color(0xff3C3C43).withOpacity(0.6),
                        ),
                      ),
                      const Gap(7),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RegisterPage.routeName);
                        },
                        child: Text(
                          'Register',
                          style: TextStyles.MediumTextRegular.copyWith(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
