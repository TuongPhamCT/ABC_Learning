import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});
  static const String routeName = 'achievement';

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  int _selectedIndex = 1;
  double rating = 3;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: size.height * 0.1,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: size.width,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        'Achievement',
                        style: TextStyles.pageTitle,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: List<BoxShadow>.generate(
                        1,
                        (index) => BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.menu,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(40),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: ColorPalette.achievementBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        child: CircularProgressIndicator(
                          strokeWidth: 7,
                          backgroundColor: Colors.grey,
                          value: 0.8,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      Text(
                        '80 %',
                        style: TextStyles.heading,
                      ),
                    ],
                  ),
                  Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Achievement: 20',
                        style: TextStyles.heading,
                      ),
                      Text(
                        'Great job, John! Complete your\nachievements now',
                        style: TextStyles.content,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(20),
            Container(
              decoration: BoxDecoration(
                color: ColorPalette.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Image.asset(
                    AssetHelper.trophyAchievement,
                    width: 72,
                  ),
                  Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.62,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Studious',
                              style: TextStyles.heading.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            RatingBar.builder(
                              ignoreGestures: true,
                              itemSize: 24,
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              unratedColor: Colors.white,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, index) {
                                if (index < rating) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.star_border_outlined,
                                  );
                                }
                              },
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'You have completed this lesson\n10 times.',
                        style: TextStyles.content.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
          )),
    );
  }
}
