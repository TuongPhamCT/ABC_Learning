import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingTopic {
  static const String documentId = 'reading';

  String id;
  String topic;
  String img_url;
  int maxQuestions;
  String unitId;

  ReadingTopic(
      {this.id = '',
      required this.topic,
      required this.img_url,
      required this.maxQuestions,
      required this.unitId});

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'img_url': img_url,
      'maxQuestions': maxQuestions.toString(),
      'unitId': unitId
    };
  }

  factory ReadingTopic.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ReadingTopic(
        id: doc.id,
        topic: data['topic'],
        img_url: data['img_url'],
        maxQuestions: int.parse(data['maxQuestions']),
        unitId: data['unitId']);
  }

  @override
  String toString() {
    return topic;
  }
}

class ReadingTopicRepo {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection(ReadingTopic.documentId);

  Future<List<ReadingTopic>> getAllTopic() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final topics = querySnapshot.docs
        .map((doc) => ReadingTopic.fromFirestore(doc))
        .toList();
    print(topics);
    return topics;
  }
}

class ReadingParagraph {
  static const String type = 'paragraph';

  String title;
  String content;
  String img_url;

  ReadingParagraph({
    required this.title,
    required this.img_url,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'img_url': img_url,
      'content': content,
    };
  }

  factory ReadingParagraph.fromFirestore(Map<String, dynamic> doc) {
    return ReadingParagraph(
        title: doc['title'], img_url: doc['img_url'], content: doc['content']);
  }

  @override
  String toString() {
    return title;
  }
}

class ReadingQuestion {
  static const String type = 'question';

  String question;
  String answer;

  ReadingQuestion({
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer};
  }

  factory ReadingQuestion.fromFirestore(Map<String, dynamic> doc) {
    return ReadingQuestion(question: doc['question'], answer: doc['answer']);
  }

  @override
  String toString() {
    return question;
  }
}
