/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_clinic_for_psychiatry/data/database/FirebaseUitls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  MyUser.User? databaseUser;
  User? authFirebaseUser;

  Future<void> register(
      String fullName, String email, String password) async {
    var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await UserDou.createUser(MyUser.User(
        id: credential.user?.uid,
        fullName: fullName,
        email: email));
  }

  Future<void> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    var user = await UserDou.getUser(credential.user!.uid);
    databaseUser = user;
    authFirebaseUser = credential.user;
    notifyListeners();
  }

  void logout() {
    databaseUser = null;
    FirebaseAuth.instance.signOut();
  }

  bool isUserLoggedInBefore() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> retrieveUserFromDatabase() async {
    authFirebaseUser = FirebaseAuth.instance.currentUser;
    databaseUser = await UserDou.getUser(authFirebaseUser!.uid);
  }
}
*/
