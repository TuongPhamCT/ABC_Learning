import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/model/reading_data_model.dart';
import 'package:abc_learning_app/model/reading_progress_model.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:abc_learning_app/page/reading/read_sub_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ReadMainPage extends StatefulWidget {
  const ReadMainPage({super.key});
  static const String routeName = 'read_main';

  @override
  State<ReadMainPage> createState() => _ReadMainPageState();
}

class _ReadMainPageState extends State<ReadMainPage> {
  final ReadingTopicRepo _readingTopicRepo = ReadingTopicRepo();
  final ReadingProgressRepo _readingProgressRepo = ReadingProgressRepo();
  ReadingProgress? _readingProgress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder(
            future: Future.wait([_readingTopicRepo.getAllTopic()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<ReadingTopic> readingTopic = snapshot.data[0];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        AssetHelper.readingMain,
                        width: 260,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Reading',
                        style: TextStyles.titlePage,
                      ),
                    ),
                    const Gap(20),
                    FutureBuilder(
                        future: Future.wait([
                          _readingProgressRepo.getReadingProgressById(
                              FirebaseAuth.instance.currentUser!.uid)
                        ]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            _readingProgress = snapshot.data[0];
                            return Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: readingTopic.length,
                                itemBuilder: (context, index) {
                                  String currentUnit =
                                      readingTopic[index].unitId;
                                  int currentProgress = _readingProgress!
                                      .progresses
                                      .singleWhere(
                                          (progress) =>
                                              progress.unitId == currentUnit,
                                          orElse: () =>
                                              ReadingProgressCollection(
                                                  unitId: '0',
                                                  currentProgress: 0))
                                      .currentProgress;
                                  return buildListenItem(
                                      readingTopic[index], currentProgress);
                                },
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                    const Gap(15),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget buildListenItem(ReadingTopic topic, int correctTasks) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        String currentUnit = topic.unitId;
        ReadingProgressCollection progress = _readingProgress!.progresses
            .singleWhere((progress) => progress.unitId == currentUnit,
                orElse: () =>
                    ReadingProgressCollection(unitId: '0', currentProgress: 0));
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ReadSubPage(
                  readingTopic: topic,
                  readingProgressCollection: progress,
                ),
              ),
            )
            .then((res) => setState(() {}));
      },
      child: Container(
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
              topic.img_url,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.topic,
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
                          value: correctTasks / topic.maxQuestions,
                          backgroundColor: ColorPalette.progressbarbackground,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              ColorPalette.progressbarValue),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      "$correctTasks / ${topic.maxQuestions}",
                      style: TextStyles.itemprogress,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
