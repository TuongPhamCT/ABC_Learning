import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingProgressCollection {
  String id;
  String unitId;
  int currentProgress;

  ReadingProgressCollection(
      {this.id = '', required this.unitId, required this.currentProgress});

  Map<String, dynamic> toJson() {
    return {'unitId': unitId, 'currentProgress': currentProgress.toString()};
  }

  factory ReadingProgressCollection.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ReadingProgressCollection(
      id : doc.id,
        unitId: data['unitId'],
        currentProgress: int.parse(data['currentProgress']));
  }

  @override
  String toString() {
    return unitId;
  }
}

class ReadingProgress {
  static const String documentId = 'progress-reading';

  List<ReadingProgressCollection> progresses;
  String userId;

  ReadingProgress({required this.progresses, required this.userId});

  Map<String, dynamic> toJson() {
    return {'progresses': progresses};
  }

  static Future<ReadingProgress> fromFirestore(DocumentSnapshot doc) async {
    ReadingProgressRepo readingProgressRepo = ReadingProgressRepo();
    List<ReadingProgressCollection> progresses =
        await readingProgressRepo.getProgresses();
    return ReadingProgress(userId: doc.id, progresses: progresses);
  }

  @override
  String toString() {
    return userId;
  }
}

class ReadingProgressRepo {
  Future<List<ReadingProgressCollection>> getProgresses() async {
    final CollectionReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance
            .collection(ReadingProgress.documentId)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('progresses');
    QuerySnapshot querySnapshot = await collectionRef.get();

    final progresses = querySnapshot.docs
        .map((doc) => ReadingProgressCollection.fromFirestore(doc))
        .toList();
    return progresses;
  }

  Future<ReadingProgress> getReadingProgressById(String id) async {
    final DocumentReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance
            .collection(ReadingProgress.documentId)
            .doc(id);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await collectionRef.get();

    final readingProgress =
        await ReadingProgress.fromFirestore(documentSnapshot);
    print(readingProgress);
    return readingProgress;
  }

  Future<void> uploadProgressCollection(
      ReadingProgressCollection progress) async {
    FirebaseFirestore.instance
        .collection(ReadingProgress.documentId)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('progresses')
        .doc(progress.id)
        .update(progress.toJson())
        .onError((e, _) => throw Exception('Upload ReadingProgress Failed'));
  }
}
