import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReadSubPage extends StatefulWidget {
  const ReadSubPage({super.key});
  static const String routeName = 'read_sub';

  @override
  State<ReadSubPage> createState() => _ReadSubPageState();
}

class _ReadSubPageState extends State<ReadSubPage> {
  int cauHoi = 1;
  PageController _pageController = PageController();
  AudioPlayer player = AudioPlayer();
  TextEditingController textController = TextEditingController();

  bool checkAnswer = false;
  String answer = 'A';
  String selectedAnswer = '';
  String trueAnswer = 'Elephant';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(30),
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
                Container(
                  height: 8,
                  width: size.width * 0.6,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 8,
                        width: size.width * 0.1 - 5,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: index < cauHoi
                              ? ColorPalette.primaryColor
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  ),
                ),
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
                        onTap: () {},
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
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  //Trang dau tien, Trang de doc truyen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Read this story',
                        style:
                            TextStyles.titlePage.copyWith(color: Colors.black),
                      ),
                      const Gap(5),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AssetHelper.storyilu,
                          width: 150,
                          height: 145,
                        ),
                      ),
                      const Gap(5),
                      Container(
                        alignment: Alignment.center,
                        height: size.height * 0.42,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ColorPalette.primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Jokes in the news',
                                style: TextStyles.storyTitle,
                              ),
                              const Gap(15),
                              Text(
                                'On April Fool\'s Day, there are often jokes in the news, on TV or on websites. In 2008 the BBC made a short video which showed the \'news\' that some penguins had learned to fly! Two big UK newspapers wrote about the \'important story\' on their front pages. One year in the UK, a children\'s news programme said that scientists had invented a \'Brain Band\'. It was a coloured headband that you put on your head and it helped to make you more intelligent!',
                                style: TextStyles.storyContent,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            cauHoi++;
                          });
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(8)),
                          fixedSize: MaterialStateProperty.all<Size>(
                              Size(size.width * 0.75, 55)),
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
                      const Gap(15),
                    ],
                  ),
                  //Trang thu 2, Trang de tra loi cau hoi
                  SingleChildScrollView(
                    child: Container(
                      height: size.height - 145,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Answer the question',
                            style: TextStyles.titlePage
                                .copyWith(color: Colors.black),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: size.height * 0.4,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: ColorPalette.primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Jokes in the news',
                                    style: TextStyles.storyTitle,
                                  ),
                                  const Gap(15),
                                  Text(
                                    'On April Fool\'s Day, there are often jokes in the news, on TV or on websites. In 2008 the BBC made a short video which showed the \'news\' that some penguins had learned to fly! Two big UK newspapers wrote about the \'important story\' on their front pages. One year in the UK, a children\'s news programme said that scientists had invented a \'Brain Band\'. It was a coloured headband that you put on your head and it helped to make you more intelligent!',
                                    style: TextStyles.storyContent,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'April Fool\'s Day is on 1 April\nevery year?',
                              style: TextStyles.storyQuestion,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: checkAnswer
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedAnswer = 'A';
                                        });
                                      },
                                child: Container(
                                  height: 50,
                                  width: size.width * 0.5 - 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: checkAnswer
                                        ? (answer == 'A')
                                            ? Colors.green
                                            : selectedAnswer == 'A'
                                                ? Colors.red
                                                : ColorPalette.answerBackground
                                        : selectedAnswer == 'A'
                                            ? ColorPalette.primaryColor
                                            : ColorPalette.answerBackground,
                                    border: Border.all(
                                      color: ColorPalette.answerBorder,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 20,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'True',
                                    style: TextStyles.storyAnswer,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: checkAnswer
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedAnswer = 'B';
                                        });
                                      },
                                child: Container(
                                  height: 50,
                                  width: size.width * 0.5 - 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: checkAnswer
                                        ? (answer == 'B')
                                            ? Colors.green
                                            : selectedAnswer == 'B'
                                                ? Colors.red
                                                : ColorPalette.answerBackground
                                        : selectedAnswer == 'B'
                                            ? ColorPalette.primaryColor
                                            : ColorPalette.answerBackground,
                                    border: Border.all(
                                      color: ColorPalette.answerBorder,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 20,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'False',
                                    style: TextStyles.storyAnswer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (checkAnswer)
                            if (selectedAnswer == answer)
                              Container(
                                height: size.height * 0.23,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'That\'s right',
                                      style: TextStyles.questionResult,
                                    ),
                                    const Gap(5),
                                    Text(
                                      'Answer:',
                                      style: TextStyles.questionLabel,
                                    ),
                                    const Gap(10),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'True',
                                        style: TextStyles.trueAnswer,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                          setState(() {
                                            cauHoi++;
                                            checkAnswer = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.all(8)),
                                          fixedSize:
                                              MaterialStateProperty.all<Size>(
                                                  Size(size.width * 0.75, 55)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                          ),
                                        ),
                                        child: Text('Next Question',
                                            style: TextStyles.loginButtonText),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                height: size.height * 0.23,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Oops.. That\'s not quite right',
                                      style: TextStyles.questionResult.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Gap(5),
                                    Text(
                                      'Answer:',
                                      style: TextStyles.questionLabel.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Gap(10),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'True',
                                        style: TextStyles.trueAnswer.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                          setState(() {
                                            cauHoi++;
                                            checkAnswer = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.all(8)),
                                          fixedSize:
                                              MaterialStateProperty.all<Size>(
                                                  Size(size.width * 0.75, 55)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                          ),
                                        ),
                                        child: Text('Next Question',
                                            style: TextStyles.loginButtonText),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          else
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  checkAnswer = true;
                                });
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(8)),
                                fixedSize: MaterialStateProperty.all<Size>(
                                    Size(size.width * 0.75, 55)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                              child: Text('Check Answer',
                                  style: TextStyles.loginButtonText),
                            ),
                        ],
                      ),
                    ),
                  ),

                  //Trang thu 3, review
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Reading',
                        style:
                            TextStyles.titlePage.copyWith(color: Colors.black),
                      ),
                      const Gap(15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: ColorPalette.itemBorder,
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Image.asset(
                              AssetHelper.itemListen,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alphabet',
                                  style: TextStyles.itemTitle,
                                ),
                                const Gap(12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: size.width - 185,
                                      height: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: LinearProgressIndicator(
                                          value: 9 / 50,
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
                                      '9/50',
                                      style: TextStyles.itemprogress,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: size.height * 0.5,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount:
                              50, // Thay đổi số lượng item tùy theo nhu cầu của bạn
                          itemBuilder: (BuildContext context, int index) {
                            Color getItemColor(int index) {
                              if (index % 3 == 0) {
                                return Colors.green;
                              } else if (index % 3 == 1) {
                                return Colors.red;
                              } else {
                                return Colors.grey;
                              }
                            }

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.all(8)),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      Size(size.width * 0.27, 36)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          getItemColor(index)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Text('${index + 1}',
                                    style: TextStyles.loginButtonText),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(8)),
                          fixedSize: MaterialStateProperty.all<Size>(
                              Size(size.width * 0.75, 55)),
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
                        child:
                            Text('Finish', style: TextStyles.loginButtonText),
                      ),
                      const Gap(15),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
