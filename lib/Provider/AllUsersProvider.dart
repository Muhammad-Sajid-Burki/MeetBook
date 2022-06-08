import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllUsersProvider with ChangeNotifier{

  changeGender(context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    if(userProvider.userModel.gender == 'Male') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gender', 'Female');
      notifyListeners();
    }
    else{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gender', 'Male');
      notifyListeners();
    }
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers(BuildContext context) async  {
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final String? gender = prefs.getString('gender');
    return FirebaseFirestore.instance.collection("user").where("gender", isEqualTo: gender).where("showUser", isEqualTo: "public").get();

  }
  notifyListeners();

}