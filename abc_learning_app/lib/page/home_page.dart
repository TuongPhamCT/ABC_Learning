import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/achievement_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: ColorPalette.primaryColor,
          ),
          Column(
            children: [
              Container(
                height: size.height * 0.3,
                color: Colors.transparent,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: size.height * 0.3,
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(size.height * 0.12),
                        Text(
                          'Hi, User!',
                          style: TextStyles.profileTitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Gap(5),
                        Text(
                          'What do you want to\nlearn now?',
                          style: TextStyles.MediumTextRegular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      AssetHelper.home,
                      width: size.width * 0.5,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ListenMainPage.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorPalette.componentBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                AssetHelper.iconlisten,
                                width: 60,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Listening',
                                    style: TextStyles.titleComponent,
                                  ),
                                  Gap(5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: size.width - 150,
                                        height: 12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: LinearProgressIndicator(
                                            value: 0.8,
                                            backgroundColor: ColorPalette
                                                .progressbarbackground,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                ColorPalette.progressbarValue),
                                          ),
                                        ),
                                      ),
                                      Gap(8),
                                      Text(
                                        '80%',
                                        style: TextStyles.progress,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorPalette.componentBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                AssetHelper.iconread,
                                width: 60,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reading',
                                    style: TextStyles.titleComponent,
                                  ),
                                  Gap(5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: size.width - 150,
                                        height: 12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: LinearProgressIndicator(
                                            value: 0.5,
                                            backgroundColor: ColorPalette
                                                .progressbarbackground,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                ColorPalette.progressbarValue),
                                          ),
                                        ),
                                      ),
                                      Gap(8),
                                      Text(
                                        '50%',
                                        style: TextStyles.progress,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorPalette.componentBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                AssetHelper.iconexecise,
                                width: 60,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exercise',
                                    style: TextStyles.titleComponent,
                                  ),
                                  Gap(5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: size.width - 150,
                                        height: 12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: LinearProgressIndicator(
                                            value: 0.3,
                                            backgroundColor: ColorPalette
                                                .progressbarbackground,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                ColorPalette.progressbarValue),
                                          ),
                                        ),
                                      ),
                                      Gap(8),
                                      Text(
                                        '30%',
                                        style: TextStyles.progress,
                                      ),
                                    ],
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
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorPalette.primaryColor.withOpacity(0.7),
          iconSize: 33,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.of(context).pushNamed(HomePage.routeName);
                break;
              case 1:
                Navigator.of(context).pushNamed(AchievementPage.routeName);
                break;
              // case 2:
              //   Navigator.pushReplacementNamed(context, '/profile');
              //   break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.menu_book_sharp,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.trophy,
              ),
              label: 'Achievement',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.circleUser,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
