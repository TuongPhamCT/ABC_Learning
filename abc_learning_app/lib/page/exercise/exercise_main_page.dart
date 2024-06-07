import 'package:abc_learning_app/constant/asset_helper.dart';
import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:abc_learning_app/page/exercise/exercise_sub_page.dart';
import 'package:abc_learning_app/page/listening/listen_main_page.dart';
import 'package:abc_learning_app/page/reading/read_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ExerciseMainPage extends StatefulWidget {
  const ExerciseMainPage({Key? key}) : super(key: key);
  static const String routeName = 'exercise_main';

  @override
  State<ExerciseMainPage> createState() => _ExerciseMainPageState();
}

class _ExerciseMainPageState extends State<ExerciseMainPage> {
  void _navigateToTopicPage(String unitsId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExerciseSubPage(unitsId: unitsId),
      ),
    );
  }

  Future<void> initializeUserProgressIfNeeded(
      String userId, String documentId) async {
    final progressDocRef = FirebaseFirestore.instance
        .collection('exercises')
        .doc(documentId)
        .collection('progress')
        .doc(userId);

    final progressDocSnapshot = await progressDocRef.get();

    if (!progressDocSnapshot.exists) {
      await progressDocRef.set({
        'user_id': userId,
        'current_index': 0,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String? email = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
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
                AssetHelper.exerciseMain,
                width: 260,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Exercise',
                style: TextStyles.titlePage,
              ),
            ),
            const Gap(20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('exercises')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return buildExerciseItem(context, document, email);
                    },
                  );
                },
              ),
            ),
            const Gap(15),
          ],
        ),
      ),
    );
  }

  Widget buildExerciseItem(
      BuildContext context, DocumentSnapshot document, String? email) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return FutureBuilder<String?>(
      future: fetchUserIdByEmail(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('User not found');
        } else {
          String userId = snapshot.data!;
          initializeUserProgressIfNeeded(userId, document.id);
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('exercises')
                .doc(document.id)
                .collection('progress')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return GestureDetector(
                  onTap: () {
                    _navigateToTopicPage(data['units_id']);
                  },
                  child: buildExerciseCard(
                      context, data, size, 0, data['maxIndex']),
                );
              } else {
                var progressData =
                    snapshot.data!.data() as Map<String, dynamic>;
                int currentIndex = progressData['current_index'] ?? 0;
                return GestureDetector(
                  onTap: () {
                    _navigateToTopicPage(data['units_id']);
                  },
                  child: buildExerciseCard(
                      context, data, size, currentIndex, data['maxIndex']),
                );
              }
            },
          );
        }
      },
    );
  }

  Future<String?> fetchUserIdByEmail(String? email) async {
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

  Widget buildExerciseCard(BuildContext context, Map<String, dynamic> data,
      Size size, int currentIndex, int maxIndex) {
    return Container(
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
          Image.network(
            data['img_url'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
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
                        value: currentIndex / maxIndex,
                        backgroundColor: ColorPalette.progressbarbackground,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorPalette.progressbarValue),
                      ),
                    ),
                  ),
                  Gap(8),
                  Text(
                    '$currentIndex/$maxIndex',
                    style: TextStyles.itemprogress,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
