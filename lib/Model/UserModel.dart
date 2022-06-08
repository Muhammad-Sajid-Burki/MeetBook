import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    id = documentSnapshot.id;
    age = documentSnapshot.data()!['age'];
    country = documentSnapshot.data()!['country'];
    email = documentSnapshot.data()!['email'];
    gender = documentSnapshot.data()!['gender'];
    imageUrl = documentSnapshot.data()!['imageUrl'];
    name = documentSnapshot.data()!['name'];
    password = documentSnapshot.data()!['password'];
    phoneNo = documentSnapshot.data()!['phoneNo'];
    showUser = documentSnapshot.data()!['showUser'];
    status = documentSnapshot.data()!['status'];
    isBlocked = documentSnapshot.data()!['isBlocked'];
  }

  String? age;
  String? country;
  String? email;
  String? gender;
  String? imageUrl;
  String? name;
  String? id;
  String? password;
  String? phoneNo;
  String? showUser;
  String? status;
  String? isBlocked;

  UserModel({
    this.age,
    this.country,
    this.email,
    this.gender,
    this.imageUrl,
    this.name,
    this.id,
    this.password,
    this.phoneNo,
    this.showUser,
    this.status,
    this.isBlocked
  });

  DocumentReference get firestoreRef => FirebaseFirestore.instance.doc('user/$id');

  Future<void> saveInfo() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'country': country,
      'email': email,
      'gender': gender,
      'imageUrl': imageUrl,
      'name': name,
      'password': password,
      'phoneNo': phoneNo,
      'showUser': showUser,
      'status': "online",
      'isBlocked': "false",
    };
  }
}