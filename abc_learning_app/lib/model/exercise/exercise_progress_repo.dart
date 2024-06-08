import 'package:abc_learning_app/model/exercise/exercise_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProgressRepo {
  Future<ExerciseProgress> getExerciseProgressById(String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('progress-exercise')
        .doc(userId)
        .get();

    if (doc.exists) {
      return ExerciseProgress.fromFirestore(doc);
    } else {
      return ExerciseProgress(
        currentIndex: 0,
        simpleIndex: 0,
        unitProgress: {},
      ); // Trả về một đối tượng trống nếu không có dữ liệu
    }
  }
}
