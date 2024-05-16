import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  static const String documentId = 'users';

  String uid;
  String address;
  String age;
  String avatar;
  String email;
  String gender;
  String name;
  String phoneNumber;

  MyUser(
      {this.uid = '',
      required this.address,
      required this.age,
      required this.avatar,
      required this.email,
      required this.gender,
      required this.name,
      required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'age': age,
      'avatar': avatar,
      'email': email,
      'gender': gender,
      'name': name,
      'phoneNumber': phoneNumber
    };
  }

  factory MyUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MyUser(
        uid: doc.id,
        address: data['address'],
        age: data['age'],
        avatar: data['avatar'],
        email: data['email'],
        gender: data['gender'],
        name: data['name'],
        phoneNumber: data['phoneNumber']);
  }

  @override
  String toString() {
    return uid;
  }
}

class UserRepo {
  Future<List<MyUser>> getAllUsers() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(MyUser.documentId);
    QuerySnapshot querySnapshot = await collectionRef.get();

    final achievements =
        querySnapshot.docs.map((doc) => MyUser.fromFirestore(doc)).toList();
    return achievements;
  }

  Future<MyUser> getUserById(String id) async {
    final DocumentReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance.collection(MyUser.documentId).doc(id);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await collectionRef.get();
    MyUser user = MyUser.fromFirestore(documentSnapshot);
    print(user);
    return user;
  }
}
