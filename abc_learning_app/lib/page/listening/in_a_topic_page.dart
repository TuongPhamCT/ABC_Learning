import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:async/async.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ListenTopicPage extends StatefulWidget {
  final String unitsId;
  const ListenTopicPage({super.key, required this.unitsId});
  static const String routeName = 'listen_topic';

  @override
  State<ListenTopicPage> createState() => _ListenTopicPageState();
}

class _ListenTopicPageState extends State<ListenTopicPage> {
  late Future<DocumentSnapshot> _unitDocument;
  late Future<List<QueryDocumentSnapshot>> _listeningDocument;
  late String? email;
  @override
  void initState() {
    super.initState();
    _unitDocument = _fetchUnitDocument(widget.unitsId);
    _listeningDocument = fetchListeningDocuments(widget.unitsId);
    email = FirebaseAuth.instance.currentUser?.email;
  }

  Future<DocumentSnapshot> _fetchUnitDocument(String unitsId) async {
    return FirebaseFirestore.instance.collection('units').doc(unitsId).get();
  }

  Future<List<QueryDocumentSnapshot>> fetchListeningDocuments(
      String unitId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('listening')
        .where('units_id', isEqualTo: unitId)
        .get();

    return querySnapshot.docs;
  }

  Stream<List<Map<String, dynamic>>> fetchResults(
      String email, String unitId) async* {
    final String? userId = await fetchUserIdByEmail(email);
    if (userId != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('results')
          .doc('${userId}_$unitId')
          .get();
      if (snapshot.exists) {
        final results = List<Map<String, dynamic>>.from(snapshot['results']);
        int correctAnswers =
            results.where((result) => result['is_correct']).length;

        await updateCurrentIndexIfNeeded(unitId, correctAnswers);

        yield results;
      } else {
        yield [];
      }
    } else {
      yield [];
    }
  }

  Future<void> updateCurrentIndexIfNeeded(
      String unitsId, int newCorrectAnswers) async {
    final listeningDocs = await fetchListeningDocuments(unitsId);
    if (listeningDocs.isNotEmpty) {
      final docRef = listeningDocs.first.reference;
      final listeningData = listeningDocs.first.data() as Map<String, dynamic>;
      int currentIndex = listeningData['currentIndex'];

      if (newCorrectAnswers > currentIndex) {
        await docRef.update({'currentIndex': newCorrectAnswers});
      }
    }
  }

  Future<String?> fetchUserIdByEmail(String email) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<void> updateResult(
      String userId, String unitId, String questionId, bool isCorrect) async {
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('results')
        .doc('${userId}_$unitId');

    final DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(snapshot['results']);
      bool questionFound = false;
      for (var result in results) {
        if (result['question_id'] == questionId) {
          result['is_correct'] = isCorrect;
          questionFound = true;
          break;
        }
      }

      if (!questionFound) {
        results.add({'question_id': questionId, 'is_correct': isCorrect});
      }

      await docRef.update({
        'results': results,
      });
    } else {
      await docRef.set({
        'unit_id': unitId,
        'user_id': userId,
        'results': [
          {'question_id': questionId, 'is_correct': isCorrect}
        ],
      });
    }
  }

  int cauHoi = 1;
  PageController _pageController = PageController();
  AudioPlayer player = AudioPlayer();
  TextEditingController textController = TextEditingController();

  bool checkAnswer = false;
  String answer = "right";
  String selectedAnswer = "";
  String trueAnswer = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: _unitDocument,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null || !snapshot.data!.exists) {
              return Text('Document does not exist');
            } else {
              var unitData = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
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
                    const Gap(30),
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          //Trang dau tien, Trang de xem video
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Listening',
                                style: TextStyles.titlePage
                                    .copyWith(color: Colors.black),
                              ),
                              Expanded(
                                child: Center(
                                  child: FutureBuilder(
                                    future: _unitDocument,
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        var videoUrl = snapshot.data!
                                            .get('question_1')['video_url'];
                                        return YoutubePlayer(
                                          controller: YoutubePlayerController(
                                            initialVideoId: videoUrl,
                                            flags: YoutubePlayerFlags(
                                              hideControls: true,
                                              controlsVisibleAtStart: true,
                                              autoPlay: true,
                                              mute: false,
                                            ),
                                          ),
                                          // onReady: () {
                                          //   YoutubePlayerController.of(context)!
                                          //       .addListener(() {
                                          //     if (YoutubePlayerController.of(
                                          //             context)!
                                          //         .value
                                          //         .isFullScreen) {
                                          //       YoutubePlayerController.of(
                                          //               context)!
                                          //           .toggleFullScreenMode();
                                          //     }
                                          //   });
                                          // },
                                          showVideoProgressIndicator: true,
                                          progressIndicatorColor:
                                              ColorPalette.primaryColor,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  setState(() {
                                    cauHoi++;
                                  });
                                  bool isCorrect = true;
                                  if (email != null) {
                                    final String? userId =
                                        await fetchUserIdByEmail(email!);
                                    if (userId != null) {
                                      await updateResult(
                                        userId,
                                        widget.unitsId,
                                        'question_1', // Thay thế bằng questionId thực tế
                                        isCorrect,
                                      );
                                    } else {
                                      print('User ID not found');
                                    }
                                  } else {
                                    print('User is not logged in');
                                  }
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
                                      BorderSide(
                                          color: Colors.white, width: 1)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                child: Text('Next',
                                    style: TextStyles.loginButtonText),
                              ),
                              const Gap(15),
                            ],
                          ),
                          //Trang thu 2, Trang de tra loi cau hoi
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${snapshot.data!.get('question_2')['question_name']}',
                                style: TextStyles.titlePage
                                    .copyWith(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(15),
                              Expanded(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await player.play(
                                          UrlSource(
                                              snapshot.data!.get(
                                                  'question_2')['audio_url'],
                                              mimeType: 'audio/mpeg'),
                                        );
                                      },
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(0)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(55, 55)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.volumeHigh,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        createAnswerButton(
                                            'right',
                                            snapshot.data!
                                                    .get('question_2')['right']
                                                ['img_url']),
                                        createAnswerButton(
                                            'wrong 0',
                                            snapshot.data!
                                                    .get('question_2')['wrong']
                                                ['img_url'][0]),
                                      ],
                                    ),
                                    const Gap(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        createAnswerButton(
                                            'wrong 1',
                                            snapshot.data!
                                                    .get('question_2')['wrong']
                                                ['img_url'][1]),
                                        createAnswerButton(
                                            'wrong 2',
                                            snapshot.data!
                                                    .get('question_2')['wrong']
                                                ['img_url'][2]),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                              ),
                              if (checkAnswer)
                                if (selectedAnswer == answer)
                                  Container(
                                    height: size.height * 0.3,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.green, width: 2),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data!.get('question_2')['right']['description']}',
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
                                            '${snapshot.data!.get('question_2')['right']['answer']}',
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
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.all(8)),
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(
                                                      size.width * 0.75, 55)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                            child: Text('Next Question',
                                                style:
                                                    TextStyles.loginButtonText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    height: size.height * 0.3,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Oops.. That\'s not quite right',
                                          style: TextStyles.questionResult
                                              .copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Gap(5),
                                        Text(
                                          'Answer:',
                                          style:
                                              TextStyles.questionLabel.copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Gap(10),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${snapshot.data!.get('question_2')['right']['answer']}',
                                            style:
                                                TextStyles.trueAnswer.copyWith(
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
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.all(8)),
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(
                                                      size.width * 0.75, 55)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                            child: Text('Next Question',
                                                style:
                                                    TextStyles.loginButtonText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              else
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      checkAnswer = true;
                                    });
                                    if (selectedAnswer == answer) {
                                      bool isCorrect = true;
                                      if (email != null) {
                                        final String? userId =
                                            await fetchUserIdByEmail(email!);
                                        if (userId != null) {
                                          await updateResult(
                                            userId,
                                            widget.unitsId,
                                            'question_2', // Thay thế bằng questionId thực tế
                                            isCorrect,
                                          );
                                        } else {
                                          print('User ID not found');
                                        }
                                      } else {
                                        print('User is not logged in');
                                      }
                                    } else {
                                      bool isCorrect = false;
                                      if (email != null) {
                                        final String? userId =
                                            await fetchUserIdByEmail(email!);
                                        if (userId != null) {
                                          await updateResult(
                                            userId,
                                            widget.unitsId,
                                            'question_2', // Thay thế bằng questionId thực tế
                                            isCorrect,
                                          );
                                        } else {
                                          print('User ID not found');
                                        }
                                      } else {
                                        print('User is not logged in');
                                      }
                                    }
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
                                        BorderSide(
                                            color: Colors.white, width: 1)),
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
                              const Gap(15),
                            ],
                          ),
                          //Trang thu 3
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${snapshot.data!.get('question_3')['question_name']}',
                                style: TextStyles.titlePage
                                    .copyWith(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(15),
                              Expanded(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await player.play(
                                          UrlSource(
                                              snapshot.data!.get(
                                                  'question_3')['audio_url'],
                                              mimeType: 'audio/mpeg'),
                                        );
                                      },
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(0)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(55, 55)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.volumeHigh,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    TextField(
                                      enabled: !checkAnswer,
                                      controller: textController,
                                      textAlign: TextAlign.center,
                                      style: TextStyles.trueAnswer.copyWith(
                                        color: checkAnswer
                                            ? (trueAnswer
                                                        .trim()
                                                        .toLowerCase() ==
                                                    textController.text
                                                        .trim()
                                                        .toLowerCase())
                                                ? Colors.green
                                                : Colors.red
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Type your answer here',
                                        hintStyle:
                                            TextStyles.questionResult.copyWith(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            color: ColorPalette.primaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: trueAnswer
                                                        .trim()
                                                        .toLowerCase() ==
                                                    textController.text
                                                        .trim()
                                                        .toLowerCase()
                                                ? Colors.green
                                                : Colors.red,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    ElevatedButton(
                                      onPressed: null,
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(0)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(size.width, 110)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: Image.network(
                                        '${snapshot.data!.get('question_3')['img_url']}',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                              ),
                              if (checkAnswer)
                                if ('${snapshot.data!.get('question_3')['right']['answer']}' ==
                                    textController.text.trim().toUpperCase())
                                  Container(
                                    height: size.height * 0.3,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            '${snapshot.data!.get('question_3')['right']['description']}',
                                            style: TextStyles.trueAnswer,
                                            textAlign: TextAlign.center,
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
                                              bool isCorrect = true;
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.all(8)),
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(
                                                      size.width * 0.75, 55)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                            child: Text('Review',
                                                style:
                                                    TextStyles.loginButtonText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    height: size.height * 0.3,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Oops.. That\'s not quite right',
                                          style: TextStyles.questionResult
                                              .copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Gap(5),
                                        Text(
                                          'Answer:',
                                          style:
                                              TextStyles.questionLabel.copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Gap(10),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${snapshot.data!.get('question_3')['wrong']['description']}',
                                            style:
                                                TextStyles.trueAnswer.copyWith(
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
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.all(8)),
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(
                                                      size.width * 0.75, 55)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                            child: Text('Review',
                                                style:
                                                    TextStyles.loginButtonText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              else
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      checkAnswer = true;
                                    });
                                    if ('${snapshot.data!.get('question_3')['right']['answer']}'
                                            .trim()
                                            .toUpperCase() ==
                                        textController.text
                                            .trim()
                                            .toUpperCase()) {
                                      bool isCorrect = true;
                                      if (email != null) {
                                        final String? userId =
                                            await fetchUserIdByEmail(email!);
                                        if (userId != null) {
                                          await updateResult(
                                            userId,
                                            widget.unitsId,
                                            'question_3', // Thay thế bằng questionId thực tế
                                            isCorrect,
                                          );
                                        } else {
                                          print('User ID not found');
                                        }
                                      } else {
                                        print('User is not logged in');
                                      }
                                    } else {
                                      bool isCorrect = false;
                                      if (email != null) {
                                        final String? userId =
                                            await fetchUserIdByEmail(email!);
                                        if (userId != null) {
                                          await updateResult(
                                            userId,
                                            widget.unitsId,
                                            'question_3', // Thay thế bằng questionId thực tế
                                            isCorrect,
                                          );
                                        } else {
                                          print('User ID not found');
                                        }
                                      } else {
                                        print('User is not logged in');
                                      }
                                    }
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
                                        BorderSide(
                                            color: Colors.white, width: 1)),
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
                              const Gap(15),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('listening')
                                    .where('units_id',
                                        isEqualTo: widget.unitsId)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Center(child: Text('No data found'));
                                  } else {
                                    var listeningData =
                                        snapshot.data!.docs.first.data()
                                            as Map<String, dynamic>;
                                    int currentIndex =
                                        listeningData['currentIndex'];
                                    int maxIndex = listeningData['maxIndex'];
                                    String title = listeningData['title'];

                                    return Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Listening',
                                            style: TextStyles.titlePage
                                                .copyWith(color: Colors.black),
                                          ),
                                          const Gap(15),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title,
                                                      style:
                                                          TextStyles.itemTitle,
                                                    ),
                                                    const Gap(12),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          width:
                                                              size.width - 185,
                                                          height: 10,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child:
                                                                LinearProgressIndicator(
                                                              value:
                                                                  currentIndex /
                                                                      maxIndex,
                                                              backgroundColor:
                                                                  ColorPalette
                                                                      .progressbarbackground,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      ColorPalette
                                                                          .progressbarValue),
                                                            ),
                                                          ),
                                                        ),
                                                        Gap(8),
                                                        Text(
                                                          '$currentIndex/$maxIndex',
                                                          style: TextStyles
                                                              .itemprogress,
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
                                            child: StreamBuilder(
                                              stream: fetchResults(
                                                  email!, widget.unitsId),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<
                                                              Map<String,
                                                                  dynamic>>>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'));
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No results found'));
                                                } else {
                                                  List<Map<String, dynamic>>
                                                      results = snapshot.data!;
                                                  Map<String, bool>
                                                      uniqueResults = {};
                                                  for (var result in results) {
                                                    uniqueResults[result[
                                                            'question_id']] =
                                                        result['is_correct'];
                                                  }
                                                  List<Map<String, dynamic>>
                                                      finalResults =
                                                      uniqueResults.entries
                                                          .map((e) => {
                                                                'question_id':
                                                                    e.key,
                                                                'is_correct':
                                                                    e.value
                                                              })
                                                          .toList();

                                                  return GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      childAspectRatio: 2.5,
                                                      mainAxisSpacing: 10,
                                                      crossAxisSpacing: 10,
                                                    ),
                                                    itemCount: finalResults
                                                        .length, // Số lượng item tùy theo kết quả
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      Map<String, dynamic>
                                                          result =
                                                          finalResults[index];
                                                      bool isCorrect =
                                                          result['is_correct'];
                                                      Color getItemColor() {
                                                        return isCorrect
                                                            ? Colors.green
                                                            : Colors.red;
                                                      }

                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.15),
                                                              blurRadius: 5,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ButtonStyle(
                                                            padding:
                                                                MaterialStateProperty.all<
                                                                        EdgeInsetsGeometry>(
                                                                    EdgeInsets
                                                                        .all(
                                                                            8)),
                                                            fixedSize: MaterialStateProperty
                                                                .all<Size>(Size(
                                                                    size.width *
                                                                        0.27,
                                                                    36)),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        getItemColor()),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                              '${result['question_id']}',
                                                              style: TextStyles
                                                                  .loginButtonText),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.all(8)),
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size(
                                                      size.width * 0.75, 55)),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(ColorPalette
                                                          .primaryColor),
                                              side: MaterialStateProperty
                                                  .all<BorderSide>(BorderSide(
                                                      color: Colors.white,
                                                      width: 1)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                            child: Text('Finish',
                                                style:
                                                    TextStyles.loginButtonText),
                                          ),
                                          const Gap(15),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget createAnswerButton(String answerLabel, String imgUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: checkAnswer
                  ? null
                  : () {
                      setState(() {
                        selectedAnswer = answerLabel;
                      });
                    },
              style: ButtonStyle(
                alignment: Alignment.center,
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(10)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
                    color: checkAnswer
                        ? (answer == answerLabel)
                            ? Colors.green
                            : selectedAnswer == answerLabel
                                ? Colors.red
                                : Colors.black
                        : selectedAnswer == answerLabel
                            ? ColorPalette.primaryColor
                            : Colors.black,
                    width: checkAnswer
                        ? (answer == answerLabel)
                            ? 3
                            : selectedAnswer == answerLabel
                                ? 3
                                : 1
                        : selectedAnswer == answerLabel
                            ? 3
                            : 1,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              child: Image.network(
                imgUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10), // Khoảng cách giữa hai nút đáp án
        ],
      ),
    );
  }
}
