import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String audioUrl;
  String questionName;
  String rightDescription;
  String rightImgUrl;
  List<String> wrongImgUrls;
  String wrongDescription;

  Question({
    required this.audioUrl,
    required this.questionName,
    required this.rightDescription,
    required this.rightImgUrl,
    required this.wrongImgUrls,
    required this.wrongDescription,
  });

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      audioUrl: data['audio_url'],
      questionName: data['question_name'],
      rightDescription: data['right']['description'],
      rightImgUrl: data['right']['img_url'],
      wrongImgUrls: List<String>.from(data['wrong']['img_url']),
      wrongDescription: data['wrong']['description'],
    );
  }
}
