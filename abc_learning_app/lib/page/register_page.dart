import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/age_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String routeName = 'register_page';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Column(
            children: [
              SizedBox(height: size.height * 0.13),
              Container(
                child: Image.asset(AssetHelper.illustraionRegis),
              ),
              SizedBox(height: size.height * 0.12),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Profile',
                      style: TextStyles.Typrography,
                    ),
                    Text(
                      'Now!',
                      style: TextStyles.Typrography.copyWith(
                          fontWeight: FontWeight.w600),
                    ),
                    const Gap(20),
                    Text(
                      'Create a profile to save your learning \nprogress and keep learning for free!',
                      style: TextStyles.MediumTextRegular.copyWith(
                        color: Color(0xff989EA7),
                      ),
                    ),
                    const Gap(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(8)),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(130, 50)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.white, width: 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          child: Text('Back',
                              style: TextStyles.loginButtonText.copyWith(
                                color: ColorPalette.loginbutton,
                              )),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AgeProfile.routeName);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(8)),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(130, 50)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorPalette.primaryColor),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.white, width: 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          child:
                              Text('Next', style: TextStyles.loginButtonText),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorPalette.primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.5 - 30);
    path.quadraticBezierTo(size.width * 0.5 + 10, size.height * 0.5 + 130,
        size.width, size.height * 0.5 + 50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);

    paint.color = Colors.white;

    path = Path();
    path.moveTo(0, size.height * 0.5 - 30);
    path.quadraticBezierTo(size.width * 0.5 + 10, size.height * 0.5 + 130,
        size.width, size.height * 0.5 + 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
