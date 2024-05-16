import 'package:abc_learning_app/component/log_out_dialog.dart';
import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/model/achievement_model.dart';
import 'package:abc_learning_app/model/reading_data_model.dart';
import 'package:abc_learning_app/model/reading_progress_model.dart';
import 'package:abc_learning_app/model/user_model.dart';
import 'package:abc_learning_app/page/achievement_page.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/home_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:abc_learning_app/page/profile/privacy_page.dart';
import 'package:abc_learning_app/page/profile/setting_page.dart';
import 'package:abc_learning_app/page/reading/read_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage({super.key});
  static const String routeName = 'profile_main_page';

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  final UserRepo _userRepo = UserRepo();
  final ReadingTopicRepo _readingTopicRepo = ReadingTopicRepo();
  final ReadingProgressRepo _readingProgressRepo = ReadingProgressRepo();
  final AchievementRepo _achievementRepo = AchievementRepo();
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: CustomPaint(
              painter: Split(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(25),
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
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.angleLeft,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Text('My Profile', style: TextStyles.loginButtonText),
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
                            offset: const Offset(0, 8),
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
                            padding: const EdgeInsets.all(5),
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
                                    offset: const Offset(0, 8),
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
                            padding: const EdgeInsets.all(5),
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
                                    offset: const Offset(0, 8),
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
                            padding: const EdgeInsets.all(5),
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
                                    offset: const Offset(0, 8),
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
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                FutureBuilder(
                    future: Future.wait([
                      _achievementRepo.getAllAchievements(),
                      _readingTopicRepo.getAllTopic(),
                      _readingProgressRepo.getReadingProgressById(
                          FirebaseAuth.instance.currentUser!.uid),
                      _userRepo
                          .getUserById(FirebaseAuth.instance.currentUser!.uid)
                    ]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        int completedAchievements = 0;
                        List<Achievement> achievements = snapshot.data[0];
                        List<ReadingTopic> readingTopics = snapshot.data[1];
                        ReadingProgress readingProgress = snapshot.data[2];
                        MyUser user = snapshot.data[3];
                        for (int i = 0; i < achievements.length; i++) {
                          Achievement currentAchievement = achievements[i];
                          int currentProgress = 0;
                          if (currentAchievement.type == 'reading') {
                            for (ReadingTopic readingTopic in readingTopics) {
                              ReadingProgressCollection progress =
                                  readingProgress.progresses.singleWhere(
                                      (progress) =>
                                          progress.unitId ==
                                          readingTopic.unitId,
                                      orElse: () => ReadingProgressCollection(
                                          unitId: '0', currentProgress: 0));
                              if (progress.currentProgress >=
                                  readingTopic.maxQuestions) {
                                currentProgress++;
                              }
                            }
                            if (currentProgress >=
                                currentAchievement.maxIndex) {
                              completedAchievements++;
                            }
                          }
                        }
                        return Container(
                          padding: const EdgeInsets.all(10),
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
                                          offset: const Offset(0, 8),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(user.name,
                                          style: TextStyles.titleComponent),
                                      const Gap(10),
                                      Text(
                                          completedAchievements < 5
                                              ? 'Foundation'
                                              : completedAchievements < 10
                                                  ? 'Beginner'
                                                  : 'Intermediate',
                                          style: TextStyles.kindUser),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PrivacyPage(
                                                user: user,
                                                completedAchievements:
                                                    completedAchievements,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.penToSquare,
                                          color: Colors.black.withOpacity(0.8),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(30),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 5),
                                decoration: const BoxDecoration(
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
                                        child: const Column(
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
                                          Text(completedAchievements.toString(),
                                              style: TextStyles.titleComponent),
                                          const Text('Achievement',
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
                                        child: const Column(
                                          children: [
                                            Text('2',
                                                style:
                                                    TextStyles.titleComponent),
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
                                padding: const EdgeInsets.all(15),
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
                                    const Text('Dashboard',
                                        style: TextStyles.labelField),
                                    const Gap(20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(SettingPage.routeName);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ColorPalette.primaryColor,
                                            ),
                                            child: const Icon(
                                              Icons.settings_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Gap(10),
                                          const Text('Settings',
                                              style: TextStyles.nameFunction),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: const Icon(
                                                FontAwesomeIcons.caretRight,
                                                color: ColorPalette.kindUser,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Gap(20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            AchievementPage.routeName);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.yellow,
                                            ),
                                            child: const Icon(
                                              FontAwesomeIcons.trophy,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Gap(10),
                                          const Text('Achievements',
                                              style: TextStyles.nameFunction),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: const Icon(
                                                FontAwesomeIcons.caretRight,
                                                color: ColorPalette.kindUser,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Gap(20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PrivacyPage(
                                              user: user,
                                              completedAchievements:
                                                  completedAchievements,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                            ),
                                            child: const Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Gap(10),
                                          const Text('Privacy',
                                              style: TextStyles.nameFunction),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: const Icon(
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
                              const Gap(25),
                              Container(
                                width: size.width,
                                padding: const EdgeInsets.all(15),
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
                                    const Text('My Account',
                                        style: TextStyles.labelField),
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
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
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
