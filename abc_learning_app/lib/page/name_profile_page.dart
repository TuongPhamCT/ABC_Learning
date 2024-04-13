import 'package:abc_learning_app/component/input_frame.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class NameProfilePage extends StatefulWidget {
  const NameProfilePage({super.key});

  @override
  State<NameProfilePage> createState() => _NameProfilePageState();
}

class _NameProfilePageState extends State<NameProfilePage> {
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
                    ),
                    const Gap(36),
                    ElevatedButton(
                      onPressed: () {},
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
