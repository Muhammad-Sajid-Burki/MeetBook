import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {

  UserProvider() {
    loadLoggedUser();
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel userModel = UserModel();

  Future<void> signUp({UserModel? userModel, Function? onFail, Function? onSuccess}) async {

    try {
      final UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(
          email: userModel!.email!, password: userModel.password!);

      userModel.id = authResult.user!.uid;

      await userModel.saveInfo();
      await loadLoggedUser(user: authResult.user);

      onSuccess!();

    } catch (e) {
      onFail!('error with following: $e');
    }
    notifyListeners();

  }

  Future<void> signIn({UserModel? userModel, Function? onFail, Function? onSuccess}) async {

    try {
      final UserCredential authResult = await firebaseAuth
          .signInWithEmailAndPassword(
          email: userModel!.email!, password: userModel.password!);

      await loadLoggedUser(user: authResult.user);

      onSuccess!();

    } catch (e) {
      onFail!('error with following: $e');
    }
    notifyListeners();
  }

  Future<void> loadLoggedUser({User? user}) async {
    final User currentUser = user ?? firebaseAuth.currentUser!;
    if(currentUser != null) {
      final DocumentSnapshot documentSnapshot = await firestore.collection('user')
          .doc(currentUser.uid).get();
      await firestore.collection('user')
          .doc(currentUser.uid).update({'status': "online"});
      userModel = UserModel.fromDocument(documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);

      notifyListeners();
    }

  }

  Future logout() async {
    final currentUser =  firebaseAuth.currentUser!;
    await firestore.collection('user')
        .doc(currentUser.uid).update({'status': "offline"});
    await FirebaseAuth.instance.signOut();

  }
}