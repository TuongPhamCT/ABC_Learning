import 'package:abc_learning_app/component/input_frame.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/email_profile_page.dart';
import 'package:abc_learning_app/page/name_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class AgeProfile extends StatefulWidget {
  const AgeProfile({Key? key}) : super(key: key);
  static const String routeName = 'age_profile_page';

  @override
  State<AgeProfile> createState() => _AgeProfileState();
}

class _AgeProfileState extends State<AgeProfile> {
  final TextEditingController _ageController = TextEditingController();
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
                      'How old are you?',
                      style: TextStyles.profileTitle,
                    ),
                    const Gap(36),
                    InputFrame(
                      hintText: 'Your Age',
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                    ),
                    const Gap(36),
                    ElevatedButton(
                      onPressed: () {
                        // Kiểm tra xem trường tuổi có được điền vào không
                        if (_ageController.text.isEmpty) {
                          // Hiển thị một thông báo lỗi nếu trường tuổi trống
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thông báo'),
                                content: Text('Vui lòng nhập tuổi của bạn.'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NameProfilePage(
                              age: _ageController.text,
                            ),
                          ),
                        );
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
                      child: Text('Next', style: TextStyles.loginButtonText),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
