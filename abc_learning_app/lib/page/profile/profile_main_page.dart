import 'package:abc_learning_app/component/google_login_dialog.dart';
import 'package:abc_learning_app/component/log_out_dialog.dart';
import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/achievement_page.dart';
import 'package:abc_learning_app/page/age_profile_page.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:abc_learning_app/page/reading/read_main_page.dart';
import 'package:abc_learning_app/page/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage({super.key});
  static const String routeName = 'profile_main_page';

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  int _selectedIndex = 2;
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
              painter: Split(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Text('My Profile', style: TextStyles.loginButtonText),
                    Container(
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
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ListenMainPage.routeName);
                            },
                            padding: EdgeInsets.all(5),
                            height: 42,
                            value: 'item1',
                            child: Container(
                              alignment: Alignment.center,
                              height: 42,
                              width: 100,
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  AssetHelper.iconlisten,
                                ),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ReadMainPage.routeName);
                            },
                            padding: EdgeInsets.all(5),
                            height: 42,
                            value: 'item2',
                            child: Container(
                              height: 42,
                              width: 100,
                              alignment: Alignment.center,
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  AssetHelper.iconread,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ExerciseMainPage.routeName);
                            },
                            padding: EdgeInsets.all(5),
                            height: 42,
                            value: 'item3',
                            child: Container(
                              height: 42,
                              width: 100,
                              alignment: Alignment.center,
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  AssetHelper.iconexecise,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                AssetHelper.storyilu,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const Gap(25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('John Doe',
                                  style: TextStyles.titleComponent),
                              const Gap(10),
                              Text('Newbie', style: TextStyles.kindUser),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                FontAwesomeIcons.edit,
                                color: Colors.black.withOpacity(0.8),
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(30),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: ColorPalette.kindUser,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text('2+ hours',
                                        style: TextStyles.pageTitle),
                                    Text('Total Learn',
                                        style: TextStyles.kindUser),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                              height: 30,
                              child: Container(
                                color: ColorPalette.kindUser,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Text('20', style: TextStyles.titleComponent),
                                  Text('Achievement',
                                      style: TextStyles.kindUser),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 1,
                              height: 30,
                              child: Container(
                                color: ColorPalette.kindUser,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Text('2', style: TextStyles.titleComponent),
                                    Text('Language',
                                        style: TextStyles.kindUser),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(15),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorPalette.kindUser,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dashboard', style: TextStyles.labelField),
                            const Gap(15),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorPalette.primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.settings_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text('Settings',
                                      style: TextStyles.nameFunction),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        FontAwesomeIcons.caretRight,
                                        color: ColorPalette.kindUser,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Gap(15),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.yellow,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.trophy,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text('Achievements',
                                      style: TextStyles.nameFunction),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        FontAwesomeIcons.caretRight,
                                        color: ColorPalette.kindUser,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Gap(15),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text('Privacy',
                                      style: TextStyles.nameFunction),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        FontAwesomeIcons.caretRight,
                                        color: ColorPalette.kindUser,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(15),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorPalette.kindUser,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('My Account', style: TextStyles.labelField),
                            const Gap(15),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const LogOutDialog(); // Hiển thị bottom sheet đăng xuất
                                  },
                                  isScrollControlled: true,
                                );
                              },
                              child: Text(
                                'Log Out Account',
                                style: TextStyles.nameFunction.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              case 2:
                Navigator.of(context).pushNamed(ProfileMainPage.routeName);
                break;
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

class Split extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorPalette.primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.33);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.17,
        size.width * 0.5, size.height * 0.168);
    path.lineTo(size.width * 0.5, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);

    paint.color = ColorPalette.primaryColor;

    path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.168);
    path.quadraticBezierTo(
        size.width * 0.82, size.height * 0.169, size.width, size.height * 0.11);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
