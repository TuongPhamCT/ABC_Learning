import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProgress {
  final int currentIndex;
  final int simpleIndex;
  final Map<String, dynamic> unitProgress;

  ExerciseProgress({
    required this.currentIndex,
    required this.simpleIndex,
    required this.unitProgress,
  });

  factory ExerciseProgress.fromFirestore(DocumentSnapshot doc) {
    return ExerciseProgress(
      currentIndex: doc['current_index'] ?? 0,
      simpleIndex: doc['simple_index'] ?? 0,
      unitProgress: Map<String, dynamic>.from(doc['unit_progress']),
    );
  }
}
