import 'dart:math';

import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/exercise/exercise_main_page.dart';
import 'package:abc_learning_app/page/exercise/fill_the_blank.dart';
import 'package:abc_learning_app/page/home_page.dart';
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
  late Future<List<QueryDocumentSnapshot>> _exerciseDocument;
  late Future<DocumentSnapshot> _unitDocument;
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

  Stream<List<Map<String, dynamic>>> fetchResults(
      String email, String unitId) async* {
    final String? userId = await fetchUserIdByEmail(email);
    if (userId != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('results')
          .doc('${userId}_$unitId')
          .get();
      if (snapshot.exists) {
        final List<Map<String, dynamic>> results =
            List<Map<String, dynamic>>.from(snapshot['results']);
        int correctAnswers =
            results.where((result) => result['is_correct'] == true).length;

        await updateCurrentIndexIfNeeded(unitId, userId, correctAnswers);

        yield results;
      } else {
        yield [];
      }
    } else {
      yield [];
    }
  }

  Future<void> updateCurrentIndexIfNeeded(
      String unitsId, String userId, int newCorrectAnswers) async {
    try {
      // Truy cập tài liệu listening theo unitsId trong collection listening
      final QuerySnapshot listeningSnapshot = await FirebaseFirestore.instance
          .collection('exercises')
          .where('units_id', isEqualTo: unitsId)
          .get();

      if (listeningSnapshot.docs.isNotEmpty) {
        final DocumentSnapshot unitsDoc = listeningSnapshot.docs.first;

        // Truy cập tài liệu progress của người dùng
        final progressDocRef =
            unitsDoc.reference.collection('progress').doc(userId);
        final progressDocSnapshot = await progressDocRef.get();

        if (progressDocSnapshot.exists) {
          // Lấy dữ liệu của tài liệu progress
          final progressData =
              progressDocSnapshot.data() as Map<String, dynamic>;
          int currentIndex = progressData['current_index'] ?? 0;

          // Kiểm tra giá trị của newCorrectAnswers và currentIndex
          print(
              'Current Index: $currentIndex, New Correct Answers: $newCorrectAnswers');

          // Cập nhật currentIndex nếu newCorrectAnswers lớn hơn currentIndex hiện tại
          if (newCorrectAnswers > currentIndex) {
            print('Updating current_index to: $newCorrectAnswers');
            await progressDocRef.update({'current_index': newCorrectAnswers});
            print('Update successful');
          } else {
            print('No update needed');
          }
        } else {
          print('Progress document does not exist');
        }
      } else {
        print('Listening document does not exist');
      }
    } catch (e) {
      print('Error updating current index: $e');
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
  final List<Map<String, Offset>> selectedPairs = [];
  final List<Map<String, String>> table = [];
  String selectedWord = '';
  String selectedImage = '';
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

  void updateSelectedImage(String image, Offset position) {
    setState(() {
      selectedImage = image; // Cập nhật URL hình ảnh đã chọn
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
        bool alreadyConnected = selectedPairs.any((pair) =>
            (pair['word'] == selectedWordPosition ||
                pair['image'] == selectedImagePosition));

        if (!alreadyConnected) {
          selectedPairs.add({
            'word': selectedWordPosition,
            'image': selectedImagePosition,
          });
          // Save the data to the table for checking correctness
          table.add({'description': selectedWord, 'imgUrl': selectedImage});
        }

        selectedWord = '';
        selectedImage = '';
        selectedWordPosition = Offset.zero;
        selectedImagePosition = Offset.zero;
      }
    });
  }

  bool checkAllPairsCorrect(
      List<Map<String, String>> table, Map<String, dynamic> questionData) {
    // Tạo một map các cặp đúng từ dữ liệu câu hỏi
    Map<String, String> correctPairs = {
      questionData['option_1']['description']: questionData['option_1']
          ['imgUrl'],
      questionData['option_2']['description']: questionData['option_2']
          ['imgUrl'],
      questionData['option_3']['description']: questionData['option_3']
          ['imgUrl'],
    };

    // In ra các cặp đúng để kiểm tra
    print("Correct pairs:");
    correctPairs.forEach((desc, url) {
      print('$desc -> $url');
    });

    // Kiểm tra số lượng cặp trong bảng table
    if (table == null || table.length != correctPairs.length) {
      print(
          'Mismatch in the number of pairs. Expected: ${correctPairs.length}, but found: ${table.length}');
      return false;
    }

    // In ra các cặp đã chọn để kiểm tra
    print("Selected pairs in table:");
    for (var pair in table) {
      if (pair == null) {
        return false;
      }
      print(
          'Description: ${pair['description']}, Image URL: ${pair['imgUrl']}');
      if (correctPairs[pair['description']] != pair['imgUrl']) {
        print('Mismatch found: ${pair['description']} -> ${pair['imgUrl']}');
        return false;
      }
    }

    // Nếu tất cả các cặp đều đúng và số lượng cặp khớp
    return true;
  }

  bool checkAnswer = false;
  //
  String answer = '';
  String selectedAnswer = '';

  Future<void> saveProgress(String userId, int currentIndex, int simpleIndex,
      Map<String, dynamic> unitProgress) async {
    try {
      await FirebaseFirestore.instance
          .collection('progress-exercise')
          .doc(userId)
          .set({
        'current_index': currentIndex,
        'simple_index': simpleIndex,
        'unit_progress': unitProgress,
      }, SetOptions(merge: true)); // Merge để giữ lại các trường hiện có
    } catch (e) {
      print("Error saving progress: $e");
    }
  }

  Future<void> processAndSaveProgress(String userId, String unitId) async {
    // Lấy danh sách các exercise documents cho unitId
    List<QueryDocumentSnapshot> exerciseDocs =
        await fetchExerciseDocuments(unitId);

    int maxUnitIndex = 0;

    // Tính toán maxIndex cho đơn vị học tập hiện tại
    for (var exerciseDoc in exerciseDocs) {
      var exerciseData = exerciseDoc.data() as Map<String, dynamic>;
      maxUnitIndex = exerciseData['maxIndex'] ?? 0;
    }

    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('results')
        .doc('${userId}_$unitId');

    final DocumentSnapshot snapshot = await docRef.get();
    if (!snapshot.exists) {
      print('No results found for the user and unit.');
      return;
    }

    List<Map<String, dynamic>> results =
        List<Map<String, dynamic>>.from(snapshot['results']);
    int currentUnitIndex =
        results.where((result) => result['is_correct'] == true).length;

    // Lấy dữ liệu progress hiện tại từ Firestore
    DocumentSnapshot userProgressDoc = await FirebaseFirestore.instance
        .collection('progress-exercise')
        .doc(userId)
        .get();

    int currentIndex = 0;
    int simpleIndex = 0;

    Map<String, dynamic> unitProgress = {}; // Lưu trữ tiến độ của từng unit

    if (userProgressDoc.exists) {
      var progressData = userProgressDoc.data() as Map<String, dynamic>;
      currentIndex = progressData['current_index'] ?? 0;
      simpleIndex = progressData['simple_index'] ?? 0;
      unitProgress =
          Map<String, dynamic>.from(progressData['unit_progress'] ?? {});
    }

    // Tính toán currentIndex và cập nhật unitProgress
    // Tính toán currentIndex và cập nhật unitProgress
    var previousUnitProgress = unitProgress[unitId] as Map<String, dynamic>? ??
        {'index': 0, 'reachMax': false};
    int previousUnitIndex = previousUnitProgress['index'];
    bool reachMax = previousUnitProgress['reachMax'];

    if (currentUnitIndex > previousUnitIndex) {
      currentIndex = currentIndex - previousUnitIndex + currentUnitIndex;
      unitProgress[unitId] = {'index': currentUnitIndex, 'reachMax': reachMax};

      // Kiểm tra nếu tất cả câu hỏi đều đúng lần đầu tiên cho đơn vị hiện tại
      if (currentUnitIndex == maxUnitIndex && !reachMax) {
        simpleIndex++;
        unitProgress[unitId]['reachMax'] = true;
      }
    }

    // Lưu tiến độ vào Firestore
    await saveProgress(userId, currentIndex, simpleIndex, unitProgress);
  }

// Ví dụ gọi hàm này sau khi có kết quả
  void handleResults(String userId, String unitId) {
    processAndSaveProgress(userId, unitId);
  }

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
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null || !snapshot.data!.exists) {
              return const Text('Document does not exist');
            } else {
              var unitData = snapshot.data!.data() as Map<String, dynamic>;
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
                            itemCount: 3,
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
                    const Gap(10),
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
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
                                        const Text(
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
                                                duration: const Duration(
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
                                                      const EdgeInsets.all(8)),
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
                                            child: const Text('Next Question',
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
                                                duration: const Duration(
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
                                                      const EdgeInsets.all(8)),
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
                                            child: const Text('Next Question',
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
                                    if (textController.text
                                            .trim()
                                            .toLowerCase() ==
                                        '${snapshot.data!.get('question_1')['answer']}'
                                            .trim()
                                            .toLowerCase()) {
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
                                    } else {
                                      bool isCorrect = false;
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
                                    }
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                        const EdgeInsets.all(8)),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(size.width * 0.75, 55)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorPalette.primaryColor),
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                            color: Colors.white, width: 1)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Check Answer',
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
                                              child: const Text("Delete"),
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
                                                    duration: const Duration(
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
                                                          const EdgeInsets.all(
                                                              8)),
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
                                                child: const Text(
                                                    'Next Question',
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
                                                    duration: const Duration(
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
                                                          const EdgeInsets.all(
                                                              8)),
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
                                                child: const Text(
                                                    'Next Question',
                                                    style: TextStyles
                                                        .loginButtonText),
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
                                        if (wordController.text
                                                .trim()
                                                .toUpperCase() ==
                                            '${snapshot.data!.get('question_2')['answer']}'
                                                .trim()
                                                .toUpperCase()) {
                                          bool isCorrect = true;
                                          if (email != null) {
                                            final String? userId =
                                                await fetchUserIdByEmail(
                                                    email!);
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
                                                await fetchUserIdByEmail(
                                                    email!);
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
                                                EdgeInsetsGeometry>(
                                            const EdgeInsets.all(8)),
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(size.width * 0.75, 55)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette.primaryColor),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(const BorderSide(
                                                color: Colors.white, width: 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                        ),
                                      ),
                                      child: const Text('Check Answer',
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
                                  Expanded(child: Container()),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (selectedWord.isNotEmpty) {
                                            updateSelectedImage(
                                                '${snapshot.data!.get('question_3')['option_1']['imgUrl']}',
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
                                                '${snapshot.data!.get('question_3')['option_2']['imgUrl']}',
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
                                            updateSelectedImage(
                                                '${snapshot.data!.get('question_3')['option_3']['imgUrl']}',
                                                Offset(
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
                                            selectedImagePosition !=
                                                Offset.zero)
                                          CustomPaint(
                                            painter: LinePainter(
                                              // Kiểm tra xem điểm bắt đầu là từ hay ảnh
                                              startPosition:
                                                  selectedWordPosition,
                                              // Kiểm tra xem điểm kết thúc là từ hay ảnh
                                              endPosition:
                                                  selectedImagePosition,
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
                                                  Colors.black
                                                      .withOpacity(0.15)),
                                          fixedSize: MaterialStateProperty.all<
                                                  Size>(
                                              Size(size.width / 3 - 40, 36)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorPalette.primaryColor),
                                          side: MaterialStateProperty
                                              .all<BorderSide>(const BorderSide(
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
                                              const EdgeInsets.all(0)),
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
                                                  Colors.black
                                                      .withOpacity(0.15)),
                                          fixedSize: MaterialStateProperty.all<
                                                  Size>(
                                              Size(size.width / 3 - 40, 36)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorPalette.primaryColor),
                                          side: MaterialStateProperty
                                              .all<BorderSide>(const BorderSide(
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
                                              const EdgeInsets.all(0)),
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
                                              const EdgeInsets.all(0)),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black
                                                      .withOpacity(0.15)),
                                          fixedSize: MaterialStateProperty.all<
                                                  Size>(
                                              Size(size.width / 3 - 40, 36)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorPalette.primaryColor),
                                          side: MaterialStateProperty
                                              .all<BorderSide>(const BorderSide(
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
                                  Expanded(child: Container()),
                                  if (checkAnswer)
                                    if (checkAllPairsCorrect(table,
                                        snapshot.data!.get('question_3')))
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
                                              color:
                                                  Colors.red.withOpacity(0.3),
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
                                        ],
                                      )
                                  else
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          checkAnswer = true;
                                        });
                                        if (checkAllPairsCorrect(table,
                                            snapshot.data!.get('question_3'))) {
                                          bool isCorrect = true;
                                          if (email != null) {
                                            final String? userId =
                                                await fetchUserIdByEmail(
                                                    email!);
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
                                                await fetchUserIdByEmail(
                                                    email!);
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
                                ]),
                          ),

                          //Trang thu tu
                          //Trang review
                          // Trang thứ 4
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('exercises')
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
                                    var listeningDoc =
                                        snapshot.data!.docs.first;
                                    var listeningData = listeningDoc.data()
                                        as Map<String, dynamic>;
                                    int maxIndex = listeningData['maxIndex'];
                                    String title = listeningData['title'];

                                    return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('exercises')
                                          .doc(listeningDoc.id)
                                          .collection('progress')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .snapshots(),
                                      builder: (context, progressSnapshot) {
                                        if (progressSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (progressSnapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${progressSnapshot.error}'));
                                        } else if (!progressSnapshot.hasData ||
                                            !progressSnapshot.data!.exists) {
                                          return Center(
                                              child: Text(
                                                  'No progress data found'));
                                        } else {
                                          var progressData =
                                              progressSnapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          int currentIndex =
                                              progressData['current_index'];

                                          return Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Exercise',
                                                  style: TextStyles.titlePage
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                                const Gap(15),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    border: Border.all(
                                                      color: ColorPalette
                                                          .itemBorder,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            title,
                                                            style: TextStyles
                                                                .itemTitle,
                                                          ),
                                                          const Gap(12),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    size.width -
                                                                        185,
                                                                height: 10,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  child:
                                                                      LinearProgressIndicator(
                                                                    value: currentIndex /
                                                                        maxIndex,
                                                                    backgroundColor:
                                                                        ColorPalette
                                                                            .progressbarbackground,
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      ColorPalette
                                                                          .progressbarValue,
                                                                    ),
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
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Center(
                                                            child: Text(
                                                                'Error: ${snapshot.error}'));
                                                      } else if (!snapshot
                                                              .hasData ||
                                                          snapshot
                                                              .data!.isEmpty) {
                                                        return Center(
                                                            child: Text(
                                                                'No results found'));
                                                      } else {
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            results =
                                                            snapshot.data!;
                                                        Map<String, bool>
                                                            uniqueResults = {};
                                                        for (var result
                                                            in results) {
                                                          uniqueResults[result[
                                                                  'question_id']] =
                                                              result[
                                                                  'is_correct'];
                                                        }
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            finalResults =
                                                            uniqueResults
                                                                .entries
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
                                                            childAspectRatio:
                                                                2.5,
                                                            mainAxisSpacing: 10,
                                                            crossAxisSpacing:
                                                                10,
                                                          ),
                                                          itemCount:
                                                              finalResults
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            Map<String, dynamic>
                                                                result =
                                                                finalResults[
                                                                    index];
                                                            bool isCorrect =
                                                                result[
                                                                    'is_correct'];
                                                            Color
                                                                getItemColor() {
                                                              return isCorrect
                                                                  ? Colors.green
                                                                  : Colors.red;
                                                            }

                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.15),
                                                                    blurRadius:
                                                                        5,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style:
                                                                    ButtonStyle(
                                                                  padding: MaterialStateProperty.all<
                                                                          EdgeInsetsGeometry>(
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                                  fixedSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          size.width *
                                                                              0.27,
                                                                          36)),
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          getItemColor()),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    '${index + 1}',
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
                                                  onPressed: () async {
                                                    try {
                                                      String? userId =
                                                          await fetchUserIdByEmail(
                                                              email!);
                                                      if (userId != null) {
                                                        handleResults(userId,
                                                            widget.unitsId);
                                                        Navigator.pop(context);
                                                      } else {
                                                        print('User not found');
                                                        // Xử lý trường hợp người dùng không tìm thấy
                                                      }
                                                    } catch (e) {
                                                      print('Error: $e');
                                                      // Xử lý lỗi nếu cần thiết
                                                    }
                                                    Navigator.pop(
                                                        const ExerciseMainPage()
                                                            as BuildContext);
                                                  },
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .all<EdgeInsetsGeometry>(
                                                            EdgeInsets.all(8)),
                                                    fixedSize:
                                                        MaterialStateProperty
                                                            .all<Size>(Size(
                                                                size.width *
                                                                    0.75,
                                                                55)),
                                                    backgroundColor:
                                                        MaterialStateProperty.all<
                                                                Color>(
                                                            ColorPalette
                                                                .primaryColor),
                                                    side: MaterialStateProperty
                                                        .all<
                                                                BorderSide>(
                                                            BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1)),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text('Finish',
                                                      style: TextStyles
                                                          .loginButtonText),
                                                ),
                                                const Gap(15),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          )
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
