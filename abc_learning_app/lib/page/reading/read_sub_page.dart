import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/model/question.dart';
import 'package:abc_learning_app/model/reading_data_model.dart';
import 'package:abc_learning_app/model/reading_progress_model.dart';
import 'package:abc_learning_app/page/reading/read_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

enum QuestionState { wrong, correct, uncompleted }

class ReadSubPage extends StatefulWidget {
  final ReadingTopic readingTopic;
  final ReadingProgressCollection readingProgressCollection;
  const ReadSubPage(
      {super.key,
      required this.readingTopic,
      required this.readingProgressCollection});
  static const String routeName = 'read_sub';

  @override
  State<ReadSubPage> createState() => _ReadSubPageState();
}

class _ReadSubPageState extends State<ReadSubPage> {
  int cauHoi = 1;
  final PageController _pageController = PageController();
  TextEditingController textController = TextEditingController();
  final ReadingProgressRepo _readingProgressRepo = ReadingProgressRepo();

  bool finished = false;

  bool checkAnswer = false;
  String selectedAnswer = '';
  List<QuestionState> questionsAnswer = [];

  Future<DocumentSnapshot> _fetchUnitDocument(String unitsId) async {
    return FirebaseFirestore.instance.collection('units').doc(unitsId).get();
  }

  @override
  void initState() {
    for (int i = 0; i < widget.readingTopic.maxQuestions; i++) {
      questionsAnswer.add(QuestionState.uncompleted);
    }
    super.initState();
  }

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
                    int correctResults = 0;
                    for (var result in questionsAnswer) {
                      if (result == QuestionState.correct) {
                        correctResults++;
                      }
                    }
                    ReadingProgressCollection progress =
                        ReadingProgressCollection(
                            id: widget.readingProgressCollection.id,
                            currentProgress: correctResults,
                            unitId: widget.readingTopic.unitId);
                    _readingProgressRepo.uploadProgressCollection(progress);
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
                Container(
                  height: 8,
                  width: size.width * 0.6,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.readingTopic.maxQuestions,
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
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {},
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
            Expanded(
              child: FutureBuilder(
                  future: Future.wait(
                      [_fetchUnitDocument(widget.readingTopic.unitId)]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      ReadingParagraph rp = ReadingParagraph(
                          title: "title",
                          img_url: "img_url",
                          content: "content");
                      return PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: List.generate(
                            widget.readingTopic.maxQuestions + 1, (index) {
                          if (index == widget.readingTopic.maxQuestions) {
                            return buildReview();
                          } else if (snapshot.data[0]!
                                  .get('question_${index + 1}')['type'] ==
                              'paragraph') {
                            rp = ReadingParagraph.fromFirestore(
                                snapshot.data[0]!.get('question_${index + 1}'));
                            return buildStory(rp);
                          } else {
                            return buildQuestions(
                                rp,
                                ReadingQuestion.fromFirestore(snapshot.data[0]!
                                    .get('question_${index + 1}')));
                          }
                        }),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget buildStory(ReadingParagraph para) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Read this story',
          style: TextStyles.titlePage.copyWith(color: Colors.black),
        ),
        const Gap(5),
        Container(
          alignment: Alignment.center,
          child: Image.network(
            para.img_url,
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
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  para.title,
                  style: TextStyles.storyTitle,
                ),
                const Gap(15),
                Text(
                  para.content,
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              questionsAnswer[cauHoi - 1] = QuestionState.correct;
              cauHoi++;
            });
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(8)),
            fixedSize:
                MaterialStateProperty.all<Size>(Size(size.width * 0.75, 55)),
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
            side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: Colors.white, width: 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          child: const Text('Next', style: TextStyles.loginButtonText),
        ),
        const Gap(15),
      ],
    );
  }

  Widget buildQuestions(ReadingParagraph para, ReadingQuestion question) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height - 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Answer the question',
              style: TextStyles.titlePage.copyWith(color: Colors.black),
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
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      para.title,
                      style: TextStyles.storyTitle,
                    ),
                    const Gap(15),
                    Text(
                      para.content,
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
                question.question,
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
                            selectedAnswer = 'True';
                          });
                        },
                  child: Container(
                    height: 50,
                    width: size.width * 0.5 - 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: checkAnswer
                          ? (question.answer == 'True')
                              ? Colors.green
                              : selectedAnswer == 'True'
                                  ? Colors.red
                                  : ColorPalette.answerBackground
                          : selectedAnswer == 'True'
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
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
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
                            selectedAnswer = 'False';
                          });
                        },
                  child: Container(
                    height: 50,
                    width: size.width * 0.5 - 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: checkAnswer
                          ? (question.answer == 'False')
                              ? Colors.green
                              : selectedAnswer == 'False'
                                  ? Colors.red
                                  : ColorPalette.answerBackground
                          : selectedAnswer == 'False'
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
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      'False',
                      style: TextStyles.storyAnswer,
                    ),
                  ),
                ),
              ],
            ),
            if (!finished)
              if (checkAnswer)
                if (selectedAnswer == question.answer)
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
                        const Text(
                          'That\'s right',
                          style: TextStyles.questionResult,
                        ),
                        const Gap(5),
                        const Text(
                          'Answer:',
                          style: TextStyles.questionLabel,
                        ),
                        const Gap(10),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            question.answer,
                            style: TextStyles.trueAnswer,
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              questionsAnswer[cauHoi - 1] =
                                  QuestionState.correct;
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                cauHoi++;
                                checkAnswer = false;
                                selectedAnswer = '';
                              });
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(8)),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(size.width * 0.75, 55)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            child: const Text('Next Question',
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
                            question.answer,
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
                              questionsAnswer[cauHoi - 1] = QuestionState.wrong;
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                cauHoi++;
                                checkAnswer = false;
                                selectedAnswer = '';
                              });
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(8)),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(size.width * 0.75, 55)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            child: const Text('Next Question',
                                style: TextStyles.loginButtonText),
                          ),
                        ),
                      ],
                    ),
                  )
              else
                ElevatedButton(
                  onPressed: () {
                    if (selectedAnswer.isEmpty) {
                      return;
                    }
                    setState(() {
                      checkAnswer = true;
                    });
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(8)),
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(size.width * 0.75, 55)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.primaryColor),
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Colors.white, width: 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: const Text('Check Answer',
                      style: TextStyles.loginButtonText),
                )
            else
              ElevatedButton(
                onPressed: () {
                  _pageController.animateToPage(
                      widget.readingTopic.maxQuestions,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(8)),
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size(size.width * 0.75, 55)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      ColorPalette.primaryColor),
                  side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.white, width: 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                child: const Text('Finish', style: TextStyles.loginButtonText),
              )
          ],
        ),
      ),
    );
  }

  Widget buildReview() {
    Size size = MediaQuery.of(context).size;
    int correctResults = 0;
    for (var result in questionsAnswer) {
      if (result == QuestionState.correct) {
        correctResults++;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Reading',
          style: TextStyles.titlePage.copyWith(color: Colors.black),
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
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Image.network(
                widget.readingTopic.img_url,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.readingTopic.topic,
                    style: TextStyles.itemTitle,
                  ),
                  const Gap(12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: size.width - 185,
                        height: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: LinearProgressIndicator(
                            value: correctResults /
                                widget.readingTopic.maxQuestions,
                            backgroundColor: ColorPalette.progressbarbackground,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                ColorPalette.progressbarValue),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '$correctResults/${widget.readingTopic.maxQuestions}',
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
        SizedBox(
          height: size.height * 0.5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: widget.readingTopic
                .maxQuestions, // Thay đổi số lượng item tùy theo nhu cầu của bạn
            itemBuilder: (BuildContext context, int index) {
              Color getItemColor(int index) {
                if (questionsAnswer[index] == QuestionState.uncompleted) {
                  return Colors.grey;
                } else if (questionsAnswer[index] == QuestionState.correct) {
                  return Colors.green;
                } else if (questionsAnswer[index] == QuestionState.wrong) {
                  return Colors.red;
                }
                return Colors.grey;
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cauHoi = index + 1;
                    });
                    finished = true;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(8)),
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(size.width * 0.27, 36)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(getItemColor(index)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child:
                      Text('${index + 1}', style: TextStyles.loginButtonText),
                ),
              );
            },
          ),
        ),
        Expanded(child: Container()),
        ElevatedButton(
          onPressed: () {
            ReadingProgressCollection progress = ReadingProgressCollection(
                id: widget.readingProgressCollection.id,
                currentProgress: correctResults,
                unitId: widget.readingTopic.unitId);
            _readingProgressRepo.uploadProgressCollection(progress);
            Navigator.pop(context);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(8)),
            fixedSize:
                MaterialStateProperty.all<Size>(Size(size.width * 0.75, 55)),
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorPalette.primaryColor),
            side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: Colors.white, width: 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          child: const Text('Finish', style: TextStyles.loginButtonText),
        ),
        const Gap(15),
      ],
    );
  }
}
