import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement {
  static const String documentId = 'achivement';

  String id;
  String name;
  String description;
  String icon;
  int maxIndex;

  Achievement(
      {this.id = '',
      required this.name,
      required this.description,
      required this.icon,
      required this.maxIndex});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'maxIndex': maxIndex.toString()
    };
  }

  factory Achievement.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Achievement(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        icon: data['icon'],
        maxIndex: int.parse(data['maxIndex']));
  }

  @override
  String toString() {
    return id;
  }
}

class AchievementRepo {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection(Achievement.documentId);

  Future<List<Achievement>> getAllAchievements() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final achievements = querySnapshot.docs
        .map((doc) => Achievement.fromFirestore(doc))
        .toList();
    return achievements;
  }
}
