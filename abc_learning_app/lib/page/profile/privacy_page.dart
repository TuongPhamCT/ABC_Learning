import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});
  static const routeName = 'privacy_page';

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
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
              painter: SplitPrivacy(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(35),
                Stack(
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: 42,
                          child: Text('Privacy',
                              style: TextStyles.loginButtonText)),
                    ),
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
                  ],
                ),
                const Gap(40),
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    image: DecorationImage(
                      image: AssetImage(AssetHelper.storyilu),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(10),
                Text('John Doe', style: TextStyles.titleComponent),
                const Gap(5),
                Text('Newbie', style: TextStyles.kindUser),
                const Gap(20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name',
                    style: TextStyles.nameFunction,
                  ),
                ),
                const Gap(5),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: ColorPalette.itemBackground),
                  ),
                  child: Text(
                    'John Doe',
                    style: TextStyles.privacyContent,
                  ),
                ),
                const Gap(10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'User Name',
                    style: TextStyles.nameFunction,
                  ),
                ),
                const Gap(5),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: ColorPalette.itemBackground),
                  ),
                  child: Text(
                    'JohnDOE',
                    style: TextStyles.privacyContent,
                  ),
                ),
                const Gap(10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyles.nameFunction,
                  ),
                ),
                const Gap(5),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: ColorPalette.itemBackground),
                  ),
                  child: Text(
                    'John.doe@gmail.com',
                    style: TextStyles.privacyContent,
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Age', style: TextStyles.nameFunction),
                        const Gap(5),
                        Text('21', style: TextStyles.privacyContent),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Joined From', style: TextStyles.nameFunction),
                        const Gap(5),
                        Text('5, Jan 2024', style: TextStyles.privacyContent),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SplitPrivacy extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorPalette.primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.11);
    path.quadraticBezierTo(size.width * 0.13, size.height * 0.19,
        size.width * 0.35, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.2,
        size.width * 0.8, size.height * 0.32);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.4, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);

    // paint.color = ColorPalette.primaryColor;

    // path = Path();
    // path.moveTo(size.width * 0.5, size.height * 0.168);
    // path.quadraticBezierTo(
    //     size.width * 0.82, size.height * 0.25, size.width, size.height * 0.4);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);

    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
