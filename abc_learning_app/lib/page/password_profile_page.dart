import 'package:abc_learning_app/component/input_frame.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:abc_learning_app/page/no_network_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:abc_learning_app/page/login_page.dart';

class PasswordProfile extends StatefulWidget {
  final String age;
  final String name;
  final String email;
  const PasswordProfile(
      {Key? key, required this.age, required this.email, required this.name})
      : super(key: key);

  static const String routeName = 'password_profile_page';

  @override
  State<PasswordProfile> createState() => _PasswordProfileState();
}

class LoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _PasswordProfileState extends State<PasswordProfile> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationCodeController =
      TextEditingController();
  bool _isLoading = false; // Biến để kiểm soát hiển thị của LoadingSpinner
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          content: Container(
            height: 190,
            child: Column(
              children: [
                const Text('Verification Code', style: TextStyles.verifyCode),
                const Gap(30),
                const Text(
                  'A verification code was send to your email\nEnter code:',
                  style: TextStyles.verifyDes,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeColor: ColorPalette.primaryColor,
                    activeFillColor: ColorPalette.primaryColor,
                    selectedColor: ColorPalette.primaryColor,
                    selectedFillColor: ColorPalette.primaryColor,
                    inactiveColor: ColorPalette.primaryColor.withOpacity(0.44),
                    inactiveFillColor:
                        ColorPalette.primaryColor.withOpacity(0.44),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  textStyle: const TextStyle(fontSize: 20, height: 1.6),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(30),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Set Up Your Password',
                      style: TextStyles.profileTitle,
                    ),
                    const Gap(36),
                    InputFrame(
                      hintText: 'Your Password',
                      textAlign: TextAlign.center,
                      isPassword: true,
                      obscureCharacter: 'X',
                      controller: _passwordController,
                    ),
                    const Gap(20),
                    InputFrame(
                      hintText: 'Confirm Your Password',
                      textAlign: TextAlign.center,
                      isPassword: true,
                      obscureCharacter: 'X',
                      controller: _confirmationCodeController,
                    ),
                    const Gap(36),
                    ElevatedButton(
                      onPressed: () async {
                        // Kiểm tra xem trường tuổi có được điền vào không
                        if (_passwordController.text.isEmpty ||
                            _confirmationCodeController.text.isEmpty) {
                          // Hiển thị một thông báo lỗi nếu trường tuổi trống
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thông báo'),
                                content: Text(
                                    'Vui lòng điền đầy đủ password và xác thực password của bạn.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              );
                            },
                          );
                          return; // Dừng hàm ở đây nếu trường tuổi trống
                        }
                        if (_passwordController.text !=
                            _confirmationCodeController.text) {
                          // Hiển thị một thông báo lỗi nếu mật khẩu và xác nhận mật khẩu không khớp
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Mật khẩu và xác nhận mật khẩu không khớp.'),
                            ),
                          );
                          return; // Dừng hàm ở đây nếu mật khẩu không khớp
                        }
                        // Hiển thị vòng quay
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: widget.email,
                            password: _passwordController.text,
                          );
                          // Save additional user information to Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .set({
                            'age': widget.age,
                            'email': widget.email,
                            'name': widget.name,
                            'avatar': "",
                            'phoneNumber': "",
                            "address": "",
                            "gender": ""
                          });
                          // Hiển thị vòng quay
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thông báo'),
                                content: Text('Đăng ký thành công.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              );
                            },
                          );
                          // Navigate to home screen or next step
                          // For example, you can navigate to a home screen here
                        } catch (e) {
                          print('Error: $e');
                          // Handle error, for example, display a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Đăng ký không thành công. Vui lòng thử lại sau.'),
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
                      child: Text('Start', style: TextStyles.loginButtonText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
