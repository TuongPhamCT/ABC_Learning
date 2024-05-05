import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Progress {
  String achievementId;
  int currentProgress;

  Progress({required this.achievementId, required this.currentProgress});

  Map<String, dynamic> toJson() {
    return {'achievementId': achievementId, 'currentProgress': currentProgress};
  }

  factory Progress.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Progress(
        achievementId: data['achievementId'],
        currentProgress: int.parse(data['currentProgress']));
  }

  @override
  String toString() {
    return achievementId;
  }
}

class AchievementProgress {
  static const String documentId = 'progress-achivement';

  List<Progress> progresses;
  String userId;

  AchievementProgress({required this.progresses, required this.userId});

  Map<String, dynamic> toJson() {
    return {'progresses': progresses};
  }

  static Future<AchievementProgress> fromFirestore(DocumentSnapshot doc) async {
    AchievementProgressRepo achiementProgressRepo = AchievementProgressRepo();
    List<Progress> progresses = await achiementProgressRepo.getProgresses();
    return AchievementProgress(userId: doc.id, progresses: progresses);
  }

  @override
  String toString() {
    return userId;
  }
}

class AchievementProgressRepo {
  Future<List<Progress>> getProgresses() async {
    final CollectionReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance
            .collection(AchievementProgress.documentId)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('progresses');
    QuerySnapshot querySnapshot = await collectionRef.get();

    final progresses =
        querySnapshot.docs.map((doc) => Progress.fromFirestore(doc)).toList();
    return progresses;
  }

  Future<AchievementProgress> getAchievementProgressById(String id) async {
    final DocumentReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance
            .collection(AchievementProgress.documentId)
            .doc(id);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await collectionRef.get();

    final achievement = await AchievementProgress.fromFirestore(documentSnapshot);
    print(achievement);
    return achievement;
  }
}
