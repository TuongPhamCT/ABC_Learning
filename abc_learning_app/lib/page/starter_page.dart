import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});
  static const String routeName = 'starter_page';

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  final List<String> slogans = [
    "Learn all English languages interactively at your fingertips!",
    "Unlock the world of English with interactive learning!",
    "Master English effortlessly with interactive lessons!"
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  AssetHelper.logo,
                  width: size.width * 0.75,
                  height: size.width * 0.75,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                width: size.width,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'Learn the English language \nfor free!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 60,
                      width: size.width * 0.8,
                      child: PageView.builder(
                        itemCount: slogans.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            width: size.width * 0.8,
                            height: 60,
                            child: Text(
                              softWrap: true,
                              slogans[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1.02,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Lexend',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 10,
                      width: 75,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: (slogans.length),
                        itemBuilder: (context, index) {
                          return imageIndicator(index == currentIndex);
                        },
                      ),
                    ),
                    SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(8)),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(135, 55)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Lexend',
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                FontAwesomeIcons.caretRight,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginPage.routeName);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(8)),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(135, 55)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: ColorPalette.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Lexend',
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                FontAwesomeIcons.caretRight,
                                color: ColorPalette.primaryColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget imageIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: isActive ? 30 : 10,
      decoration: BoxDecoration(
        color:
            isActive ? Color(0xffFFEDDA) : Color(0xffFFEDDA).withOpacity(0.7),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
