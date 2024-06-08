import 'package:abc_learning_app/model/listening/listening_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListeningProgressRepo {
  Future<ListeningProgress> getExerciseProgressById(String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('progress-exercise')
        .doc(userId)
        .get();

    if (doc.exists) {
      return ListeningProgress.fromFirestore(doc);
    } else {
      return ListeningProgress(
        currentIndex: 0,
        simpleIndex: 0,
        unitProgress: {},
      ); // Trả về một đối tượng trống nếu không có dữ liệu
    }
  }
}
