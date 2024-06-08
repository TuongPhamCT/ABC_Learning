import 'package:cloud_firestore/cloud_firestore.dart';

class ListeningProgress {
  final int currentIndex;
  final int simpleIndex;
  final Map<String, dynamic> unitProgress;

  ListeningProgress({
    required this.currentIndex,
    required this.simpleIndex,
    required this.unitProgress,
  });

  factory ListeningProgress.fromFirestore(DocumentSnapshot doc) {
    return ListeningProgress(
      currentIndex: doc['current_index'] ?? 0,
      simpleIndex: doc['simple_index'] ?? 0,
      unitProgress: Map<String, dynamic>.from(doc['unit_progress']),
    );
  }
}
