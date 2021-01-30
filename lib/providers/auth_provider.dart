import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/models/user.dart';

class Auth extends ChangeNotifier {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;

  Auth(
    this._googleSignIn,
    this._firebaseAuth,
    this._firestore,
    this._sharedPreferences,
  );

  WasfatUser wasfatUser;

  bool get isLoggedIn => _sharedPreferences.getBool('authenticated') ?? false;
  String get userId => _firebaseAuth.currentUser?.uid;

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _sharedPreferences.setBool('authenticated', false);
    wasfatUser = null;
    notifyListeners();
  }

  Future<void> getUserData() async {
    if (isLoggedIn) {
      final userSnapshot = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser.uid)
          .get();
      wasfatUser = WasfatUser.fromMap(userSnapshot.data());
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    final userCredential =
        await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
    if (userCredential?.user?.uid != null)
      await _sharedPreferences.setBool('authenticated', true);
    wasfatUser = WasfatUser(
      uid: userCredential.user.uid,
      name: userCredential.user.displayName,
      email: userCredential.user.email,
      phoneNumber: userCredential.user.phoneNumber,
      photoURL: userCredential.user.photoURL,
    );
    notifyListeners();
  }
}
