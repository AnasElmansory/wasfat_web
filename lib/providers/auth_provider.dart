import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/models/user.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  WasfatUser? wasfatUser;

  Auth(
    this._firebaseAuth,
    this._firestore,
  );

  Future<bool> isLoggedIn() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getBool('isLoggedIn') ?? false;
  }

  // String get userId => _firebaseAuth.currentUser?.uid;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('isLoggedIn', false);
    wasfatUser = null;
    notifyListeners();
  }

  Future<void> getUserData() async {
    if (await isLoggedIn()) {
      final userSnapshot = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();
      if (userSnapshot.data() != null)
        wasfatUser = WasfatUser.fromMap(userSnapshot.data()!);
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    final shared = await SharedPreferences.getInstance();
    final userCredential =
        await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
    final isUser = userCredential.user != null;
    if (isUser) {
      await shared.setBool('isLoggedIn', true);
      wasfatUser = WasfatUser(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        phoneNumber: userCredential.user!.phoneNumber ?? '',
        photoURL: userCredential.user!.photoURL ?? '',
      );
    }
    notifyListeners();
  }
}
