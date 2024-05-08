import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/model/achievement_model.dart';
import 'package:abc_learning_app/model/progress_model.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  static final AchievementRepo _achievementRepo = AchievementRepo();
  static final AchievementProgressRepo _achievementProgressRepo =
      AchievementProgressRepo();

  int _totalAchievement = 0;
  int _completePercent = 0;

  int _selectedIndex = 1;
  double rating = 3;
  List<Color> colors = [
    ColorPalette.itemBackgroundOne,
    ColorPalette.itemBackgroundTwo,
    ColorPalette.itemBackgroundThree,
    ColorPalette.itemBackgroundFour,
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: Future.wait([
              _achievementRepo.getAllAchievements(),
              _achievementProgressRepo.getAchievementProgressById(
                  FirebaseAuth.instance.currentUser!.uid)
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Achievement> achievements = snapshot.data[0];
                AchievementProgress achievementProgress = snapshot.data[1];
                _totalAchievement = achievements.length;
                int completedAchievements = 0;
                for (Achievement achievement in achievements) {
                  Progress currentProgress = achievementProgress.progresses
                      .singleWhere(
                          (progress) =>
                              progress.achievementId == achievement.id,
                          orElse: () =>
                              Progress(achievementId: '0', currentProgress: 0));
                  if (currentProgress.currentProgress >= achievement.maxIndex) {
                    completedAchievements++;
                  }
                }
                _completePercent =
                    (completedAchievements / _totalAchievement * 100).round();
                return Column(
                  children: [
                    SizedBox(
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
                              child: const Text(
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
                                  offset: const Offset(0, 0),
                                ),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.menu,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(40),
                    Container(
                      padding: const EdgeInsets.all(15),
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
                              SizedBox(
                                width: 72,
                                height: 72,
                                child: CircularProgressIndicator(
                                  strokeWidth: 7,
                                  backgroundColor: Colors.grey,
                                  value: _completePercent / 100,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                              ),
                              Text(
                                '$_completePercent %',
                                style: TextStyles.heading,
                              ),
                            ],
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Achievements: $_totalAchievement',
                                style: TextStyles.heading,
                              ),
                              const Text(
                                'Great job, John! Complete your\nachievements now',
                                style: TextStyles.content,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: achievements.length,
                        itemBuilder: (context, index) {
                          Color color = colors[index % 4];
                          String currentAchievement = achievements[index].id;
                          int currentProgress = achievementProgress.progresses
                              .singleWhere(
                                  (progress) =>
                                      progress.achievementId ==
                                      currentAchievement,
                                  orElse: () => Progress(
                                      achievementId: '0', currentProgress: 0))
                              .currentProgress;
                          return buildAchievementItem(index, color,
                              achievements[index], currentProgress);
                        },
                      ),
                    )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
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
            items: const [
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

  Widget buildAchievementItem(
      int index, Color color, Achievement achievement, int currentProgress) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Image.network(
            achievement.icon,
            width: 72,
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // width: size.width * 0.62,

              Text(
                achievement.name,
                style: TextStyles.heading.copyWith(
                  color: Colors.white,
                ),
              ),
              RatingBar.builder(
                ignoreGestures: true,
                itemSize: 24,
                initialRating: (currentProgress / achievement.maxIndex) * 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                unratedColor: Colors.white,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, index) {
                  if (index < (currentProgress / achievement.maxIndex) * 5) {
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
                onRatingUpdate: (rating) {},
              ),
              Text(
                'Completed: ${currentProgress >= achievement.maxIndex ? achievement.maxIndex : currentProgress}/${achievement.maxIndex}',
                style: TextStyles.content.copyWith(
                  color: Colors.white,
                ),
              ),
              const Gap(5),
              SizedBox(
                width: size.width - 200,
                child: Text(
                  achievement.description,
                  style: TextStyles.content.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
