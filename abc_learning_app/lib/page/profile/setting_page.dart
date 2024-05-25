import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:abc_learning_app/page/reading/read_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  static const String routeName = 'setting';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;

  bool isNotification = false;
  bool isTurnOnNotification = false;

  bool isTextSize = false;
  String textSize = 'Medium';

  bool isSound = false;
  double _currentVolume = 0.5;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
                Text('Settings',
                    style: TextStyles.loginButtonText.copyWith(
                      color: Colors.black,
                    )),
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
            Expanded(child: Container()),
            Container(
              padding: const EdgeInsets.all(10),
              child: Container(
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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Dark Mode',
                              style: TextStyles.nameFunction),
                          CupertinoSwitch(
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                            activeColor: ColorPalette.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: isNotification
                            ? ColorPalette.itemBackground.withOpacity(0.5)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Notification',
                                  style: TextStyles.nameFunction),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNotification = !isNotification;
                                  });
                                },
                                child: Icon(
                                  isNotification
                                      ? FontAwesomeIcons.caretDown
                                      : FontAwesomeIcons.caretRight,
                                  color: ColorPalette.kindUser,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: isNotification,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Turn on notification',
                                      style: TextStyles.nameFunction),
                                  CupertinoSwitch(
                                    value: isTurnOnNotification,
                                    onChanged: (value) {
                                      setState(() {
                                        isTurnOnNotification = value;
                                      });
                                    },
                                    activeColor: ColorPalette.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: isTextSize
                            ? ColorPalette.itemBackground.withOpacity(0.5)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Text Size',
                                  style: TextStyles.nameFunction),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTextSize = !isTextSize;
                                  });
                                },
                                child: Icon(
                                  isTextSize
                                      ? FontAwesomeIcons.caretDown
                                      : FontAwesomeIcons.caretRight,
                                  color: ColorPalette.kindUser,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: isTextSize,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        textSize = 'Small';
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        textSize == 'Small'
                                            ? ColorPalette.primaryColor
                                            : Colors.white,
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(size.width * 0.18, 35),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(0),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Small',
                                      style: TextStyles.nameFunction.copyWith(
                                        color: textSize == 'Small'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        textSize = 'Medium';
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        textSize == 'Medium'
                                            ? ColorPalette.primaryColor
                                            : Colors.white,
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(size.width * 0.18, 35),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(0),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Medium',
                                      style: TextStyles.nameFunction.copyWith(
                                        color: textSize == 'Medium'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        textSize = 'Large';
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        textSize == 'Large'
                                            ? ColorPalette.primaryColor
                                            : Colors.white,
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(size.width * 0.18, 35),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(0),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Large',
                                      style: TextStyles.nameFunction.copyWith(
                                        color: textSize == 'Large'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: isSound
                            ? ColorPalette.itemBackground.withOpacity(0.5)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sound And Volume',
                                  style: TextStyles.nameFunction),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSound = !isSound;
                                  });
                                },
                                child: Icon(
                                  isSound
                                      ? FontAwesomeIcons.caretDown
                                      : FontAwesomeIcons.caretRight,
                                  color: ColorPalette.kindUser,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: isSound,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorPalette.primaryColor,
                                    ),
                                    child: Icon(
                                      _currentVolume == 0
                                          ? FontAwesomeIcons.volumeMute
                                          : _currentVolume < 0.5
                                              ? FontAwesomeIcons.volumeDown
                                              : FontAwesomeIcons.volumeUp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(5),
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        width: size.width - 200,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            (size.width - 200) * _currentVolume,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                      GestureDetector(
                                        onHorizontalDragUpdate: (details) {
                                          setState(() {
                                            double newVolume = _currentVolume +
                                                (details.primaryDelta! /
                                                    (size.width - 200));
                                            _currentVolume =
                                                newVolume.clamp(0.0, 1.0);
                                          });
                                        },
                                        child: Container(
                                          width: size.width - 200,
                                          height: 20,
                                          color: Colors.transparent,
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
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Privacy Policy',
                                style: TextStyles.nameFunction),
                            Icon(
                              FontAwesomeIcons.caretRight,
                              color: ColorPalette.kindUser,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Terms and Condition',
                                style: TextStyles.nameFunction),
                            Icon(
                              FontAwesomeIcons.caretRight,
                              color: ColorPalette.kindUser,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
