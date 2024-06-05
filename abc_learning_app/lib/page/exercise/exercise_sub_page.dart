import 'dart:math';

import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/exercise/fill_the_blank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ExerciseSubPage extends StatefulWidget {
  final String unitsId;
  const ExerciseSubPage({super.key, required this.unitsId});
  static const String routeName = 'exercise_sub_page';

  @override
  State<ExerciseSubPage> createState() => _ExerciseSubPageState();
}

class _ExerciseSubPageState extends State<ExerciseSubPage> {
  int cauHoi = 1;
  PageController _pageController = PageController();
  TextEditingController textController = TextEditingController();
  late Future<DocumentSnapshot> _unitDocument;
  late Future<List<QueryDocumentSnapshot>> _exerciseDocument;
  late String? email;
  //trang thu 2
  TextEditingController wordController = TextEditingController();
  String filledWord = '';
  int filledWordLength = 0;
  String listIndex = '';
  List<bool> buttonDisabled = [];
  List<String> combinedCharacters = [];
  String wordFromFirebase = '';
  bool isWordInitialized = false;

  void fillCharacter(String character, int index) {
    setState(() {
      filledWord += character;
      wordController.text = filledWord;
      buttonDisabled[index] = true; // Vô hiệu hóa nút đã được bấm
      filledWordLength++; // Tăng độ dài từ đã điền
      listIndex += index.toString();
    });
  }

  void deleteCharacter() {
    setState(() {
      if (filledWord.isNotEmpty) {
        filledWord = filledWord.substring(
            0, filledWord.length - 1); // Xóa ký tự cuối cùng
        wordController.text = filledWord; // đặt lại giá trị cho textController
        filledWordLength--; // Giảm độ dài từ đã điền
        int index = int.parse(listIndex.substring(listIndex.length - 1));
        buttonDisabled[index] = false; // Kích hoạt nút đã bị vô hiệu hóa
        listIndex =
            listIndex.substring(0, listIndex.length - 1); // Xóa index cuối cùng
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _unitDocument = _fetchUnitDocument(widget.unitsId);
    _exerciseDocument = fetchExerciseDocuments(widget.unitsId);
    email = FirebaseAuth.instance.currentUser?.email;
  }

  void _initializeWordData(String word) {
    if (!isWordInitialized) {
      final random = Random();
      buttonDisabled = List.generate(word.length + 3, (_) => false);
      combinedCharacters = word.split('');
      final List<String> randomCharacters = List.generate(3, (_) {
        return String.fromCharCode(random.nextInt(26) + 'A'.codeUnitAt(0));
      });
      combinedCharacters.addAll(randomCharacters);
      combinedCharacters.shuffle();
      isWordInitialized = true;
    }
  }

  Future<DocumentSnapshot> _fetchUnitDocument(String unitsId) async {
    return FirebaseFirestore.instance.collection('units').doc(unitsId).get();
  }

  Future<List<QueryDocumentSnapshot>> fetchExerciseDocuments(
      String unitId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('exercises')
        .where('units_id', isEqualTo: unitId)
        .get();

    return querySnapshot.docs;
  }

  Future<void> updateCurrentIndexIfNeeded(
      String unitsId, int newCorrectAnswers) async {
    final exerciseDocs = await fetchExerciseDocuments(unitsId);
    if (exerciseDocs.isNotEmpty) {
      final docRef = exerciseDocs.first.reference;
      final listeningData = exerciseDocs.first.data() as Map<String, dynamic>;
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

  //Trang thu 3
  //Trang bai tap thu 3
  //Noi tu va hinh anh
  // Position and selection variables
  List<Map<String, Offset>> selectedPairs = [];
  String selectedWord = '';
  Offset selectedWordPosition = Offset.zero;
  Offset selectedImagePosition = Offset.zero;

  void updateSelectedWord(String word, Offset position) {
    setState(() {
      selectedWord = word;
      selectedWordPosition = position;
      if (selectedImagePosition != Offset.zero) {
        addPair();
      }
    });
  }

  void updateSelectedImage(Offset position) {
    setState(() {
      selectedImagePosition = position;
      if (selectedWord.isNotEmpty) {
        addPair();
      }
    });
  }

  void addPair() {
    setState(() {
      if (selectedWord.isNotEmpty && selectedImagePosition != Offset.zero) {
        // Check if the word or image is already connected
        bool wordConnected =
            selectedPairs.any((pair) => pair['word'] == selectedWordPosition);
        bool imageConnected =
            selectedPairs.any((pair) => pair['image'] == selectedImagePosition);

        if (!wordConnected && !imageConnected) {
          selectedPairs.add({
            'word': selectedWordPosition,
            'image': selectedImagePosition,
          });
        }

        selectedWord = '';
        selectedWordPosition = Offset.zero;
        selectedImagePosition = Offset.zero;
      }
    });
  }

  bool checkAnswer = false;
  //
  String answer = '';
  String selectedAnswer = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Tạo danh sách nút
    List<Widget> buttons = [];
    for (int i = 0; i < combinedCharacters.length; i++) {
      buttons.add(
        GestureDetector(
          onTap: buttonDisabled[i]
              ? null
              : () => fillCharacter(combinedCharacters[i], i),
          child: Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: buttonDisabled[i]
                  ? ColorPalette.exerciseButton
                  : ColorPalette.exerciseButtonInActive,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              combinedCharacters[i],
              style: TextStyles.exerciseContent.copyWith(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                color: buttonDisabled[i]
                    ? Colors.white
                    : ColorPalette.exerciseButton,
              ),
            ),
          ),
        ),
      );
    }
    // Tạo danh sách các hàng
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 4) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.sublist(i, min(i + 4, buttons.length)),
        ),
      );
    }
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
              bool checkAllPairsCorrect(List<Map<String, Offset>> selectedPairs,
                  Map<String, dynamic> options) {
                // Lặp qua tất cả các cặp đã chọn
                for (var option in options.values) {
                  // Kiểm tra xem mỗi cặp có trong selectedPairs không
                  if (!selectedPairs.any((pair) =>
                      pair['word'] == option['description'] &&
                      pair['image'] == option['imgUrl'])) {
                    return false; // Nếu thiếu ít nhất một cặp, trả về false
                  }
                }
                return true; // Nếu tất cả các cặp đều được chọn đúng, trả về true
              }

              String wordFromFirebase = unitData['question_2']['answer'];
              _initializeWordData(wordFromFirebase);
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
                    const Gap(10),
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          //Trang dau tien
                          //Dien tu con thieu vao cho trong
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${snapshot.data!.get('question_1')['title']}',
                                style: TextStyles.titlePage
                                    .copyWith(color: Colors.black),
                              ),
                              Expanded(child: Container()),
                              Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  AssetHelper.storyilu,
                                  width: 130,
                                  height: 115,
                                ),
                              ),
                              const Gap(10),
                              FillInTheBlanks(
                                sentence:
                                    '${snapshot.data!.get('question_1')['sentence_question']}',
                                controller: textController,
                                checkAnswer: checkAnswer,
                              ),
                              Expanded(child: Container()),
                              if (checkAnswer)
                                if (textController.text.trim().toLowerCase() ==
                                    '${snapshot.data!.get('question_1')['answer']}'
                                        .trim()
                                        .toLowerCase())
                                  Container(
                                    height: size.height * 0.25,
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
                                          '${snapshot.data!.get('question_1')['description_right']}',
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
                                            '${snapshot.data!.get('question_1')['complete_sentence']}',
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
                                    height: size.height * 0.25,
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
                                          '${snapshot.data!.get('question_1')['description_wrong']}',
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
                                            '${snapshot.data!.get('question_1')['complete_sentence']}',
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
                          //Trang thu hai
                          //Ghep tu
                          SingleChildScrollView(
                            child: Container(
                              height: size.height - 145,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${snapshot.data!.get('question_2')['title']}',
                                    style: TextStyles.titlePage
                                        .copyWith(color: Colors.black),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      AssetHelper.exerciseMain,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  PinCodeTextField(
                                    readOnly: true,
                                    length:
                                        '${snapshot.data!.get('question_2')['answer']}'
                                            .length,
                                    appContext: context,
                                    controller: wordController,
                                    pastedTextStyle:
                                        TextStyles.exerciseContent.copyWith(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w800,
                                      color: ColorPalette.primaryColor,
                                    ),
                                    animationType: AnimationType.fade,
                                    textStyle:
                                        TextStyles.exerciseContent.copyWith(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w800,
                                      color: ColorPalette.primaryColor,
                                    ),
                                    pinTheme: PinTheme(
                                      fieldHeight: 50,
                                      fieldWidth: 30,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedFillColor: Colors.white,
                                      activeColor: Colors.black,
                                      inactiveColor: Colors.black,
                                      selectedColor: ColorPalette.primaryColor,
                                    ),
                                  ),
                                  Container(
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ...rows,
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                surfaceTintColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.pink),
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(ColorPalette
                                                            .primaryColor),
                                                textStyle: MaterialStateProperty
                                                    .all<TextStyle>(TextStyles
                                                        .exerciseContent),
                                              ),
                                              onPressed: checkAnswer
                                                  ? null
                                                  : deleteCharacter,
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        ),

                                        //Ngan khong cho nguoi dung tiep tuc bam cac nut
                                        Visibility(
                                          child: Container(
                                            height: rows.length * 65.0,
                                            color: Colors.transparent,
                                          ),
                                          visible: filledWordLength ==
                                              '${snapshot.data!.get('question_2')['answer']}'
                                                  .length,
                                        )
                                      ],
                                    ),
                                  ),
                                  if (checkAnswer)
                                    if (wordController.text
                                            .trim()
                                            .toUpperCase() ==
                                        '${snapshot.data!.get('question_2')['answer']}'
                                            .trim()
                                            .toUpperCase())
                                      Container(
                                        height: size.height * 0.23,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                '${snapshot.data!.get('question_2')['answer']}',
                                                style: TextStyles.trueAnswer,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _pageController.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 300),
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
                                                  fixedSize:
                                                      MaterialStateProperty
                                                          .all<Size>(Size(
                                                              size.width * 0.75,
                                                              55)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.green),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                  ),
                                                ),
                                                child: Text('Next Question',
                                                    style: TextStyles
                                                        .loginButtonText),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              style: TextStyles.questionLabel
                                                  .copyWith(
                                                color: Colors.red,
                                              ),
                                            ),
                                            const Gap(10),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${snapshot.data!.get('question_2')['answer']}',
                                                style: TextStyles.trueAnswer
                                                    .copyWith(
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
                                                    duration: Duration(
                                                        milliseconds: 300),
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
                                                  fixedSize:
                                                      MaterialStateProperty
                                                          .all<Size>(Size(
                                                              size.width * 0.75,
                                                              55)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                  ),
                                                ),
                                                child: Text('Next Question',
                                                    style: TextStyles
                                                        .loginButtonText),
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
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(8)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(size.width * 0.75, 55)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(BorderSide(
                                                color: Colors.white, width: 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
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

                          //Trang thu ba
                          //Bai tap noi cac tu va hinh anh
                          Container(
                            height: size.height - 145,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Gap(20),
                                Text(
                                  '${snapshot.data!.get('question_3')['title']}',
                                  style: TextStyles.titlePage
                                      .copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(45),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedWord.isNotEmpty) {
                                          updateSelectedImage(
                                              Offset(size.width / 6 - 20, 5));
                                        }
                                      },
                                      child: Image.network(
                                        '${snapshot.data!.get('question_3')['option_1']['imgUrl']}',
                                        width: size.width / 3 - 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedWord.isNotEmpty) {
                                          updateSelectedImage(
                                              Offset(size.width / 2 - 24, 5));
                                        }
                                      },
                                      child: Image.network(
                                        '${snapshot.data!.get('question_3')['option_2']['imgUrl']}',
                                        width: size.width / 3 - 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedWord.isNotEmpty) {
                                          updateSelectedImage(Offset(
                                              size.width -
                                                  48 -
                                                  (size.width / 6 - 20),
                                              5));
                                        }
                                      },
                                      child: Image.network(
                                        '${snapshot.data!.get('question_3')['option_3']['imgUrl']}',
                                        width: size.width / 3 - 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: size.height * 0.25,
                                  width: size.width,
                                  child: Stack(
                                    children: [
                                      for (var pair in selectedPairs)
                                        CustomPaint(
                                          painter: LinePainter(
                                            startPosition: pair['word']!,
                                            endPosition: pair['image']!,
                                          ),
                                        ),
                                      if (selectedWord.isNotEmpty &&
                                          selectedImagePosition != Offset.zero)
                                        CustomPaint(
                                          painter: LinePainter(
                                            // Kiểm tra xem điểm bắt đầu là từ hay ảnh
                                            startPosition:
                                                selectedWord.isNotEmpty
                                                    ? selectedWordPosition
                                                    : selectedImagePosition,
                                            // Kiểm tra xem điểm kết thúc là từ hay ảnh
                                            endPosition: selectedWord.isNotEmpty
                                                ? selectedImagePosition
                                                : selectedWordPosition,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (selectedImagePosition ==
                                            Offset.zero) {
                                          setState(() {
                                            selectedWord =
                                                '${snapshot.data!.get('question_3')['option_2']['description']}';
                                            selectedWordPosition = Offset(
                                                size.width / 6 - 20,
                                                size.height * 0.245);
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        shadowColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black.withOpacity(0.15)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(size.width / 3 - 40, 36)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(BorderSide(
                                                color:
                                                    ColorPalette.answerBorder,
                                                width: 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(0)),
                                      ),
                                      child: Text(
                                        '${snapshot.data!.get('question_3')['option_2']['description']}',
                                        style: TextStyles.storyAnswer,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (selectedImagePosition ==
                                            Offset.zero) {
                                          setState(() {
                                            selectedWord =
                                                '${snapshot.data!.get('question_3')['option_3']['description']}';
                                            selectedWordPosition = Offset(
                                                size.width / 2 - 24,
                                                size.height * 0.245);
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        shadowColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black.withOpacity(0.15)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(size.width / 3 - 40, 36)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(BorderSide(
                                                color:
                                                    ColorPalette.answerBorder,
                                                width: 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(0)),
                                      ),
                                      child: Text(
                                        '${snapshot.data!.get('question_3')['option_3']['description']}',
                                        style: TextStyles.storyAnswer,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (selectedImagePosition ==
                                            Offset.zero) {
                                          setState(() {
                                            selectedWord =
                                                '${snapshot.data!.get('question_3')['option_1']['description']}';
                                            selectedWordPosition = Offset(
                                                size.width -
                                                    48 -
                                                    (size.width / 6 - 20),
                                                size.height * 0.245);
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                            EdgeInsets.all(0)),
                                        shadowColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black.withOpacity(0.15)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(size.width / 3 - 40, 36)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(BorderSide(
                                                color:
                                                    ColorPalette.answerBorder,
                                                width: 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '${snapshot.data!.get('question_3')['option_1']['description']}',
                                        style: TextStyles.storyAnswer,
                                      ),
                                    ),
                                  ],
                                ),
                                if (checkAllPairsCorrect(
                                        selectedPairs,
                                        snapshot.data!
                                            .get('question_3')['option']) ==
                                    true)
                                  if (false)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: size.width,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Excellent !',
                                            style: TextStyles.result,
                                          ),
                                        ),
                                        const Gap(15),
                                        ElevatedButton(
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
                                                    Size(
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
                                      ],
                                    )
                                  else
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: size.width,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Wrong !',
                                            style: TextStyles.result.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const Gap(15),
                                        ElevatedButton(
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
                                                    Size(
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
                                      ],
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
                                              EdgeInsetsGeometry>(
                                          EdgeInsets.all(8)),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(size.width * 0.75, 55)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ColorPalette.primaryColor),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                              BorderSide(
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
                                    child: Text('Check Answer',
                                        style: TextStyles.loginButtonText),
                                  ),
                              ],
                            ),
                          ),

                          //Trang thu tu
                          //Trang review
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Exercise',
                                style: TextStyles.titlePage
                                    .copyWith(color: Colors.black),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Alphabet',
                                          style: TextStyles.itemTitle,
                                        ),
                                        const Gap(12),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: size.width - 185,
                                              height: 10,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: LinearProgressIndicator(
                                                  value: 9 / 50,
                                                  backgroundColor: ColorPalette
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.all(8)),
                                          fixedSize:
                                              MaterialStateProperty.all<Size>(
                                                  Size(size.width * 0.27, 36)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  getItemColor(index)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                child: Text('Finish',
                                    style: TextStyles.loginButtonText),
                              ),
                              const Gap(15),
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
}

class LinePainter extends CustomPainter {
  final Offset startPosition;
  final Offset endPosition;

  LinePainter({required this.startPosition, required this.endPosition});

  @override
  void paint(Canvas canvas, Size size) {
    if (startPosition != null && endPosition != null) {
      Paint paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0;

      canvas.drawLine(startPosition, endPosition, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
